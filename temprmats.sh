python /injury/someTools/rmats-turbo/rmats.py  --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/coll.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.novel..2._contvscoll --tmp  /injury/MegaFolderB/Nassa.out/rmats.tempnovel2_contvscoll;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.novel..2._contvscoll contvscoll_novel

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/coll.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.novel..2._collvstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.tempnovel2_collvstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.novel..2._collvstrap collvstrap_novel

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.novel..2._convstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.tempnovel2_convstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.novel..2._convstrap convstrap_novel




python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/coll.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --od /injury/MegaFolderB/Nassa.out/rmats.out.2._contvscoll --tmp  /injury/MegaFolderB/Nassa.out/rmats.temp2_contvscoll;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.2._contvscoll contvscoll

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/coll.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --od /injury/MegaFolderB/Nassa.out/rmats.out.2._collvstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.temp2_collvstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.2._collvstrap collvstrap

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/Nassa.out/controls.txt --b2 /injury/MegaFolderB/Nassa.out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/Nassa.out/rmats.out.2._convstrap --tmp  /injury/MegaFolderB/Nassa.out/rmats.temp2_convstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/Nassa.out/rmats.out.2._convstrap convstrap 

