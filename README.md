# Retrieval of uncharacterized proteins between known anti-phage defense genes
Many anti-phage genes are located in defense islands. However, there are several genes of unknown function present in these regions which likely participate in defense. This tool retrieves uncharacterized proteins located between two known defense proteins or systems. These proteins can be subjected to downstream analysis such as clustering, domain prediction, and protein structure prediction to identify new anti-phage systems. More information can be found in Duan *et al* (202x) (ref).

## INSTALLATION
This tool depends on PADLOC (https://github.com/padlocbio/padloc) and Samtools. We recommend installation of dependencies using Bioconda by following the steps below:

##### conda create -n extractGenesTool -c conda-forge -c bioconda -c padlocbio padloc samtools
    - # Activate the environment
    conda activate extractGenesTool
    
    - # Download the latest padloc database
    padloc --db-update

    - # Download the extractGenes files
    wget https://github.com/EmiolaLab/ExtractGenes/archive/1.0.tar.gz
    tar xvf 1.0.tar.gz
    cd ExtractGenes-1.0

    - # Add to PATH
    echo "export PATH=$PATH:/path/to/ExtractGenes-1.0" >> ~/.bashrc   
    source ~/.bashrc

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

We use PADLOC to identify known anti-phage proteins. By default, if two defense proteins are separated by 1,000 – 15,000 bp, our tool will retrieve all uncharacterized proteins in this region. However, this range can be modified using the `-m` and `-x` flag. For basic usage, simply run `extractGenes -i [genomes_directory] `. 
Note: Genomes must be in fasta format and must have either .fasta, .fa or .fna extensions.

## OUTPUT
Eight output files are generated, 5 of which are the output from PADLOC. The main output files from extractGenes are:
`ExtractedGenes_[genome_name].txt`
`ExtractedGenes_[genome_name].faa`

ExtractedGenes_[genome_name].txt contains 4 columns: (a) Name of candidate region, (b) left-flanking known defense protein, (c) right-flanking known defense protein, and (d) gene IDs of extracted proteins (separated by semicolon).

ExtractedGenes_[genome_name].faa contains the extracted protein sequences. The protein headers also contain the names of flanking defense proteins. For example `>cbass_type_IIs|gabija|protein_1` means protein_1 is located between CBASS and Gabija defense systems.
