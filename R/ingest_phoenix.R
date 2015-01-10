
#' @export
ingest_phoenix <- function(dir, version = "auto", read_func = "read.csv"){  
  # Handle messy file paths
  lastletter <- stringr::str_sub(dir ,-1, -1)
  if (lastletter != "/"){
    dir <- paste0(dir, "/")
  }
  
  files <- list.files(dir)
  files <- paste0(dir, files)
  eventColClasses <- c(rep("integer", 5), rep("character", 8), rep("factor", 3), 
                       "numeric", "character", "numeric", "numeric", rep("character", 6))
  event_list  <- lapply(files, read.csv, stringsAsFactors=FALSE, header=FALSE, colClasses=eventColClasses, sep="\t")
  events <- dplyr::rbind_all(event_list)
  names(events) <- c("EventID", "Date", "Year", "Month", "Day", "SourceActorFull", 
                     "SourceActorEntity", "SourceActorRole", "SourceActorAttribute", 
                     "TargetActorFull", "TargetActorEntity", "TargetActorRole", 
                     "TargetActorAttribute", "EventCode", "EventRootCode", "QuadClass", 
                     "GoldsteinScore", "Issues", "Lat", "Lon", 
                     "LocationName", "StateName", "CountryName", "SentenceID", "URLs", 
                     "NewsSources")
  return(events)
}
  