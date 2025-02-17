#!/bin/bash

# Настройки
telegramapi="00000000:AABBCCDDEEFFGGHHaabbccddeeffgghh"
idchattelegram="000000000"
# Создание временного каталога для хранения SMS
mkdir -p /tmp/sms

# Определение модема
idmodem=$(mmcli -L | sed 's/.*m\///' | awk '{print $1}')

# Получение списка SMS и формирование файлов с текстом
mmcli -m $idmodem --messaging-list-sms | awk -F: '/(received)/ { print $1 }' | sed 's/.*SMS//' | tr -d '/(received)' | while read textsms; do
	echo "$(mmcli -s $textsms | grep number: | sed s/.*number:// | tr -d ' ' && echo '------------' && mmcli -s $textsms | sed s/.*text:// | sed '/^$/d' | sed 1,4d|  head -n -6 | sed 's/^.*|           //g')" > /tmp/sms/$textsms
done

# Сравнение файлов и удаление дубликатов
declare -A dublsms
for filesmsduble in /tmp/sms/*; do
    [[ -f "$filesmsduble" ]] || continue
    cksm=$(md5sum "$filesmsduble" | awk '{print $1}')
    if ((dublsms[$cksm]++)); then
        rm "$filesmsduble"
    fi
done
unset dublsms

# Формирование и отправка SMS в telegram через PHP
for textsmssend in /tmp/sms/*; do
    smstelegram=$(cat $textsmssend | sed 's/$/%0A/' | tr -d "\n")
    echo "<?php file_get_contents('https://api.telegram.org/bot$telegramapi/sendMessage?chat_id=$idchattelegram&text='.(string)'$smstelegram'); ?>" | php
done

# Удаление входящих SMS
mmcli -m "$idmodem" --messaging-list-sms | awk -F: '/(received)/ { print $1 }' | sed 's/.*SMS//' | tr -d '/(received)' | while read recivedsmsdel; do
    mmcli -m "$idmodem" --messaging-delete-sms="$recivedsmsdel"
done

# Очистка временного каталога
rm -rf /tmp/sms
