library(shiny)
library(shinydashboard)
library(plotly)
library(randomForest)
library(quantregForest)
library(dplyr)
library(DT)
load("GE Dashboard.RData")

df.ge$Purchase.Order.Date <- as.Date(df.ge$Purchase.Order.Date, format="%b %d, %Y")
ge.bar <- as.data.frame(table(df.ge$Purchase.Order.Date))
colnames(ge.bar) <- c("OrderDate", "NumberofOrders")
ge.bar$OrderDate <- format(as.Date(ge.bar$OrderDate), "%b%d")

colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plnt", "ABC Indicator", "Quantity", "Pdt",
                     "PO Cycle Time", "Purchase Order Date", "Open PO")

load("GE Dashboard.RData")

colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plant ID", "ABC Indicator", "Quantity", "Planned Delivery Time",
                     "Actual Delivery Time", "Purchase Order Date", "Open PO", "Predicted Delivery Date")

df.ge <- df.ge[,c(1,2,3,4,5,9,11,7,8,10)]


load("GE Dashboard.RData")

colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plant ID", "ABC Indicator", "Quantity", "Planned Delivery Time",
                     "Actual Delivery Time", "Purchase Order Date", "Open PO", "Predicted Delivery Date")

df.ge <- df.ge[,c(1,2,3,4,5,9,11,7,8,10)]



server <- function(input, output, session) {
  output$OpenOrdersTable = DT::renderDataTable({
    df.ge
  }, options = list(scrollX = TRUE, autoWidth = TRUE))
  
  output$barchart = renderPlotly({
    plot_ly(ge.bar, x = ~OrderDate, y = ~NumberofOrders, type = 'bar') %>% layout(xaxis= list(title = "", tickangle = -45))
  })
  

}
