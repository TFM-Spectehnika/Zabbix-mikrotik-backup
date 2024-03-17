# Zabbix-mikrotik-backup

Template to backup mikrotik RouterOS

From zabbix externalscript
In zabbix server you must added script (if you use proxy must added scritp in proxy server)
Added permissions on execute it.

In macro must set username and password user who have right to do command, and user who upload files in storage.

In mikrotik must set below command
/user group
add name=group_name policy=ssh,ftp,read,write,policy,test,sniff,sensitive,!local,!reboot,!winbox,!password,!web,!api,!romon,!dude,!tikapp
/user
add name=user_name password="password" group=group_name
/ip service
enable ssh
set ssh address=address_zabbix_server or service vlan
