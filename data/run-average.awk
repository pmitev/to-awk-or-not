#!/usr/bin/awk -f
{
  if (!col)  col = 1
  if (!size) size= 5
  mod= NR%size; 
  if(NR <= size){count++}
  else{ sum-= array[mod] };
  sum+= $(col); array[mod]= $(col);
  print sum/count
}
