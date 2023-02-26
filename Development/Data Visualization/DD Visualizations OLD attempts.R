## DD Visualizations OLD attempts

# Creating the TOP 10 rank

```{r}
top10_rank <- playlists_videos %>% 
  slice_max(video_total_views, n = 10) %>% 
  select(video_title, video_total_views) %>% 
  tidyr::separate(video_title, sep = "-", into = c("song", "concert"), remove = FALSE) %>% 
  mutate(song = stringr::str_trim(song), 
         concert = stringr::str_trim(concert),
         video_title_plot = str_c(song, concert, sep = "\n")) %>% 
  dplyr::relocate(video_title_plot, .before = video_total_views)

saveRDS(top10_rank, file = "data/top10_rank.rds")
```

# Creating the TOP 10 rank - Alternative method using factors with forcats

```{r}
top10_rank_fct <- playlists_videos %>%
  select(video_title, video_total_views) %>% 
  tidyr::separate(video_title, sep = "-", into = c("song", "concert"), remove = FALSE) %>% 
  dplyr::mutate(song = stringr::str_trim(song), 
         concert = stringr::str_trim(concert),
         video_title_plot = str_c(song, concert, sep = "\n"),
         video_title_fct_plot = forcats::fct_lump_n(video_title_plot, n = 10, w = video_total_views, other_level = "Remaining Songs"),
         ) %>% 
  group_by(video_title_fct_plot) %>% 
  summarise(video_total_views = sum(video_total_views)) %>%
  arrange(desc(video_total_views)) %>% 
  dplyr::mutate(position = dplyr::case_when(video_title_fct_plot == "Remaining Songs" ~ 11,
                                     TRUE ~ (dplyr::row_number() - 1)),
                video_title_fct_plot = forcats::fct_rev(forcats::fct_reorder(video_title_fct_plot, position)))
  
levels(top10_rank_fct$video_title_fct_plot)


pal <- c("goldenrod1",
         rep("#1F4364", length(top10_rank_fct$video_title_fct_plot)))

ggplot(top10_rank_fct, aes(x = video_total_views, y = video_title_fct_plot, fill = video_title_fct_plot)) +
  geom_col() +
  scale_fill_manual(values = pal, guide = "none") +
  theme_minimal()

# vedere come colorare le barre per playlists



sum(top10_rank_fct$video_total_views)



saveRDS(top10_rank_fct, file = "data/top10_rank_fct.rds")
```

#7 Lollipop with absolute values

```{r}
top10_rank2 <- top10_rank %>% 
  mutate(x2 = fct_reorder(video_title_plot, video_total_views))

saveRDS(top10_rank2, file = "data/top10_rank2.rds")

ggplot(top10_rank2, aes(x = video_title_plot, y = video_total_views)) + 
   geom_segment(aes(x=x2, xend=x2,y=0,yend=video_total_views), color = "#1380A1", size = 4, alpha = .6) +
   geom_point(color = "#1380A1", size = 6) +
    geom_text(aes(label = video_total_views, size = 2, hjust = -0.5)) +
   coord_flip() +
  # Layout Tuning
  # bbc_style() +
  theme_ipsum_rc() +
  scale_color_ipsum() +
  ggtitle("Dead Dogs Songs - Top 10") +
  xlab("") +
  ylab("views")
  # theme(plot.title = element_text(color="red", size=14, face="bold.italic", hjust = -1.5),
        # axis.title.x = element_text(colour = "blue"))
```