FROM almondsh/almond:latest AS almond

USER root

# Install lsb-release to get the codename
RUN apt update && apt install -y lsb-release

# Get the codename and update the APT sources list
RUN CODENAME=$(lsb_release -cs) && \
    echo "deb http://archive.ubuntu.com/ubuntu/ $CODENAME main universe" > /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ $CODENAME-updates main universe" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ $CODENAME-security main universe" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ $CODENAME multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ $CODENAME-updates multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ $CODENAME-security multiverse" >> /etc/apt/sources.list

# Update package lists
RUN apt update

# Install required packages
RUN apt install -y make graphviz git cmake libcgal-dev

# Install specific version of GCC and G++
RUN apt install -y gcc g++

# Install CUDA toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin && \
    mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    wget https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb && \
    dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb && \
    cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && \
    apt-get -y install cuda-toolkit-12-8

# Set environment variables for CUDA
ENV PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
