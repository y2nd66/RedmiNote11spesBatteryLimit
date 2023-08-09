# RedmiNote11spesBatteryLimit

::Android Devices Monitor
  > D:\Projects\Android\SDK\tools\lib\monitor-x86_64\monitor.exe
  LogCat
    filter = tag:batterylimit
  
::crDroid
  Settings
    System
      Developer options
        + USB debugging
        
::Command Prompt
  > d:
  > cd D:\Projects\Android\SDK\platform-tools
  > adb forward tcp:8022 tcp:8022
    8022

::Termux
  > sshd
  
::PUTTY
  "D:\Tools\PuTTY\PUTTY.EXE"
  127.0.0.1 : 8022
  Accept
  <empyt>
  123456
  ...
  Welcome to Termux!
