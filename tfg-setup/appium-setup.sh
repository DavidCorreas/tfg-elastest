#!/bin/bash
n=0
until [ "$n" -ge 30 ]
do
    adb connect $ANDROID_DEVICES
    device_lines=`adb devices | wc -l`
    if [ "$device_lines" -gt 2 ];
    then
        echo Success. 
        echo `adb devices`
        exit 0
    fi
    echo No connected devices. Retries left $[30-$n]
    n=$((n+1)) 
    sleep 2
    echo Retrying... 
done
