#OPENET_API_KEY <- "e0hM4q68a4GfAZQ2QrTu6t8Au9OZpE2PNMsJyhuyrngKD8HN3865OQw3798O"

library(sf)
library(dplyr)
library(httr2)
library(jsonlite)
library(purrr)
library(tidyr)
library(stringr)
library(openet)


inund_poly <- scott_inundation$inundation_aggregate
OPENET_API_KEY <- Sys.getenv("OPENET_API_KEY")
stopifnot(nchar(OPENET_API_KEY) > 0)

openet_post <- function(path, body, api_key, base = "https://openet-api.org") {
  req <- request(paste0(base, path)) |>
    req_method("POST") |>
    req_headers(
      "Authorization" = api_key,
      "accept" = "application/json",
      "Content-Type" = "application/json"
    ) |>
    req_body_json(body)

  resp <- req_perform(req)
  raw <- resp_body_raw(resp)

  # Try gzip first
  txt <- tryCatch(
    rawToChar(memDecompress(raw, type = "gzip")),
    error = function(e) NULL
  )

  # If not gzip, try zip
  if (is.null(txt)) {
    tf <- tempfile(fileext = ".zip")
    writeBin(raw, tf)
    td <- tempfile()
    dir.create(td)
    unzip(tf, exdir = td)
    files <- list.files(td, full.names = TRUE, recursive = TRUE)
    # take the first file
    txt <- readChar(files[1], file.info(files[1])$size)
  }

  # content is often JSON-like; parse safely
  fromJSON(txt, simplifyVector = TRUE)
}

sf_to_openet_geometry <- function(poly_sf) {
  sf::sf_use_s2(FALSE)  # avoid s2 strictness during cleanup

  poly_ll <- poly_sf |>
    st_make_valid() |>
    st_collection_extract("POLYGON") |>
    st_transform(4326) |>
    st_union() |>
    st_make_valid()

  coords  <- st_coordinates(poly_ll)

  # keep only X/Y and drop ring/part indices
  xy <- coords[, c("X", "Y"), drop = FALSE]

  # OpenET example shows a flat list: [lon,lat,lon,lat,...]
  as.numeric(t(xy))
}

geom_vec <- sf_to_openet_geometry(inund_poly)

ids_res <- openet_post(
  path = "/geodatabase/metadata/ids",
  body = list(geometry = geom_vec, version = 2.1),
  api_key = OPENET_API_KEY
)

field_ids <- unlist(ids_res)
length(field_ids)

# test <- getOpenET_fields(
#   field_ids = as.character(field_ids[1]),
#   start_date   = '2023-01-01',
#   end_date     = '2023-12-31',
#   model      = 'ensemble',
#   variable = "et",
#   interval = "monthly",
#   units = "in",
#   api_key    = OPENET_API_KEY
# )


safe_getOpenET <- possibly(
  function(fid) {
    getOpenET_fields(
      field_ids  = as.character(fid),
      start_date = '2023-01-01',
      end_date   = '2023-12-31',
      model      = 'ensemble',
      variable   = "et",
      interval   = "monthly",
      units      = "in",
      api_key    = OPENET_API_KEY
    ) %>%
      mutate(field_id = fid)
  },
  otherwise = NULL
)

all_openet_df <- map_dfr(field_ids, safe_getOpenET)

all_openet_df |> glimpse()

# only 398 out of 629 fields worked...
length(unique(all_openet_df$field))

write_csv(all_openet_df, "data-raw/scott_river_fields_et.csv")

# this works:
# etdata <- getOpenET_polygon(
#   geometry     = geom_vec,
#   start_date   = '2023-01-01',
#   end_date     = '2023-12-31',
#   interval     = 'monthly',
#   model        = 'ensemble',
#   reference_et = 'cimis',
#   api_key      = OPENET_API_KEY
# )


