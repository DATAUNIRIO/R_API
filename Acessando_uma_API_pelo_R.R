##---------------------------------------------------------------##
##                                                               ##
##    Nome: Acessando API pelo R                                 ##
##                                                               ##
##                                                               ##
##    site: https://tclavelle.github.io/blog/r_and_apis/         ##
##                                                               ##
##    prof. Steven Dutt-Ross                                     ##
##    UNIRIO                                                     ##
##---------------------------------------------------------------##


#http://www.transparencia.gov.br/swagger-ui.html#!/Servidores32do32Poder32Executivo32Federal/servidoresUsingGET
#http://www.transparencia.gov.br/swagger-ui.html#!/Servidores32do32Poder32Executivo32Federal/servidorUsingGET

library(RJSONIO)
#library(rjson)

library(dplyr)
library(httr)
library(jsonlite)
library(lubridate)


url  <- "http://www.transparencia.gov.br/api-de-dados/servidores?orgaoServidorExercicio=26269&pagina=3"

#executing an API call with the GET flavor is done using the GET() function.
raw.result <- GET(url)

#Let’s explore what we’ve got back:
names(raw.result)

#The first step is to examine the status_code, which, 
#if everything worked properly, should read 200. 
#If you’ve ever entered an incorrect web address, such as https://github.com/trumpsucks, 
#you’ve seen a 404 status code indicating that things, uh, did not work properly.

raw.result$status_code

############################################################################################
############################################################################################
############################################################################################

this.raw.content <- rawToChar(raw.result$content)
#That’s rather large. Let’s look at the first 100 characters:
#substr(this.raw.content, 1, 200)
this.content <- fromJSON(this.raw.content)

############################################################################################
############################################################################################
##### FUNCAO
############################################################################################
############################################################################################

url  <- "http://www.transparencia.gov.br/api-de-dados/servidores?orgaoServidorExercicio=26269&pagina="
n_paginas <- 3
banco_transparencia   <- c()

for (i in 0:n_paginas) {
  
  url_number <- 3 - i + 1
  # Buscando a página
  url_completa <- paste0(url,url_number)
  raw.result <- GET(url_completa)
  if (raw.result$status_code!=200){
    break
  }
  this.raw.content <- rawToChar(raw.result$content)
  this.content <- fromJSON(this.raw.content)
  
  banco_transparencia<-rbind(banco_transparencia, this.content)
  #banco_transparencia<-append(banco_transparencia, this.content)
  # Mostra a página em que o R está
  print(url_number)
  # Para suspender a execução do R
  # Sys.sleep(5)
}


banco_transparencia[["pessoa"]][["nome"]]


