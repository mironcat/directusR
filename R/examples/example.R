### ** Examples

library(directusR)
db1<-initDirectus(db='paleobot')
db1
db1$auth(login="534temp@gmail.com", password="LJat9spxs")
cabs<-db1$get_items('cabs', params="?limit=10")

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
