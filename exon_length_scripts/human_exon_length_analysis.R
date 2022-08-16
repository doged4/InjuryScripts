library(readr)
Exon_coordinates_GRCh38 <- read_delim("Documents/exon_length_analysis/Exon_coordinates_GRCh38.txt", 
                                      delim = "\t", escape_double = FALSE, 
                                      trim_ws = TRUE)

Exons_with_lens <- Exon_coordinates_GRCh38
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
                        geom_histogram(binwidth = 10) + ggtitle("Distribution of modes, filtered human genes")

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








### Simulated statistical significance ----


top_counts <- interesting_gene_table[order(interesting_gene_table[,2],decreasing = TRUE),][1:20,]
sim_holder <- rep(list(c(NA,NA)),1)
top_counts <- cbind(top_counts, t(sim_holder))
colnames(top_counts)[4] <- 'sim_counts'

counts_for_twos <- c()
for (i in 1:1000){
    tsim_ratio <- c()
    for (j in 1:length(interesting_genes[,1])){
      t_exon1 <- sample(Exons_with_lens$length, 1)
      t_exon2 <- sample(Exons_with_lens$length, 1)
      while (t_exon2 == t_exon1) {
        t_exon2 <- sample(Exons_with_lens$length, 1)
      }
      
      tsim_ratio <- c(tsim_ratio, c(t_exon1 / t_exon2))
    }
    tsim_data <- data.frame(mode_ratio = tsim_ratio,
                          log_mode_ratio = log2(tsim_ratio),
                          abs_log_mode_ratio = abs(log2(tsim_ratio)))
  new_count <- tsim_data %>% 
    filter(abs_log_mode_ratio == 1) %>% 
    pull() %>% length()
  
  for (k in 1:length(top_counts[,1])){
    simmed_count <- tsim_data %>%
      filter(abs_log_mode_ratio == top_counts[k,1]) %>%
      pull() %>% length()
    top_counts$sim_counts[[k]] <- c(top_counts$sim_counts[[k]],  simmed_count)
    
  }
  counts_for_twos <- c(counts_for_twos,c(new_count))
}
for (i in length(top_counts$sim_counts)){
  top_counts$sim_counts[[i]] <- na_remover(top_counts$sim_counts[[i]])
}

top_counts$mean_sim <- NA
top_counts$sd_sim <- NA
top_counts$expected_diff_from_sim <- NA
for (i in 1:length(top_counts$sim_counts)){
  top_counts$sim_counts[[i]] <- na_remover(top_counts$sim_counts[[i]])
  top_counts$mean_sim[i] <- mean(top_counts$sim_counts[[i]], na.rm =TRUE)
  top_counts$sd_sim[i] <- sd(top_counts$sim_counts[[i]], na.rm =TRUE)
  top_counts$expected_diff_from_sim[i] <- (top_counts$mean_sim[i] - top_counts$Freq[i])/ top_counts$sd_sim[i]
}




### Output interesting genes with each length ----

# library(xlsx)

library(openxlsx)



doubling_genes <-  interesting_genes %>% filter(abs_log_mode == 1) %>% pull(`Gene name`) %>% unique() %>% sort()
work_book <- createWorkbook()
# front_sheet <- createSheet(work_book, sheetName = "ALL_DOUBLING_GENES") #
addWorksheet(work_book, "ALL_DOUBLING_GENES")
# addDataFrame(interesting_genes %>% filter(`Gene name` %in% doubling_genes), #
#             front_sheet,
#             row.names = FALSE)
writeData(work_book, sheet = "ALL_DOUBLING_GENES", x = interesting_genes %>% filter(`Gene name` %in% doubling_genes),
             rowNames = FALSE)
mode_a_style <- createStyle(bgFill = '#769ee5')
mode_b_style <- createStyle(bgFill = '#b1a8d2')


for (i in 1:length(doubling_genes)){
  this_gene_data <- cast_togene_exon_lengths %>% filter(`Gene name` == doubling_genes[i]) %>% t() %>% data.frame()
  colnames(this_gene_data) <- this_gene_data[2,]
  this_gene_data <- this_gene_data[c(-2,-1),]
  for (j in 1: length(this_gene_data)){
    this_gene_data[,j] <- as.numeric(this_gene_data[,j])
  }
  # this_sheet <- createSheet(work_book, sheetName = doubling_genes[i]) #
  addWorksheet(work_book, doubling_genes[i])
  # addDataFrame(this_gene_data, this_sheet) #
  writeData(wb = work_book, sheet = doubling_genes[i], x =this_gene_data, rowNames = TRUE)
  
  this_mode_a <- interesting_genes %>% filter(abs_log_mode == 1, `Gene name` == doubling_genes[i]) %>% pull(mode_a) %>% .[1]
  this_mode_b <- interesting_genes %>% filter(abs_log_mode == 1, `Gene name` == doubling_genes[i]) %>% pull(mode_b) %>% .[1]
  
  # print(paste0('==', this_mode_a))
  conditionalFormatting(wb = work_book,
                        sheet = doubling_genes[i],
                        cols = 1:length(this_gene_data[1,]),
                        rule = paste0('==', this_mode_a), style = mode_a_style, rows = 1:366
                        )
  conditionalFormatting(wb = work_book,
                        sheet = doubling_genes[i],
                        cols = 1:length(this_gene_data[1,]),
                        rule = paste0("==", this_mode_b), style = mode_b_style, rows = 1:366
  )
}
saveWorkbook(work_book, 'Documents/exon_length_analysis/doubling_genes_by_exon.xlsx', overwrite = TRUE)

