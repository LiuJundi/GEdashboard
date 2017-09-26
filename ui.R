library(shiny)
library(shinydashboard)
library(plotly)
library(randomForest)
library(quantregForest)
library(dplyr)
library(DT)
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
            box(title = "Bar Chart for Open Orders", status = "primary", plotlyOutput(outputId = "barchart"), width = "100%"),
            box(title = "", status = "primary", verbatimTextOutput("hover"), width = "100%"),
            box(title = "You select:", DT::dataTableOutput('click'), width = "100%" , height = "100%")
#            box(title = "", status = "primary", verbatimTextOutput("brush"), width = "100%"),
#            box(title = "", status = "primary", verbatimTextOutput("zoom"), width = "100%")
            ),
    tabItem(tabName = "table",
            box(DT::dataTableOutput('OpenOrdersTable'), width = "100%" , height = "100%")),
    tabItem(tabName = "predictions")
  )
)

dashboardPage(header, sidebar, body, skin = "purple")