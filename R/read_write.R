
getRequest <- function(durl,key, params) {
  req<-httr::GET( paste0(durl,params), httr::add_headers(Authorization = paste("Bearer", key, sep = " ") )) #req operatis
  print(httr::http_status(req)$message)
  data<-jsonlite::fromJSON(content(req, "text"))$data
  return (data)
}
