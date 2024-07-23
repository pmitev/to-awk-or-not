#!/bin/awk -f
# This script will execute the commands bellow, collect the output
# then check for failures and mail the status
# The subject of the mail will be:
# [ProLiant Status]: OK - if everything is fine or
# [ProLiant Status]: !!!WARNING!!! followed by the problematic line/s
BEGIN {

  cmd="/usr/sbin/hpacucli controller all show status";
  line[l++]="> "cmd;  get_output(cmd);
 
  cmd="/usr/sbin/hpacucli controller slot=0 logicaldrive all show status"; 
  line[l++]="> "cmd; get_output(cmd);

  cmd="/usr/sbin/hpacucli controller slot=0 physicaldrive all show status"; 
  line[l++]="> "cmd; get_output(cmd);

  
  cmd="/sbin/hpasmcli -s \"SHOW ASR\"";  
  line[l++]="> "cmd; get_output(cmd);

  cmd="/sbin/hpasmcli -s \"SHOW FANS\"";
  line[l++]="> "cmd; get_output(cmd);

  cmd="/sbin/hpasmcli -s \"SHOW TEMP\"";
  line[l++]="> "cmd; get_output(cmd);

  
# Compose a mail containing the output
  if (! SUBJ) SUBJ="[ProLiant Status - allium]: OK";
  else SUBJ="[ProLiant Status - allium]: !!!WARNING!!! "SUBJ

  cmd="mail -s \""SUBJ"\" root"
#  cmd="cat" # print on screen instead mailing
  for (i=0;i<=l;i++) {
    print line[i] | cmd
  }
  close(cmd);
}


# Collects the output and checks for failures
function get_output(command) {

  while (cmd | getline) {
    line[l++]=$0;
    # check the line for NOK or FAIL
    if (tolower($0) ~ "nok|fail")  SUBJ=SUBJ" "$0
   
    # if the line contains temperature info - check the threshold
    if ($0 ~ "C.*F.*C.*F") {
      gsub("C/"," ",$0); # trick to get easily only the numbers
      if ($3 >= $5) SUBJ=SUBJ" "$0
    }
  }
  close(cmd)
}
