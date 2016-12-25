#include <Rcpp.h>
#include <geos_c.h>

// [[Rcpp::export]]
Rcpp::IntegerVector geos_version(bool c_api = false) 
{
  Rcpp::IntegerVector ver = (c_api) ?
    Rcpp::IntegerVector::create(
      GEOS_CAPI_VERSION_MAJOR,
      GEOS_CAPI_VERSION_MINOR,
      GEOS_CAPI_VERSION_PATCH
    ) :
    Rcpp::IntegerVector::create(
      GEOS_VERSION_MAJOR,
      GEOS_VERSION_MINOR,
      GEOS_VERSION_PATCH
    );  

  return ver;
}


// [[Rcpp::export]]
int test_api(std::string wkt)
{
  GEOSContextHandle_t handle = GEOS_init_r();
  GEOSWKTReader* reader = GEOSWKTReader_create_r(handle);
  
  GEOSGeometry* geom = GEOSWKTReader_read_r(handle, reader, wkt.c_str());
  
  int n_coords = NA_INTEGER;
  if (geom != NULL)
  {
    n_coords = GEOSGetNumCoordinates_r(handle, geom);
    GEOSGeom_destroy_r(handle, geom);
  }

  GEOSWKTReader_destroy_r(handle, reader);
  GEOS_finish_r(handle);

  return(n_coords);
}