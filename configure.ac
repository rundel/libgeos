AC_PREREQ(2.61)

AC_INIT([libgeos], [0.1.0])

AC_ARG_ENABLE(
  [verbose],
  AC_HELP_STRING(
    [--enable-verbose],
    [Enable verbose output of build]
  ),
  [VERBOSE="yes"],
  [VERBOSE="no"]
)

AC_ARG_WITH(
  [system_geos],
  AS_HELP_STRING(
    [--with-system-geos[=ARG]],
    [Use existing system GEOS (ARG=yes, no or geos-config path)]
  ),
  [],
  [with_system_geos=yes]
)

GEOS_CPPFLAGS=""
GEOS_LIBS=""

if test x"$with_system_geos" = x"no" ; then

  GEOS_CONFIG=no

elif test x"${with_system_geos}" == x"yes" -o x"${with_system_geos}" = x""; then 

  AC_PATH_PROG(GEOS_CONFIG, geos-config, no)

else

  AC_CHECK_PROG(
    [GEOS_CONFIG],
    [`basename "${with_system_geos}"`],
    [${with_system_geos}],
    [no],
    [`dirname "${with_system_geos}"`]
  )

fi

if test x"${GEOS_CONFIG}" != x"no"; then
  
  AC_MSG_NOTICE([Found geos-config at ${GEOS_CONFIG}])

  GEOS_LIBS="`${GEOS_CONFIG} --ldflags` -lgeos `${GEOS_CONFIG} --ldflags` -lgeos_c"
  GEOS_CFLAGS="`${GEOS_CONFIG} --cflags`"
  
else

  if test x"$with_system_geos" != x"no" ; then
    AC_MSG_NOTICE([Unable to find geos-config, building local static libraries.]) 
  fi

  : ${R_HOME=$(R RHOME)}
  if test -z "${R_HOME}"; then
      AC_MSG_ERROR([Could not determine R_HOME.])   
  fi

  GEOS_VERSION=$(cat geos_version)
  GEOS_DIR="geos-${GEOS_VERSION}"
  
  if ! test -d "${GEOS_DIR}"; then
    AC_MSG_ERROR([GEOS source directory can't be found.])   
  fi
  
  # Build GEOS
  cd ${GEOS_DIR}

  INST_DIR=`cd ../inst;pwd`

  AC_MSG_NOTICE([Configuring geos])
  if test x"${VERBOSE}" = x"no"; then
    sh ./configure --prefix="${INST_DIR}"   \
      --enable-static --disable-shared      \
      --disable-python --disable-ruby       \
      CFLAGS="${R_CFLAGS}" CXXFLAGS="${R_CXXFLAGS}" > /dev/null 2>&1
  else
    sh ./configure --prefix="${INST_DIR}"   \
      --enable-static --disable-shared      \
      CFLAGS="${R_CFLAGS}" CXXFLAGS="${R_CXXFLAGS}"
  fi
    
  AC_MSG_NOTICE([Compiling geos])
  if test x"${VERBOSE}" = x"no"; then
    make install > /dev/null 2>&1
  else
    make install
  fi

  cd ..

  if ! test -e "inst/lib/libgeos.a" -a -e "inst/lib/libgeos_c.a"; then
    AC_MSG_ERROR([Building geos failed.])   
  fi
  
  strip -x -S inst/lib/libgeos.a > /dev/null 2>&1
  strip -x -S inst/lib/libgeos_c.a > /dev/null 2>&1

  rm -rf inst/bin
  
  GEOS_LIBS="${INST_DIR}/lib/libgeos.a ${INST_DIR}/lib/libgeos_c.a"
  GEOS_CFLAGS="-I${INST_DIR}/include"
  
  GEOS_LIBS="-L${INST_DIR}/lib/ -lgeos -lgeos_c"
  GEOS_CFLAGS="-I${INST_DIR}/include"
fi


# CFLAGS="${CFLAGS} ${GEOS_CFLAGS}"
# AC_CHECK_HEADER(
#   [geos.h],
#   [],
#   [AC_MSG_NOTICE([Unable to locate geos.h header])]
# ) 
# 
# AC_CHECK_HEADER(
#   [geos_c.h],
#   [],
#   [AC_MSG_NOTICE([Unable to locate geos_c.h header])]
# ) 
# 
# 
# LIBS="${LIBS} ${GEOS_LIBS}"
# AC_CHECK_LIB(
#   [geos_c], 
#   [GEOSversion], 
#   [], 
#   [AC_MSG_NOTICE([Unable to locate libgeos_c])]
# )
# 
# AC_CHECK_LIB(
#   [geos], 
#   [geos::geom::geosversion], 
#   [], 
#   [AC_MSG_NOTICE([Unable to locate libgeos])]
# )


AC_MSG_NOTICE([GEOS_CFLAGS: ${GEOS_CFLAGS}])
AC_MSG_NOTICE([GEOS_LIBS: ${GEOS_LIBS}])
AC_MSG_NOTICE([GEOS_CONFIG: ${GEOS_CONFIG}])

AC_SUBST([PKG_CPPFLAGS],["${GEOS_CFLAGS}"])
AC_SUBST([PKG_LIBS],["${GEOS_LIBS}"])
AC_SUBST([GEOS_CONFIG],["${GEOS_CONFIG}"])
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT

