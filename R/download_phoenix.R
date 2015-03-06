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

# get all the URLs on a page
get_links <- function(phoenix_version){
  library(rvest) # I know...not best practices...
  page_url <- paste0("http://phoenixdata.org/data/", phoenix_version)
  data_page <- rvest::html(page_url)
  
  page <- data_page %>%
    html_node("tbody") %>%
    html_text
  
  page <- unlist(stringr::str_split(page, " "))
  page <- stringr::str_trim(page)
  
  links <- gsub("\\d{4}\\-\\d{2}\\-\\d{2}$", "", page)
  links <- links[links != ""]
  return(links)
}

# given a list of links, download them and write to specified directory
dw_file <- function(link, destpath, phoenix_version){
  baseurl <- paste0("https://s3.amazonaws.com/oeda/data/", phoenix_version, "/")
  filename <- gsub(baseurl, "", link)
  filename <- paste0(destpath, filename)
  bin <- getBinaryURL(link, ssl.verifypeer=FALSE)
  con <- file(filename, open = "wb")
  writeBin(bin, con)
  close(con)
  unzip(filename, exdir = destpath, unzip = "internal", setTimes = FALSE)
  unlink(filename)
}

#' @export
#' @importFrom plyr l_ply progress_text
download_phoenix <- function(destpath, phoenix_version = "current"){
  library(RCurl)
  if (stringr::str_sub(destpath, -1) != "/"){
    stop("Destination paths need to have trailing forward slashes")
  }
  ll <- get_links(phoenix_version = phoenix_version)
  message("Downloading and unzipping files.")
  plyr::l_ply(ll, dw_file, phoenix_version = phoenix_version, destpath = destpath, .progress = plyr::progress_text(char = '='))
}





