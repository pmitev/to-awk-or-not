#!/usr/bin/awk -f

# For AWK Workshop by Pavlin Mitev
# Written by Martín González Buitrón with collaboration of Pavlin Mitev
# Email: martingonzalezbuitron@gmail.com
# Modify, share and use. FOSS.

BEGIN{
    #Checking that each argument is in its place, otherwise print help.
    if(ARGC <= 2 || ARGC > 3){
        print "\nUsage:\n\n ./script.awk <CDHit-1.clstr> <CDHit-2.clstr>\n"
        exit
    }
    #CDHit use ">Cluster" for each cluster
    #so it was chose for Record Separator
    #because of that.
    RS=">Cluster"
    #CDHit separate each seq member with a number
    #plus "\t".
    FS="\t"
    #Print output header
    printf("File1,,,,File2,,,,\n")
    printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",\
            "query_code",\
            "query_length",\
            "cluster_number_in_file_1",\
            "cluster_size_in_file_1",\
            "target_code",\
            "target_length",\
            "cluster_number_in_file_2",\
            "cluster_size_in_file_2",\
            "cluster_size_diff",\
            "same_cluster")
    #Set ARGC equal 2 so only process until file 1
    ARGC=2
}
{
    #Start reading RECORDS per FILE but don't pay attention to first field (cluster name)
    if (NF == 0){
        next
    }
    #Save amount of all queries in this cluster
    total_seqs_in_cluster_file_1=NF
    #Go through one cluster in file 1
    for(i=2;i<=total_seqs_in_cluster_file_1;i++){
        query=$i
        #Processing query string
        split(query,query_array,"|")
        split(query_array[1],length_code_query_array,"nt, >")
        #Save query
        query_code=length_code_query_array[2]
        #Save length of query
        query_length=length_code_query_array[1]
        #Processing cluster string
        split($1,cluster_line_array," ")
        #Get cluster info
        cluster_number_in_file_1=cluster_line_array[1]
        cluster_size_in_file_1=(total_seqs_in_cluster_file_1-1)
        #Load second file file to search the query
        while(getline cluster_in_file_2 < ARGV[2]){
            #Split cluster_in_file_2 to be used
            NF2=split(cluster_in_file_2,all_cluster_lines_array_file_2,"\t")
            #Start reading RECORDS per FILE but don't pay attention to first field (cluster name)
            if (NF2 == 0){
                continue
            }
            #Save amount of all targets in this cluster
            total_seqs_in_cluster_file_2=NF2
            #Go through one cluster in file 2
            for(j=2;j<=total_seqs_in_cluster_file_2;j++){
                target=all_cluster_lines_array_file_2[j]
                #Processing member string
                split(target,target_array,"|")
                split(target_array[1],length_code_target_array,"nt, >")
                #Save possible target
                target_code=length_code_target_array[2]
                #Save length of possible target
                target_length=length_code_target_array[1]
                # Check if query is the same as possible target
                if(query_code == target_code){
                    #Processing cluster string
                    split(all_cluster_lines_array_file_2[1],cluster_line_array_file_2," ")
                    #Get cluster info
                    cluster_number_in_file_2=cluster_line_array_file_2[1]
                    cluster_size_in_file_2=(total_seqs_in_cluster_file_2-1)
                    #Get cluster sizes difference
                    cluster_size_diff=(cluster_size_in_file_2-cluster_size_in_file_1)
                    #Get cluster location comparation
                    same_cluster=(cluster_number_in_file_2-cluster_number_in_file_1)
                    if (same_cluster == 0){
                        same_cluster="Yes"
                    }
                    else{
                        same_cluster="No"
                    }
                    printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
                                query_code,\
                                query_length,\
                                cluster_number_in_file_1,\
                                cluster_size_in_file_1,\
                                target_code,\
                                target_length,\
                                cluster_number_in_file_2,\
                                cluster_size_in_file_2,\
                                cluster_size_diff,\
                                same_cluster)
                    break
                }
            }
            #Keep searching this query or go for the next one?
            if(query_code == target_code){
                #Query was found it in earlier cluster
                #so close second file and go to the next query.
                close(ARGV[2])
                break

            }
            else{
                #Query was not found it in earlier cluster
                #so go to next cluster.
                continue
            }
        }
        continue
    }
}
