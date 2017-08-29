
SeedBox is a pre-configured LAMP Vagrant box that installs all dependencies to get a custom version of [SeedDMS 5.0](http://github.com/rachmari/seeddms) working right out of the box.

# Overview
To use this Vagrant Box, you must have [Vagrant](http://vagrantup.com) and [VirtualBox](https://www.virtualbox.org) installed.

# Operating System

* Ubuntu 14.04 LTS Trusty Tahr (64-Bit): [ubuntu/trusty64](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) from [Atlas Vagrant Box](https://atlas.hashicorp.com/boxes/search?utm_source=vagrantcloud.com&vagrantcloud=1).
 
# Included packages

* Apache2 _2.4.7_
* PHP _v5.5.9_
  * php5-mysql
  * php5-gd
* MySQL _Ver 14.14 Distrib v5.5.57_
  * debconf-utils
* Git _v1.9.1_

## SeedDMS Dependencies

* Pear package installer (installed using aptitude)
* Pear packages:
  * Mail _v1.4.1_
  * Log _v1.13.1_
  * Net_SMTP _v1.7.2_
    * Net_Socket _v1.0.14_
  * [SeedDMS Lucene](https://sourceforge.net/projects/seeddms/files/seeddms-5.0.1/SeedDMS_Lucene-1.1.7.tgz)
  * [SeedDMS Preview](https://sourceforge.net/projects/seeddms/files/seeddms-5.0.1/SeedDMS_Preview-1.1.5.tgz)
* id3
* poppler-utils
* catdoc
* gnumeric
* php-ldap
* ldap-utils

## SeedDMS Source
* [SeedDMS Core](https://github.com/rachmari/seeddms)

# Installation

Create your SeedDMS settings file:
1. Download the [settings.xml.template](https://github.com/rachmari/seeddms/blob/master/conf/settings.xml.template) template file.
2. Use this template to start or add your SMTP mail, LDAP, or updated mysql credentials.
3. Save this file as settings.xml.

Clone this repository:

    $ git clone https://github.com/rachmari/seedBox.git
    
Configure and provision your Vagrant Box:

    $ cd /seedBox
    $ vagrant up
    
Copy the settings.xml to the seedBox/shared/seeddms/conf directory.
    
That's all! Go to [http://192.168.33.10](http://192.168.33.10) to see your SeedDMS installation.

# Vagrant Info
```
memory: 1024mB RAM
cpu: 1
```
The Vagrantfile configuration sets up port forwarding for http and mysql default ports. This allows accessing the http and mysql ports on the guest machine from the host machine. This allows you to use the browser on your host machine and a tool like Sequel Pro to connect to view your database. A private network is set up to assign an IP address to the virtual machine
```
http:  Host port 8080 -> guest port 80
mysql: Localhost port 3309 -> guest port 3306
ip:    192.168.33.10
```
All packages are installed from the provisioning script. This repo contains two directories: vagrant and shared. The vagrant directory contains the provisioning script `bootstrap.sh` which will be executed automatically when you run `vagrant up`. The seedDMS source code is downloaded to the `shared` directory from the provisioning script. This directory is a shared folder accessible from the host machine and the guest machine. This directory is synced with `/var/www` directory in the virtual machine. 

The provisioning script writes some variables to the /etc/php5/apache2/php.ini and /etc/mysql/my.cnf files on the vagrant box. Variables are overwritten by appending the redeclared variable to the end of the files.

# Default Credentials
These are credentials setup by default.

## SeedDMS Admin Login
```
user: admin
password: admin
```
## Host Address:
```
host: 192.168.33.10 (To change modify the private_network in the Vagrantfile)
 ```
## SSH
```
username: vagrant
password: vagrant
port: 22
```
## MySQL Credentials
```
host: localhost
username: root
password: root
port: 3306
```
To connect to the development vagrant machine with Sequel Pro from the host machine, use the forwarded port number. Note that if `bind-address` is defined as `127.0.0.1` in `/etc/mysql/my.cnf`, this connection will not be availabe from the host machine. The provisioning script sets the `bind-address` to 0.0.0.0 to allow this connection.
```
host:     127.0.0.1
username: root
password: root
database: seeddms
port: 3309
```
# Disclaimer
This Vagrant Box has only been tested on a mac.
