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
    cd SMEG-1.1.1/test

## USAGE
    #################################################
    ##   RETRIEVAL OF UNCHARACTERIZED GENES BETWEEN #
    ##   KNOWN DEFENSE GENES                        #
    #################################################
    Usage:
        extractGenes -v                     Version
        extractGenes -h                     Display this help message
        extractGenes -i                     Input genomes directory
        extractGenes -l                     File listing a subset of genomes for analysis
                                            [default = use all genomes in 'Genomes directory']
        extractGenes -t  INT                Number of threads [default 8]
        extractGenes -o                     Output directory
        extractGenes -m  INT                Minimum size (bp) seperating 2 defense genes for analysis [default 1000]
        extractGenes -x  INT                Maximum size (bp) seperating 2 defense genes for analysis [default 15000]
