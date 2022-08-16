library(readr)

mouse_Exons_with_lens <-  read_delim("Documents/exon_length_analysis/mouse_exon_coordinates.txt", 
                                       delim = "\t", escape_double = FALSE, 
                                       trim_ws = TRUE)

Exons_with_lens <- mouse_Exons_with_lens
rm(Exon_coordinates_GRCh38)

Exons_with_lens$length <- abs(Exons_with_lens$`Exon region start (bp)` - Exons_with_lens$`Exon region end (bp)` ) +1 # Signpost error?

# write.csv(Exons_with_lens, "Downloads/Exon_coordinates_with_lens_GRCh38.txt", sep = '\t', quote = FALSE)





library(dplyr)
library(reshape2)
cast_togene_exon_lengths <- Exons_with_lens %>% select(`Gene name`, `Transcript stable ID`, `Exon rank in transcript`, `length`) %>%
  dcast(data = ., `Gene name` + `Transcript stable ID` ~ `Exon rank in transcript` ,fun.aggregate =   mean)



### Functions to analyze a gene ----
mode_stats <- function(in_vec, df_out = FALSE){
  tabbed <- tabulate(in_vec)
  mode_a <- which.max(tabbed)
  count_a <- tabbed[mode_a]
  
  tabbed[mode_a] <- 0
  mode_b <- which.max(tabbed)
  count_b <- tabbed[mode_b]
  if(count_b == 0){
    mode_b <- NA
    count_b <- NA
  }
  # returns first mode if there is a tie!!
  if(df_out){
    data.frame('mode' = c(mode_a, mode_b), 'count' = c(count_a, count_b), row.names = c('a','b'))
  } else{
    c(mode_a,mode_b,count_a,count_b)
  }
  
}

sd_no_na <- function(in_vec){
  sd(in_vec, na.rm = TRUE)
}

mean_no_na <- function(in_vec){
  mean(in_vec, na.rm = TRUE)
}

count_exons <- function(in_vec){
  sum(!is.na(in_vec))
}

na_remover <- function(in_vec){
  in_vec[!is.na(in_vec)]
}


### Backup exon length data ----

backup_lengths <- cast_togene_exon_lengths %>% transmute(`Gene name`, `Transcript stable ID`, backup_data = apply(cast_togene_exon_lengths[,c(-1,-2)],1,na_remover))

### Making table with analysis ----

modes <- data.frame(t(apply(cast_togene_exon_lengths[,c(-1,-2)],1,mode_stats)))
colnames(modes) <- c('mode_a', 'mode_b', 'count_a', 'count_b')

mean_col <- apply(cast_togene_exon_lengths[,c(-1,-2)],1,mean_no_na)

sd_col <- apply(cast_togene_exon_lengths[,c(-1,-2)],1,sd_no_na)

num_exons <- apply(cast_togene_exon_lengths[,c(-1,-2)],1,count_exons)


gene_statistics <- cast_togene_exon_lengths %>% 
  transmute(`Gene name` = `Gene name`, 
            `Transcript stable ID` = `Transcript stable ID`, 
            `exon_total` = num_exons, `means` = mean_col,`sds` = sd_col) %>%
  cbind(modes)

rm(modes, num_exons, sd_col, mean_col)

gene_statistics <- gene_statistics %>%  
  mutate(mode_ratio = `mode_a` / `mode_b`,
         log_mode_ratio = log2(`mode_a` / `mode_b`),
         abs_log_mode = abs(log2(`mode_a` / `mode_b`)),
         total_modes_fraction = (count_a + count_b)/exon_total)

# write.csv(gene_statistics, "Downloads/Exon_means_and_modes.txt", quote = FALSE)

#### Filtering gene analysis ----

gene_statistics_multiexons <- gene_statistics %>%
  filter(!is.na(`mode_b`)) %>%
  filter(`count_a` != 1)

interesting_genes <- gene_statistics_multiexons %>% filter(`count_a` >= 3) %>%
  filter(`count_b` >= 2)


gene_statistics_multiexons %>% 
  ggplot(aes(x=log_mode_ratio)) +
  geom_histogram(bins = 80) + ggtitle("Log mode ratio on genes with no nas") + xlab("Log2 (mode_a / mode_b)")

# write.csv(interesting_genes, "Downloads/interesting_exon_ratios.txt")








# 
# library(infer)
# Exons_with_lens %>% 
#   specify(mode_a ~ mode_b) %>%
#   generate(reps = 1000, type = permute) %>%
#   

#### Simulated mode log ratios ------
sim_ratio  <-  c() 
for (i in 1:10000){
  t_exon1 <- sample(Exons_with_lens$length, 1)
  t_exon2 <- sample(Exons_with_lens$length, 1)
  while (t_exon2 == t_exon1) {
    t_exon2 <- sample(Exons_with_lens$length, 1)
  }
  
  sim_ratio <- c(sim_ratio, c(t_exon1 / t_exon2))
}
sim_data <- data.frame(mode_ratio = sim_ratio, log_mode_ratio = log2(sim_ratio), abs_log_mode = abs(log2(sim_ratio)))

#### Visualizing exon lengths ------

# Exon lengths, all genes all transcripts
Exons_with_lens %>% ggplot(aes(x=length)) + geom_histogram(bins = 50) + xlim(c(0,500)) + xlab("exon length") + ggtitle("Exon length across whole genome")
Exons_with_lens %>% summarise(`mean exon length` = mean(length), 
                              `median exon length` = median(length), 
                              `first quartile` = quantile(length)[2], 
                              `third quartile` = quantile(length)[4],
                              `mode exon length` = which.max(tabulate(length)))

# Exons_with_lens %>% ggplot(aes(x=length)) + geom_boxplot() + xlim(c(0,1000))

# Gene modes distribution

interesting_genes %>% ggplot(aes(x=mode_a)) +
  geom_histogram(binwidth = 10) + ggtitle("Distribution of modes, filtered mouse genes")

interesting_genes %>% summarise(`mean exon length` = mean(mode_a), 
                                `median exon length` = median(mode_a), 
                                `first quartile` = quantile(mode_a)[2], 
                                `third quartile` = quantile(mode_a)[4],
                                `mode exon length` = which.max(tabulate(mode_a)))


# Log mode ratios at width 0.1
sim_data %>% ggplot(aes(x=log_mode_ratio)) + geom_histogram(binwidth = .1) + ggtitle("Simulated log mode ratios")

interesting_genes %>% ggplot(aes(x=log_mode_ratio)) + geom_histogram(binwidth = .1) + ggtitle("Filtered log mode ratios")

# Absolute log mode ratios 0.1
sim_data %>% ggplot(aes(x=abs_log_mode)) + geom_histogram(binwidth = .1) + ggtitle("Simulated absolute log mode ratios") + xlim(c(0,5))

interesting_genes %>% ggplot(aes(x=abs_log_mode)) + geom_histogram(binwidth = .1) + ggtitle("Filtered absolute log mode ratios") + xlim(c(0,5))

# Absolute log mode ratios 0.01
sim_data %>% ggplot(aes(x=abs_log_mode)) + geom_histogram(binwidth = .01) + ggtitle("Simulated absolute log mode ratios") + xlim(c(0,5))

interesting_genes %>% ggplot(aes(x=abs_log_mode)) + geom_histogram(binwidth = .01) + ggtitle("Filtered absolute log mode ratios") + xlim(c(0,5))


# View(interesting_genes$abs_log_mode %>% table() %>% data.frame() %>% mutate(change = 2**`.`))
interesting_gene_table <-  interesting_genes$abs_log_mode %>% table() %>% data.frame()
colnames(interesting_gene_table)[1] <- 'abs_log_mode'
interesting_gene_table <- interesting_gene_table %>% mutate(fold_change = 2**as.numeric(as.character(abs_log_mode)))

# 
# mouse_Exons_with_lens$length <- abs(mouse_Exons_with_lens$`Exon region start (bp)` - mouse_Exons_with_lens$`Exon region end (bp)` ) +1
# # Signpost error?
# 
# write.csv(mouse_Exons_with_lens, "Downloads/Exon_coordinates_with_lens_GRCh38.txt", sep = '\t', quote = FALSE)
# 
# 
# library(reshape2)
# 
# # test_long <- reshape2::dcast(mouse_Exons_with_lens, formula = `Gene name` ~ `Exon rank in transcript`, fun.aggregate = )
# # test_longer <- reshape2::dcast(mouse_Exons_with_lens, formula = `Gene name` ~ `Exon rank in transcript`, fun.aggregate = paste0)
# 
# library(dplyr)
# # means applying correctly?
# # test <- mouse_Exons_with_lens %>% select(`Gene name`, `Exon rank in transcript`, `length`) %>%
# # dcast(data = ., `Gene name` ~ `Exon rank in transcript`,fun.aggregate =   mean)
# 
# 
# mouse_test_no_collisions <- mouse_Exons_with_lens %>% select(`Gene name`, `Transcript stable ID`, `Exon rank in transcript`, `length`) %>%
#   dcast(data = ., `Gene name` + `Transcript stable ID` ~ `Exon rank in transcript` ,fun.aggregate =   mean)
# 
# just_lengths <- mouse_test_no_collisions %>% select(2: length(colnames(mouse_test_no_collisions)))
# just_means <- rowMeans(just_lengths, na.rm = TRUE)
# library(matrixStats)
# just_sds <- rowSds(as.matrix(just_lengths), na.rm = TRUE)
# # just_tabulation <-  tabulate(as.matrix(just_lengths))
# 
# 
# mouse_mean_exon_lens <- cbind(mouse_test_no_collisions$`Gene name`,just_means, just_sds)
# colnames(mouse_mean_exon_lens)[1] <- "Gene"
# 
# write.csv(mouse_mean_exon_lens, "Downloads/mouse_Exon_mean_lens.txt", quote = FALSE)
# 
# 
# mode_stats <- function(in_vec, df_out = FALSE){
#   tabbed <- tabulate(in_vec)
#   mode_a <- which.max(tabbed)
#   count_a <- tabbed[mode_a]
#   
#   tabbed[mode_a] <- 0
#   mode_b <- which.max(tabbed)
#   count_b <- tabbed[mode_b]
#   if(count_b == 0){
#     mode_b <- NA
#     count_b <- NA
#   }
#   # returns first mode if there is a tie
#   if(df_out){
#     data.frame('mode' = c(mode_a, mode_b), 'count' = c(count_a, count_b), row.names = c('a','b'))
#   } else{
#     c(mode_a,mode_b,count_a,count_b)
#   }
#   
# }
# 
# sd_no_na <- function(in_vec){
#   sd(in_vec, na.rm = TRUE)
# }
# 
# mean_no_na <- function(in_vec){
#   mean(in_vec, na.rm = TRUE)
# }
# 
# count_exons <- function(in_vec){
#   sum(!is.na(in_vec))
# }
# 
# na_remover <- function(in_vec){
#   in_vec[!is.na(in_vec)]
# }
# 
# 
# # mouse_test_no_collisions %>% transmute(`Gene name` = `Gene name`, `Transcript stable ID` = `Transcript stable ID`,
# # `data` = as.matrix(mouse_test_no_collisions[,3:length(mouse_test_no_collisions)]))
# 
# # efcab_testing <- mouse_test_no_collisions %>% filter(`Gene name` == 'EFCAB13')
# 
# 
# # modes <- data.frame(t(apply(efcab_testing[,c(-1,-2)],1,mode_stats)))
# # colnames(modes) <- c('mode_a', 'mode_b', 'count_a', 'count_b')
# # 
# # mean_col <- apply(efcab_testing[,c(-1,-2)],1,mean_no_na)
# # 
# # sd_col <- apply(efcab_testing[,c(-1,-2)],1,sd_no_na)
# # 
# # 
# # efcab_output <- efcab_testing %>% transmute(`Gene name` = `Gene name`, `Transcript stable ID` = `Transcript stable ID`,
# #                                  `means` = mean_col,`sds` = sd_col)
# # efcab_output <- cbind(efcab_output, modes)
# # 
# 
# 
# mouse_backup_lengths <- mouse_test_no_collisions %>% transmute(`Gene name`, `Transcript stable ID`, backup_data = apply(mouse_test_no_collisions[,c(-1,-2)],1,na_remover))
# 
# 
# mouse_modes <- data.frame(t(apply(mouse_test_no_collisions[,c(-1,-2)],1,mode_stats)))
# colnames(mouse_modes) <- c('mode_a', 'mode_b', 'count_a', 'count_b')
# 
# mouse_mean_col <- apply(mouse_test_no_collisions[,c(-1,-2)],1,mean_no_na)
# 
# mouse_sd_col <- apply(mouse_test_no_collisions[,c(-1,-2)],1,sd_no_na)
# 
# mouse_num_exons <- apply(mouse_test_no_collisions[,c(-1,-2)],1,count_exons)
# 
# 
# mouse_exons_all_output <- mouse_test_no_collisions %>% transmute(`Gene name` = `Gene name`, `Transcript stable ID` = `Transcript stable ID`,
#                                                      `exon_total` = mouse_num_exons,
#                                                      `means` = mouse_mean_col,`sds` = mouse_sd_col)
# mouse_exons_all_output <- cbind(mouse_exons_all_output, mouse_modes)
# 
# rm(mouse_modes, mouse_num_exons, mouse_sd_col, mouse_mean_col)
# 
# write.csv(mouse_exons_all_output, "Downloads/mouse_Exon_means_and_modes.txt", quote = FALSE)
# 
# # rm(just_lengths, )
# 
# mouse_many_count_exons <- mouse_exons_all_output %>%
#   filter(!is.na(`mode_b`)) %>%
#   filter(`count_a` != 1)
# 
# 
# mouse_many_count_exons <- mouse_many_count_exons %>% mutate(mode_ratio = `mode_a` / `mode_b`, log_mode_ratio = log2(`mode_a` / `mode_b`))
# mouse_many_count_exons <- mouse_many_count_exons %>% mutate(total_modes_fraction = (count_a + count_b)/exon_total)
# mouse_many_count_exons %>% ggplot(aes(x=log_mode_ratio)) +
#   geom_histogram(bins = 80)
# 
# mouse_interesting_genes <- mouse_many_count_exons %>% filter(`count_a` >= 3) %>%
#   filter(`count_b` >= 2)
# write.csv(mouse_interesting_genes, "Downloads/mouse_interesting_exon_ratios.txt")
