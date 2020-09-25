# Multiple output files
Here is a type of problem particularly suited for awk. 

Let's use the example with the coins again  and assume that the file is much larger and you want to print the data in separate files, named after the country and the year, for example "USA.1986.txt".

This will require to write into multiple files in different order. Most languages will require to open files (in append mode), assign file handles and closing it. If you want to avoid multiple opening/closing you need to handle the list of open files yourself. This puts some extra overhead that could be easily avoided in awk (_and all shells [bash, csh, tcsh] as long as I know_). It is as easy as writing:

``` awk
print "whatever you want" >  country"."year".txt"
print "whatever you want" >> country"."year".txt"
```

Here is an one line variant of it...
``` bash hl_lines="1"
$ awk '{print $0 > $4"."$3".txt"}' coins.txt
$ wc -l *.txt
   1 Austria-Hungary.1908.txt
   1 Canada.1988.txt
  13 coins.txt
   1 PRC.1986.txt
   1 RSA.1979.txt
   1 RSA.1981.txt
   1 Switzerland.1984.txt
   1 USA.1981.txt
   4 USA.1986.txt
   2 USA.1987.txt
  26 total
```

Awk can keep up to 1024 open files at the same time.

!!! warning
    The example above is not working under OS X . A simple fix is to store the file name in a variable before printing into it i.e.

!!! example "OS X version. It will work with Gnu Awk as well"
    ``` awk
    $ awk '{f=$4"."$3".txt"; print $0 > f }' coins.txt
    ```
    Credits to Ding He for the tip  
    original source: [http://stackoverflow.com/questions/7980325/splitting-a-file-using-awk-on-mac-os-x](http://stackoverflow.com/questions/7980325/splitting-a-file-using-awk-on-mac-os-x)

