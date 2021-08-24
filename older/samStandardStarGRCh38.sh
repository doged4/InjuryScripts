# /bin/bash

mkdir ./STAR.Ensembl.Out;
thisdir=$(pwd);



#run from folder with all the fastqs, so that the for(ls) works

for i in $(ls *R2_001.fastq.gz | rev | cut -c 17- | rev | uniq);  do\
	echo ${i};
   	mkdir ./STAR.Ensembl.Out/${i};
    	cd  ./STAR.Ensembl.Out/${i};

       /STAR/bin/Linux_x86_64/STAR --runMode alignReads --runThreadN 50 --genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38   --readFilesIn  $thisdir/${i}_R1_001.fastq.gz   $thisdir/${i}_R2_001.fastq.gz   --outFileNamePrefix $thisdir/STAR.Ensembl.Out/${i}/${i}.  --sjdbGTFfile /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --outSAMtype SAM --readFilesCommand zcat;
	cd ..; cd ..;
	done;

cd  ./STAR.Ensembl.Out

featureCounts -T 45 -a /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf -o geneCounts.mapped */*Aligned.out.sam  #for Ensembl



#for i in $(ls -d *);  do\
#	echo ${i};
#        cd  ${i};
#	#featureCounts -T 45 -a /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf -o ${i}.mapped Aligned.out.sam  #for Ensembl
# 	featureCounts -T 45 -a /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf -o ${i}.mapped Aligned.out.sam  #for Ensembl
#
#
##        featureCounts -T 45 -a /genome/genomes/hg19.gtf -o ${i}.mapped Aligned.out.sam  #first ovation test command
##  	 featureCounts -T 45 -a /genome/Homo_sapiens_AWS/UCSC/hg19/Annotation/Genes/genes.gtf -o ${i}.mapped Aligned.out.sam # based on qucke data run
##        python3 /injury/scripts2/ucsctoGenename.py ${i}.mapped
#	cd ..;
#	done;

/injury/scripts2/moveSJouts.sh
