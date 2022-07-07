library("Ularcirc")
sample3a_chimerics <- loadSTAR_chimeric(filename = "/Volumes/Samsara/injury/MegaFolderB/purified_platelets_deepseq/chimeric_alignment/STAR.Ensembl.Out/3a_S67_L004/3a_S67_L004_chimeric_.Chimeric.out.junction",returnColIdx = 1:14)
# filtered_3a <- Ularcirc::FilterChimericJuncs(sample3a_achimerics$data_set)
Ularcirc::Fil

SelectUniqueJunctions(filtered_3a)
library(readr)
X3a_S67_L004_chimeric_SJ_out <- read_delim("/Volumes/Samsara/injury/MegaFolderB/purified_platelets_deepseq/chimeric_alignment/STAR.Ensembl.Out/3a_S67_L004/3a_S67_L004_chimeric_.SJ.out.tab", 
                                           delim = "\t", escape_double = FALSE, 
                                           trim_ws = TRUE)
Ularcirc::SelectUniqueJunctions(BSJ_junctions = filtered_3a, FSJ_Junctions = X3a_S67_L004_chimeric_SJ_out)

# use below
out_juncs <- FilterChimeric_Ularcirc(sample3a_achimerics$data_set)$SummaryData

FilterChimeric_Ularcirc(canonicalJuncs = )



out_juncs <- FilterChimeric_Ularcirc(sample3a_achimerics$data_set, chromFilter = TRUE, strandFilter = TRUE, summaryNumber = 10000, chrM_Filter = TRUE)$SummaryData
# must be on same chormosome
# must be on same strand
# top 10000 junctions
# must not be mitochondrial?