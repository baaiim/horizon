#!/bin/bash
cd 
mkdir horizon
cd horizon
yum install epel-release -y
yum install jq -y
yum install python -y
yum install java-1.7.0-openjdk.x86_64 -y
yum install unzip -y
yum install screen -y
yum install curl -y
wget https://downloads.horizonplatform.io/binaries/hz_v3.8.zip
unzip hz*.zip 
cd hz
IP=$(wget -qO- ifconfig.me/ip)
sed -i s/nhz.myAddress=/nhz.myAddress=$IP/g /root/horizon/hz/conf/nhz-default.properties
chmod +x run.sh
screen -d -m -S hallmarked ./run.sh
echo "WAIT FOR WALLET UP (30 Second)"
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
CODE=$(curl -d requestType="markHost" -d host="$IP" -d weight="100" -d date="$TGL" -d secretPhrase="$1" http://127.0.0.1:7776/nhz | jq -r '.hallmark')
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
history -c
reboot
exit 0
