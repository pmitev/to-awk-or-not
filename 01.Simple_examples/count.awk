#!/usr/bin/awk -f 
{ 
    country[$4]++
} 

END { 
      for (i in country) print "Country: " i," count: ", country[i] 
}
