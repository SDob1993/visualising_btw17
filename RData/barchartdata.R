install.packages("rjson")
install.packages("igraph")
require(rjson)
require(tidyverse)
require(stringr)
require(dplyr)
require(igraph)

#get data and filter
twitter_data_bc<-read.csv("twitter_data.csv")
twitter_data_bc<-twitter_data_bc%>%filter(weeksTillElection<7)

#get party and weets per week
twitter_data_bcparty<-twitter_data_bc%>%select(ID,party,twitter.handle,weeksTillElection)
twitter_data_bcparty<-twitter_data_bcparty%>%group_by(party,weeksTillElection)%>%summarise(freq = n())

#get all tweets per week
twitter_data_bcall<-twitter_data_bc%>%select(ID,twitter.handle,weeksTillElection)
twitter_data_bcall<-twitter_data_bcall%>%group_by(weeksTillElection)%>%summarise(freqall = n())

#join
maindfbc<-left_join(twitter_data_bcparty,twitter_data_bcall)
maindfbc<-maindfbc%>%mutate(percentage=(freq/freqall))

#join db sum
maindfbcsum<-left_join(twitter_data_bcparty,twitter_data_bcall)
maindfbcsumspread<-maindfbcsum%>%spread(weeksTillElection,freq)


#creating df per week
week6<-maindfbc%>%filter(weeksTillElection==6)
week5<-maindfbc%>%filter(weeksTillElection==5)
week4<-maindfbc%>%filter(weeksTillElection==4)
week3<-maindfbc%>%filter(weeksTillElection==3)
week2<-maindfbc%>%filter(weeksTillElection==2)
week1<-maindfbc%>%filter(weeksTillElection==1)
week0<-maindfbc%>%filter(weeksTillElection==0)
week01<-maindfbc%>%filter(weeksTillElection==-1)
week02<-maindfbc%>%filter(weeksTillElection==-2)
week03<-maindfbc%>%filter(weeksTillElection==-3)

week6<-toJSON(unname(split(week6, 1:nrow(week6))))
week5<-toJSON(unname(split(week5, 1:nrow(week5))))
week4<-toJSON(unname(split(week4, 1:nrow(week4))))
week3<-toJSON(unname(split(week3, 1:nrow(week3))))
week2<-toJSON(unname(split(week2, 1:nrow(week2))))
week1<-toJSON(unname(split(week1, 1:nrow(week1))))
week0<-toJSON(unname(split(week0, 1:nrow(week0))))
week01<-toJSON(unname(split(week01, 1:nrow(week01))))
week02<-toJSON(unname(split(week02, 1:nrow(week02))))
week03<-toJSON(unname(split(week03, 1:nrow(week03))))

write(week6, "week6.json")
write(week5, "week5.json")
write(week4, "week4.json")
write(week3, "week3.json")
write(week2, "week2.json")
write(week1, "week1.json")
write(week0, "week0.json")
write(week01, "week01.json")
write(week02, "week02.json")
write(week03, "week03.json")

#sum weeks
week6n<-maindfbc%>%filter(weeksTillElection==6)

week5n<-left_join(week6n,week5,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week5n)<-c("party","weeksTillElection","freq","freqall")

week4n<-left_join(week5n,week4,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week4n)<-c("party","weeksTillElection","freq","freqall")

week3n<-left_join(week4n,week3,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week3n)<-c("party","weeksTillElection","freq","freqall")

week2n<-left_join(week3n,week2,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week2n)<-c("party","weeksTillElection","freq","freqall")

week1n<-left_join(week2n,week1,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week1n)<-c("party","weeksTillElection","freq","freqall")

week0n<-left_join(week1n,week0,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week0n)<-c("party","weeksTillElection","freq","freqall")

week01n<-left_join(week0n,week01,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week01n)<-c("party","weeksTillElection","freq","freqall")

week02n<-left_join(week01n,week02,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week02n)<-c("party","weeksTillElection","freq","freqall")

week03n<-left_join(week02n,week03,by="party")%>%mutate(freq=freq.x+freq.y)%>%mutate(freqall=freqall.x+freqall.y)%>%
  select(party,weeksTillElection.y,freq,freqall)
colnames(week03n)<-c("party","weeksTillElection","freq","freqall")

week6n<-week6n%>%mutate(percentage=freq/freqall)
week5n<-week5n%>%mutate(percentage=freq/freqall)
week4n<-week4n%>%mutate(percentage=freq/freqall)
week3n<-week3n%>%mutate(percentage=freq/freqall)
week2n<-week2n%>%mutate(percentage=freq/freqall)
week1n<-week1n%>%mutate(percentage=freq/freqall)
week0n<-week0n%>%mutate(percentage=freq/freqall)
week01n<-week01n%>%mutate(percentage=freq/freqall)
week02n<-week02n%>%mutate(percentage=freq/freqall)
week03n<-week03n%>%mutate(percentage=freq/freqall)

week6n<-toJSON(unname(split(week6n, 1:nrow(week6n))))
week5n<-toJSON(unname(split(week5n, 1:nrow(week5n))))
week4n<-toJSON(unname(split(week4n, 1:nrow(week4n))))
week3n<-toJSON(unname(split(week3n, 1:nrow(week3n))))
week2n<-toJSON(unname(split(week2n, 1:nrow(week2n))))
week1n<-toJSON(unname(split(week1n, 1:nrow(week1n))))
week0n<-toJSON(unname(split(week0n, 1:nrow(week0n))))
week01n<-toJSON(unname(split(week01n, 1:nrow(week01n))))
week02n<-toJSON(unname(split(week02n, 1:nrow(week02n))))
week03n<-toJSON(unname(split(week03n, 1:nrow(week03n))))

write(week6n, "week6n.json")
write(week5n, "week5n.json")
write(week4n, "week4n.json")
write(week3n, "week3n.json")
write(week2n, "week2n.json")
write(week1n, "week1n.json")
write(week0n, "week0n.json")
write(week01n, "week01n.json")
write(week02n, "week02n.json")
write(week03n, "week03n.json")
