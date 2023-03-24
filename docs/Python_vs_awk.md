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

??? "python challenge"
    If you think that this could be done **significaanly** easier in `python` than the python solution above, here is a [link to a smaller](data/H2O.log) file on which you can try your code. I will be glad to share the solution on this page. 
    ```
    ./extract-freq.awk H2O.log
    
    23.1750 0.0019 1.4225
    34.8104 0.0044 0.0422
    42.9143 0.0060 0.0702
    46.5066 0.0071 2.7913
    48.1367 0.0081 7.5572
    79.9492 0.0282 0.0113
    87.5406 0.0309 2.7116
    93.0389 0.0417 2.5642
    121.2068 0.0585 1.9881
    145.7597 0.0776 2.0812
    . . . 
    3048.5567 5.8718 1459.3611
    3180.5241 6.3493 796.1409
    3217.1453 6.5022 2372.1535
    3242.9776 6.5949 309.5433
    3247.6888 6.6231 2019.7043
    3260.1368 6.6708 59.4172
    3634.5856 8.2915 533.1068
    3636.1663 8.3042 226.5813
    3641.2286 8.3247 598.4021
    3644.1577 8.3436 313.5530
    3830.3485 9.2159 2.4124
    3854.9395 9.3284 12.6945
    3855.2245 9.3301 50.4032
    3858.7550 9.3463 39.0654
    3858.9545 9.3474 21.1611
    ```
    
    - 2023.03.23 - Solution by [ryan-duve](https://github.com/pmitev/to-awk-or-not/issues/3#issue-1637700669)
    ```python
    data = {"Frequencies":[], "Frc consts":[], "IR Inten":[]}

    with open("H2O.log") as f:
        for line in f.readlines():
            for label in data:
                if label in line:
                    data[label].extend(line.split()[-3:])

    for line in zip(*data.values()):
        print(" ".join(line))    
    ```