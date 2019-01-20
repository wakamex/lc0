#!/bin/bash
echo "Installing CUDA"
wget -nc http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/cuda-repo-ubuntu1704_9.0.176-1_amd64.deb
sudo apt-get install -y --fix-missing --no-install-recommends dirmngr gnupg-curl
sudo dpkg -i cuda-repo-ubuntu1704_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/7fa2af80.pub
sudo apt-get update
sudo mkdir /usr/lib/nvidia
sudo apt-get install -y --fix-missing --no-install-recommends nvidia-384=384.111-0ubuntu1 libcuda1-384=384.111-0ubuntu1 nvidia-384-dev=384.111-0ubuntu1
sudo apt-get install -y --fix-missing --no-install-recommends cuda-cudart-9-0 cuda-cublas-9-0  cuda-core-9-0  cuda-cublas-dev-9-0 cuda-cudart-dev-9-0
cd /usr/local/ &&  sudo ln -s cuda-9.0 cuda
export PATH="$PATH:/usr/local/cuda/bin"
cd ~

echo "Installing CUDNN"
wget -nc http://developer.download.nvidia.com/compute/redist/cudnn/v7.1.4/cudnn-9.0-linux-x64-v7.1.tgz
tar -xzvf cudnn-9.0-linux-x64-v7.1.tgz
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include/cudnn.h
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/lib64/libcudnn*
sudo nvidia-smi -pm 1

echo "Installing other"
sudo apt-get install -y ninja-build libprotobuf-dev protobuf-compiler python3-pip
sudo pip3 install meson
sudo apt-get install -y g++-6

echo "Installing lc0"
rm -rf lc0 
git clone --recurse-submodules https://github.com/LeelaChessZero/lc0.git
cd lc0 && git checkout $(git tag --list |grep -v rc |tail -1)
CC=clang-6.0 CXX=clang++-6.0 ./build.sh
mv ./build/release/lc0 lc0

echo "Downloading lczero client"
sudo curl -s -L https://github.com/LeelaChessZero/lczero-client/releases/latest | egrep -o '/LeelaChessZero/lczero-client/releases/download/.*/client_linux' | head -n 1 | wget --base=https://github.com/ -i - -O client_linux && chmod +x client_linux

echo "Running Leela Chess Zero"
./client_linux --user googlecloud --password googlecloud --use-test-server
