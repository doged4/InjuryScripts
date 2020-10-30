require("openxlsx")
require("stats")

#cfprank.table <- read.xlsx("/Users/rolandbainton/Desktop/MANCH/02_DEEP_READS_Mnach/Low platelet RANK/WithMockControl_02_DEEP_READS_Manch_CPM_novalues_cutbyCFPrank_pltRanklow.xlsx")
#platelet.table <- read.xlsx("/Users/rolandbainton/Desktop/MANCH/02_DEEP_READS_Mnach/High platelet RANK/02_DEEP_READS_Manch_CPM_novalues_cutbyCFPrank_pltHigh_aveSD>2.xlsx")

#initialize getteing data and fixing colnames
main.data <- main_data
main.data <- data.frame(main.data)

convertGenes <- read.csv("Downloads/CONVERSIONTABLE_GENE STABLE_ENS_GENENAME.csv")

# 
# expList <- colnames(main.data)[substr(colnames(main.data),1,2) == "E_"]
# conList <- colnames(main.data)[substr(colnames(main.data),1,2) == "C_"]
# 
# 
# selected.data <- main.data[,c(
#   "Geneid",
#   "Chr",
#   expList,
#   conList
# )]


selected.data <- main.data[,-6]

#get rid of bad rows by gene name


selected.data <- selected.data[substr(selected.data$Geneid, 1,4) == "ENSG",]
selected.data[6:length(selected.data)] <- lapply(FUN =  strtoi,X =  selected.data[6:length(selected.data)])
selected.data <- selected.data[!is.na(selected.data[6]),]



sumData <- colSums(selected.data[6:length(selected.data)])

norm.data <- data.frame(cbind(
  selected.data[1:5],
  scale(selected.data[6:length(selected.data)],
  center = FALSE,
        scale = sumData)))


selected.data <- norm.data

# FDR stuff was here
out.data <- rbind(c("sums", NA, NA, NA, NA, NA, sumData), selected.data)



out.data$GenesSymbol <- convertGenes$Gene.name[match(x= out.data$Geneid, table = convertGenes$Gene.stable.ID)]

out.data <- cbind("Geneid" = out.data$Geneid, "Gene Name" = out.data$GenesSymbol,"Chr" = out.data$Chr, out.data[,3:(length(out.data)-1)])

write.table(out.data,
            "~/Desktop/out.tsv",
            col.names = TRUE,
            row.names = FALSE,
            sep = "\t")

