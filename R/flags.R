cxxflags = function()
{
  cat(
    paste0( '-I"', system.file( "include", package = "libgeos" ), '"' ) 
  )
}

ldflags = function()
{
  cat(
    paste0( '-L"', system.file( "libs", package = "libgeos" ), '" -llibgeos' ) 
  )
}