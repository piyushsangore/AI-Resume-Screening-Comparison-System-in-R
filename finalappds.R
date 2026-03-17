library(shiny)
library(tm)
library(text2vec)
library(xgboost)
library(textstem)
library(dplyr)
library(Matrix)

# Load model and vectorizer
model <- readRDS("resume_screening_model.rds")
vectorizer <- readRDS("vectorizer.rds")

# --- Preprocessing and Utility Functions ---

preprocess_resume <- function(resume_text, vectorizer) {
  corpus <- Corpus(VectorSource(resume_text))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  cleaned_text <- sapply(corpus, as.character)
  cleaned_text <- lemmatize_strings(cleaned_text)
  tokens <- word_tokenizer(cleaned_text)
  it <- itoken(tokens, progressbar = FALSE)
  dtm <- create_dtm(it, vectorizer)
  return(Matrix(dtm, sparse = TRUE))
}

preprocess_text <- function(text, vectorizer) {
  corpus <- Corpus(VectorSource(text))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  tokens <- unlist(strsplit(corpus[[1]]$content, "\\s+"))
  it <- itoken(list(tokens), progressbar = FALSE)
  dtm <- create_dtm(it, vectorizer)
  if (nrow(dtm) == 0) return(NULL)
  return(as.matrix(dtm)[1, ])
}

cosine_similarity <- function(vec1, vec2) {
  if (length(vec1) == 0 || length(vec2) == 0) return(0)
  return(sum(vec1 * vec2) / (sqrt(sum(vec1^2)) * sqrt(sum(vec2^2)) + 1e-10))
}

# --- UI ---
ui <- fluidPage(
  titlePanel("AI Resume Screening & Comparison System"),
  tabsetPanel(
    tabPanel("Screen Single Resume",
             sidebarLayout(
               sidebarPanel(
                 fileInput("resume_file", "Upload Resume (TXT or CSV)", accept = c(".txt", ".csv")),
                 actionButton("predict", "Predict Category")
               ),
               mainPanel(
                 textOutput("prediction_result"),
                 br(),
                 img(src = "confusion_matrix.png", height = "400px"),
                 img(src = "accuracy_plot.png", height = "400px")
               )
             )
    ),
    tabPanel("Compare Multiple Resumes",
             sidebarLayout(
               sidebarPanel(
                 numericInput("num_resumes", "Number of Resumes:", value = 2, min = 2, step = 1),
                 uiOutput("file_inputs"),
                 textAreaInput("job_desc", "Paste Job Description or Ideal Resume:", 
                               placeholder = "Enter key skills, job role, and experience", rows = 5),
                 actionButton("compare", "Compare Resumes")
               ),
               mainPanel(
                 tableOutput("ranked_resumes"),
                 textOutput("best_resume")
               )
             )
    )
  )
)

# --- Server ---
server <- function(input, output, session) {
  
  # --- Classification Tab ---
  observeEvent(input$predict, {
    req(input$resume_file)
    resume_text <- if (grepl(".csv$", input$resume_file$name)) {
      df <- read.csv(input$resume_file$datapath, stringsAsFactors = FALSE)
      paste(df$Resume, collapse = " ")
    } else {
      paste(readLines(input$resume_file$datapath, warn = FALSE), collapse = " ")
    }
    
    resume_dtm <- preprocess_resume(resume_text, vectorizer)
    predicted_category <- predict(model, newdata = resume_dtm)
    predicted_label <- gsub("\\.", " ", levels(model$trainingData$.outcome))[as.numeric(predicted_category)]
    
    output$prediction_result <- renderText({
      paste("🔍 Predicted Category:", predicted_label)
    })
  })
  
  # --- Comparison Tab ---
  output$file_inputs <- renderUI({
    num <- input$num_resumes
    lapply(1:num, function(i) {
      fileInput(paste0("resume_", i), paste("Upload Resume", i), accept = c(".txt"))
    }) |> tagList()
  })
  
  observeEvent(input$compare, {
    req(input$num_resumes)
    req(input$job_desc)
    
    job_desc_text <- input$job_desc
    job_desc_vector <- preprocess_text(job_desc_text, vectorizer)
    
    if (is.null(job_desc_vector)) {
      output$ranked_resumes <- renderTable(data.frame(Error = "Job description is too short or empty."))
      return()
    }
    
    resume_data <- data.frame(File = character(), Score = numeric(), stringsAsFactors = FALSE)
    
    for (i in 1:input$num_resumes) {
      file_input_id <- paste0("resume_", i)
      file_info <- input[[file_input_id]]
      if (is.null(file_info)) {
        output$ranked_resumes <- renderTable(data.frame(Error = paste("Upload all", input$num_resumes, "resumes.")))
        return()
      }
      
      file_text <- paste(readLines(file_info$datapath, warn = FALSE), collapse = " ")
      resume_vector <- preprocess_text(file_text, vectorizer)
      if (is.null(resume_vector)) next
      score <- cosine_similarity(resume_vector, job_desc_vector)
      resume_data <- rbind(resume_data, data.frame(File = file_info$name, Score = score))
    }
    
    if (nrow(resume_data) < 2) {
      output$ranked_resumes <- renderTable(data.frame(Error = "Not enough valid resumes for comparison."))
      return()
    }
    
    resume_data <- resume_data %>% arrange(desc(Score))
    output$ranked_resumes <- renderTable(resume_data)
    output$best_resume <- renderText(paste("🏆 Best Resume for the Job:", resume_data$File[1]))
  })
}

# Run App
shinyApp(ui = ui, server = server)
