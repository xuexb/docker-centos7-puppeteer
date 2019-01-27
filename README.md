# docker-centos7-prerender
支持 Node.js + Yarn + Puppeteer 的 CentOS7 环境

## 使用

### 直接编译产出

```bash
docker run \
    --rm \
    -v /source/path:/root/src \
    -v /output/path:/root/dist \
    xuexb/docker-centos7-prerender:latest
```

以上脚本流程：

1. 根据 `USER_TAOBAO_MIRRORS` 变量决定是否使用淘宝源，包括：
    - nvm 安装 Node.js 时的镜像
    - `$HOME/.npmrc` 中的默认源配置，见：[@xuexb/docker-centos7-prerender/.npmrc](https://github.com/xuexb/docker-centos7-prerender/blob/master/.npmrc)
2. 根据 `NODEJS_VERSION` 变量使用 nvm 安装对应的 Node.js
4. 判断源目录中（`/root/src`）是否存在 `yarn.lock`：
    - 如果有，则使用 `yarn install && yarn run $BUILD_CMD`
    - 如果没有，则使用 `npm install && npm run $BUILD_CMD`
5. 如果源目录中存在产出目录（`/root/src/dist`），则**复制**到产出目录中（`/root/dist`）

### 直接进入镜像自定义编译

```bash
docker run \
    -it \
    --rm \
    -v /source/path:/root/src \
    -v /output/path:/root/dist \
    xuexb/docker-centos7-prerender:latest \
    /bin/bash
```

### Dockerfile

```bash
# 编译项目
FROM xuexb/docker-centos7-prerender:latest as builder

# 复制源文件
COPY . /root/src

# 工作目录
WORKDIR /root/src

RUN cp -r $PUPPETEER_DIR/.npmrc $HOME

# 编译
RUN \. "/root/.bashrc" \
    && nvm install 10.0.0 \
    && yarn \
    && yarn build

# 复制产出文件到产出目录
RUN cp -r /root/src/dist/. /root/dist

# 产出镜像
FROM nginx:alpine
COPY --from=builder /root/dist /usr/share/nginx/html
```

## 变量

| 变量名称 | 默认值 | 说明 |
| --- | --- | --- |
| `USER_TAOBAO_MIRRORS` | `true` | 是否使用淘宝源安装 Node.js 和使用淘宝源 `.npmrc` |
| `NODEJS_VERSION` | `8.0.0` | 安装的 Node.js 版本 |
| `BUILD_CMD` | `build` | 编译命令，如果 `/root/src` 中有 `yarn.lock` 则使用 `yarn run $BUILD_CMD` ，否则使用 `npm run $BUILD_CMD` |

## 内置工具

- vim
- wget
- nvm
    - Node.js 8.0.0
    - Node.js 9.0.0
    - Node.js 10.0.0
    - Node.js 11.0.0
- Yarn 1.13.0
