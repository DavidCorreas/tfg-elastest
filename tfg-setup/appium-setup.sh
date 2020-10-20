#!/bin/bash
n=0
until [ "$n" -ge 30 ]
do
    adb connect $ANDROID_DEVICES
    device_lines=`adb devices | wc -l`
    if [ "$device_lines" -gt 2 ];
    then
        echo Device finded. 
        echo `adb devices`
        break
    else
        echo Device offline. Retries left $[30-$n]
        n=$((n+1))
        if [ $[30-$n] -lt 1 ]; 
        then
            echo "ERROR: No devices found, emulator in Selenium Hub may not be available" 
            exit 0
        fi
        sleep 2
        echo Retrying...
    fi
done

### COMENTADO YA QUE NO HACE FALTA, APPIUM PUEDE REGISTRAR UN DISPOSITIVO OFFLINE EN EL HUB

# echo "Waiting until online"
# n=0
# until [ "$n" -ge 30 ]
# do
#     device_lines=`adb devices | sed '2q;d' | awk 'NF>1{print $NF}'`
#     if [ "$device_lines" == "device" ];
#     then
#         echo Success, device online. 
#         echo `adb devices`
#         break
#     else
#         echo Device offline. Retries left $[30-$n]
#         echo `adb devices`
#         n=$((n+1))
#         if [ $[30-$n] -lt 1 ]; 
#         then
#             echo "ERROR: No device not online, emulator in Selenium Hub may not be available"
#             exit 0
#         fi 
#         sleep 3
#         echo Retrying...
#     fi
# done

echo SUCCESS!
exit 0
