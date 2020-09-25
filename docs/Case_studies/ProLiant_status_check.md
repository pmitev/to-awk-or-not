# ProLiant Status check
Here is another example of a common problem solved by awk script.

If you are running an HP ProLiant server, you might want to receive mail with the system health every day. In general that is easy, but what I want is, to check the report before delivery and make the subject reflect the general result i.e. ""
[ProLiant Status]: OK - if everything is fine or
[ProLiant Status]: !!!WARNING!!! followed by the problematic line/s

So, awk makes system calls and checks for "hot" keywords (FAIL, nok) indicating failures and checks the reported temperature values against the thresholds.

!!! note "ProLiant_Status.awk"
    ``` awk
    #!/usr/bin/awk -f
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
    ```

Here is how the report looks like:
``` java
Subject: [ProLiant Status - aberlour]: OK

> /usr/sbin/hpacucli controller all show status

Smart Array P212 in Slot 1
   Controller Status: OK
   Cache Status: OK
   Battery/Capacitor Status: OK


> /usr/sbin/hpacucli controller slot=1 logicaldrive all show status

   logicaldrive 1 (40.0 GB, 6): OK
   logicaldrive 2 (16.3 TB, 6): OK

> /usr/sbin/hpacucli controller slot=1 physicaldrive all show status

   physicaldrive 1I:1:1 (port 1I:box 1:bay 1, 3 TB): OK
   physicaldrive 1I:1:2 (port 1I:box 1:bay 2, 3 TB): OK
   physicaldrive 1I:1:3 (port 1I:box 1:bay 3, 3 TB): OK
   physicaldrive 1I:1:4 (port 1I:box 1:bay 4, 3 TB): OK
   physicaldrive 1I:1:5 (port 1I:box 1:bay 5, 3 TB): OK
   physicaldrive 1I:1:6 (port 1I:box 1:bay 6, 3 TB): OK
   physicaldrive 1I:1:7 (port 1I:box 1:bay 7, 3 TB): OK
   physicaldrive 1I:1:8 (port 1I:box 1:bay 8, 3 TB): OK

> /sbin/hpasmcli -s "SHOW ASR"

ASR timeout is 10 minutes.
ASR is currently enabled.

> /sbin/hpasmcli -s "SHOW FANS"

Fan  Location        Present Speed  of max  Redundant  Partner  Hot-pluggable
---  --------        ------- -----  ------  ---------  -------  -------------
#1   SYSTEM          Yes     NORMAL  55%     N/A        N/A      No            
#2   SYSTEM          Yes     NORMAL  55%     N/A        N/A      No            
#3   SYSTEM          Yes     NORMAL  59%     N/A        N/A      No            
#4   SYSTEM          Yes     NORMAL  53%     N/A        N/A      No            


> /sbin/hpasmcli -s "SHOW TEMP"

Sensor   Location              Temp       Threshold
------   --------              ----       ---------
#1        MEMORY_BD            33C/91F    87C/188F 
#2        MEMORY_BD             -         87C/188F 
#3        MEMORY_BD            33C/91F    87C/188F 
#4        MEMORY_BD             -         87C/188F 
#5        MEMORY_BD             -         87C/188F 
#6        MEMORY_BD             -         87C/188F 
#7        MEMORY_BD            40C/104F   95C/203F 
#8        MEMORY_BD             -         87C/188F 
#9        MEMORY_BD             -         87C/188F 
#10       MEMORY_BD             -         87C/188F 
#11       MEMORY_BD             -         87C/188F 
#12       MEMORY_BD             -         87C/188F 
#13       MEMORY_BD             -         87C/188F 
#14       MEMORY_BD             -         95C/203F 
#15       SYSTEM_BD             -         60C/140F 
#16       SYSTEM_BD             -         60C/140F 
#17       AMBIENT              30C/86F    60C/140F 
#18       AMBIENT              38C/100F   70C/158F 
#19       SYSTEM_BD            17C/62F    112C/233F
#20       SYSTEM_BD            41C/105F   79C/174F 
#21       SYSTEM_BD            31C/87F    60C/140F
``` 
!!! example "Files"
    * [ProLiant_Status.awk](../data/ProLiant_Status.awk)
