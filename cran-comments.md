## Test environments

* GitHub Actions (ubuntu-latest): devel, release, oldrel
* GitHub Actions (windows-latest): release, oldrel  
* GitHub Actions (macOS-latest): release
* win-builder: devel, release
* R-hub: ubuntu-latest, windows-latest, macos-latest

## R CMD check results

0 errors | 0 warnings | 3 notes

* This is a resubmission addressing CRAN feedback from July 9, 2025

## Notes

1. **CRAN incoming feasibility**: Shows "New submission" - normal for first-time submissions
2. **utils namespace**: The 'utils' package is used for `utils::globalVariables()` in R/globals.R to declare global variables for NSE contexts. This is standard practice in R packages.
3. **HTML validation problems**: Minor HTML rendering warnings in documentation that do not affect package functionality

## Changes made in response to CRAN feedback

* Fixed "misspelled words" by putting technical terms in single quotes: 'electrocardiographic' and 'HRV' in DESCRIPTION
* Added LICENSE.md to .Rbuildignore to exclude it from package build
* Verified all functionality remains intact with comprehensive testing

## Previous improvements (from initial submission)

* Fixed all function syntax errors and missing return statements
* Corrected improper `requireNamespace()` usage with vectors
* Resolved variable scoping issues in nested functions  
* Improved documentation with proper `@param`, `@return`, and `@examples` tags
* Added comprehensive input validation and error handling
* Fixed DESCRIPTION file to meet CRAN standards
* Added `.Rbuildignore` to exclude development files
* Moved unused dependencies to Suggests
* Added proper global variable declarations
