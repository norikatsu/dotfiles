#!/bin/bash
# Backup Ubuntu(remote machine) to USBHDD
rsync -au -delete --safe-links --log-file=/home/nori/log/rsync-ubuntu-`date +"%Y%m%d-%H%M"`.log -e ssh nori@nori-linux:/home/nori /mnt/usbhdd/Backup/nori-ubuntu/
