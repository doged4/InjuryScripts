# /bin/bash

mkdir ./STAR.Ensembl.Out


#run from folder with all the fastqs, so that the for(ls) works
for i in $(ls *R2_001.fastq.gz | rev | cut -c 17- | rev | uniq);  do\
    	echo ${i};
   	mkdir ./STAR.Ensembl.Out/${i};
    	cd  ./STAR.Ensembl.Out/${i};
	 ls /injury/MegaFolderB/deepReads/200612_K00153_0841_AHNKTMBBXX_PE100_1/FMRB01/FASTQ/${i}_R1_001.fastq.gz  
	 ls /injury/MegaFolderB/deepReads/200612_K00153_0841_AHNKTMBBXX_PE100_1/FMRB01/FASTQ/${i}_R2_001.fastq.gz 



       /STAR/bin/Linux_x86_64/STAR --runMode alignReads --runThreadN 50 --genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38   --readFilesIn  /injury/MegaFolderB/deepReads/200612_K00153_0841_AHNKTMBBXX_PE100_1/FMRB01/FASTQ/${i}_R1_001.fastq.gz   /injury/MegaFolderB/deepReads/200612_K00153_0841_AHNKTMBBXX_PE100_1/FMRB01/FASTQ/${i}_R2_001.fastq.gz   --outFileNamePrefix /injury/MegaFolderB/deepReads/200612_K00153_0841_AHNKTMBBXX_PE100_1/FMRB01/FASTQ/STAR.Ensembl.Out/${i}/  --sjdbGTFfile /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --outSAMtype SAM --readFilesCommand zcat;
	cd ..; cd ..;	
#       /STAR/bin/Linux_x86_64/STAR \
#	--runMode alignReads \
#	--runThreadN 50 \
##	--genomeDir /genome/genomes/hg19STARbase \
#        --genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 \
#        --readFilesIn \
#               /injury/MegaFolderB/TestConditions3_Ensembl/FASTQ/${i}_R1_001.fastq.gz   \
#	       /injury/MegaFolderB/TestConditions3_Ensembl/FASTQ/${i}_R2_001.fastq.gz   \
#	--outFileNamePrefix /injury/MegaFolderB/TestConditions3_Ensembl/FASTQ/STAR.Ensembl.Out/${i}/ \
#        --outSAMtype SAM;
#	cd ..; cd ..;	
	done;

cd  ./STAR.Ensembl.Out

	for i in $(ls -d *);  do\
		        echo ${i};
	        cd  ${i};
#	         	  featureCounts -T 45 -a /genome/Homo_sapiens_AWS/UCSC/hg19/Annotation/Genes/genes.gtf -o ${i}.mapped Aligned.out.sam # based on qucke data run
		            featureCounts -T 45 -a /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf -o ${i}.mapped Aligned.out.sam  #for Ensembl
		 #           featureCounts -T 45 -a /genome/genomes/hg19.gtf -o ${i}.mapped Aligned.out.sam  #first ovation test command
	  	 #           python3 /injury/scripts2/ucsctoGenename.py ${i}.mapped

			cd ..;
		done;

