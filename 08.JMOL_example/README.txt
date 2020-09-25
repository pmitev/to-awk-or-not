# here is a line to create a file "vectors.spt" with apropriate code for Jmol
awk '{i++;printf ("draw v%i vector (atomno=%i) {%f,%f,%f}\n",i,i,$1,$2,$3)}' vectors.dat > vectors.spt
