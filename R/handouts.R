#' Use the handout version of slides with the INBO theme
#'
#' Similar to [slides()] except that you can't have progressive slides.
#' And you can place multiple slides on a single page.
#' @inheritParams slides
#' @param nup Number of slides on a page.
#' Defaults to `8`.
#' The 'plus' layouts leave blank space for recipients to make handwritten notes
#' next to each slide.
#' Note that the `2`, `3plus`, `4` and `6` layouts are intended for slides in
#' the 4:3 aspect ratio, while the `3`, `4plus` and `8` layouts are intended for
#' widescreen slides like the 16:10 aspect ratio.
#' @template yaml_generic
#' @template yaml_slide
#' @export
#' @family output
handouts <- function(
  toc = TRUE,
  nup = c("8", "1", "1plus", "2", "3", "3plus", "4", "4plus", "6"), ...
) {
  config <- slides(toc = toc, ...)
  fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
  nup <- ifelse(has_name(fm, "nup"), as.character(fm$nup), nup)
  nup <- match.arg(nup)
  config$pandoc$args <- c(config$pandoc$args,
    pandoc_variable_arg("handout", nup)
  )
  return(config)
}

#' @rdname deprecated
#' @family deprecated
#' @inheritParams slides
#' @inheritParams handouts
#' @export
inbo_handouts <- function(
  toc = TRUE,
  nup = c("8", "1", "1plus", "2", "3", "3plus", "4", "4plus", "6"), ...
) {
  .Deprecated(
    handouts(toc = toc, nup = nup, ...),
    msg = "`inbo_handouts` is deprecated. Use `handouts` instead."
  )
}
