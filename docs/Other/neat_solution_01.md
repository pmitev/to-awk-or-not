# Neat solution #1
Here is a neat example of using associative arrays again.

Let's have a list of e-mails which we collected from different sources and unfortunately might contain duplicate entries. Let's use just some regular text instead of mail addresses... In this example "aa" and  "aaa" appear 2 times.

```
aaa
bbb
aaa
aa
ccc
aa
```
``` awk 
$ awk '!x[$0]++' file.txt
```

  or 
``` awk hl_lines="1"
$ echo -e "aaa\nbbb\naaa\naa\nccc\naa" | awk '!x[$0]++'
aaa 
bbb 
aa 
ccc
```
That is really not easy to read/understand - I agree. 
Do not worry, it is meant only to demonstrate some features that make awk rather god tool for text parsing and simple data manipulation.

Here is what happens. By default, if there is no action defined, awk will execute print command which will print the whole line content. Essentially what we have `#!awk '!x[$0]++'` is a matching criteria. When awk starts, `#!awk x` is empty, so on the first line of the file `#!awk x[$0]` is empty (that is equal to FALSE) then `#!awk !` negates the result and `++` actually ads 1 to the default 0 for undefined element, so next time when there is a line with the same text, the negated result will be FALSE and the line will not be printed.

:fontawesome-solid-terminal:
