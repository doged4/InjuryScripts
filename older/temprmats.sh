python /injury/someTools/rmats-turbo/rmats.py  --b1 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/controls.txt --b2 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/coll.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.novel..2._contvscoll --tmp  /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.tempnovel2_contvscoll;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.novel.2._contvscoll contvscoll_novel

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/coll.txt --b2 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.novel..2._collvstrap --tmp  /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.tempnovel2_collvstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.novel.2._collvstrap collvstrap_novel

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/controls.txt --b2 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.novel..2._convstrap --tmp  /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.tempnovel2_convstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.novel.2._convstrap convstrap_novel

#Novel below

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/controls.txt --b2 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/coll.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --od /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.2._contvscoll --tmp  /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.temp2_contvscoll;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.2._contvscoll contvscoll

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/coll.txt --b2 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --od /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.2._collvstrap --tmp  /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.temp2_collvstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.2._collvstrap collvstrap

python /injury/someTools/rmats-turbo/rmats.py --b1 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/controls.txt --b2 /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/trap.txt --gtf /genome/genomes/Ensembl_Grch38/Homo_sapiens.GRCh38.100.gtf --bi /genome/genomes/Ensembl_Grch38/STAR.Ensembl.GRCh38 --variable-read-length --allow-clipping --nthread 45 -t paired --readLength 150 --novelSS --od /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.2._convstrap --tmp  /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.temp2_convstrap;

python3 /injury/scripts2/argmanchRMATspython.py /injury/MegaFolderB/working_platelets/Nassa/STAR.Ensembl.Out/rmats.out.2._convstrap convstrap 

