#!/usr/bin/awk -f
BEGIN{
  FWHM=30; # Default smearing if none is provided on the command line
  FWHM= FWHM/2.35482
  # trick to read parameters from the command line
  if (ARGC==3) FWHM=ARGV[2];  ARGC=2; 
}

!/#/ {
  f++;
  if (f==1) {fmin=$1; fmax=$1}

  freq[f]=$1;
  if (fmin > $1) fmin=$1;
  if (fmax < $1) fmax=$1;
  nfreq=f;
}

END{
  print "# freq   intensity | nfreq: "nfreq" fmin: "fmin" fmax: "fmax
  for (i=int(fmin -5*FWHM); i<=int(fmax +5*FWHM);i++){
    for (f=1;f<=nfreq;f++){
      data[i]= data[i] + gauss(freq[f],i,FWHM);
    }
    print i,data[i]
  }  
}

function gauss(x0,x,c){
  area=1;
  if ((x-x0)**2 < 10000) { return  area*exp(-(((x-x0))**2)/(2.*c**2))}
  else {return 0.0}
}
