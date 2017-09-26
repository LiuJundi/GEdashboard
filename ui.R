library(shiny)
library(shinydashboard)
library(plotly)
library(randomForest)
library(quantregForest)
load("GE Dashboard.RData")

# Notification menu
notifications <- dropdownMenu(type = "notifications",
                              notificationItem(
                                status="warning",
                                text = "Data updated 9/24/2017",
                                icon("info-circle")
                              )
)

# Header menu
header <- dashboardHeader(title = "GE Dashboard Demo", notifications)

# Sidebar menu
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Interactive Plots", tabName = "plots", icon = icon("bar-chart")),
    menuItem("Data Table", tabName = "table", icon = icon("table")),
    menuItem("Predictions", tabName = "predictions", icon = icon("info-circle"))
  )
)

# Body
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "plots",
            box(title = "Bar Chart for Open Orders", status = "primary", plotlyOutput(outputId = "barchart"), width = 12)),
    tabItem(tabName = "table",
            dataTableOutput("OpenOrdersTable")),
    tabItem(tabName = "predictions")
  )
)

dashboardPage(header, sidebar, body, skin = "purple")