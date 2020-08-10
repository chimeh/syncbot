#!/bin/bash
THIS_SCRIPT=$(realpath $(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)/$(basename ${BASH_SOURCE:-$0}))
#automatic detection TOPDIR
SCRIPT_DIR=$(dirname $(realpath ${THIS_SCRIPT}))
source ${SCRIPT_DIR}/0helper-document.sh
source ${SCRIPT_DIR}/0helper-cloud.sh

#https://github.com/tuna/tunasync/releases/tag
TUNASYNC_TAG=v0.6.6


if ! command -v go; then
    echo " go must install first"
    exit 1
fi
if runon_cn;then
  echo "on tencent cloud, use tencent mirror"
  export GOPROXY="http://mirrors.cloud.tencent.com/go/,https://goproxy.cn,direct"
fi

set +e
useradd --home-dir /home/ts --create-home --user-group  --shell /bin/bash ts
set -e

TSDIR=/home/ts
mkdir -p ${TSDIR}
cd ${TSDIR}
pip3 install requests
git clone --depth 1 https://github.com/tuna/tunasync-scripts.git ${TSDIR}/tunasync-scripts

ln -sf ${TSDIR}/tunasync-scripts /home/scripts
    
git clone --branch master https://github.com/tuna/tunasync.git ${TSDIR}/tunasync-src
cd ${TSDIR}/tunasync-src
git checkout ${TUNASYNC_TAG}
make
/bin/cp -fv build/* /usr/local/bin/
/bin/rm -rf build/
cd ~



chown -R ts:ts /home/ts


echo "check cmd run ok"
for cmd in  tunasync tunasynctl; do
    if ! command -v $cmd; then
        echo "$cmd was not installed or found on path"
        exit 1
    fi
done


DocumentInstalledItem "tunasync tunasynctl"


