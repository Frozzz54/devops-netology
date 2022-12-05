# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Ответ
### Запускаем контейнер
```
C:\Programming\DevOps\devops-netology\homeworks\06-db-04-postgresql> docker-compose up -d 

PS C:\Programming\DevOps\devops-netology\homeworks\06-db-04-postgresql> docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES
b84df0732b6d   postgres:13   "docker-entrypoint.s…"   19 minutes ago   Up 19 minutes   0.0.0.0:5432->5432/tcp   postgres
```

### Подключение к бд
```
C:\Programming\DevOps\devops-netology\homeworks\06-db-04-postgresql> docker exec -it postgres /bin/bash 

root@b84df0732b6d:/# psql -U test-admin-user -d test_db
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.

test_db=# 
```

```
- вывода списка БД -> \l
- подключения к БД -> \c
- вывода списка таблиц -> \d 
- вывода описания содержимого таблиц -> **TABLE orders;** || **SELECT * FROM "orders";**
- выхода из psql -> \q
```
---
## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Ответ
### Создаем базу **test_database**
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

### Восстанавливаем базу из бэкапа
```
root@1e2411743a6c:/# psql -U test-admin-user -d test_database -f /test_data/test_dump.sql
```
### Проведите операцию ANALYZE

```
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

### Среднее наибольшее значение размера в байтах

```
test_database=# SELECT schemaname, tablename, attname, avg_width, correlation from pg_stats where tablename = 'orders' ORDER BY avg_width DESC LIMIT 1;
 schemaname | tablename | attname | avg_width | correlation 
------------+-----------+---------+-----------+-------------
 public     | orders    | title   |        16 |  -0.3809524
(1 row)
```
---
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Ответ 

```
Преобразовать существующую таблицу в партиционированную поэтому пересоздадим таблицу
test_database=# alter table orders rename to orders_simple;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_simple;
INSERT 0 8
test_database=# 
При изначальном проектировании таблиц можно было сделать ее секционированной, тогда не пришлось бы переименовывать исходную таблицу и переносить данные в новую.
```
---
## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

### Создание бэкапа
```
root@1e2411743a6c:/# cd test_data/
root@1e2411743a6c:/test_data# pg_dump -U test-admin-user -d test_database >test_database_dump.sql
```
### В бэкап-файл добавил при создании таблице orders для столбца title ключевое слово UNIQUE
### Когда добавляется UNIQUE ограничение к столбцу или группе столбцов, PostgreSQL автоматически создает уникальный индекс для столбца или группы столбцов.
---
