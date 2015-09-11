#' Download the Phoenix Dataset
#'
#' Download and unzip all of the data files for the Phoenix dataset from the
#' Phoenix data website into a given directory.
#'
#' @param destpath The path to the directory where Phoenix should go.
#' @param phoenix_version. Download a specific version of Phoenix ("v0.1.0" or the current version by default).
#'
#' @return NULL
#' @author Andy Halterman
#' @note This function, like Phoenix, is still in development and may contain errors and change quickly.
#' @examples
#'
#' download_phoenix("~/OEDA/phoxy_test/", phoenix_version = "current")
#'
#' @rdname download_phoenix


# get all the URLs on a page
get_links <- function (phoenix_version = 'current') {
  phoenix_version <- gsub('.', '', phoenix_version, fixed = T) # remove dots

  # check version user input, either 'current' or up to 3 digits
  # with optional 'v' in the beginning
  if (!grepl('(current|v?\\d{,3})', phoenix_version)) stop('Incorrect version name.')

  if (!grepl('^(v|current)', phoenix_version)) # if the user submitted a version without 'v'
    phoenix_version <- paste0('v', phoenix_version)

  # Access the Phoenix API. http://xkcd.com/1481/
  url <- paste0('http://phoenixdata.org/data/', phoenix_version)
  page <- XML::htmlParse(url)
  all_links <- as.vector(XML::xpathSApply(page, "//a/@href")) # xpath to extract url strings
  links <- all_links[grepl('zip$', all_links)] # only links ending with "zip"

  return(links)
}


# given a link, download the file and write it to the specified directory
dw_file <- function(link, destpath) {
  # extract filename from link
  m <- regexpr('[^/]*(?=\\.zip$)', link, perl = T)
  filename <- regmatches(link, m)

  # remove trailing filepath separator to destpath if it's there
  destpath <- gsub(paste0(.Platform$file.sep, '$'), '', destpath)

  # download method
  if (.Platform$OS.type == 'windows')
    download_method <- 'auto'
  else
    download_method <- 'curl'

  # download and unzip to destpath
  temp <- tempfile()
  download.file(link, temp, method = download_method, quiet = T)
  unzip(temp, exdir = destpath)
  unlink(temp)
}

#' @export
#' @importFrom plyr l_ply progress_text
download_phoenix <- function(destpath, phoenix_version = 'current'){
  links <- get_links(phoenix_version = phoenix_version)
  message("Downloading and unzipping files.")
  plyr::l_ply(links, dw_file, destpath = destpath, .progress = plyr::progress_text(char = '='))
}
