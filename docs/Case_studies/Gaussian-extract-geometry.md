#Gaussian - extract geometry from output .log file
It is rather common problem that one wants to extract the final geometry from a Gaussian calculation. It is possible to do it with GaussView, molden... But when you have hundreds of geometries...

Here is a solution using Open Babel
``` bash hl_lines="1"
$ obabel -ig09 gaussian_output.log -oxyz
8
gaussian_output.log        Energy: -190290.8876477
O          1.48397        0.74575       -0.00894
H          0.54487        0.98777        0.10858
O          1.36176       -0.69934       -0.11156
H          1.80921       -0.98067        0.69811
O         -1.48420       -0.74573        0.00817
H         -0.54547       -0.98830       -0.11124
O         -1.36140        0.69926        0.11245
H         -1.80957        0.98168       -0.69645
1 molecule converted
```

Which will find the last geometry (not sure what happens if the point is not stationary) and will write out the standard orientation of the molecule.

Here is a solution in awk, which gives you the option to select which orientation you want: Input or Standard orientation

By default the script will print the last geometry in the output.log file in "Standard orientation".

``` bash hl_lines="1"
$ GAUSSIAN-log2xyz.awk  gaussian_output.log
8
  XYZ  -Stationary point- [Standard orientation]  extracted from: gaussian_output.log
   O      1.48396700      0.74574700     -0.00893700
   H      0.54487000      0.98777200      0.10857600
   O      1.36176000     -0.69934000     -0.11155800
   H      1.80920900     -0.98067200      0.69811200
   O     -1.48420500     -0.74573000      0.00817100
   H     -0.54547200     -0.98829500     -0.11124500
   O     -1.36140100      0.69926200      0.11245000
   H     -1.80957500      0.98167900     -0.69645200
```

To print in the Input orientation add outf=0 before the output.log i.e.

``` bash hl_lines="1"
$ GAUSSIAN-log2xyz.awk outf=0 gaussian_output.log
8
  XYZ  -Stationary point- [Input orientation]  extracted from: gaussian_output.log
   O     -0.70140300     -0.20578800      0.09097700
   H     -1.11738400      0.67789200      0.07209400
   O      0.69843900      0.17126700     -0.01863500
   H      0.91917500     -0.18830400     -0.88864000
   O      0.23362800      2.98135600      0.03930000
   H      0.65037800      2.09806100      0.06000100
   O     -1.16628300      2.60379100      0.14722400
   H     -1.38832100      2.96390800      1.01668100
```

!!! note "GAUSSIAN-log2xyz.awk"
    ``` awk
    #!/bin/awk -f
    BEGIN{
     ss="H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Ha,D"
      split(ss,atsym,",")
      outf=1 # Default output format
      orient[0]= "Input orientation"
      orient[1]= "Standard orientation"
    }
    
    /Stationary point found/{
      SP= 1; # found stationary point
      SPtxt= " -Stationary point- " # add info to the second line
    }
    
    $0 ~ orient[outf] && (SP < 2) {
      if (SP==1) SP= 2 # stop looking for geometry output
    
      getline; getline; getline; getline; getline;
    
      iat= 0
      do {
        iat++
        atn[iat]=$2; x[iat]=$4; y[iat]=$5; z[iat]=$6
        getline;
      } while (NF !=1)
    
    }
    
    END{
        print iat"\n  XYZ "SPtxt"["orient[outf]"]  extracted from: "FILENAME
        for (i=1;i<=iat;i++) printf ("%4s  %14.8f  %14.8f  %14.8f\n",atsym[atn[i]],x[i],y[i],z[i])
    }
    ```
!!! example "Files"
    * [GAUSSIAN-log2xyz.awk](../data/GAUSSIAN-log2xyz.awk)

