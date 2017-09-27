#!/bin/sh
# A script to install and running Folding@Home
# Author: Monisan Fu(@sufuf3)
# date:20170924
#
# OS: Ubuntu 16.04 64-bits
# Install: sh p4-environment.sh

sudo apt-get install git vim -y
sudo apt-get install g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev pkg-config python python-scapy python-ipaddr tcpdump cmake linux-generic-lts-vivid -y
sudo apt-get install python-pip python-dev build-essential -y
sudo apt-get install mininet -y
sudo pip install scapy thrift networkx
# Install docker
#curl -sSL https://get.docker.com/ | sh
#sudo docker version
# Install other dependencies
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install bridge-utils -y
sudo pip3 install scapy-python3
sudo pip3 install websockets
# install bmv2: P4 software switch (aka behavioral model)
cd ~/ && git clone https://github.com/p4lang/behavioral-model.git bmv2
cd ~/bmv2/ && sh install_deps.sh
cd ~/bmv2/travis/ && sh install-nanomsg.sh
cd ~/bmv2/travis/ && sh install-thrift.sh
cd ~/bmv2/travis/ && sh install-nanomsg.sh
cd ~/bmv2/ && ./autogen.sh
cd ~/bmv2/ && ./configure
cd ~/bmv2/ && make
cd ~/bmv2/ && sudo make install
sudo ldconfig

# p4c-bm: Generates the JSON configuration for the behavioral-model (bmv2)
cd ~/ && git clone https://github.com/p4lang/p4c-bm.git p4c-bmv2
cd ~/p4c-bmv2/ && sudo pip install -r requirements.txt
cd ~/p4c-bmv2/ && sudo python setup.py install

# Install P4 language tutorials repo
cd ~/ && git clone https://github.com/p4lang/tutorials.git

# Install protobuf
sudo apt-get install autoconf automake libtool curl make g++ unzip
cd ~/ && git clone https://github.com/google/protobuf.git
cd ~/protobuf/ && ./autogen.sh
cd ~/protobuf/ && ./configure
cd ~/protobuf/ && make
cd ~/protobuf/ && sudo make install
cd ~/protobuf/ && sudo ldconfig

# install p4c
sudo apt-get install g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev pkg-config python python-scapy python-ipaddr tcpdump cmake
cd ~/ && git clone --recursive https://github.com/p4lang/p4c.git
cd ~p4c/ && mkdir build
cd ~/p4c/build/ && cmake ..
cd ~/p4c/build/ && make -j4
cd ~/p4c/build/ && make -j4 check
cd ~/p4c/build/ && sudo make install
