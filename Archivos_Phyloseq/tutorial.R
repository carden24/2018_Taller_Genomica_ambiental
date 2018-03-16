rm(list=ls()) 


setwd("E:/Libraries/Dropbox/tutorial/")

data="a"
data2="B"

save.image("Toda_la_session.RData")
save(data, file="un_objeto.Rdata")


load("Toda_la_session.RData")
load("un_objeto.Rdata")



library(phyloseq)
library(ggplot2)



# Crear variables para los archivos que exportamos de *Mothur*

shared_file = "stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.opti_mcc.unique_list.shared"
tax_file = "stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.opti_mcc.unique_list.0.03.cons.taxonomy"
metadata_file = "mouse.dpw.metadata"
tree_file = "stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.phylip.tre"

# Import mothur data
mothur_data <- import_mothur(mothur_shared_file = shared_file,
                             mothur_constaxonomy_file = tax_file)

# Import sample metadata
metadata <- read.delim2(metadata_file, header=TRUE)

head(map)
summary(map)
str(map)

head(mothur_data)
summary(map)
str(map)



data("GlobalPatterns")
