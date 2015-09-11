phoxy
=====

Download, ingest, and analyze the Phoenix and ICEWS event datasets.

The Phoenix event data set records social and political events
automatically extracted from news reporting. `phoxy` provides
functions to make acquiring and analyzing this event data easier. For more
information about Phoenix, see its website here:
[http://phoenixdata.org/](http://phoenixdata.org/) and the website of the Open Event Data
Alliance here: [http://openeventdata.org/](http://openeventdata.org). `phoxy`
also includes basic functionality for working with the
[ICEWS](https://dataverse.harvard.edu/dataverse/icews) event dataset.

`phoxy`, like the Phoenix event dataset, is still under beta development and will
change greatly. Bug reports are welcome.

Installation
------------
`devtools::install_github("ahalterman/phoxy")`

Usage
-----

Currently, `phoxy` includes the following functions:

* `download_phoenix` takes a directory path and version number and downloads
  the entire Phoenix dataset (of that version) from
  [http://phoenixdata.org/data](http://phoenixdata.org/data) into the given
  directory. It currenty accepts two versions: "current" and "v0.1.0".

* `download_icews` takes a directory path and downloads the entire ICEWS event
  dataset from [https://dataverse.harvard.edu/dataverse/icews](https://dataverse.harvard.edu/dataverse/icews).

* `update_phoenix` takes a directory path that contains Phoenix files and
  downloads any of the daily updates that are missing from the directory.
  Running it on an empty directory is equivalent to running `download_phoenix`,
  and running it daily will make sure you always have yesterday's data
  downloaded.

* `ingest_phoenix` reads in each daily text file from that directory, does some
  basic column name and class fixing, and combines them all into one large
  dataframe for easy analysis. 

* `ingest_icews` reads in a directory of files containing the ICEWS event
  dataset.

* `convert_cameo` will translate from CAMEO event codes to the human readable
  definitions taken from the CAMEO codebook.

Example:

```
download_phoenix("~/OEDA/phoxy_test/", phoenix_version = "current")
events <- ingest_phoenix("~/OEDA/phoxy_test/")

> str(events)

Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	699429 obs. of  26 variables:
 $ EventID             : chr  "0_v0.2.0" "1_v0.2.0" "2_v0.2.0" "3_v0.2.0" ...
 $ Date                : Date, format: "2014-06-20" "2014-06-20" "2014-06-20" "2014-06-16" ...
 $ Year                : int  2014 2014 2014 2014 2014 2014 2014 2014 2014 2014 ...
 $ Month               : int  6 6 6 6 6 6 6 6 6 6 ...
 $ Day                 : int  20 20 20 16 20 20 19 20 20 20 ...
 $ SourceActorFull     : chr  "THA" "INDPTY" "ESPCOP" "IMGMUSISI" ...
 $ SourceActorEntity   : chr  "THA" "IND" "ESP" "IMG" ...
 $ SourceActorRole     : chr  "" "PTY" "COP" "" ...
 $ SourceActorAttribute: chr  "" "" "" "MUS;ISI" ...
 $ TargetActorFull     : chr  "USA" "IND" "IMGMUSISI" "TUR" ...
 $ TargetActorEntity   : chr  "USA" "IND" "IMG" "TUR" ...
 $ TargetActorRole     : chr  "" "" "" "" ...
 $ TargetActorAttribute: chr  "" "" "MUS;ISI" "" ...
 $ EventCode           : chr  "043" "010" "010" "130" ...
 $ EventRootCode       : chr  "04" "01" "01" "13" ...
 $ PentaClass           : chr  "1" "0" "0" "3" ...
 $ GoldsteinScore      : num  2.8 0 0 -4.4 0 9 8 0 3.4 7 ...
 $ Issues              : chr  "" "" "SECURITY_SERVICES,1" "NAMED_TERROR_GROUP,1" ...
 $ Lat                 : num  25.5 28.6 40.4 39.9 39.8 ...
 $ Lon                 : num  51.2 77.2 -3.7 32.9 -98.5 ...
 $ LocationName        : chr  "State of Qatar" "New Delhi" "Madrid" "Ankara" ...
 $ StateName           : chr  "" "National Capital Territory of Delhi" "Comunidad de Madrid" "Ankara" ...
 $ CountryCode         : chr  "QAT" "IND" "ESP" "TUR" ...
 $ SentenceID          : chr  "53a492ef421aa9436ba6d1e0_3" "53a49741421aa9435ea6d25e_1" "53a4943e421aa94379a6d2ea_6" "53a492e5421aa94369a6d1c5_5" ...
 $ URLs                : chr  "http://www.theguardian.com/global-development/2014/jun/20/thailand-qatar-downgraded-human-trafficking-report" "http://www.thehindu.com/news/national/hindi-issue-cong-advises-caution-says-backlash-in-nonhindi-states/article6133644.ece?utm_"| __truncated__ "http://rss.nytimes.com/c/34625/f/640334/s/3b920a70/sc/11/l/0L0Snytimes0N0C20A140C0A60C170Cworld0Ceurope0Cspanish0Epolice0Etarge"| __truncated__ "http://www.ipsnews.net/2014/06/turkeys-kurdish-problem-likely-worsen-isis-gains-iraq/?utm_source=rss&utm_medium=rss&utm_campaig"| __truncated__ ...
 $ NewsSources         : chr  "guardian_americas" "hindu_nat" "nyteurope" "ips_hr" ...
 ```

