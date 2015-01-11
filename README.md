phoxy
=====

The Phoenix event data set records social and political events
automatically extracted from news reporting. \code{phoxy} provides
functions to make acquiring and analyzing this event data easier. For more
information about Phoenix, see its website here:
 \url{http://phoenixdata.org/} and the website of the Open Event Data
Alliance here: \url{http://openeventdata.org/}.

Currently, phoxy includes two basic functions.

* `download_phoenix` takes a directory path and downloads the entire Phoenix
  dataset from [http://phoenixdata.org/data](http://phoenixdata.org/data) into
  that directory.

* `ingest_phoenix` reads in each daily text file from that directory, does some
  basic column name and class fixing, and combines them all into one large
  dataframe for easy analysis.
