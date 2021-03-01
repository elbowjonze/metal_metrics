## how to republish app to shinyapp.io
# library(rsconnect)
# deployApp()

#setwd('D:/R_files/shiny/metal_metrics')

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(ggplot2)
library(googlesheets4)
library(googledrive)
library(tidyr)
library(plyr)


menuWidth=300 
header <- dashboardHeader(title='',
                          titleWidth=menuWidth, 
                          disable = FALSE)

sidebar <- dashboardSidebar(width=menuWidth,
  sidebarMenu(id='sidebar',
    style = "position:fixed; width:300px;",  ## fixes sidebar (will not scroll with table)
    uiOutput('judge_dropbox'),
    uiOutput('date_range'),
    uiOutput('genre_dropbox')
  )
)
  
body <- dashboardBody(
  fluidRow(
    plotOutput('timeline')
  )
)

suppressWarnings(dashboardPage(header, sidebar, body))
