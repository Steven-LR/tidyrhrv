test_that("read_tilt works with toy CSV data", {
  # Skip if required packages aren't available
  skip_if_not_installed("dplyr")
  skip_if_not_installed("tibble")
  skip_if_not_installed("purrr")
  
  # Create temporary directory and toy data
  temp_dir <- tempdir()
  
  # Generate toy HRV data
  hrv_data1 <- data.frame(
    Time = seq(0, 10, by = 0.8),
    HR = 70 + rnorm(13, 0, 3),
    RR = 60/70 + rnorm(13, 0, 0.05)
  )
  
  hrv_data2 <- data.frame(
    Time = seq(0, 8, by = 0.7),
    HR = 80 + rnorm(12, 0, 2),
    RR = 60/80 + rnorm(12, 0, 0.04)
  )
  
  # Write toy data files
  write.csv(hrv_data1, file.path(temp_dir, "test1.csv"), row.names = FALSE)
  write.csv(hrv_data2, file.path(temp_dir, "test2.csv"), row.names = FALSE)
  
  # Test read_tilt function
  result <- read_tilt(temp_dir, read.csv)
  
  # Basic checks
  expect_s3_class(result, "data.frame")
  expect_true("names" %in% names(result))
  expect_true("contents" %in% names(result))
  expect_gte(nrow(result), 2)  # Should have at least our 2 test files
  
  # Check that contents are data frames
  expect_s3_class(result$contents[[1]], "data.frame")
  
  # Clean up
  unlink(file.path(temp_dir, c("test1.csv", "test2.csv")))
})

test_that("read_tilt handles errors gracefully", {
  # Test with non-existent directory
  expect_error(read_tilt("/non/existent/path", read.csv))
  
  # Test with missing arguments
  expect_error(read_tilt())
  expect_error(read_tilt("path"))
}) 