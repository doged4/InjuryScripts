import pandas as pd
import math

# Todo
# -- Fix inputting sj outs --- Fixed as was taking in wrong sj outs column as count, and was taking in wrong side as start
# -- fix clr_counts --- Fixed by converting backsplice from series to df, then pivoting
# output to csv
# fix checking both strands because of DCC
# do across many samples

# Notes
# 47361378
# line 37239 is our 10-14 circular in circrnacount
# what is 47361378 in CircRNACount and IGV is 47361377 in SJ.out.tab, the start of EFCAB13 exon 10


circ_counts = pd.read_csv('CircRNACount', sep = "\t", low_memory=False)



def make_fsj_dict(sj_file, which_c):
    fsj_table = dict()
    assert which_c ==  "start" or which_c == "end"

    if which_c == "start":
        column_coord = 1
        jnc_offset = -1
    elif which_c == "end":
        column_coord = 2
        jnc_offset = 1
    for i in range(len(sj_file)):
        coord = (str(sj_file.iloc[i, 0]), sj_file.iloc[i, column_coord] + jnc_offset)
        if coord in fsj_table:
            fsj_table[coord] += int(sj_file.iloc[i, 6]) # 7th column so index 6!!!!!!!!!!
        else:
            fsj_table[coord] =  int(sj_file.iloc[i, 6]) # 7th column so index 6!!!!!!!!!!
    return fsj_table



# in sjout.tab, cols     chr, base1, base2, strand, intron_motif, uniquely_mapped, multimapped, maximum_splice_over
def get_fsj (chrom, start_c, end_c, start_fsj, end_fsj):
    ''' Gets total number of forward splice junctions from front and back, divided by 2. 
        Start will search the fsj start, ends searches the fsj end.
        Call make_fsj_dict first
    '''
    starts = 0
    if (chrom, start_c) in start_fsj:
        starts = start_fsj[(chrom, start_c)]

    ends = 0
    if (chrom, end_c) in end_fsj:
        ends = end_fsj[(chrom, end_c)]

    # Direction UNSPECIFIC due to DCC being weird. May accidentally double count
    if (chrom, end_c) in start_fsj:
        starts += start_fsj[(chrom, end_c)]
    if (chrom, start_c) in end_fsj:
        ends += end_fsj[(chrom, start_c)]

    fsj_tot = starts + ends
    #start
    # for i in range(len(sj_file)):
    #     row =  sj_file.loc[i]
    #     if row["chr"] == chrom:
    #         # if backsplice goes 14 --> 10, then check if 14 is a base1 and 10 is a base2
    #         if row["base1"] == start_c or row["base2"] == end_c:
    #             # only using unique mapped reads
    #             fsj_tot +=  row["uniquely_mapped"]
    return (fsj_tot/2)




# for sample in all_samples:

# change intaking later
sj_head = ["chr", "base1", "base2", "strand", "intron_motif", "annotated","uniquely_mapped", "multimapped", "maximum_splice_over"]


def get_clrs(sample):
    '''Given the full chimeric junction filename as an argument, loads circular and linear read tables and returns clr table for the sample.
    Relies on DCC CircRNACount (one column) and [sample]SJ.out.tab in same directory.
    Applies filter of more than 1 circular form at junction to calculate.
    '''
    sj_filename = sample[:(len(sample)-21)] + "SJ.out.tab"
    sj_outs = pd.read_csv(sj_filename, sep = "\t", names= sj_head, low_memory=False)

    start_dict_fsj = make_fsj_dict(sj_outs, "start")
    end_dict_fsj = make_fsj_dict(sj_outs, "end")
    
    clr_sample_table = pd.DataFrame(columns = ["Chr", "Start", "End", "Strand", sample])
   
    progress = 0
    for i in range(len(circ_counts)):
        backsplice = circ_counts.loc[i]
        if backsplice.loc[sample] > 1:
        # Below is FINE, note that start and end switched though
            linears = get_fsj(backsplice["Chr"], backsplice["End"], backsplice["Start"], start_dict_fsj, end_dict_fsj)
            ratio = 0
            if not linears == 0:
                ratio = backsplice[ sample] / linears
            else:
                ratio = math.inf
            clr_row = backsplice.loc[["Chr", "Start", "End", "Strand"]].to_frame().T
            clr_row[sample] = ratio
            
            clr_sample_table = pd.concat([clr_sample_table , clr_row])
        # print(i)
        frac = math.floor(i / len(circ_counts) * 10)
        if frac > progress:
            progress = frac
            print(str(progress * 10) + "%")

    print("-- Done --")
    clr_sample_table = clr_sample_table.astype({'Start':'int64','End':'int64')
    return (clr_sample_table)



def get_linears_from_bsj(sample):
    '''Given the full chimeric junction filename as an argument, loads circular and linear read tables and returns linear read corresponding to each circular site (back splice junction) table for the sample.
    Relies on DCC CircRNACount (one column) and [sample]SJ.out.tab in same directory.
    Applies filter of more than 1 circular form at junction to calculate.
    '''
    # sj_filename = sample[:(len(sample)-21)] + "SJ.out.tab"
    sj_filename =sample[:len(sample)-32] + "/" + sample[:(len(sample)-21)] + "SJ.out.tab"
    sj_outs = pd.read_csv(sj_filename, sep = "\t", names= sj_head, low_memory=False)

    start_dict_fsj = make_fsj_dict(sj_outs, "start")
    end_dict_fsj = make_fsj_dict(sj_outs, "end")
    
    linears_sample_table = pd.DataFrame(columns = ["Chr", "Start", "End", "Strand", sample])
   
    progress = 0
    for i in range(len(circ_counts)):
        backsplice = circ_counts.loc[i] # doesn't actually use circular counts
        if backsplice.loc[sample] > 1:
        # Below is FINE, note that start and end switched though
            linears = get_fsj(backsplice["Chr"], backsplice["End"], backsplice["Start"], start_dict_fsj, end_dict_fsj)
            # ratio = 0
            # if not linears == 0:
                # ratio = backsplice[ sample] / linears
            # else:
                # ratio = math.inf
            linear_in_row = backsplice.loc[["Chr", "Start", "End", "Strand"]].to_frame().T
            linear_in_row[sample] = linears

            linears_sample_table = pd.concat([linears_sample_table , linear_in_row])
        # print(i)
        frac = math.floor(i / len(circ_counts) * 10)
        if frac > progress:
            progress = frac
            print(str(progress * 10) + "%")
    print("-- Done --")
    linears_sample_table = linears_sample_table.astype({'Start':'int64','End':'int64')
    return (linears_sample_table)


# sample1 = "1a_S65_L004_chimeric_.Chimeric.out.junction"
# clr_1a = get_clrs(sample1)

# backsplice = circ_counts.loc[37239]
# linears = get_fsj(backsplice["Chr"], backsplice["End"], backsplice["Start"], start_dict_fsj, end_dict_fsj)
# ratio = 0
# if not linears == 0:
#     ratio = backsplice[ sample] / linears
# else:
#     ratio = math.inf
# clr_row = backsplice.loc[["Chr", "Start", "End", "Strand"]].to_frame().T
# clr_row[sample] = ratio

main_table = pd.DataFrame(columns=circ_counts.columns[:4])

for sample_name in circ_counts.columns[4:]:
    print(sample_name)
    current_linear_table = get_linears_from_bsj(sample_name)
    table_1 = main_table
    main_table = table_1.merge(current_linear_table, how = "outer", on = ["Chr", "Start", "End", "Strand"]) 

main_table.to_csv("linears_of_each_circular.txt", sep="\t")
