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
# 是否运行脚本
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


# 安装所需依赖
yum install -y pcre* zlib zlib-devel libssl-devel libssl
yum install -y openssl
yum install -y epel-release

# yum 安装 clamav
yum install -y epel-release  
yum clean all && yum makecache
yum install -y clamav  clamav-server clamav-data clamav-update clamav-filesystem clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

# 配置clamAV
sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf 
sed -i -e "s/^Example/#Example/" /etc/freshclam.conf 
sed -i "s/^#LocalSocket \//LocalSocket \//g" /etc/clamd.d/scan.conf
sed -i "$aDatabaseDirectory /usr/local/clamav/updata" /etc/clamd.d/scan.conf
sed -i "$aUpdateLogFile /usr/local/clamav/logs/freshclam.log" /etc/clamd.d/scan.conf
sed -i "$aPidFile /usr/local/clamav/updata/freshclam.pid" /etc/clamd.d/scan.conf

# 更新病毒库
freshclam

# 更新完成启动
systemctl start clamav-freshclam.service
systemctl status clamav-freshclam.service

echo
'''
Using the example:
-r/--recursive[=yes/no]             递归扫描
--log=FILE/-l FILE                  增加扫描报告
--move [路径]                       移动病毒文件至..
--remove [路径]                     删除病毒文件
--quiet                             只输出错误消息
--infected/-i                       只输出感染文件
--suppress-ok-results/-o            跳过扫描OK的文件
--bell                              扫描到病毒文件发出警报声音
--unzip(unrar)                      解压压缩文件扫描
eg:
clamscan -r --bell -i /             扫描所有文件并且显示有问题的文件的扫描结果 
clamdscan -r /usr                   递归扫描/usr目录
clamscan --no-summary -ri /tmp      只显示找到的病毒信息
clamscan --infected --remove --recursive /home  扫描并删除

'''
sleep 5s

echo '安装完成'
echo 
'''
需要执行以下命令手动修改 ClamAV 权限，并重启
sed -i 's/SELINUX=disable/SELINUX=1/' /etc/selinux/config
reboot
setsebool -P antivirus_can_scan_system 1 
setsebool -P clamd_use_jit 1 

验证：
[root@localhost ~]# getsebool -a | grep antivirus 
antivirus_can_scan_system --> on 
antivirus_use_jit --> on 
''' 

ln -s /usr/local/clamav/bin/clamscan /usr/local/sbin/clamscan

