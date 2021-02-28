options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)


sheet <- as.data.frame(read_sheet('https://docs.google.com/spreadsheets/d/17dptNNNx830tgMLIBQ1O-PdDm-91j6aezyqX7voBmk0/edit?ts=60355514#gid=1879736710'))
names(sheet) <- tolower(names(sheet))
sheet <- subset(sheet, !is.na(date))[,1:16]
tidy_sheet <- gather(sheet, key='rater', value='rating', rating_kris, rating_brad, rating_bryan, rating_seth, rating_geoff, rating_mike, rating_avg)
  

shinyServer(function(input, output) {
    
  output$timeline <- renderPlot({
  
    p <- ggplot(data=tidy_sheet, aes(x=date, y=rating, group=rater, color=rater)) +
           geom_line()
    return(p)
  })
  
})


## expandable plot ... clickable album covers ... brings up modal with more info



