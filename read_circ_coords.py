import pandas as pd
import subprocess
import os

# Relies on bedtools
# Needs to be in same directory as CircCoordinates and CircRNACount
include_superset_dcc = True
filter_mt = True
output_full_csv = False
output_gene_counts = False
remove_bad_bed_lines = True


circ_coords = pd.read_csv('CircCoordinates', delim_whitespace=True,low_memory = False, names =  ["chr", "start", "end", "gene", "JunctionType", "strand", "Start-End Region", "OverallRegion"], index_col=False)
circ_coords = circ_coords.loc[1:]
circ_coords.loc[:,"name"] = circ_coords.loc[:,"gene"] + ":" + circ_coords.loc[:,"JunctionType"] + ":" + circ_coords.loc[:,"Start-End Region"] + ":" +  circ_coords.loc[:,"OverallRegion"]


circ_counts = pd.read_csv('CircRNACount', delim_whitespace=True,low_memory = False)
circ_counts = circ_counts.astype(str)

sample_names = circ_counts.columns[4:len(circ_counts.columns)].to_list()
circ_counts.loc[:,"score"] = ""
for i in range(4,len(circ_counts.columns)-1):
    # print(circ_counts.loc[:,"score"])
    # print(circ_counts.loc[:,"score"] + circ_counts.iloc[:,i] + ";")
    circ_counts.loc[:,"score"] = circ_counts.loc[:,"score"] + circ_counts.iloc[:,i] + ":"


circ_full = circ_coords
circ_full.loc[:,"score"] = circ_counts.loc[:,"score"]

bed_circ_coords = circ_full.loc[:,["chr","start","end","name", "score","strand"]]

bed_circ_coords.to_csv("test_out.bed",index = False,sep="\t")



print("Running bedtools to intersect")
subprocess.call("/usr/bin/bedtools intersect -loj -wa -wb -a test_out.bed -b /home/beccai/testing_regtools/just_genes_Ensembl_GRCh38.100.bed > intersected_gene_annotations.bed", shell = True)

# keep only coding rna genes as option?
#annotated_file = open("bedtools_test_output.txt",'r')
annotated_file = open("intersected_gene_annotations.bed","r")

annotated_circs = dict()
scored_genes = dict()

print("Reading bed intersections")
for line in annotated_file:
    if len(line.split(";")) > 1 :
        name_text = line.split(";")[2]
        type_text = line.split(";")[4]
        # if not name_text[1:10] == "gene_name":
        #     print(name_text)
        assert(name_text[1:10] == "gene_name")
        
        gene = name_text[12:len(name_text)-1]
        genetype = type_text[15:len(type_text)-1]
    else:
        gene = "no_annotated_gene"
        genetype = "protein_coding"

    chrom, start, end = line.split()[:3]
    name = line.split()[3]
    strand = line.split()[5]
    score_text = line.split()[4] # seperates on whitespace
    score = score_text.split(":")[0:-1] # gets rid of trailing _ 
    score = [int(val) for val in score]

    # print((chrom,start,end,name,strand))

    if (chrom,start,end,name,strand) in annotated_circs.keys():
        assert (annotated_circs[(chrom,start,end,name,strand)][0] == score)
        annotated_circs[(chrom,start,end,name,strand)][1] = annotated_circs[(chrom,start,end,name,strand)][1] + ";" + gene # CHANGE SEP TO COMMA?
    else:    
        annotated_circs[(chrom,start,end,name,strand)] = [score, gene]

    if gene in scored_genes.keys():
        new_score = []
        for i in range(0,len(score)):
            new_score += [scored_genes[gene][i] + score[i]]
        scored_genes[gene] = new_score
    else:
        scored_genes[gene] = score


annotated_file.close()

# For all circs, find DCC annotation and add that as well
if include_superset_dcc:
    print("Taking superset with DCC")
    superset_genes_annotated = dict()
    for this_key in annotated_circs.keys():
        this_name = this_key[3]
        this_gene_text = this_name.split(":")[0]
        dcc_genes = this_gene_text.split(',')

        score, bed_genes_text = annotated_circs[this_key]
        bed_genes = bed_genes_text.split(";")
        genes_to_add = []
        for n_gene in dcc_genes:
            if not n_gene in bed_genes:
                genes_to_add += [n_gene]

        superset_genes_annotated[this_key] = [score, bed_genes + genes_to_add]
    
    annotated_circs = superset_genes_annotated

print("Creating outfiles")
gene_circ_frame = pd.DataFrame.from_dict(scored_genes,orient="index", columns = sample_names)



annotated_circ_frame = pd.DataFrame()
start_temp_counts = pd.DataFrame.from_dict(annotated_circs,orient="index")

# This cleans, shouldn't stay here
if remove_bad_bed_lines:
    samples_clean_bools = [len(thiscount) == len(sample_names) for thiscount in start_temp_counts.iloc[:,0]]
    temp_counts = start_temp_counts[samples_clean_bools]
    bad_lines = sum([not sample_bool for sample_bool in samples_clean_bools])
    if not bad_lines == 0:
        print("Lines degraded: " + str(bad_lines) + " lines")

annotated_circ_frame.loc[:,"Chr"] = [tup_ind[0] for tup_ind in temp_counts.index]
annotated_circ_frame.loc[:,"Start"] = [tup_ind[1] for tup_ind in temp_counts.index]
annotated_circ_frame.loc[:,"End"] = [tup_ind[2] for tup_ind in temp_counts.index]
annotated_circ_frame.loc[:,"Name"] = [tup_ind[3] for tup_ind in temp_counts.index]
annotated_circ_frame.loc[:,"Strand"] = [tup_ind[4] for tup_ind in temp_counts.index]




for i in range(0,len(sample_names)):
    annotated_circ_frame.loc[:,sample_names[i]] = [all_counts[i] for all_counts in temp_counts.iloc[:,0]]

annotated_circ_frame.loc[:,"Gene"] =  temp_counts.iloc[:,1].values

annotated_circ_frame = annotated_circ_frame.astype({"Chr" : str, "Start" : int, "End" : int, "Name" : str, "Strand" : str, "Gene" : str})
temp_names = annotated_circ_frame.loc[:,"Name"].str.split(":") # eliminated pat for compatibility with python2
annotated_circ_frame.loc[:,"JunctionType"] = [name[1] for name in temp_names]
annotated_circ_frame.loc[:,"Start-End Region"] = [name[2] for name in temp_names]
annotated_circ_frame.loc[:,"OverallRegion"] = [name[3] for name in temp_names]




# Filters out mitochondrial genes. 
# Make this an option in future
if filter_mt:
    mitochondrial_bools =  [not is_mt for is_mt in annotated_circ_frame.loc[:,"Chr"] == "MT"]
    annotated_circ_frame = annotated_circ_frame[mitochondrial_bools]


if output_full_csv:
    annotated_circ_frame.to_csv("all_CircCoordinates_and_Counts.new", sep = "\t")

if output_gene_counts:
    gene_circ_frame.to_csv("circ_counts_per_gene.txt", sep = "\t")

# Output sample by sample
easy_pipeline_circs = annotated_circ_frame.loc[:,["Chr", "Start", "End", "Strand"] + sample_names + ["Gene"]]
try:
    os.mkdir("annotated_counts")
except:
    print("Directory annotated_counts exits")

print("Writing to ./annotated_counts/")
for this_sample in sample_names:
    current_frame = easy_pipeline_circs.loc[:,["Chr", "Start", "End", "Strand", this_sample, "Gene"]]
    current_frame = current_frame.rename(columns={this_sample : "counts"})
    short_name = this_sample.split("_chimeric")[0]
    current_frame.to_csv("annotated_counts/" + short_name + "_corrected_circ_counts.txt", sep = "\t", index_label= False)




# Remove temp files
# Move justgenes.bed elsewhere
# Decide about outputting extra data
#   need to extract name data to own columns?
# test runtime?