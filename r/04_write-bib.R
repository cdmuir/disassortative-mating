source("r/header.R")

uri <- "https://api.zotero.org/users/5814932/collections/VPXJS8II/items"
.parms <- list(
  key = "ED0yHWd4Qtd6ereWuiLgYN2p", 
  collection = "VPXJS8II",
  limit = 1000,
  format = "bibtex",
  uri = "https://api.zotero.org/users/5814932/collections/VPXJS8II/items"
)
res <- httr::GET(uri, query = .parms)
res <- httr::content(res, as = "text", encoding = "UTF-8")
write(res, file = "ms/disassortative-mating.bib", append = FALSE)
