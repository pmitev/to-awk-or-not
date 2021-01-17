# Manipulating the output from a genome analysis - vcf and gff
We have a comparison between a number of different fly cell lines. These are found in a huge vcf file (dgrp2.vcf). We also have the annotations in a gff3 file (Drosophila_melanogaster.BDGP6.28.101.chr.gff3) and the genome itself in a fasta file.

## Getting the RAW files

### The annotation of the fly genome:
Find the GFF3 [here](https://tinyurl.com/y2opo93p "Drosophila_melanogaster.BDGP6.28.101.chr.gff3").

### The genome sequence used in this project:
The genome is located [here](https://tinyurl.com/yyldprwp "Drosophila_melanogaster.BDGP6.28.dna.toplevel.fa").

### The comparison of all the variants in the cell lines in the freeze project
Finally, [here](http://dgrp2.gnets.ncsu.edu/data.html "dgrp2.vcf") is the VCF file.

### Starting to work with the data
Let's say we want to find out all genes that contains a variant and all variants that are located within a gene. What do we want to do first? Take a look at the vcf file. That is the one that contains all the variants. Then look at the gff file, which contains the genes and other annotations. Finally, take a look at the DNA sequence. You will need to combine all three to answer the question. Also, to make this faster, lets just look at **chromosome 4**, which means we have to extract that data as well.

### What do we need to get
* Fles containing only chromosome 4
* Positions for SNPs and INDELs
* Positions for genes and CDSs
* Separation of variants (SNPs and INDELs) into two groups, inside and outside genes (and CDSs)
* Separation of genes/CDSs into those with and without variants (and maybe how many there are per gene)

#### Tips before starting
* For readability of the vcf file:

`awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' dgrp2.vcf > dgrp2_trimmed.vcf &`

* If your awk takes too long to run (10h or so) - Make sure you have the latest awk, and also you might want to think about parallelisation.
* My solutions also work for files with more than one chromosome, so in some cases they are longer than needed for your exercise. I left it so on purpose.
* *SNPs* and *INDELs* are collectively named **variants**
* *Genes* and *CoDing Sequences (CDSs)* are sometimes just collectively called **genes**

### The exercise
Identify the steps you need to do and what each step does. Open the hints if you get stuck.


### Chromosome 4

??? "_Hint_, what do we need?"
    #### Extract chr4 from the vcf and the gff and make new files

??? "_Hint_"
    #### All lines from chromosome 4 start with a *4*

??? "_Solution_"
    `awk '/^4/{print $0}' Drosophila_melanogaster.BDGP6.28.101.chr.gff3 > Drosophila_melanogaster.chr4.gff3`
   
    `awk '/^4/{print $0}' dgrp2_trimmed.vcf > dgrp2_chr4.vcf`

#### *Follow-up task:* Count and sort the different genomic features in chromosome 4 by number.
??? "__Task result example__"
       1 chromosome
       1 snoRNA
       2 pre_miRNA
       7 pseudogene
      11 pseudogenic_transcript
      26 ncRNA_gene
      31 ncRNA
      79 gene
     295 mRNA
     338 three_prime_UTR
     571 five_prime_UTR
    2740 CDS
    3155 exon

### SNPs and INDELs

??? "_Hint_, which output do we want?"
    #### Get distribution of variants and list them in two separate files. For a bonus plot of the lengths of the INDELS, get the length of all INDELS into a third file

??? "_Hint_"
    #### Remove lines beginning with \# (grep)

??? "_Hint_"
    #### If columns 4 and 5 have different length, it's an INDEL. Otherwise it's a SNP.

??? "_Hint_"
    #### You want the output to be a file with columns 1, 2, 4 and 5, a classifier (SNP or INDEL) and finally the length of the INDEL (put "-" for the SNPs)

??? "_Solution_"
    `cat dgrp2_chr4.vcf | grep -v "#" | awk '{if (length($4)>1||length($5)>1){a="INDEL";b=length($4)-length($5);cnt[b]+=1;} else {a="SNP";b="-";} printf("%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, a, b, $4, $5) > "indels_Drosophila_chr4";}END{for (x in cnt){print x,cnt[x] > "distr_Drosophila_chr4"}}'`

#### *Follow-up task:* Print nucleotide substitution that these SNPs introduce sorted by number. Remember the coins...

??? "_Task result example_"
    1182 C->T
    1133 G->A
     932 A->G
     929 A->T
     892 T->A
     880 T->C
     639 G->T
     621 C->A
     436 A->C
     396 T->G
     372 G->C
     357 C->G

### Genes with variants

??? "_Hint_, how do we get those?"
    #### Compare back and separate the annotation into features that do and don’t have variants. For a bonus, also record the number of variants in each feature

??? "_Hint_"
    #### Make an index using the previous output to identify positions of variants

??? "_Hint_"
    #### For each feature in the gff, check all position it covers to see if they are in your index, if so print to one file. If not, print to another.

??? "_Solution_"
    `awk 'FNR==NR{a[$1,$2]="T"; next}{ hits=0; for(N=$4; N<=$5; N++) { if (a[$1,N] == "T") {hits+=1}} if (hits>0) {print hits "\t" $0 > "haveSNPINDEL_Drosophila_chr4.gff"} else {print $0 > "noSNPINDEL_Drosophila_chr4.gff"}}' indels_Drosophila_chr4 Drosophila_melanogaster.chr4.gff3`
    

#### *Follow-up task:* Count and sort the SNPs (not INDELs) in your output and compare to the output from the first step.
??? "_Task result example_"
       1 chromosome
       1 pre_miRNA
       1 snoRNA
       6 pseudogene
       9 pseudogenic_transcript
      22 ncRNA_gene
      28 ncRNA
      79 gene
     264 three_prime_UTR
     290 five_prime_UTR
     295 mRNA
    1798 CDS
    2181 exon

### Genes/CDSs only
??? "_Hint_, what features do we look for?"
    #### Filter for genes and CDSs before doing the analysis.

??? "_Hint_"
    #### Only genes and CDSs are interesting to us. Make a gff without the rest of the features.

??? "_Solution_"
    `awk '{if ($3=="gene" || $3=="CDS") print $0}' Drosophila_melanogaster.chr4.gff3 > Drosophila_melanogaster.chr4_genesCDSs.gff3`
    

### Final list of variants
??? "_Hint_, how do we classify the variants?"
    #### Repeat step 3 for the SNPs/INDELs themselves, to see which are actually located inside genes

??? "_Hint_"
    #### Make an index of all genes/CDSs (from your gff), where start and stop are paired

??? "_Hint_"
    #### For each feature from your step 2 file, check the position agains the index and print whether or not the variant is inside a gene.

??? "_Solution_"
    `awk 'FNR==NR{ingene[$1,$4]=$5; next}{state="Not in gene";for (pair in ingene) {split(pair, t, SUBSEP); if ($1==t[1] && $2>=t[2] && $2<=ingene[t[1],t[2]]) {state=(t[1] " " t[2] " " ingene[t[1],t[2]])}} print $0, " ", state }' Drosophila_melanogaster.chr4_genesCDSs.gff3 indels_Drosophila_chr4 > SNPsInGenes_Drosophila_ch4`

### Final result
Here we can see all SNPs and INDELs which are inside a relevant region. We have successfully made two gff:s containing all gene positions for genes with variants and genes without. Along the way we also got a list of all genes that contain variants too.

### Extra task
Re-do the files but this time include the gene ID (i.e. FBtr0089178 from column nine) and translate that into the full gene name found in this [file](http://ftp.flybase.org/releases/FB2020_06/precomputed_files/genes/fbgn_fbtr_fbpp_expanded_fb_2020_06.tsv.gz).


??? "__Solution__"  
    `awk 'FNR==1{++fileidx} fileidx==1{split($9,a,";|:");ingene[$1,$4,$5]=a[2]; next} fileidx==2{FS="\t";name[$3]=$5} fileidx==3{state="Not in gene";for (trip in ingene) {split(trip, t, SUBSEP); if ($1==t[1] && $2>=t[2] && $2<=t[3]) {state=(t[1] "\t" t[2] "\t" t[3] "\t" name[ingene[t[1],t[2],t[3]]])}} print $0, "\t", state }' Drosophila_melanogaster.chr4_genesCDSs.gff3 fbgn_fbtr_fbpp_expanded_fb_2020_06.tsv indels_Drosophila_chr4 > SNPsInNamedGenes_Drosophila_ch4`

    Look at the distribution of genes:

    `awk -F"\t" '{print $10}' SNPsInNamedGenes_Drosophila_ch4 | sort | uniq -c | sort -n`

