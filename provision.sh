#EPElレポジトリを追加
yum install epel-release -y
#デフォルトではEPElを無効に
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo
 
#Remiレポジトリを追加
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
 
#nginxをインストール
yum --enablerepo=epel install nginx -y

#nginxの自動起動設定、起動
systemctl enable nginx
systemctl start nginx
systemctl status nginx
 
#confファイルのサンプルを作成
cat << EOT > /etc/nginx/conf.d/mylaravel.conf
server {
  listen 80;
  server_name vagrant-test.local.com;
  root /var/www/html/public;
  index index.php index.html index.htm;

  # '/'で始まる全てのURIに一致
  location / {
    # リクエストURI, /index.phpの順に処理を試みる
    try_files $uri $uri/ /index.php?$query_string;
  }
 
  location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;

    fastcgi_pass unix:/var/run/php-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param PATH_INFO $fastcgi_path_info;

    include fastcgi_params;
  }
}
EOT
#nginxの自動起動設定、起動
systemctl reload nginx
 
#PHP7とPHP-FPMなどその他extensionをインストール
yum install --enablerepo=epel,remi-php70 php php-mbstring php-pear php-fpm php-mcrypt php-gd php-mysql -y
 
#PHP-FPMのuserとgroupをnginxに変更
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
 
#PHP-FPMの自動起動設定、起動
systemctl enable php-fpm
systemctl start php-fpm
systemctl status php-fpm
 
#MySQLのインストール
rpm -ivh http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum install mysql-community-server -y
 
#VagrantではパスワードなしでMySQLのrootユーザのログインを許可したい
echo skip-grant-tables >> /etc/my.cnf
#MySQLの自動起動設定、起動
systemctl enable mysqld.service
systemctl start mysqld.service
#Basic認証使いたいのでインストール
yum install httpd-tools -y
#node.jsとnpmインストール
yum install nodejs -y
yum install npm --enablerepo=epel -y
# Composer install
curl -sS https://getcomposer.org/installer | php -- --install-dir=/tmp
mv /tmp/composer.phar /usr/local/bin/composer
ln -s /usr/local/bin/composer /bin
 
#Vagrantでディレクトリをマウントすると403になるのでSELinuxを停止
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
