#!/bin/bash
# AUTHOR: Bruno Gomez-Gil, Laboratorio de Genomica Microbiana, CIAD.
# DEPENDECIES: KronaTools 2.5
# USAGE: script samples-tax.tsv
# LAST REVISITED: 16 July 2017
# https://github.com/GenomicaMicrob/OTUsamples2krona
SCRIPT='OTUsamples2krona'
VER='ver.0.2'
display_help(){
	echo
	echo "_____________________________ $SCRIPT $VER ___________________________________"
	echo
	echo "A simple script to generate Krona pie charts from all sampleS OTUs."
	echo
	echo -e "\e[1mUSAGE\e[0m: $SCRIPT file.tsv"
	echo
	echo "The tsv file has to have the following format:"
	echo "   first line has the sample name (delimited by tabs) and taxa structure"
	echo "   from the second line, the OTU values (delimited by tabs) and the taxonomy"
	echo "   delimited by semicolons. Example:"
	echo
	echo "sample1 sample2 sampleN domain;phylum;class;order;family;genus;species"
	echo "  2       0       0     Bacteria;Firmicutes;Bacilli;Bacillales;Bacillaceae;Marinococcus;Unclassified_s"
	echo
	echo "mg_classifier produces already the file samples-tax.tsv with this format."
	echo "____________________________________________________________________________________________"
	echo
}
# -h is typed, displays usage
	if [ "$1" == "-h" ]
	then
		display_help
		exit 1
	fi
display_usage(){
	echo
	echo "__________________ $SCRIPT $VER _________________________"
	echo
	echo -e "\e[1mERROR\e[0m: missing file"
	echo
	echo -e "\e[1mUSAGE\e[0m: $SCRIPT samples-tax.tsv "
	echo "For help, type: $SCRIPT -h"
	echo "______________________________________________________________________"
	echo
}
# less than one arguments supplied, display usage 
	if [  $# -le 0 ] 
	then 
		display_usage
		exit 1
	fi
# ------- script starts -------
NCOL=$(awk 'NR==1{print NF-1}' $1) # variable to get the number of columns, except the last (taxonomy)
mkdir -p krona
awk '{print $NF}' $1 > krona/tax.txt # creates a file with only the taxonomy for later pasting
for (( i=1; i <= $NCOL; i++ )); do awk '{print $'$i'}' $1 > krona/sample_0${i}.dat; done # makes temporary files with the info of each sample (column)
# create individual files with OTU values and taxonomy
for f in krona/*.dat
do
	SAMPLE=$(head -1 $f)
	paste $f krona/tax.txt > krona/$SAMPLE.tmp
done
# formatting files for krona
for f in krona/*.tmp
do
	sed -i '1d' $f
	grep -w -v "0" $f > $f.tax
done # removes first line (header) and lines with zero as value
rename 's/tmp.//' krona/*.tax
# formatting and charting
for f in krona/*.tax
do
	sort -k2,2 $f -o $f # sorts based on taxonomy
	sed -i 's/;/\t/g' $f
	SAMPLE=$(basename $f .tax) # gets the filename without the extension
	ktImportText $f -n $SAMPLE -o $f.html # generates Krona charts
done
# clean up
rename -f 's/tax.//' krona/*.html
rm -f krona/*.dat krona/*.tmp krona/tax.txt krona/*.tax
echo -e "\e[33m$NCOL Krona charts have been created in krona/\e[0m"
echo "Adios"
echo
# This is the end.