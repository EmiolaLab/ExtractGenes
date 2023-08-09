#!/bin/bash

cd $WDR
GDR=$(readlink -f $INPUT_DIR)
echo "$WDR is present directory" 
echo "$GDR is the genomes directory"
echo "$ODR is the output directory"
echo "For two defense systems separated by $MIN – $MAX bp, retrieved all uncharacterized genes"

cd $GDR
exec 3>&2
exec 2> /dev/null
if [ "$LIST" == "false" ]; then
ls {*.fna,*.fa,*.fasta} > $ODR/genomes.txt #suppress error to std output
else
cat $LIS > $ODR/genomes.txt
fi
exec 2>&3
#############

cd $ODR
for genome in `cat $ODR/genomes.txt`
do
i=$(echo "$genome" |  rev | cut -d'.' -f2- | rev)
mkdir out.$i

echo "Running PADLOC to identify known defense genes"
echo ""
padloc --fna $GDR/$genome --outdir out.$i --cpu $NUM_THREAD || exit 1

echo "Processing output of PADLOC"
echo ""
cd out.$i

exec 3>&2
exec 2> /dev/null
sed '1d' $i*\_padloc.csv | cut -f2 -d',' | sort | uniq > contigs # retrieve contigs with defense systems || exit 1
exec 2>&3

if  [[ -s contigs ]]; then

for contigs in `cat contigs`
do
grep -w "$contigs" $i*\_padloc.csv | sort -n -t',' -k13,13 | cut -f3,4,12,13 -d',' > first
grep -w "$contigs" $i*\_padloc.csv | sort -n -t',' -k13,13 | cut -f3,4,12,13 -d',' | sed '1d' > second

#retrieving regions between defense systems based on size cutoffs 
paste -d'\t' second first | sed 's/,/\t/g' | awk '{ $9 = $3 - $8 } 1' | awk '$9 > '$MIN'' | awk '$9 < '$MAX'' |sed '/./=' | sed '/./N; s/\n/ /' | sed 's/^/candidate/g' | sed 's/ /\t/g' > out || exit 1

#checkpoint
if  [[  -s out ]]; then 

cut -f1 out > tmp
for defense_gene in `cat tmp`
do
grep -w "$defense_gene" out | cut -f3,7 | sed 's/\t/\n/g' > gene_interval
defense_types_boundary=$(grep -w "$defense_gene" out | cut -f2,6 | sed 's/\t/|/g')

var=$(grep ">" $i*\_prodigal.faa | grep -wnf gene_interval | cut -f1 -d':' | tr '\r\n' ',' | sed '$ s/.$/p/')
grep ">" $i*\_prodigal.faa | sed -n ''$var'' | sed 's/>//g' | grep -wvf gene_interval > extract_genes
samtools faidx $i*\_prodigal.faa $(cat extract_genes ) | sed "s/>/>$defense_types_boundary|/g" >> ExtractedGenes_$i.faa || exit 1

### write output 
known_defense_genes=$(echo "$defense_types_boundary" | sed 's/|/\t/g')
genes=$(cat extract_genes | tr '\r\n' ';')
echo -e "$known_defense_genes\t$genes" >> ExtractedGenes_$i.txt.tmp 
done
fi

done
exec 3>&2
exec 2> /dev/null
rm out second first tmp contigs gene_interval extract_genes
exec 2>&3

else
echo "######## NO DEFENSE SYSTEM(S) DETECTED by PADLOC"
fi
#Add numbering and header to file
exec 3>&2
exec 2> /dev/null
awk -vOFS="\t" '$0 { print "Region" ++nr , $0; next }{ print }' ExtractedGenes_$i.txt.tmp > ExtractedGenes_$i.txt
printf '1\ni\nRegion(s)\tFlanking_Defense_Gene1\tFlanking_Defense_Gene2\tExtracted_Genes_ID\n.\nw\n' | ed -s ExtractedGenes_$i.txt
rm ExtractedGenes_$i.txt.tmp
exec 2>&3
cd $ODR
done
