library(httr)
getRequest <- function(durl,key, params) {
  req<-httr::GET( paste0(durl,params), httr::add_headers(Authorization = paste("Bearer", key, sep = " ") )) #req operatis
  print(httr::http_status(req)$message)
  data<-jsonlite::fromJSON(httr::content(req, as = "text", encoding = "UTF-8"))$data
  return (data)
}
updateOneRequest <- function(durl, id, dat, key) {
  # dat <- data.frame (id  = c(6628),
  #                   genus = c("test2")
  # )
  if (nrow(dat)!=1){
    message("dataframe must be with ONE row")
    return()
  }
  jsonstr<-jsonlite::toJSON(dat)
  jsonstr<-substring(jsonstr, 2)
  jsonstr<-substring(jsonstr,1, nchar(jsonstr)-1)
  req<-httr::PATCH(
    url =  paste0(durl,'/',id),
    body = jsonstr,
    encode = "json",
    httr::content_type_json(),
    httr::add_headers( Authorization = paste("Bearer", key, sep = " ") )
  ) #req operatis
  # print(httr::http_status(req)$message)
  # content<-httr::content(req, encode = "json", encoding = "UTF-8")
  # content_data<-data.frame(lapply(content$data, function(x) t(data.frame(x))))
  # return (content_data)
}
insertOneRequest<- function(durl, id, dat, key) {
  if (nrow(dat)!=1){
    message("dataframe must be with ONE row")
    return()
  }
  jsonstr<-jsonlite::toJSON(dat)
  jsonstr<-substring(jsonstr, 2)
  jsonstr<-substring(jsonstr,1, nchar(jsonstr)-1)
  req<-httr::PATCH(
    url =  paste0(durl,'/',id),
    body = jsonstr,
    encode = "json",
    httr::content_type_json(),
    httr::add_headers( Authorization = paste("Bearer", key, sep = " ") )
  )
}
