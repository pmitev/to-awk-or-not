# Input/Output to an external program from within awk

## Reading output from external program
Awk has a way to read output from external programs. Here is an example where we will use only the BEGIN block in order to simplify the discussion.

!!! example "read_ext1.awk"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN{
      while ("lsb_release -a" | getline){
        print "awk:",$0
      }
    }
    ```

``` hl_lines="1"
$ ./read_ext1.awk
No LSB modules are available.
awk: Distributor ID:    Ubuntu
awk: Description:       Ubuntu 18.04.4 LTS
awk: Release:   18.04
awk: Codename:  bionic
```

!!! note
    `No LSB modules are available.` was sent to `/dev/stderr` by `lsb_release` and awk newer got to read it on first place.

!!! warning
    Kepp in mind that `getline` will read one line and store it in `$0` by replacing the content from the common lines read by awk. 
    To avoid this use `getline variablename` to store the line in new variable. [more...](https://www.gnu.org/software/gawk/manual/html_node/Getline.html)

!!! info
    Awk can `getline` directly from another file instead of the one that awk is currently reading - `getline < filename` [more...](https://www.gnu.org/software/gawk/manual/html_node/Getline.html)


This second variant will produce the same result, but also illustrates the use of `#!awk close()`. 

!!! example "read_ext2.awk"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN{
      cmd="lsb_release -a"
      while (cmd | getline){
        print "awk:",$0
      }
      close(cmd)
    }
    ```

!!! question
    What happens if you try to read the output second time without closing?

---

How about if we want to get only the `bionic` from the **Codename** (_ignore that you can request this by `lsb_release -c`_)  
This version will print only what we need.

!!! example "read_ext3.awk"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN{
      cmd="lsb_release -a"
      while (cmd | getline){
        if($1 == "Codename:") print $2
      }
      close(cmd)
    }
    ```

!!! note
    You need to redirect standard error to get the clean output.
    ``` hl_lines="1"
    $ ./read_ext3.awk 2> /dev/null
    bionic
    ```

## Sending data to external program (and reading the output)

These examples perhaps are not the best use but will illustrate how awk can send data to the standard input of an external program and read the produced output so you can use the data in your script. Awk does not have a function to find the [greatest common divisor](https://en.wikipedia.org/wiki/Greatest_common_divisor) but python has such function [math.gcd](https://docs.python.org/3/library/math.html#math.gcd) and we can use it by sending commands directly to python.

!!! example "gcd1.awk"
    ``` awk linenums="1"
    #!/usr/bin/awk -f
    BEGIN{ 
      print "import math; print(math.gcd(12,88))" | "python3"
    }
    ```

``` bash hl_lines="1"
$ ./gcd1.awk
4

```

This will simply send the commands to python and the output will be printed to standard output.  
**We want the result back**.

!!! example "gcd2.awk"
    ``` awk linenums="1"
    #!/usr/bin/awk -f
    BEGIN{
      cmd="python3"
      print "import math; print(math.gcd(12,88));" |& cmd
     
      close(cmd,"to")
     
      cmd |& getline
      print "awk:",$0
    }
    ```

There is a complication, though. Python is an interactive program and expects end of stream in order to preprocess the data or in many situations - to flush the input buffer.  
The solution to this is to call `#!awk close(cmd,"to")` function on line 6, deeply buried in the awk [documentation](https://www.gnu.org/software/gawk/manual/html_node/Two_002dway-I_002fO.html).

This last example covers more or less the most complicated situation. Usually one can get away with fewer lines. Note also that we `getline`-ed only once since we wanted only the first line in the output. This might not be the case and you might need to run `#!awk while` loop to read all lines.

---

Summary of the eight variants of getline, listing which predefined variables are set by each one, and whether the variant is standard or a gawk extension.

| Variant                 |Effect                       | awk / gawk |
|-------------------------|-----------------------------|------------|
| getline                 |Sets $0, NF, FNR, NR, and RT	| awk        |
| getline var             | Sets var, FNR, NR, and RT   | awk        |
| getline < file          |  Sets $0, NF, and RT        | awk        |
| getline var < file      | Sets var and RT             | awk        |
| command \| getline      | Sets $0, NF, and RT         | awk        |
| command \| getline var  | Sets var and RT             | awk        |
| command \|& getline     | Sets $0, NF, and RT         | gawk       |
| command \|& getline var | Sets var and RT             | gawk       |
