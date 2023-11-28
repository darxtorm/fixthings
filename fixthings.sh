#!/bin/bash
## defining mount folders to work with
FOLDER1=moobies
FOLDER2=backups
echo -e "\n"
echo "This script is designed to fix drive mounts that are normally empty but have been written to"
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
echo "First we will stop the containers. You may be asked to enter your password..."
echo
sudo docker container stop radarr
sudo docker container stop sonarr
sudo docker container stop bazarr
sudo docker container stop jackett
sudo docker container stop transmission
echo
echo "Checking if the containers have stopped before continuing"
echo
echo "..."
sudo docker container ls | grep transmission 
sudo docker container ls | grep radarr
sudo docker container ls | grep sonarr
sudo docker container ls | grep bazarr
sudo docker container ls | grep jackett
echo "There should be no text above this line apart from the '...'"
echo
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
echo
echo "Now we will unmount the network drives so we can work with the folders underneath"
sudo umount /mnt/$FOLDER1
sudo umount -l /mnt/$FOLDER1
sudo umount /mnt/$FOLDER2
sudo umount -l /mnt/$FOLDER2
echo "Checking if the network drives have successfully unmounted before continuing"
echo
echo "..."
sudo mount | grep $FOLDER1
sudo mount | grep $FOLDER2
echo "There should be no text above this line apart from the '...'" 
echo
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
echo
du -d 1 -h /mnt
echo "The lines above show the sizes of the folders in /mnt - which should normally be empty but are currently not."
echo
echo "Now we will move the contents of these folders to a temporary location."
echo
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
mkdir /tmp/$FOLDER1
mkdir /tmp/$FOLDER2
sudo mv /mnt/$FOLDER1/* /tmp/$FOLDER1/
sudo mv /mnt/$FOLDER2/* /tmp/$FOLDER2/
echo "Moving has finished, now let's check the sizes of the folders in /mnt again."
echo
du -d 1 -h /mnt
echo "The lines above show the sizes of the folders in /mnt - which should now be empty."
echo
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
echo
echo "Now we will re-mount the network drives on the NAS to the /mnt folder"
sudo mount -a
echo
echo "Checking if the network drives have successfully mounted again before continuing"
echo "..."
sudo mount | grep $FOLDER1
sudo mount | grep $FOLDER2
echo "There should be two lines showing the mounted drives, above this line, apart from the '...'"
echo
read -p "Press Enter to continue, or Ctrl + C to abort" </dev/tty
echo
echo "Now we will copy the folder contents to the right places. This might take a little while..."
cd /tmp/$FOLDER1/
sudo rsync -ahrP ./* /mnt/$FOLDER1/
cd /tmp/$FOLDER2/
sudo rsync -ahrP ./* /mnt/$FOLDER2/
echo -e \n
echo "Now all the files are in their correct places, let's start the containers again."
echo
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
