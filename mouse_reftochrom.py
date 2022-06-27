import pandas as pd

mouseFile = open("mouse_refseq_to_chrom.tsv")

ref_chrm = dict()


for line in mouseFile.readlines():
    chrm = line[0:line.find("\t")]
    refseq = line[(line.find("\t")+1):(len(line)-1)]
    # ref_chrm[]
    ref_chrm[refseq] = chrm

# len("NC_000082.7"), 11

mouseFile.close()
# print(ref_chrm)

# chimer_file = open("Test.chimeric.txt")

col_names = ["chr_s", "coord_s", "strand_s", "chr_e", "coord_e", "strand_e", "junctype", "repleft", "repright", "read", "seg_s", "cigar_s", "seg_e", "cigar_e"]


chimer_df = pd.read_csv("Test.chimeric.txt", sep = "\t",    names= col_names)

ref_fun = lambda x : ref_chrm[x]


chimer_df["chr_s"] = chimer_df["chr_s"].apply(ref_fun)
chimer_df["chr_e"] = chimer_df["chr_e"].apply(ref_fun)

print(chimer_df)