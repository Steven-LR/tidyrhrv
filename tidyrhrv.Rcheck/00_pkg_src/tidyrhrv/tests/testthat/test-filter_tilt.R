test_that("filter_tilt input validation works", {
  # Test input validation (these should work even without RHRV)
  expect_error(filter_tilt(), "Argument '.data' is missing")
  expect_error(filter_tilt(data.frame()), "Argument 'g' must be a numeric")
  expect_error(filter_tilt(data.frame(), "not_numeric", 0.8), "Argument 'g' must be a numeric")
  expect_error(filter_tilt(data.frame(), 1.2, "not_numeric"), "Argument 'l' must be a numeric")
})

test_that("filter_tilt works with RHRV if available", {
  # Only run this test if RHRV and pracma are available
  skip_if_not_installed("RHRV")
  skip_if_not_installed("pracma")
  skip_if_not_installed("dplyr")
  skip_if_not_installed("purrr")
  
  # Create minimal toy data in expected format
  toy_data <- data.frame(
    Time = seq(0, 8, by = 0.8),
    niHR = 70 + rnorm(11, 0, 2),
    RR = 60/70 + rnorm(11, 0, 0.03)
  )
  
  nested_data <- data.frame(
    names = "test_hrv.csv",
    stringsAsFactors = FALSE
  )
  nested_data$contents <- list(toy_data)
  
  # Test that filter_tilt runs without error (basic smoke test)
  # We're not checking exact output since filtering algorithms may vary
  expect_no_error({
    result <- filter_tilt(nested_data, g = 1.2, l = 0.8)
  })
}) 