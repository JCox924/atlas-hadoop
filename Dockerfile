FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop-3.3.2
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# 1. Install required OS packages, Python2, Python3, and pip
RUN apt-get update && \
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
      python2-pip \
      python3 \
      python3-dev \
      python3-pip && \
    ln -sf /usr/bin/python2.7 /usr/bin/python && \
    ln -sf /usr/bin/python3 /usr/bin/python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Install Snakebite on both Python2 and Python3
RUN pip2 install snakebite && \
    pip3 install snakebite-py3

# 3. Install Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz && \
    tar -xzvf hadoop-3.3.2.tar.gz -C /opt/ && \
    rm hadoop-3.3.2.tar.gz

# 4. Configure SSH (passwordless for localhost)
RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# 5. Configure Hadoop environment variables
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> /root/.bashrc && \
    echo "export PATH=\$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin" >> /root/.bashrc

# 6. Copy your Hadoop XML configs (pseudo‑distributed mode)
COPY core-site.xml   ${HADOOP_HOME}/etc/hadoop/core-site.xml
COPY hdfs-site.xml   ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
COPY yarn-site.xml   ${HADOOP_HOME}/etc/hadoop/yarn-site.xml

# 7. Format namenode on build
RUN ${HADOOP_HOME}/bin/hdfs namenode -format -nonInteractive

# 8. Default to Bash
WORKDIR /root
CMD ["/bin/bash"]
