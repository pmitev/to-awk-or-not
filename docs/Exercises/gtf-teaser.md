# How to Analyze a Transcriptome Like a Pro

This is just a teaser for the full tutorial:  
[AWK GTF! How to Analyze a Transcriptome Like a Pro](http://reasoniamhere.com/2013/09/16/awk-gtf-how-to-analyze-a-transcriptome-like-a-pro-part-1/)

Let's use small file to exercise a bit with the content.

``` bash
$ wget https://raw.github.com/nachocab/nachocab.github.io/master/assets/transcriptome.gtf
```

> Hint: to get the line unwrapped in the terminal pipe the output to `less -S`

``` bash
$ head transcriptome.gtf | less -S
##description: evidence-based annotation of the human genome (GRCh37), version 18 (Ensembl 73)
##provider: GENCODE
##contact: gencode@sanger.ac.uk
##format: gtf
##date: 2013-09-02
chr1	HAVANA	exon	173753	173862	.	-	.	gene_id "ENSG00000241860.2"; transcript_id "ENST00000466557.2"; gene_type "processed_transcript"; gene_status "NOVEL"; gene_name "RP11-34P13.13"; transcript_type "lincRNA"; transcript_status "KNOWN"; transcript_name "RP11-34P13.13-001"; exon_number 1;  exon_id "ENSE00001947154.2";  level 2; tag "not_best_in_genome_evidence"; havana_gene "OTTHUMG00000002480.3"; havana_transcript "OTTHUMT00000007037.2";
chr1	HAVANA	transcript	1246986	1250550	.	-	.	gene_id "ENSG00000127054.14"; transcript_id "ENST00000478641.1"; gene_type "protein_coding"; gene_status "KNOWN"; gene_name "CPSF3L"; transcript_type "retained_intron"; transcript_status "KNOWN"; transcript_name "CPSF3L-006"; level 2; havana_gene "OTTHUMG00000003330.11"; havana_transcript "OTTHUMT00000009365.1";
chr1	HAVANA	CDS	1461841	1461911	.	+	0	gene_id "ENSG00000197785.9"; transcript_id "ENST00000378755.5"; gene_type "protein_coding"; gene_status "KNOWN"; gene_name "ATAD3A"; transcript_type "protein_coding"; transcript_status "KNOWN"; transcript_name "ATAD3A-003"; exon_number 13;  exon_id "ENSE00001664426.1";  level 2; tag "basic"; tag "CCDS"; ccdsid "CCDS31.1"; havana_gene "OTTHUMG00000000575.6"; havana_transcript "OTTHUMT00000001365.1";
chr1	HAVANA	exon	1693391	1693474	.	-	.	gene_id "ENSG00000008130.11"; transcript_id "ENST00000341991.3"; gene_type "protein_coding"; gene_status "KNOWN"; gene_name "NADK"; transcript_type "protein_coding"; transcript_status "KNOWN"; transcript_name "NADK-002"; exon_number 3;  exon_id "ENSE00003487616.1";  level 2; tag "basic"; tag "CCDS"; ccdsid "CCDS30565.1"; havana_gene "OTTHUMG00000000942.5"; havana_transcript "OTTHUMT00000002768.1";
chr1	HAVANA	CDS	1688280	1688321	.	-	0	gene_id "ENSG00000008130.11"; transcript_id "ENST00000497186.1"; gene_type "protein_coding"; gene_status "KNOWN"; gene_name "NADK"; transcript_type "nonsense_mediated_decay"; transcript_status "KNOWN"; transcript_name "NADK-008"; exon_number 2;  exon_id "ENSE00001856899.1";  level 2; tag "mRNA_start_NF"; tag "cds_start_NF"; havana_gene "OTTHUMG00000000942.5"; havana_transcript "OTTHUMT00000002774.3";
```

> The transcriptome has 9 columns. The first 8 are separated by tabs and look reasonable (chromosome, annotation source, feature type, start, end, score, strand, and phase), the last one is kind of hairy: it is made up of key-value pairs separated by semicolons, some fields are mandatory and others are optional, and the values are surrounded in double quotes. That’s no way to live a decent life. (*text copied from the source*)

let's get only the lines that have `gene` in the 3^th^ column.

``` bash
$ awk -F '$3 == "gene"' transcriptome.gtf | head | less -S

chr1    HAVANA  gene    11869   14412   .   +   .   gene_id "ENSG00000223972.4"; transcript_id "ENSG00000223972.4"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "DDX11L1"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "DDX11L1"; level 2; havana_gene "OTTHUMG00000000961.2";
chr1    HAVANA  gene    14363   29806   .   -   .   gene_id "ENSG00000227232.4"; transcript_id "ENSG00000227232.4"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "WASH7P"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "WASH7P"; level 2; havana_gene "OTTHUMG00000000958.1";
chr1    HAVANA  gene    29554   31109   .   +   .   gene_id "ENSG00000243485.2"; transcript_id "ENSG00000243485.2"; gene_type "lincRNA"; gene_status "NOVEL"; gene_name "MIR1302-11"; transcript_type "lincRNA"; transcript_status "NOVEL"; transcript_name "MIR1302-11"; level 2; havana_gene "OTTHUMG00000000959.2";
chr1    HAVANA  gene    34554   36081   .   -   .   gene_id "ENSG00000237613.2"; transcript_id "ENSG00000237613.2"; gene_type "lincRNA"; gene_status "KNOWN"; gene_name "FAM138A"; transcript_type "lincRNA"; transcript_status "KNOWN"; transcript_name "FAM138A"; level 2; havana_gene "OTTHUMG00000000960.1";
chr1    HAVANA  gene    52473   54936   .   +   .   gene_id "ENSG00000268020.2"; transcript_id "ENSG00000268020.2"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "OR4G4P"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "OR4G4P"; level 2; havana_gene "OTTHUMG00000185779.1";
chr1    HAVANA  gene    62948   63887   .   +   .   gene_id "ENSG00000240361.1"; transcript_id "ENSG00000240361.1"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "OR4G11P"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "OR4G11P"; level 2; havana_gene "OTTHUMG00000001095.2";
chr1    HAVANA  gene    69091   70008   .   +   .   gene_id "ENSG00000186092.4"; transcript_id "ENSG00000186092.4"; gene_type "protein_coding"; gene_status "KNOWN"; gene_name "OR4F5"; transcript_type "protein_coding"; transcript_status "KNOWN"; transcript_name "OR4F5"; level 2; havana_gene "OTTHUMG00000001094.1";
chr1    HAVANA  gene    89295   133566  .   -   .   gene_id "ENSG00000238009.2"; transcript_id "ENSG00000238009.2"; gene_type "lincRNA"; gene_status "NOVEL"; gene_name "RP11-34P13.7"; transcript_type "lincRNA"; transcript_status "NOVEL"; transcript_name "RP11-34P13.7"; level 2; havana_gene "OTTHUMG00000001096.2";
chr1    HAVANA  gene    89551   91105   .   -   .   gene_id "ENSG00000239945.1"; transcript_id "ENSG00000239945.1"; gene_type "lincRNA"; gene_status "NOVEL"; gene_name "RP11-34P13.8"; transcript_type "lincRNA"; transcript_status "NOVEL"; transcript_name "RP11-34P13.8"; level 2; havana_gene "OTTHUMG00000001097.2";
chr1    HAVANA  gene    131025  134836  .   +   .   gene_id "ENSG00000233750.3"; transcript_id "ENSG00000233750.3"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "CICP27"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "CICP27"; level 1; tag "pseudo_consens"; havana_gene "OTTHUMG00000001257.3";
```

Perhaps filter a bit more and print the content of the 9^th^ column in the file.

``` bash
$ awk -F "\t" '$3 == "gene" { print $9 }' transcriptome.gtf | head | less -S

gene_id "ENSG00000223972.4"; transcript_id "ENSG00000223972.4"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "DDX11L1"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "DDX11L1"; level 2; havana_gene "OTTHUMG00000000961.2";
gene_id "ENSG00000227232.4"; transcript_id "ENSG00000227232.4"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "WASH7P"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "WASH7P"; level 2; havana_gene "OTTHUMG00000000958.1";
gene_id "ENSG00000243485.2"; transcript_id "ENSG00000243485.2"; gene_type "lincRNA"; gene_status "NOVEL"; gene_name "MIR1302-11"; transcript_type "lincRNA"; transcript_status "NOVEL"; transcript_name "MIR1302-11"; level 2; havana_gene "OTTHUMG00000000959.2";
gene_id "ENSG00000237613.2"; transcript_id "ENSG00000237613.2"; gene_type "lincRNA"; gene_status "KNOWN"; gene_name "FAM138A"; transcript_type "lincRNA"; transcript_status "KNOWN"; transcript_name "FAM138A"; level 2; havana_gene "OTTHUMG00000000960.1";
gene_id "ENSG00000268020.2"; transcript_id "ENSG00000268020.2"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "OR4G4P"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "OR4G4P"; level 2; havana_gene "OTTHUMG00000185779.1";
gene_id "ENSG00000240361.1"; transcript_id "ENSG00000240361.1"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "OR4G11P"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "OR4G11P"; level 2; havana_gene "OTTHUMG00000001095.2";
gene_id "ENSG00000186092.4"; transcript_id "ENSG00000186092.4"; gene_type "protein_coding"; gene_status "KNOWN"; gene_name "OR4F5"; transcript_type "protein_coding"; transcript_status "KNOWN"; transcript_name "OR4F5"; level 2; havana_gene "OTTHUMG00000001094.1";
gene_id "ENSG00000238009.2"; transcript_id "ENSG00000238009.2"; gene_type "lincRNA"; gene_status "NOVEL"; gene_name "RP11-34P13.7"; transcript_type "lincRNA"; transcript_status "NOVEL"; transcript_name "RP11-34P13.7"; level 2; havana_gene "OTTHUMG00000001096.2";
gene_id "ENSG00000239945.1"; transcript_id "ENSG00000239945.1"; gene_type "lincRNA"; gene_status "NOVEL"; gene_name "RP11-34P13.8"; transcript_type "lincRNA"; transcript_status "NOVEL"; transcript_name "RP11-34P13.8"; level 2; havana_gene "OTTHUMG00000001097.2";
gene_id "ENSG00000233750.3"; transcript_id "ENSG00000233750.3"; gene_type "pseudogene"; gene_status "KNOWN"; gene_name "CICP27"; transcript_type "pseudogene"; transcript_status "KNOWN"; transcript_name "CICP27"; level 1; tag "pseudo_consens"; havana_gene "OTTHUMG00000001257.3";
```

What about if we want just a specific piece from this information?
We can `|` the output from the first awk script in to a second one. Note that we will use different field separator `"; "`.

``` bash
$ awk -F "\t" '$3 == "gene" { print $9 }' transcriptome.gtf | awk -F "; " '{ print $3 }' | head

gene_type "pseudogene"
gene_type "pseudogene"
gene_type "lincRNA"
gene_type "lincRNA"
gene_type "pseudogene"
gene_type "pseudogene"
gene_type "protein_coding"
gene_type "lincRNA"
gene_type "lincRNA"
gene_type "pseudogene"
```

At this point I will suggest to follow the original tutorial:  
[AWK GTF! How to Analyze a Transcriptome Like a Pro](http://reasoniamhere.com/2013/09/16/awk-gtf-how-to-analyze-a-transcriptome-like-a-pro-part-1/)
