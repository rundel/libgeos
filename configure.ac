AC_PREREQ(2.61)

AC_INIT([libGEOS], [4.9.3])

AC_LANG(C++)
AC_REQUIRE_CPP
AC_PROG_CXX

AC_ARG_WITH(
  [system-geos],
  AC_HELP_STRING(
    [--with-system-geos=<GEOS prefix>],
    [Supply location (prefix) of GEOS]
  ),
  [SYSTEM_GEOS=$withval],
  [SYSTEM_GEOS=""]
)

GEOS_CPPFLAGS=""
GEOS_LIBS=""


if test x"${SYSTEM_GEOS}" = x""; then
  
  : ${R_HOME=$(R RHOME)}
  if test -z "${R_HOME}"; then
      AC_MSG_ERROR([Could not determine R_HOME.])   
  fi

  R_CPICFLAGS=`${R_HOME}/bin/R CMD config CPICFLAGS`

  GEOS_VERSION="3.6.1"

  
  GEOS_ZIP="geos-${GEOS_VERSION}.tar.bz2"
  GEOS_DIR="geos-${GEOS_VERSION}"
  #GEOS_URL="https://github.com/OSGeo/GEOS.4/archive/${GEOS_VERSION}.zip"
  GEOS_URL="http://download.osgeo.org/geos/${GEOS_ZIP}"

  if ! test -d "${GEOS_DIR}"; then
    AC_MSG_NOTICE([Downloading GEOS (${GEOS_VERSION})])
    ${R_HOME}/bin/Rscript tools/download_zip.R "${GEOS_URL}" "${GEOS_ZIP}" "./"
  fi

  if ! test -d "${GEOS_DIR}"; then
    AC_MSG_ERROR([GEOS download failed.])   
  fi


  cd ${GEOS_DIR}
  echo "Changing to `pwd`"

  INST_DIR=`cd ../inst;pwd`

  AC_MSG_NOTICE([Configuring GEOS])
  sh ./configure --prefix="${INST_DIR}" --enable-static --disable-shared CFLAGS=${R_CPICFLAGS} #> /dev/null 2>&1
  
  AC_MSG_NOTICE([Compiling GEOS])
  make install #> /dev/null 2>&1

  cd ..

  strip -x -S inst/lib/libgeos.a
  strip -x -S inst/lib/libgeos_c.a

  if ! test -e "inst/lib/libgeos_c.a"; then
    AC_MSG_ERROR([Building GEOS failed.])   
  fi

    if ! test -e "inst/lib/libgeos.a"; then
    AC_MSG_ERROR([Building GEOS failed.])   
  fi

  #rm -rf "${GEOS_DIR}"

  GEOS_LIBS="${INST_DIR}/lib/libgeos_c.a ${INST_DIR}/lib/libgeos.a"
  GEOS_CPPFLAGS="-I${INST_DIR}/include"

else # User provided prefix for GEOS

  GEOS_CPPFLAGS="-I${SYSTEM_GEOS}/include"
  CPPFLAGS="${CPPFLAGS} ${GEOS_CPPFLAGS}"
  AC_CHECK_HEADER(
    [GEOS_api.h],
    [],
    [AC_MSG_ERROR([Unable to locate GEOS_api.h])]
  ) 

  if test -d "${SYSTEM_GEOS}/lib64"; then
    GEOS_LIBS="-L${SYSTEM_GEOS}/lib64"
  elif test -d "${SYSTEM_GEOS}/lib"; then
    GEOS_LIBS="-L${SYSTEM_GEOS}/lib"
  else
    GEOS_LIBS="-L${SYSTEM_GEOS}" 
  fi

  LIBS="${LIBS} ${GEOS_LIBS}"
  AC_CHECK_LIB(
    [geos_c], 
    [GEOS_init_r], 
    [GEOS_LIBS="${GEOS_LIBS} -lgeos_c"], 
    [AC_MSG_ERROR([Unable to locate libgeos_c])]
  )

fi

AC_SUBST([PKG_CPPFLAGS],["${PKG_CPPFLAGS} ${GEOS_CPPFLAGS}"])
AC_SUBST([PKG_LIBS],["${PKG_LIBS} ${GEOS_LIBS}"])
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
