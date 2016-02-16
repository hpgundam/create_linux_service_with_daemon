#!/usr/bin/env bash

# set -o xtrace
cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${cwd} > /dev/null

f_services=services.cfg
d_log=/var/log/service_guard
mkdir -p ${d_log}
f_log=${d_log}/service_guard.log
touch ${f_log}

max_try=5

logging()
{
	msg=$1;shift
	time=`date '+%F %T'`
	echo "${time}:    ${msg}" >> ${f_log}
}


start_service()
{
	logging "service[${service}] down, begin to start it up ..."
	service=$1;shift
	i=0
	while [ $i -lt ${max_try} ]
	do
		logging "starting service[${service}] ..."
		service ${service} start >/dev/null 2>&1
		status=`service ${service} status`
		if [[ ! "${status}" =~ "not" ]];then
			logging "service[${service}] started"
			break 
		fi
		i=`expr $i + 1`
	done
	if [ $i -eq ${max_try} ];then
		logging "failed to start service[${service}]"
	fi	
}


while read service
do
	echo ${service}
	status=`service ${service} status`
	if [[ "${status}" =~ "not" ]];then
		start_service ${service} &
	fi
done < ${f_services}

cd - > /dev/null






