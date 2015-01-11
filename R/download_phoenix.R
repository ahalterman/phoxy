#' Download the Phoenix Dataset
#'
#' Download and unzip all of the data files for the Phoenix dataset from the 
#' Phoenix data website into a given directory.
#'
#' @param dir The path to download Phoenix into.
#' @param version [Not yet implemented]. Download a specific version of Phoenix.
#'
#' @return NULL
#' @author Andy Halterman
#' @note This function, like Phoenix, is still in development and may contain errors and change quickly.
#' @examples
#'
#' download_phoenix("~/OEDA/phoxy_test/")
#'
#' @rdname download_phoenix

get_links <- function(){
  library(rvest)
  data_page <- rvest::html("http://phoenixdata.org/data")
  
  page <- data_page %>%
    html_node("tbody") %>%
    html_text
  
  page <- unlist(stringr::str_split(page, "\n"))
  page <- stringr::str_trim(page)
  
  links <- page[grep("https://s3.amazonaws.com/oeda/data/events", page)]
  return(links)
}



#' @export
#' @importFrom plyr l_ply progress_text

download_phoenix <- function(destpath){
  # Get all the links on the page
  library(RCurl)
  ll <- get_links()
  
  # given a list of links, download them and write to specified directory
  dw_file <- function(link){
    filename = gsub("https://s3.amazonaws.com/oeda/data/", "", link)
    bin <- getBinaryURL(link, ssl.verifypeer=FALSE)
    con <- file(filename, open = "wb")
    writeBin(bin, con)
    close(con)
    unzip(filename, exdir = ".", unzip = "internal", setTimes = FALSE)
    unlink(filename)
}
  message("Downloading and unzipping files.")
  plyr::l_ply(ll, dw_file, .progress = plyr::progress_text(char = '*'))
}





