FROM centos:7
LABEL MAINTAINER="xuexb <fe.xiaowu@gmail.com>"

USER root

# 设置默认参数
ENV USE_TAOBAO_MIRRORS true
ENV NODEJS_VERSION "8.0.0"
ENV BUILD_CMD build

# 设置常用变量
ENV HOME /root
ENV PUPPETEER_DIR $HOME/.prerender
ENV WORK_DIR $HOME/src
ENV DIST_DIR $HOME/dist

# 创建目录
RUN mkdir -p $PUPPETEER_DIR $WORK_DIR $DIST_DIR

# 设置工作目录
WORKDIR $WORK_DIR

# 复制文件+权限
ADD . $PUPPETEER_DIR
RUN chmod +x $PUPPETEER_DIR/build.sh

# 更换源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN cp $PUPPETEER_DIR/Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo

# # 安装依赖
RUN yum makecache \
    && yum -y update \
    && yum install -y vim git wget \
    && yum install -y pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 \
    && yum install -y ipa-gothic-fonts xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic xorg-x11-fonts-Type1 xorg-x11-fonts-misc

# 安装 nvm
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# 安装常用版本
RUN \. "$HOME/.bashrc" \
    && nvm install 8.0.0 \
    && nvm install 9.0.0 \
    && nvm install 10.0.0 \
    && nvm install 11.0.0

# 安装 yarn
RUN \. "$HOME/.bashrc" \
    && curl -o- -L https://yarnpkg.com/install.sh | bash

# 入口文件
CMD [ "/root/.prerender/build.sh" ]