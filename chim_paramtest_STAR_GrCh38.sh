#!/bin/bash

mkdir ./chimeric_STAR.Ensembl.Out;
thisdir=$(pwd);



#run from folder with all the fastqs, so that the for(ls) works

#for i in $(ls *R2_001.fastq.gz | rev | cut -c 17- | rev | uniq);  do\
filename="./samples.txt"
n=1
/STAR/bin/Linux_x86_64/STAR --runMode alignReads \
	--genomeLoad LoadAndExit \
	--runThreadN 50  \
	--genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 \
	--sjdbGTFfile /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf

while read line
do
	echo "-------------------------------------"
	ID=$(echo $line | awk -F',' '{print $2}')
	echo "ID:"
	echo ${ID};
	R1_path=$(echo $line | awk -F',' '{print $1}')
	R2_path=$(echo $R1_path | sed "s/R1/R2/")

	echo "R1 path: "
	echo $R1_path
	echo "R2 path: "
	echo $R2_path




   	mkdir ./chimeric_STAR.Ensembl.Out/${ID};
    	cd  ./chimeric_STAR.Ensembl.Out/${ID};

	# outputs sorted bams


	#	Parameters taken from DCC circular RNA guidelines, here:
	#	https://github.com/dieterich-lab/DCC


       /STAR/bin/Linux_x86_64/STAR --runMode alignReads --runThreadN 50 --chimOutType Junctions SeparateSAMold \
	      	--outSJfilterOverhangMin 15 15 15 15 \
	     	--alignSJoverhangMin 15 \
	    	--alignSJDBoverhangMin 15 \
		--outFilterMultimapNmax 20 \
		--outFilterScoreMin 1 \
		--outFilterMatchNmin 1 \
		--outFilterMismatchNmax 2 \
       		--chimSegmentMin 15 \
		--chimScoreMin 15 \
		--chimScoreSeparation 10 \
		--chimJunctionOverhangMin 15 \
		--genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38   --readFilesIn  ${R1_path}   ${R2_path}   --outFileNamePrefix $thisdir/chimeric_STAR.Ensembl.Out/${ID}/${ID}_chimeric_.  --sjdbGTFfile /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --outSAMtype BAM Unsorted --readFilesCommand zcat;

       samtools sort -@32 -m 4G -o ${ID}_sorted_chimeric.bam ${ID}_chimeric_.Aligned.out.bam 
       samtools index ${ID}_sorted_chimeric.bam

       samtools view -S -b ${ID}_chimeric_.Chimeric.out.sam > ${ID}_chimeric_.Chimeric.out.bam
       samtools sort -@32 -m 4G -o ${ID}_chimeric_.Chimeric.out.bam ${ID}_chimeric_.Chimeric.aligned.out.bam
       samtools index ${ID}_chimeric_.Chimeric.aligned.out.bam
	cd ..; cd ..;
done < $filename





/STAR/bin/Linux_x86_64/STAR --runMode alignReads \                                
	        --genomeLoad Remove \                                                
	        --runThreadN 50  \                                                        
	        --genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 \
        	--sjdbGTFfile /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf  




cd  ./chimeric_STAR.Ensembl.Out

/home/ysantos/bin/feature_count_from_bam.sh



#		CHANGES TO MAKE:
#
#
#		delete unsorted bam after sorting
#		If possible- As soon as alignment is finished,
#		start sorting AND aligning the next sample.
#
#		ALSO- add 'feature count from bam' at end





