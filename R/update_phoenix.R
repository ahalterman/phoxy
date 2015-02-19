#' Update a local directory of Phoenix dataset files with new files from the server
#'
#' Checks the contents of a directory containing Phoenix event data files, checks whether the 
#' server has new events, and downloads them to that directory. (It'll have some version handling ability,
#' too, either from the file names or by reading in the events.)
#'


#' #' @export
update_phoenix <- function(destpath){
  library(RCurl)
  links <- phoxy:::get_links()  # pulls all the links from the OEDA Phoenix page
  links_shortened <- as.data.frame(stringr::str_match(links, "events.full.(\\d+).txt"), stringsAsFactors=FALSE)
  filelist <- list.files(destpath)
  filelist_shortened <- as.data.frame(stringr::str_match(filelist, "events.full.(\\d+).txt"), stringsAsFactors=FALSE)
  #print(head(filelist_shortened))
  #print(head(links_shortened))
  # All rows in links_shortened that do not have a match in filelist_shortened.
  new_files <- dplyr::anti_join(links_shortened, filelist_shortened, by = "V2")
  message("There are ", nrow(new_files), " undownloaded daily files. Downloading now...")

  ll <- paste0("https://s3.amazonaws.com/oeda/data/", new_files$V1, ".zip")
  
  # given a list of links, download them and write to specified directory
  dw_file <- function(link){
    filename <- gsub("https://s3.amazonaws.com/oeda/data/", "", link)
    filename <- paste0(destpath, filename)
    bin <- getBinaryURL(link, ssl.verifypeer=FALSE)
    con <- file(filename, open = "wb")
    writeBin(bin, con)
    close(con)
    unzip(filename, exdir = destpath, unzip = "internal", setTimes = FALSE)
    unlink(filename)
  }
  message("Downloading and unzipping files.")
  plyr::l_ply(ll, dw_file, .progress = plyr::progress_text(char = '='))
}



