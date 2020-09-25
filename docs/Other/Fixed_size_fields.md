# Fixed size fields
---
Your file has fixed length of the data fields... 
Here is a good example how to deal with it:

``` awk
$ echo 20140805234656 | awk 'BEGIN { FIELDWIDTHS = "4 2 2 2 2 2" } { printf "%s-%s-%s %s:%s:%s\n", $1, $2, $3, $4, $5, $6 }'
2014-08-05 23:46:56
```


