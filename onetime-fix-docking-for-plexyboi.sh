#!/bin/bash
echo
echo "this script will fix your mount folders so they can't be broken again!"
echo "be sure you have run the fixthings.sh script immediately before running this script!!"
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
echo
echo
echo "stopping containers"
echo "..."
sudo docker container stop radarr
sudo docker container stop sonarr
sudo docker container stop bazarr
sudo docker container stop jackett
sudo docker container stop transmission
echo "unmounting network drives"
echo "..."
sudo umount /mnt/moobies
sudo umount -l /mnt/moobies
sudo umount /mnt/backups
sudo umount -l /mnt/backups
echo "waiting for 10 seconds for the hamster wheels to stop spinning"
echo "..."
sleep 10
echo
echo
echo "please confirm there are no output lines between here..."
sudo mount | grep moobies
sudo mount | grep backups
read -p "... and here, before pressing enter to continue, or Ctrl + C to abort" </dev/tty
echo
echo "..."
echo
read -p "press enter again if you're !!absolutely sure!! or press Ctrl + C to abort" </dev/tty
echo "..."
echo "cleaning mount folders"
echo "..."
sudo rm -rf /mnt/moobies/*
sudo rm -rf /mnt/backups/*
echo "fixing mount folders so they can't be written to incorrectly"
echo "..."
sudo chmod -R 555 /mnt/moobies
sudo chmod -R 555 /mnt/backups
echo "mounting network drives"
echo "..."
sudo mount -a
echo "starting containers back up"
echo "..."
sudo docker container start transmission
sudo docker container start jackett
sudo docker container start radarr
sudo docker container start sonarr
sudo docker container start bazarr
echo
echo "Checking if the containers are running"
echo "..."
sudo docker container ls | grep transmission
sudo docker container ls | grep radarr
sudo docker container ls | grep sonarr
sudo docker container ls | grep bazarr
sudo docker container ls | grep jackett
echo
echo "All done!"
