# Get EDI URL
get_edi_url <- function(pkg_id, revision_num = "current") {
  if (revision_num == "current") {
    edi_url <- glue::glue("https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}")
  } else {
    edi_url <- glue("https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier={pkg_id}&revision={revision_num}")
  }
  
  return(edi_url)
}


# get API key
# # must have API key saved as an environment variable if running locally (defaults "EDI_API_KEY")
# # also can save as repo secret if using GitHub Actions
edi_get <- function(url, key_name = "EDI_API_KEY") {
  request(url) %>%
    req_url_query(key = Sys.getenv(key_name)) %>%
    req_perform()
}

# check latest revision for targets
edi_latest_revision <- function(pkg_id, scope = "edi", key_name = "EDI_API_KEY") {
  revisions <- edi_get(
    sprintf("https://pasta.lternet.edu/package/eml/%s/%s", scope, pkg_id),
    key_name
  ) |> resp_body_string()
  max(as.numeric(strsplit(trimws(revisions), "\n")[[1]]))
}

# get EDI file
# # match type: use "regex" if the name isn't consistent (eg. updates annually)
get_edi_file <- function(pkg_id, fname, scope = "edi", match_type = c("exact", "regex"),
                         col_types = NULL, key_name = "EDI_API_KEY", revision = NULL) {
  match_type <- match.arg(match_type)
  base <- "https://pasta.lternet.edu/package"
  
  revisions <- edi_get(sprintf("%s/eml/%s/%s", base, scope, pkg_id), key_name) %>%
    resp_body_string()
  latest_revision <- revision %||% edi_latest_revision(pkg_id, scope, key_name)
  
  entities <- edi_get(sprintf("%s/data/eml/%s/%s/%s", base, scope, pkg_id, latest_revision), key_name) %>%
    resp_body_string()
  entities <- strsplit(trimws(entities), "\n")[[1]]
  
  # rate limit to be nicer to servers; technically optional
  get_name <- purrr::slowly(function(entity_id) {
    edi_get(sprintf("%s/name/eml/%s/%s/%s/%s", base, scope, pkg_id, latest_revision, entity_id), key_name) %>%
      resp_body_string() %>% trimws()
  }, purrr::rate_delay(pause = 0.2))
  
  is_match <- function(name) {
    if (match_type == "regex") grepl(fname, name) else identical(name, fname)
  }
  
  matched <- purrr::keep(entities, ~ is_match(get_name(.x)))
  if (length(matched) == 0) {
    stop(sprintf("No entity matching '%s' (%s) in %s.%s.%s",
                 fname, match_type, scope, pkg_id, latest_revision))
  }
  entity_id <- matched[[1]]
  
  raw <- edi_get(sprintf("%s/data/eml/%s/%s/%s/%s", base, scope, pkg_id, latest_revision, entity_id), key_name) %>%
    resp_body_raw()
  readr::read_csv(raw, show_col_types = FALSE, col_types = col_types, lazy = FALSE)
}


# Read in EDI file (old, can update when EDIutils allows API keys)
# get_edi_file <- function(pkg_id, fname, scope = 'edi') {
#   # get latest revision
#   revisions <- EDIutils::list_data_package_revisions(scope = "edi", identifier = pkg_id)
#   latest_revision <- max(as.numeric(revisions))
#   package_id_str <- glue::glue("{scope}.{pkg_id}.{latest_revision}")
#   
#   # get entity IDs
#   entities <- EDIutils::list_data_entities(packageId = package_id_str)
#   
#   # slow wrapper (avoid rate limit)
#   slow_read <- purrr::slowly(EDIutils::read_data_entity_name, purrr::rate_delay(pause = 1))
#   
#   # find the matching entity
#   matched <- purrr::keep(entities, function(entity_id) {
#     entity_name <- slow_read(packageId = package_id_str, entityId = entity_id)
#     identical(entity_name, fname)
#   })
#   
#   if (length(matched) == 0) {
#     stop(glue::glue("File '{fname}' not found in package edi.{pkg_id}.{latest_revision}"))
#   }
#   
#   # construct download URL and read csv
#   entity_id <- matched[[1]]
#   file_url <- glue::glue("https://pasta.lternet.edu/package/data/eml/{scope}/{pkg_id}/{latest_revision}/{entity_id}")
#   df <- readr::read_csv(file_url, guess_max = 1000000, show_col_types = FALSE)
#   
#   return(df)
# }