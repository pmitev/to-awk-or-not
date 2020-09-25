# Discrete histogram
This is an improved version of the script that was mentioned in the introduction of the task to count the countries in the coin.txt file. The usual [histogram](https://en.wikipedia.org/wiki/Histogram) is a graphical representation of the distribution of numerical data. That also implies that you have regular intervals for the range of the data. 
What if you want statistics over Months, days or any text - yes it is possible - remember the coins?

It uses an **undocumented feature** that is rather useful. Here is the code, always check with the attached file which should contain the latest version.

``` awk
#!/usr/bin/awk -f
BEGIN {
  if (!col) col=1
}

{
  counts[$(col)]++;
  total++;
}

END {
  for (v in counts) {
    printf "%s %.0f %f \n", v, counts[v], counts[v]/0.01/total ;
  }
}
```

Simply running the script over the file with the data (coins.txt) will calculate the distribution over the first column.

``` bash
$ ./histogram-discrete.awk coins.txt
silver 4 30.769231
gold   9 69.230769
```

This finds that there are 4 silver coins and 9 gold in the file. The last column is the percentage.

Now, for the trick (special thanks to my colleague Douglas Scofield for introducing me to this trick). If you add col=4 before the name of the input file it will be interpreted as variable assignment (providing that you do not have a file with this name ;-)). Here is the result - nothing is changed in the script.

``` bash
$ ./histogram-discrete.awk col=4 coins.txt
Switzerland     1  7.692308
Canada          1  7.692308
Austria-Hungary 1  7.692308
PRC             1  7.692308
RSA             2 15.384615
USA             7 53.846154
```

The official documentation says that you should write `-v col=4` or `--assign=col=4` so, keep this in mind. Notice that the output has no particular order. In the latest awk versions there is a way to force a particular order to the output but this is something I leave to you. You can always pipe the output via sort.

!!! example "Files"
    * [coins.txt](../data/coins.txt)
    * [histogram-discrete.awk](../data/histogram-discrete.awk)

