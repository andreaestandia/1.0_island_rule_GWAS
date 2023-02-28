#cat ../output/chr16.ld | bash ../../../src/others/LD_blocks.sh chr16 1 379548
#cat ../output/chr22.ld | bash ../../../src/others/LD_blocks.sh chr22 2824315 2831854
#for {1..2320000}
#do
#	cat ../output/chr29.ld | bash ../../../src/others/LD_blocks.sh chr29 5874181 5882086
#done

#THINGS TO DO: ADD RELATIVE PATHS BC THIS WORKS FROM THE LD_BLOCK DIR

chr=$1
i=$2
j=$3
step=$4

until [ $i -gt 2320000 ] 
do
	cat ../output/$chr.ld | bash ../../../src/myscripts/plot_LDblocks.sh $chr $i $j
	((i=i+$4))
	((j=j+$4))
done
