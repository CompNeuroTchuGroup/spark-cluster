FROM almondsh/almond:latest AS almond

USER root

RUN apt update
RUN apt install -y make graphviz

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt