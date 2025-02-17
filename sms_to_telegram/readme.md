# Скрипт для перенаправления SMS из модема в telegram

## Описание

Этот скрипт предназначен для отправки SMS из модема на ваш telegram, используя команду `mmcli` и `PHP`.

Поддерживается только один модем в системе

## Установка и настройка

1. ### Клонирование репозитория
   ```bash
   git clone https://github.com/gooog1111/mmcli_sms_send.git
   cd ./mmcli_sms_send/sms_to_telegram/
   ```
2. ### Настройка скрипта:

2.1 Убедитесь, что у вас установлен `modemmanager`, `php` и модем определяется в системе:
```bash
   mmcli -L

   #    /org/freedesktop/ModemManager1/Modem/2 [QUALCOMM INCORPORATED] 0

```
2.2 Создайте бот в телеграме через `@BotFather`

2.3 Откройте в браузере `https://api.telegram.org/botВАШ_API/getupdates`

2.4 Напишите в свой бот несколько сообщений, для отображения id чата на странице браузера.
```php
"message":{"message_id":7,"from":{"id":00000000 .....
```
2.5 Отправьте тестовое сообщение вставив ссылку в браузер
```html
https://api.telegram.org/botВАШ_API/sendMessage?chat_id=ВАШ_ID_ЧАТА&text=тест
```
2.6 Настройте переменные `telegramapi` и `idchattelegram` в скрипте в соответствии с вашими требованиями.
```bash
   nano ./sms_send_telegram.sh
```
2.7 Скопируйте скрипт:
```bash
   sudo cp ./sms_send_telegram.sh /opt/
```

2.8 Настройте crontab:
Откройте редактор crontab:
```bash
   crontab -e
```
2.9 Добавьте следующую строку для запуска скрипта каждую минуту:
```bash
* * * * * sudo bash /opt/sms_send_telegram.sh
```
