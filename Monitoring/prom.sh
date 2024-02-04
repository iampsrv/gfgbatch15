#!/bin/bash
sudo apt update -y
sudo apt-get update
sudo apt-get -y upgrade
cd /opt
sudo wget https://github.com/prometheus/prometheus/releases/download/v2.49.1/prometheus-2.49.1.linux-amd64.tar.gz
sudo tar xf prometheus-2.49.1.linux-amd64.tar.gz