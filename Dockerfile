#FROM debian:stretch
# i could not get systemd to run in debian :(

FROM centos:7


#RUN apt-get update && apt-get install -y asterisk \
#    vim-tiny \
#    less 
#RUN apt-get install -y procps \
#    systemd \
#    initscripts \
#    systemd-sysv
#RUN apt-get install -y strace

RUN yum -y  install asterisk \
    vim-tiny \
    less 
RUN yum -y  install procps \
    systemd \
    initscripts \
    systemd-sysv
RUN yum -y  install strace

### linode asterisk on centos 7 guide
# https://www.linode.com/docs/applications/voip/install-asterisk-on-centos-7/
RUN yum install -y epel-release gcc-c++ ncurses-devel libxml2-devel wget \
    openssl-devel newt-devel kernel-devel-`uname -r` sqlite-devel \
    libuuid-devel gtk2-devel jansson-devel binutils-devel \
    bzip2 patch libedit libedit-devel

WORKDIR /root

RUN mkdir build-asterisk
RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz
RUN cd build-asterisk ; tar -xavf ../asterisk-16-current.tar.gz

# noticed i needed them
RUN yum -y install make file

RUN cd build-asterisk/as* ; ./configure --libdir=/usr/lib64 --with-jansson-bundled
RUN cd build-asterisk/as* ; make -j `nproc`
RUN  cd build-asterisk/as* ; make install && make samples && make config

RUN yum install -y net-tools

#######

ADD entry.sh /root/
    
#CMD [ "tail", "-f", "/dev/null" ]
#CMD [ "/sbin/init" ]
CMD [ "/root/entry.sh" ]
