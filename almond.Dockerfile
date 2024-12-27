FROM almondsh/almond:latest as almond

USER root

RUN apt update
RUN apt install -y make graphviz

COPY reuirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt