# POSCAR: reorder atom types
This study case is designed to illustrate a combination of awk features while solving an easy to describe problem but painfully annoying to program. It contains only the basic functionality and does not check for error,  does not handle some exceptions in the File format etc.

[POSCAR](https://www.vasp.at/wiki/index.php/POSCAR) is an text format structure input file for the [VASP](https://www.vasp.at/) computational code. It defines the lattice geometry and the ionic positions. A limitation of the format is that the positions of the ions cannot be provided in random order, which makes the task of reordering them particularly unpleasant. Nowadays one can find tools to do this, but here we pick the case for the purpose of the workshop.

!!! note "POSCAR"
    ``` linenums="1"
    MgOH2                                   
        1.000000000000000     
         3.18083395988771     0.00000000000000      0.00000000000000  
        -1.59041697994386     2.75468301448513      0.00000000000000  
         0.00000000000000     0.00000000000000      4.76789525772412
      Mg O H
      1 2 2
    Direct
      0.0000000000000000  0.0000000000000000  0.000000000000
      0.3333333333300033  0.6666666666599994  0.219129582305 
      0.6666666666599994  0.3333333333300033 -0.219129582305 
      0.3333333333300033  0.6666666666599994  0.423195382917 
      0.6666666666599994  0.3333333333300033 -0.423195382917
    ```
 
The lines below `Direct` are the positions of the ions in order specified on line 6 - `Mg O H` . Yet, this is not enough, since on line 7 one gets the number of each ion type... The example above has 3 types and 5 ions in total and it is easier to manually fix the desired order. When this file contains more than 100 ions and several types, this simple routine becomes extremely dangerous, since any error is very difficult to spot.

Here we have a code that we can easily build interactively as exercise, but below each block is briefly described.

``` awk
#!/usr/bin/awk -f
BEGIN{
  argc= ARGC;
  ARGC=2 # just read the first file
}

NR<=5 {print} # print the part that does not change

NR==6 {
  Ntypes= NF;                           # Keep the number of different types
  for(i=1; i<=NF; i++){element[i]=$i}   # Make list with the elements
} 

NR==7 {for(i=1; i<=NF; i++){elementN[element[i]]=$i} } # count the number of elements

/Direct/ {
  for(i=1; i<=Ntypes;i++){                   # loop over the different types
    for(j=1; j<=elementN[element[i]]; j++){  # loop over the number of atoms for each type
      getline                                # get one line
      line[element[i],j]= $0                 # keep the whole line,[atom name, N]
    }
  }
}

END{
  for(i=1; i<=argc-2; i++){
    printf("%s ",ARGV[i+1])                  # print the new order
  }
  print ""                                   # print new line
  for(i=1; i<=argc-2; i++){
    printf("%s ",elementN[ARGV[i+1]])        # print the type numbers in the order
  }
  print ""                                   # print new line

  print "Direct"
  for(i=1; i<=argc-2; i++){
    atom= ARGV[i+1]
    for(j=1; j<=elementN[atom]; j++){
      print line[atom,j]
    }
  }
}
```

We will put a code that will read the provided file as first parameter and use the remaining to specify the new order of ions.

`#!awk BEGIN{...}` we need the original number of arguments, that is why we first `#!awk argc= ARGC;` Then we change the number of parameters to trick awk to read only the first argument `#!awk ARGC=2` .

`#!awk NR<=5 {print}` lines 1 to 5 does not need to be changed - so we print them.

`#!awk NR==6 {...}`  We need to know the number of different types Ntypes= NF and then make a index list with the labels of the elements.   

`#!awk NR==7 {...)` We match the number of elements for each type, so it becomes `#!awk elementN["Mg"]=1; elementN["O"]=2; elementN["H"]=2;`

`#!awk /Direct/ {...}` We have all the information to read the following lines with a double loop over each type and corresponding number. Done. We have each line indexed in a way that we can access them in a random order. The first line will look like `#!awk line["Mg",1]= 0.0000000000000000  0.0000000000000000  0.000000000000` . Note, we do not need to do anything but reorder the lines, so we keep them intact.

`#!awk END{...}` Time to fetch the new order from the command line and print in loops by calling the collected data.


Output
``` bash hl_lines="1"
./POSCAR-reorder.awk POSCAR H O Mg
MgOH2
    1.000000000000000
     3.18083395988771     0.00000000000000      0.00000000000000
    -1.59041697994386     2.75468301448513      0.00000000000000
     0.00000000000000     0.00000000000000      4.76789525772412
H O Mg
2 2 1
Direct
  0.3333333333300033  0.6666666666599994  0.423195382917
  0.6666666666599994  0.3333333333300033 -0.423195382917
  0.3333333333300033  0.6666666666599994  0.219129582305
  0.6666666666599994  0.3333333333300033 -0.219129582305
  0.0000000000000000  0.0000000000000000  0.000000000000
```

!!! question "Easy or not?"
    This might look complicated but it mostly contains for-loops that collect the data.  
    What could be an advantage then? 
    If you look, each block matches and operates only on the targeted lines - makes it a bit easier to split the problem to separate tasks.


