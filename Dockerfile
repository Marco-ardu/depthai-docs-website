FROM ubuntu:20.04

USER root

ENV TZ="America/New_York"
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install python3 git python3-pip -y \
    && apt-get clean 

RUN python3 -m pip install -U pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && python3 -m pip install sphinx sphinx-rtd-theme requests -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN useradd -ms /bin/bash ubuntu
USER ubuntu


WORKDIR /build



