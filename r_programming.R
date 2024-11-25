# Create a function to create a special object that can cache its computation
makeCacheVector <- function(x = numeric()) {
  m <- NULL  # initialize the cache to NULL
  
  # Function to set a new vector
  set <- function(y) {
    x <<- y   # assign the new vector to x
    m <<- NULL # reset cached mean to NULL when the vector changes
  }
  
  # Function to get the current vector
  get <- function() x
  
  # Function to cache the mean
  setmean <- function(mean) m <<- mean
  
  # Function to get the cached mean
  getmean <- function() m
  
  # Return a list of functions to access and manipulate the cache
  list(set = set, get = get, setmean = setmean, getmean = getmean)
}

# Create a function to compute the mean and cache it
cacheMean <- function(x, ...) {
  m <- x$getmean()  # try to get the cached mean
  if(!is.null(m)) {  # if cached mean exists, return it
    message("getting cached data")
    return(m)
  }
  data <- x$get()  # get the current vector
  m <- mean(data, ...)  # compute the mean
  x$setmean(m)  # cache the computed mean
  m  # return the computed mean
}

# Usage Example:
# Create a special object to hold the vector and its cached mean
cacheObj <- makeCacheVector(c(1, 2, 3, 4, 5))

# Compute and cache the mean
meanValue <- cacheMean(cacheObj)  # First time, it computes the mean
print(meanValue)

# Retrieve the cached mean without recomputing
meanValue <- cacheMean(cacheObj)  # This time, it retrieves the cached value
print(meanValue)
