#!/bin/bash

# This file is managed by puppet

# This script is based on https://github.com/lukhas/collectd-jstat

[[ $# -eq 1 ]] || { echo 'The wrong number of arguments, exiting...'; exit 1; }

HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"
INTERVAL="${COLLECTD_INTERVAL:-60}"
PROGRAM=$(echo $1|tr '.' '_'|tr '/' '_')
SUDO=''

[[ -x '/bin/jstat' ]] || { echo 'jstat not found, exiting...'; exit 2; }

while sleep "$INTERVAL"; do

  PID=$(/bin/jps -l | grep "$1" | cut -d ' ' -f1)

  # try to run jps with sudo when PID is not a number
  [[ "$PID" =~ '^[0-9]+$' ]] || { PID=$(sudo /bin/jps -l | grep "$1" | cut -d ' ' -f1); SUDO=sudo ; }


  # GC util + count + time
  ########################

  JSTAT_RESULTS=(`$SUDO /bin/jstat -gcutil $PID`)
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_survivor0_s0\" interval=$INTERVAL N:${JSTAT_RESULTS[11]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_survivor1_s1\" interval=$INTERVAL N:${JSTAT_RESULTS[12]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_eden_e\" interval=$INTERVAL N:${JSTAT_RESULTS[13]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_old_o\" interval=$INTERVAL N:${JSTAT_RESULTS[14]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM/percent-used_metaspace_m\" interval=$INTERVAL N:${JSTAT_RESULTS[15]}"

  # derive
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/derive-young_gc_ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/derive-full_gc_fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  # gauge
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-young_gc_ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-full_gc_fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  # derive
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/derive-young_gc_time_ygct\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/derive-full_gc_time_fgct\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  # gauge
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-young_gc_time_ygct\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM/count-full_gc_time_fgct\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  # GC
  ####

  JSTAT_RESULTS=(`$SUDO /bin/jstat -gc $PID`)
  # capacity
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-survivor0_capacity_s0c\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-survivor1_capacity_s1c\" interval=$INTERVAL N:${JSTAT_RESULTS[18]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-eden_capacity_ec\" interval=$INTERVAL N:${JSTAT_RESULTS[21]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-old_capacity_oc\" interval=$INTERVAL N:${JSTAT_RESULTS[23]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-metaspace_capacity_mc\" interval=$INTERVAL N:${JSTAT_RESULTS[25]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-compressed_class_capacity_ccsc\" interval=$INTERVAL N:${JSTAT_RESULTS[27]}"
  # used
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-survivor0_used_s0u\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-survivor1_used_s1u\" interval=$INTERVAL N:${JSTAT_RESULTS[20]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-eden_used_eu\" interval=$INTERVAL N:${JSTAT_RESULTS[22]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-old_used_ou\" interval=$INTERVAL N:${JSTAT_RESULTS[24]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-metaspace_used_mu\" interval=$INTERVAL N:${JSTAT_RESULTS[26]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM/bytes-compressed_class_used_ccsu\" interval=$INTERVAL N:${JSTAT_RESULTS[28]}"


done
