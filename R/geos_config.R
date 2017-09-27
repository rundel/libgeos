check_geos_config_path = function()
{
  file = system.file("geos_config_path", package = "libgeos")
  if (!file.exists(file)) 
    return(FALSE)
  
  path = readLines(file)
  if (!file.exists(path)) 
    return(FALSE)
  
  return(TRUE)
}

get_geos_config_path = function()
{
  stopifnot(check_geos_config_path())
  
  readLines(system.file("geos_config_path", package = "libgeos"))
}


geos_prefix = function()
{
  if (check_geos_config_path())
    return( system2(get_geos_config_path(), "--prefix", stdout = TRUE) )
  else
    dirname(system.file(".", package = "libgeos"))
}

geos_cflags = function()
{
  if (check_geos_config_path())
    system2(get_geos_config_path(), "--cflags", stdout = TRUE)
  else
    paste0("-I",geos_includes())
}

geos_includes = function()
{
  if (check_geos_config_path())
    system2(get_geos_config_path(), "--includes", stdout = TRUE)
  else
    paste0(geos_prefix(),"/include")
}



geos_libs = function()
{
  if (check_geos_config_path()) {
    system2(get_geos_config_path(), "--libs", stdout = TRUE)
  } else {
    os = Sys.info()["sysname"]
    switch(
      os, 
      { stop("Unknown os: ", os) },
      Linux   = { paste0(geos_ldflags(), " -lgeos -lgeos_c") },
      Darwin  = { paste0(geos_ldflags(), " -lgeos -lgeos_c -lc++") },
      Windows = { paste0(geos_ldflags(), " -lgeos -lgeos_c") }
    )
  }
}

geos_clibs = function()
{
  if (check_geos_config_path()) {
    system2(get_geos_config_path(), "--clibs", stdout = TRUE)
  } else {
    os = Sys.info()["sysname"]
    switch(
      os, 
      { stop("Unknown os: ", os) },
      Linux   = { paste0(geos_ldflags(), " -lgeos -lgeos_c") },
      Darwin  = { paste0(geos_ldflags(), " -lgeos -lgeos_c -lc++") },
      Windows = { paste0(geos_ldflags(), " -lgeos -lgeos_c") }
    )
  }
}

geos_cclibs = function()
{
  if (check_geos_config_path()) {
    system2(get_geos_config_path(), "--cclibs", stdout = TRUE)
  } else {
    os = Sys.info()["sysname"]
    switch(
      os, 
      { stop("Unknown os: ", os) },
      Linux   = { paste0(geos_ldflags(), " -lgeos") },
      Darwin  = { paste0(geos_ldflags(), " -lgeos -lc++") },
      Windows = { paste0(geos_ldflags(), " -lgeos") }
    )
  } 
}

geos_static_clibs = function()
{
  if (check_geos_config_path()) {
    system2(get_geos_config_path(), "--static-clibs", stdout = TRUE)
  } else {
    os = Sys.info()["sysname"]
    switch(
      os, 
      { stop("Unknown os: ", os) },
      Linux   = { paste0(geos_ldflags(), " -lgeos -lgeos_c") },
      Darwin  = { paste0(geos_ldflags(), " -lgeos -lgeos_c -lc++") },
      Windows = { paste0(geos_ldflags(), " -lgeos -lgeos_c") }
    )
  }
}

geos_static_cclibs = function()
{
  if (check_geos_config_path()) {
    system2(get_geos_config_path(), "--static-cclibs", stdout = TRUE)
  } else {
    os = Sys.info()["sysname"]
    switch(
      os, 
      { stop("Unknown os: ", os) },
      Linux   = { paste0(geos_ldflags(), " -lgeos") },
      Darwin  = { paste0(geos_ldflags(), " -lgeos -lc++") },
      Windows = { paste0(geos_ldflags(), " -lgeos") }
    )
  }  
}

geos_ldflags = function()
{
  if (check_geos_config_path()) {
    system2(get_geos_config_path(), "--ldflags", stdout = TRUE)
  } else {
    paste0("-L", geos_prefix(), "/lib")
  }
}

