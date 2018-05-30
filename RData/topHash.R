install.packages("rjson")
install.packages("igraph")
install.packages("ggplot")
require(rjson)
require(tidyverse)
require(stringr)
require(dplyr)
require(igraph)
require(ggplot)
require(stringi)

twitter_rtdata<-read.csv("rt_data.csv")
twitter_data<-read.csv("twitter_data.csv")

hashtag_pattern <- "#([[:alnum:]]|[_])+"

#create df and select
hashtag22<-twitter_data%>%select(ID,text,party,weeksTillElection)%>%
  mutate(hashtags=str_extract_all(text,hashtag_pattern))
hashtag22<-hashtag22%>%unnest()

#clean hashtags
source("cleanHashtags.R")
hashtag22<-hashtag22%>%
  mutate(hashtags=cleanHashtags(hashtags))

topHashtags<-hashtag22%>%
  group_by(party,hashtags,weeksTillElection)%>%
  summarise(freq=n())
topHashtags<-topHashtags%>%filter(weeksTillElection<7)%>%filter(hashtags!="a") #filter
topHashtags<-topHashtags%>%ungroup()%>%group_by(party,weeksTillElection)%>%top_n(5) #top5

topHashtagsJson<-toJSON(unname(split(topHashtags, 1:nrow(topHashtags))))
write(topHashtagsJson, "topHashtags5.json")



