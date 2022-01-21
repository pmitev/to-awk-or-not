# Mail merge ****

This exercise is for those of you that feel comfortable experimenting with awk and to improve further.
Here is the link to the original task [https://opensource.com/article/19/10/advanced-awk](https://opensource.com/article/19/10/advanced-awk)

To recap...  
We want to compose text from a template `email_template.txt` in which we will replace the fields with the data provided on each line in the second file `proposals.csv`.

!!! note "email_template.txt"
    ```
    From: Program committee <pc@event.org>
    To: {firstname} {lastname} <{email}>
    Subject: Your presentation proposal

    Dear {firstname},

    Thank you for your presentation proposal:
      {title}

    We are pleased to inform you that your proposal has been successful! We
    will contact you shortly with further information about the event 
    schedule.

    Thank you,
    The Program Committee
    ```

!!! note "proposals.csv"
    ```
    firstname,lastname,email,title
    Harry,Potter,hpotter@hogwarts.edu,"Defeating your nemesis in 3 easy steps"
    Jack,Reacher,reacher@covert.mil,"Hand-to-hand combat for beginners"
    Mickey,Mouse,mmouse@disney.com,"Surviving public speaking with a squeaky voice"
    Santa,Claus,sclaus@northpole.org,"Efficient list-making"
    ```

If you feel confident, go ahead and try to solve the problem. Or...

- Follow the tutorial for the first part till the end of the "Advanced awk: Mail merge" section.
- Try to have the script running and understand the way it works.
- Then return to this exercise and let's make this really advanced!

The solution presented at the link has too much features hard coded i.e. the names and the numbers of the fields, file names... Let's make this really generic and flexible. Here I would like to run the tool like this.

> Merge the data (first argument) with the provided template (second argument) for participant 1 (provided after the 2 filenames)

``` bash
$ ./mail-merge.awk proposals.csv email_template.txt 1

From: Program committee <pc@event.org>
To: Harry Potter <hpotter@hogwarts.edu>
Subject: Your presentation proposal

Dear Harry,

Thank you for your presentation proposal:
  "Defeating your nemesis in 3 easy steps"

We are pleased to inform you that your proposal has been successful! We
will contact you shortly with further information about the event
schedule.

Thank you,
The Program Committee
```

Here is the strategy I would like to propose.

- use the trick `NR==NFR` to load the relevant data from the first file.
- hard code the third argument i.e. make the script running for the firs data line.
- while reading the second file run the substitutions with the data collected from the first file.
- the ultimate goal is to have tool that is independent of the numbers and the names of the fields for substitution and the file names containing the data and the template...

??? "Possible solution"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN {
      FS=","
      if (ARGC <=3 ) exit # not enaugh arguments provided
      #print ARGC,ARGV[3] # for debugging purposes
      argc= ARGC;  ARGC=3 # Do not read after the second file
    }
    
    NR==1 {
      for (i=1;i<=NF;i++)  {
        varnames[$i]=i   # list with variables and the corresponding column
        varcolumns[i]=$i # the opposite...
      }
      next
    }
    
    NR==FNR {
      for(i=1;i<=NF;i++){ 
        data[varcolumns[i]][NR-1]= $i # collect the data
      } 
    }
    
    NR!=FNR {
      for(i in varnames){ gsub("{"i"}",data[i][ARGV[3]])  }
      print
    }
    ```
