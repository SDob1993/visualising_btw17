install.packages("rjson")
install.packages("igraph")
require(rjson)
require(tidyverse)
require(stringr)
require(dplyr)
require(igraph)


twitter_rtdata<-read.csv("rt_data.csv")
twitter_data<-read.csv("twitter_data.csv")

hashtag_pattern <- "#([[:alnum:]]|[_])+"

maindf<-twitter_data%>%group_by(twitter.handle,party)%>%summarise(freq = n()) #
colnames(maindf) <- c("name", "party","freq")

rtdf<-twitter_rtdata%>%group_by(twitter.handle.x, twitter.handle.y)%>%summarise(freq = n())

Graphx<-graph_from_data_frame(rtdf,directed = TRUE,vertices = NULL)
pagerank<-page.rank(Graphx, vids = V(Graphx), directed = TRUE,damping = 0.85, weights = NULL, options = igraph.arpack.default)
#getting pagerank using igraph

prdf<-as.data.frame(pagerank) #make df
prdf<-prdf%>%select(vector) #get pagerank
prdf<-prdf%>%mutate(twitter.handle=rownames(prdf)) #mutate the rownames

maindfpr<-left_join(maindf,prdf) #join and rename
colnames(maindfpr)<-c("name","party","freq","pagerank")
colnames(rtdf)<-c("source","target","count")

nodes<-toJSON(unname(split(maindfpr, 1:nrow(maindfpr)))) #make JSON
links<-toJSON(unname(split(rtdf,1:nrow(rtdf))))
write(nodes, "nwnodes.json")
write(links, "nwlinks.json")

rm(twitter_rtdata)
