
# Apply Schemas -----------------------------------------------------------
# Dates are complicated bc, especially with cwq that's read from csv, never can be certain of format

build_col_spec <- function(schema) {
  # map schema type names to readr column functions
  col_fns <- list(
    character = col_character, double = col_double, integer = col_integer,
    logical = col_logical, date = col_date, time = col_time, datetime = col_datetime
  )
  
  # build one readr column spec per schema column, named by source column name
  do.call(cols, setNames(
    lapply(schema$columns, function(c) {
      # date with multiple formats: read as text, parsed later in apply_schema()
      if (identical(c$type, 'date') && length(c$format) > 1) return(col_character())
      
      fn <- col_fns[[c$type]]
      if (is.null(fn)) stop('unknown type: ', c$type)
      
      # pass the format if the schema gives one (e.g. a single date format)
      if (!is.null(c$format)) fn(format = c$format) else fn()
    }),
    vapply(schema$columns, `[[`, '', 'source')
  ))
}

# parse dates trying each format in order; stop if any value matches none
parse_multi_date <- function(x, formats) {
  # start with all NA dates
  out <- as.Date(rep(NA_character_, length(x)))
  
  # try each format on values not yet parsed (blank cells stay NA)
  for (f in formats) {
    todo <- is.na(out) & !is.na(x)
    out[todo] <- as.Date(x[todo], format = f)
  }
  
  # stop instead of silently returning NA for unrecognized dates
  failed <- unique(x[is.na(out) & !is.na(x)])
  if (length(failed)) {
    stop('dates not matching any format: ', paste(head(failed, 5), collapse = ', '))
  }
  
  out
}

apply_schema <- function(df, schema) {
  # rename source column names to schema names
  rename_map <- setNames(
    vapply(schema$columns, `[[`, '', 'source'), names(schema$columns))
  
  # stop if any expected source column isn't in the file
  missing <- setdiff(unname(rename_map), names(df))
  if (length(missing))
    stop('expected source columns missing: ', paste(missing, collapse = ', '))
  df <- dplyr::rename(df, !!!rename_map)
  
  # parse date columns that list multiple formats
  multi_date <- names(Filter(
    function(c) identical(c$type, 'date') && length(c$format) > 1,
    schema$columns
  ))
  for (col in multi_date) {
    df[[col]] <- parse_multi_date(df[[col]], schema$columns[[col]]$format)
  }
  
  # convert columns marked `as: date` in the schema to Date
  to_date <- names(Filter(function(c) identical(c$as, 'date'), schema$columns))
  if (length(to_date))
    df <- dplyr::mutate(df, dplyr::across(dplyr::all_of(to_date), as.Date))
  
  df
}

read_typed <- function(schema, reader) {
  apply_schema(reader(build_col_spec(schema)), schema)
}