# Awk writes Python
This sounds strange. Why would one use awk to write Python code?
Well, the reason is the same as before, **"the overheads of more sophisticated approaches are not worth the bother"**. My analysis program runs in Python but collecting my data from the output of another program (GULP in this case) requires some tedious work. The result is a small awk script that extracts the relevant values and writes a Python structure that takes a couple of lines to load. The code looks large and complicated, but if you just look closely, each search section is independent from the rest and addresses a single property of interest. With time, I kept adding more and more patterns to make the script more robust and generic. 

If you are still not convinced, just look how the GULP output looks like. In the file section, as usual, there is a complete set as an example.

!!! note "GULP-out2python.awk"
    ``` awk
    #!/usr/bin/awk -f
    BEGIN{
      print "import numpy as np\n\nclass GULP:\n\tdef __init__(self):\n\t\tself.ver=\"2015.04.15\""
    }
    
    /Dimensionality =/{
      if ($3==3) print "GULP.pbc= np.array([ True, True, True], dtype=bool)"
      if ($3==2) print "GULP.pbc= np.array([ True, True, False], dtype=bool)"
      if ($3==1) print "GULP.pbc= np.array([ True, False, False], dtype=bool)"
      if ($3==0) print "GULP.pbc= np.array([ False, False, False], dtype=bool)"
    }
    
    
    /Cartesian lattice vectors \(Angstroms\) :/{
      getline;
      getline; printf "GULP.cell= np.array([\n\t[%g,%g,%g],\n",$1,$2,$3
      getline; printf "\t[%g,%g,%g],\n",$1,$2,$3
      getline; printf "\t[%g,%g,%g]])\n",$1,$2,$3
    }
    
    /Fractional coordinates of asymmetric unit/ {
      for(i=1;i<=6;i++) getline
      while (NF>1){
        scoord[$1]="["$4","$5","$6"]";
        charge[$1]=$7;
        if ($2 == "X1") $2="X"
        symbol[$1]=$2;
        natoms=$1;
        getline;
      }
      print  "GULP.scaled_positions= np.array([";  for (i=1;i<=natoms-1;i++){ print "\t"scoord[i]"," }; print "\t"scoord[i]"])"
      printf "GULP.charges=   np.array([";  for (i=1;i<=natoms-1;i++){ print "\t"charge[i]"," };print "\t",charge[natoms]"])";
      printf "GULP.symbols=   np.array([";  for (i=1;i<=natoms-1;i++){ printf "'"symbol[i]"'," };print "'"symbol[natoms]"'])";
    }
    
    /Initial Cartesian coordinates :/{
      for(i=1;i<=6;i++) getline
      while (NF>1){
        coord[$1]="["$4","$5","$6"]"
        charge[$1]=$7 
        symbol[$1]=$2
        natoms=$1
        getline;
      }
      print  "GULP.positions= np.array([";  for (i=1;i<=natoms-1;i++){ print "\t"coord[i]"," }; print "\t"coord[i]"])" 
    }
    
    /Electrostatic potential at atomic positions :/{
      for(i=1;i<=6;i++) getline
       while (NF>1){
          gsub("-"," -",$0); split($0,data)
          aPOT[$1]=data[4]+0
          aEF[$1]="["data[5]+0","data[6]+0","data[7]+0"]"
          getline;
       }
       printf "GULP.EPOT= np.array([";  for (i=1;i<=natoms-1;i++){ print "\t"aPOT[i]"," }; print "\t"aPOT[natoms]"])";
       print  "GULP.EPOTgradient= np.array([";  for (i=1;i<=natoms-1;i++){ print "\t"aEF[i]","  }; print "\t"aEF[i]"])"
    }
    ```


The output from the script looks like this "data.py"
``` python
import numpy as np

class GULP:
 def __init__(self):
 self.ver="2014.01.28"
GULP.pbc= np.array([ True, True, True], dtype=bool)
GULP.cell= np.array([
 [8.93076,0,0],
 [0,5.95384,0],
 [0,0,23.42]])
GULP.scaled_positions= np.array([
 [0.578633,0.302123,0.218589],
 [0.762789,0.553684,0.312622],
 [0.078391,0.553354,0.313708],
 [0.242805,0.801983,0.220219],
 [0.078509,0.053341,0.313727],
 [0.578346,0.802044,0.218543],
 [0.764646,0.052150,0.315978],
...
```


and here is the code that loads the data in my Python program

``` python
# Load the data from GULP
#==========================================
from data import GULP

structure= Atoms(symbols=GULP.symbols,
  cell=GULP.cell, 
  #positions= GULP.positions,
  scaled_positions= GULP.scaled_positions,
  pbc= GULP.pbc)
structure.charges= GULP.charges;
structure.EPOTgradient= GULP.EPOTgradient;
#==========================================
```

!!! example "Files"
    * [GULP-out2python.awk](../data/GULP-out2python.awk)
    * [data.py](../data/data.py)
    * [EF.gout](../data/EF.gout) - GULP program output
