####################################################
# week 3: build leaflet
####################################################

#' @title eq_map
#' @description maps earthquakes on a leaflet object
#' @param eq_data a dataframe containing info on earthquakes. The data frame should have the following columns: LONGITUDE, LATITUDE, EQ_PRIMARY
#' @param  annot_col the name of the column containing information to show on the map.
#' @examples
#' \dontrun{readr::read_delim(eq_raw_file, delim = "\t") %>%
#' eq_clean_data() %>%
#' dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#' eq_map(annot_col = "DATE")}
#'
#' @importFrom leaflet leaflet addCircleMarkers
#' @export
eq_map <- function(eq_data, annot_col){
  annot <- eq_data %>% magrittr::extract2(annot_col) %>% as.character
  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(data = eq_data, lng = ~ LONGITUDE, lat = ~ LATITUDE, radius = ~ EQ_PRIMARY, weight = 2, popup = annot)
}


#' Creates a label for leaflet map
#'
#' This function creates a label for the \code{leaflet} map based on location
#' name, magnitude and casualties from NOAA earthquake data
#'
#' @param data A data frame containing cleaned NOAA earthquake data
#'
#' @return A character vector with labels
#'
#' @details The input \code{data.frame} needs to include columns LOCATION_NAME,
#' EQ_PRIMARY and TOTAL_DEATHS with the earthquake location, magintude and
#' total casualties respectively.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' eq_create_label(data)
#' }
eq_create_label <- function(data) {
  popup_text <- with(data, {
    part1 <- ifelse(is.na(LOCATION_NAME), "",
                    paste("<strong>Location:</strong>",
                          LOCATION_NAME))
    part2 <- ifelse(is.na(EQ_PRIMARY), "",
                    paste("<br><strong>Magnitude</strong>",
                          EQ_PRIMARY))
    part3 <- ifelse(is.na(TOTAL_DEATHS), "",
                    paste("<br><strong>Total deaths:</strong>",
                          TOTAL_DEATHS))
    paste0(part1, part2, part3)
  })
}
