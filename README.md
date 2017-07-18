
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/clems/NoaaCS.svg?branch=master)](https://travis-ci.org/clems/NoaaCS)

The NoasCS R package is created to visualize NOAA earthquake data. It processes data from [NOAA database](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1) and visualizes them using `ggplot2` and `leaflet` packages.

Package functions
-----------------

There are six exported functions available to users:

-   `eq_clean_data()`
-   `geom_timeline()`
-   `geom_timeline_label()`
-   `theme_timeline()`
-   `eq_create_label()`
-   `eq_map()`

Clean data
----------

The function `eq_clean_data` preprocess the data. It creates a DATE column in `Date` format, transforms latitude and longitude to numeric format and trims country from LOCATION\_NAME.

``` r
filename <- system.file("extdata/signif.txt", package = "NoaaCS")
data <- readr::read_tsv(filename)

eq_clean_data(data)
#> Warning: Too few values at 720 locations: 7, 19, 27, 32, 47, 50, 52, 53,
#> 71, 88, 108, 113, 126, 131, 140, 146, 149, 163, 171, 177, ...
```

Visualize earthquake timeline
-----------------------------

Three functions use `ggplot2` to plot an earthquake timeline:

-   `geom_timeline()` requires cleaned data. You should provide dates to the required aesthetics `x` , and countries to the optional aesthetics `y`. , You can set `size` and `color` according to your needs.
-   The `geom_timeline_label()` function requires additional `label` aesthetic for labeling.
-   A `theme_timeline()` is available as well.

``` r
data %>% eq_clean_data() %>%
     filter(COUNTRY %in% c("USA", "CHINA"), YEAR > 2000, DEATHS>0) %>%
     ggplot(aes(x = DATE,
                y = COUNTRY,
                color = DEATHS,
                size = as.numeric(EQ_PRIMARY)
     )) +
     geom_timeline() +
     geom_timeline_label(aes(label = LOCATION_NAME), n_max = 5) +
     theme_timeline() +
     labs(size = "Richter scale value", color = "# deaths")
#> Warning: Too few values at 720 locations: 7, 19, 27, 32, 47, 50, 52, 53,
#> 71, 88, 108, 113, 126, 131, 140, 146, 149, 163, 171, 177, ...
#> Warning: Ignoring unknown parameters: n_max
#> Warning: Removed 1 rows containing missing values (geom_timeline_label).
```

![](README-eq_timeline_example-1.png)

Visualize earthquakes on map
----------------------------

The package uses `leaflet` functions to show earthquakes on a map using `eq_map()` function. Optional annotations can be created using `eq_create_label()` function. The result is an interactive map where user can click on individual points to get details.
