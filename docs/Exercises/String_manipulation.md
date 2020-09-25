# String manipulation **
This exercise is not specific for awk, but I keep getting questions of this kind, since it is rather common situation.
Anyway, if this is what you find interesting, here are few task that will require you to read a bit on how to use the [special formatting](https://www.gnu.org/software/gawk/manual/html_node/Format-Modifiers.html). Feel free to look in the answers and decode the code.

Let us use the following file.

!!! note "strfunc.dat"
    ```
    Daniel    10.32
    Anders    7.44
    Sven      56.898
    Ali      -17.2
    Peter      6
    ```

## Task 1

Write an awk script that aligns the data in such way.

```
Daniel     10.320
Anders      7.440
Sven       56.898
Ali       -17.200
Peter       6.000
```

??? "Posible solution"
    ``` awk
    $ awk '{printf("%-10s%7.3f\n",$1,$2) }' strfunc.dat
    ```
## Task 2

There is away to align without taking into account the sign...

```
Daniel    10.320
Anders    7.440
Sven      56.898
Ali      -17.200
Peter     6.000
```

??? "Posible solution"
    ``` awk
    $ awk '{printf("%-7s  % .3f\n",$1,$2) }' strfunc.dat
    ```

## Task 3

Can you modify the script so you get this form which preserves the original data and formatting, but still makes it more readable.
```
 Daniel  10.32
 Anders  7.44
   Sven  56.898
    Ali  -17.2
  Peter  6
```

??? "Posible solution"
    ``` awk
    $ awk '{printf("%7s  %-7s\n",$1,$2) }' strfunc.dat
    ```

## Task 4

Can you use the data to compose strings like this?
```
Dan+10.320
And+7.440
Sve+56.898
Ali-17.200
Pet+6.000
```

??? "Posible solution"
    ``` awk
    $ awk '{printf("%.3s%+.3f\n",$1,$2) }' strfunc.dat
    ```

