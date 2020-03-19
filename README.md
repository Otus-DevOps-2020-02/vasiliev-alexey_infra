# vasiliev-alexey_infra
vasiliev-alexey Infra repository


###  **Домашнее задаание по теме №6**  
testapp_IP = 146.148.17.212  
testapp_port = 9292

[Создаем VM в GCP](create_gcp_vm.sh)

    
    

[Устанвливаем Ruby](install_ruby.sh)  
        
        sudo apt update && sudo apt install -y ruby-full ruby-bundler build-essential

[Устанвливаем MongoDB](install_mongodb.sh)  

        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xd68fa50fea312927
        sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list' sudo apt-get update
        sudo apt install -y --allow-unauthenticated mongodb-org

        sudo systemctl start mongod

        sudo systemctl enable mongod


[Деплой приложения](deploy_mongodb.sh)  

        cd ~
        git clone -b monolith https://github.com/express42/reddit.git
        cd reddit && bundle install
        puma -d
Создаем  правило firewall  

        gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags=puma-server

 
Тестим  

        curl -s -o /dev/null -w "%{http_code}" http://146.148.17.212:9292/




ДЗ1*
[Создаем все вместе ](startup-script.sh)  
  
    gcloud compute instances create reddit-app\
    --boot-disk-size=10GB \
    --image-family ubuntu-1604-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=g1-small \
    --tags puma-server \
    --restart-on-failure\
    --metadata-from-file\
    startup-script=startup-script.sh


ДЗ2* : Создаем правило  firewall
 
    gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags=puma-server

___


### **Домашнее задаание по теме №5**

bastion_IP = 35.246.100.145
someinternalhost_IP    = 10.154.0.3

Создана конфигурация в GCP:

Хост      | ip ext |   ip int
:-------- |:-----:|  :-----:|
bastion  | 35.246.100.145  |  10.154.0.2|
someinternalhost  |-   | 10.154.0.3   |

[Установлен  vpn сервер pritunl](setupvpn.sh), открыт порт 13211/udp
Создан пользователь тест, с организацией otus.
[Конфигурация для подключения ](cloud-bastion.ovpn)

ДЗ:

    export bastion_ip=35.246.100.145
    export someinternalhost_ip=10.154.0.3
    export hostuser=appuser
    ssh -i ~/.ssh/$hostuser -A -J $hostuser@$bastion_ip $hostuser@$someinternalhost_ip

ДЗ1*:
Создаем конфиг ~/.ssh/config
    
    Host bastion
        HostName 35.246.100.145
        User appuser
    Host someinternalhost
        HostName 10.154.0.3
        ProxyJump bastion
        User appuser
        IdentityFile ~/.ssh/appuser

ДЗ2*:
Прикручен сертификат Let's Enccrypt
Вход по URL https://35-246-100-145.sslip.io
