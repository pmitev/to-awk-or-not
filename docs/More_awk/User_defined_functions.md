# User defined functions

> Related Awk [documentation](https://www.gnu.org/software/gawk/manual/html_node/User_002ddefined.html)

Usually at this point (_looking on how to write own functions_) you have a working script (_I doubt you want to do this on one line_) and you want to wrap your repetitive task in a function call...  
The User defined function syntax is as follows

``` awk
function name([parameter-list])
{
  body-of-function

  [return variable] 
}
```

Here is a simple example.  
It is rather surprising but awk dows not have funtion to return athe absolute value of a number.

``` awk
function abs(x){
  if (x >= 0) return x
  else return -x
}
```

or 

``` awk
function abs(x)  { return (x >= 0) ? x : -x }
```

---
Here is another example from one of the study cases [Gaussian smearing](../Case_studies/Gaussian_smearing.md)  
[Gaussian funtion](https://en.wikipedia.org/wiki/Gaussian_function). I have used $x_0$ instead of $b$ for the peak center. 

``` awk
function gauss(x0,x,c){
  area=1;
  if ((x-x0)**2 < 10000) { return  area*exp(-(((x-x0))**2)/(2.*c**2))}
  else {return 0.0}
}
```

The function returns the value for the Gaussian for a point $x$ away from the center. For large $(x-x0)^2$ the `exp()` was crashing, so I needed to add a condition which makes sure that for these very large numbers the function does not call the `exp(...)` but returns directly `0.0` instead. The function is called within a double loop on line 23

``` awk linenums="23"
      data[i]= data[i] + gauss(freq[f],i,FWHM);
```

!!! warning
    It's entirely fair to say that the awk syntax for local variable definitions is appallingly awful.  
    - _Brian Kernighan_ [source](https://www.gnu.org/software/gawk/manual/html_node/Definition-Syntax.html)
