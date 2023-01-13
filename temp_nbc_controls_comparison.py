# import scipy
import glob
import numpy
import pandas
from scipy.stats import ttest_ind


# Load filenames
#controls_list_file = open("controls_list.txt","r")
#controls_list = [name[:-1] for name in controls_list_file.readlines()]
#controls_list_file.close()

#pen_list_file = open("pen_trauma_list.txt","r")
#pen_list = [name[:-1] for name in pen_list_file.readlines()]
#pen_list_file.close()

#blunt_list_file = open("blunt_trauma_list.txt","r")
#blunt_list = [name[:-1] for name in blunt_list_file.readlines()]
#blunt_list_file.close()

normalized_coverage_path = "/genome/extra_space/ysantos/nucleotide_level_counting/nbc_trauma_analysis/counting_activating_conditions_BCD/nbc_coverage/normalized_coverage"
controls_A = glob.glob(normalized_coverage_path + "/controls/*a_S*txt")
controls_B = glob.glob(normalized_coverage_path + "/controls/*b_S*txt")
# controls_C = glob.glob(normalized_coverage_path + "/controls/*c_S*txt")
# controls_D = glob.glob(normalized_coverage_path + "/controls/*d_S*txt")



# Prepare base columns
base_columns = pandas.read_csv("normalized_coverage/" + controls_A[0], sep = "\t", names=["chr","efcab13_start", "efcab13_end","index","count"])
base_columns = base_columns.iloc[:,0:4] # Remove count data from this
base_columns.loc[:,"coordinate"] = base_columns.loc[:,"efcab13_start"] + base_columns.loc[:,"index"]
all_coverage = base_columns




columns_A = []
for this_file_path in controls_A:                                                          
    print(this_file_path)
    this_colname = this_file_path.split("_EFCAB")[0] + "_A"
    this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
    all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]
    columns_A.append(this_colname)    

columns_B = []
for this_file_path in controls_B:                                                          
    print(this_file_path)
    this_colname = this_file_path.split("_EFCAB")[0] + "_B"
    this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
    all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]
    columns_B.append(this_colname)

# columns_C = []
# for this_file in controls_C:                                                          
#     print(this_file)
#     this_colname = this_file.split("_EFCAB")[0] + "_C"
#     this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
#     all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]
#     columns_C.append(this_colname)

# columns_D = []
# for this_file in controls_D:                                                          
#     print(this_file)
#     this_colname = this_file.split("_EFCAB")[0] + "_D"
#     this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
#     all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]
#     columns_D.append(this_colname)







# Take in control data
# for this_file in controls_list:
#      print(this_file)
#      this_colname = this_file.split("_EFCAB")[0] + "_control"
#      this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
#      all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]
# 
# # Take in penetrating trauma data
# for this_file in pen_list:
#     print(this_file)
#     this_colname = this_file.split("_EFCAB")[0] + "_pentrauma"
#     this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
#     all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]
# 
# # Take in penetrating trauma data
# for this_file in blunt_list:
#     print(this_file)
#     this_colname = this_file.split("_EFCAB")[0] + "_blunttrauma"
#     this_coverdata = pandas.read_csv(this_file_path, sep = "\t", names=["chr","efcab13_start", "efcab13_end","index",this_colname])
#     all_coverage.loc[:, this_colname] = this_coverdata.loc[:,this_colname]



# T-test prep

def stat_comparer(grp1, grp2):
    grp1_ave = sum(grp1)/len(grp1)
    grp2_ave = sum(grp2)/len(grp2)
    if grp1_ave != 0:
        fold_change = grp2_ave / grp1_ave
    else:
        fold_change = -1
    stat , pval = ttest_ind(grp1, grp2, equal_var = False)
    return (grp1_ave, grp2_ave, fold_change, stat, pval)

 


# T-test
print("Running t-tests...")
out_stats_AvB = all_coverage.apply(lambda row : stat_comparer(row[columns_A], row[columns_B]), axis=1)
# out_statistics = all_coverage.apply( lambda row : stat_comparer(row[5:10], row[10:16]), axis=1)

all_coverage[['samples_A_ave', 'samples_B_ave', 'fold_change','stat','pval']] = pandas.DataFrame(out_stats_AvB.tolist(), index = all_coverage.index)
# all_coverage[['ctrl_ave', 'pentrauma_ave', 'fold_change','stat','pval']] = pandas.DataFrame(out_statistics.tolist(), index = all_coverage.index)


all_coverage.to_csv("controls_A_vs_B_t_test.txt",sep='\t')
print("Output written to \'controls_A_vs_B_t_test.txt\'")