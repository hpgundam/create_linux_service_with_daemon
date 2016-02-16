#!/usr/bin/env bash



if [ $# -lt 3 ];then
	echo 
	echo "Usage: $0 name appbin appargs"
	echo "name: the name of the service"
	echo "appbin: the command to be executed(no space between this parameter, and this command should have full path)"
	echo "appargs: the arguments of the command(arguments with spaces between should be enclosed by quotes)"
	echo
	exit 1
fi

NAME=$1;shift
APPBIN=$1;shift
APPARGS=$1;shift

f_services=services.cfg
supported_os="ubuntu14.04 redhat6.x"

os_info=`cat /proc/version`
if [[ ${os_info} =~ "Ubuntu" ]];then
	if [ `cat /etc/issue|head -1|awk '{print $2}'` != "14.04" ];then
		echo "This os is not supported."
		echo ${os_info}
		echo "Supported os: ${supported_os}"
		exit 1
	fi
	os=ubuntu
	f_service=service_script_ubuntu
	cmd_auto="update-rc.d ${NAME} defaults"
elif [[ ${os_info} =~ "el6" ]];then
	os=redhat
	f_service=service_script_rh
	cmd_auto="chkconfig ${NAME} on"
else
	echo "This os is not supported."
	echo ${os_info}
	echo "Supported os: ${supported_os}"
	exit 1
fi


cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${cwd} > /dev/null

sed  "s,\(^NAME.*=.*\"\).*\(\"\),\1${NAME}\2," ${f_service} > ${NAME}
sed  -i "s,\(^APPBIN.*=.*\"\).*\(\"\),\1${APPBIN}\2," ${NAME} 
sed  -i "s,\(^APPARGS.*=.*\"\).*\(\"\),\1${APPARGS}\2," ${NAME} 

chmod +x ${NAME}
cp ${NAME} /etc/init.d/
${cmd_auto}
service ${NAME} start

if [ "`grep ${NAME} ${f_services}`x" = "x" ];then
	echo  ${NAME} >> ${f_services}
fi
chmod +x service_guard.sh
f_crontab=/etc/crontab
if [ "`grep "${cwd}/service_guard.sh" ${f_crontab}`x" = "x" ];then
	echo "  *  *  *  *  *  root ${cwd}/service_guard.sh" >> ${f_crontab}
fi

cd - > /dev/null