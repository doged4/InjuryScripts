#!/usr/bin/env python
# coding: utf-8

# In[1]:


from glob import glob
from pathlib import Path
import pandas as pd

# data_folder = Path("/Users/manch/rmats/sp4_novaseq2019/")
# couldnt get this to work: files=data_folder / "*.JCEC.txt"
# filenames = sorted(glob('/Users/manch/jupyter/rmats6/*.JCEC.txt'))
filenames = sorted(glob('/injury/MegaFolderB/wholeblood_plateletActivation_Novaseq/STAR.Ensembl.Out/rmats.out_nonnovel2/*.JCEC.txt'))
dataframes = [pd.read_csv(f, sep='\t') for f in filenames]


# In[2]:


print(filenames[0])
print(filenames[1])
print(filenames[2])
print(filenames[3])
print(filenames[4])


# In[3]:


A3SS = dataframes[0]
A5SS = dataframes[1]
MXE = dataframes[2]
RI = dataframes[3]
SE = dataframes[4]


# In[4]:


# add Event_type

A3SS['Event_type'] = pd.Series('A3SS',(list(range(0,A3SS.shape[0]))))
A5SS['Event_type'] = pd.Series('A5SS',(list(range(0,A5SS.shape[0]))))
MXE['Event_type'] = pd.Series('MXE',(list(range(0,MXE.shape[0]))))
RI['Event_type'] = pd.Series('RI',(list(range(0,RI.shape[0]))))
SE['Event_type'] = pd.Series('SE',(list(range(0,SE.shape[0]))))


# In[5]:


SUMMARY=pd.concat([A3SS,A5SS,MXE,SE,RI], axis=0, ignore_index=True)
SUMMARY


# In[6]:


SUMMARY_FDR=SUMMARY[SUMMARY.FDR <0.25]
SUMMARY_FDR.sort_values(by=['FDR'])
#moves columns pval fdr and event type to the end of concatonated file
column_names=['ID', 'GeneID', 'geneSymbol', 'chr', 'strand', 'longExonStart_0base',
               'longExonEnd', 'shortES', 'shortEE', 'flankingES', 'flankingEE', 'ID.1',
                      'IJC_SAMPLE_1', 'SJC_SAMPLE_1', 'IJC_SAMPLE_2', 'SJC_SAMPLE_2',
                             'IncFormLen', 'SkipFormLen','IncLevel1', 'IncLevel2',
                                    'IncLevelDifference', '1stExonStart_0base', '1stExonEnd',
                                           '2ndExonStart_0base', '2ndExonEnd', 'upstreamES', 'upstreamEE',
                                                  'downstreamES', 'downstreamEE', 'exonStart_0base', 'exonEnd',
                                                         'riExonStart_0base', 'riExonEnd', 'PValue', 'FDR','Event_type']
SUMMARY_FDR = SUMMARY_FDR.reindex(columns=column_names)
SUMMARY_FDR


# In[7]:


SUMMARY_FDR.to_csv('rmats6_25.csv')


# In[8]:


#search for a specfic gene
SUMMARY_FDR.loc[SUMMARY_FDR['geneSymbol']== 'MKNK1']


# In[9]:


# search for a gene with wildcards
SUMMARY_FDR.loc[SUMMARY_FDR['geneSymbol'].str.contains('RBM', regex=False, na=False)]


# In[10]:


SUMMARY_FDR1=SUMMARY[SUMMARY.FDR <0.01]
SUMMARY_FDR1.sort_values(by=['FDR'])
#moves columns pval fdr and event type to the end of concatonated file
column_names=['ID', 'GeneID', 'geneSymbol', 'chr', 'strand', 'longExonStart_0base',
               'longExonEnd', 'shortES', 'shortEE', 'flankingES', 'flankingEE', 'ID.1',
                      'IJC_SAMPLE_1', 'SJC_SAMPLE_1', 'IJC_SAMPLE_2', 'SJC_SAMPLE_2',
                             'IncFormLen', 'SkipFormLen','IncLevel1', 'IncLevel2',
                                    'IncLevelDifference', '1stExonStart_0base', '1stExonEnd',
                                           '2ndExonStart_0base', '2ndExonEnd', 'upstreamES', 'upstreamEE',
                                                  'downstreamES', 'downstreamEE', 'exonStart_0base', 'exonEnd',
                                                         'riExonStart_0base', 'riExonEnd', 'PValue', 'FDR','Event_type']
SUMMARY_FDR1 = SUMMARY_FDR1.reindex(columns=column_names)
SUMMARY_FDR1


SUMMARY_FDR1.to_csv('rmats6_01.csv')


# In[ ]:





