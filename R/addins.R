#' Insert a markdown block
#' These functions will add template chunks into your Rmd file. A markdown block will be display as a frame with a title in a different background. There are 3 types of blocks: "block", "exampleblock" and "alertblock".
#' @export
#' @rdname blocks
insert_block <- function() {
  requireNamespace("rstudioapi", quietly = TRUE)
#nolint start
  rstudioapi::insertText('
```{block2 chunk-name, type="block", latex.options="{title}", echo = TRUE}
Enter your Markdown here. Last line should be blank.

```
')
#nolint end
}

#' @export
#' @rdname blocks
insert_exampleblock <- function() {
  requireNamespace("rstudioapi", quietly = TRUE)
  rstudioapi::insertText('
```{block2 the-name, type="exampleblock", latex.options="{title}", echo = TRUE}
Enter your Markdown here. Last line should be blank.

```
')
}

#' @export
#' @rdname blocks
insert_alertblock <- function() {
  requireNamespace("rstudioapi", quietly = TRUE)
#nolint start
  rstudioapi::insertText('
```{block2 chunk-name, type="alertblock", latex.options="{title}", echo = TRUE}
Enter your Markdown here. Last line should be blank.

```
')
#nolint end
}
