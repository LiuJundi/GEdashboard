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
df.ge$Predicted.Delivery.Date <- as.Date(df.ge$Predicted.Delivery.Date, format="%b %d, %Y")

#data frame for the bar chart
ge.od.bar <- as.data.frame(table(df.ge$Purchase.Order.Date))
colnames(ge.od.bar) <- c("OrderDate", "NumberofOrders")
ge.od.bar$OrderDate <- as.Date(ge.od.bar$OrderDate)
ge.pdd.bar <- as.data.frame(table(df.ge$Predicted.Delivery.Date))
colnames(ge.pdd.bar) <- c("PredictedDate", "NumberofOrders")
ge.pdd.bar$PredictedDate <- as.Date(ge.pdd.bar$PredictedDate)


#Naming and reordering columns for the table
colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plant ID", "ABC Indicator", "Quantity", "Planned Delivery Time",
                     "Actual Delivery Time", "Purchase Order Date", "Open PO", "Predicted Delivery Date")
df.ge <- df.ge[,c(1,2,3,4,5,9,11,7,8,10)]


server <- function(input, output, session) {
  output$OpenOrdersTable = DT::renderDataTable({
    df.ge
  }, options = list(scrollX = TRUE, autoWidth = TRUE))
  
  output$od_barchart = renderPlotly({
    start.date <- input$purchase_date[1]
    end.date <- input$purchase_date[2]
    ge.tmp <- ge.od.bar[ge.od.bar$OrderDate >= start.date,]
    ge.tmp <- ge.tmp[ge.tmp$OrderDate <= end.date,]
    ge.tmp$OrderDate <- format(as.Date(ge.tmp$OrderDate), "%b %d,%y")
    ge.tmp$OrderDate <- factor(ge.tmp$OrderDate, levels = ge.tmp[["OrderDate"]])
    plot_ly(ge.tmp) %>%
      add_trace(x = ~OrderDate, y = ~NumberofOrders, type = 'bar', hoverinfo = 'text', marker=list(color="darkslateblue"),
                text = ~paste('Purchase Date: ', OrderDate,
                              ' Number of Open Orders: ', NumberofOrders)) %>% 
      add_trace(x = ~OrderDate, y = ~NumberofOrders, type = 'scatter', hoverinfo = 'text',
                text = ~paste('Date: ', OrderDate,
                              ' Number of Open Orders: ', NumberofOrders), mode = "marker",
                marker=list(color="darkslateblue", opacity=0.00001)) %>%
      layout(margin = list(b = 70), xaxis= list(title = "Order Date", tickangle = -45),
             yaxis = list(title = 'Number of Open Orders'),
             dragmode = "select", showlegend = FALSE)
  })
  
  output$pdd_barchart = renderPlotly({
    start.date <- input$deliver_date[1]
    end.date <- input$deliver_date[2]
    ge.tmp <- ge.pdd.bar[ge.pdd.bar$PredictedDate >= start.date,]
    ge.tmp <- ge.tmp[ge.tmp$PredictedDate <= end.date,]
    ge.tmp$PredictedDate <- format(as.Date(ge.tmp$PredictedDate), "%b %d,%y")
    ge.tmp$PredictedDate <- factor(ge.tmp$PredictedDate, levels = ge.tmp[["PredictedDate"]])
    plot_ly(ge.tmp) %>%
      add_trace(x = ~PredictedDate, y = ~NumberofOrders, type = 'bar', hoverinfo = 'text', marker=list(color="darkslateblue"),
                text = ~paste('Predicted Date: ', PredictedDate,
                              ' Number of Open Orders: ', NumberofOrders)) %>% 
      add_trace(x = ~PredictedDate, y = ~NumberofOrders, type = 'scatter', hoverinfo = 'text',
                text = ~paste('Date: ', PredictedDate,
                              ' Number of Open Orders: ', NumberofOrders), mode = "marker",
                marker=list(color="darkslateblue", opacity=0.00001)) %>%
      layout(margin = list(b = 70), xaxis= list(title = "Predicted Delivery Date", tickangle = -45),
             yaxis = list(title = 'Number of Open Orders'),
             dragmode = "select", showlegend = FALSE)
  })
  
  output$od_click <- DT::renderDataTable({
    d <- event_data("plotly_click")
    if (is.null(d)) NULL else {
      tmp <- as.Date(as.list(d)$x, format = "%b %d,%y")
      df.ge[df.ge$`Purchase Order Date` == tmp,]
    }
  })
  
  output$od_brush <- DT::renderDataTable({
    d <- event_data("plotly_selected")
    if (is.null(d)) NULL else {
      dt <- as.list(d)$x+which(ge.od.bar$OrderDate == input$purchase_date[1])
      tmp <- ge.od.bar$OrderDate[dt]
      tmp <- as.Date(tmp, format = "%b %d,%y")
      df.ge[df.ge$`Purchase Order Date` == tmp,]
    }
  })
  
  output$pdd_click <- DT::renderDataTable({
    d <- event_data("plotly_click")
    if (is.null(d)) NULL else {
      tmp <- as.Date(as.list(d)$x, format = "%b %d,%y")
      df.ge[df.ge$`Predicted Delivery Date` == tmp,]
    }
  })
  
  output$pdd_brush <- DT::renderDataTable({
    d <- event_data("plotly_selected")
    if (is.null(d)) NULL else {
      dt <- as.list(d)$x+which(ge.pdd.bar$PredictedDate == input$purchase_date[1])
      tmp <- ge.pdd.bar$PredictedDate[dt]
      tmp <- as.Date(tmp, format = "%b %d,%y")
      df.ge[df.ge$`Predicted Delivery Date` == tmp,]
    }
  })
  
}
