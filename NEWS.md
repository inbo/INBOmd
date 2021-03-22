# INBOmd 0.4.10

* Use pandoc to render citations with `inbo_rapport()` on pdf instead of natbib
  (#63, @ThierryO).
* `inbo_rapport()` support custom languages when using `style = "Flanders"`
  (#64, @ThierryO).
* Update CSL style to most recent version (#63, @florisvdh).
* Add colofon to INBO reports in pdf and gitbook formats.

# INBOmd 0.4.9

* Update CSL style to most recent version (#61, @thierryo).
* Slides template allows different aspect ratios (#60, @thierryo).

# INBOmd 0.4.8 (2020-05-12)

* bugfix in `dyn_table()` function
* bugfix in `inbo_rapport()` function
* overhaul of the csl and bst citation styles
* minor tweaks in gitbook, epub and LaTeX styles for reports
* upgrade to Roxygen 7.1.0
* upgrade Docker image
* bugfix in CI

# INBOmd 0.4.7

* new `dyn_table()` function
* some tweaks to the report styles

# INBOmd 0.4.6

* slides gains a logo argument
* add report templates with Flemish corporate identity in Dutch and English
* update Flanders Art font

# INBOmd 0.4.5

* `inbo_rapport()` gains a `tocdepth` argument
* updated installation instructions

# INBOmd 0.4.4

* INBO theme for English presentation

# INBOmd 0.4.3

* add `inbo_poster()`
* add `inbo_report_css()`
* add report template for gitbook
* import report template for pdf
* create addins for RStudio

# INBOmd 0.4.2

* `inbo_rapport()` gains a `flandersfont` argument
* natbib citation style is updated
* hyperlinks have a bluish colour instead of fuchsia
* LaTeX style for inbo_rapport updated
* draft of gitbook style for inbo_rapport
* draft of epub style for inbo_rapport

# INBOmd 0.4.1.1

* `inbo_rapport()` now handles UTF-8 strings (like éëèï...) correctly
* the package now displays at warning message at startup about the configuration
