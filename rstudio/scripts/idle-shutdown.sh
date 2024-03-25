#!/bin/bash

#Customize these two values:
#threshold - threshold for cpu usage, used to determine if instance is idle. If usage goes above this number count resets to zero. By default 0.1 (10 percent)
#wait_minutes - length of time window in which threshold should not be broken. By default 60 (minutes)

threshold=0.1
wait_minutes=10

function set_cpu_last_active() {
  local attr_value="${1}"
  curl -s -X PUT --data "${attr_value}" \
    -H "Metadata-Flavor: Google" \
    "http://metadata.google.internal/computeMetadata/v1/instance/guest-attributes/cpu-utilization/last-active"
}
readonly -f set_cpu_last_active

count=0
while true
do

  load=$(uptime | sed -e 's/.*load average: //g' | awk '{ print $1 }') # 1-minute average load
  load="${load//,}" # remove trailing comma
  echo "cpu load is $load"
  res=$(echo $load'<'$threshold | bc -l)
  if (( $res ))
  then
    echo "Idling.."
    ((count+=1))
  else
    count=0
    set_cpu_last_active $(date +'%s')
  fi
  echo "Idle minutes count = $count"

  sleep 60

done
