# Dipole moment example
Here is a simple script that will calculate the dipole moment of a molecule[^1]. In this particular case I have used the result for a water molecule from a Wannier function localization calculation. To keep the script simple, I have added the charges of the species as 5th column in the file. You can perhaps change it, so it recognizes **O** with charge of 6 valence electrons, **H** with $1e$, and **X** - Wannier center with charge of $-2e$. The coordinates are in Angstroms.

Here is the code
``` awk
#!/usr/bin/awk -f
# x,y,z in Angstroms
NR > 2 {
  mx= mx + $2*$5; my= my + $3*$5; mz= mz + $4*$5;
}

END {
  norm=sqrt(mx**2 + my**2 + mz**2);
  # Convert to Debye
  toD= 4.80320425;
  mx= mx*toD; my= my*toD; mz= mz*toD;
  norm= norm*toD;
  printf("Dipole Moment\t  x\t\t  y\t\t  z\t\t| D.Moment |\n");
  printf(" [ Debye ]   \t%f\t%f\t%f\t%f\n", mx, my, mz, norm);
}
```

and here is the .xyz file with the charges added
``` xyz
     7
 Wannier centres, written by Wannier90 on 6Aug2013 at 14:23:10
X          6.50000026       6.18706578       6.50000000  -2
X          6.50000000       6.71337672       6.50000002  -2
X          6.50000008       6.95339960       6.49999998  -2
X          6.49999971       6.54636884       6.50000000  -2
H          6.50000000       7.09480000       7.26880000   1
H          6.50000000       7.09480000       5.73120000   1
O          6.50000000       6.50000000       6.50000000   6
```

Here is the output of the program
``` bash hl_lines="1"
$ ./dipole_moment.awk waterX.xyz
Dipole Moment     x               y               z             | D.Moment |
 [ Debye ]      -0.000000       1.869302        0.000000        1.869302
```

This example should be easy to alter, so you can calculate (_if you want_) the center of the mass of the molecule, the geometrical center, [radius of gyration](https://en.wikipedia.org/wiki/Radius_of_gyration)...

!!! example "Files"
    * [dipole_moment.awk](../data/dipole_moment.awk)
    * [waterX.xyz](../data/waterX.xyz)

[^1]: [Dipole moment of an array of charges](https://en.wikipedia.org/wiki/Electric_dipole_moment#Dipole_moment_density_and_polarization_density)
