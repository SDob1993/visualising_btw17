require(tidyverse)
require(stringr)
require(lsa)
require(rjson)

source("cleanHashtags.R")

hashtag_pattern <- "#([[:alnum:]]|[_])+"


#select, filter,mutate, rename

hashtagSearch<-twitter_data%>%select(ID,text,twitter.handle,hashtagCount,party)%>%filter(hashtagCount>1)%>%
  mutate(hashtags=str_extract_all(text,hashtag_pattern))%>%mutate(hashtags=cleanHashtags(hashtags))%>%
  select(party,hashtags,hashtagCount)%>%separate(hashtags,into=c("Hashtag1","Hashtag2","Hashtag3","Hashtag4","Hashtag5","Hashtag6","Hashtag7","Hashtag8","Hashtag9","Hashtag10","Hashtag11","Hashtag12","Hashtag13","Hashtag14"),sep="\\,")

#cleaning
hashtagSearchCleaned<-hashtagSearch%>%mutate(Hashtag1=str_replace(Hashtag1,"c+[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag1=str_replace(Hashtag1,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag3=str_replace(Hashtag3,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag4=str_replace(Hashtag4,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag5=str_replace(Hashtag5,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag6=str_replace(Hashtag6,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag7=str_replace(Hashtag7,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag8=str_replace(Hashtag8,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag9=str_replace(Hashtag9,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag10=str_replace(Hashtag10,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag11=str_replace(Hashtag11,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag12=str_replace(Hashtag12,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag13=str_replace(Hashtag13,"[^\\w\\s]+",""))
hashtagSearchCleaned<-hashtagSearchCleaned%>%mutate(Hashtag14=str_replace(Hashtag14,"[^\\w\\s]+",""))

#full matrix
hspre<-hashtagSearchCleaned
#gather
hsmain<-gather(hspre,Hashtag1,Hashtag2,2:(ncol(hspre)))

#rename
colnames(hsmain)<-c("Hashtag1","aaa","Hashtag2")
hsmain<-hsmain%>%select(-aaa)
#filter
hsmain<-hsmain%>%filter(!is.na(Hashtag2))
#wir erstellen einen zweiten dataframe mit umgekehrter Zuordnung, so ist es egal ob der hashtag davor 
#oder danach im Tweet vorgekommen iust. Es zählt nur, dass sie überhaupt zusaamen in einem stehen
hsmain2<-hsmain
colnames(hsmain2)<-c("Hashtag2","Hashtag1")
#bind
hsmain3<-rbind(hsmain,hsmain2)


#re summarise
hsmainfinal<-hsmain3%>%group_by(Hashtag1,Hashtag2)%>%summarise(freq=n())
hsmainfinaltest<-hsmainfinal%>%filter(freq>1)
  
#createJSON
hsmainJson<-toJSON(unname(split(hsmainfinal, 1:nrow(hsmainfinal))))
write(hsmainJson, "hssearch.json")







