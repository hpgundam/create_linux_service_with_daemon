启发于https://github.com/frdmn/service-daemons

功能：
创建自定义服务
添加开机启动
为该服务创建守护进程

支持系统：
redhat 6.5
ubuntu 14.04


使用方法：
需要使用root来使用该工具，将这个目录随意放在任何目录下，然后执行脚本create_service.sh即可：
create_service.sh name appbin appargs
name:服务名
appbin:执行的命令（命令中不能有空格，并且要写全路径）
appargs:命令的参数（如有空格需要用引号包裹，如果没有参数使用两个引号表示）

守护进程会每隔一分钟监听被守护服务的状态，如果服务停止了则尝试启动服务，最多尝试5次。
可以查看守护进程的日志了解启停详情：/var/log/service_guard/service_guard.log







