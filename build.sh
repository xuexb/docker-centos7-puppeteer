#!/bin/bash

source $HOME/.bashrc

cd $WORK_DIR

if [ "$USER_TAOBAO_MIRRORS" == "true" ]; then
  export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
  cp -r $PUPPETEER_DIR/.npmrc $HOME
fi

# 安装 Node.js
nvm install $NODEJS_VERSION

if [ -f "$WORK_DIR/yarn.lock" ]; then
    yarn install && yarn run $BUILD_CMD
else
    npm install && npm run $BUILD_CMD
fi

if [ -d "$WORK_DIR/dist" ]; then
    cp -r $WORK_DIR/dist/. $DIST_DIR
fi
