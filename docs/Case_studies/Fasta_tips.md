# Fasta file format tips
With multi-fasta files, it is often required to extract few fasta sequences which contain the keyword/s of interest.
One fast way to do this, is by awk.

!!! note "data.fa"
    ```
    >Chr1
    ATCTGCTGCTCGGGCTGCTCTAT...
    >Chr2
    GTACGTCGTAGGACATGCATCG...
    >MT1
    TACGATCGATCAGCTCAGCATC...
    >MT2
    CGCCATGGATCAGCTACATGTA...
    ```

``` awk
$ awk 'BEGIN {RS=">"} /Chr2/ {print ">"$0}' data.fa
```

Note that in the `#!awk BEGIN` section of the script, we have redefined the internal variable for the record separator `#!awk RS=">"` which by default is "new line". This way, awk will treat the whole fasta (multi-line) record as one record. 

output:
```

>Chr2
GTACGTCGTAGGACATGCATCG...
```

example taken from: [link](https://infoplatter.wordpress.com/2013/10/15/extracting-specific-fasta-records-from-a-multi-fasta-file/comment-page-1/)
