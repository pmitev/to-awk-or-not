#!/bin/awk -f
BEGIN {
  if (!col) col=1 
}

{
  counts[$(col)]++;
  total++;
}

END {
  for (v in counts) {
    printf "%s %.0f %f \n", v, counts[v], counts[v]/0.01/total ;
  }
}
