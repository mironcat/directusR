
getRequest <- function(durl,key) {
  req<-httr::GET(durl, httr::add_headers(Authorization = paste("Bearer", key, sep = " ") )) #req operatis
  print(http_status(req)$message)
  data<-jsonlite::fromJSON(content(req, "text"))$data
  return (data)
}
