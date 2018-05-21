# OTUsamples2krona
Simple script to generate Krona charts for all samples in an OTU table file

This bash script needs the [KronaTools](https://github.com/marbl/Krona/tree/master/KronaTools) to be installed and also a tab delimited file with OTU numbers and taxonomy.

### Installation ###
Clone this repository in you linux machine, make it executable and you are ready to go.

```
git clone https://github.com/GenomicaMicrob/OTUsamples2krona.git
cd OTUsamples2krona
chmod +x OTUsamples2krona.v0.2.2.sh
```

### Usage ###

`./OTUsamples2krona.v0.2.2.sh samples-tax.tsv`

The test file `samples-tax.tsv` is also included. This file was created with [mg_classifier](https://github.com/GenomicaMicrob/mg_classifier) from samples from P. Schloss [Miseq SOP webpage](https://www.mothur.org/wiki/MiSeq_SOP). 

For help:

`./OTUsamples2krona.sh -h`

### OTU file ###

The OTU file has to have the following format:
The first line has the sample name (delimited by tabs) and a taxa structure (although this structure is not strictly necessary), from the second line downwards, the OTU values (delimited by tabs) and the taxonomy delimited by semicolons.
```
A	B	C	domain;phylum;class;order;family;genus;species
48	10	0	Bacteria;Proteobacteria;Gammaproteobacteria;Vibrionales;Vibrionaceae;Photobacterium;Unclassified_s
10	0	14	Bacteria;Proteobacteria;Gammaproteobacteria;Vibrionales;Vibrionaceae;Vibrio;Unclassified_s
0	0	3	Bacteria;Actinobacteria;Actinobacteria_c;Micrococcales;Microbacteriaceae;Limnoluna;Limnoluna_rubra
93	278	777	Bacteria;Cyanobacteria;Chroobacteria;Chroococcales;Prochlorococcaceae;Prochlorococcus;AM084273_s
9	0	66	Bacteria;Cyanobacteria;Chroobacteria;Chroococcales;Prochlorococcaceae;Prochlorococcus;BX548175_s
...
```
From this example file (`samples-tax.tsv`, included), the script will create three html files in a subdirectory named krona. The sample name will appear at the center of the pie chart generated.

If you use [QIIME](http://qiime.org), during the standard pipelines, the file `otu_table.biom` is produced, this file can be converted to the format needed with [biom](http://biom-format.org/index.html) (of course you have to have biom installed):

`biom convert -i otu_table.biom -o otu_table.tsv --to-tsv --header-key taxonomy`

This command will produce a file almost ready to use; since a column at the beggining is added with no useful data, we need to delete it with:

`cut -f1 --complement otu_table.tsv > otu.tsv`

Sometimes the taxonomy structure produced by QIIME is rather crappy, due to the crappy databases it uses, so it might not work all the time. Consider using [mg_classifier](https://github.com/GenomicaMicrob/mg_classifier), a super fast classifier that produces the file `samples-tax.tsv` with the correct format.
