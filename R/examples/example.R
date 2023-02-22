### ** Examples

library(directusR)
db1<-initDirectus(db='paleosib',directus.version = 8)
db1
db1$auth(login="xxxxxxx", password="xxxxxxx")

taxanorm <-db1$get_items(tablename = 'taxanorm', params = '?limit=10')
colls <-db1$get_items(tablename = 'colls', params = '?limit=-1')
dat <- data.frame (
  genus = c("test534")
)

db1$save_one_item(tablename = 'taxanorm',id=6628, dat=dat)
source('R/read_write.R')
test1<-getRequest(durl = 'https://biogeolog.tk/paleosib/items/taxanorm',params = '?limit=5', key = key)
test2<-updateOneRequest(durl = 'https://biogeolog.tk/paleosib/items/taxanorm', id=6628,dat = dat,key =key)



cabs<-db1$get_items('cabs', params="?limit=20")

# or
db2<-initDirectus(db='paleosib', directus.version=8)
db2
db.info <- list(
  arth=list(
    base.url='http://arth.mironcat.tk/',
    tbl.names=c('specimens','collections','localities','taxa','reflinks')
  ),
  myproject = list(
    base.url='http://url.to.myproject/',
    tbl.names=c('table1','table2')
  )
)

db3<-initDirectus(db='myproject', db.info=db.info)
db3
