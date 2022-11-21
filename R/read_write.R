
getRequest <- function(durl,key, params) {
  req<-httr::GET( paste0(durl,params), httr::add_headers(Authorization = paste("Bearer", key, sep = " ") )) #req operatis
  print(httr::http_status(req)$message)
<<<<<<< HEAD
  data<-jsonlite::fromJSON(httr::content(req, "text"))$data
=======
  data<-jsonlite::fromJSON(content(req, "text"))$data
>>>>>>> c838fc058a5ec5511ad80b8ef0fb08e0ce9b45a2
  return (data)
}
