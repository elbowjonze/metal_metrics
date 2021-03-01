## needed for reading in Google sheet without manual auth
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)

shinyServer(function(input, output) {

  ## read in data for each session to reflect latest changes in google sheet
  raw_sheet <- as.data.frame(read_sheet('https://docs.google.com/spreadsheets/d/17dptNNNx830tgMLIBQ1O-PdDm-91j6aezyqX7voBmk0/edit?ts=60355514#gid=1879736710'))
  names(raw_sheet) <- tolower(names(raw_sheet))
  raw_sheet <- subset(raw_sheet, !is.na(date))[,1:16]
  raw_sheet$date <- as.Date(raw_sheet$date)
  
  ## tidy the data
  tidy_sheet <- gather(raw_sheet, key='rater', value='rating', rating_kris, rating_brad, rating_bryan, rating_seth, rating_geoff, rating_mike, rating_avg)
  tidy_sheet$judge <- stringr::str_to_title(ldply(strsplit(tidy_sheet$rater, '_'))$V2)
  tidy_sheet$judge <- ifelse(tidy_sheet$judge == 'Avg', 'The Council', tidy_sheet$judge)
  
  
  ## FILTERS
  output$judge_dropbox <- renderUI({
    judges <- sort(unique(tidy_sheet$judge))
    pickerInput('judge_dropbox', 'Who Sits in Judgement?', judges, multiple=TRUE, options=list('actions-box'=TRUE), selected='The Council')
  })
    
  output$date_range <- renderUI({
    dateRangeInput('date_range', 'Day of Judgement', start=min(tidy_sheet$date), end=max(tidy_sheet$date))
  })
  
  output$genre_dropbox <- renderUI({
    genres <- sort(unique(tidy_sheet$genre))
    pickerInput('genre_dropbox', 'List of Offenses', genres, multiple=TRUE, options=list('actions-box'=TRUE), selected=genres)
  })
  

  ## TIMELINE PLOT
  output$timeline <- renderPlot({

    message(paste0('judges: ', input$judge_dropbox))
    message(paste0('date1: ', input$date_range[1]), '    class: ', class(input$date_range[1]))
    message(paste0('date2: ', input$date_range[2]))
    message(paste0('genres: ', input$genre_dropbox))
    
    data_temp <- subset(tidy_sheet, judge %in% input$judge_dropbox & 
                          date >= input$date_range[1] &
                          date <= input$date_range[2] &
                          genre %in% input$genre_dropbox)
                        
    p <- ggplot(data=data_temp, aes(x=date, y=rating, group=judge, color=judge)) +
           geom_line()
    return(p)
  })
  
})


## expandable plot ... clickable album covers ... brings up modal with more info



