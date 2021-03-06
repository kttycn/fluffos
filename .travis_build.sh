#!/bin/sh
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update -qq
sudo apt-get install -qq autoconf
sudo apt-get install -qq gcc-4.8 g++-4.8
sudo apt-get install -qq bison

if [ "$BUILD" = "i386" ]; then
  sudo apt-get remove libevent-dev libevent* libssl-dev

  sudo apt-get install g++-multilib g++-4.8-multilib
  sudo apt-get --no-install-recommends install valgrind:i386

  sudo apt-get install libevent-2.0-5:i386
  sudo apt-get install libevent-dev:i386
  sudo apt-get --no-install-recommends install libz-dev:i386
else
  sudo apt-get install valgrind
  sudo apt-get install libevent-dev libmysqlclient-dev libsqlite3-dev libpq-dev libz-dev libssl-dev libpcre3-dev
fi

cd src && ./autogen.sh && cp local_options.$CONFIG local_options && ./build.FluffOS $TYPE && make -j 4 && cd testsuite && valgrind --malloc-fill=0x75 --free-fill=0x73 --track-origins=yes --leak-check=full ../driver etc/config.test -ftest -d
