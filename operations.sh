#!/bin/bash

cp ./.iaac.functions.sh ~/
rm ./.iaac.functions.sh
chmod +x ~/.iaac.functions.sh
echo " " >>  ~/.bashrc
echo "# IAAC Devops Env." >>  ~/.bashrc
echo 'source ~/.iaac.functions.sh' >>  ~/.bashrc