import csv
import pandas
import sys

nameMapper = '/genome/genomes/kgUCSCformToSymbol.txt'
mapneedingFile = sys.argv[1]


mapperTable = pandas.read_csv(nameMapper, sep = "\t")
mappedFrame = pandas.read_csv(mapneedingFile, sep = "\t", header =1)

outSend = mappedFrame.merge(mapperTable, how = "left", left_on = "Geneid", right_on = "#kgID")


outSend.to_csv(mapneedingFile + ".use.tsv",sep='\t')






