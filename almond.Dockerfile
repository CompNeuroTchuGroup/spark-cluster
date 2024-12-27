FROM almondsh/almond:latest as almond

USER root

RUN apt update
RUN apt install -y make wget

RUN wget https://gitlab.com/api/v4/projects/4207231/packages/generic/graphviz-releases/12.2.1/graphviz-12.2.1.tar.gz
RUN tar -xvf graphviz-12.2.1.tar.gz
RUN cd graphviz-12.2.1 && ./configure && make && make install