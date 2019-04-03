library(jsonlite)
library(httr)

# See https://developers.themoviedb.org/3/getting-started/introduction for creating API and query structure

### NB: THIS CODE WILL NOT WORK UNTIL YOU INSERT AN API KEY ON ROW 9 ###

base.url <- "https://api.themoviedb.org/3/discover/movie?"
api.key <- "insert your api key here"

# Create variables that can be changed to vary the query
region.var <- "US" # code is two capital letters, Australia = AU, United States = US
year.var <- 2010
sort.var <- "revenue.desc" # TMDb also offers sorting by popularity, release date and other variables


read.api.page.by.page <- function(x){
  # Function to pull down TMBD data page by page
  # Args:
  # x = page number
  # Returns:
  # data frame with observations from specified page
  page.no <- x
  query <- list(api_key = api.key,  # create a query to use in httr::GET
                region = region.var, 
                primary_release_year = year.var, 
                language = "en-US",
                include_adult = FALSE, 
                include_video = FALSE, 
                sort_by = sort.var,
                page = page.no)
  response <- GET(base.url, query = query)
  tmdb.df.temp <- data.frame(fromJSON(content(response, as = "text")))
  return(tmdb.df.temp)
}

# Initialise the data frame with the first page of results
tmdb.df <- read.api.page.by.page(1)
dim(tmdb.df)  # check the initial data frame has correct number of observations (20 in this case)

# Set the number of pages to read to 5. This will return 100 top grossing movies (20 * 5)
total.pages <- 5

# Use a for loop to run the function through each page. 
for(i in 2:total.pages) {  # Start at page 2 because the data frame already has page 1 in it
  if(total.pages < 2) {   # loop breaks if page number not 2 or more
    break
  } else {
    new.df <- read.api.page.by.page(i)
    if(is.null(dim(new.df))) {   # loop breaks if new.df is empty
      break
    } else {
      tmdb.df <- rbind(tmdb.df, new.df)   # adds new observations to bottom of existing data frame
    }}}

# Check the final data frame has 100 rows
dim(tmdb.df)

# Clean up the table
names(tmdb.df)

# Keep id, title, genre_ids, release_date
tmdb.df.tidy <- tmdb.df[c(5, 8, 13, 17)]
tmdb.df.tidy







