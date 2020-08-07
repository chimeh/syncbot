#!/bin/bash
THIS_SCRIPT=$(realpath $(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)/$(basename ${BASH_SOURCE:-$0}))
#automatic detection TOPDIR
SCRIPT_DIR=$(dirname $(realpath ${THIS_SCRIPT}))

source ${SCRIPT_DIR}/0helper-document.sh

RUNIT_VER=2.1.2
yum install -y glibc-static
# runit is not available in ubi or CentOS repos so build it.
wget -P /tmp http://smarden.org/runit/runit-${RUNIT_VER}.tar.gz && \
    gunzip /tmp/runit-${RUNIT_VER}.tar.gz && \
    tar -xpf /tmp/runit-${RUNIT_VER}.tar -C /tmp && \
    cd /tmp/admin/runit-${RUNIT_VER}/ && \
    package/install
/bin/cp -rf /tmp/admin/runit-${RUNIT_VER}/command/* /usr/local/bin/
/bin/rm -rf /tmp/*

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
cmd_test=(
  runit
  runsvchdir
  runsvdir
)
for cmd in ${cmd_test[*]}; do
  if ! command -v $cmd; then
    echo "$cmd was not installed"
  fi
done
# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "init:"
DocumentInstalledItemIndent "runit ${RUNIT_VER}"
