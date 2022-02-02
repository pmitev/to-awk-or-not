#Python vs. awk

Well, the title is misleading. I am not going to argue which language is better. Obviously, Python is more powerful and has vastly more features. Instead, here I have selected a particular case where (_I think_) the use of Python is not a good choice at all.

Some time ago, I needed to extract frequency data from a Gaussian calculation. As many of us do, I searched the Net for already existing solutions, after all I do not want to rediscover the wheel... 
Luckily, the very first hit was a very well written Python script that does the job. Here is the link to the [original page](http://verahill.blogspot.se/2013/09/514-extracting-frequency-data-from.html) with the solution. I have to say that ~50 lines of code were a bit too much for me and for this particular task. Here I will paste the code just to support my case.

``` python linenums="1" hl_lines="16"
#!/usr/bin/python
# Compatible with python 2.7 
# Reads frequency output from a g09 (gaussian) calculation
# Usage ex.: g09freq g09.log ir.dat
import sys 

def ints2float(integerlist):
    for n in range(0,len(integerlist)):
        integerlist[n]=float(integerlist[n])
    return integerlist

def parse_in(infile):
    g09output=open(infile,'r')
    captured=[]
    for line in g09output:
        if ('Frequencies' in line) or ('Frc consts' in line) or ('IR Inten' in line):
            captured+=[line.strip('\n')]
    g09output.close()
    return captured
    
def format_captured(captured):
    vibmatrix=[]
    steps=len(captured)
    for n in range(0,steps,3):
        freqs=ints2float(filter(None,captured[n].split(' '))[2:5])
        forces=ints2float(filter(None,captured[n+1].split(' '))[3:6])
        intensities=ints2float(filter(None,captured[n+2].split(' '))[3:6])
        for m in range(0,3):
            vibmatrix+=[[freqs[m],forces[m],intensities[m]]]
    return vibmatrix

def write_matrix(vibmatrix,outfile):
    f=open(outfile,'w')
    for n in range(0,len(vibmatrix)):
        item=vibmatrix[n]
        f.write(str(item[0])+'\t'+str(item[1])+'\t'+str(item[2])+'\n')
    f.close()
    return 0

if __name__ == "__main__":
    infile=sys.argv[1]
    outfile=sys.argv[2]

    captured=parse_in(infile)

    if len(captured)%3==0:
        vibmatrix=format_captured(captured)
    else:
        print 'Number of elements not divisible by 3 (freq+force+intens=3)'
        exit()
    success=write_matrix(vibmatrix,outfile)
    if success==0:
        print 'Read %s, parsed it, and wrote %s'%(infile,outfile)

```

A large amount of the code deals with declarations of functions, reading and finding the data.

Here is how this problem could be solved with awk:
```awk title="extract-freq.awk"
#!/usr/bin/awk -f

/Frequencies/ { for (i=3;i<=NF; i++) { im++; freq[im ]=$i } }
/Frc consts/  { for (i=NF;i>=4; i--)     fc[im-(NF-i)]=$i   }
/IR Inten/    { for (i=NF;i>=4; i--)     ir[im-(NF-i)]=$i   }

END { for (i=1;i<=im;i++) print freq[i],fc[i],ir[i] }
```
Somehow, I think this is much more readable and easier to modify...

<!---

??? "python challenge"
    If you think that this could be done **significaanly** easier in `python` than the python solution above, here is a [link to a smaller](data/H2O.log) file on which you can try your code. I will be glad to share the solution on this page. 
    ```
    ./extract-freq.awk H2O.log

    1600.7808 1.6363 87.1321
    3806.5315 8.9139 5.0653
    3928.9605 9.8505 53.6136
    1600.7808 1.6363 87.1321
    3806.5315 8.9139 5.0653
    3928.9605 9.8505 53.6136
    ```

-->