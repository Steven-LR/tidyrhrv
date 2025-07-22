test_that("plot_tilt input validation works", {
  # Test input validation (these should work even without RHRV)
  expect_error(plot_tilt(), "Argument '.data' is missing")
  expect_error(plot_tilt(data.frame()), "Argument 'folder' is missing")
  expect_error(plot_tilt(data.frame(), "test_folder"), "Argument 'type' is missing")
})

test_that("plot_tilt works with RHRV if available", {
  # Only run this test if RHRV is available
  skip_if_not_installed("RHRV")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("purrr")
  skip_if_not_installed("tibble")
  skip_if_not_installed("tidyr")
  
  # Create minimal toy data in expected format
  toy_data <- data.frame(
    Time = seq(0, 6, by = 0.8),
    niHR = 75 + rnorm(8, 0, 1.5),
    RR = 60/75 + rnorm(8, 0, 0.02)
  )
  
  nested_data <- data.frame(
    names = "test_plot.csv",
    stringsAsFactors = FALSE
  )
  nested_data$contents <- list(toy_data)
  
  # Create temporary plot directory
  temp_dir <- tempdir()
  plot_folder <- "test_plots"
  
  # Test that plot_tilt runs without error (basic smoke test)
  expect_no_error({
    result <- plot_tilt(nested_data, plot_folder, "original")
  })
  
  # Clean up plot directory if it was created
  plot_path <- file.path(getwd(), plot_folder)
  if (dir.exists(plot_path)) {
    unlink(plot_path, recursive = TRUE)
  }
}) 