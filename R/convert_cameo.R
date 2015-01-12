#' Convert CAMEO Codes
#'
#' Converts CAMEO codes. CAMEO is an event ontology used in event data projects, including Phoenix. 
#'
#' @param cameo Vector of CAMEO event codes.
#' @keywords event data
#' @export
#' @aliases countrycode
#' @examples
#' events$Description <- phoxy::convert_cameo(events$EventCode) # Vector of values to be converted
#' 
convert_cameo <- function(cameo){
  data(convert_cameo_data, envir=environment())
  # Sanity check
#  origin_codes <- names(phoxy::countrycode_data)[!(names(phoxy::countrycode_data) %in% c("continent","region","regex"))]
#  destination_codes <- names(phoxy::countrycode_data)[!(names(phoxy::countrycode_data) %in% c("regex"))]
#  if (!origin %in% origin_codes){stop("Origin code not supported")}
#  if (!destination %in% destination_codes){stop("Destination code not supported")}
#  if (origin == 'country.name'){
#    dict = na.omit(countrycode::countrycode_data[,c('regex', destination)])
  #}else{
  dict <- na.omit(convert_cameo_data[,c("CAMEOcode", "EventDescription")])
  #}
  # Prepare output vector
  destination_vector <- rep(NA, length(cameo))
  # All but regex-based operations
    matches <- match(cameo, dict[, "CAMEOcode"])
    destination_vector <- dict[matches, "EventDescription"]
return(destination_vector)
}

