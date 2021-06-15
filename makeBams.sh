#!/bin/bash

for i in $(ls */*sam | cut -f 1 -d \/);  do\
	cd $i;
	echo $i
	samtools view $(ls *.sam) --threads 20  -O BAM -o $(ls *.sam | rev | cut -c 5- | rev).bam
	cd ..;
done;
