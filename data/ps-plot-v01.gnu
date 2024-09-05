#!/usr/bin/gnuplot

set term png size 800, 400 enhanced
set out "Gauss-smearing.png"

set border

set key top left
set title "Gaussian smearing with FWHM 10 and 30"
set xlabel "Frequency"
set ylabel "Intensity"

plot "< ./gauss-smear-data.awk freq.dat 30" u ($1 ):($2) w l t "Gauss smearing 30" lw 2,\
     "< ./gauss-smear-data.awk freq.dat 10" u ($1 ):($2) w l t "Gauss smearing 10" lw 2,\
     "freq.dat" u ($1):(1) w impulses t "" lc rgb "blue"

!eog Gauss-smearing.png
