FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    HADOOP_HOME=/opt/hadoop-3.3.2 \
    PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# 1. Install core OS packages + Python2.7 + Python3.9 + setuptools/distutils
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
      openjdk-8-jdk \
      ssh \
      pdsh \
      wget \
      curl \
      nano \
      vim \
      python2.7 \
      python2.7-dev \
      python-setuptools \
      python3.9 \
      python3.9-dev \
      python3.9-distutils && \
    ln -sf /usr/bin/python2.7 /usr/bin/python && \
    ln -sf /usr/bin/python3.9 /usr/bin/python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip2.py && \
    python get-pip2.py && rm get-pip2.py && \
    curl -sSL https://bootstrap.pypa.io/get-pip.py      -o get-pip3.py && \
    python3 get-pip3.py && rm get-pip3.py

RUN python -m pip install snakebite && \
    python3 -m pip install snakebite-py3

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz && \
    tar -xzvf hadoop-3.3.2.tar.gz -C /opt/ && \
    rm hadoop-3.3.2.tar.gz \

RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> /root/.bashrc && \
    echo "export PATH=\$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin" >> /root/.bashrc

COPY core-site.xml   ${HADOOP_HOME}/etc/hadoop/core-site.xml
COPY hdfs-site.xml   ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
COPY yarn-site.xml   ${HADOOP_HOME}/etc/hadoop/yarn-site.xml

RUN ${HADOOP_HOME}/bin/hdfs namenode -format -nonInteractive

WORKDIR /root
CMD ["/bin/bash"]
