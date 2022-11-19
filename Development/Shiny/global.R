library(tidyverse)
library(httr)
library(jsonlite)
  
# DATA RETRIEVAL


# Google Authentication
endpoints <- oauth_endpoints("google")

# IMPORTANT! Connect to Google with Alessandro Speranza account
myapp <- httr::oauth_app("dead-dogs-analytics-311702",
                   key = "930372143435-m3db5ec7dl300guvbu5i3o5khk6g6fpe.apps.googleusercontent.com",
                   secret = "BijkxeCom14MlLYtW-vfofEh")

access_token <- httr::oauth2.0_token(endpoints, myapp, scope = "https://www.googleapis.com/auth/yt-analytics.readonly")



# get_channel info using YouTube Data API - Real time Data
api_call_channel <- "https://www.googleapis.com/youtube/v3/channels?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=UC6CV_32l8omBfcliOOQnIew&part=snippet,contentDetails,statistics&maxResults=15"

api_result_channel <- httr::GET(api_call_channel)

json_result_channel <- httr::content(api_result_channel, "text", encoding="UTF-8")

# Process the raw data into a data frame
json_channel <- jsonlite::fromJSON(json_result_channel, flatten = T)

channels <- as.data.frame(json_channel) %>% 
  janitor::clean_names()
  


# get_playlists info using YouTube Data API - Real time Data
api_call_playlists <- "https://www.googleapis.com/youtube/v3/playlists?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&channelId=UC6CV_32l8omBfcliOOQnIew&part=snippet,contentDetails,player,status&maxResults=15"

api_result_playlists <- httr::GET(api_call_playlists)

json_result_playlists <- httr::content(api_result_playlists, "text", encoding="UTF-8")

# Process the raw data into a data frame
json_playlists <- jsonlite::fromJSON(json_result_playlists, flatten = T)

playlists <- as.data.frame(json_playlists) %>% 
  janitor::clean_names() %>%
  dplyr::rename(playlist_id = items_id,
         playlist_published_date = items_snippet_published_at,
         channel_id = items_snippet_channel_id,
         playlist_title = items_snippet_title,
         playlist_description = items_snippet_description,
         channel_title = items_snippet_channel_title,
         playlist_status = items_status_privacy_status,
         playlist_videos_count = items_content_details_item_count,
         playlist_embed_html = items_player_embed_html
  ) %>% 
  dplyr::select(playlist_id,
         playlist_title,
         playlist_description,
         playlist_published_date,
         playlist_status,
         playlist_videos_count,
         channel_id,
         channel_title,
         playlist_embed_html)

playlists_vector <- playlists %>%
  dplyr::select (playlist_id) %>%
  dplyr::pull()



# Get all the items in all the playlists of a channel - Real time Data
get_all_playlist_items <- function(playlist_id) {
  
api_call_playlistItems <- str_c("https://www.googleapis.com/youtube/v3/playlistItems?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&playlistId=", playlist_id,"&part=snippet,status&maxResults=50")

api_result_playlistItems <- httr::GET(api_call_playlistItems)

json_result_playlistItems <- httr::content(api_result_playlistItems, "text", encoding="UTF-8")

# Process the raw data into a data frame
json_playlistItems <- jsonlite::fromJSON(json_result_playlistItems, flatten = T)

playlistItems <- as.data.frame(json_playlistItems) %>%
  janitor::clean_names()

}

all_playlist_items <- purrr::map_df(playlists_vector, get_all_playlist_items) %>% 
  dplyr::rename(playlist_id = items_snippet_playlist_id,
         video_id = items_snippet_resource_id_video_id,
         video_title = items_snippet_title,
         video_description = items_snippet_description,
         video_published_date = items_snippet_published_at,
         video_status = items_status_privacy_status,
         playlist_video_position = items_snippet_position,
         playlist_total_videos = page_info_total_results,
         channel_id = items_snippet_channel_id,
         channel_title = items_snippet_channel_title) %>% 
  dplyr::select(video_id,
         video_title,
         video_description,
         video_published_date,
         video_status,
         playlist_id,
         playlist_video_position,
         playlist_total_videos,
         channel_id,
         channel_title)

all_video_ids_vector <- all_playlist_items %>% 
  dplyr::select (video_id) %>%
  dplyr::pull()



# Get all the videos stats - Real time Data
get_all_videos_info <- function(video_id) {
  
  api_call_videos <- str_c("https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=statistics&maxResults=50")
  
  api_result_videos <- httr::GET(api_call_videos)
  
  json_result_videos <- httr::content(api_result_videos, "text", encoding="UTF-8")
  
  # Process the raw data into a data frame
  json_videos <- fromJSON(json_result_videos, flatten = T)
  
  videos <- as.data.frame(json_videos) %>% 
    janitor::clean_names()  
  
}

all_videos_stats <- map_df(all_video_ids_vector, get_all_videos_info) %>% 
  mutate(items_statistics_view_count = as.integer(items_statistics_view_count),
         items_statistics_like_count = as.integer(items_statistics_like_count),
         # items_statistics_dislike_count = as.integer(items_statistics_dislike_count),
         items_statistics_favorite_count = as.integer(items_statistics_favorite_count),
         items_statistics_comment_count = as.integer(items_statistics_comment_count)) %>%
  rename(video_id = items_id,
         views = items_statistics_view_count,
         likes = items_statistics_like_count,
         # dislikes = items_statistics_dislike_count,
         favorites = items_statistics_favorite_count,
         comments = items_statistics_comment_count) %>% 
  select(video_id, 
         views, 
         likes, 
         # dislikes, 
         favorites,
         comments)
