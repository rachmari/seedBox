PASSWORD='root'
DBNAME='seeddms'
DBUSER='seeddms'
DBPASS='seeddms'


sudo apt-get update
sudo apt-get install -y php5
sudo apt-get install -y php5-gd
sudo apt-get install -y php5-mysql
sudo apt-get install -y apache2


# MySQL 
echo "Preparing MySQL"
sudo apt-get install -y debconf-utils
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
echo "Installing MySQL"
sudo apt-get install mysql-server -y -f


# Install Git
echo "Installing Git"
sudo apt-get install -y git


# SeedDMS Dependencies
echo "Installing SeedDMS Dependencies"
echo "Installing id3"
sudo apt-get install -y id3
echo "Installing poppler-utils"
sudo apt-get install -y poppler-utils
echo "Installing catdoc"
sudo apt-get install -y catdoc
echo "Installing gnumeric"
sudo apt-get install -y gnumeric
echo "Installing php5-ldap"
sudo apt-get install -y php5-ldap
echo "Installing ldap-utils"
sudo apt-get install -y ldap-utils

echo "Installing SeedDMS Pear Dependencies"
sudo aptitude install -y php-pear
sudo pear install Mail-1.4.1
sudo pear install Log-1.13.1
sudo pear install Net_Socket-1.0.14
sudo pear install Net_SMTP-1.7.2


# Setup SeedDMS Data directory
echo "Setup SeedDMS Data Directory /var/www/data"
DATA_DIR=/var/www/data
sudo mkdir -p $DATA_DIR/lucene/
sudo mkdir $DATA_DIR/staging/
sudo mkdir $DATA_DIR/cache/
sudo chown -cvR www-data $DATA_DIR


# Downloading SeedDMS
echo "Downloading SeedDMS Installation"
sudo git clone https://github.com/rachmari/seeddms.git /var/www/seeddms
sudo rm -rf /var/www/html
sudo ln -s /var/www/seeddms /var/www/html

echo "Installing SeedDMS Lucene and Preview Pear Packages"
wget https://sourceforge.net/projects/seeddms/files/seeddms-5.0.1/SeedDMS_Preview-1.1.5.tgz
sudo pear install SeedDMS_Preview-1.1.5.tgz
sudo rm SeedDMS_Preview-1.1.5.tgz
wget https://sourceforge.net/projects/seeddms/files/seeddms-5.0.1/SeedDMS_Lucene-1.1.7.tgz
sudo pear install SeedDMS_Lucene-1.1.7.tgz
sudo rm SeedDMS_Lucene-1.1.7.tgz


echo "Set up seeddms database and user"
DBROOTUSER=$PASSWORD
DBROOTPASS=$PASSWORD
DBSCHEMA=$DBNAME
DBUSER=$DBUSER
DBPASS=$DBPASS
mysql -u $DBROOTUSER -p$DBROOTPASS -e "create database $DBSCHEMA;"
mysql -u $DBROOTUSER -p$DBROOTPASS -e "grant all privileges on $DBSCHEMA.* to $DBUSER@localhost identified by '$DBPASS';"
mysql -u $DBROOTUSER -p$DBROOTPASS -e "grant all privileges on $DBSCHEMA.* to $DBROOTUSER@'%' identified by '$DBROOTPASS';"
sudo chown -R mysql:mysql /var/lib/mysql
echo "Creating database tables"
mysql -u $DBROOTUSER -p$DBROOTPASS $DBSCHEMA < /var/www/html/install/create_tables-innodb.sql

sudo service mysql restart
sudo service apache2 restart

#create install tool config
cd /var/www/html/conf
sudo wget http://perforce.paradesh.com:8080/@rev1=head@//webapps/DMS/seedLocalFiles/settings.xml

echo "Finished provisioning."
