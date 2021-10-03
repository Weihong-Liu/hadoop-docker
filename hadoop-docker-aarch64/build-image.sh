#!/bin/bash

echo -e "\nbuild docker hadoop image\n"
sudo docker build -f Dockerfile -t puppets/hadoop:1.0 .

echo ""