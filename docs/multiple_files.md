# Multiple files ...
> ... or how to apply different rules for different input files.

## Common practice - `NR` and `FNR`

Perhaps one of the most common approach is utilizing the internally [predefined variables](https://www.gnu.org/software/gawk/manual/html_node/Built_002din-Variables) [`NR`](https://www.gnu.org/software/gawk/manual/html_node/Auto_002dset.html#index-NR-variable-1) and [`FNR`](https://www.gnu.org/software/gawk/manual/html_node/Auto_002dset.html#index-FNR-variable-1).

To illustrate this, we can create two files with some distinct data. You can run `seq -f "File_1 - Line_%g" 1 3` and `seq -f "File_2 - Line_%g" 1 3` and redirect the output to two separate files.

```bash
$ seq -f "File_1 - Line_%g" 1 3 
File_1 - Line_1
File_1 - Line_2
File_1 - Line_3

$ seq -f "File_2 - Line_%g" 1 3 
File_2 - Line_1
File_2 - Line_2
File_2 - Line_3
```

Or use anonymous pipeline to run directly this example:
```bash
awk '{print "FNR: "FNR" NR: "NR"  => "$0}' <(seq -f "File_1 - Line_%g" 1 3) <(seq -f "File_2 - Line_%g" 1 3)
FNR: 1 NR: 1  => File_1 - Line_1
FNR: 2 NR: 2  => File_1 - Line_2
FNR: 3 NR: 3  => File_1 - Line_3
FNR: 1 NR: 4  => File_2 - Line_1
FNR: 2 NR: 5  => File_2 - Line_2
FNR: 3 NR: 6  => File_2 - Line_3
```

Note that `FNR` keeps the line number in the file, while `NR` keeps incrementing - i.e. referring to the line number irrelevant of the file.

It is rather common (in the awk community) to treat differently the first file which usually is realized by adding check for `NR==FNR` that is **_true_** only for the first file.

```awk
...
NR==FNR { commands } # runs only on the first file
NR!=FNR { commands } # runs on any but the first file
        { commands } # runs on all files
...
```

## `FILENAME`, `ARGIND`

- [`FILENAME`](https://www.gnu.org/software/gawk/manual/html_node/Auto_002dset.html#index-dark-corner-FILENAME-variable-1) - The name of the current input file. When no data files are listed on the command line, awk reads from the standard input and `FILENAME` is set to "-". `FILENAME` changes each time a new file is read.
- [`ARGIND`](https://www.gnu.org/software/gawk/manual/html_node/Auto_002dset.html#index-ARGIND-variable) - Every time gawk opens a new data file for processing, it sets `ARGIND` to the index in ARGV of the file name. When gawk is processing the input files, `FILENAME == ARGV[ARGIND]` is always true.
!!! warning
    `ARGIND` is not working under OS X - you need gawk for this.