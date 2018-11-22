#!/bin/bash
function install_esets()
#######################################################
#install_esets()安装软件，使用expect语言进行交互      #
#######################################################
{
if [ ! -f /usr/bin/expect -a `cat /proc/version|grep -i redhat|wc -l` -gt 0 ] 
   	then  echo -e  "NOTICE:please install expect first!\n" && echo "FYI:yum install expect*" && exit 
elif [ ! -f /usr/bin/expect -a `cat /proc/version|grep -i suse|wc -l` -gt 0 ] 
	then  echo -e  "NOTICE:please install expect first!\n" && echo "FYI:zypper install expect*"  && exit
else    echo "expect is exist,keeping install......!"
fi
if [ `rpm -qa|grep esets-4.0-10.x86_64|wc -l` -gt 0 ]
   then echo "esets has installed!" && echo -e "\n"
   pro_continue   
fi
echo "Please wait for a moment!!!"
sleep 3
expect<<-END
spawn ./esets.x86_64.rpm.bin
expect  "Licence..."
        send "\n" 
        send "q" 
expect "(y/n)"  
        send "y\r"
expect "(y/n, default=y)"
        send "y\r"
expect  eof

END
############################################################################
#expect语言嵌套到shell中，匹配方式有两种，一种是串行匹配，一种是并行匹配   #
# 需要的注意的是spawn、expect、send命令的使用和注意事项，这个可以参考文档  #
# <expect学习笔记及实例详解>,还有就是注意最后一条expect eof                #
############################################################################
if [ `rpm -qa|grep esets-4.0-10.x86_64|wc -l` -gt 0 ]
  then echo "esets install successfully!"
fi

}
######################################################################
#modify_esets_cfg()修改配置文件，使用sed命令去修改配置文件中的参数   #
######################################################################
function modify_esets_cfg()
{
read choice
case $choice in
        y|Y|yes|YES)
        if [ ! -f /etc/opt/eset/esets/esets.cfg ]
           then echo "esets.cfg is not exist!"
           exit
        fi
        echo -n "please input the av_update_username:"
        read av_update_username
        echo -n "please input the av_update_password:"
        read av_update_password
	sed -i  '385d'  /etc/opt/eset/esets/esets.cfg
	sed -i  '381d'  /etc/opt/eset/esets/esets.cfg
	sed -i  '380 aav_update_username ="'"$av_update_username"'"' /etc/opt/eset/esets/esets.cfg
	sed -i  '384 aav_update_password ="'"$av_update_password"'"' /etc/opt/eset/esets/esets.cfg
######################################################################
#sed命令：-i 在参数表示直接在原文件上面做修改；d命令表示删除；380空格#
#后面的a命令表示在380行后面参入新行                                  #
######################################################################
	echo "operation successful!"
	echo -e "\n"
	pro_continue        
        ;;

        n|N|no|No|NO)
	echo -e "\n"
	pro_continue
        ;;

        *)
        echo -n  "you input a wrong choice,please input y or n:"
        modify_esets_cfg
	;;
esac
}

function pro_continue()
{
PS3="select a program to execute:"
select option in  "install eset" "modify the esets.cfg" "uninstall eset" "exit"
    do
		case $option in
			"install eset")
			install_esets
			echo -e "\n\r"
			pro_continue
			;;

			"modify the esets.cfg")
			echo -n  "Do you want to modify the esets.cfg really?(y/n)"
			modify_esets_cfg
			;;
			
			"uninstall eset")
			rpm -e esets
			echo -e "\n\r"
			pro_continue
			;;

			"exit")
			echo "Thank you for using my program!"
			exit
			;;

			*)
			echo -n  "NOTICE:you input a wrong number,please Re-"
			;;
		esac
    done
}
echo "###############################################"
echo "#	author:tx                             #"
echo "#	date:2014-04-26                       #"
echo "#	version:2.1                           #"
echo "#	copyright:tianxun@nsfocus.com         #" 
echo "###############################################"
echo -e "\n"
echo "please wait for sometime,check the environment......"
while [ `cat /proc/version|grep -i suse|wc -l` -gt 0 ]
do
    echo "your operation system is suse!"
    break
done

while [ `cat /proc/version|grep -i redhat|wc -l` -gt 0 ]
do
   echo "your operation system is redhat!" && updatedb
   if [ `locate ld-linux.so.2|wc -l` -eq 0 ]
	then echo "NOTICE:/lib/ld-linux.so.2 is needed by esets-4.0-10.x86_64" && exit
   fi
   if [ `locate UTF-16.so|wc -l` -eq 0 ]
        then echo "NOTICE:/usr/lib/gconv/UTF-16.so is needed by esets-4.0-10.x86_64" && exit
   fi
   break
done
######################################################################
#while和if的混合使用，需要注意的是break的使用，匹配一次后跳出当前循环#
#while实现原理：如果while后的命令执行成功,或条件真,则执行do和done之间#
#的语句,执行完成后,再次判断while后的命令和条件，所以这儿要使用break，#
#即匹配成功一次后即退出循环                                          #
######################################################################
if [ ! -f ./esets.x86_64.rpm.bin ]
  then echo 'NOTICE:file "esets.x86_64.rpm.bin" is not exist in  current directory!' && exit
  else  echo "file "esets.x86_64.rpm.bin" is exist!"
fi
echo -e  "environment is ok!!!\n" && pro_continue


