#!/bin/bash
#@author jimin.huang@benload.com

set -e

THIS_SCRIPT=$(realpath $(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)/$(basename ${BASH_SOURCE:-$0}))
#automatic detection TOPDIR
SCRIPT_DIR=$(dirname $(realpath ${THIS_SCRIPT}))

mkdir -p /etc/profile.d/
if [ -f /etc/profile.d/env.sh ]; then
    echo "/cfg/env.txt mounted"
    set -a # automatically export all variables
    . /etc/profile.d/env.sh
    set +a
    echo "import env vars from /etc/profile.d/env.sh done"
else
    echo "/etc/profile.d/env.sh not found!"
fi

K8S_NS_FILE="/var/run/secrets/kubernetes.io/serviceaccount/namespace"
if [ -f ${K8S_NS_FILE} ];then
    K8S_NS=`head -n 1 ${K8S_NS_FILE}`
    SVC_NAME=`echo ${K8S_NS}.${HOSTNAME} | rev | cut -d'-'  -f 3- | rev`
    MY_K8S_NS=${K8S_NS}
    MY_K8S_SVC_NAME=$(echo ${SVC_NAME} | awk -F. '{print $NF}')
    echo "SVC_NAME=${SVC_NAME}"
    echo "MY_K8S_NS=${MY_K8S_NS}"
    echo "MY_K8S_SVC_NAME=${MY_K8S_SVC_NAME}"
    export MY_K8S_NS
    export MY_K8S_SVC_NAME
fi



RUNNER_TYPE="aio"
if [ $# -gt 0 ];then
    RUNNER_TYPE=$1
fi

USAGE="
  usage:
  
  $(basename $(realpath $0)) tunasync
  $(basename $(realpath $0)) nginx
"
echo "start ${RUNNER_TYPE}"

case ${RUNNER_TYPE} in
    ts-manager)
        exec tunasync manager --config /home/ts/.config/manager.conf
        ;;
    ts-worker)
        exec tunasync worker --config /home/ts/.config/manager.conf
        ;;
    nginx)
        exec nginx -g 'daemon off;'
        ;;
    aio)
    # all in one
        nginx

        ;;
         
    *)
        echo "unkown ${RUNNER_TYPE}"
        exec tail -f /dev/null
        ;;
esac
