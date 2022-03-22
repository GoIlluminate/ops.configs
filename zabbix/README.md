# Illuminate Zabbix Monitoring

## Architecture
* `Zabbix-Agent` on VMs will communicate with `Zabbix-Proxy` and then `Zabbix-Proxy` 
will communicate with `Zabbix-Server`
* Due to security, Zabbix connection will remain `active`, which means
the communication will be one way like so, `Zabbix-Agent -> Zabbix-Proxy -> Zabbix-Server`

## Version
* `Zabbix-Server`: `zabbix_server (Zabbix) 6.0.x`
* `Zabbix-Proxy`: `zabbix_proxy (Zabbix) 6.0.x`
* `Zabbix-Agent`: `zabbix_agentd (daemon) (Zabbix) 6.0.0`
* It is recommended to keep all three components at the same version

## Debian Packages
* `https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix/`

## Installation
### Linux
#### Zabbix-Proxy (runs on Proxy VM)
##### Installation
* Import Debian Package
```shell
### Change version, os, and architecture as needed ###
  
$ wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix/zabbix-proxy-pgsql_6.0.0-1%2Bubuntu20.04_amd64.deb
$ sudo dpkg -i zabbix-proxy-pgsql_6.0.0-1+ubuntu20.04_amd64.deb

### If dpkg fails due to dependencies ###

$ sudo apt-get install -f
$ sudo apt-get -y install postgresql
```
* Import sql script
```shell
### Change version, os, and architecture as needed ###

$ sudo wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix/zabbix-sql-scripts_6.0.1-1%2Bubuntu20.04_all.deb
$ sudo dpkg -i zabbix-sql-scripts_6.0.1-1+Bubuntu20.04_all.deb
```
* Initialize Database
```shell
$ sudo -u postgres createuser --pwprompt zabbix
$ sudo -u postgres createdb -O zabbix zabbix 
$ sudo cat /usr/share/doc/zabbix-sql-scripts/postgresql/proxy.sql | sudo -u zabbix psql zabbix
```
* Configure Zabbix-Proxy
```shell
$ cd /etc/zabbix/zabbix_proxy.conf

### Match the content of zabbix_proxy.conf in this repository ###

## Important ##

# Hostname=<SITE_NAME>-proxy 
# <SITE_NAME> should be client mnemonic
# Example: ILLUM_KS-proxy
```
* Restart and enable `Zabbix-Proxy` service
```shell
$ sudo systemctl restart zabbix-proxy
$ sudo systemctl enable zabbix-proxy

### Check if zabbix-proxy service is running ###
$ sudo systemctl status zabbix-proxy
```

#### Zabbix-Agent (runs on Net Prod VM and DB Prod VM) - Illuminate only monitor Net VM and DB VM in Production environment
##### Installation
* Import debian package
```shell
### Change version, os, and architecture as needed ###
$ sudo wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix/zabbix-agent_6.0.1-1%2Bubuntu20.04_amd64.deb
$ dpkg -i zabbix-agent_6.0.1-1+ubuntu20.04_amd64.deb
```
* Configure Zabbix-Agent
```shell
$ sudo vi /etc/zabbix/zabbix-agentd.conf

### Match the content of zabbix_agentd.conf in this repository ###

## Important ##

# Ensure that StartAgents=0

# Hostname=<SITE_NAME>-<SERVER_TYPE>
# <SITE_NAME> should be client mnemonic
# <SERVER_TYPE> should be either net or db
# Example: ILLUM_KS-net or ILLUM_KS-db
```
* Restart and enable `Zabbix-Agent` service
```shell
$ sudo systemctl restart zabbix-agent
$ sudo systemctl enable zabbix-agent

### Check if zabbix-proxy service is running ###
$ sudo systemctl status zabbix-agent
```
* Allow zabbix to execute `rabbitmqctl`
```shell
$ sudo vi /etc/zabbix/zabbix_agentd.d/rabbitmq_userparameters.conf

### Copy content of rabbitmq_userparameters.conf in this repository then save

$ sudo su
$ cd /etc/sudoers.d
$ sudo visudo -f zabbix_rabbitmq_access

### visudo will prevent wrong syntax
### Copy content of zabbix_rabbitmq_access in this repository then save

$ sudo systemctl restart zabbix-agent
```
