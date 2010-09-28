#!/bin/bash

if [ -z "$SAMBA_GIT_URL" ]; then
	SAMBA_GIT_URL=git://git.samba.org/samba.git
fi

LDBTMP=`mktemp -d`
git clone --depth 1 $SAMBA_GIT_URL $LDBTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $LDBTMP
	git checkout $REFSPEC || exit 1
	popd
fi
pushd $LDBTMP/source4/lib/ldb
./configure
make dist
popd
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
mv $LDBTMP/source4/lib/ldb/ldb-*.tar.gz ldb_$version.orig.tar.gz
rm -rf $LDBTMP
