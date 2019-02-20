#!/bin/sh

set -x

cd ./node_modules/thanksy-webapp
npm install --production
pwd
ls -1 ./node_modules
npm run build
yes | cp -Rf dist/* ../../public/
cd ../..
ls -1 public
