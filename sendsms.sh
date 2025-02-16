#!/bin/bash

# Настройки
smsc="+1234567890"
sendnumber="+1234567890"

# Создание временного каталога для хранения SMS
mkdir -p /tmp/sms

# Определение модема
idmodem=$(mmcli -L | sed 's/.*m\///' | awk '{print $1}')

# Получение списка SMS и формирование файлов с текстом
mmcli -m $idmodem --messaging-list-sms | awk -F: '/(received)/ { print $1 }' | sed 's/.*SMS//' | tr -d '/(received)' | while read textsms; do
	echo "$(mmcli -s $textsms | grep number: | sed s/.*number:// | tr -d ' ' && echo '------------' && mmcli -s 42 | sed s/.*text:// | sed '/^$/d' | sed 1,4d|  head -n -6 | sed 's/^.*|           //g')" > /tmp/sms/$textsms
done

# Сравнение файлов и удаление дубликатов
declare -A dublsms
for filesmsduble in /tmp/sms/*; do
    [[ -f "$filesmsduble" ]] || continue
    cksm=$(md5sum "$filesmsduble" | awk '{print $1}')
    if ((dublsms[$cksm]++)); then
        rm "$filesmsduble"
        filesmsduble=$(basename "$filesmsduble")
        mmcli -m "$idmodem" --messaging-delete-sms="$filesmsduble"
    fi
done
unset dublsms

# Формирование SMS для отправки
for textsms in /tmp/sms/*; do
    mmcli -m "$idmodem" --messaging-create-sms-with-text="$textsms" --messaging-create-sms="number='$sendnumber',smsc='$smsc'"
done

# Удаление входящих SMS
mmcli -m "$idmodem" --messaging-list-sms | awk -F: '/(received)/ { print $1 }' | sed 's/.*SMS//' | tr -d '/(received)' | while read recivedsmsdel; do
    mmcli -m "$idmodem" --messaging-delete-sms="$recivedsmsdel"
done

# Отправка сформированных SMS
mmcli -m "$idmodem" --messaging-list-sms | awk -F: '/(unknown)/ { print $1 }' | sed 's/.*SMS//' | tr -d '/(unknown)' | while read sendlistsms; do
    if ! mmcli -s "$sendlistsms" --send; then
        exit 1
    fi
done

# Удаление отправленных SMS
mmcli -m "$idmodem" --messaging-list-sms | awk -F: '/(sent)/ { print $1 }' | sed 's/.*SMS//' | tr -d '/(sent)' | while read sendlistsmsdel; do
    mmcli -m "$idmodem" --messaging-delete-sms="$sendlistsmsdel"
done

# Очистка временного каталога
rm -rf /tmp/sms
