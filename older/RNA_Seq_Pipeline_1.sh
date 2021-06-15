!# /bin/bash

#This is the start of the RNA_seq Script

for i in $(ls *R2_001.fastq.gz | rev | cut -c 17- | rev | uniq);  do

echo ${i};

mkdir /injury/MegaFolderB/TestConditions1_FM_121719/STAR.TestConditions1.out/${i}.dir;

cd  /injury/MegaFolderB/TestConditions1_FM_121719/STAR.TestConditions1.out/${i}.dir;

#Call trimmomatic here

#? Call Quality filtering

#? Remove Duplicate Reads?

#Align to ERCC and only allow unaligned reads forward
	#featureCounts ERCC alignemnet .bam file

#Align remaining reads to hg19

STAR --runMode alignReads --runThreadN 50 --runDirPerm All_RWX --genomeDir /genome/genomes/hg19STARbase --readFilesIn /injury/MegaFolderB/TestConditions1_FM_121719/${i}_R1_001.fastq.gz /injury/MegaFolderB/TestConditions1_FM_121719/${i}_R2_001.fastq.gz --readFilesCommand zcat --outFileNamePrefix /injury/MegaFolderB/TestConditions1_FM_121719/STAR.TestConditions1.out/${i};

featureCounts -T 45 -a /genome/genomes/hg19.gtf -o /injury/MegaFolderB/TestConditions1_FM_121719/STAR.TestConditions1.out/${i}dir/${i}.mapped /injury/MegaFolderB/TestConditions1_FM_121719/STAR.TestConditions1.out/${i}dir/Aligned.out.sam;

done
