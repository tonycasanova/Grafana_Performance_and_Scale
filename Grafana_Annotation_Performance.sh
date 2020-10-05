#!/bin/bash

# Grafana Annotation Performaance Script
# Created by: Tony Casanova https://twitter.com/tonycasanova
# Date: October 4, 2020

# Purpose: Creata bulk Grafana annotations via API.
# Used to measure how many annonations can be made per unit of time and large scale GUI testing.

printf "# Grafana Annotation Performaance Script\n"

echo "Hello"
# Variables.
GRAFANA_HOST_IP_ADDRESS="<insert_Gafana_Host_IP_Address_here>"
GRAFANA_HOST_IP_PORT="3000"
GRAFANA_API_KEY="<insert_Grafana_API_KEY_here>"
GRAFANA_ANNOTATIONS_COUNT="100"

# Record START time.

printf "Grafana_Performance_START_TIME_UTC=\`echo \$((\$(date +%%s%%N)/1000000))\`; export Grafana_Performance_START_TIME_UTC; echo \$Grafana_Performance_START_TIME_UTC\n\n"

cmd=$(printf "Grafana_Performance_START_TIME_UTC=\`echo \$((\$(date +%%s%%N)/1000000))\`; export Grafana_Performance_START_TIME_UTC; echo \$Grafana_Performance_START_TIME_UTC\n\n")
echo "$cmd"
echo "$cmd" > Grafana_cmd_to_run.curl

# Loop
for ((counter = 1; counter <= $GRAFANA_ANNOTATIONS_COUNT ; counter++ ))
do
cmd=$(printf "time curl --insecure -H \"Authorization: Bearer %s\" http://%s:%s/api/annotations -H \"Content-Type: application/json\" -d \'{\"text\":\"test_%s\",\"tags\":[\"GrafanaPerfTest\"]\'};echo \"\"" $GRAFANA_API_KEY $GRAFANA_HOST_IP_ADDRESS $GRAFANA_HOST_IP_PORT $counter)
echo "$cmd"
echo "$cmd" >> Grafana_cmd_to_run.curl
done

printf "Grafana_Performance_STOP_TIME_UTC=\`echo \$((\$(date +%%s%%N)/1000000))\`; export Grafana_Performance_STOP_TIME_UTC; echo \$Grafana_Performance_STOP_TIME_UTC\n\n"
cmd=$(printf "Grafana_Performance_STOP_TIME_UTC=\`echo \$((\$(date +%%s%%N)/1000000))\`; export Grafana_Performance_STOP_TIME_UTC; echo \$Grafana_Performance_STOP_TIME_UTC\n\n")
echo "$cmd"
echo "$cmd" >> Grafana_cmd_to_run.curl

# Find Duration - ms
printf "let Grafana_Performance_Duration_ms=\$Grafana_Performance_STOP_TIME_UTC-\$Grafana_Performance_START_TIME_UTC;echo \"Grafana_Performance_Duration_ms: \$Grafana_Performance_Duration_ms\"\n"
cmd=$(printf "let Grafana_Performance_Duration_ms=\$Grafana_Performance_STOP_TIME_UTC-\$Grafana_Performance_START_TIME_UTC;echo \"Grafana_Performance_Duration_ms: \$Grafana_Performance_Duration_ms\"\n")
echo "$cmd"
echo "$cmd" >> Grafana_cmd_to_run.curl

# Find Duration - seconds
printf "Grafana_Performance_Duration_secs=\`echo \$Grafana_Performance_Duration_ms / 1000 | bc -l\`\n"
cmd=$(printf "Grafana_Performance_Duration_secs=\`echo \$Grafana_Performance_Duration_ms / 1000 | bc -l\`\n")
echo "$cmd"
echo "$cmd" >> Grafana_cmd_to_run.curl

printf "echo \"Grafana_Performance_Duration_secs: \$Grafana_Performance_Duration_secs\"\n"
cmd=$(printf "echo \"Grafana_Performance_Duration_secs: \$Grafana_Performance_Duration_secs\"\n")
echo "$cmd"
echo "$cmd" >> Grafana_cmd_to_run.curl


echo ""
echo "Running command here:"
echo "Grafana - START"
echo ""
echo ""
source ./Grafana_cmd_to_run.curl
echo ""
echo ""
echo "Grafana - STOP"
