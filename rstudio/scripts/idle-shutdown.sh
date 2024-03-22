#!/bin/bash

#Customize these two values:
#threshold - threshold for cpu usage, used to determine if instance is idle. If usage goes above this number count resets to zero. By default 0.1 (10 percent)
#wait_minutes - length of time window in which threshold should not be broken. By default 60 (minutes)

threshold=0.1
wait_minutes=60

count=0
while true
do

  load=$(uptime | sed -e 's/.*load average: //g' | awk '{ print $1 }') # 1-minute average load
  load="${load//,}" # remove trailing comma
  res=$(echo $load'<'$threshold | bc -l)
  if (( $res ))
  then
    echo "Idling.."
    ((count+=1))
  else
    count=0
  fi
  echo "Idle minutes count = $count"

  if (( count>wait_minutes ))
  then
    echo Shutting down
    # wait a little bit more before actually pulling the plug
    sleep 300
    sudo poweroff
  fi

  sleep 60

done
