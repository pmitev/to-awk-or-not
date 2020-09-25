# Localization problems
Well, here are some annoying problems related to some local settings, for example decimal point/comma. 

US localization with decimal point
``` awk
$ echo 123.2 |  gawk  '{print; print $1+1}‘
124.2
```

SE localization with decimal comma 
``` awk
$ echo 123,2 |  gawk  '{print; print $1+1}‘
124
```


SE localization with decimal comma - FIX
``` awk
$ echo 123,2 | LC_NUMERIC=se_SE.utf-8 gawk --use-lc-numeric '{printf $1+1}‘
124,2
```
