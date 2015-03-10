#' Update a local directory of Phoenix dataset files with new files from the server
#'
#' Checks the contents of a directory containing Phoenix event data files, checks whether the 
#' server has new events, and downloads them to that directory. (It'll have some version handling ability,
#' too, either from the file names or by reading in the events.)
#'
#' @param destpath The path to download Phoenix into.
#' @param phoenix_version. Download a specific version of Phoenix ("v0.1.0" or "current").
#'
#' @return NULL
#' @author Andy Halterman
#' @note This function, like Phoenix, is still in development and may contain errors and change quickly.
#' @examples
#'
#' update_phoenix("~/OEDA/phoxy_test/", phoenix_version = "current")

#' 
#' @export
update_phoenix <- function(destpath, phoenix_version = "current"){
  library(RCurl)
  # pulls all the links from the OEDA Phoenix page
  links <- phoxy:::get_links(phoenix_version = phoenix_version)  
  links_shortened <- as.data.frame(stringr::str_match(links, "events.full.(\\d+).txt"), stringsAsFactors=FALSE)
  filelist <- list.files(destpath)
  filelist_shortened <- as.data.frame(stringr::str_match(filelist, "events.full.(\\d+).txt"), stringsAsFactors=FALSE)
  # All rows in links_shortened that do not have a match in filelist_shortened.
  new_files <- dplyr::anti_join(links_shortened, filelist_shortened, by = "V2")
  message("There are ", nrow(new_files), " undownloaded daily files. Downloading now...")
  
  version_nodots <- gsub(".", "", phoenix_version, fixed=TRUE)
  ll <- paste0("https://s3.amazonaws.com/oeda/data/", version_nodots, "/", new_files$V1, ".zip")
  
  message("Downloading and unzipping files.")
  plyr::l_ply(ll, phoxy:::dw_file, destpath = destpath, phoenix_version = phoenix_version, .progress = plyr::progress_text(char = '='))
}





