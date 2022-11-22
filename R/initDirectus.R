source('R/directusInstance.R',local = T)
#' Initialization and working with [Directus REST API](https://docs.directus.io/reference/introduction.html)
#' @param db A string. A project name
#' @param directus.version A number.
#' @param db.info A list with information about path to Directus and available tables.
#' @return An instance of directusInstance class
#' @examples
#' library(directusR)
#' db1<-initDirectus(db='palebot')
#' db1
#' # or
#' db2<-initDirectus(db='paleosib', directus.version=8)
#' db2
#' db.info <- list(
#'   arth=list(
#'    base.url='http://arth.mironcat.tk/',
#'    tbl.names=c('specimens','collections','localities','taxa','reflinks')
#'   ),
#'   myproject = list(
#'    base.url='http://url.to.myproject/',
#'    tbl.names=c('table1','table2')
#'   )
#'  )
#' db3<-initDirectus(db='myproject', db.info=db.info)
#' db3
#' @seealso
#' [directusInstance()] - class documentation
#' @details
#' ## Description
#'
#' ## Methods
#' ### Authentification
#' For authenticating into the API run `db$auth()`with parameters.
#' ```
#' db$auth(login="YOUR LOGIN", password="YOUR PASSWORD")
#' # expected:
#' # you are authentificated to..
#' ```
#' ### Get Items
#' Run `db$get_items()` with parameters.
#' ### Code example:
#' ```
#' items<-db$get_items('tablename', params="?limit=10")
#' # expected:
#' # dataframe with items
#' ```
#' @export
initDirectus <- function(db, directus.version=9, db.info=NA) {
 return ( directusInstance$new(db, directus.version, db.info) )
}




