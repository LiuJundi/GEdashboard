library(shiny)
library(shinydashboard)
library(plotly)
library(googleVis)
load("GE Dashboard.RData")

colnames(df.ge) <- c("Purchasing Document", "Vendor", "Material Number", "Plnt", "ABC Indicator", "Quantity", "Pdt",
                     "PO Cycle Time", "Purchase Order Date", "Open PO")

server <- function(input, output, session) {
  output$OpenOrdersTable = renderDataTable({
    df.ge
  }, options = list(scrollX = TRUE, autoWidth = TRUE))
}