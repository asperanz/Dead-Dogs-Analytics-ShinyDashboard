# Example about how append values to a vector 

nextPageToken <- 'EAAaBlBUOkNESQ'

get_all_nextPageTokens <- function (nextPageToken) {
  
  nextPageToken_vector <- nextPageToken
  
   while (!is.null(nextPageToken)) {
    
    api_call_channel_videos_np <- str_c("https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=", nextPageToken, "&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50")

api_result_channel_videos_np <- httr::GET(api_call_channel_videos_np)

json_result_channel_videos_np <- httr::content(api_result_channel_videos_np, "text", encoding="UTF-8")

# Process the raw data into a data frame
json_channel_videos_np <- jsonlite::fromJSON(json_result_channel_videos_np, flatten = T)

nextPageToken <- json_channel_videos_np[["nextPageToken"]]

nextPageToken_vector <- base::append(nextPageToken_vector, nextPageToken)

 }
  
nextPageToken_vector

}


nextPageToken_vector <- get_all_nextPageTokens ('EAAaBlBUOkNESQ')