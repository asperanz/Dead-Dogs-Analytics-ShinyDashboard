library(tidyverse)
library(magrittr)
library(plotly) # BE CAREFUL!! load plotly pkg before httr pkg
library(janitor)
library(jsonlite)
library(httr)
library(feather)

## Set environment variables (for this R session)


google_api_key <- Sys.getenv("GOOGLE_API_KEY")
oauth2_key <- Sys.getenv("OAUTH2_KEY")
oauth2_secret <- Sys.getenv("OAUTH2_SECRET")


# Real Time Data Section

## get_channel info using YouTube Data API - Real Time Data

channel_id <- "UC6CV_32l8omBfcliOOQnIew"

api_call_channel <- str_c("https://www.googleapis.com/youtube/v3/channels?key=",google_api_key,"&id=",channel_id,"&part=snippet,contentDetails,statistics&maxResults=15")

api_result_channel <- httr::GET(api_call_channel)

json_result_channel <- httr::content(api_result_channel, "text", encoding="UTF-8")

# Process the raw data into a data frame

json_channel <- jsonlite::fromJSON(json_result_channel, flatten = T)

channel_info <- base::as.data.frame(json_channel) %>% 
  janitor::clean_names()


## get_playlists info using YouTube Data API - Real Time Data


api_call_playlists <- str_c("https://www.googleapis.com/youtube/v3/playlists?key=",google_api_key,"&channelId=UC6CV_32l8omBfcliOOQnIew&part=snippet,contentDetails,player,status&maxResults=15")

api_result_playlists <- httr::GET(api_call_playlists)

json_result_playlists <- httr::content(api_result_playlists, "text", encoding="UTF-8")

# Process the raw data into a data frame

json_playlists <- jsonlite::fromJSON(json_result_playlists, flatten = T)

playlists <- base::as.data.frame(json_playlists) %>% 
  janitor::clean_names() %>%
  dplyr::rename(playlist_id = items_id
                ,playlist_published_date = items_snippet_published_at
                ,channel_id = items_snippet_channel_id
                ,playlist_title = items_snippet_title
                ,playlist_description = items_snippet_description
                ,channel_title = items_snippet_channel_title
                ,playlist_status = items_status_privacy_status
                ,playlist_videos_count = items_content_details_item_count
                ,playlist_embed_html = items_player_embed_html
  ) %>% 
  dplyr::select(playlist_id
                ,playlist_title
                ,playlist_description
                ,playlist_published_date
                ,playlist_status
                ,playlist_videos_count
                ,channel_id
                ,channel_title
                ,playlist_embed_html)

playlists_vector <- playlists %>%
  dplyr::select (playlist_id) %>%
  dplyr::pull()


## Get all the items in all the playlists of a channel - Real Time Data


get_all_playlist_items <- function(playlist_id) {
  
  api_call_playlistItems <- str_c("https://www.googleapis.com/youtube/v3/playlistItems?key=",google_api_key,"&playlistId=", playlist_id,"&part=snippet,status&maxResults=50")
  
  api_result_playlistItems <- httr::GET(api_call_playlistItems)
  
  json_result_playlistItems <- httr::content(api_result_playlistItems, "text", encoding="UTF-8")
  
  # Process the raw data into a data frame
  
  json_playlistItems <- jsonlite::fromJSON(json_result_playlistItems, flatten = T)
  
  playlistItems <- base::as.data.frame(json_playlistItems) %>%
    janitor::clean_names()
  
}

all_playlist_items <- purrr::map_df(playlists_vector, get_all_playlist_items) %>%
  dplyr::filter(items_snippet_title != "Deleted video") %>% # condition to avoid the videos deleted
  dplyr::rename(playlist_id = items_snippet_playlist_id
                ,video_id = items_snippet_resource_id_video_id
                ,video_title = items_snippet_title
                ,video_description = items_snippet_description
                ,video_published_date = items_snippet_published_at
                ,video_status = items_status_privacy_status
                ,playlist_video_position = items_snippet_position
                ,playlist_total_videos = page_info_total_results
                ,channel_id = items_snippet_channel_id
                ,channel_title = items_snippet_channel_title
  ) %>% 
  dplyr::select(video_id
                ,video_title
                ,video_description
                ,video_published_date
                ,video_status
                ,playlist_id
                ,playlist_video_position
                ,playlist_total_videos
                ,channel_id
                ,channel_title
  )

all_video_ids_vector <- all_playlist_items %>% 
  dplyr::select (video_id) %>%
  dplyr::pull()


## Get all the videos stats - Real Time Data


get_all_videos_info <- function(video_id) {
  
  api_call_videos <- str_c("https://www.googleapis.com/youtube/v3/videos?key=",google_api_key,"&id=", video_id, "&part=contentDetails,recordingDetails,snippet,statistics,status,topicDetails&maxResults=50") 
  
  api_result_videos <- httr::GET(api_call_videos)
  
  json_result_videos <- httr::content(api_result_videos, "text", encoding="UTF-8")
  
  # Process the raw data into a data frame
  
  json_videos <- jsonlite::fromJSON(json_result_videos, flatten = T)
  
  videos <- base::as.data.frame(json_videos) %>% 
    janitor::clean_names()  
  
}

all_videos_stats <- purrr::map_df(all_video_ids_vector, get_all_videos_info) %>% 
  dplyr::mutate(items_statistics_view_count = as.integer(items_statistics_view_count)
                ,items_statistics_like_count = as.integer(items_statistics_like_count)
                ,items_statistics_favorite_count = as.integer(items_statistics_favorite_count)
                ,items_statistics_comment_count = as.integer(items_statistics_comment_count)
  ) %>%
  dplyr::rename(video_id = items_id
                ,views = items_statistics_view_count
                ,likes = items_statistics_like_count
                ,favorites = items_statistics_favorite_count
                ,comments = items_statistics_comment_count
  ) %>% 
  dplyr::select(video_id
                ,views
                ,likes
                ,favorites
                ,comments
  )

# N.B. 'items_statistics_dislike_count' has been deprecated


## Join playlist info & video stats - Real Time Data


playlists_videos <- playlists %>%
  dplyr::inner_join(all_playlist_items, by = "playlist_id") %>%  
  dplyr::inner_join(all_videos_stats, by = "video_id") %>%
  dplyr::mutate(video_published_date = as.Date(video_published_date)
                ,video_total_views = views
                ,video_total_likes = likes
                ,channel_id = channel_id.x
                ,channel_title = channel_title.x
  ) %>%
  dplyr::select(video_id
                ,video_title
                ,video_description
                ,video_published_date
                ,video_total_views
                ,video_total_likes
                ,playlist_id
                ,playlist_title
                ,channel_id
                ,channel_title
  ) %>%
  dplyr::arrange(desc(video_total_views)) %>% 
  feather::write_feather("Development/Data Retrieval/data/dda_playlists_videos_gha.feather")
