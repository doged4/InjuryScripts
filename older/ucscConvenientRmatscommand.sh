date
python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/oddforRMATs.txt --b2 /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/CforRMATs.txt --gtf /genome/Homo_sapiens/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf  --bi /genome/genomes/hg19STARbase --variable-read-length --allow-clipping --nthread 50 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/rmats.out10 --tmp  /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/rmats.temp10;
date
# clipping lets it work with old Bams
