#!/bin/bash

#java -jar /injury/Trimmomatic-0.39/trimmomatic-0.39.jar  PE [-threads <threads] [-phred33 | -phred64] [-trimlog <logFile>] <input 1> <input 2> <paired output 1> <unpaired output 1> <paired output 2> <unpaired output 2> <step 1> ...
java -jar /injury/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 40  input_forward.fastq.gz input_reverse.fastq.gz output_forward_paired.fastq.gz output_forward_unpaired.fastq.gz output_reverse_paired.fastq.gz output_reverse_unpaired.fastq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36




