## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(clock)
library(magrittr)

## ---- eval=FALSE--------------------------------------------------------------
#  zoned_time_now("")
#  #> <zoned_time<nanosecond><America/New_York (current)>[1]>
#  #> [1] "2021-02-10 15:54:29.875011000-05:00"

## ---- eval=FALSE--------------------------------------------------------------
#  zoned_time_now("Asia/Shanghai")
#  #> <zoned_time<nanosecond><Asia/Shanghai>[1]>
#  #> [1] "2021-02-11 04:54:29.875011000+08:00"

## -----------------------------------------------------------------------------
my_time <- year_month_day(2019, 1, 30, 9) %>%
  as_naive_time() %>%
  as_zoned_time("America/New_York")

my_time

their_time <- zoned_time_set_zone(my_time, "Asia/Shanghai")

their_time

## -----------------------------------------------------------------------------
my_time <- as.POSIXct("2019-01-30 09:00:00", "America/New_York")

date_set_zone(my_time, "Asia/Shanghai")

## -----------------------------------------------------------------------------
my_time <- year_month_day(2019, 1, 30, 9) %>%
  as_naive_time() %>%
  as_zoned_time("America/New_York")

my_time

# Drop the time zone information, retaining the printed time
my_time %>%
  as_naive_time()

# Add the correct time zone name back on,
# again retaining the printed time
their_9am <- my_time %>%
  as_naive_time() %>%
  as_zoned_time("Asia/Shanghai")

their_9am

## -----------------------------------------------------------------------------
zoned_time_set_zone(their_9am, "America/New_York")

## -----------------------------------------------------------------------------
my_time <- as.POSIXct("2019-01-30 09:00:00", "America/New_York")

my_time %>%
  as_naive_time() %>%
  as.POSIXct("Asia/Shanghai") %>%
  date_set_zone("America/New_York")

## -----------------------------------------------------------------------------
days <- as_naive_time(year_month_day(2019, c(1, 2), 1))

# A Tuesday and a Friday
as_weekday(days)

monday <- weekday(clock_weekdays$monday)

time_point_shift(days, monday)

as_weekday(time_point_shift(days, monday))

## -----------------------------------------------------------------------------
time_point_shift(days, monday, which = "previous")

## -----------------------------------------------------------------------------
tuesday <- weekday(clock_weekdays$tuesday)

time_point_shift(days, tuesday)
time_point_shift(days, tuesday, boundary = "advance")

## -----------------------------------------------------------------------------
next_weekday <- function(x, target) {
  x + (target - as_weekday(x))
}

next_weekday(days, monday)

as_weekday(next_weekday(days, monday))

## -----------------------------------------------------------------------------
monday - as_weekday(days)

## -----------------------------------------------------------------------------
days + (monday - as_weekday(days))

## -----------------------------------------------------------------------------
next_weekday2 <- function(x, target) {
  x <- x + duration_days(1L)
  x + (target - as_weekday(x))
}

a_monday <- as_naive_time(year_month_day(2018, 12, 31))
as_weekday(a_monday)

next_weekday2(a_monday, monday)

## -----------------------------------------------------------------------------
monday <- weekday(clock_weekdays$monday)

x <- as.Date(c("2019-01-01", "2019-02-01"))

date_shift(x, monday)

# With a date-time
y <- as.POSIXct(
  c("2019-01-01 02:30:30", "2019-02-01 05:20:22"), 
  "America/New_York"
)

date_shift(y, monday)

## -----------------------------------------------------------------------------
ym <- seq(year_month_day(2019, 1), by = 2, length.out = 10)
ym

## -----------------------------------------------------------------------------
yq <- seq(year_quarter_day(2019, 1), by = 2, length.out = 10)

## -----------------------------------------------------------------------------
set_day(ym, "last")

set_day(yq, "last")

## -----------------------------------------------------------------------------
from <- as_naive_time(year_month_day(2019, 1, 1))
to <- as_naive_time(year_month_day(2019, 5, 15))

seq(from, to, by = 20)

## -----------------------------------------------------------------------------
from <- as_naive_time(year_month_day(2019, 1, 1, 2, 30, 00))
to <- as_naive_time(year_month_day(2019, 1, 1, 12, 30, 00))

seq(from, to, by = duration_minutes(90))

## -----------------------------------------------------------------------------
date_seq(date_build(2019, 1), by = 2, total_size = 10)

## -----------------------------------------------------------------------------
date_seq(date_build(2019, 1), by = duration_months(2), total_size = 10)

## ---- error=TRUE--------------------------------------------------------------
date_seq(
  date_build(2019, 1, 1),
  to = date_build(2019, 10, 2),
  by = duration_months(2)
)

## ---- error=TRUE--------------------------------------------------------------
jan31 <- date_build(2019, 1, 31)
dec31 <- date_build(2019, 12, 31)

date_seq(jan31, to = dec31, by = duration_months(1))

## -----------------------------------------------------------------------------
date_seq(jan31, to = dec31, by = duration_months(1), invalid = "previous")

## -----------------------------------------------------------------------------
seq(jan31, to = dec31, by = "1 month")

## -----------------------------------------------------------------------------
from <- as_naive_time(year_month_day(2019, 1, 1))
to <- as_naive_time(year_month_day(2019, 12, 31))

x <- seq(from, to, by = duration_days(20))

x

## -----------------------------------------------------------------------------
ymd <- as_year_month_day(x)

head(ymd)

calendar_group(ymd, "month")

## -----------------------------------------------------------------------------
yqd <- as_year_quarter_day(x)

head(yqd)

calendar_group(yqd, "quarter")

## -----------------------------------------------------------------------------
calendar_group(ymd, "month", n = 2)

calendar_group(yqd, "quarter", n = 2)

## -----------------------------------------------------------------------------
x <- seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by = 20)

date_group(x, "month")

## -----------------------------------------------------------------------------
x %>%
  as_year_quarter_day() %>%
  calendar_group("quarter") %>%
  set_day(1) %>%
  as.Date()

## -----------------------------------------------------------------------------
x %>%
  as_year_quarter_day(start = clock_months$june) %>%
  calendar_group("quarter") %>%
  set_day(1) %>%
  as.Date()

## -----------------------------------------------------------------------------
from <- as_naive_time(year_month_day(2019, 1, 1))
to <- as_naive_time(year_month_day(2019, 12, 31))

x <- seq(from, to, by = duration_days(20))

## -----------------------------------------------------------------------------
time_point_floor(x, "day", n = 60)

## -----------------------------------------------------------------------------
unclass(x[1])

## -----------------------------------------------------------------------------
x <- seq(as_naive_time(year_month_day(2019, 1, 1)), by = 3, length.out = 10)
x

thursdays <- time_point_floor(x, "day", n = 14)
thursdays

as_weekday(thursdays)

## -----------------------------------------------------------------------------
origin <- as_naive_time(year_month_day(2018, 12, 31))
as_weekday(origin)

mondays <- time_point_floor(x, "day", n = 14, origin = origin)
mondays

as_weekday(mondays)

## -----------------------------------------------------------------------------
x <- seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by = 20)

date_floor(x, "day", n = 60)

## -----------------------------------------------------------------------------
x <- seq(as.Date("2019-01-01"), by = 3, length.out = 10)

origin <- as.Date("2018-12-31")

date_floor(x, "week", n = 2, origin = origin)

## -----------------------------------------------------------------------------
x <- year_month_day(2019, clock_months$july, 4)

yd <- as_year_day(x)
yd

get_day(yd)

## -----------------------------------------------------------------------------
x <- as.Date("2019-07-04")

x %>%
  as_year_day() %>%
  get_day()

## -----------------------------------------------------------------------------
x <- "2020-10-25 01:30:00 IST"

zoned_time_parse_abbrev(x, "Asia/Kolkata")
zoned_time_parse_abbrev(x, "Asia/Jerusalem")

## -----------------------------------------------------------------------------
x <- naive_time_parse(x)
x

## -----------------------------------------------------------------------------
naive_find_by_abbrev <- function(x, abbrev) {
  if (!is_naive_time(x)) {
    abort("`x` must be a naive-time.")
  }
  if (length(x) != 1L) {
    abort("`x` must be length 1.")
  }
  if (!rlang::is_string(abbrev)) {
    abort("`abbrev` must be a single string.")
  }
  
  zones <- tzdb_names()
  info <- naive_time_info(x, zones)
  info$zones <- zones
  
  c(
    compute_uniques(x, info, abbrev),
    compute_ambiguous(x, info, abbrev)
  )
}

compute_uniques <- function(x, info, abbrev) {
  info <- info[info$type == "unique",]
  
  # If the abbreviation of the unique time matches the input `abbrev`,
  # then that candidate zone should be in the output
  matches <- info$first$abbreviation == abbrev
  zones <- info$zones[matches]
  
  lapply(zones, as_zoned_time, x = x)
}

compute_ambiguous <- function(x, info, abbrev) {
  info <- info[info$type == "ambiguous",]

  # Of the two possible times,
  # does the abbreviation of the earliest match the input `abbrev`?
  matches <- info$first$abbreviation == abbrev
  zones <- info$zones[matches]
  
  earliest <- lapply(zones, as_zoned_time, x = x, ambiguous = "earliest")
  
  # Of the two possible times,
  # does the abbreviation of the latest match the input `abbrev`?
  matches <- info$second$abbreviation == abbrev
  zones <- info$zones[matches]
  
  latest <- lapply(zones, as_zoned_time, x = x, ambiguous = "latest")
  
  c(earliest, latest)
}

## -----------------------------------------------------------------------------
candidates <- naive_find_by_abbrev(x, "IST")
candidates

## -----------------------------------------------------------------------------
as_zoned_time(x, "Asia/Kolkata")
as_zoned_time(x, "Europe/Dublin", ambiguous = "earliest")
as_zoned_time(x, "Asia/Jerusalem", ambiguous = "latest")

## -----------------------------------------------------------------------------
x <- zoned_time_parse_complete("2019-01-01 00:00:00-05:00[America/New_York]")

info <- sys_time_info(as_sys_time(x), zoned_time_zone(x))

# Beginning of the current DST range
as_zoned_time(info$begin, zoned_time_zone(x))

# Beginning of the next DST range
as_zoned_time(info$end, zoned_time_zone(x))

## -----------------------------------------------------------------------------
# Last moment in time in the current DST range
info$end %>%
  add_seconds(-1) %>%
  as_zoned_time(zoned_time_zone(x))

