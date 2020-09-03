# /bin/bash

for i in $(*R2_001.fastq.gz | rev | cut -c 13- | rev | uniq);  do\
    	echo ${i};
   	mkdir ./STAR.Placeholder.Out/${i};
    	cd  ./STAR.Placeholder.Out/${i};
    	/STAR/bin/Linux_x86_64/STAR \
		--runMode alignReads\
	  	--runThreadN 50\
	  	--genomeDir /injury/GRCh38_ensembl/Homo_sapiens.GRCh38.dna_rm.nowIndexed.STR\
	 	--readFilesIn \
			/injury/FiteredRuebenFastqs/02a.filtered_fastq/${i}_R1.fastq.gz \
			/injury/FiteredRuebenFastqs/02a.filtered_fastq/${i}_R2.fastq.gz\
		--outFileNamePrefix /injury/STAR.Ensembl.Out/${i}/ \
	   	--outSAMtype SAM \
		--readFilesInCommand gunzip - 
	done;
