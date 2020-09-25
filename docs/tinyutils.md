# Tiny utilities by Douglas Scofield

[https://github.com/douglasgscofield/tinyutils](https://github.com/douglasgscofield/tinyutils)

Tiny scripts that work on a single column of data. Some of these transform a single column of their input while passing everything through, some produce summary tables, and some produce a single summary value. All (so far) are in awk, and all have the common options `#!awk header=0` which specifies the number of header lines on input to skip, `#!awk skip_comment=1` which specifies whether to skip comment lines on input that begin with `#!awk #`, and `#!awk col=1`, which specifies which column of the input stream should be examined. Since they are awk scripts, they also have the standard variables for specifying the input field separator `#!awk FS="\t"` and the output field separator `#!awk OFS="\t"`. Default output column separator is`#!awk "\t"`.

Set any of these variables by using `#!awk key=value` on the command line. For example to find the median of the third column of numbers, when the first 10 lines of input are header:

```bash
$ median col=3 header=10 your.dat
```

Stick these in a pipeline that ends with [spark](https://github.com/holman/spark) for quick visual summaries. If `indels.vcf.gz` is a compressed [VCF](http://www.1000genomes.org/wiki/Analysis/Variant%20Call%20Format/vcf-variant-call-format-version-41) file containing indel calls, then this will print a sparkline of indel sizes in the range of ±10bp:

``` bash
$ zcat indels.vcf.gz \
| stripfilt \
| awk '{print length($5)-length($4)}' \
| inrange abs=10 \
| hist \
| cut -f2 \
| spark
▁▁▁▁▁▁▁▁▂█▁▇▂▁▁▁▁▁▁▁▁
```

We get the second column of **hist** output because that's the counts. This clearly shows the overabundance of single-base indels, and a slight overrepresentation of single-base deletions over insertions.

...

_Please, visit the Git repository for complete documentation and up to date sources:_
[https://github.com/douglasgscofield/tinyutils](https://github.com/douglasgscofield/tinyutils)
