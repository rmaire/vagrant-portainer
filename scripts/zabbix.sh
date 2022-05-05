# https://www.zabbix.com/download?zabbix=4.2&os_distribution=ubuntu&os_version=18.04_bionic&db=postgresql
wget https://repo.zabbix.com/zabbix/4.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.2-1+bionic_all.deb
dpkg -i zabbix-release_4.2-1+bionic_all.deb
apt-get -y update
apt-get -y install zabbix-server-pgsql zabbix-frontend-php php-pgsql zabbix-agent
usermod -aG adm zabbix
sudo -u postgres psql -c "create role zabbix with login password 'test123';"
sudo -u postgres createdb -O zabbix zabbix
zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix PGPASSWORD=test123 psql -q zabbix

sed -i "s/# DBPassword=/DBPassword=test123/" /etc/zabbix/zabbix_server.conf
sed -i "s/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Zurich/g" /etc/zabbix/apache.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
