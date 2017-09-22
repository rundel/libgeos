#!/bin/sh

GEOS_VERSION="3.6.2"

printf ${GEOS_VERSION} > geos_version

GEOS_URL="http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2"
GEOS_DIR="geos-${GEOS_VERSION}"


R_HOME=`R RHOME`
if test -z "${R_HOME}"; then
  echo "Could not determine R_HOME."
  exit1
fi


if ! test -d "${GEOS_DIR}"; then
  echo "Downloading geos v${GEOS_VERSION} from ${GEOS_URL}."
  ${R_HOME}/bin/Rscript tools/download_zip.R "${GEOS_URL}" "./"
fi


cd ${GEOS_DIR}

if test -e "Makefile"; then
  make clean
fi

aclocal
automake
autoconf

cd ..

autoconf