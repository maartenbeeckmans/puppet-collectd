#!/bin/bash

# This file is managed by puppet

# This script is based on https://github.com/lukhas/collectd-jstat

[[ $# -ge 1 && $# -le 2 ]] || { echo 'The wrong number of arguments, exiting...'; exit 1; }

HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"
INTERVAL="${COLLECTD_INTERVAL:-60}"
SUDO=''

[[ -x '/bin/jstat' ]] || { echo 'jstat not found, exiting...'; exit 2; }

for i in "$@";do
  case $i in
    -s|--sudo)
    SUDO=sudo
    ;;
    *)
    PROGRAM="$i"
    ;;
  esac
done

PROGRAM_SAFE_CHARS=$(echo "$PROGRAM"|tr '.' '_'|tr '/' '_')

while sleep "$INTERVAL"; do

  PID=$($SUDO /bin/jps -l | grep "$PROGRAM" | cut -d ' ' -f1)

  # GC util + count + time
  ########################

  # run jstat only when PID is a number
  [[ "$PID" =~ ^[0-9]+$ ]] && JSTAT_RESULTS=(`$SUDO /bin/jstat -gcutil $PID`)
  [[ $? -ne 0 ]] && continue

  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM_SAFE_CHARS/percent-used_survivor0_s0\" interval=$INTERVAL N:${JSTAT_RESULTS[11]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM_SAFE_CHARS/percent-used_survivor1_s1\" interval=$INTERVAL N:${JSTAT_RESULTS[12]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM_SAFE_CHARS/percent-used_eden_e\" interval=$INTERVAL N:${JSTAT_RESULTS[13]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM_SAFE_CHARS/percent-used_old_o\" interval=$INTERVAL N:${JSTAT_RESULTS[14]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gcutil-$PROGRAM_SAFE_CHARS/percent-used_metaspace_m\" interval=$INTERVAL N:${JSTAT_RESULTS[15]}"

  # derive
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/derive-young_gc_ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/derive-full_gc_fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  # gauge
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/count-young_gc_ygc\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/count-full_gc_fgc\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  # derive
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/derive-young_gc_time_ygct\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/derive-full_gc_time_fgct\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  # gauge
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/count-young_gc_time_ygct\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gccount-$PROGRAM_SAFE_CHARS/count-full_gc_time_fgct\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"

  # GC
  ####

  JSTAT_RESULTS=(`$SUDO /bin/jstat -gc $PID`)
  # capacity
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-survivor0_capacity_s0c\" interval=$INTERVAL N:${JSTAT_RESULTS[17]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-survivor1_capacity_s1c\" interval=$INTERVAL N:${JSTAT_RESULTS[18]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-eden_capacity_ec\" interval=$INTERVAL N:${JSTAT_RESULTS[21]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-old_capacity_oc\" interval=$INTERVAL N:${JSTAT_RESULTS[23]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-metaspace_capacity_mc\" interval=$INTERVAL N:${JSTAT_RESULTS[25]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-compressed_class_capacity_ccsc\" interval=$INTERVAL N:${JSTAT_RESULTS[27]}"
  # used
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-survivor0_used_s0u\" interval=$INTERVAL N:${JSTAT_RESULTS[19]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-survivor1_used_s1u\" interval=$INTERVAL N:${JSTAT_RESULTS[20]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-eden_used_eu\" interval=$INTERVAL N:${JSTAT_RESULTS[22]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-old_used_ou\" interval=$INTERVAL N:${JSTAT_RESULTS[24]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-metaspace_used_mu\" interval=$INTERVAL N:${JSTAT_RESULTS[26]}"
  echo "PUTVAL \"$HOSTNAME/jvm-gc-$PROGRAM_SAFE_CHARS/bytes-compressed_class_used_ccsu\" interval=$INTERVAL N:${JSTAT_RESULTS[28]}"


done
