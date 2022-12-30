# BEAGLE TO VCF

```bash
#############
###MARKERS###
#############

#Create a file with individuals that will be used as header for the markers file
zcat window_chr30_25104-28571_100_snps.beagle.gz | cut -f 4- | head -n 1 > tmp0

while read line; do
	echo $line | tr ' ' '\n' | uniq | tr '\n' '   ' > ind
	done < tmp0

sed -i '1s/^/I /' ind
sed -i -e '$a\' ind

rm tmp0

#Create a temporary file with the first three lines of the BEAGLE file
zcat window_chr30_25104-28571_100_snps.beagle.gz | awk '{print $1,$2,$3}' > tmp0
#Create three files: one with the marker, the second with the alleleA but changing the numeric code to a ACTG code
cat tmp0 | cut -f1 -d' ' > column0 #marker line
cat tmp0 | awk '{print $2}' | sed 's/0/A/' | sed 's/1/C/' | sed 's/2/T/' | sed 's/3/G/' > column1 #alleleA
cat tmp0 | awk '{print $3}' | sed 's/0/A/' | sed 's/1/C/' | sed 's/2/T/' | sed 's/3/G/' > column2 #alleleB
#Combine all columns into a temporary file
paste column0 column1 column2 > tmp1
#Remove the header of the temporary file
cat tmp1 | tail -n+2 > tmp2
#Add the ind file as header: it contains an I to indicate that these are this line corresponds to individuals and then all individuals
cat ind tmp2 > tmp3
#Subtitute tabs for three spaces
sed -e 's/\t/   /g' tmp3 > markers
#Clean up
rm column0 column1 column2 tmp0 tmp1 tmp2 tmp3

############
###BEAGLE###
############

#Remove the three first columns
zcat window_chr30_25104-28571_100_snps.beagle.gz | cut -f 4-  > tmp4
#Add three columns: marker, 
cat markers | tail -n+2 | awk '{print $1,$2,$3}' > tmp2
touch header
printf 'marker   alleleA   alleleB\n' > header
cat header tmp2 > tmp3
paste tmp3 tmp4 > beagle
rm tmp2 tmp3 tmp4

############
###CHROMO###
############

zcat window_chr30_25104-28571_100_snps.beagle.gz | cut -f 1  > tmp5
sed 's/_.*//' tmp5 | tail -n+2 > chromosome
rm tmp5

#RUN BEAGLE2VCF

java -jar beagle2vcf.jar chromosome beagle markers NA 
```

