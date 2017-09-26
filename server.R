library(shiny)
library(shinydashboard)
library(plotly)
library(randomForest)
library(quantregForest)
library(dplyr)
library(DT)
load("GE Dashboard.RData")

#Change format to date
df.ge$Purchase.Order.Date <- as.Date(df.ge$Purchase.Order.Date, format="%b %d, %Y")

#data frame for the bar chart
ge.bar <- as.data.frame(table(df.ge$Purchase.Order.Date))
colnames(ge.bar) <- c("OrderDate", "NumberofOrders")
ge.bar$OrderDate <- format(as.Date(ge.bar$OrderDate), "%b %d,%y")
ge.bar$OrderDate <- factor(ge.bar$OrderDate, levels = ge.bar[["OrderDate"]])

#Naming and reordering columns for the table
colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plant ID", "ABC Indicator", "Quantity", "Planned Delivery Time",
                     "Actual Delivery Time", "Purchase Order Date", "Open PO", "Predicted Delivery Date")
df.ge <- df.ge[,c(1,2,3,4,5,9,11,7,8,10)]


server <- function(input, output, session) {
  output$OpenOrdersTable = DT::renderDataTable({
    df.ge
  }, options = list(scrollX = TRUE, autoWidth = TRUE))
  
  output$barchart = renderPlotly({
    plot_ly(ge.bar, x = ~OrderDate, y = ~NumberofOrders, type = 'bar') %>% 
      layout(margin = list(b = 70), xaxis= list(title = "Order Date", tickangle = -45), dragmode = "select")
  })
  
  output$hover <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover events appear here (unhover to clear)" else {
      cat("Date: ")
      cat(as.data.frame(d)$x)
      cat('\n')
      cat('Number of Open Orders: ')
      cat(as.data.frame(d)$y)
    }
  })
  
  output$click <- DT::renderDataTable({
    d <- event_data("plotly_click")
    if (is.null(d)) NULL else {
      tmp <- as.Date(as.list(d)$x, format = "%b %d,%y")
      df.ge[df.ge$`Purchase Order Date` == tmp,]
    }
  })
  
}
