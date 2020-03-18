# vasiliev-alexey_infra
vasiliev-alexey Infra repository

**Домашнее задаание по теме №5**

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
