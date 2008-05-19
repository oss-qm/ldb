#!/bin/bash
REFSPEC=$1
GIT_URL=$2
shift 2

if [ -z "$GIT_URL" ]; then
	GIT_URL=git://git.samba.org/samba.git
fi

LDBTMP=$TMPDIR/$RANDOM.ldb.git
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )
git clone --depth 1 -l $GIT_URL $LDBTMP
if [ ! -z "$REFSPEC" ]; then
	pushd $LDBTMP
	git checkout $REFSPEC
	popd
fi

mv $LDBTMP/source/lib/ldb "ldb-$version"
mv $LDBTMP/source/lib/replace "ldb-$version/libreplace"
mv $LDBTMP/source/lib/tdb "ldb-$version/libtdb"
mv $LDBTMP/source/lib/talloc "ldb-$version/libtalloc"
rm -rf $LDBTMP
pushd "ldb-$version" && ./autogen.sh && popd
tar cvz "ldb-$version" > "ldb_$version.orig.tar.gz"
rm -rf "ldb-$version"
