i# Awk and json

To begin with, awk is not strong at dealing with json or csv. Having said that, one can still tackle particular or specific problems.

Here is a small piece from the stream of json formatted data coming from different sensors.

!!! note "rtl_433a.log"
    ``` json
    {"time" : "2020-12-19 08:50:39", "model" : "Fineoffset-TelldusProove", "id" : 183, "temperature_C" : 21.800, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:50:40", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.900, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:50:44", "model" : "Fineoffset-TelldusProove", "id" : 184, "temperature_C" : 20.200, "mic" : "CRC"}
    {"time" : "2020-12-19 08:50:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 20, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
    {"time" : "2020-12-19 08:50:48", "model" : "Acurite-Rain", "id" : 34, "rain_mm" : 851.000}
    {"time" : "2020-12-19 08:50:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 16, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
    {"time" : "2020-12-19 08:50:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 16, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
    {"time" : "2020-12-19 08:50:54", "model" : "Fineoffset-WH2", "id" : 215, "temperature_C" : 22.600, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:50:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 0}
    {"time" : "2020-12-19 08:50:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 1}
    {"time" : "2020-12-19 08:50:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 2}
    {"time" : "2020-12-19 08:51:00", "model" : "Acurite-Rain", "id" : 9, "rain_mm" : 2032.000}
    {"time" : "2020-12-19 08:51:16", "model" : "Nexus-TH", "id" : 4, "channel" : 2, "battery" : 71, "temperature_C" : 6.800, "humidity" : 89}
    {"time" : "2020-12-19 08:51:16", "model" : "Eurochron-TH", "id" : 4, "battery" : 40, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
    {"time" : "2020-12-19 08:51:27", "model" : "Fineoffset-TelldusProove", "id" : 183, "temperature_C" : 21.800, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:51:28", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.900, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:51:32", "model" : "Fineoffset-TelldusProove", "id" : 184, "temperature_C" : 20.200, "mic" : "CRC"}
    {"time" : "2020-12-19 08:51:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
    {"time" : "2020-12-19 08:51:48", "model" : "Acurite-Rain", "id" : 34, "rain_mm" : 851.000}
    {"time" : "2020-12-19 08:51:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
    {"time" : "2020-12-19 08:51:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
    {"time" : "2020-12-19 08:51:54", "model" : "Fineoffset-WH2", "id" : 216, "temperature_C" : 21.600, "mic" : "CRC"}
    {"time" : "2020-12-19 08:51:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 1}
    {"time" : "2020-12-19 08:51:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 2}
    {"time" : "2020-12-19 08:52:15", "model" : "Fineoffset-TelldusProove", "id" : 183, "temperature_C" : 21.800, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:52:16", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:52:16", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:52:16", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:52:20", "model" : "Fineoffset-TelldusProove", "id" : 184, "temperature_C" : 20.100, "mic" : "CRC"}
    {"time" : "2020-12-19 08:52:23", "model" : "Nexus-TH", "id" : 4, "channel" : 2, "battery" : 71, "temperature_C" : 6.800, "humidity" : 89}
    {"time" : "2020-12-19 08:52:23", "model" : "Eurochron-TH", "id" : 4, "battery" : 30, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
    {"time" : "2020-12-19 08:52:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 14, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
    {"time" : "2020-12-19 08:52:48", "model" : "Acurite-Rain", "id" : 34, "rain_mm" : 851.000}
    {"time" : "2020-12-19 08:52:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
    {"time" : "2020-12-19 08:52:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
    {"time" : "2020-12-19 08:52:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 0}
    {"time" : "2020-12-19 08:52:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 1}
    {"time" : "2020-12-19 08:52:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 2}
    {"time" : "2020-12-19 08:53:03", "model" : "Fineoffset-TelldusProove", "id" : 183, "temperature_C" : 21.900, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:04", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:08", "model" : "Fineoffset-TelldusProove", "id" : 184, "temperature_C" : 20.100, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:30", "model" : "Nexus-TH", "id" : 4, "channel" : 2, "battery" : 71, "temperature_C" : 6.800, "humidity" : 89}
    {"time" : "2020-12-19 08:53:30", "model" : "Eurochron-TH", "id" : 4, "battery" : 20, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
    {"time" : "2020-12-19 08:53:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 13, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
    {"time" : "2020-12-19 08:53:48", "model" : "Acurite-Rain", "id" : 34, "rain_mm" : 851.000}
    {"time" : "2020-12-19 08:53:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 12, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
    {"time" : "2020-12-19 08:53:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 12, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
    {"time" : "2020-12-19 08:53:51", "model" : "Fineoffset-TelldusProove", "id" : 183, "temperature_C" : 21.900, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:52", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 74, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:54", "model" : "Fineoffset-WH2", "id" : 216, "temperature_C" : 21.600, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:56", "model" : "Fineoffset-TelldusProove", "id" : 184, "temperature_C" : 20.100, "mic" : "CRC"}
    {"time" : "2020-12-19 08:53:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 0}
    {"time" : "2020-12-19 08:53:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 1}
    {"time" : "2020-12-19 08:53:58", "model" : "WT450-TH", "id" : 15, "channel" : 1, "battery" : 100, "temperature_C" : 7.125, "humidity" : 90, "seq" : 2}
    {"time" : "2020-12-19 08:54:37", "model" : "Nexus-TH", "id" : 4, "channel" : 2, "battery" : 71, "temperature_C" : 6.800, "humidity" : 89}
    {"time" : "2020-12-19 08:54:37", "model" : "Eurochron-TH", "id" : 4, "battery" : 20, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
    {"time" : "2020-12-19 08:54:39", "model" : "Fineoffset-TelldusProove", "id" : 183, "temperature_C" : 21.800, "humidity" : 45, "mic" : "CRC"}
    {"time" : "2020-12-19 08:54:40", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 75, "mic" : "CRC"}
    {"time" : "2020-12-19 08:54:40", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 75, "mic" : "CRC"}
    {"time" : "2020-12-19 08:54:40", "model" : "Fineoffset-WH5", "id" : 200, "temperature_C" : -31.800, "humidity" : 75, "mic" : "CRC"}
    {"time" : "2020-12-19 08:54:44", "model" : "Fineoffset-TelldusProove", "id" : 184, "temperature_C" : 20.100, "mic" : "CRC"}
    {"time" : "2020-12-19 08:54:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 10, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
    {"time" : "2020-12-19 08:54:48", "model" : "Acurite-Rain", "id" : 34, "rain_mm" : 851.000}
    {"time" : "2020-12-19 08:54:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 10, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
    {"time" : "2020-12-19 08:54:54", "model" : "Fineoffset-WH2", "id" : 215, "temperature_C" : 22.600, "humidity" : 45, "mic" : "CRC"}
    ```

## Task 1
We are interested only from the temperature values for `Fineoffset-TelldusProove` with `id : 183`, so let's tabulate them to something we can easily read and plot. ( * )


```
2020-12-19T08:50:39 21.800
2020-12-19T08:51:27 21.800
2020-12-19T08:52:15 21.800
2020-12-19T08:53:03 21.900
2020-12-19T08:53:51 21.900
2020-12-19T08:54:39 21.800
```

??? "Possible solution"
    ``` bash
    awk '/"Fineoffset-TelldusProove", "id" : 183/ {gsub(",|\"",""); print $3"T"$4,$13}' rtl_433a.log
    ```

## Task 2 
We want to filter the stream and print the original line for sensors with value for battery less than 20%. ( *** )

``` json
{"time" : "2020-12-19 08:50:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 20, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
{"time" : "2020-12-19 08:50:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 16, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
{"time" : "2020-12-19 08:50:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 16, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
{"time" : "2020-12-19 08:51:16", "model" : "Eurochron-TH", "id" : 4, "battery" : 40, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
{"time" : "2020-12-19 08:51:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
{"time" : "2020-12-19 08:51:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
{"time" : "2020-12-19 08:51:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
{"time" : "2020-12-19 08:52:23", "model" : "Eurochron-TH", "id" : 4, "battery" : 30, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
{"time" : "2020-12-19 08:52:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 14, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
{"time" : "2020-12-19 08:52:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
{"time" : "2020-12-19 08:52:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 15, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
{"time" : "2020-12-19 08:53:30", "model" : "Eurochron-TH", "id" : 4, "battery" : 20, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
{"time" : "2020-12-19 08:53:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 13, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
{"time" : "2020-12-19 08:53:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 12, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
{"time" : "2020-12-19 08:53:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 12, "temperature_C" : 23.250, "humidity" : 36, "seq" : 2}
{"time" : "2020-12-19 08:54:37", "model" : "Eurochron-TH", "id" : 4, "battery" : 20, "temperature_C" : -16.700, "humidity" : 68, "button" : 1}
{"time" : "2020-12-19 08:54:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 10, "temperature_C" : 23.250, "humidity" : 36, "seq" : 0}
{"time" : "2020-12-19 08:54:48", "model" : "WT450-TH", "id" : 13, "channel" : 1, "battery" : 10, "temperature_C" : 23.250, "humidity" : 36, "seq" : 1}
```

??? "Possible solution"
    ``` bash
    awk -F '"battery" :' '/battery/{if ($2+0<=50) print $0 }' rtl_433a.log

    # Same result using proper tool (something like advanced grep or basic awk for json)
    # https://stedolan.github.io/jq/
    jq -r -c  'select(.battery > 0 and .battery <= 20)' rtl_433a.log
    ```
