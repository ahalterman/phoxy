#' Download the ICEWS Dataset
#'
#' Download and unzip all of the data files for the ICEWS dataset from the 
#' Harvard Dataverse into a given directory.
#'
#' @param destpath The path to the directory where ICEWS should go.
#'
#' @return NULL
#' @author Tony Boyles
#' @note This function is still in development and may contain errors and change quickly.
#' @examples
#'
#' download_icews("~/ICEWS/")
#'
#' @rdname download_icews

#' @export
#' @importFrom plyr l_ply progress_text
download_icews <- function(destpath = "."){
  library("RCurl")
  ids <- c(2546408,2546409,2546410,2546411,2546412,2546413,2546414,2546867,2546868,2546869,2546870,2546871,2546872,2546873,2546874,2546875,2546876,2546878,2546879,2548735)
  if (stringr::str_sub(destpath, -1) != "/"){
    destpath <- paste0(destpath, "/")
  }
  message("Downloading and unzipping files.")
  plyr::l_ply(ids, dw_file, destpath = destpath, .progress = "text")
}

# given a list of links, download them and write to specified directory
dw_file <- function(link, destpath){
  baseURL <- "https://dataverse.harvard.edu/api/access/datafile/"
  fullURL <- paste0(baseURL, link)
  filename <- paste0(destpath, link)
  bin <- getBinaryURL(fullURL)
  con <- file(filename, open = "wb")
  writeBin(bin, con)
  close(con)
  unzip(filename, exdir = destpath, unzip = "internal", setTimes = FALSE)
  unlink(filename)
}
