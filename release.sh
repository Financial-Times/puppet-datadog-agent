#!/bin/bash
rake 

if [[ -z "$1" ]]; then
    echo "Usage: <version> <module_path>"
    exit 2
fi

pushd $2
MODULEFULLPATH=$(pwd)
echo "Full path: $MODULEFULLPATH"

if [[ ! -f ${MODULEFULLPATH}/Modulefile ]]
then
  echo "Error: cannot find Modulefile in $MODULEFULLPATH"
  exit 1
fi

VERSION=$1
echo "Building version $VERSION"
sed -i -e "s/^version '.*'/version '$VERSION'/g" Modulefile

echo "====DIAGNOSIS====="
echo "--- dir $(pwd)"
ls -lt
echo "--- Modulefile"
cat Modulefile
echo "====/DIAGNOSIS===="

echo "Publishing $VERSION"

/usr/local/bin/forge-admin.py -p -s ${MODULEFULLPATH}

echo "Cleaning up"

git checkout Modulefile
popd

rm -rf ${MODULEFULLPATH}/pkg
