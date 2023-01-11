source('R/auth_to_directus.R', local = T)
source('R/read_write.R',local = T)

#' @title R6 Class REST API of Directus
#'
#' @description
#' Initialization and working with Directus Headless CMS
#'
#' @details
#' A person can also greet you.
#' @export
directusInstance <- R6::R6Class(classname = "directusInstance",
                                public = list(
                                  #' @field db The name of [Directus project](https://docs.directus.io/getting-started/glossary.html#projects)
                                  db  = NA,
                                  #' @field base.url Base url
                                  base.url = NA,
                                  #' @field db.info db.info
                                  db.info = NA,
                                  #' @field current.table current.table
                                  current.table=NA,
                                  #' @field auth.status is authentificated
                                  auth.status=F,
                                  #' @field directus.version version of directus
                                  directus.version=9,
                                  #' @field table.names list of tables
                                  table.names=NA,
                                  #' @field durls urls
                                  durls=NA,
                                  #' @description
                                  #' Create a new directus API instance.
                                  #' @param db a string. The name of [Directus project](https://docs.directus.io/getting-started/glossary.html#projects)
                                  #' @param directus.version Version of Directus.
                                  #' @param db.info H list with information about path to Directus and available tables.
                                  #' @return A new `directusInstance` object.
                                  initialize = function(db,directus.version=9, db.info=NA) {
                                    self$db  <- db
                                    self$directus.version  <- directus.version
                                    if (is.list(db.info)) {
                                      #print("db.info is list. Accept custom database info")
                                      self$db.info <- db.info
                                    } else {
                                      #print("db.info is NA, accept tempDBinfo")
                                      self$db.info <- private$db.temp
                                    }
                                    self$base.url <- self$db.info[[db]]$base.url
                                    self$table.names <-self$db.info[[self$db]]$tbl.names
                                    self$durls=setNames( as.list(paste0(self$base.url,'items/',self$table.names)),self$table.names )
                                  },
                                  #' @description
                                  #' print some information
                                  print = function() {
                                    cat("Database info: \n")
                                    cat("  db: ", self$db, "\n", sep = "")
                                    cat("  auth:  ", self$auth.status, "\n", sep = "")
                                    cat("  base.url:  ", self$base.url, "\n", sep = "")
                                    cat("  selected table:  ", self$current.table, "\n", sep = "")
                                    cat("  number of tables:  ", length(self$table.names), "\n", sep = "")
                                    cat("  directus version: ", self$directus.version, "\n", sep = "")
                                    invisible(self)
                                  },
                                  #' @description
                                  #' Auth
                                  #' @param login a string.
                                  #' @param password a string.
                                  #' @return success message.
                                  #' @examples
                                  #' db<-initDirectus(db='paleobot')
                                  #' db$auth(login="YOUR LOGIN", password="YOUR PASSWORD")
                                  #' #' # expected:
                                  #' # you are authentificated to..
                                  auth =
                                    function(login, password)
                                    {
                                      auth_results<-auth_to_directus(base.url=self$base.url, login, password, directus_version=self$directus.version)
                                      auth_results
                                      self$auth.status <- is.character(auth_results$access_token)
                                      if (self$auth.status) {
                                        private$access_token <- auth_results$access_token
                                        message(cat("Success auth to", self$db,"!"))
                                      } else {
                                        warning(cat("Auth to", self$db, "is failed. Check login, password, and base url"))
                                      }
                                      invisible(self)
                                    },
                                  #' @description
                                  #' Get Items
                                  #' @param tablename a string.
                                  #' @param params a string.
                                  #' @return dataframe with items.
                                  #' @examples
                                  #' db<-initDirectus(db='paleobot')
                                  #' db$auth(login="YOUR LOGIN", password="YOUR PASSWORD")
                                  #' items<-db$get_items('taxa', params="?limit=10")
                                  get_items =
                                    function(tablename, params)
                                    {
                                      if(!self$auth.status) {
                                        warning('you are not authentificated. Please run "auth" method of directus instance')
                                        return (NA)
                                      } else {
                                        self$current.table <- tablename
                                        res<-getRequest(durl =  self$durls[[tablename]], params=params,key =private$access_token)
                                        return (res)
                                      }

                                      invisible(self)
                                    },
                                  #' @description
                                  #' Save Items
                                  #' @param tablename a string.
                                  #' @param id a number. ID of item in database
                                  #' @param dat a dataframe with one row. columns is correspond to fields in database table
                                  #' @return dataframe with updated item.
                                  #' @examples
                                  #' db<-initDirectus(db='paleobot')
                                  #' dat <- data.frame (
                                  #'   id  = c(6628),
                                  #'   genus = c("test2")
                                  #' )
                                  #' db$auth(login="YOUR LOGIN", password="YOUR PASSWORD")
                                  #' items<-db$save_one_item('taxanorm', 6628, dat)
                                save_one_item =
                                  function(tablename, dat, id)
                                  {
                                    if(!self$auth.status) {
                                      warning('you are not authentificated. Please run "auth" method of directus instance')
                                      return (NA)
                                    } else {
                                      self$current.table <- tablename
                                      res<-updateOneRequest(durl =  self$durls[[tablename]],id=id, dat=dat,key=private$access_token)
                                      return (res)
                                    }

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
                                      base.url="http://paleobot.paleobotany.ru/",
                                      tbl.names=c('specimens','taxa','cabs','trays','boxes')
                                    ),
                                    paleosib=list(
                                      base.url="https://biogeolog.tk/paleosib/",
                                      tbl.names=c('collections','taxanorm','taxa'),
                                      directus_version=8
                                    )
                                  )
                                )
)

