# Trick to pass parameters on the command line

The common way to pass options and parameters to an Awk script is via the awk option `-v varname=value` 

```  bash
$ script.awk -v variablename1=value2 -v variablename=value2 filename1 filename2
```

This is really flexible and has many advantages, but in most cases, you want to use something more common - positional parameters i.e. something like this

``` bash
$ script.awk filename parameter1 parameter2
```

Without some precautions, parameter1 and parameter2 will be treated as file names...

When Awk starts, the information from the command line will be stored in two internal variables `#!awk ARGV` - array with argument values and `#!awk ARGC` - scalar variable with the count of elements in `#!awk ARGV`. `#!awk ARGV[0]` will contain the name of the script itself (`script.awk` in this example), `#!awk ARGV[1]` - the name of the first file on the command line etc.

``` awk
ARGV[0]="script.awk"
ARGV[1]="filename"
ARGV[2]="parameter1"
ARGV[3]="parameter2"

ARGC=4
```

Essentially, awk starts to read files with names taken from the elements of the `#!awk ARGV` array - except for `#!awk ARGV[0]`.  
Here is the neat **trick** - if you change the value `#!awk ARGC=2`, awk will "think" that there are only 2 elements - program name and first file and run the loop as usual for these 2 elements i.e. reading only `filename`. Without any surprise, the values in `#!awk ARGV` continue to be available...

!!! note "input.dat"
    ```
    1 2
    3 4
    5 6
    7 8
    ```
!!! example "add_to_columns.awk"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN {ARGC=2}

    {print $1+ARGV[2],$2+ARGV[3]}
    ```


``` bash
$ ./add_to_column.awk input.dat 1 2
2 4
4 6
6 8
8 10
```

This "trick" could be used in other ways - [Rereading the Current File](https://www.gnu.org/software/gawk/manual/html_node/Rewind-Function.html), changing the name of the next file to read as well (if you want) etc.

