############################################################
# Dockerfile to compile 3DRepoBouncer
# Based on Ubuntu 14.04 x64
############################################################

FROM ubuntu:14.04
MAINTAINER connor@jenca.io

# Install Dependencies

RUN apt-get -y install software-properties-common && \
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get -y update && apt-get -y install \
	g++-4.9 \
	git \
	scons \
	cmake \
	libboost1.55-all-dev

# Install MongoDB Cxx Driver

RUN cd ~ && \
	git clone https://github.com/mongodb/mongo-cxx-driver
RUN cd ~/mongo-cxx-driver && \
	git checkout legacy && \
	scons --prefix=/usr/local install

# Install ASSIMP

RUN cd /usr/local/ && \
	git clone https://github.com/3drepo/assimp
RUN cd /usr/local/assimp/ && \
	git checkout ISSUE_4 && \
	mkdir build
RUN cd /usr/local/assimp/build && \
	cmake ../

# Make sure latest compiler version is used

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

################## BEGIN COMPILATION ######################

# Compile 3Drepo core

RUN cd ~ && \
	git clone https://github.com/3drepo/3drepobouncer.git
RUN cd ~/3drepobouncer/ && \
	python updateSources.py && \
	mkdir build
RUN cd ~/3drepobouncer/build/ && \
	cmake ../ && \
	make

##################### END COMPILATION #####################