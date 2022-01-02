
file_to_examine <- "1209-Radstock-Dr_Library_PA_15129_M47489-26914"

property <- read_html(file_to_examine)


property %>% 
  html_elements(css = 'head > meta.og:title')

property %>% 
  html_elements(xpath = '/html/head/meta[@property = "og:title"]') %>% 
  html_attr("content")

property %>% 
  html_elements(xpath = '//head/meta[@property = "place:location:latitude"]') %>% 
  html_attr("content")

property %>% 
  html_elements(xpath = '//div[@class="rui__ygf76n-0 bsUILD rui__xdwspd-0 ibkjoI listing-key-fact-item__label"]')

property %>% 
  html_elements(xpath = '//ul')

property %>% 
  html_element(xpath = '//div[@id="content-property_details"]')

property %>% 
  html_elements(xpath = '//table') %>% 
  html_table()

property %>% 
  html_element(xpath = '//table') %>% 
  html_table()

str(property)


# html_element() vs html_elements() --------------------------------------
html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
  </ul>
")
li <- html %>% html_elements("li")

# When applied to a node set, html_elements() returns all matching elements
# beneath any of the inputs, flattening results into a new node set.
li %>% html_elements("i")

# When applied to a node set, html_element() always returns a vector the
# same length as the input, using a "missing" element where needed.
li %>% html_element("i")
# and html_text() and html_attr() will return NA
li %>% html_element("i") %>% html_text2()
li %>% html_element("span") %>% html_attr("class")