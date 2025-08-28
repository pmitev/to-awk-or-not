# Manipulating the output from a genome analysis - vcf and gff

> Problem formulated and presented at the workshop by [**Jonas Söderberg**](https://katalog.uu.se/profile/?id=N2-1277),  
Department of Cell and Molecular Biology, _Molecular Evolution_

## Task at hand
We have a bunch of files that describes a standard fly, the genes of the fly and also where our new non-standard flies differ from the standard fly (the reference). These differences are called variants and are divided ito three categories; SNPs (Singular Nucleotide Polymorphisms), Insertions (Some DNA is inserted in our variant in comparison to the reference) and Deletions (Some DNA is deleted from our variant in comparison to the reference). We want to find out where and in what way the new flies have variants, if those variants are inside genes or not and finally what the genes (in which those variants are located) actually do.

## Getting the RAW files
We have a comparison between a number of different new fly cell lines. These are found in a huge vcf file (dgrp2.vcf). We also have the annotations in a gff3 file (Drosophila_melanogaster.BDGP6.28.101.chr.gff3) and the genome itself in a fasta file.

### The annotation of the fly genome:
Find the GFF3 [here](https://ftp.ensembl.org/pub/release-101/gff3/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.28.101.chr.gff3.gz "Drosophila_melanogaster.BDGP6.28.101.chr.gff3").

### The genome sequence used in this project:
The genome is located [here](https://ftp.ensemblgenomes.org/pub/metazoa/release-48/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.28.dna.toplevel.fa.gz "Drosophila_melanogaster.BDGP6.28.dna.toplevel.fa").

### The comparison of all the variants in the cell lines in the freeze project
[Here](http://dgrp2.gnets.ncsu.edu/data.html "dgrp2.vcf") is the VCF file with the variants.
(That page seems to be lost, so [here](https://resources.aertslab.org/DGRP2/NCSU/final/dm6/DGRP2.source_NCSU.dm6.final.vcf.gz) is a very similar, although not identical file)

### Common names and functions
Finally, full gene names and functions found in this [file](https://ftp.flybase.org/releases/FB2020_06/precomputed_files/genes/fbgn_fbtr_fbpp_expanded_fb_2020_06.tsv.gz).

### Tips before starting
* For readability of the vcf file:

`awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' dgrp2.vcf > dgrp2_trimmed.vcf &`

* If your awk takes too long to run (10h or so) - Make sure you have the latest awk, and also you might want to think about parallelisation.
* My solutions also work for files with more than one chromosome, so in some cases they are longer than needed for your exercise. I left it so on purpose.
* *SNPs* and *INDELs* are collectively named **variants**
* *Genes* and *CoDing Sequences (CDSs)* are sometimes just collectively called **genes**

* For shorter run times, extract chromosome 4 and look only at that.

### Making awking the data easier
Start by splitting the task into sub-tasks. This makes it easier to see what happens and you might get interesting intermediary results. 

### *bonus result* 
A table with counted and sorted different genomic features in chromosome 4.

### *bonus result* 
SNPs sorted by number. Just like the coins on day one.

### The exercise
Identify the steps you need and use awk to do those. Open the hints if you get stuck.


<br>
<br>
<br>
<br>
<br>
<br>



## Hints, ordered by subject. Don't use them unless necessary. They are not good code examples.

### Overall, an example of things to look for

??? "_Hint_ **Example**"
    Let's say we want to find out all genes that contains a variant and all variants that are located within a gene. What do we want to do first? Take a look at the vcf file. That is the one that contains all the variants. Then look at the gff file, which contains the genes and other annotations. Finally, take a look at the DNA sequence. You will need to combine all three to answer the question. 
    
??? "_Hint_ **Example, what do we need to get?**"
    * Positions for SNPs and INDELs
    * Positions for genes and CDSs
    * Separation of variants (SNPs and INDELs) into two groups, inside and outside genes (and CDSs)
    * Separation of genes/CDSs into those with and without variants (and maybe how many there are per gene)

### Chromosome 4

??? "_Hint_ **What do we need?**"
    Extract chr4 from the vcf and the gff and make new files

??? "_Hint_"
    All lines from chromosome 4 start with a *4*

??? "_Solution_"
    `awk '/^4/{print $0}' Drosophila_melanogaster.BDGP6.28.101.gff3 > Drosophila_melanogaster.chr4.gff3`
   
    `awk '/^4/{print $0}' dgrp2_trimmed.vcf > dgrp2_chr4.vcf`



??? "_bonus result example_ **A table with counted and sorted different genomic features in chromosome 4.**"
    ```
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
    ```

### Variants

??? "_Hint_ **Which output do we want?**"
    Get distribution of variants and list them in two separate files. For a bonus plot of the lengths of the INDELS, get the length of all INDELS into a third file

??? "_Hint_"
    Remove lines beginning with \# (grep)

??? "_Hint_"
    If columns 4 and 5 have different length, it's an INDEL. Otherwise it's a SNP.

??? "_Hint_"
    You want the output to be a file with columns 1, 2, 4 and 5, a classifier (SNP or INDEL) and finally the length of the INDEL (put "-" for the SNPs)

??? "_Solution_"
    `cat dgrp2_chr4.vcf | grep -v "#" | awk '{if (length($4)>1||length($5)>1){a="INDEL";b=length($4)-length($5);cnt[b]+=1;} else {a="SNP";b="-";} printf("%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, a, b, $4, $5) > "indels_Drosophila_chr4";}END{for (x in cnt){print x,cnt[x] > "distr_Drosophila_chr4"}}'`
    <br>
    or
    <br>
    `cat dgrp2_chr4.vcf | grep -v "#" | ./indels.awk`
    
    ??? "_indels.awk_"
        ```
        #!/usr/bin/awk -f
        {
            if (length($4)>1||length($5)>1){
                a="INDEL";
                b=length($4)-length($5);
                cnt[b]+=1;
            }
            else{
                a="SNP";
                b="-";
            }
        printf("%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, a, b, $4, $5) > "indels_Drosophila_chr4";
        }

        END{
            for (x in cnt){
                print x,cnt[x] > "distr_Drosophila_chr4"
            }
        }
        ```

    ??? "_Solution_ proposed by Loïs Rancilhac - 2022.08.30"
        `awk '/_SNP/ {SNP++; print $0 > "chr4_SNPs.vcf"} /_DEL/ {DEL++; print $0 > "chr4_DEL.vcf"; LENGTH=length($4)-length($5); print LENGTH > "Deletions_lengths.txt"} /_INS/ {INS++; print $0 > "chr4_INS.vcf"; LENGTH=length($5)-length($4); print LENGTH > "Insertions_lengths.txt"} END{print "SNPs: "SNP"\nInsertions: "INS"\nDeletions: "DEL}' chr4.vcf`

??? "_bonus result example_ **SNPs sorted by number**"
    ```
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
    ```

### Genes with variants

??? "_Hint_ **How do we get those?**"
    Compare back and separate the annotation into features that do and don’t have variants. For a bonus, also record the number of variants in each feature

??? "_Hint_"
    Make an index using the previous output to identify positions of variants

??? "_Hint_"
    For each feature in the gff, check all position it covers to see if they are in your index, if so print to one file. If not, print to another.

??? "_Solution_"
    `awk 'FNR==NR{a[$1,$2]="T"; next}{ hits=0; for(N=$4; N<=$5; N++) { if (a[$1,N] == "T") {hits+=1}} if (hits>0) {print hits "\t" $0 > "haveSNPINDEL_Drosophila_chr4.gff"} else {print $0 > "noSNPINDEL_Drosophila_chr4.gff"}}' indels_Drosophila_chr4 Drosophila_melanogaster.chr4.gff3`
    <br>
    or
    <br>
    `./genes_var.awk indels_Drosophila_chr4 Drosophila_melanogaster.chr4.gff3`
    
    ??? "_genes_var.awk_"
        ```
        #!/usr/bin/awk -f

        FNR==NR{
            a[$1,$2]="T";
            next
        }
        {
            hits=0;
            for(N=$4; N<=$5; N++) {
                if (a[$1,N] == "T") {
                 hits+=1
                }
            }
            if (hits>0) {
                print hits "\t" $0 > "haveSNPINDEL_Drosophila_chr4.gff"
            }
            else {
                print $0 > "noSNPINDEL_Drosophila_chr4.gff"
            }
        }
        ```

### Genes/CDSs only

??? "_Hint_ **What features do we look for?**"
    Filter for genes and CDSs before doing the analysis.

??? "_Hint_"
    Only genes and CDSs are interesting to us. Make a gff without the rest of the features.

??? "_Solution_"
    `awk '$3 ~ /gene|CDS/' Drosophila_melanogaster.chr4.gff3 > Drosophila_melanogaster.chr4_genesCDSs.gff3`
    

### List of variants

??? "_Hint_ **How do we classify the variants?**"
    Repeat step 3 for the SNPs/INDELs themselves, to see which are actually located inside genes

??? "_Hint_"
    Make an index of all genes/CDSs (from your gff), where start and stop are paired

??? "_Hint_"
    For each feature from your step 2 file, check the position against the index and print whether or not the variant is inside a gene.

??? "_Solution_"
    `awk 'FNR==NR{ingene[$1,$4]=$5; next}{state="Not in gene";for (pair in ingene) {split(pair, t, SUBSEP); if ($1==t[1] && $2>=t[2] && $2<=ingene[t[1],t[2]]) {state=(t[1] " " t[2] " " ingene[t[1],t[2]])}} print $0, " ", state }' Drosophila_melanogaster.chr4_genesCDSs.gff3 indels_Drosophila_chr4 > SNPsInGenes_Drosophila_ch4`
    <br>
    or
    <br>
    `./varlist.awk Drosophila_melanogaster.chr4_genesCDSs.gff3 indels_Drosophila_chr4 > SNPsInGenes_Drosophila_ch4`
    
    ??? "_varlist.awk_"
        ```
        #!/usr/bin/awk -f
        
        FNR==NR{
            ingene[$1,$4]=$5; 
            next
        }
        {
            state="Not in gene";
            for (pair in ingene) {
                split(pair, t, SUBSEP); 
                if ($1==t[1] && $2>=t[2] && $2<=ingene[t[1],t[2]]) {
                    state=(t[1] " " t[2] " " ingene[t[1],t[2]])
                }
            } 
            print $0, " ", state 
        }
        ```

??? "_Hint_ **Finding the names**"
    Find a common field

??? "_Hint_ **Which field?**"
    gene ID
    
??? "_Hint_ **Where is that?**"
    column nine, not awk!
    
??? "_Solution_"  
    `awk 'FNR==1{++fileidx} fileidx==1{split($9,a,";|:");ingene[$1,$4,$5]=a[2]} fileidx==2{FS="\t";name[$3]=$5} fileidx==3{state="Not in gene";for (trip in ingene) {split(trip, t, SUBSEP); if ($1==t[1] && $2>=t[2] && $2<=t[3]) {state=(t[1] "\t" t[2] "\t" t[3] "\t" name[ingene[t[1],t[2],t[3]]])}} print $0, "\t", state }' Drosophila_melanogaster.chr4_genesCDSs.gff3 fbgn_fbtr_fbpp_expanded_fb_2020_06.tsv indels_Drosophila_chr4 > SNPsInNamedGenes_Drosophila_ch4`
    <br>
    or
    <br>
    `./in_named.awk Drosophila_melanogaster.chr4_genesCDSs.gff3 fbgn_fbtr_fbpp_expanded_fb_2020_06.tsv indels_Drosophila_chr4 > SNPsInNamedGenes_Drosophila_ch4`
    ??? "__in_named.awk__"
        ```
        #!/usr/bin/awk -f
        FNR==1{
            ++fileidx
        }
        {
            if (fileidx==1){
                split($9,a,";|:");
                ingene[$1,$4,$5]=a[2]
            } 
            if (fileidx==2){
                FS="\t";
                name[$3]=$5
            } 
            if (fileidx==3){
                state="Not in gene";
                for (trip in ingene) {
                    split(trip, t, SUBSEP); 
                    if ($1==t[1] && $2>=t[2] && $2<=t[3]) {
                        state=(t[1] "\t" t[2] "\t" t[3] "\t" name[ingene[t[1],t[2],t[3]]])
                    }
                } 
                print $0, "\t", state 
            }
        }
        ```

    Look at the distribution of genes:

    `awk -F"\t" '{print $10}' SNPsInNamedGenes_Drosophila_ch4 | sort | uniq -c | sort -n`

