# Multiple input files - first approach

> The script will collect the data in sequence and store the data in memory, then print the arranged data at the end.

Here is an example problem that is easy to solve with awk. 


Let's assume that we have collected some data about some persons. It is not systematic, so the data files are not complete and rows are not in the same order... 

!!! note "file: 1.dat"
    ```
    Daniel    10
    Anders     7
    Sven      56
    Ali       17
    Peter      6
    ```

!!! note "file: 2.dat"
    ```
    Peter     Monday
    Sven      Sunday
    David     Tuesday
    ```

Let's put them together!
If the files had all names with missing data marked - sorting the files and pasting them together will essentially be enough. 

Below, it is just one possible way to do it. First we need to have a list of all names, collect the data, then try to print whatever we have collected.

!!! warning
    awk under OS X is not fully compatible with Gawk (GNU awk) and the internal variable `#!awk ARGIND` is not available - the script will not work as intended.

!!! example "script.awk"
    ``` awk
    #!/usr/bin/awk -f

    { 
      data[$1][ARGIND]= $2
    }
    
    END {
      for (i in data) print i"\t"data[i][1]"\t"data[i][2]
    }
    ```

Run the script like this:

``` bash
./script.awk 1.dat 2.dat`
```

The script runs over the two files in a row and on each line it uses associative arrays to collect the names from the first column in `#!awk names[$1]`.
`#!awk data[$1][ARGIND]` is two dimensional array with indexes [name][ number of current file/argument]. At the end we will have elements like this:

``` awk
...
data["Sven"][1] = 56
data["Sven"][2] = "Sunday"
...
```

The `#!awk END` section runs over the collected names and prints the collected data - so we recover as much as possible from both files.

Here is the output.
```
Anders          7
Daniel          10
Ali             17
Sven            56              Sunday
David                           Tuesday
Peter           6               Monday
```


Alternative, perhaps better solution in this case, might the specially written tool for this purpose i.e.

``` bash hl_lines="1"
$ join -a1 -a2  -j 1 -o 0,1.2,2.2 -e "NULL"   <(sort 1.dat)  <(sort 2.dat)
Ali 17 NULL
Anders 7 NULL
Daniel 10 NULL
David NULL Tuesday
Peter 6 Monday
Sven 56 Sunday
```

!!! note
    Note that the files need to be sorted by the field they will be joined, since the program is trying to avoid loading the whole data in the memory. If the data is sorted, awk also can join the data without loading it into the memory.
    [http://unix.stackexchange.com/questions/194968/why-isnt-this-awk-command-doing-a-full-outer-join](http://unix.stackexchange.com/questions/194968/why-isnt-this-awk-command-doing-a-full-outer-join)  
    _Credits to Mahesh Panchal for the tip_

## Exercise

Copy/paste the text in to two files with the suggested names

`scientific`
```
2       |       Bacteria        |       Bacteria <bacteria>     |       scientific name |
29      |       Myxococcales    |               |       scientific name |
139     |       Borreliella burgdorferi |               |       scientific name |
161     |       Treponema pallidum subsp. pallidum      |               |       scientific name |
168     |       Treponema pallidum subsp. pertenue      |               |       scientific name |
356     |       Rhizobiales     |               |       scientific name |
638     |       Arsenophonus nasoniae   |               |       scientific name |
```

`genbank`
```
2       |       eubacteria      |               |       genbank common name     |
29      |       fruiting gliding bacteria       |               |       genbank common name     |
139     |       Lyme disease spirochete |               |       genbank common name     |
161     |       syphilis treponeme      |               |       genbank common name     |
168     |       yaws treponeme  |               |       genbank common name     |
356     |       rhizobacteria   |               |       genbank common name     |
638     |       son-killer infecting Nasonia vitripennis        |               |       genbank common name     |
```

Can you join the information from both files to collect the data in better format?

`ID | scientific name | genbank common name`

```
2 | Bacteria | eubacteria
29 | Myxococcales | fruiting gliding bacteria
139 | Borreliella burgdorferi | Lyme disease spirochete
```

Leave the extra blanks for the first attempt. We will use this problem (cleaning the remaining spaces before and after) to introduce user defined functions.

!!! hint
    Using `FILENAME` might come handy.

??? "Possible solution"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN{ FS="|" }
    
    {
      data[$1][FILENAME]= $2
    }
    
    END {
      for (i in data) print trim(i)"|"trim(data[i]["scientific"])"|"trim(data[i]["genbank"])
    }
    
    function trim (x) {
      sub(/^[ \t]*/,"",x);
      sub(/[ \t]*$/,"",x);
      return x
    }
    ```

??? "Solution usung join suggested by Amrei Binzer-Panchal, 2021.01.18" 
    ``` bash
    $ join -a1 -a2  -j 1 -o 0,1.2,2.2 -e "NULL" -t "|"  <(sort scientific)  <(sort genbank)

    139     |       Borreliella burgdorferi |       Lyme disease spirochete 
    161     |       Treponema pallidum subsp. pallidum      |       syphilis treponeme      
    168     |       Treponema pallidum subsp. pertenue      |       yaws treponeme  
    2       |       Bacteria        |       eubacteria      
    29      |       Myxococcales    |       fruiting gliding bacteria       
    356     |       Rhizobiales     |       rhizobacteria   
    638     |       Arsenophonus nasoniae   |       son-killer infecting Nasonia vitripennis 
    ```
