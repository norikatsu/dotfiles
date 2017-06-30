#!/bin/bash
# Backup Redhat(local machine) to USBHDD
rsync -au -delete --safe-links --log-file=/home/nori/log/rsync-redhat-`date +"%Y%m%d-%H%M"`.log /home/nori /mnt/usbhdd/Backup/nori-fpga-build/

