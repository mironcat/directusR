#devtools::install_github("r-lib/httr")
library(httr)
library(jsonlite)
#' Authentification into the API
#' @param base.url A string. A project name
#' @param login A string.
#' @param password A string.
#' @param directus_version A number.
#' @return Message about success auth
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
  req<-httr::POST(paste0(base.url, url_auth), body = rbody, httr::content_type_json()
  )
  res <- jsonlite::fromJSON(httr::content(req, "text",encoding = "UTF-8"))$data
  if(is.character(res$token) & directus_version<9) {
    return (
      list(
          access_token=res$token,
          expires=NA,
          refresh_token=NA

        )
    )
  } else {
    return (
      res
    )
  }

}


