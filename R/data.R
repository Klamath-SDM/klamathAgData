#' @title Estimated Maximum Floodplain Acres
#' @name floodplain_acres
#' @description This data object summarizes the theoretical maximum inundation
#' for chosen reaches in the Klamath Basin as well as the potential agricultural impacts.
#' See the \link[vignette("floodplain-mapping")]{Floodplain Mapping vignette} for details
#' on the DEM-based inundation approach used to generate these estimates.
#' @format A tibble with 4 rows and 4 columns:
#' \itemize{
#'   \item{\code{location: }}{Name of the stream or river (Sprague River, Williamson River, Scott River, Wood River).}
#'   \item{\code{inundated_acres: }}{Estimated maximum inundation acreage using the "bathtub" DEM approach.}
#'   \item{\code{field_acres: }}{Estimated acreage of agricultural fields that would be impacted by inundation. Source: https://www.dri.edu/project/owrd-et/}
#'   \item{\code{n_fields_touched: }}{Number of agricultural fields impacted by inundation. Source: https://www.dri.edu/project/owrd-et/}
#' }
"floodplain_acres"


#' @title Irrigation Volume by Month and Year
#' @name all_irr_summary
#' @description This table summarizes the total estimated irrigation volume
#' (using OpenET; source: https://www.dri.edu/project/owrd-et/) for all fields
#' impacted by potential maximum inundation. A threshold of 30\% overlap was
#' used to determine which fields were impacted. See the
#' \link[vignette("floodplain-mapping")]{Floodplain Mapping vignette} for the
#' methodology used to generate inundation extents and identify impacted fields.
#' @format A tibble with 1368 rows and 6 columns:
#' \itemize{
#'   \item{\code{location: }}{Name of the stream or river (Sprague River, Williamson River, Scott River, Wood River).}
#'   \item{\code{year: }}{Calendar year of the estimate.}
#'   \item{\code{month: }}{Month of the estimate (1--12).}
#'   \item{\code{irr_vol_acft: }}{Total irrigation volume (acre-feet) for all fields impacted for each year and month. Source: https://www.dri.edu/project/owrd-et/}
#'   \item{\code{water_year: }}{Water year (October--September convention).}
#'   \item{\code{date: }}{Date corresponding to the first day of each month.}
#' }
"all_irr_summary"
