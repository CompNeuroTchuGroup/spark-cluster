FROM almondsh/almond:latest as almond

USER root

RUN apt update
RUN apt install -y make graphviz