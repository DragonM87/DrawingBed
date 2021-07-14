#����:����shell�ű�spool���ݵ�һָ���� 
#!/bin/bash
###############################
# 1.define #
###############################
#----------1.1_set param-------#
#���ݿ��û���
ORA_USER=agent1
#���ݿ��û�����
ORA_PASS=agent1
#��½��������(Ҳ��@������Ӵ�)
ORA_LOCAL_NAME=callsrv
#��ŵ������ݵı���·��

echo "======================================================================="
echo "database username: ${ORA_USER}"
echo "the path of the file: ${ORA_PASS}"
Cur_Date=`date -d  '1 day ago' +%Y%m%d`
echo "----ʱ��----------${Cur_Date}------------"
Cur_time=`date "+%Y%m%d %H%M%S"`
echo "----��?------${Cur_time}------------"
TMPFILE="service_${Cur_Date}.dat"
echo "export max service data to file�� ${TMPFILE}"
echo $NLS_LANG
#su - oracle -c
export NLS_LANG=American_America.ZHS16GBK
export ORACLE_BASE=/opt/app/oracle
export ORACLE_HOME=/opt/app/oracle/oracle/product/10.2.0/db_1
export ORACLE_SID=callsrv
#export LIBPATH=$ORACLE_HOME/lib32:$ORACLE_HOME/precomp/lib32
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/precomp/lib32:$PATH
echo $NLS_LANG
sqlplus -s $ORA_USER/$ORA_PASS@$ORA_LOCAL_NAME <<EOF >/dev/null
@/home/agent/bin/txlog.sql
@/home/agent/bin/tb_agent_telerecord.sql
@/home/agent/bin/acl_oper.sql     
@/home/agent/bin/acl_oper_his.sql
@/home/agent/bin/tb_cust_info.sql
@/home/agent/bin/finish.sql
EOF
#@/home/agent/bin/tb_agent_telerecord.sql
#@/home/agent/bin/acl_oper.sql     
#@/home/agent/bin/acl_oper_his.sql 
#@/home/agent/bin/tb_cust_info.sql
#rm -rf /home/TB_TXLOG_HISTORY_*.dat
#!/bin/bash
echo "start ----------------"
#ftp -u -n 10.172.45.5
ftp -i -in <<! 
#open 10.172.44.101
open 10.50.116.21
user pb pb
passive
binary
cd /dsbdata/ods_data_up/PB/ 
lcd /home
prompt
#put *.dmp
put PB_TXLOG_HISTORY_$Cur_Date.dat
put PB_ACL_OPER_$Cur_Date.dat
put PB_ACL_OPER_HIS_$Cur_Date.dat
put PB_TB_AGENT_TELRECORD_$Cur_Date.dat
put PB_CUST_INFO_$Cur_Date.dat
put pb_$Cur_Date.ok
close
bye
!      
echo "end  ----------------"
#rm -rf /home/TB_TXLOG_HISTORY_*.dat   
#rm -rf /home/TB_TXLOG_HISTORY_*.dat  
#rm -rf /home/TB_TXLOG_HISTORY_*.dat        
#rm -rf /home/TB_TXLOG_HISTORY_*.dat     
