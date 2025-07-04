# Use the official Python 3.12 image as the base
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
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
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y

# Install required packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    gcc \
    g++ \
    curl \
    unzip \
    wget \
    python3.11 \
    openjdk-11-jdk
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

RUN apt install -y make graphviz git cmake libcgal-dev

RUN apt-get update && apt-get install -y \
    curl \
    openjdk-11-jdk

# Install CUDA toolkit
RUN wget --quiet https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
RUN mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget --quiet https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu2404-12-8-local_12.8.1-570.124.06-1_amd64.deb
RUN cp /var/cuda-repo-ubuntu2404-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
RUN apt-get update && \
    apt-get -y install cuda-toolkit-12-8

# Set environment variables for CUDA
ENV PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

# Install Jupyter
RUN python3.11 -m pip install --no-cache-dir jupyter

# Install Scala and Almond
RUN curl -Lo coursier https://git.io/coursier-cli && \
    chmod +x coursier && \
    ./coursier bootstrap almond:0.13.14 --scala 2.13 -o almond && \
    ./almond --install

# Install requirements.txt
COPY requirements.txt /main/requirements.txt
RUN python3.11 -m pip install setuptools
RUN python3.11 -m pip install -r /main/requirements.txt
RUN rm -rf /usr/bin/python3.10
RUN update-alternatives --remove python /usr/bin/python3.10

# Create symlinks for python and pip
RUN ln -s /usr/bin/python3.11 /usr/bin/python && \
    ln -s /usr/local/bin/pip /usr/bin/pip

# Expose the port for JupyterLab
EXPOSE 8888

# Command to launch JupyterLab
CMD ["jupyter-lab", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
