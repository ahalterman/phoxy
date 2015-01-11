phoxy
=====

Download, ingest, and analyze the Phoenix event dataset.

The Phoenix event data set records social and political events
automatically extracted from news reporting. `phoxy` provides
functions to make acquiring and analyzing this event data easier. For more
information about Phoenix, see its website here:
[http://phoenixdata.org/](http://phoenixdata.org/) and the website of the Open Event Data
Alliance here: [http://openeventdata.org/](http://openeventdata.org).

`phoxy`, like the Phoenix event dataset, is still under beta development and will
change greatly. Bug reports are welcome.

Installation
------------
`devtools::install_github("ahalterman/phoxy")`

Usage
-----

Currently, phoxy includes two basic functions.

* `download_phoenix` takes a directory path and downloads the entire Phoenix
  dataset from [http://phoenixdata.org/data](http://phoenixdata.org/data) into
  that directory. 

* `ingest_phoenix` reads in each daily text file from that directory, does some
  basic column name and class fixing, and combines them all into one large
  dataframe for easy analysis. 

Example:

```
download_phoenix("~/OEDA/phoxy_test/")
events <- ingest_phoenix("~/OEDA/phoxy_test/")
```

