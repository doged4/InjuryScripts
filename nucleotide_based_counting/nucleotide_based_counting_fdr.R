library(readr)
# controls_vs_pentrauma_t_test <- read_delim("Desktop/w/coverage_files/nbc_trauma_statistical_analysis/controls_vs_pentrauma_t_test.txt", 
#                                            delim = "\t", escape_double = FALSE, 
#                                            trim_ws = TRUE)



library(readxl)
controls_vs_pentrauma_t_test_filtered <- read_excel("Downloads/controls_vs_pentrauma_t_test_filtered.xlsx",col_types = c(rep("numeric",23),"text"))
controls_vs_pentrauma_t_test_filtered$...1 <- NULL
colnames(controls_vs_pentrauma_t_test_filtered)[22] <- "bad_mod_pval"
colnames(controls_vs_pentrauma_t_test_filtered)[23] <- "notes"


count_nonzeroes <- function(this_row){
  sum(this_row != 0)
}



nonzeroes_in_row <- apply(X = controls_vs_pentrauma_t_test_filtered[,3:11], FUN = count_nonzeroes, MARGIN = 1)
# At least 5 nonzero values
controls_vs_pentrauma_t_test_super_filter <- controls_vs_pentrauma_t_test_filtered[nonzeroes_in_row >= 5,]
# Fold change of at least 2 (up or down)
controls_vs_pentrauma_t_test_super_filter <- controls_vs_pentrauma_t_test_super_filter[abs(log2(controls_vs_pentrauma_t_test_super_filter$fold_change)) >= 1,]

# Place holder for fdr
controls_vs_pentrauma_t_test_super_filter$bad_mod_pval <- 1
colnames(controls_vs_pentrauma_t_test_super_filter)[22] <- "fdr_adjusted_pval"

# Apply fdr
controls_vs_pentrauma_t_test_super_filter$fdr_adjusted_pval <- p.adjust(controls_vs_pentrauma_t_test_super_filter$pval, method = "fdr")

write_csv2(controls_vs_pentrauma_t_test_super_filter,file = "~/Downloads/controls_vs_pentrauma_fdr_corrected.csv")




