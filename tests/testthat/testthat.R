test_that("Noaa pkg tests", {

  eq_raw_file <- system.file("extdata/signif.txt", package = "NoaaCS")
  eq_raw_data <- read_tsv(eq_raw_file)
  eq_clean <- eq_clean_data(eq_raw_data)




  # row 5 and 5000
  eq_test_table <- data.frame(I_D = c(8, 8209),
                           YEAR = c(-1566,2000),
                           MONTH = c(NA,6),
                           DAY = c(NA,17),
                           HOUR= c(NA,15),
                           MINUTE = c(NA,40),
                           SECOND = c(NA,41.7),
                           EQ_PRIMARY = c(NA, 6.5),
                           COUNTRY = c("ISRAEL","ICELAND"),
                           LOCATION_NAME = c("ISRAEL: ARIHA (JERICHO)","ICELAND: VESTMANNAEYJAR, HELLA"),
                           LATITUDE = c("31.5","63.966"),
                           LONGITUDE = c("35.3","-20.487"),
                           TOTAL_DEATHS = c(NA, 10),
                           DEATHS = c(NA, 10))

  # test location cleaner
  expect_that(eq_location_clean(eq_test_table)$LOCATION_NAME[2], is_identical_to("Vestmannaeyjar, Hella"))

  eq_clean_test_table <- eq_clean_data(eq_test_table)

  expect_that(eq_clean_test_table, is_a("data.frame"))

  # test coordinates conversion
  expect_that(eq_clean_test_table$LATITUDE[2], is_identical_to(63.966))

  # test for BC dates
  expect_that(as.character(eq_clean_test_table$DATE[1]), is_identical_to("-1566-01-01"))

  # test for regular dates
  expect_that(eq_clean_test_table$DATE[2], is_identical_to(lubridate::ymd("2000-06-17")))

  # test that geom_timeline generates a valid ggplot object
  p1 <- ggplot() +
    geom_timeline(data = eq_clean_test_table, aes(x = DATE, size = EQ_PRIMARY, y = COUNTRY, color = DEATHS)) +
    scale_size_continuous(name  ="Richter scale value") +
    scale_colour_continuous(name  ="# deaths") +
    theme_timeline()

  expect_is(p1, "ggplot")
  expect_is(p1$layers[[1]]$geom, "GeomTimeline")

  # test that geom_timeline_label generates a valid ggplot object
  noteworthy_eq <- eq_clean %>%
    filter(EQ_PRIMARY == max(EQ_PRIMARY, na.rm = T) | DEATHS == max(DEATHS, na.rm = T))

  p2 <- ggplot() +
    geom_timeline(data = eq_clean, aes(x = DATE, size = EQ_PRIMARY, color = DEATHS)) +
    geom_timeline_label(data = noteworthy_eq, aes(x = DATE, label = LOCATION_NAME)) +
    scale_size_continuous(name  ="Richter scale value") +
    scale_colour_continuous(name  ="# deaths") +
    theme_timeline()

  expect_is(p2, "ggplot")
  expect_is(p2$layers[[2]]$geom, "GeomTimelineLabel")


# readr::read_delim(eq_raw_file, delim = "\t") %>%
#   eq_clean_data() %>%
#   dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#   eq_map(annot_col = "DATE")

})
