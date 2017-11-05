#!/bin/bash
# Backup Ubuntu(remote machine) to USBHDD
rsync -au -delete --safe-links --log-file=/home/nori/log/rsync-planck-`date +"%Y%m%d-%H%M"`.log -e ssh nori@planck:/home/nori /mnt/usbhdd/Backup/nori-planck/
