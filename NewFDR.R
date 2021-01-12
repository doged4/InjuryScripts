# Takes Geneid, Chr, columns beginning with E_ and columns beginning with C_
# Does normalization, then pvalues, fdr, then translates gene names via conversion table

require("openxlsx")
require("stats")

#cfprank.table <- read.xlsx("/Users/rolandbainton/Desktop/MANCH/02_DEEP_READS_Mnach/Low platelet RANK/WithMockControl_02_DEEP_READS_Manch_CPM_novalues_cutbyCFPrank_pltRanklow.xlsx")
#platelet.table <- read.xlsx("/Users/rolandbainton/Desktop/MANCH/02_DEEP_READS_Mnach/High platelet RANK/02_DEEP_READS_Manch_CPM_novalues_cutbyCFPrank_pltHigh_aveSD>2.xlsx")

#initialize getteing data and fixing colnames
main.data <- main_data
main.data <- data.frame(main.data)

convertGenes <- read.csv("Downloads/CONVERSIONTABLE_GENE STABLE_ENS_GENENAME.csv")


expList <- colnames(main.data)[substr(colnames(main.data),1,2) == "E_"]
conList <- colnames(main.data)[substr(colnames(main.data),1,2) == "C_"]


selected.data <- main.data[,c(
  "Geneid",
  "Chr",
  expList,
  conList
)]

#get rid of bad rows by gene name
selected.data <- selected.data[substr(selected.data$Geneid, 1,4) == "ENSG",]
selected.data[3:length(selected.data)] <- lapply(FUN =  strtoi,X =  selected.data[3:length(selected.data)])
selected.data <- selected.data[!is.na(selected.data[3]),]



sumData <- colSums(selected.data[3:length(selected.data)])

norm.data <- data.frame(cbind(
    "Geneid" = selected.data$Geneid,
    "Chr" = selected.data$Chr,
      center = FALSE,
    scale(selected.data[3:length(selected.data)],
      scale = sumData)))


selected.data <- norm.data



selected.data$t_stat <- NA # t statistics
selected.data$p <- NA # p value
selected.data$mean_diff <- NA # difference in means
selected.data$ci_lower <- NA # lower bound of CI
selected.data$ci_upper <- NA # upper bound of CI


for (i in 1:nrow(selected.data)) {
  experimentals = as.numeric(selected.data[i,
                                           expList])
  controls = as.numeric(selected.data[i,
                                      conList])
  test <- tryCatch({
    t.test(controls, experimentals, paired = FALSE, alternative = "two.sided") #changed to false
  }, warning = function(w) {
  }, error = function(e) {
    list(statistic = NA, 
         p.value = NA, 
         conf.int = c(NA,NA),
         estimate = c(mean(experimentals),mean(controls)))
  }, finally = {
  })
  
  # test2 <- t.test(controls, experimentals, paired = FALSE, alternative = "two.sided") #changed to false
  selected.data$t_stat   [i] <- test$statistic
  selected.data$p        [i] <- test$p.value
  selected.data$mean_diff[i] <- test$estimate[1] - test$estimate[2] #changed to subtract means!!
  selected.data$ci_lower [i] <- test$conf.int[1]
  selected.data$ci_upper [i] <- test$conf.int[2]
  selected.data$e_mean   [i] <- test$estimate[1]
  selected.data$c_mean   [i] <- test$estimate[2]
  
  rm(test)
}
selected.data$p_adjusted <- p.adjust(selected.data$p, method = "fdr")


out.data <- rbind(c("sums", NA, sumData, NA, NA, NA, NA, NA, NA), selected.data)



out.data$GenesSymbol <- convertGenes$Gene.name[match(x= out.data$Geneid, table = convertGenes$Gene.stable.ID)]

out.data <- cbind("Geneid" = out.data$Geneid, "Gene Name" = out.data$GenesSymbol,"Chr" = out.data$Chr, out.data[,3:(length(out.data)-1)])

write.table(out.data,
            "~/Desktop/out.tsv",
            col.names = TRUE,
            row.names = FALSE,
            sep = "\t")

