## Overview

These are the scripts and container definition files for running run QC by mapping the fastqc files and extracting various metrics.

## QC workflow
* Run mapping QC on all fastqc files (illuminaQC.pl)
* Create run specific QC html files (QC_map_PE_illumina.pl)
* Update index for all QC runs





## Create genome indexes
This project is simple Lorem ipsum dolor generator.
	
## illuminaQC
Project is created with:
* Lorem version: 12.3
* Ipsum version: 2.33
* Ament library version: 999
	
## Run scripts (runPE.sh and runSE.sh)

These files act as the link between the illuminaQC


```
$ cd ../lorem
$ npm install
$ npm start
```


## Create genome indexes
This scripts gives examples of using bwa index genome fasta files for incorporation with these scripts.


After creating additional indexes, these would need to be added to the runPE.sh and runSE.sh scripts citing the reference name and the index location.

e.g.
```
if [ "${ref}" == "hg19" ]; then
    refpath=/data09/QC_pipelines/genomes/UCSC/hg19/hg19
fi
```