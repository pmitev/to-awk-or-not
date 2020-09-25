#!/usr/bin/awk -f

{
  names[$1]= 1;
  data[$1,ARGIND]= $2
} 

END{ 
  for (i in names) print i"\t\t"data[i,1]"\t\t"data[i,2]  
}
