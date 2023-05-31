#!/bin/bash

#echo "Try to ping baidu.com..."

code_statu=$(curl -sIL -w "%{http_code}\n" -o /dev/null https://baidu.com)

#echo $code_statu

if [[ $code_statu != 200 ]];
then
        #echo "The current device is not online, trying to reconnect……"

        current_mac=$(ifconfig eth0 | grep "HWaddr" | cut -d " " -f 11)

        #echo $current_mac

        current_ip=$(ifstatus wan | grep -w '"address"' | cut -d "\"" -f 4)

        #echo $current_ip

        #echo "Try sending a Get request……"
	   
	   curl "http://172.31.8.14:801/eportal/portal/login?callback=dr1003&login_method=1&user_account=%2C0%2C13337204385%40telecom&user_password=fff123456&wlan_user_ip=${current_ip}&wlan_user_ipv6=&wlan_user_mac=${current_mac}&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=1035&lang=zh" > /etc/drcom_log1.txt

        if grep "认证成功" /etc/drcom_log1.txt;
        then
                echo "Successfully connected!"

        elif grep "您的账号已经在线" /etc/drcom_log1.txt;
        then
                #echo "A device conflict is detected ,connect again……"

                curl "http://172.31.8.14:801/eportal/portal/login?callback=dr1003&login_method=1&user_account=%2C0%2C13337204385%40telecom&user_password=fff123456&wlan_user_ip=${wan_ip}&wlan_user_ipv6=&wlan_user_mac=${wan_mac}&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=1035&lang=zh" >/etc/drcom_log1.txt

                if grep "认证成功" /etc/drcom_log1.txt;
                then
                        echo "Successfully connected!"
                fi

        else

                #echo "Try to generate available unicast mac address……"

                rand_mac=$(printf '48:%02X:%02X:%02X:%02X:%02X' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])
                
                #echo $rand_mac

                wan_mac=$(echo $rand_mac | tr -cd "[0-9][A-Z]")

                #echo $wan_mac

                #echo "Closing the network port eth0……"

                #ifconfig eth0 down

                #echo "Try writing the mac address to the network port eth0..."

                ifconfig eth0 hw ether $rand_mac

                #echo "Opening the network port eth0..."

                #ifconfig eth0 up

                #echo "Reading the wan_ip……"

                #ifstatus wan > /etc/wan_status.txt

                #wan_ip=$(grep -w '"address"' /etc/wan_status.txt | cut -d \" -f 4)

                wan_ip=$(ifstatus wan | grep -w '"address"' | cut -d "\"" -f 4)
			
		#echo ${wan_ip}

                #echo "Try sending a Get request……"

                curl "http://172.31.8.14:801/eportal/portal/login?callback=dr1003&login_method=1&user_account=%2C0%2C13337204385%40telecom&user_password=fff123456&wlan_user_ip=${wan_ip}&wlan_user_ipv6=&wlan_user_mac=${wan_mac}&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.2&terminal_type=1&lang=zh-cn&v=1035&lang=zh" > /etc/drcom_log1.txt

        fi
        echo 'date +%Y-%m-%d--%H:%M:%S' >> /etc/drcom.log1.txt

else
        #echo "The current device is online！"

        current_time=`date +%Y-%m-%d--%H:%M:%S`

        echo "The current device is online！$current_time" >> /etc/drcom_log.txt

fi
