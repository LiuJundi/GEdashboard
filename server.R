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
    plot_ly(ge.bar) %>%
      add_trace(x = ~OrderDate, y = ~NumberofOrders, type = 'bar', hoverinfo = 'text', marker=list(color="darkslateblue"),
                text = ~paste('Date: ', OrderDate,
                              ' Number of Open Orders: ', NumberofOrders)) %>% 
      add_trace(x = ~OrderDate, y = ~NumberofOrders, type = 'scatter', hoverinfo = 'text',
                text = ~paste('Date: ', OrderDate,
                              ' Number of Open Orders: ', NumberofOrders), mode = "marker",
                marker=list(color="darkslateblue", opacity=0.00001)) %>%
      layout(margin = list(b = 70), xaxis= list(title = "Order Date", tickangle = -45), dragmode = "select", showlegend = FALSE)
  })
  
  output$click <- DT::renderDataTable({
    d <- event_data("plotly_click")
    if (is.null(d)) NULL else {
      tmp <- as.Date(as.list(d)$x, format = "%b %d,%y")
      df.ge[df.ge$`Purchase Order Date` == tmp,]
    }
  })
  
  output$brush <- DT::renderDataTable({
    d <- event_data("plotly_selected")
    if (is.null(d)) NULL else {
      tmp <- ge.bar$OrderDate[as.list(d)$x+1]
      tmp <- as.Date(tmp, format = "%b %d,%y")
      df.ge[df.ge$`Purchase Order Date` == tmp,]
    }
  })
  
  output$zoom <- renderPrint({
    d <- event_data("plotly_relayout")
    if (is.null(d)) "Relayout (i.e., zoom) events appear here" else d
  })
}
