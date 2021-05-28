#!/bin/bash

for i in $(ls -d */);  do\
	cd $i;
	samtools view $(ls *.sam) --threads 20  -O BAM -o $(ls *.sam | rev | cut -c 5- | rev).bam
	cd ..;
done;
