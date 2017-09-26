#include <Rcpp.h>
#include <geos_c.h>
#include <geos.h>

// [[Rcpp::export]]
std::string geos_c_api_version() 
{
  return  std::to_string(GEOS_CAPI_VERSION_MAJOR) + "." +
          std::to_string(GEOS_CAPI_VERSION_MINOR) + "." +
          std::to_string(GEOS_CAPI_VERSION_PATCH);
}

// [[Rcpp::export]]
std::string geos_version() 
{
  return geos::geom::geosversion();
}

// [[Rcpp::export]]
std::string geos_jtsport() 
{
  return geos::geom::jtsport();
}
