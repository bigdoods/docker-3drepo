############################################################
# Dockerfile to compile 3DRepoBouncer
# Based on Ubuntu 14.04 x64
############################################################

FROM ubuntu:14.04
MAINTAINER connoralexander@bimscript.com

# Install Dependencies

RUN apt-get -y install software-properties-common

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get -y update && apt-get -y install \
	g++-4.9 \
	git \
	scons \
	cmake \
	libboost1.55-all-dev \

# Install MongoDB Cxx Driver

RUN cd ~
RUN git clone https://github.com/mongodb/mongo-cxx-driver
RUN cd mongo-cxx-driver
RUN git checkout legacy
RUN scons --prefix=/usr/local install

# Install ASSIMP

RUN cd /usr/local/
RUN git clone https://github.com/3drepo/assimp
RUN cd assimp
RUN git checkout multipart
RUN mkdir build
RUN cd build
RUN cmake ../
RUN make install

# Make sure latest compiler version is used

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

################## BEGIN COMPILATION ######################

# Compile 3Drepo core

RUN cd ~
RUN git clone https://github.com/3drepo/3drepobouncer.git
RUN cd 3drepobouncer
RUN python updateSources.py
RUN mkdir build
RUN cd build
RUN cmake ../
RUN make install

##################### END COMPILATION #####################