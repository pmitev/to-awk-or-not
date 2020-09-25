# Bioawk

Bioawk is an awk extension for biological formats written by [Dr. Heng Li](http://www.liheng.org/).  
See the documentation [here](https://github.com/lh3/bioawk/blob/master/README.md) .




## Install on MacOS with the Homebrew package manager

``` bash
$ brew install bioawk
```

## Conda

``` conda
conda install -c bioconda bioawk
```

## Install from source

``` bash
$ git clone git://github.com/lh3/bioawk.git
$ cd bioawk && make 

# Make sure that bioawk is in your $PATH or use the full path to call the executable.
```

:spiral_note_pad: Several tutorial on the net suggest installing it with `sudo` in you system path - no need for that. This is another way to say - avoid unnecessary (it is bad practice) installation of tools as root. You will not be able to do it on any computer center anyway. :closed_lock_with_key: 

If you get error about
```
...
make: yacc: Command not found
```

then you need install few packages (root privileges required)

``` bash
$ sudo apt-get install bison byacc
```

## Examples

### bioawk supported formats

``` bash
$ bioawk -c help

bed:
	1:chrom 2:start 3:end 4:name 5:score 6:strand 7:thickstart 8:thickend 9:rgb 10:blockcount 11:blocksizes 12:blockstarts 
sam:
	1:qname 2:flag 3:rname 4:pos 5:mapq 6:cigar 7:rnext 8:pnext 9:tlen 10:seq 11:qual 
vcf:
	1:chrom 2:pos 3:id 4:ref 5:alt 6:qual 7:filter 8:info 
gff:
	1:seqname 2:source 3:feature 4:start 5:end 6:score 7:filter 8:strand 9:group 10:attribute 
fastx:
	1:name 2:seq 3:qual 4:comment 
```

### We will use GTF and FASTA files for the chr17:7400001-7800000 region, downloaded using the [UCSC Table Browser](https://genome.ucsc.edu/cgi-bin/hgTables).

- `chr17_fragm.gtf`
- `chr17_fragm.fasta`

> use the file `chr17_fragm.gtf`

### Print the length of all the exons (end position - start position):

``` bash
$ bioawk -c gff  '$3 ~ /exon/ {print $seqname, $feature, $end-$start}' chr17_fragm.gtf | sort -nk3 
```

> use the file `chr17_fragm.fasta`

### Count the number of FASTA entries

``` bash
$ bioawk -c fastx 'END{print NR}' chr17_fragm.fasta
```

### Reverse complement the sequences

``` bash
$ bioawk -c fastx '{print ">"$name"\n"revcomp($seq)}' chr17_fragm.fasta > chr17_fragm.revcomp.fasta | head -n 2

$ head -n 2 chr17_fragm.fasta
$ head -n 2 chr17_fragm.revcomp.fasta
```

### Create a table with the sequence length in the FASTA file.

``` bash
$ bioawk -c fastx '{print $name,length($seq)}' chr17_fragm.fasta > chr17_fragm.fasta.seqlen | head -n 10 chr17_fragm.fasta.seqlen
$ head -n 10 chr17_fragm.fasta.seqlen
```
