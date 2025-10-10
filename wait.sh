#!/bin/bash
echo -e "\033[1;36mWaiting for cloud-init..."
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
  sleep 1
done
sudo snap install docker
sleep 2s
sudo docker pull strm/helloworld-http
sleep 2s
#sudo docker run --rm -it -p 80:80 strm/helloworld-http
sudo docker run -d -p 80:80 strm/helloworld-http > /dev/null 2>&1