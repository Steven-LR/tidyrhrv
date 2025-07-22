test_that("prep_data standardizes column names correctly", {
  # Skip if required packages aren't available
  skip_if_not_installed("dplyr")
  skip_if_not_installed("purrr")
  
  # Create toy nested data frame similar to read_tilt output
  toy_data <- data.frame(
    time_col = seq(0, 5, by = 0.8),
    heart_rate = 75 + rnorm(7, 0, 2),
    rr_interval = 60/75 + rnorm(7, 0, 0.03)
  )
  
  nested_data <- data.frame(
    names = "test_file.csv",
    stringsAsFactors = FALSE
  )
  nested_data$contents <- list(toy_data)
  
  # Test prep_data function
  result <- prep_data(nested_data, "time_col", "heart_rate", "rr_interval")
  
  # Check structure
  expect_s3_class(result, "data.frame")
  expect_true("names" %in% names(result))
  expect_true("contents" %in% names(result))
  
  # Check that column names are standardized
  standard_names <- names(result$contents[[1]])
  expect_true("Time" %in% standard_names)
  expect_true("niHR" %in% standard_names)
  expect_true("RR" %in% standard_names)
  expect_equal(length(standard_names), 3)
})

test_that("prep_data handles errors gracefully", {
  # Test with missing arguments
  expect_error(prep_data())
  expect_error(prep_data(data.frame()))
  
  # Test with invalid column names
  toy_data <- data.frame(a = 1, b = 2, c = 3)
  nested_data <- data.frame(names = "test")
  nested_data$contents <- list(toy_data)
  
  expect_error(prep_data(nested_data, "invalid_col", "b", "c"))
}) 