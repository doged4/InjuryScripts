#!/bin/bash

NAME=$(echo $1 | rev | cut -c 5- | rev)
echo $(echo $1 | rev | cut -c 5- | rev)

samtools view -S -b ${NAME}.sam > ${NAME}.bam
samtools sort ${NAME}.bam -o ${NAME}.sorted.bam
samtools index  ${NAME}.sorted.bam
