date
python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/oddforRMATs.txt --b2 /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/CforRMATs.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 50 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/rmats.out10 --tmp  /injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/rmats.temp10;
date
# clipping lets it work with old Bams
