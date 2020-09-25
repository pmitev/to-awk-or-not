#!/usr/bin/awk -f 

BEGIN { AU2eV= 27.211383 } 

/Distance matrix/ {getline; getline; getline; getline; getline; getline; rOH= $5} 

/Counterpoise: corrected energy/ { printf "%.12f %.6f\n", rOH, $5*AU2eV }
