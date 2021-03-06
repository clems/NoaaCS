% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eq_data_cleaning.R
\name{eq_clean_data}
\alias{eq_clean_data}
\title{Clean NOAA data}
\usage{
eq_clean_data(raw_data)
}
\arguments{
\item{raw_data}{the name of the file to read (character)}
}
\value{
a clean data frame with the following columns:
   date: type Date with year, month and day
   LATITUDE: numeric
   LONGITUDE: numeric
}
\description{
Takes raw NOAA data frame and returns a clean data frame.
}
\examples{
\dontrun{
eq_raw_file <- file.path("inst", "extdata", "signif.txt")
eq_raw_data <- read_tsv(eq_raw_file, skip = 1)
eq_clean <- eq_clean_data(eq_raw_data) }

}
