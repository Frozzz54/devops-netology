# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

```
1. Replication: указывает количество реплик, которые необходимо запустить. Global: запускает сервисы на каждом узле. При добавлении нового узла, планировщик назначает задачу новому узлу.
2. Использует Raft - протокол для реализации распределенного консенсуса. Все узлы начинают с состояния "последователя", если они не получают ответа от лидера, они могут стать кандитами, кандидат отправляет запрос на утверждения последователям, узлы отвечают и кандидат становится лидером.
3. Overlay - распределенная сеть между узлами Docker. Предназначена для использования в кластере Docker Swarm, образатывает маршрутизацию каждого пакета к правильному хосту демона Docker и правильному контейнеру.
```



## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```

```
frozzy@Frozzy:~/devops-netology/homeworks/05-virt-05-docker-swarm/src/terraform$ ssh -A centos@62.84.119.195
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
ezuzu936921clcquhyd2zc4q0 *   node01.netology.yc   Ready     Active         Leader           20.10.17
7n5x5lnkibamx2lybx3c10wiu     node02.netology.yc   Ready     Active         Reachable        20.10.17
8htveuuixnbowa5h3tm8bk5d1     node03.netology.yc   Ready     Active         Reachable        20.10.17
8hc1sxitfryz3rq32mii6isdm     node04.netology.yc   Ready     Active                          20.10.17
i096v3gzgzuzfn096xd03ikdo     node05.netology.yc   Ready     Active                          20.10.17
lteff4b8w2jw0rasmt0e8b6se     node06.netology.yc   Ready     Active                          20.10.17
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

```
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
s207qwojfg6d   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
ryxmv18wmgtm   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
27s4b0tq64n1   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
b8burclqv51m   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
ra56pozpoekw   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
ydym1cexmhb2   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
k058p64a9xm2   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
5sl6srl1qjiq   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
