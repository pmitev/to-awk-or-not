# Case studies
Here is a collection of mine and contributed awk scripts.  

---

## General topic
* **[Awk and Jmol](awk-jmol.md)**  
   _awk is using input data to write java script code to plot vectors in Jmol_
* **[Multiple input files - first approach](multiple_files_I.md)**  
  _awk collects and assembles data from multiple files in memory_
* **[Multiple input files - second approach](multiple_files_II.md)**  
  _awk collects data from multiple files but picks only the necessary data to save on memory_
* **[Multiple output files](Multiple_output_files.md)**  
  _MUST KNOW feature - covered during the workshop_
* **[Color output with custom keywords](colors.md)**  
  _use simple awk script to highlight keywords in your output_


## Bioinformatics oriented
* **[bioawk](../Bio/bioawk.md)**  
  _Bioawk is an extension to Brian Kernighan's awk, adding the support of several common biological data formats, including optionally gzip'ed BED, GFF, SAM, VCF, FASTA/Q and TAB-delimited formats with column names._
* **[Fasta file format tips](Fasta_tips.md)**  
  _worth to know if working often with files in multi-fasta format_
* **[Multiline fasta to single line fasta](Multi2single_fasta.md)**  
  _single cryptic-looking line that will decriphered during the workshop_
* **[Sequence clustering with awk](Sequence_clustering.md)**  
  _apllication of the multiple files approach - contribution by Martín González Buitrón_
* **[Substitute scientific with common species names in a phylogenetic tree file](../Bio/NCBI-taxonomy.md)**
* **[Statistics on very large columns of values](../Bio/Stat-large-files.md)**
* **[Manipulating and getting statistics for .vcf and .gff files](manipulating_vcf.md)**

## Math oriented
* **[Discrete histogram](Discrete_histogram.md)**  
  _very handy discrete histogram awk code_
* **[Gaussian smearing](Gaussian_smearing.md)**  
  _trivial task done with awk - example how to use functions_
* **[Linear interpolation](Linear_interpolation.md)**  
  _use linear interpolation to resample your data on different grid_

## Physics oriented
* **[Dipole moment example](Dipole_moment.md)**  
  _simple calulations should not be difficult to code - here is an example_
* **[Multiple files - VASP CHGCAR difference](CHGCAR_diff.md)**  
  _an simplified example on how to read multiple files (bzip-ed) line-by-line simultaneously to save memory_ 
* **[POSCAR: reorder atom types](POSCAR_reorder.md)**  
  _simple task creates programing nightmare_

## Primarily used as reference
* **[Awk and Gnuplot](awk_gnuplot.md)**  
  _outdated problem but shows hot to send data to another program and read back the results_
* **[Awk writes Python](awk_writes_python.md)**  
  _collecting your data might be so tedious to program, that you might wamt to use awk to write python instead_
* **[Gaussian - extract geometry from output .log file](Gaussian-extract-geometry.md)**  
  _example_
* **[ProLiant Status check](ProLiant_status_check.md)**  
  _simple check on some values, collected and mailed_
* **[Awk and Networking](awk_network.md)**  
  _awk have some advance network protocol capabilities..._

