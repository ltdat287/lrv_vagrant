#EPElレポジトリを追加
yum install epel-release -y
#デフォルトではEPElを無効に
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo
 
#Remiレポジトリを追加
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
 
#nginxをインストール
yum --enablerepo=epel install nginx -y
 
# Set up nginx server
sudo cp /vagrant/nginx/nginx.conf /etc/nginx/conf.d/site.conf
sudo chmod 644 /etc/nginx/conf.d/site.conf

#nginxの自動起動設定、起動
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
 
#PHP7とPHP-FPMなどその他extensionをインストール
yum install --enablerepo=epel,remi-php71 php php-mbstring php-pear php-fpm php-mcrypt php-gd php-mysql -y
 
#PHP-FPMのuserとgroupをnginxに変更
sed -i 's/user = apache/user = vagrant/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = vagrant/g' /etc/php-fpm.d/www.conf
 
#PHP-FPMの自動起動設定、起動
sudo systemctl enable php-fpm
sudo systemctl start php-fpm
sudo systemctl status php-fpm
 
#MySQLのインストール
rpm -ivh http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum install mysql-community-server -y
 
#VagrantではパスワードなしでMySQLのrootユーザのログインを許可したい
sudo echo skip-grant-tables >> /etc/my.cnf
#MySQLの自動起動設定、起動
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service
#Basic認証使いたいのでインストール
yum install httpd-tools -y
#node.jsとnpmインストール
yum install nodejs -y
yum install npm --enablerepo=epel -y
# Composer install
curl -sS https://getcomposer.org/installer | php -- --install-dir=/tmp
sudo mv /tmp/composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /bin

# Install Git
yum install git -y

sudo yum install zip unzip php7.1-zip -y
 
#Vagrantでディレクトリをマウントすると403になるのでSELinuxを停止
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Install laravel
cd /var/www/html/server && composer install
sudo chmod -R 755 storage/
