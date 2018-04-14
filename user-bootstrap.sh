#!/bin/bash

# Print script commands.
set -x
# Exit on errors.
set -e

BMV2_COMMIT="39abe290b4143e829b8f983965fcdc711e3c450c"
PI_COMMIT="afd5831393824228246ea01b26da2f93d38fd20c"
P4C_COMMIT="80f8970b5ec8e57c4a3611da343461b5b0a8dda3"
PROTOBUF_COMMIT="v3.2.0"
GRPC_COMMIT="v1.3.2"

NUM_CORES=`grep -c ^processor /proc/cpuinfo`

# Mininet
git clone git://github.com/mininet/mininet mininet
cd ~/mininet && sudo ./util/install.sh -nwv
cd ~/

# Protobuf
# Install protobuf
sudo apt-get install autoconf automake libtool curl make g++ unzip
git clone https://github.com/google/protobuf.git
cd ~/protobuf && git checkout ${PROTOBUF_COMMIT}
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Wl,-s"
cd ~/protobuf && ./autogen.sh
cd ~/protobuf && ./configure --prefix=/usr
cd ~/protobuf && make -j${NUM_CORES}
cd ~/protobuf && sudo make install
cd ~/protobuf && sudo ldconfig
unset CFLAGS CXXFLAGS LDFLAGS
cd ~/

# gRPC
git clone https://github.com/grpc/grpc.git
cd ~/grpc && git checkout ${GRPC_COMMIT}
cd ~/grpc && git submodule update --init --recursive
export LDFLAGS="-Wl,-s"
cd ~/grpc && make -j${NUM_CORES}
cd ~/grpc && sudo make install
cd ~/grpc && sudo ldconfig
unset LDFLAGS
cd ~/
# Install gRPC Python Package
sudo pip install grpcio

# BMv2 deps (needed by PI)
sudo apt-get install g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev pkg-config python python-scapy python-ipaddr tcpdump cmake linux-generic-lts-vivid libssl-dev -y
sudo apt-get install python-pip python-dev build-essential -y
sudo pip install --upgrade pip
sudo pip install scapy thrift networkx
# Install other dependencies
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install bridge-utils -y
sudo pip3 install scapy-python3
sudo pip3 install websockets
git clone https://github.com/p4lang/behavioral-model.git
cd ~/behavioral-model && git checkout ${BMV2_COMMIT}
# From bmv2's install_deps.sh, we can skip apt-get install.
# Nanomsg is required by p4runtime, p4runtime is needed by BMv2...
cd ~/behavioral-model
tmpdir=`mktemp -d -p .`
#cd ${tmpdir} && bash ../travis/install-thrift.sh
cd ~/behavioral-model/travis/ && sh install-thrift.sh
cd ${tmpdir} && bash ../travis/install-nanomsg.sh
cd ${tmpdir} && sudo ldconfig
cd ${tmpdir} && bash ../travis/install-nnpy.sh
cd ..
sudo rm -rf $tmpdir
cd ~/

# PI/P4Runtime
sudo apt-get install -y libjudy-dev libreadline-dev valgrind libtool-bin libboost-dev libboost-system-dev libnanomsg-dev
git clone https://github.com/p4lang/PI.git
cd ~/PI && git checkout ${PI_COMMIT}
cd ~/PI && git submodule update --init --recursive
cd ~/PI && ./autogen.sh
cd ~/PI && ./configure --with-proto
cd ~/PI && make -j${NUM_CORES}
cd ~/PI && sudo make install
cd ~/PI && sudo ldconfig
cd ~/

# Bmv2
cd ~/behavioral-model && ./autogen.sh
cd ~/behavioral-model && ./configure --enable-debugger --with-pi
cd ~/behavioral-model && make -j${NUM_CORES}
cd ~/behavioral-model && sudo make install
cd ~/behavioral-model && sudo ldconfig
# Simple_switch_grpc target
cd ~/behavioral-model/targets/simple_switch_grpc && ./autogen.sh
cd ~/behavioral-model/targets/simple_switch_grpc && ./configure
cd ~/behavioral-model/targets/simple_switch_grpc && make -j${NUM_CORES}
cd ~/behavioral-model/targets/simple_switch_grpc && sudo make install
cd ~/behavioral-model/targets/simple_switch_grpc && sudo ldconfig
cd ~/

# P4C
git clone https://github.com/p4lang/p4c
cd ~/p4c && git checkout ${P4C_COMMIT}
cd ~/p4c && git submodule update --init --recursive
cd ~/p4c && mkdir -p build
cd ~/p4c/build && cmake ..
cd ~/p4c/build && make -j${NUM_CORES}
cd ~/p4c/build && make -j${NUM_CORES} check
cd ~/p4c/build && sudo make install
cd ~/p4c/build && sudo ldconfig
cd ~/

# Tutorials
sudo pip install crcmod
git clone https://github.com/p4lang/tutorials

# Do this last!
sudo reboot
