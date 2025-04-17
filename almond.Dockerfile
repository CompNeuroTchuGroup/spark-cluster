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
RUN apt install -y make graphviz gcc

# Copy requirements and install Python packages
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
