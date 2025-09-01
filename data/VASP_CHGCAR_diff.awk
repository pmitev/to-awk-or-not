#!/usr/bin/awk -f
BEGIN{
  cmd1= "bzcat  "ARGV[1]; 
  cmd2= "bzcat  "ARGV[2];
  cmd3= "bzcat  "ARGV[3];

  NF=1;  while(NF>0){ cmd2 |& getline;       } cmd2 |& getline; 
  NF=1;  while(NF>0){ cmd3 |& getline;       } cmd3 |& getline; 
  NF=1;  while(NF>0){ cmd1 |& getline; print } cmd1 |& getline; print;

  do {
    cmd1 |& getline; split($0,d1)
    cmd2 |& getline; split($0,d2)
    cmd3 |& getline; split($0,d3)
    for(i=1;i<=NF;i++) printf "%18.11e ", d1[i]-d2[i]-d3[i]
    print""
  } while ($1*1==$1)
  
}


