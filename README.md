# vasiliev-alexey_infra
vasiliev-alexey Infra repository

___
###  **Домашнее задаание по теме №11**
1. Ознакомились с playbook
        playbook - (1-N) plays  ->  (1-N) tasks для одного хоста
2. Ознакомились с шаблонами
3. Создали handlers
4. Изучили различные варианты построения playbook:
        * Один плейбук,несколько сценариев
        * Избавляем бизнес от ИТ-зависимостиНесколько плейбуков
5. Изучили примение Ansible  как провижининг в Packer

___
###  **Домашнее задаание по теме №10**

1. Установили ansible  через pip
2. Ознакомились с базовыми функциями
        * Inventory file
        * Модулями
        ping
        command
        shell
        service
        * конфигурационными файлами
3. Ознакомились с  инвентори
4. Написали собственный playbook

ДЗ

        Проигрывание playbook  после комманды по удалению директории - привело к  измнению состояния, и это отразилось в выводе в консоль.

ДЗ*

        Inventory создано в  формате JSON, создан bash-скрипт  параметризирован
         --list  - выдает список всех хостов из json  файла
         --host  выдает пустой список хостов.
          В ansible.cfg указан скрипт, как генератор invrntory.

___
###  **Домашнее задаание по теме №9**

1. Импортировали в State terraform  инфраструктуру GCP  firewall

        terraform import google_compute_firewall.firewall_ssh default-allow-ssh
2. Научились создавать зависимости между ресурами инфраструктуры проекта TF
3. Раздлили однонодовую конфигурацию на 2 нодовую. путем разбиения на несколько инфраструктур в terraform
4. Конфигурацию разбили на  3 модуля -  app db vpc -  параметризировали их.
5. На основе модулй - создали 2    сред -  stage и  prod
6.  Изучили реестр модулей на примере storage-bucket

ДЗ*  Созданы  конфигурации для удаленого хранения [состояния](terraform/prod/backend.tf)
        1. Проверено  что состояние обнаруживается через  storage bucket
        2. Паралельное измнение поймать не удалось


ДЗ** В модуль app добавлены provisioners для деплоя приложения. Хост db-service передается в app-service и добавляется в  systemd  конфиг puma.service.
 В db-service - открыты адреса для подключения




___
###  **Домашнее задаание по теме №8**

1. Устанавливаем Terraform - скачиваением бинарников и помещении его в  каталог поиска исполняемых файлов.
2. Создаем [конфиг](terraform/main.tf)
3. Сконфигурировали [out  переменные](terraform/outputs.tf)
4. Конфигугурируем Provisioners

        provisioner "file" {
        source      = "files/puma.service"
        destination = "/tmp/puma.service"
        }

        provisioner "remote-exec" {
        script = "files/deploy.sh"
        }
5. Добавляем [Input vars](terraform/variables.tf)
6. Добавляем [переменные](terraform/terraform.tfvars.example)
7. Реконфигурируем конфиг, для использования переменных

ДЗ1* Добавляем нескольких пользователей

        metadata = {
        ssh-keys = "appuser:${file(var.public_key_path)}\nappuser1:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"
        }
  При  добавлении через WEB-консоль и последующей синхронизацией - данные  про ключи, теряются

Note:
Для корректной работы
рекомендуется указывать версию терраформа ~> 0.12.0 и
провайдера google ~> 2.5.0

ДЗ1** [Добавляем  балансировщик](terraform/lb.tf)

стр52
___
###  **Домашнее задаание по теме №7**

1. Устанвливаем  Packer  по инструкции от вендора.

        packer -v

2. Даем доступ Application Default Credentials

        gcloud auth application-default login

3. [Создаем конфиг packer](packer/ubuntu16.json)
4. Валидируем созданный конфиг

        packer validate -var-file=./variables.json ./ubuntu16.json
5. Собираем образ по [конфигу](packer/ubuntu16.json)

        packer build -var-file=./variables.json ubuntu16.json

        ps Иногда не успевает  VM развернутся, перед апдейтом - возникают ошибки - добавил задержку в 20 секунд

6. Создаем  VM из web-console, прописываем правило firewall. Развертываем приложение.

ДЗ1* [Создаем базовую конфигурацию](packer/immutable.json)

Используя DSL -  внедряем занчения переменных

         "{{user `machine_type`}}"

[Имитация конфига секретов](packer/variables.json.example)

ДЗ2* : [Создаем VM из образа  ДЗ1*](config-scripts/create-reddit-vm.sh)

        gcloud compute instances create reddit-app-full\
        --boot-disk-size=10GB \
        --image-family reddit-full  \
        --machine-type=g1-small \
        --restart-on-failure\
        --tags='puma-server'


___

###  **Домашнее задаание по теме №6**
testapp_IP = 146.148.17.212
testapp_port = 9292


[Создаем VM в GCP](config-scripts/create_gcp_vm.sh)




[Устанвливаем Ruby](config-scripts/install_ruby.sh)

        sudo apt update && sudo apt install -y ruby-full ruby-bundler build-essential

[Устанвливаем MongoDB](config-scripts/install_mongodb.sh)

        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xd68fa50fea312927
        sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list' sudo apt-get update
        sudo apt install -y --allow-unauthenticated mongodb-org

        sudo systemctl start mongod

        sudo systemctl enable mongod


[Деплой приложения](config-scripts/deploy_mongodb.sh)

        cd ~
        git clone -b monolith https://github.com/express42/reddit.git
        cd reddit && bundle install
        puma -d
Создаем  правило firewall

        gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags=puma-server


Тестим

        curl -s -o /dev/null -w "%{http_code}" http://146.148.17.212:9292/




ДЗ1*
[Создаем все вместе ](config-scripts/startup-script.sh)

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

| Хост             |     ip ext     |   ip int   |
| :--------------- | :------------: | :--------: |
| bastion          | 35.246.100.145 | 10.154.0.2 |
| someinternalhost |       -        | 10.154.0.3 |

[Установлен  vpn сервер pritunl](VPN/setupvpn.sh), открыт порт 13211/udp
Создан пользователь тест, с организацией otus.
[Конфигурация для подключения ](VPN/loud-bastion.ovpn)

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
