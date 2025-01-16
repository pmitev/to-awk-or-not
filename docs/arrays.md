# Awk arrays

Here is a simple array definition and a way to scan its elements.

```awk
#!/usr/bin/awk -f
BEGIN { 
  D["a"]="A"
  D["b"]="B"
  D["c"]="C"
  
  for (i in D){        # loop over the  index
    print i" : "D[i]
  }
}
```

Output:
```
a : A
b : B
c : C
```
> Note: by default, when a for loop traverses an array, the order is undefined, meaning that the awk implementation determines the order in which the array is traversed. This order is usually based on the internal implementation of arrays and will vary from one version of awk to the next.. Here is how to sort them [Predefined Array Scanning order](https://www.gnu.org/software/gawk/manual/html_node/Controlling-Scanning.html)

## Multidimensional arrays - [docs](https://www.gnu.org/software/gawk/manual/html_node/Multidimensional.html)
A multidimensional array is an array in which an element is identified by a sequence of indices instead of a single index. For example, a two-dimensional array requires two indices. The usual way (in many languages, including awk) to refer to an element of a two-dimensional array named grid is with `grid[x,y]`.

```awk
#!/usr/bin/awk -f      
BEGIN {                
  D["a","A"]="aA"     
  D["a","B"]="aB"     
  D["a","C"]="aC"     
                       
  D["b","A"]="bA"     
                       
  for (i in D){        # loop over the first index
    print i" : "D[i]
    print "--------"   
  }                    
}
```
Output:
```
aA : aA
--------
aB : aB
--------
aC : aC
--------
bA : bA
--------
```

> If you look carefully, `i` iterates over an index that is a string concatenated of both indexes. In other words, the combined string is used as a single index into an ordinary, one-dimensional array. This makes it somewhat dificult to iterate ovet the second index... but could be used in some specific solutions like [Manipulating the output from a genome analysis - vcf and gff](./Case_studies/manipulating_vcf.md).

## Array of arrays - [docs](https://www.gnu.org/software/gawk/manual/html_node/Arrays-of-Arrays.html)

The so called "Array of Arrays" implementation is easier for scanning (iterating) than the above  [multidimensional array](https://www.gnu.org/software/gawk/manual/html_node/Multidimensional.html) implementation.

```awk
#!/usr/bin/awk -f
BEGIN { 
  D["a"]["A"]="aA"
  D["a"]["B"]="aB"
  D["a"]["C"]="aC"
  
  D["b"]["A"]="bA"

  for (i in D){                    # loop over the first  index
    for (j in D[i])                # loop over the second index
      print i","j" : "D[i][j]
    print "--------"
  }
}
```
Output
```
a,A : aA
a,B : aB
a,C : aC
--------
b,A : bA
--------
```

## More

If you want to learn or just check what other "tricks" one could do with arrays in Awk, here a suggested tutorial on the topic - look for "AWK tips and tricks" section on the page.

!!! quote 
    AWK arrays appear only rarely online in tutorials, and I found myself  guilty of using arrays on my data blog ([https://www.datafix.com.au/BASHing/](https://www.datafix.com.au/BASHing/)) as though I was assuming that every reader was comfortable with them.

    This is not true, of course, so I wrote a 4-part series on the blog explaining how they work and how you can use them (see the "AWK tips and tricks" section of the Bashing data index page). One reader wrote me to say the articles had clarified for him how arrays work and he now felt more confident - always good feedback!

    Please feel free to link to those articles on your AWK site, or use them as models for your own tutorial work.

    Dr Robert Mesibov  
    West Ulverstone, Tasmania, Australia 7315
