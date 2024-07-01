#!/usr/bin/awk -f
# x,y,z in Angstroms
NR > 2 {
  mx= mx + $2*$5; my= my + $3*$5; mz= mz + $4*$5;
}

END {
  norm=sqrt(mx**2+my**2+mz**2);
  # Convert to Debye
  toD= 4.80320425;
  mx= mx*toD; my= my*toD; mz= mz*toD;
  norm= norm*toD;
printf("Dipole Moment\t  x\t\t  y\t\t  z\t\t| D.Moment |\n");
printf(" [ Debye ]   \t%f\t%f\t%f\t%f\n", mx, my, mz, norm);
}
