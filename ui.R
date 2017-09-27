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
    menuItem("Purchase Order Date Plots", tabName = "od_plots", icon = icon("bar-chart")),
    menuItem("Estimated Delivery Date Plots", tabName = "pdd_plots", icon = icon("bar-chart")),
    menuItem("Data Table", tabName = "table", icon = icon("table")),
    menuItem("Predictions", tabName = "predictions", icon = icon("info-circle"))
  )
)

# Body
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "od_plots",
            box(title = "Bar Chart for Open Orders", plotlyOutput(outputId = "od_barchart"), width = "100%"),
            box(title = 'Please select the date range: ', dateRangeInput("purchase_date", NULL,
                                                                         start  = "2017-02-15",
                                                                         end    = "2017-04-24",
                                                                         min    = "2016-01-01",
                                                                         max    = "2017-12-31",
                                                                         separator = " - "), width = "100%", height = "100%"),
            box(title = "You select (by clicking):", DT::dataTableOutput('od_click'), width = "100%" , height = "100%"),
            box(title = "You select (by brushing):", DT::dataTableOutput('od_brush'), width = "100%" , height = "100%")
            ),
    tabItem(tabName = "pdd_plots",
              box(title = "Bar Chart for Open Orders", plotlyOutput(outputId = "pdd_barchart"), width = "100%"),
              box(title = 'Please select the date range: ', dateRangeInput("deliver_date", NULL,
                                                                           start  = "2017-04-15",
                                                                           end    = "2017-08-17",
                                                                           min    = "2016-01-01",
                                                                           max    = "2017-12-31",
                                                                           separator = " - "), width = "100%", height = "100%"),
              box(title = "You select (by clicking):", DT::dataTableOutput('pdd_click'), width = "100%" , height = "100%"),
              box(title = "You select (by brushing):", DT::dataTableOutput('pdd_brush'), width = "100%" , height = "100%")
      ),
    tabItem(tabName = "table",
            box(DT::dataTableOutput('OpenOrdersTable'), width = "100%" , height = "100%")),
    tabItem(tabName = "predictions",
            valueBoxOutput("lowerPrediction"),
            valueBoxOutput("actualPrediction"),
            valueBoxOutput("upperPrediction"),
            box(actionButton("predictButton", "Click Me"),
                selectInput(inputId = "predictMaterial", label = "Material to predict:", choices = sort(unique(df.ge$Material.Number))),
                selectInput(inputId = "predictPlant", label = "Plant ID:", choices = sort(unique(df.ge$Plnt))),
                numericInput(inputId = "predictQuantity", label = "Quantity:", value = 1),
                numericInput(inputId = "predictPdt", label = "Planned delivery time (in days):", value = 1)
                )
            )
  )
)

dashboardPage(header, sidebar, body, skin = "purple")