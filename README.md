# Скрипт для перенаправления SMS через модем

## Описание

Этот скрипт предназначен для отправки SMS на ваш номер через модем, используя команду `mmcli`.

Поддерживается только один модем в системе

## Установка и настройка

### Клонирование репозитория
   ```bash
   git clone https://github.com/gooog1111/mmcli_sms_to_sms.git
   cd ./mmcli_sms_to_sms/
   sudo cp ./sendsms.sh /opt/
   ```
### Настройка скрипта:

Убедитесь, что у вас установлен `modemmanager` и модем определяется в системе:
```bash
mmcli -L

#    /org/freedesktop/ModemManager1/Modem/2 [QUALCOMM INCORPORATED] 0

```
Настройте переменные `smsc` и `sendnumber` в скрипте в соответствии с вашими требованиями.

Настройка crontab:
Откройте редактор crontab:

```bash
crontab -e
```
Добавьте следующую строку для запуска скрипта каждую минуту:
```bash
* * * * * sudo bash /opt/sendsms.sh >> /var/log/sendsms.log 2>&1

```
