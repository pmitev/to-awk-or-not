# Scrubbing a web page **
!!! warning
    Unfortunately, the web engine is changing quite often and even the address might not be correct, so it might not be possible to solve the problem as described...
    To make it work, please use a copy of the page at [https://web.archive.org/](https://web.archive.org/)  
    https://web.archive.org/web/20190323025902/http://www.kemi.uu.se/about-us/people-angstrom/ 

Here is another example when awk comes handy. You can get some information on a web page which is more or less well structured and you want to make some statistics from the numbers you can extract. Disclaimer: there are better tools to this but honestly they come with their own overhead...

For instance, on the following web address http://www.kemi.uu.se/about-us/people-angstrom/ one can find list of the people employed at the department of chemistry with their positions. Try to make a simple awk script which will count how many people are employed on different positions.

To make the example as general as possible let's work with the HTML source code of the web page (do not worry if you are not familiar with HTML). There are many ways to get the web page from the command line but let's consider  two standard tools curl or wget. The commands below will produce identical output with a lot of irrelevant HTML code.
``` bash
$ curl -s http://www.kemi.uu.se/about-us/people-angstrom/
$ wget -O - http://www.kemi.uu.se/about-us/people-angstrom/
```

``` html
!DOCTYPE html>
<!--[if lt IE 7]>      <html lang="sv" class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html lang="sv" class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html lang="sv" class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html lang="sv" class="no-js"> <!--<![endif]-->
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
...
```


Luckily, all employee titles are on a new line after a line with the following content `#!html <span class="emp-title">` .  
Let's `grep` for this string and print the line bellow as well with the `-A 1` option.

``` bash hl_lines="1"
curl -s http://www.kemi.uu.se/about-us/people-angstrom/ | grep -A 1 "emp-title" | head
<span class="emp-title">
visiting researcher
--
<span class="emp-title">
degree project worker
--
<span class="emp-title">
doctoral/PhD student
--
<span class="emp-title">
```

Can you come with a solution (awk is a good choice) on how to count how many people are employed on each position?

??? "Possible solution"
    ``` awk
    curl -s https://web.archive.org/web/20190323025902/http://www.kemi.uu.se/about-us/people-angstrom/ | awk ' /emp-title/{getline;title[$0]++} END{for (i in title) print title[i],i}'
    ```
    ```
    1 computer coordinator
    3 Assistant Professor
    1 administrator
    8 assistant undergoing research training
    35 visiting researcher
    3 senior professor
    1 administrative manager
    1 administrative assistant
    1 financial coordinator
    10 professor emeritus
    44 post doctoral
    1 course administrator
    20 degree project worker
    4 master's thesis students
    1 personnel coordinator
    1 systems administrator
    3 economist
    16 professor
    4 research engineer
    38 researcher
    1 instrument maker
    1 project coordinator
    1 hr-generalist
    1 information officer
    1 technician
    79 doctoral/PhD student
    1 personnel administrator
    1 senioruniversitetlektor i oorganisk kemi 
    6 guest doctoral student
    4 visiting professor
    23 senior lecturer
    4 associate senior lecturer
    3 research assistant
    20 visiting student
    6 senior research engineer
    2 financial administrator
    3 visiting senior lecturer
    ```
