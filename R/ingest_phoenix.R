#' Ingest the Phoenix Dataset
#'
#' Given a directory with individual Phoenix dataset files, quickly read 
#' them all in, name them correctly, and combine them into one dataframe.
#'
#' @param dir The path to the Phoenix folder.
#' @param version [Not yet implemented]. Use the appropriate function for each Phoenix version.
#' @param read_func [Not yet implemented]. Use an alternative reading function like \code{fread} or \code{read_csv}.
#'
#' @return A single dataframe with all the Phoenix events in the folder.
#' @author Andy Halterman
#' @note This function, like Phoenix, is still in development and may contain errors and change quickly.
#' @examples
#'
#' events <- ingest_phoenix("~/OEDA/phoxy_test/")
#' 
#' @rdname ingest_phoenix
#' @export
ingest_phoenix <- function(dir, version = "auto", read_func = "read.csv", processing_function){  
  # Handle messy file paths
  lastletter <- stringr::str_sub(dir ,-1, -1)
  if (lastletter != "/"){
    dir <- paste0(dir, "/")
  }
  
  files <- list.files(dir)
  files <- paste0(dir, files)
  eventColClasses <- c(rep("integer", 5), rep("character", 8), rep("factor", 3), 
                       "numeric", "character", "numeric", "numeric", rep("character", 6))
  
  # A reading function with some error catching.
  read_one <- function(file){
    t <- tryCatch(read.csv(file, stringsAsFactors=FALSE, header=FALSE, 
                      colClasses=eventColClasses, sep="\t", quote = ""), error=function(e) NULL)
    if(class(t)[1] == "data.frame"){
      return(t)
    }
  }
  
  message("Reading in files...")
  event_list  <- plyr::llply(files, read_one, .progress = plyr::progress_text(char = '='))
  # bind everything together. Surpress this warning: "Unequal factor levels: coercing to character"
  events <- suppressWarnings(dplyr::rbind_all(event_list))
  #print(str(events))
  names(events) <- c("EventID", "Date", "Year", "Month", "Day", "SourceActorFull", 
                     "SourceActorEntity", "SourceActorRole", "SourceActorAttribute", 
                     "TargetActorFull", "TargetActorEntity", "TargetActorRole", 
                     "TargetActorAttribute", "EventCode", "EventRootCode", "QuadClass", 
                     "GoldsteinScore", "Issues", "Lat", "Lon", 
                     "LocationName", "StateName", "CountryCode", "SentenceID", "URLs", 
                     "NewsSources")
  events$Date <- as.Date(lubridate::ymd(events$Date))  # use lubridate, then de-POSIX the date.
  message("Process complete")
  return(events)
}



  