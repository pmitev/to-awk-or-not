# Manipulating the output from a genome analysis - vcf and gff
We have a comparison between a number of different fly cell lines. These are found in a huge vcf file (dgrp2.vcf). We also have the annotations in a gff3 file (Drosophila_melanogaster.BDGP6.28.101.chr.gff3) and the genome itself in a fasta file.

## Getting the RAW files

### The annotation of the fly genome:
Find the GFF3 [here](https://tinyurl.com/y2opo93p "Drosophila_melanogaster.BDGP6.28.101.chr.gff3").

### The genome sequence used in this project:
The genome is located [here](https://tinyurl.com/yyldprwp "Drosophila_melanogaster.BDGP6.28.dna.toplevel.fa").

### The comparison of all the variants in the cell lines in the freeze project.
Finally, [here](http://dgrp2.gnets.ncsu.edu/data.html "dgrp2.vcf") is the VCF file.


!>`cat dgrp2.vcf | grep -v "#" | awk 'function abs(x){return ((x < 0.0) ? -x : x)} {if (length($4)>1||length($5)>1){a="INDEL";b=length($4)-length($5);cnt[b]+=1;} else {a="SNP";b="-";} printf("%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, a, b, $4, $5) > "indels_dgrp2";}END{for (x in cnt){print x,cnt[x] > "distr_dgrp2"}}' & awk 'FNR==NR{a[$1,$2]="T"; next}{ hits=0; for(N=$4; N<=$5; N++) { if (a[$1,N] == "T") {hits+=1}} if (hits>0) {print hits "\t" $0 > "haveSNPINDEL.gff"} else {print $0 > "noSNPINDEL.gff"}}' indels_dgrp2 Drosophila_melanogaster.BDGP6.28.101.chr.gff3 &`

Too much time (10h) - Make sure you have the latest awk, and also think about prallelisation.

#### For readability:

`awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' dgrp2.vcf > dgrp2_trimmed.vcf &`

1. extract chr4:

    `awk '/^4/{print $0}' Drosophila_melanogaster.BDGP6.28.101.chr.gff3 > Drosophila_melanogaster.chr4.gff3`

    `awk '/^4/{print $0}' dgrp2_trimmed.vcf > dgrp2_chr4.vcf`

2. Get distribution of variants and list them in two separate files:

    `cat dgrp2_chr4.vcf | grep -v "#" | awk 'function abs(x){return ((x < 0.0) ? -x : x)} {if (length($4)>1||length($5)>1){a="INDEL";b=length($4)-length($5);cnt[b]+=1;} else {a="SNP";b="-";} printf("%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, a, b, $4, $5) > "indels_Drosophila_chr4";}END{for (x in cnt){print x,cnt[x] > "distr_Drosophila_chr4"}}'`

3. Compare back and separate the annotation into features that do and don’t have variants:

    `awk 'FNR==NR{a[$1,$2]="T"; next}{ hits=0; for(N=$4; N<=$5; N++) { if (a[$1,N] == "T") {hits+=1}} if (hits>0) {print hits "\t" $0 > "haveSNPINDEL_Drosophila_chr4.gff"} else {print $0 > "noSNPINDEL_Drosophila_chr4.gff"}}' indels_Drosophila_chr4 Drosophila_melanogaster.chr4.gff3`

4. Great, now we can do the same for the SNPs themselves, to see which are actually located inside genes

    `awk 'FNR==NR{ingene[$1,$4]=$5; next}{sats="Not in gene";for (pair in ingene) {split(pair, t, SUBSEP); if ($1==t[1] && $2>=t[2] && $2<=ingene[t[1],t[2]]) {sats=(t[1] " " t[2] " " ingene[t[1],t[2]])}} print $0, " ", sats }' Drosophila_melanogaster.chr4.gff3 indels_Drosophila_chr4 > SNPsInGenes_Drosophila_ch4`

##### Oh, that didn’t work (look at output, everything is inside a (?), well not gene)

5. Filter for genes and possibly CDSs before doing the analysis.

    `awk '{if ($3=="gene" || $3=="CDS") print $0}' Drosophila_melanogaster.chr4.gff3 > Drosophila_melanogaster.chr4_genesCDSs.gff3`

#### Now:

`awk 'FNR==NR{ingene[$1,$4]=$5; next}{sats="Not in gene";for (pair in ingene) {split(pair, t, SUBSEP); if ($1==t[1] && $2>=t[2] && $2<=ingene[t[1],t[2]]) {sats=(t[1] " " t[2] " " ingene[t[1],t[2]])}} print $0, " ", sats }' Drosophila_melanogaster.chr4_genesCDSs.gff3 indels_Drosophila_chr4 > SNPsInGenes_Drosophila_ch4`

Here we can see all SNPs and INDELs which are inside a relevant region.
