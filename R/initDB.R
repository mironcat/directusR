source('R/auth_to_directus.R')
source('R/read_write.R')

#  класс DatabaseInit
DataBaseInit <- R6::R6Class(classname = "DataBaseInit",
                            public = list(
                              db  = NA,
                              base.url = NA,
                              db.info = list(),
                              current.table=NA,
                              auth.status=F,
                              directus.version=9,
                              table.names=NA,
                              durls=NA,
                              initialize = function(db='paleosib',directus.version=9, db.info=NA) {
                                self$db  <- db
                                self$directus.version  <- directus.version
                                if (is.na(db.info)) {
                                  self$db.info <- private$db.temp
                                } else {
                                  self$db.info <- db.info
                                }
                                self$base.url <- self$db.info[[db]]$base.url
                                self$table.names <-self$db.info[[self$db]]$tbl.names
                                self$durls=setNames( as.list(paste0(self$base.url,'items/',self$table.names)),self$table.names )
                              },
                              print = function(...) {
                                cat("Database info: \n")
                                cat("  db: ", self$db, "\n", sep = "")
                                cat("  auth:  ", self$auth.status, "\n", sep = "")
                                cat("  base url:  ", self$base.url, "\n", sep = "")
                                cat("  selected table:  ", self$current.table, "\n", sep = "")
                                cat("  number of tables:  ", length(self$table.names), "\n", sep = "")
                                invisible(self)
                              }
                            ),
                            private = list(
                              access_token = NULL,
                              login  = NULL,
                              password = NULL,
                              db.temp = list(
                                geoloc=list(
                                  base.url="http://geoloc.paleobotany.ru/",
                                  tbl.names=c('sections','levels','strats','references')
                                ),
                                arth=list(
                                  base.url="http://arth.mironcat.tk/",
                                  tbl.names=c('specimens','collections','localities','taxa','reflinks')
                                ),
                                paleobot=list(
                                  base.url="https://paleobot.paleobotany.ru/",
                                  tbl.names=c('specimens','taxa','cabs','trays','boxes')
                                ),
                                paleosib=list(
                                  base.url="http://biogeolog.tk/paleosib/",
                                  tbl.names=c('taxanorm','taxa'),
                                  directus_version=8
                                )
                              )
                            )
)

# добавляем метод get_items
DataBaseInit$set( 'public',
                  'auth',
                  function(login, password)
                  {
                    auth_results<-auth_to_directus(base.url=self$base.url, login, password, directus_version=self$directus.version)
                    auth_results
                    self$auth.status <- is.character(auth_results$access_token)
                    if (self$auth.status) {
                      private$access_token <- auth_results$access_token
                      return(cat("  auth succes!  "))
                    }
                    invisible(self)
                  })
# добавляем метод get_items
DataBaseInit$set( 'public',
                  'get_items',
                  function(tablename, params)
                  {
                    if(!self$auth.status) {
                      return('you are not authentificated')
                    } else {
                      self$current.table <- tablename
                      res<-getRequest(durl =  self$durls[[tablename]], params=params,key =private$access_token)
                      return (res)
                    }

                    invisible(self)
                  }
                )

# добавляем метод create_items
DataBaseInit$set( 'public',
                  'create_items',
                  function(tablename) {
                    self$current.table <- tablename
                    invisible(self)
                  })

paleosibDB <- DataBaseInit$new(db="paleosib", directus.version=8)

paleosibDB$auth(login="534temp@gmail.com", password="LJat9spx")
paleosibDB
taxanorm=paleosibDB$get_items('taxanorm', params="?limit=10")
paleosibDB$base.url
