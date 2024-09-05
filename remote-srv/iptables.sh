#!/bin/bash
#apt install iptables iptables-persistent
#для сохранения правил
#netfilter-persistent save
#посмотрим что сохранилось
#cat /etc/iptables/rules.v4

IPT=iptables
## Внешний интерфейс
WAN=eth0
WAN_IP=38.180.212.239


## Блокируем весь трафик, который не соответствует ни одному из правил
$IPT -P INPUT DROP

## Разрешаем весь трафик в локалхост и локальной сети
$IPT -A INPUT -i lo -j ACCEPT


## Разрешаем все установленные соединения и дочерние от них
$IPT -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT

## Защита от наиболее распространенных сетевых атак. (опционально)
## Отбрасываем все пакеты без статуса (опционально)
$IPT -A INPUT -m state --state INVALID -j DROP

## Блокируем нулевые пакеты (опционально)
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

## Закрываемся от syn-flood атак (опционально)
$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

## Запрет доступа с определенных IP (опционально)
#$IPT -A INPUT -s ipaddres -j REJECT


## Разрешаем ssh (порт 22 - это порт по умолчанию для ssh соединения, если вы его меняли, то обязательно значение 22 надо заменить своим, иначе будет потерян доступ к серверу)
$IPT -A INPUT -i $WAN -p tcp --dport 22 -j ACCEPT
$IPT -A INPUT -i $WAN -p tcp --dport 80 -j ACCEPT
$IPT -A INPUT -i $WAN -p tcp --dport 43492 -j ACCEPT