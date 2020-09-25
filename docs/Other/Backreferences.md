# Backreferences
---

This is kind of common situation. You know how to do it with sed or perl but now, for whatever reason, you want to do it with awk. Googling around and reading some other sources, can give you the impression that backreference is not implemented in awk...

Here is an example how one can "translate" sed backreference in awk. 

sed
``` bash
$ echo ">seq12/1-100" | sed -e 's,>seq\(.*\)\/.*,>SEQ-\1,g'
>SEQ-12
```


awk
``` awk
$ echo ">seq12/1-100" | awk ' {print gensub( />seq(.*)\/.*/ , ">SEQ-\\1" , "g")} '
>SEQ-12
```


Note: if you are looking just to rename the entries in a Fasta file, perhaps there is way easier way to do it: Renaming Entries In A Fasta File

Here is another example, where I can mention some disadvantages with awk (or perhaps I could not find how to do it properly).

!!! note "filedata"
    ```
    /home/ux/user/z156256
    /home/ux/user/z056254
    /home/lx/user/z106253
    /home/ux/user/z150252
    /home/mp/user/z056254
    /home/lx/user/z106253
    ```

sed
``` bash
$ sed -e 's,/home/\(..\)/user/\(z[0-9]\{6\}\),/usr/\2/\1,g' filedata
/usr/z156256/ux
/usr/z056254/ux
/usr/z106253/lx
/usr/z150252/ux
/usr/z056254/mp
/usr/z106253/lx
```

awk
``` awk
$awk '{print gensub(/\/home\/(..)\/user\/(z[0-9][0-9][0-9][0-9][0-9][0-9])/,"/usr/\\2/\\1","g")}' filedata
/usr/z156256/ux
/usr/z056254/ux
/usr/z106253/lx
/usr/z150252/ux
/usr/z056254/mp
/usr/z106253/lx
```

... and as a colleague of mine, Matti Hellström, pointed out - the proper "awk way" is:

``` awk
$ awk -F/ '{print "/usr/" $5 "/" $3}' filedata
/usr/z156256/ux
/usr/z056254/ux
/usr/z106253/lx
/usr/z150252/ux
/usr/z056254/mp
/usr/z106253/lx
```


