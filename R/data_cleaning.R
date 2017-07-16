#############################################################################
# WEEK 1 Clean data
#############################################################################

#' @title cleans the LOCATION_NAME column
#'
#' @description cleans the LOCATION_NAME column by stripping out the country name
#' (including the colon) and converts names to title case (as opposed
#' to all caps).
#'
#' @param raw_data the name of the file to read (character)
#'
#' @return a data frame with a clean LOCATION_NAME column
#'
#' @examples
#' \dontrun{eq_clean <- eq_location_clean(eq_clean <- raw_data)}
#'
#' @importFrom tidyr separate_
#' @importFrom dplyr mutate_ select_
#' @importFrom stringr str_to_title
#' @importFrom magrittr %>%
#'
#' @export
eq_location_clean <- function(raw_data){
  x <- raw_data %>%
    tidyr::separate_("LOCATION_NAME", into = c("country", "LOCATION_NAME"), sep = ":", extra = "drop" ) %>%
    dplyr::mutate_(LOCATION_NAME = ~stringr::str_to_title(LOCATION_NAME)) %>%
    dplyr::select_(quote(-country))
}

#' @title Clean NOAA data
#'
#' @description Takes raw NOAA data frame and returns a clean data frame.
#'
#' @param raw_data the name of the file to read (character)
#'
#' @return a clean data frame with the following columns:
#'    date: type Date with year, month and day
#'    LATITUDE: numeric
#'    LONGITUDE: numeric
#'
#'
#' @examples
#' \dontrun{
#' eq_raw_file <- file.path("inst", "extdata", "signif.txt")
#' eq_raw_data <- read_tsv(eq_raw_file, skip = 1)
#' eq_clean <- eq_clean_data(eq_raw_data) }
#'
#' @importFrom dplyr mutate_ if_else
#' @importFrom stringr str_pad
#' @importFrom lubridate ymd years
#' @importFrom magrittr %>%
#' @export
eq_clean_data <- function(raw_data) {
  eq_clean <- raw_data %>%
    dplyr::mutate_(BC_date = ~ (YEAR <0),
                   DATE_s  = ~ paste(stringr::str_pad(abs(YEAR), 4, "left", "0"),
                                     stringr::str_pad(ifelse(is.na(MONTH), 1, MONTH),2,"left","0"),
                                     stringr::str_pad(ifelse(is.na(DAY), 1, DAY),2,"left","0"),
                                     sep = "-"),
                   DATE = ~ lubridate::ymd(DATE_s) -lubridate::years(2*abs(YEAR))*BC_date,
                   LONGITUDE = ~ as.numeric(LONGITUDE),
                   LATITUDE = ~ as.numeric(LATITUDE)) %>%
                   eq_location_clean() %>%
                   dplyr::select_(.dots = c('-DATE_s', '-BC_date'))
}


