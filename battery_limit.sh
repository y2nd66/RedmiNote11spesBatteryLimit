#!/system/bin/sh

MIN=50
MAX=80
CONTROL_FILE=/sys/class/power_supply/battery/input_suspend
CAPACITY=/sys/class/power_supply/battery/capacity
REFRESH_INTERVAL=15
VAR_FILE=var_file

#if [ -e $VAR_FILE ]
#then
#   rm $VAR_FILE
#   echo $VAR_FILE ' is removed'
#fi

while true
do
  CURRENT_LEVEL=$(cat $CAPACITY)
  echo 'Battery level: ' $CURRENT_LEVEL
  
  if [[ $CURRENT_LEVEL -lt $MIN && -e $VAR_FILE ]]
  then
    rm $VAR_FILE
    echo $VAR_FILE ' is removed'
    
    echo "0" > $CONTROL_FILE
    echo 'Resuming charging (1)'
    
    THEVALUE=$(cat $CONTROL_FILE)
    echo 'Control:' $THEVALUE    
  else
    if [ $CURRENT_LEVEL -gt $MAX ]
    then
      echo "1" > $CONTROL_FILE
      echo 'Suspending charging (2)'
      
      THEVALUE=$(cat $CONTROL_FILE)
      echo 'Control:' $THEVALUE
      
      if ! [ -e $VAR_FILE ]
      then
         echo -n "" > $VAR_FILE
         echo 'File' $VAR_FILE
      fi  
    else
      # $CURRENT_LEVEL -ge $MIN && $CURRENT_LEVEL -le $MAX
      if [ -e $VAR_FILE ]
      then
         echo "1" > $CONTROL_FILE
         echo 'Suspending charging (3)'
         
         THEVALUE=$(cat $CONTROL_FILE)
         echo 'Control:' $THEVALUE
      else
        echo 'Charging (4)'
      fi  
    fi
  fi  

  echo 'Wait...' $REFRESH_INTERVAL 's'
  sleep $REFRESH_INTERVAL
  
  THEVALUE=$(cat $CONTROL_FILE)
  echo 'Control:' $THEVALUE
done