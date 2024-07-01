#!/bin/awk -f
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
  #printf "GULP.charges=   np.array([";  for (i=1;i<=natoms-1;i++){ print "\t"charge[i]"," };print "\t",charge[natoms]"])";
  #printf "GULP.symbols=   np.array([";  for (i=1;i<=natoms-1;i++){ printf "'"symbol[i]"'," };print "'"symbol[natoms]"'])";
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
