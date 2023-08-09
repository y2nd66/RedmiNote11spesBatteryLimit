#!/system/bin/sh

MIN=50
MAX=80
CONTROL_FILE=/sys/class/power_supply/battery/input_suspend
CAPACITY_FILE=/sys/class/power_supply/battery/capacity
STATUS_FILE=/sys/class/power_supply/battery/status
POWERED_FILE=dumpsys battery | grep "AC powered: false"
FILE_VAR=var_file
INTERVAL_ON_VAR=10
INTERVAL_OFF_VAR=60

#if [ -e $FILE_VAR ]
#then
#   rm $FILE_VAR
#   echo $FILE_VAR 'is removed'
#fi

while true
do
  CONTROL_1_VAR=$(cat $CONTROL_FILE)
  CAPACITY_VAR=$(cat $CAPACITY_FILE)  
  POWERED_VAR=$($POWERED_FILE)
    
  if [[ $POWERED_VAR = "" ]]
  then
    if [[ $CAPACITY_VAR -lt $MIN && -e $FILE_VAR ]]
    then
      rm $FILE_VAR    
      echo "0" > $CONTROL_FILE    
      CONTROL_2_VAR=$(cat $CONTROL_FILE)    
      #echo $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR']' $FILE_VAR 'is removed, resuming charging...'
      log -t batterylimit $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR']' $FILE_VAR 'is removed, resuming charging...'
    else
      if [ $CAPACITY_VAR -gt $MAX ]
      then
        echo "1" > $CONTROL_FILE
        CONTROL_2_VAR=$(cat $CONTROL_FILE)
        if ! [ -e $FILE_VAR ]
        then
           echo -n "" > $FILE_VAR         
           #echo $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR']' $FILE_VAR 'is created, suspending charging...'
           log -t batterylimit $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR']' $FILE_VAR 'is created, suspending charging...'
        else
           #echo $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR'] suspending charging (1)...'
           log -t batterylimit $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR'] suspending charging (1)...'
        fi  
      else
        # $CAPACITY_VAR -ge $MIN && $CAPACITY_VAR -le $MAX
        if [ -e $FILE_VAR ]
        then
           echo "1" > $CONTROL_FILE
           CONTROL_2_VAR=$(cat $CONTROL_FILE)
           #echo $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR'] suspending charging (2)...'
           log -t batterylimit $CAPACITY_VAR':['$CONTROL_1_VAR':'$CONTROL_2_VAR'] suspending charging (2)...'
        else
          #echo $CAPACITY_VAR':['$CONTROL_1_VAR'] charging...'
          log -t batterylimit $CAPACITY_VAR':['$CONTROL_1_VAR'] charging...'
        fi  
      fi
    fi    
    INTERVAL_VAR=INTERVAL_ON_VAR
  else
    INTERVAL_VAR=INTERVAL_OFF_VAR
  fi
  STATUS_VAR=$(cat $STATUS_FILE)
  #echo 'Wait...' $INTERVAL_VAR's' $STATUS_VAR
  log -t batterylimit 'Wait...' $INTERVAL_VAR's ['$STATUS_VAR']'
  sleep $INTERVAL_VAR
done