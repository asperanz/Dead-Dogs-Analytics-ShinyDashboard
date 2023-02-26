***** DATA RETRIEVAL WITHOUT PLAYLISTS USING YOUTUBE DATA API - ANALYSIS *****
  
  
-  STEP 1: Channel Info (422 videos in total)
  
  https://www.googleapis.com/youtube/v3/channels?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=UCYAUkxkaCWJm5yoaKvqpjMQ&part=snippet,contentDetails,statistics&maxResults=15
  
  da qui tiro fuori 'uploads' key = "UUYAUkxkaCWJm5yoaKvqpjMQ" 
  
  
-  STEP 2: **1st page** (with the first 50 videos - resultsPerPage": 50)

**BE CAREFULL: 
** 1. For the first page, in the API call, I use ONLY the 'playlistId = uploads key' NOT the nextPageToken
** 2. The prevPageToken reloads exactly the previous page, but it's different from the nextPageToken used to load the same page the first time  
  
  https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
  
  da qui tiro fuori il primo nextPageToken: "EAAaBlBUOkNESQ" (che e' quello della seconda pagina)
  
  
-  STEP 3: **2nd page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaBlBUOkNESQ&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaBlBUOkNHUQ"
   "prevPageToken": "EAEaBlBUOkNESQ" (che e' quello della prima pagina, che pero' NON e' stato usato nella call dell'API)
   
   
   **N.B. To retrieve the first page using the prevPageToken just call the API using:
   
   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAEaBlBUOkNESQ&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   
-  STEP 4: **3rd page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaBlBUOkNHUQ&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaB1BUOkNKWUI"
   "prevPageToken": "EAEaBlBUOkNHUQ"
   
   
-  STEP 5: **4th page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaB1BUOkNKWUI&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaB1BUOkNNZ0I"
   "prevPageToken": "EAEaB1BUOkNKWUI"
   
   
-  STEP 6: **5th page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaB1BUOkNNZ0I&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaB1BUOkNQb0I"
   "prevPageToken": "EAEaB1BUOkNNZ0I"
   
   
-  STEP 7: **6th page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaB1BUOkNQb0I&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaB1BUOkNLd0M"
   "prevPageToken": "EAEaB1BUOkNQb0I"
   
   
-  STEP 8: **7th page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaB1BUOkNLd0M&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaB1BUOkNONEM"
   "prevPageToken": "EAEaB1BUOkNLd0M"
   
   
-  STEP 9: **8th page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaB1BUOkNONEM&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": "EAAaB1BUOkNKQUQ"
   "prevPageToken": "EAEaB1BUOkNONEM"
   
   
-  STEP 10: **9th page** (with the following 50 videos - resultsPerPage": 50)

   https://www.googleapis.com/youtube/v3/playlistItems?playlistId=UUYAUkxkaCWJm5yoaKvqpjMQ&pageToken=EAAaB1BUOkNKQUQ&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50
   
   "nextPageToken": NULL
   "prevPageToken": "EAEaB1BUOkNKQUQ"
   


---------------------------------------------------------------------------------------------------------------------------------   
* Check videos part parameters


**Parameters

contentDetails
fileDetails
id
liveStreamingDetails
localizations
player
processingDetails
recordingDetails
snippet
statistics
status
suggestions
topicDetails


** contentDetails
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=contentDetails&maxResults=50

items_id
items_content_details_region_restriction_blocked

** fileDetails
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=fileDetails&maxResults=50


** id
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=id&maxResults=50


** liveStreamingDetails
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=liveStreamingDetails&maxResults=50


** localizations
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=localizations&maxResults=50


** player
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=player&maxResults=50


** processingDetails
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=processingDetails&maxResults=50


** recordingDetails
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=recordingDetails&maxResults=50

items_recording_details_recording_date

** snippet
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=snippet&maxResults=50

items_id
items_snippet_published_at
items_snippet_channel_id
items_snippet_title
items_snippet_description
items_snippet_channel_title
items_snippet_tags
items_snippet_category_id

** statistics
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=statistics&maxResults=50

items_id
items_statistics_view_count
items_statistics_like_count
items_statistics_favorite_count
items_statistics_comment_count

** status
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=status&maxResults=50

items_status_privacy_status
items_status_public_stats_viewable
items_status_made_for_kids

** suggestions
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=suggestions&maxResults=50

** topicDetails
https://www.googleapis.com/youtube/v3/videos?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&id=", video_id, "&part=topicDetails&maxResults=50

items_topic_details_topic_categories



---------------------------------------------------------------------------------------------------------------------------------   
* Check playlistItems part parameters


** playlistItems - part=snippet

next_page_token
items_snippet_published_at
items_snippet_channel_id
items_snippet_title
items_snippet_description
items_snippet_channel_title
items_snippet_playlist_id
items_snippet_position
items_snippet_thumbnails_default_url
items_snippet_resource_id_video_id
page_info_total_results
prev_page_token



** playlistItems - part=status

next_page_token
items_snippet_published_at
items_snippet_channel_id
items_snippet_title
items_snippet_description
items_snippet_channel_title
items_snippet_playlist_id
items_snippet_position
items_snippet_thumbnails_default_url
items_snippet_resource_id_video_id
page_info_total_results
prev_page_token
	items_status_privacy_status
	
	
	
------- NOT CONSIDERED -------------------------------------------------------------------	
	
**playlistItems - part=contentDetails

next_page_token
items_snippet_published_at
items_snippet_channel_id
items_snippet_title
items_snippet_description
items_snippet_channel_title
items_snippet_playlist_id
items_snippet_position
items_snippet_thumbnails_default_url
items_snippet_resource_id_video_id
page_info_total_results
prev_page_token
	items_content_details_video_id
	items_content_details_video_published_at



** playlistItems - part=id

next_page_token
items_snippet_published_at
items_snippet_channel_id
items_snippet_title
items_snippet_description
items_snippet_channel_title
items_snippet_playlist_id
items_snippet_position
items_snippet_thumbnails_default_url
items_snippet_resource_id_video_id
page_info_total_results
prev_page_token



---------------------------------------------------------------------------------------------------------------------------------   
* http calls for comments


https://www.googleapis.com/youtube/v3/comments?id=akihV4fq9lM&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&part=snippet&maxResults=50

https://youtube.googleapis.com/youtube/v3/commentThreads?part=snippet%2Creplies&videoId=akihV4fq9lM&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs


-- BUONO PER I COMMENTI DI UN VIDEO
https://www.googleapis.com/youtube/v3/commentThreads?part=snippet%2Creplies&videoId=akihV4fq9lM&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs


-- BUONO PER I COMMENTI DEL CANALE
https://youtube.googleapis.com/youtube/v3/commentThreads?part=snippet&key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&allThreadsRelatedToChannelId=UCYAUkxkaCWJm5yoaKvqpjMQ




---------------------------------------------------------------------------------------------------------------------------------   
* http calls for subscriptions

https://www.googleapis.com/youtube/v3/subscriptions?key=AIzaSyCviXCt3rQPfDaNvuFIaWCE24gNx7q0Dfs&channelId=UC6CV_32l8omBfcliOOQnIew&part=snippet,contentDetails&maxResults=50





---------------------------------------------------------------------------------------------------------------------------------   
* CONCLUSIONS

1. The method to retrieve channels videos (without playlist) using youtube data API WORKS for channels that have playlists as well!
   (like my channel).
   
   The only problem is that with this method I don't have info about playlists obviously and I cannot make statistics on them 