#' 
#' @export
geos_prefix = function()
{
  dirname(system.file(".", package = "libgeos"))
}

#' 
#' @export
geos_cflags = function()
{
  paste0("-I",geos_includes())
}

#'
#' @export
geos_includes = function()
{
  paste0(geos_prefix(),"/include")
}

#'
#' @export
geos_libs = function()
{
  geos_static_clibs()
}

#'
#' @export
geos_clibs = function()
{
  geos_static_clibs()
}

#'
#' @export
geos_cclibs = function()
{
  geos_static_cclibs()
}

#'
#' @export
geos_static_clibs = function()
{
  paste0(geos_ldflags(), " -lgeos_c")
}

#'
#' @export
geos_static_cclibs = function()
{
  paste0(geos_ldflags(), " -lgeos")
}

#'
#' @export
geos_ldflags = function()
{
  os = Sys.info()["sysname"]
  switch(
    os, 
    { stop("Unknown os: ", os) },
    Linux   = { paste0("-L", geos_prefix(), "/lib") },
    Darwin  = { paste0("-lc++ -L", geos_prefix(), "/lib") },
    Windows = { paste0("-L", geos_prefix(), "/lib") }
  )
  
}

