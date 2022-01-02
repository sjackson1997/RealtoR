library(tidyverse)
library(lubridate)
library(rvest)
library(xml2)

realtor_rss <- c("https://www.realtor.com/realestateandhomes-detail/sitemap-rss-new/rss-new-index.xml",
                 "https://www.realtor.com/realestateandhomes-detail/sitemap-rss-price/rss-price-index.xml",
                 "https://www.realtor.com/realestateandhomes-detail/sitemap-rss-sold/rss-sold-index.xml")

zip_search <- c("18407","18411","18413","18414","18419","18420","18421","18430",
                "18433","18441","18446","18447","18453","18465","18470","18471",
                "18472","18612","18615","18618","18625","18629","18630","18636",
                "18657","18801","18816","18823","18824","18825","18826","18834",
                "18842","18843","18844","18847")

dtFormat <- "%a, %d %b %Y %T"
base_realtor_url <- "https://www.realtor.com/realestateandhomes-detail/"

# "Sun, 07 Nov 2021 23:29:04"

names(realtor_rss) <- c("newhouses", "pricechange", "sold")
 
realtor_rss
v <- vector()

for (f in names(realtor_rss)) {

  new_file <- download_xml(url = realtor_rss[f],
                           file = paste0("./realtor/", basename(realtor_rss[f])))

  xml <- xml_ns_strip(read_xml(realtor_rss[f]))
  
  pa_urls <- xml_text(xml_find_all(xml, xpath = "//loc"))
  
  l <- str_detect(pa_urls, "-pa.xml")
  v <- c(v, pa_urls[l])
  Sys.sleep(2)
  
}

v
df_table <- tibble()

for (i in v) {
  xml <- read_xml(i)
  house_link <- xml_text(xml_find_all(xml, xpath = "//item/link"))
  pub_date <-  xml_text(xml_find_all(xml, xpath = "//item/pubDate"))
  pub_type <- xml_text(xml_find_first(xml, xpath = "//title"))
  df <- tibble(link = house_link, pub_date = pub_date, pub_type = pub_type)
  df$pub_type
  df_table <- bind_rows(df_table, df)
  Sys.sleep(1)
}

df_table2 <- df_table %>% 
  mutate(
    zip_code = str_extract(
      str_extract(link, "PA_[0-9]{5}"),
      "[0-9]{5}"),
    link = str_replace(link, base_realtor_url, ""),
    pub_date = as.POSIXct(pub_date, format = dtFormat)
    ) #%>% 
  # filter(zip_code %in% zip_search)

glimpse(df_table2)

view(df_table2)
