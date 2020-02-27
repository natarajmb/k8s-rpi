# Kubernetes on Raspberry Pi

Scripts and instructions on setting up the Kubernetes cluster on Raspberry Pi. Sharing here to aid anyone else attempting to do the same. I have used Raspberry Pi 4 Model B in my setup as some of the scripts assumes wifi (wlan0) built-in.

## How to use the scripts

Step 1 : Download the repo and execute the following commands to substitute with your desired values

    # replace your domain search suffix if not sure leave it as loc
    find . -type f -exec sed -i 's/YOUR_DOMAIN_SEARCH/loc/g' {} \;

    # replace with your internal namesservers or not sure replace with googles 4.4.4.4 & 8.8.8.8 
    find . -type f -exec sed -i 's/YOUR_NAMESERVERS/4.4.4.4,8.8.8.8/g' {} \;

    # replace with your gateway i.e. generally your router ip
    find . -type f -exec sed -i 's/YOUR_GATEWAY/192.168.0.1/g' {} \;

    # replace with your wireless id
    find . -type f -exec sed -i 's/WIRELESS_SSID/awesome.ssid/g' {}\;

    # replace with your wireless password
    find . -type f -exec sed -i 's/PASSWORD/secret/g' {}\;

    # replace with your desired username else leave it as ubuntu
    find . -type f -exec sed -i 's/YOUR_USER_NAME/ubuntu/g' {}\;

Above replacements are common for all the devices you want to use this scripts for, while below i.e. hostname needs replacing for each one

    # replace with desired hostname for each RPi
    find . -type f -exec sed -i 's/HOSTNAME/k8s-master/g' {}\;

Copy your ssh key for passwordless login 

    cat ~/.ssh/id_rsa.pub >> post_install/id_rsa.pub

Step 2 : Format the SD Card and load the Ubuntu 18.04 image. Mount SD Card and copy the contents from `post_flash` directory into `/writable` partition i.e. you are overlaying files on the `/etc` and `/lib` 

Step 3 : Power on the RPi and wait for a few mins as it will power cycle twice at the end of it you should have your ready k8s node.

_Note: Use Linux for ease of mounting the file system after flashing the SD card as `/writable` partition is ext4 and you have limited support in Windows & macOS for writing on ext4 filesystem_ 