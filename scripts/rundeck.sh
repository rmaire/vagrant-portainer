echo "deb https://rundeck.bintray.com/rundeck-deb /" | tee -a /etc/apt/sources.list.d/rundeck.list
curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | apt-key add -
apt-get update
apt-get install -y rundeck
curl -L https://github.com/rundeck-plugins/docker/releases/download/1.4.1/docker-container-1.4.1.zip > docker-container-1.4.1.zip
sudo cp docker-container-1.4.1.zip /var/lib/rundeck/libext

sed -i "s/localhost/192.168.50.2/g" /etc/rundeck/framework.properties
sed -i "s/localhost/192.168.50.2/g" /etc/rundeck/rundeck-config.properties
usermod -aG docker vagrant

service rundeckd start
service rundeckd enable

# admin/admin
