#devtools::install_github("r-lib/httr")
library(httr)
library(jsonlite)
library(openssl)
increment <- function(value) {
  value + 1
}
auth_to_directus <- function(base.url, login, password, directus_version=9) {
  if(directus_version<9){
    url_auth<-'auth/authenticate'
  } else {
    url_auth<-'auth/login'
  }
  rbody <- sprintf(
    '{
        "email": "%1s",
        "password": "%2s"
      }', login, password
  )
  req<-POST(paste0(base.url, url_auth), body = rbody, content_type_json()
  )
  return ( fromJSON(content(req, "text"))$data )
}


