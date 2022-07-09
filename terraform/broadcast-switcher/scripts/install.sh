#!/bin/bash
if [ ! -e /home/ubuntu/.ssh ]; then
    mkdir -p 
    touch /home/ubuntu/.ssh/authorized_keys
    for i in jacopen TakumaNakagame capsmalt Gaku-Kunimi ryojsb tanayan299 onarada ; do
      curl "https://github.com/$i.keys" >> /home/ubuntu/.ssh/authorized_keys
    done
    sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
fi

sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo apt-get update
sudo apt-get install -y vim git unzip ubuntu-drivers-common ocl-icd-libopencl1 opencl-headers clinfo obs-studio ffmpeg ubuntu-desktop net-tools software-properties-common 
