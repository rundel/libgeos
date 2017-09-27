AC_PREREQ(2.61)

AC_INIT([libgeos], [0.1.0])

R_HOME="`R RHOME`"
if test -z "${R_HOME}"; then
  AC_MSG_ERROR([Could not determine R_HOME.])
fi

CC="`${R_HOME}/bin/R CMD config CC`"
CXX="`${R_HOME}/bin/R CMD config CXX`"


sysname="$(${R_HOME}/bin/Rscript -e "cat(Sys.info()[['sysname']])")"

if test x"${sysname}" = x"Linux"; then
  platform="linux"
elif test x"${sysname}" = x"Darwin"; then
  platform="mac"
else
  platform="unknown"
fi

AC_MSG_NOTICE([System name: ${sysname}])
AC_MSG_NOTICE([Platform: ${platform}])

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

if test x"${with_system_geos}" = x"no" ; then
  GEOS_CONFIG=no
elif test x"${with_system_geos}" = x"yes" -o x"${with_system_geos}" = x""; then 
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

  GEOS_LIBS="`${GEOS_CONFIG} --ldflags` -lgeos -lgeos_c"
  GEOS_CPPFLAGS="`${GEOS_CONFIG} --cflags`"
  
else

  if test x"$with_system_geos" != x"no" ; then
    AC_MSG_NOTICE([Unable to find geos-config, building local static libraries.]) 
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
      --disable-python --disable-ruby > /dev/null 2>&1
  else
    sh ./configure --prefix="${INST_DIR}"   \ 
      --enable-static --disable-shared      \
      --disable-python --disable-ruby
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
  
  #GEOS_LIBS="${INST_DIR}/lib/libgeos.a ${INST_DIR}/lib/libgeos_c.a"
  #GEOS_CPPFLAGS="-I${INST_DIR}/include"
  
  GEOS_LIBS="-L${INST_DIR}/lib/ -lgeos -lgeos_c"
  GEOS_CPPFLAGS="-I${INST_DIR}/include"
  
  if test x"${platform}" = x"mac"; then
    GEOS_LIBS="$GEOS_LIBS -lc++"
  fi
fi


CPPFLAGS="${GEOS_CPPFLAGS}"
LIBS="${GEOS_LIBS}"

### Test libgeos_c

AC_LANG_PUSH([C])

AC_CHECK_HEADER(
  [geos_c.h],
  [],
  [AC_MSG_ERROR([Unable to locate geos_c.h header])]
) 

AC_CHECK_LIB(
  [geos_c], 
  [GEOSversion], 
  [], 
  [AC_MSG_ERROR([Unable to locate libgeos_c])]
)

AC_LANG_POP([C])

### Test libgeos

AC_LANG_PUSH([C++])

AC_CHECK_HEADER(
  [geos.h],
  [],
  [AC_MSG_ERROR([Unable to locate geos.h header])]
) 

AC_LANG_POP([C++])


### Build Makefile

AC_MSG_NOTICE([GEOS_CPPFLAGS: ${GEOS_CPPFLAGS}])
AC_MSG_NOTICE([GEOS_LIBS: ${GEOS_LIBS}])
AC_MSG_NOTICE([GEOS_CONFIG: ${GEOS_CONFIG}])

AC_SUBST([PKG_CPPFLAGS],["${GEOS_CPPFLAGS}"])
AC_SUBST([PKG_LIBS],["${GEOS_LIBS}"])
AC_SUBST([GEOS_CONFIG],["${GEOS_CONFIG}"])
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT

