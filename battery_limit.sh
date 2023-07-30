#!/data/data/com.termux/files/usr/bin/bash
MIN=50
MAX=80
CONTROL_FILE=/sys/class/power_supply/battery/input_suspend
CAPACITY=/sys/class/power_supply/battery/capacity
REFRESH_INTERVAL=60

while true
do
  CURRENT_LEVEL=$(cat $CAPACITY)
  echo 'Battery level: ' $CURRENT_LEVEL
  if [[ $CURRENT_LEVEL > $MAX ]]; then
    echo "1" > $CONTROL_FILE
    echo 'Suspending charging'
  fi

  if [[ $CURRENT_LEVEL < $MIN ]]; then
    echo "0" > $CONTROL_FILE
    echo 'Resuming charging'
  fi

  sleep $REFRESH_INTERVAL
done