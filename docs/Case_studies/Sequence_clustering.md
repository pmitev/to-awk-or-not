# Sequence clustering with awk
Contribution by Martín González Buitrón, National University of Quilmes, Argentina, exchange PhD student - Stockholm University 2020.04

CDHit is a software that allows users to perform sequence clustering. An important thing about clustering is to evaluate clustering conditions, i.e: identity, coverage, etc. One main problem about different conditions is to know what happen with each sequence. Lucky us, CDHit standard output has few patterns that anyone could exploit using AWK. These are, how clusters are written and how sequence lines belong in one cluster begins.

Suppose someone has a non-redundant dataset of hundred or thousands of sequences and performed two clustering using CDHit. Moreover, suppose that earlier dataset is diverse. A problem appears, which configuration is better for your clustering goal?

Knowing that, the following script process both standard CDHit clustering files (ended in *.clstr) and checks in which cluster it contains each sequence. If the above is done by hand, it could not be so good for the health. So, the script output has these fields in CSV format:
```
query_code, query_length, cluster_number_in_file_1, cluster_size_in_file_1, target_code, target_length, cluster_number_in_file_2, cluster_size_in_file_2, cluster_size_diff, same_cluster
```

Where `same_cluster` is a boolean column and has information about the changing location of that sequence, i.e:  
> same_cluster = Yes  ------> that sequence didn't change of cluster  
> same_cluster = No  ------> that sequence change to other cluster (new or already existed)

Where `cluster_size_diff` has information about the difference in size from each cluster (cluster_size_in_file_2 - cluster_size_in_file_1):  
> cluster_size_diff = 0  ------> that sequence is not in a bigger or smaller cluster  
> cluster_size_diff > 0  ------> that sequence is in a bigger cluster (new or already existed)  
> cluster_size_diff < 0  ------> that sequence is in a smaller cluster (new or already existed)

!!! warning "Warnings!"
    1. Could be that `cluster_size_diff` is different than 0 but the cluster continue being the same (e.g: look sequences in Cluster_0). That happen due how CDHit works and of course, the values in clustering conditions what were used to compare. For a deeper and accurate way to understand what is happening, you should then check these three columns, same_cluster and both "cluster_size" for any sequence, easily you can check column $4, $8 and $10.
    2. Cloud be that `same_cluster` is "No" but the cluster continue being pretty the same (e.g: look sequences in Cluster_1 to Cluster_4). That happen due how CDHit works and of course, the values in clustering conditions what were used to compare. For a deeper and accurate way to understand what is happening in this hard case, you should then check sequence neighbours and/or these two "`cluster_size`" columns for any sequence, easily you can check column $4, $8. For example, for bigger clusters in File 1 is more probable that those clusters leak/add some sequence in other CDHit condition but not changing to much in size (do size percentage study if necessary). 
    3. There are others possible results that you may need to study on detail, like:
        * Creation of new clusters ("border sequences" in different clusters form this new cluster or just sequences that were alone are now together)
        * Complete destruction of clusters (this happen frequently in small clusters that have "border sequences")
        * Funny destruction of clusters (they split on half creating two "new ones" or something like that)

To run the program
``` bash
$ ./get_seq_jumping_description_from_CDHIT_clstr_info.awk 2020-03-13_cdhit_ide_1.00_cov_0.98.clstr 2020-03-13_cdhit_ide_0.98_cov_0.90.clstr
```

Example output from the program
```
File1,,,,File2,,,,
query_code, query_length, cluster_number_in_file_1, cluster_size_in_file_1, target_code,target_length, cluster_number_in_file_2, cluster_size_in_file_2, cluster_size_diff, same_cluster
1FJG:A,1522,0,271,1FJG:A,1522,0,378,107,Yes
1HNW:A,1522,0,271,1HNW:A,1522,0,378,107,Yes
1HNX:A,1522,0,271,1HNX:A,1522,0,378,107,Yes
1HNZ:A,1522,0,271,1HNZ:A,1522,0,378,107,Yes
1HR0:A,1522,0,271,1HR0:A,1522,0,378,107,Yes
1I94:A,1514,0,271,1I94:A,1514,0,378,107,Yes
1IBK:A,1522,0,271,1IBK:A,1522,0,378,107,Yes
1IBL:A,1522,0,271,1IBL:A,1522,0,378,107,Yes
...
6UCQ:2a,1521,0,271,6UCQ:2a,1521,0,378,107,Yes
6UO1:1a,1521,0,271,6UO1:1a,1521,0,378,107,Yes
6UO1:2a,1521,0,271,6UO1:2a,1521,0,378,107,Yes
1VY4:AW,76,1,209,1VY4:AW,76,4,213,4,No
1VY4:AY,76,1,209,1VY4:AY,76,4,213,4,No
1VY4:CW,76,1,209,1VY4:CW,76,4,213,4,No
1VY4:CY,76,1,209,1VY4:CY,76,4,213,4,No
...
```

For details, look into the code available for download at the bottom of this page. The role of each line is commented for easier understanding.

!!! example "Example files"
    * [get_seq_jumping_description_from_CDHIT_clstr_info.awk](../data/get_seq_jumping_description_from_CDHIT_clstr_info.awk)  
    * [2020-03-13_cdhit_ide_0.98_cov_0.90.clstr](../data/2020-03-13_cdhit_ide_0.98_cov_0.90.clstr)  
    * [2020-03-13_cdhit_ide_1.00_cov_0.98.clstr](../data/2020-03-13_cdhit_ide_1.00_cov_0.98.clstr)
