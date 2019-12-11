# Плагин redmine1c
Плагин для интеграции [Redmine](https://www.redmine.org/) с [подсистемой "Redmine 1C"](https://zfilin.org.ua/link/redmine_1c)

## Описание
Плагин предназначем для отправки уведомлений об изменении или создании задач в HTTP-сервис подсистемы "Redmine 1С" для оперативного обновления данных о задачах.

## Установка
1. Перейдите в папку, где у вас установлен Redmine, например:
   ```
   cd /var/www/redmine
   ```
2. Распакуйте файлы в папку `plugins/redmine1c`
3. Обновите зависимости и установите плагин
   ```
   bundle install --without development test --no-deployment
   bundle exec rake redmine:plugins NAME=redmine1c RAILS_ENV=production
   ```
4. Перезапустите веб-сервер

   Например, для thin это можно сделать коммандой
   ```
   /etc/init.d/thin restart 
   ```
## Настройка
В настройках плагина две опции: включение плагина и адрес опубликованного HTTP-сервиса:
![Настройки плагина](https://raw.githubusercontent.com/zfilin/redmine1c/master/doc/fig1.png)

В адресе используется токен, который нужно взять из узла обмена:
![Где находится токен](https://raw.githubusercontent.com/zfilin/redmine1c/master/doc/fig2.png)

В остальном публикация HTTP-сервиса выполняется обычным образом.

## Проблемы при получении почты
В модуле Redmine, ответственном за получение почты и создание задач, по полученным письмам нет вызова стандартных *hooks* при создании новой задачи. Во всяком случае в **версии 3.4.5**

Соответственно, при создании задачи из почты, плагин не отправляет уведомление в 1С.

Это можно исправить с помощью патча `scripts/mailer_hooks.diff`

Для установки патча перейдите в папку, где у вас установлен Redmine и выполните команду:
```
patch -p0 < plugins/redmine1c/scripts/mailer_hooks.diff
```
Затем перезапустите веб-сервер.

## Удаление плагина
1. Удалите папку `plugins/redmine1c`
2. Перейдите в папку, где у вас установлен Redmine, и выполните команду удаления
   ```
   rake redmine:plugins:migrate NAME=redmine1c VERSION=0 RAILS_ENV=production
   ```
3. Перезапустите веб-сервер
