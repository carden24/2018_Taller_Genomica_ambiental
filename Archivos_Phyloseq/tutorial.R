rm(list=ls()) 


setwd("E:/Libraries/Dropbox/tutorial/")

data="a"
data2="B"

save.image("Toda_la_session.RData")
save(data, file="un_objeto.Rdata")


load("Toda_la_session.RData")
load("un_objeto.Rdata")



library(phyloseq)







data("GlobalPatterns")
