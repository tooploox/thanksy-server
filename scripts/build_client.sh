#!/bin/sh

ZIP_FILE=thanksy-client-ts.zip
REPO=thanksy-client-ts
BRANCH=master

set -x
wget -O $ZIP_FILE https://github.com/tooploox/$REPO/archive/$BRANCH.zip
unzip $ZIP_FILE
rm $ZIP_FILE
cd $REPO-$BRANCH
npm install --production
npm run build
yes | cp -Rf dist/* ../public/
cd ..
rm -rf $REPO-$BRANCH
