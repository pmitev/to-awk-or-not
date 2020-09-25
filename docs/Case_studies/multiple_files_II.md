# Multiple input files - second approach
Let's have the same input data as in the [previous case](./multiple_files_I.md), but this time, for each line in the first file we will read the second file and look for a match. For large files, this will be significantly slower than the first case since we will read multiple times the second file, but this approach reduces the memory requirement, since at no point we need to load both files into memory like in the first case. In fact this approach needs to keep only one line per file in the memory at he same time.

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

Let's start with simple working example, that we will improve later.
!!! example "script1.awk"
    ``` awk
    #!/usr/bin/awk -f
    
    NR == FNR {
      printf("%s  ",$0)
      while(getline line < ARGV[2]){
        split(line,data)
        if(data[1]==$1) printf("%s  ",data[2])
      }
      close(ARGV[2])
      print ""
    }
    ```


Awk will read both files in order. While `#!awk FNR` will count the line number with respect to the current file, `#!awk NR` will count the concatenated number lines i.e. `#!awk NR == FNR` ensures that awk will run the code block only on the first file. Unfortunately, awk will read the second file anyway - as designed juts to find no match...

`#!awk printf("%s  ",$0)` will print the content of the line from the first file and add 2 spaces without the new line.

`#!awk while(getline line < ARGV[2])` loop will be executed on each line for the first file. It will read one line from the second file per loop and store it in line variable.

`#!awk split(line,data)` this time we need to split it manually in data array variable.

`#!awk if(data[1]==$1) printf( data[2])` we print what we find in second column only if we match the values for the first.

`#!awk close(ARGV[2])` we need to close the second file to be able to start reading from the beginning next time.

`#!awk print ""`  regardless if we found match or not, we print the new line character.

Output
``` awk hl_lines="1"
$ ./script1.awk 1.dat 2.dat
Daniel    10
Anders     7
Sven      56  Sunday
Ali       17
Peter      6  Monday
```
!!! warning
    Note that only names from the first file were processed i.e. the data for David will not appear in the output.


## Second round
---
The above solution works but for large files this is rather inefficient, let's improve a bit the code.

!!! note "script2.awk"
    ``` awk
    #!/usr/bin/awk -f
    
    FNR != NR {exit 0}
    
    {
      printf("%s  ",$0)
      while(getline line < ARGV[2]){
        split(line,data)
        if(data[1]==$1) { printf("%s  ",data[2]); break }
      }
      close(ARGV[2])
      print ""
    }
    ```

Only two changes: 

`#!awk FNR != NR {exit 0}` serves the same purpose but this time matches when we start reading the next file and exits the program preventing awk from reading the second file.

`#!awk if(data[1]==$1) { printf( data[2]); break }` we added the brake statement, when we have found the first match from the second file, the program will exit the while loop i.e. will not read the remaining of the second file. 

!!! warning
    This was made under the assumption that you have only one unique entry for each name in the second file. Several year ago, during the exercises, while gradually building the code, the first version of this solution was able to find multiple entries in the second file (real life problem) which exposed a problem with the data that was not identified before. 

On small files speed up will not be noticeable, but it will be significant on large files. Note: this problem is rather general, not awk specific.


## Third round
---
Now, what happens if we have more files? One reference and multiple matching files?
Let's make an improved version which will demonstrate some other interesting and handy awk features.


!!! note "script3.awk"
    ``` awk
    #!/usr/bin/awk -f
    
    BEGIN{argc=ARGC; ARGC=2}
    
    {
      printf("%s  ",$0)
      for(i=2; i <= argc-1; i++){
        while(getline line < ARGV[i]){
          split(line,data)
          if(data[1]==$1) { printf("%s  ",data[2]); break }
        }
        close(ARGV[i])
      }
      print ""
    }
    ```

What awk is doing is storing the name of the program + all the filenames passed as arguments in `#!awk ARGV` array in which element 0 is the program's name itself then all the filenames in order. `#!awk ARGC` will contain the number of elements, so awk will loop reading through the files. The trick is if we change the `#!awk ARGC` to 2, then awk will loop only over the first file and stop. This make it easy to use the rest of the filenames as input parameters - they can be anything you want - they do not need to be real file names.   

`#!awk BEGIN{argc=ARGC; ARGC=2}` This is the best way to force reading only the first file. Since we need to know how many they were originally, we keep it in a argc before changing `#!awk ARGC=2`. 

`#!awk for(i=2; i <= argc-1; i++)` we manually loop over the remaining files with `#!awk ARGV[i]`.

Output
``` bash hl_lines="1"
$ ./script3.awk 1.dat 2.dat 2.dat 2.dat
Daniel    10
Anders     7
Sven      56  Sunday  Sunday  Sunday
Ali       17
Peter      6  Monday  Monday  Monday
```


