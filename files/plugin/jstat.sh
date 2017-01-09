#!/bin/bash

# This file is managed by puppet

# This script is based on https://github.com/lukhas/collectd-jstat

[[ $# -eq 1 ]] || { echo 'The wrong number of arguments, exiting...'; exit 1; }

JSTAT=$(which jstat)
HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"
INTERVAL="${COLLECTD_INTERVAL:-60}"
PROGRAM=$(echo $1|tr '.' '_')

[[ -x "$JSTAT" ]] || { echo 'jstat not found, exiting...'; exit 2; }

while sleep "$INTERVAL"; do
  PID=$(jps -l | grep "$1" | cut -d ' ' -f1)

  # GC util + count + time
  JSTAT_RESULTS=(`$JSTAT -gcutil $PID`)
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_s0\" interval=$INTERVAL N:${JSTAT_RESULTS[11]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_s1\" interval=$INTERVAL N:${JSTAT_RESULTS[12]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_e\" interval=$INTERVAL N:${JSTAT_RESULTS[13]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_p\" interval=$INTERVAL N:${JSTAT_RESULTS[15]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_o\" interval=$INTERVAL N:${JSTAT_RESULTS[14]}"

  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/cache_operation-ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/cache_operation-fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  echo "PUTVAL \"$HOSTNAME/jvm-gctime-$PROGRAM/response_time-ngc\" interval=$INTERVAL N:${JSTAT_RESULTS[18]/./}"
  echo "PUTVAL \"$HOSTNAME/jvm-gctime-$PROGRAM/response_time-ogc\" interval=$INTERVAL N:${JSTAT_RESULTS[20]/./}"
  echo "PUTVAL \"$HOSTNAME/jvm-gctime-$PROGRAM/response_time-mc\" interval=$INTERVAL N:${JSTAT_RESULTS[21]/./}"

  # GC capacity
  JSTAT_RESULTS=(`$JSTAT -gccapacity $PID`)
  echo "PUTVAL \"$HOSTNAME/jvm-gccapacity-$PROGRAM/bytes-ngc\" interval=$INTERVAL N:${JSTAT_RESULTS[20]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccapacity-$PROGRAM/bytes-ogc\" interval=$INTERVAL N:${JSTAT_RESULTS[26]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccapacity-$PROGRAM/bytes-mc\" interval=$INTERVAL N:${JSTAT_RESULTS[31]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccapacity-$PROGRAM/bytes-s0c\" interval=$INTERVAL N:${JSTAT_RESULTS[21]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccapacity-$PROGRAM/bytes-s1c\" interval=$INTERVAL N:${JSTAT_RESULTS[22]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccapacity-$PROGRAM/bytes-ec\" interval=$INTERVAL N:${JSTAT_RESULTS[23]}"
done
