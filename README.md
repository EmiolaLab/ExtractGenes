# Retrieval of uncharacterized genes between known anti-phage defense genes
Many anti-phage genes are located in defense islands. However, there are several genes of unknown function present in these regions which likely participate in defense. This tool retrieves uncharacterized proteins located between two known defense proteins or systems. These proteins can be subjected to downstream analysis such as clustering, domain prediction, and protein structure prediction to identify new anti-phage systems. More information can be found in Ning *et al* (202x) (ref).

## INSTALLATION
This tool depends on Padloc (ref) and Samtools (ref). We recommend installation of dependencies using Bioconda by following the steps below:

##### conda create -n extractGenesTool -c conda-forge -c bioconda -c padlocbio padloc samtools
    - # Activate the environment
    conda activate extractGenesTool
    
    - # Download the latest padloc database
    padloc --db-update

    - # Download the extractGenes files
    wget https://github.com/ohlab/SMEG/archive/1.1.1.tar.gz
    tar xvf 1.1.1.tar.gz
