############################################################
# Dockerfile to compile 3DRepoBouncer
# Based on Ubuntu 14.04 x64
############################################################

FROM ubuntu:14.04
MAINTAINER connoralexander@bimscript.com

# Install Dependencies

RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -y update

RUN apt-get -y install \
	g++-4.9 \									# Compiler v4.9
	git \										# Git
	scons \										# SCons
	cmake \										# CMake
	libboost1.55-all-dev \						# Boost Libraries v1.55+

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

# Install MongoDB Cxx Driver

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

################## BEGIN INSTALLATION ######################

# Compile 3Drepo core

RUN cd ~
RUN git clone https://github.com/3drepo/3drepobouncer.git
RUN cd 3drepobouncer
RUN python updateSources.py
RUN mkdir build
RUN cd build
RUN cmake ../
RUN make

##################### END INSTALLATION #####################

USER 
EXPOSE 
ENTRYPOINT