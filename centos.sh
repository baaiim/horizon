#!/bin/bash
cd 
mkdir horizon
cd horizon
OPT=$1
case $OPT in
  -c5|-C5) 
  	wget http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
    sudo rpm -Uvh epel-release-5*.rpm
  	;;
  -c6|-C6) 
  	wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sudo rpm -Uvh epel-release-6*.rpm
  	;;
  -c7|-C7) 
  	wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    sudo rpm -Uvh epel-release-7*.rpm 
  	;;
   *) 
    echo "Bad argument!" 
    echo "	-c5 for centos 5 "
    echo "	-c6 for centos 6 "
    echo "	-c7 for centos 7 "
    exit 0	
    ;;
esac
yum install jq -y
yum install python -y
yum install java-1.7.0-openjdk.x86_64 -y
yum install unzip -y
yum install screen -y
yum install curl -y
wget http://files.nhzcrypto.org/binaries/hz_v3.8.zip
unzip hz*.zip 
cd hz
IP=$(wget -qO- ifconfig.me/ip)
sed -i s/nhz.myAddress=/nhz.myAddress=$IP/g /root/horizon/hz/conf/nhz-default.properties
chmod +x run.sh
screen -d -m -S hallmarked ./run.sh
echo "WAITING FOR WALLET ON (30 Second)"
echo -ne '[                                     ](0%)\r'
sleep 2
echo -ne '[==>                                  ](5%)\r'
sleep 2
echo -ne '[=====>                               ](10%)\r'
sleep 2
echo -ne '[========>                            ](15%)\r'
sleep 2
echo -ne '[=========>                           ](20%)\r'
sleep 2
echo -ne '[===========>                         ](25%)\r'
sleep 2
echo -ne '[=============>                       ](30%)\r'
sleep 2
echo -ne '[===============>                     ](33%)\r'
sleep 2
echo -ne '[=================>                   ](47%)\r'
sleep 2
echo -ne '[===================>                 ](60%)\r'
sleep 2
echo -ne '[=====================>               ](70%)\r'
sleep 2
echo -ne '[=======================>             ](75%)\r'
sleep 2
echo -ne '[===========================>         ](80%)\r'
sleep 2
echo -ne '[================================>    ](87%)\r'
sleep 2
echo -ne '[==================================>  ](96%)\r'
sleep 2
echo -ne '[=====================================](100%)\r'
echo -ne '\n'
echo "DONE"
sleep 2

TGL=$(date +%Y-%m-%d)
CODE=$(curl -d requestType="markHost" -d host="$IP" -d weight="100" -d date="$TGL" -d secretPhrase="$2" http://127.0.0.1:7776/nhz | jq -r '.hallmark')
sed -i s/nhz.myHallmark=/nhz.myHallmark=$CODE/g /root/horizon/hz/conf/nhz-default.properties
sleep 2
screen -S hallmarked -X quit
service iptables stop
chkconfig iptables off
touch /opt/auto.sh
echo "#!/bin/bash
cd /root/horizon/hz/
screen -d -m -S hallmark ./run.sh"> '/opt/auto.sh'
chmod +x /opt/auto.sh
 sed -i "s#.*touch.*#sh /opt/auto.sh\n&#" /etc/rc.local
 sed -i "s#.*touch.*#sh /opt/auto.sh\n&#" /etc/rc.d/rc.local
sleep 1
sh /opt/auto.sh
echo "
DONATE :
=============================================================
//       CREDITED : ANDIK IBRAHIMI                         //
//   NHZ : NHZ-WFZE-R2L9-M4LN-FSWVK                        //
============================================================="
sleep 3
history -c
reboot
exit 0
