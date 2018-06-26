unless Vagrant.has_plugin?("vagrant-vbguest")
  raise "please run 'vagrant plugin install vagrant-vbguest'"
end
 
Vagrant.configure(2) do |config|
 
  #CentOS7のboxを指定
  config.vm.box = "centos/7"
 
  #ゲストマシンのIPアドレスを指定
  config.vm.network "private_network", ip: "192.168.77.10"
 
  #ホストマシンとゲストマシンのディレクトリをマウント
  config.vm.synced_folder "Code", "/var/www/html", create: true
 
  #プロビジョニングの処理をprovision.shファイルにまとめる。
  config.vm.provision :shell, :path => "provision.sh"
end
