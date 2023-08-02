#!/system/bin/sh

MIN=50
MAX=80
CONTROL_FILE=/sys/class/power_supply/battery/input_suspend
CAPACITY=/sys/class/power_supply/battery/capacity
REFRESH_INTERVAL=15
THEFILE=thefile

if [ -e $THEFILE ]
then
   rm $THEFILE
   echo $THEFILE ' is removed'
fi

while true
do
  CURRENT_LEVEL=$(cat $CAPACITY)
  echo 'Battery level: ' $CURRENT_LEVEL

  if [ $CURRENT_LEVEL -gt $MAX ]
  then
    echo "1" > $CONTROL_FILE
    echo 'Suspending charging'
    THEVALUE=$(cat $CONTROL_FILE)
    echo 'Result:' $THEVALUE
    if ! [ -e $THEFILE ]
    then
       echo -n "" > $THEFILE
    fi  
  fi
  
  if [ $CURRENT_LEVEL -ge $MIN && $CURRENT_LEVEL -le $MAX ]
  then
    if [ -e $THEFILE ]
    then
       echo "1" > $CONTROL_FILE
       echo 'Suspending charging'
       THEVALUE=$(cat $CONTROL_FILE)
       echo 'Range:' $THEVALUE
    fi  
  fi

  if [ $CURRENT_LEVEL -lt $MIN ]
  then
    echo "0" > $CONTROL_FILE
    echo 'Resuming charging'
    THEVALUE=$(cat $CONTROL_FILE)
    echo 'Result:' $THEVALUE
    if [ -e $THEFILE ]
    then
       rm $THEFILE
       echo $THEFILE ' is removed'
    fi
  fi

  echo 'Wait...' $REFRESH_INTERVAL 's'
  sleep $REFRESH_INTERVAL
  THEVALUE=$(cat $CONTROL_FILE)
  echo 'Now:' $THEVALUE
done