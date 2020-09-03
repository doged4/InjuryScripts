# /bin/bash

mkdir ./STAR.Ensembl.Out
/injury/MegaFolderB/working_platelets/Nassa=$(pwd)



#run from folder with all the fastqs, so that the for(ls) works
for i in $(ls *2.fastq.gz | rev | cut -c 12- | rev | uniq);  do\
    	echo ${i};
   	mkdir ./STAR.Ensembl.Out/${i};
    	cd  ./STAR.Ensembl.Out/${i};



       /STAR/bin/Linux_x86_64/STAR --runMode alignReads --runThreadN 50 --genomeDir /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38   --readFilesIn  /injury/MegaFolderB/working_platelets/Nassa/${i}_1.fastq.gz   /injury/MegaFolderB/working_platelets/Nassa/${i}_2.fastq.gz   --outFileNamePrefix /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/${i}/  --sjdbGTFfile /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --outSAMtype SAM --readFilesCommand zcat;
cd ..; cd ..;
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

