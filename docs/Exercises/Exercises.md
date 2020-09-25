# Exercises - warming up

## Task 1. Make an awk script to calculate:

a) sum of the values  
b) the average i.e arithmetic mean value (can you write the script so it is independent from the number of rows)  
c) find the maximum value  
d) calculate the difference between numbers in the first column, i.e 2nd-1st, 3rd-2nd etc.

Copy/paste the numbers in a file for convenience.

!!! note "num.dat"
    ```text
    2
    4
    8
    9
    7
    3
    ```

??? "Possible solutions"
    1.a)
    ``` awk
    $ awk '{sum= sum+$1} END{print sum}' num.dat
    33
    ```
    
    1.b)
    ``` awk
    $ awk '{sum= sum+$1} END{print sum/NR}' num.dat
    5.5
    ```
    
    1.c) NR==1 {max=$1} makes sure that you have reasonable initial value. What could go wrong if you skip it?
    ``` awk
    $ awk 'NR==1 {max=$1}  {if (max < $1) max=$1}  END{print max}' num.dat
    9
    ```
    
    1.d) Possible solution (notice that the first number is the value of the first column):
    ``` awk
    $ awk '{print $1-prev;prev=$1}' num.dat
    2
    2
    4
    1
    -2
    -4
    ```
    
    Can you improve the script to avoid the problem with the first line?


## Task 2. Providing you have the following data

!!! note "10.dat"
    ``` text
    67
    4
    33
    53
    21
    99
    88
    69
    79
    8
    ```

Can you write a script to print the cumulative sum i.e. on each row, next to the original value, you print the sum of all above values?

Output:
``` text
67 67
4 71
33 104
53 157
21 178
99 277
88 365
69 434
79 513
8 521
```

??? "Possible solution"
    ``` awk
    $ awk '{sum=sum+$1; print $1,sum}' 10.dat
    ```
