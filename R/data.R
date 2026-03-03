#' @title Estimated Maximum Floodplain Acres
#' @name floodplain_acres
#' @description This data object summarizes the theoretical maximum inundation for chosen reaches in the Klamath basin as well as the potential agricultural impacts
#' @format A tibble with 4 rows and 4 columns
#' \itemize{
#'   \item{\code{location}: name of the stream or river - sprague river, williamson river, scott river, wood river
#'   \item{\code{inundated_acres}: estimated maximum inundation acreage using the "bath tub" DEM approach
#'   \item{\code{field_acres}: the estimated acreage of agricultural fields that would be impacted by inundation; source: https://www.dri.edu/project/owrd-et/
#'   \item{\code{n_fields_touched}: the number of agricultural fields impacted by inundation; source: https://www.dri.edu/project/owrd-et/
#' }
'floodplain_acres'

#' @title Irrigation Volume by Month and Year
#' @name all_irr_summary
#' @description This table summarizes the total estimated irrigation volume (using OpenET; source: https://www.dri.edu/project/owrd-et/) for all fields impacted by potential maximum inundation. A threshold of 30% was used to determine which fields were impacted.
#' @format A tibble with 1368 rows and 6 columns
#' \itemize{
#'   \item{\code{location}: name of the stream or river - sprague river, williamson river, scott river, wood river
#'   \item{\code{year}: calendar year of estimate
#'   \item{\code{month}: month of estimate
#'   \item{\code{irr_vol_acft}: irrigation volume (total for all fields impacted for each year, month); source: https://www.dri.edu/project/owrd-et/
#'   \item{\code{water_year}: water year
#'   \item{\code{date}: date
#' }
'all_irr_summary'
