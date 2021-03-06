#!/bin/bash -e

echo 
'''                                                                                                                                                               
       ^                                                                             
       =^                                                                =^         
       =O^                        .,]]]]]]]]]]`.                        =O^         
       .@O\                 ,]OOOOOOOOOOOOOOOOOOOOOO].                 /O@.         
       .@OOO.           ./@OOOOOOOOOOOOOOOOOOOOOOOOOOOO@].           ,OOO@          
        =@OOO\       ./@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@\.       /OOO@^          
        .@@OOOO`   ,@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@`   /OOOO@@.          
         =@@OOOOO\@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@/OOOOO@@^           
          @@@OOOOOOO@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@OOOOOO@@@/            
          .@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@             
           .@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@/.             
            /@@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@@@^              
           =@@@@@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@@@@@@^             
          ,@@@@@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@@@@@@.            
          O@@@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@@@@\            
         ,@@@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@@@@.           
         =@@@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@@@^           
         =@@@@@OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO@@@@@^           
         =@@@@@@OOOOO@@OOOOOO@@@@@@OOOOOOOOOOOO@@@@@OOOOOOO@@OOOOOO@@@@@^           
         =@@@@@@OOO@@`.[@@OO@@@@@OOOOOOOOOOOOOOOO@@@@@O@@@[.,@@OOO@@@@@@^           
         =@@@@@@@O@^      ,@@@@OOOOOOOOOOOOOOOOOOOO@@@@.      \@O@@@@@@@^           
         .@@@@@@@O@.      =@@@,@@OOOOOOOOOOOOOOOO@/`@@@^      .@O@@@@@@@.           
          =@@@@@@@@..    .@@@.   .[@OOOOOOOOOO@[.   .@@@     ..@@@@@@@@^            
          .@@@@@@@@...   =@@^        ,\OOOO/`        =@@^   ..,@@@@@@@@             
           ,@@@@@@@@.... =@@.          /OO\          .@@. ....@@@@@@@@`             
            =@@@@@@@@`....@@        ../OOOO\..        @@....,@@@@@@@@`              
     ,/[[[[[\/@@@^.@@@@]..=@........]@OOOOOO@`........@^..]@@@@@@@@@@@^       =@@^  
   =` ,/[[[\/`.@@^.@@@@@@@@@]]]]]@@OOOOOOOOOOOO@@]]]]]@@@@@@@@O@@@/.@O@`     ,@OO.  
  /../          =^.@@@@@@@@@@@@@@@@@@@@O@@@@@OO@@@@@@@@@@@@@@O@O@`  =OOO.    OO@`   
 =^ /           =^.@@@@@^.,]]` ,@@@@@.=`]]]. ,`,]]` ,@@@@@@@O@@@O^   =OO^   =OO^    
 =..^           =^.^[@@@@@@@@@@.,@@@@.=@@@@@^.@@@@@^ \@@@@@OO^ =OO`   OOO` ,@O/     
 =..^           =^.^  ,\@@[. ....@@@@.=@@@@@^.@@@@@^ =@@@@@O/  .@O@.  .@O@ OO@.     
 .^ =`          =^.^   /.,/@@@@..@@@@.=@@@@@^.@@@@@^ =@[.@OO@OOO@OO\   =OO@OO^      
  ,` ,]    ./\  =^.\  .^ =   .=..@@@@.=@@@@@^.@@@@[^ =. /OO[[[[[[\OO^   =OOO/       
   .\`  ... ./`  \` .O ,\ ,[[./^ \` =.=^   ,^.^    ^ =.=OO^       @O@`  .OO@.       
      .,[[`.       .[`   .[[`   .[. ....   ....    ........ ClamAV installation script 1.0          
                                                                                                                                                                
'''
# ??????????????????
read -r -p "Are You Sure? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
		echo "Yes"
		;;

    [nN][oO]|[nN])
		echo "No"
       	;;

    *)
		echo "Invalid input..."
		exit 1
		;;
esac


# ??????????????????
yum install -y pcre* zlib zlib-devel libssl-devel libssl
yum install -y openssl
yum install -y epel-release

# yum ?????? clamav
yum install -y epel-release  
yum clean all && yum makecache
yum install -y clamav  clamav-server clamav-data clamav-update clamav-filesystem clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

# ??????clamAV
sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf 
sed -i -e "s/^Example/#Example/" /etc/freshclam.conf 
sed -i "s/^#LocalSocket \//LocalSocket \//g" /etc/clamd.d/scan.conf
sed -i "$aDatabaseDirectory /usr/local/clamav/updata" /etc/clamd.d/scan.conf
sed -i "$aUpdateLogFile /usr/local/clamav/logs/freshclam.log" /etc/clamd.d/scan.conf
sed -i "$aPidFile /usr/local/clamav/updata/freshclam.pid" /etc/clamd.d/scan.conf

# ???????????????
freshclam

# ??????????????????
systemctl start clamav-freshclam.service
systemctl status clamav-freshclam.service

echo
'''
Using the example:
-r/--recursive[=yes/no]             ????????????
--log=FILE/-l FILE                  ??????????????????
--move [??????]                       ?????????????????????..
--remove [??????]                     ??????????????????
--quiet                             ?????????????????????
--infected/-i                       ?????????????????????
--suppress-ok-results/-o            ????????????OK?????????
--bell                              ???????????????????????????????????????
--unzip(unrar)                      ????????????????????????
eg:
clamscan -r --bell -i /             ??????????????????????????????????????????????????????????????? 
clamdscan -r /usr                   ????????????/usr??????
clamscan --no-summary -ri /tmp      ??????????????????????????????
clamscan --infected --remove --recursive /home  ???????????????

'''
sleep 5s

echo '????????????'
echo 
'''
???????????????????????????????????? ClamAV ??????????????????
sed -i 's/SELINUX=disable/SELINUX=1/' /etc/selinux/config
reboot
setsebool -P antivirus_can_scan_system 1 
setsebool -P clamd_use_jit 1 

?????????
[root@localhost ~]# getsebool -a | grep antivirus 
antivirus_can_scan_system --> on 
antivirus_use_jit --> on 
''' 

ln -s /usr/local/clamav/bin/clamscan /usr/local/sbin/clamscan

