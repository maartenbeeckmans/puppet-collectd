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
  ########################

  JSTAT_RESULTS=(`$JSTAT -gcutil $PID`)
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_s0\" interval=$INTERVAL N:${JSTAT_RESULTS[11]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_s1\" interval=$INTERVAL N:${JSTAT_RESULTS[12]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_e\" interval=$INTERVAL N:${JSTAT_RESULTS[13]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_p\" interval=$INTERVAL N:${JSTAT_RESULTS[15]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_o\" interval=$INTERVAL N:${JSTAT_RESULTS[14]}"

  # derive
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/cache_operation-ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/cache_operation-fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  # gauge
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  # derive
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/cache_operation-ygct\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/cache_operation-fgct\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  # gauge
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-ygct\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-fgct\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  # GC
  ####

  JSTAT_RESULTS=(`$JSTAT -gc $PID`)
  # capacity
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/capacity-s0c\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/capacity-s1c\" interval=$INTERVAL N:${JSTAT_RESULTS[18]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/capacity-ec\" interval=$INTERVAL N:${JSTAT_RESULTS[21]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/capacity-oc\" interval=$INTERVAL N:${JSTAT_RESULTS[23]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/capacity-mc\" interval=$INTERVAL N:${JSTAT_RESULTS[25]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/capacity-ccsc\" interval=$INTERVAL N:${JSTAT_RESULTS[27]}"
  # used
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-s0u\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-s1u\" interval=$INTERVAL N:${JSTAT_RESULTS[20]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-eu\" interval=$INTERVAL N:${JSTAT_RESULTS[22]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-ou\" interval=$INTERVAL N:${JSTAT_RESULTS[24]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-mu\" interval=$INTERVAL N:${JSTAT_RESULTS[26]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-ccsu\" interval=$INTERVAL N:${JSTAT_RESULTS[28]}"


done
