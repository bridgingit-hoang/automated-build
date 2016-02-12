#!/bin/sh

# USAGE
# ./deploytest.sh [ tar file of milon package ] [ scriptversion ]
#.

clear
sudo stop milon-actlg2
sudo stop milon-worker
sudo stop milon-www
sudo stop milon-da
sudo stop milon-st
sudo stop milon-data

cd /var/www/

mv -f ./milonst/config.json ./config.json
rm -rf milonst

tar -xvf $1
cd milonst

sudo mv -f ../config.json ./config.json

node setVersion.js $2

sudo npm install --production

sudo start milon-data
sudo start milon-st
sudo start milon-da
sudo start milon-www
sudo start milon-worker
sudo start milon-actlg2