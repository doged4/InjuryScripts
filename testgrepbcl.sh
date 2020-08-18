#!/bin/bash


for i in $(grep -o -G "^[[:digit:]]*,.*$" ../*.csv | cut -f 6 -d ,);

	#do grep -B 1  $i  Undetermined_S0_R1_001.fastq >> test2.txt
	do echo $i; 
	grep -G -A 3 :${i} fastqs_out/Undetermined_S0_R1_001.fastq > fastqs_out/${i}_R1.txt;
	grep -G -A 3 :${i}  fastqs_out/Undetermined_S0_R2_001.fastq > fastqs_out/${i}_R2.txt;
#	cat fastqs_out/$(grep -G $i ../*.csv | cut -f 2 -d ,)*_R1_001.fastq > fastqs_out/$(grep -G $i ../*.csv | cut -f 2 -d ,)_R1_001.fastq;
#	cat fastqs_out/$(grep -G $i ../*.csv | cut -f 2 -d ,)*_R2_001.fastq > fastqs_out/$(grep -G $i ../*.csv | cut -f 2 -d ,)_R2_001.fastq;
	grep -G -v "^--" fastqs_out/${i}_R1.txt >> fastqs_out/$(grep -G $i ../*.csv | cut -f 2 -d ,)_R1_001.fastq;
	grep -G -v "^--" fastqs_out/${i}_R2.txt >> fastqs_out/$(grep -G $i ../*.csv | cut -f 2 -d ,)_R2_001.fastq;
done;

