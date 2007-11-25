#!/bin/sh
# Build a source tarball for ldb

samba_repos=svn://svn.samba.org/samba/
version=$( dpkg-parsechangelog -l`dirname $0`/changelog | sed -n 's/^Version: \(.*:\|\)//p' | sed 's/-[0-9.]\+$//' )

if echo $version | grep svn > /dev/null; then
	# SVN Snapshot
	revno=`echo $version | sed 's/^[0-9.]\+~svn//'`
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/ldb ldb-$version
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/replace ldb-$version/libreplace
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/talloc ldb-$version/libtalloc
	svn export -r$revno $samba_repos/branches/SAMBA_4_0/source/lib/tdb ldb-$version/libtdb
else
	# Release
	svn export $samba_repos/tags/LDB_`echo $version | sed 's/\./_/g'` ldb-$version
fi

cd ldb-$version && ./autogen.sh && cd ..
tar cvz ldb-$version > ldb_$version.orig.tar.gz
