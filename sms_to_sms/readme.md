# Скрипт для перенаправления SMS через модем

## Описание

Этот скрипт предназначен для отправки SMS на ваш номер через модем, используя команду `mmcli`.

Поддерживается только один модем в системе

## Установка и настройка

1. ### Клонирование репозитория
   ```bash
   git clone https://github.com/gooog1111/mmcli_sms_send.git
   cd ./mmcli_sms_send/sms_to_sms/
   ```
2. ### Настройка скрипта:

2.1 Убедитесь, что у вас установлен `modemmanager` и модем определяется в системе:
```bash
   mmcli -L

   #    /org/freedesktop/ModemManager1/Modem/2 [QUALCOMM INCORPORATED] 0

```
2.2 Настройте переменные `smsc` и `sendnumber` в скрипте в соответствии с вашими требованиями.
```bash
   nano ./sms_send_sms.sh
```
2.3 Скопируйте скрипт:
```bash
   sudo cp ./sms_send_sms.sh /opt/
```

2.4 Настройте crontab:
Откройте редактор crontab:
```bash
   crontab -e
```
Добавьте следующую строку для запуска скрипта каждую минуту:
```bash
* * * * * sudo bash /opt/sms_send_sms.sh
```
