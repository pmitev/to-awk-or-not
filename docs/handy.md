# Handy to have

[Awk reference card](http://xavi.ivars.me/arxius/manuals/awk/awkcard.pdf) (.pdf)

Here are some functions that are missing in awk and might come in handy to have... 
The functions have been collected from different sources or written by myself, so always make sure that they work as expected. Please, do not assume that they are always correct!

For more complete and up to date list with various functions, look here: [http://rosettacode.org/wiki/Category:AWK](http://rosettacode.org/wiki/Category:AWK)

``` awk
#==============================================
BEGIN {
  pi=3.14159265358979;
  rad2deg=180./pi
  Q = "\"";
   _ = SUBSEP;
  Inf    = 1.99999*(2**(127));
  NegInf = -1*2**(126);
  White="^[ \t\n\r]*$";
  Number="^[+-]?([0-9]+[.]?[0-9]*|[.][0-9]+)([eE][+-]?[0-9]+)?$";
}
#==============================================

function asin(a) { return atan2(a,sqrt(1-a*a)) }
function acos(a) { return pi/2-asin(a) }
function abs(x)  { return (x >= 0) ? x : -x }
function sgn(x)  { return (x == 0) ? 0 : ( (x > 0) ? 1 : -1  ) }
function coth(x) {  exp2x=exp(2.0*x);  return (exp2x + 1.0)/(exp2x -1.0) }

#vectors
function norm(x) {return (sqrt(x[1]*x[1]+x[2]*x[2]+x[3]*x[3]));}
function dotprod (x,y) {return ( x[1]*y[1] + x[2]*y[2] + x[3]*y[3] );}
function angle (v1,v2) {
  myacos = dotprod(v1,v2)/norm(v1)/norm(v2);
  if (myacos> 1.0) myacos =  1.0;
  if (myacos<-1.0) myacos = -1.0;
  return(acos(myacos)*180.0/pi);
}



# Printing

function barph(str) {print str>"/dev/tty"}
function die(str)   {barph(str); exit 1}

# Arrays
# These array store the size of the array in position C<Array[0]>.

function top(a) {return a[a[0]]}
function push(a,x,  i) {i=++a[0]; a[i]=x; return i}
function push2(a,x,y,  i) {i=++a[x,0]; a[x,i]=y; return i}
function pop(a,   x,i) {
 i=a[0]--;
 if (!i) {return ""} else {x=a[i]; delete a[i]; return x}
}


# Arrays to strings

function saya(s,a) {print s; print a2s(a)}
function a2s(a,  n,pre,i,str) {
  for(i in a) str= str pre "[" i "]=[" a[i] "]\n";
  return str;
}

# Strings

function number(x)    { return x ~  Number  }
function symbol(x)    { return ! number(x)  }
function blank(x)     { return x~/^[ \t]*$/ }
function trimLeft(x)  { sub(/^[ \t]*/,"",x); return x}
function trimRight(x) { sub(/[ \t]*$/,"",x); return x}
function trim(x, y)   { return trimRight(trimLeft(x))}
function str2keys(str,keys,sep,   n,i,tmp) {
  n=split(str,tmp,sep);
  for(i in tmp) keys[tmp[i]];
  keys[0]=n;
}
function pairs2nums(str,pairs,sep, n,i,tmp) {
  n=split(str,tmp,sep);
  for(i=1;i<=n;i=i+2) {
    paris[tmp[i]]=tmp[i+1]+0;
    pairs[0]++;
  }
}

# Numbers

function odd(x)     {return x % 2}
function even(x)    {return ! odd(x)}
function most(x,y)  { if (x>y) {return x} else {return y}}
function least(x,y) { if (x<y) {return x} else {return y}}
function round(x)   { if (x<0) {return int(x-0.5)} else {return int(x+0.5)}}
function between(min,max) {
   if (max==min) {return min}
   else {return min+ ((max-min)*rand())}}
function mean(sumX,n) {return sumX/n}
function sd(sumSq,sumX,n) {return sqrt((sumSq-((sumX*sumX)/n))/(n-1))}


#File exists

function exists(file, dummy, ret) {
  ret=0;
  if ( (getline dummy < file) >=0 ) {ret = 1; close(file)};
  return ret;
}

# rewind.awk --- rewind the current file and start over
function rewind(i) {
    # shift remaining arguments up
    for (i = ARGC; i > ARGIND; i--)
        ARGV[i] = ARGV[i-1]

    # make sure gawk knows to keep going
    ARGC++

    # make current file next to get done
    ARGV[ARGIND+1] = FILENAME

    # do it
    nextfile
}
```
