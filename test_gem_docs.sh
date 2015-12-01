#!/bin/sh

TMP_DIR="yard_gem_docs"

rm -rf $TMP_DIR
gem build nmea_plus.gemspec
mkdir $TMP_DIR
cd $TMP_DIR
GEMFILE=$(ls -Art ../*.gem | tail -n 1)
tar -zxvf $GEMFILE
tar -zxvf data.tar.gz
yard server
