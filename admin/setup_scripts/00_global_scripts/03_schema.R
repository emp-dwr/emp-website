
# Apply Schemas -----------------------------------------------------------

build_col_spec <- function(schema) {
  col_fns <- list(
    character = col_character, double = col_double, integer = col_integer,
    logical = col_logical, date = col_date, time = col_time, datetime = col_datetime
  )
  do.call(cols, setNames(
    lapply(schema$columns, function(c) {
      fn <- col_fns[[c$type]]; if (is.null(fn)) stop('unknown type: ', c$type)
      if (!is.null(c$format)) fn(format = c$format) else fn()
    }),
    vapply(schema$columns, `[[`, '', 'source')
  ))
}

apply_schema <- function(df, schema) {
  rename_map <- setNames(
    vapply(schema$columns, `[[`, '', 'source'), names(schema$columns))
  missing <- setdiff(unname(rename_map), names(df))
  if (length(missing))
    stop('expected source columns missing: ', paste(missing, collapse = ', '))
  df <- dplyr::rename(df, !!!rename_map)
  
  to_date <- names(Filter(function(c) identical(c$as, 'date'), schema$columns))
  if (length(to_date))
    df <- dplyr::mutate(df, dplyr::across(dplyr::all_of(to_date), as.Date))
  
  df
}

read_typed <- function(schema, reader) {
  apply_schema(reader(build_col_spec(schema)), schema)
}