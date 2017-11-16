#include <Rcpp.h>
#include <geos_c.h>

//' Get geos C API version
//'
//' @export
// [[Rcpp::export]]
std::string geos_c_api_version() 
{
  return std::to_string(GEOS_CAPI_VERSION_MAJOR) + "." +
         std::to_string(GEOS_CAPI_VERSION_MINOR) + "." +
         std::to_string(GEOS_CAPI_VERSION_PATCH);
}

//' Get geos library version
//'
//' @export
// [[Rcpp::export]]
std::string geos_version() 
{
  return GEOS_VERSION;
}


//' Get geos jts port version
//'
//' @export
// [[Rcpp::export]]
std::string geos_jtsport() 
{
  return GEOS_JTS_PORT;
}
