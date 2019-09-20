##Webscrapping Trial Run

library(rvest)
library(httr)
col = POST(url="https://sanctionssearch.ofac.treas.gov/",
           encode="form",
           body=list(Name="NAME OF ENTITY",
                     search="Search"))
col_html = read_html(col)
col_table = html_table(col_html,fill=F)

## Run selenium through docker

remDr$open()

library(RSelenium)
rsDriver()
