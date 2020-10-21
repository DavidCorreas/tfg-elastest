#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

echo ====
echo "INFO: May take a while, to skip press CTRL-C"
echo ====

function ctrl_c() {
    echo
    echo "WARNING: Device may not be ready"
    echo "Exiting..."
    exit 0
}

n=0
until [ "$n" -ge 30 ]
do
    adb connect $ANDROID_DEVICES
    device_lines=`adb devices | wc -l`
    if [ "$device_lines" -gt 2 ];
    then
        echo -------------
        echo Device finded. 
        echo -------------
        echo `adb devices`
        break
    else
        echo Device offline. Retries left $[30-$n]
        n=$((n+1))
        if [ $[30-$n] -lt 1 ]; 
        then
            echo "WARNING: No devices found, emulator in Selenium Hub may not be available" 
            exit 0
        fi
        sleep 2 &
        wait $!
        echo Retrying...
    fi
done

## Esperar a que esté online, ya que puede que se registre a selenium hub sin estar
## disponible y no se registra el dispositivo

echo 
echo -------------
echo "Waiting until online. May take a while, to skip press CTRL-C."
echo -------------
sleep 5

n=0
until [ "$n" -ge 30 ]
do
    device_lines=`adb devices | sed '2q;d' | awk 'NF>1{print $NF}'`
    if [ "$device_lines" == "device" ];
    then
        echo 
        echo -------------
        echo Success, device online. 
        echo -------------
        echo `adb devices`
        break
    else
        echo Device offline. Retries left $[30-$n]
        echo `adb devices`
        n=$((n+1))
        if [ $[30-$n] -lt 1 ]; 
        then
            echo 
            echo -------------
            echo "INFO: No device not online, emulator in Selenium Hub may not be available"
            echo -------------
            exit 0
        fi 
        sleep 5 &
        wait $!
        echo Retrying...
    fi
done

echo
echo -------------
echo SUCCESS!
echo -------------
exit 0
