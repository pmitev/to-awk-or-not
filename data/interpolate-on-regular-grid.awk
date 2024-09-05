#!/bin/awk -f
BEGIN{
  minx= 1500;  # Range: lower limit 
  maxx= 4000;  #        upper limit
  dx= 1;       #        increment
}

{
  # check if the lower limit has been reached
  if (($1 > minx ) && ($1 < maxx)){
    x2=$1; y2=$2; 
    
    # for the defined range
    for (xi= minx; xi <= maxx; xi= xi+dx){
      # step forward if the current grid point is outside the [x1:x2] region
      if (xi > x2)  { 
	while (($1<xi) && (getline!=0) ) {x1=x2; y1=y2; x2=$1; y2=$2} 
      } 
      yi= (y2-y1)/(x2-x1)*(xi-x1) + y1; # linear interpolation
      print xi, yi
    }
  }
  x1= $1; y1=$2
} 
