#' Ingest the Phoenix Dataset
#'
#' Given a directory with individual Phoenix dataset files, quickly read 
#' them all in, name them correctly, and combine them into one dataframe.
#'
#' @param dir The path to the Phoenix folder.
#' @param phoenix_version [Not yet implemented]. Use the appropriate function for each Phoenix version.
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
ingest_phoenix <- function(dir, phoenix_version = "auto", read_func = "read.csv", processing_function){  
  # Handle messy file paths
  lastletter <- stringr::str_sub(dir ,-1, -1)
  if (lastletter != "/"){
    dir <- paste0(dir, "/")
  }
  
  files <- list.files(dir)
  files <- paste0(dir, files)
  # I would set the col classes here, but was causing errors. Done later, which is slower but stable.
  eventColClasses <- c(rep("character", 26))
  # A reading function with some error catching.
  read_one <- function(file){
    t <- tryCatch(read.csv(file, stringsAsFactors=FALSE, header=FALSE, 
                       sep="\t", quote = "", colClasses=eventColClasses), 
                  error=function(e) message(paste0("error reading ", file)))
    
    if(class(t)[1] == "data.frame" & is.null(t) == FALSE){
          return(t)
    }
    else{
      message("object is not a dataframe")
    }
    }
  
  message("Reading in files...")
  event_list  <- plyr::llply(files, read_one, .progress = plyr::progress_text(char = '='))
  # bind everything together. Surpress this warning: "Unequal factor levels: coercing to character"
  events <- dplyr::bind_rows(event_list)
  names(events) <- c("EventID", "Date", "Year", "Month", "Day", "SourceActorFull", 
                     "SourceActorEntity", "SourceActorRole", "SourceActorAttribute", 
                     "TargetActorFull", "TargetActorEntity", "TargetActorRole", 
                     "TargetActorAttribute", "EventCode", "EventRootCode", "QuadClass", 
                     "GoldsteinScore", "Issues", "Lat", "Lon", 
                     "LocationName", "StateName", "CountryCode", "SentenceID", "URLs", 
                     "NewsSources")
  events$Date <- as.Date(lubridate::ymd(events$Date))  # use lubridate, then de-POSIX the date.
  events$Year <- as.integer(events$Year)
  events$Month <- as.integer(events$Month)
  events$Day <- as.integer(events$Day)
  events$GoldsteinScore <- as.numeric(events$GoldsteinScore)
  events$Lat <- as.numeric(events$Lat)
  events$Lon <- as.numeric(events$Lon)
  eventColClasses <- c(rep("integer", 5), rep("character", 11), "numeric", "character", "numeric", 
                       "numeric", rep("character", 6))
  message("Process complete")
  return(events)
}


  