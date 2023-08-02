FROM amazonlinux:2.0.20230307.0

RUN yum -y install git \
    python37 \
    python37-pip \
    zip \
    && yum clean all

RUN python3 -m pip install --upgrade pip