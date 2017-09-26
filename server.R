library(shiny)
library(shinydashboard)
library(plotly)
library(randomForest)
library(quantregForest)
library(dplyr)
library(DT)

load("GE Dashboard.RData")

colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plant ID", "ABC Indicator", "Quantity", "Planned Delivery Time",
                     "Actual Delivery Time", "Purchase Order Date", "Open PO", "Predicted Delivery Date")

df.ge <- df.ge[,c(1,2,3,4,5,9,11,7,8,10)]

server <- function(input, output, session) {
  output$OpenOrdersTable = DT::renderDataTable({
    df.ge
  })
}