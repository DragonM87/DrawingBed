#!/bin/bash
# chkconfig: 345 20 80 
# description: Weblogic Server auto start/stop script.
# /etc/rc.d/init.d/weblogic 

# Please edit the variable 
export BEA_BASE=/home/weblogic/
export BEA_HOME=$BEA_BASE/start_script
export BEA_LOG=$BEA_HOME/nohup.out 
#export PATH=$PATH:$BEA_HOME

BEA_OWNR="weblogic" 
BEA_GROUP=su $BEA_OWNR -c "groups"

# if the executables do not exist -- display error 

if [ ! -f $BEA_HOME/start_admin.sh -o ! -d $BEA_HOME ] 
then 
      echo "WebLogic startup: cannot start" 
      exit 1 
fi 
if [ -d /data ] 
then 
      chown -R $BEA_OWNR:$BEA_GROUP /data
fi 
# depending on parameter -- startup, shutdown, restart 

case "$1" in 
  start) 
      echo -n "Starting WebLogic,log file $BEA_LOG: " 
      touch /var/lock/weblogic 
      chown -R $BEA_OWNR:$BEA_GROUP $BEA_BASE
      su $BEA_OWNR -c "cd ${BEA_HOME}; nohup ./start_admin.sh > $BEA_LOG 2>&1  &" 
      echo "OK" 
      ;; 
  stop) 
      echo -n "Shutdown WebLogic: " 
      rm -f /var/lock/weblogic 
      chown -R $BEA_OWNR:$BEA_GROUP $BEA_BASE
      su $BEA_OWNR -c "cd ${BEA_HOME}; ./stop_admin.sh >> $BEA_LOG" 
      echo "OK" 
      ;; 
  reload|restart) 
      $0 stop 
      $0 start 
      ;; 
  *) 
      echo "Usage: `basename $0` start|stop|restart|reload" 
      exit 1 
esac 
exit 0 