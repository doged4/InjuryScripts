# /bin/bash

mkdir ./STAR.Ensembl.Out

for i in $(ls *R2_001.fastq.gz | rev | cut -c 17- | rev | uniq);  do\
    	echo ${i};
   	mkdir ./STAR.Ensembl.Out/${i};
    	cd  ./STAR.Ensembl.Out/${i};
	 ls /injury/MegaFolderB/ovationTestConditions/FASTQ/${i}_R1_001.fastq.gz  
	 ls /injury/MegaFolderB/ovationTestConditions/FASTQ/${i}_R2_001.fastq.gz 



       /STAR/bin/Linux_x86_64/STAR --runMode alignReads --runThreadN 50 --genomeDir /genome/genomes/hg19STARbase   --readFilesIn  /injury/MegaFolderB/ovationTestConditions/FASTQ/${i}_R1_001.fastq.gz   /injury/MegaFolderB/ovationTestConditions/FASTQ/${i}_R2_001.fastq.gz   --outFileNamePrefix /injury/MegaFolderB/ovationTestConditions/FASTQ/STAR.Ensembl.Out/${i}/  --outSAMtype SAM --readFilesCommand zcat;
	cd ..; cd ..;	
#       /STAR/bin/Linux_x86_64/STAR \
	#--runMode alignReads \
	#--runThreadN 50 \
	#--genomeDir /genome/genomes/hg19STARbase \
        #--readFilesIn \
        #      \ /injury/MegaFolderB/ovationTestConditions/FASTQ/${i}_R1_001.fastq.gz   \
	#      \ /injury/MegaFolderB/ovationTestConditions/FASTQ/${i}_R2_001.fastq.gz   \
	#--outFileNamePrefix /injury/MegaFolderB/ovationTestConditions/FASTQ/STAR.Ensembl.Out/${i}/ \
        #--outSAMtype SAM;
#	cd ..; cd ..;	
	done;

cd  ./STAR.Ensembl.Out

	for i in $(ls -d *);  do\
		        echo ${i};
	        cd  ${i};
		 #           featureCounts -T 45 -a /genome/genomes/hg19.gtf -o ${i}.mapped Aligned.out.sam  #first ovation test command
	         	  featureCounts -T 45 -a /genome/Homo_sapiens_AWS/UCSC/hg19/Annotation/Genes/genes.gtf -o ${i}.mapped Aligned.out.sam # based on qucke data run
	  	 #           python3 /injury/scripts2/ucsctoGenename.py ${i}.mapped

			cd ..;
		done;

