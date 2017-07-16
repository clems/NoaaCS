####################################################
# code to test the functions
####################################################
library(readr)
library(stringr)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(leaflet)
library(NoaaCS)

eq_raw_file <- system.file("extdata/signif.txt", package = "NoaaCS")
# Create a vector of column names, based on the online documentation for this
# data
eq_raw_colnames <- c("I_D","FLAG_TSUNAMI","YEAR","MONTH","DAY","HOUR","MINUTE",
                     "SECOND","FOCAL_DEPTH","EQ_PRIMARY","EQ_MAG_MW","EQ_MAG_MS",
                     "EQ_MAG_MB" ,"EQ_MAG_ML","EQ_MAG_MFA","EQ_MAG_UNK","INTENSITY",
                     "COUNTRY","STATE","LOCATION_NAME","LATITUDE","LONGITUDE",
                     "REGION_CODE","DEATHS","DEATHS_DESCRIPTION","MISSING",
                     "MISSING_DESCRIPTION","INJURIES","INJURIES_DESCRIPTION",
                     "DAMAGE_MILLIONS_DOLLARS","DAMAGE_DESCRIPTION","HOUSES_DESTROYED",
                     "HOUSES_DESTROYED_DESCRIPTION","HOUSES_DAMAGED",
                     "HOUSES_DAMAGED_DESCRIPTION","TOTAL_DEATHS","TOTAL_DEATHS_DESCRIPTION",
                     "TOTAL_MISSING","TOTAL_MISSING_DESCRIPTION","TOTAL_INJURIES",
                     "TOTAL_INJURIES_DESCRIPTION","TOTAL_DAMAGE_MILLIONS_DOLLARS",
                     "TOTAL_DAMAGE_DESCRIPTION","TOTAL_HOUSES_DESTROYED",
                     "TOTAL_HOUSES_DESTROYED_DESCRIPTION","TOTAL_HOUSES_DAMAGED",
                     "TOTAL_HOUSES_DAMAGED_DESCRIPTION")

eq_raw_data <- read_tsv(eq_raw_file, eq_raw_colnames, skip = 1,
                               col_types = "iciiiiicinnncncnicccnniiiciiiciiiiiiicciiciiiii")

eq_clean <- eq_clean_data(eq_raw_data)

eq_20e <- eq_clean %>%
  filter(year(DATE)>=2000, COUNTRY %in% c("USA", "CHINA"))


ggplot() +
  geom_timeline(data = eq_20e, aes(x = DATE, size = EQ_PRIMARY, y = COUNTRY, color = DEATHS)) +
  scale_size_continuous(name  ="Richter scale value") +
  scale_colour_continuous(name  ="# deaths") +
  theme_timeline

noteworthy_eq <- eq_20e %>%
  filter(EQ_PRIMARY == max(EQ_PRIMARY, na.rm = T) | DEATHS == max(DEATHS, na.rm = T))

ggplot() +
  geom_timeline(data = eq_20e, aes(x = DATE, size = EQ_PRIMARY, color = DEATHS)) +
  geom_timeline_label(data = noteworthy_eq, aes(x = DATE, label = LOCATION_NAME)) +
  scale_size_continuous(name  ="Richter scale value") +
  scale_colour_continuous(name  ="# deaths") +
  theme_timeline

ggplot() +
  geom_timeline(data = eq_20e, aes(x = DATE, y = COUNTRY, size = EQ_PRIMARY, color = DEATHS)) +
  geom_timeline_label(data = noteworthy_eq, aes(x = DATE, y = COUNTRY, label = LOCATION_NAME)) +
  scale_size_continuous(name  ="Richter scale value") +
  scale_colour_continuous(name  ="# deaths") +
  theme_timeline

ggplot() +
  geom_timeline(data = eq_20e, aes(x = DATE, y = COUNTRY, color = DEATHS)) +
  geom_timeline_label(data = eq_20e, aes(x = DATE, y = COUNTRY, label = LOCATION_NAME)) +
  scale_size_continuous(name  ="Richter scale value") +
  scale_colour_continuous(name  ="# deaths") +
  theme_timeline


readr::read_delim(eq_raw_file, delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  eq_map(annot_col = "DATE")

