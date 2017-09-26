library(shiny)
library(shinydashboard)
library(plotly)
library(randomForest)
library(quantregForest)
load("GE Dashboard.RData")

df.ge$Purchase.Order.Date <- as.Date(df.ge$Purchase.Order.Date, format="%b %d, %Y")
ge.bar <- as.data.frame(table(df.ge$Purchase.Order.Date))
colnames(ge.bar) <- c("OrderDate", "NumberofOrders")
ge.bar$OrderDate <- format(as.Date(ge.bar$OrderDate), "%b%d")

colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plnt", "ABC Indicator", "Quantity", "Pdt",
                     "PO Cycle Time", "Purchase Order Date", "Open PO")



server <- function(input, output, session) {
  output$OpenOrdersTable = renderDataTable({
    df.ge
  }, options = list(scrollX = TRUE, autoWidth = TRUE))
  
  output$barchart = renderPlotly({
    plot_ly(ge.bar, x = ~OrderDate, y = ~NumberofOrders, type = 'bar') %>% layout(xaxis= list(title = "", tickangle = -45))
  })
  
}