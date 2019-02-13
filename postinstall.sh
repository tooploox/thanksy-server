#!/bin/sh

set -x

cd ./node_modules/thanksy-webapp
npm install
pwd
ls -1 ./node_modules
npm run build
cp -R dist/* ../../public/
cd ../..
ls -1 public
