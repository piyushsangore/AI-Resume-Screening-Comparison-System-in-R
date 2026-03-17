# ---------------------------
# 1. Load Required Libraries
# ---------------------------
library(tm)
library(text2vec)
library(caret)
library(xgboost)
library(textstem)
library(dplyr)
library(doParallel)
library(Matrix)
library(ggplot2)
library(pROC)
library(reshape2)

# ---------------------------
# 2. Load and Preprocess Data
# ---------------------------
resumes <- read.csv("E:/DOME sem4/Data Science/Course Project/gpt_dataset.csv", stringsAsFactors = FALSE)

# Use VCorpus instead of SimpleCorpus
corpus <- VCorpus(VectorSource(resumes$Resume))

# Preprocessing steps
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

# Apply lemmatization
resumes$CleanedResume <- sapply(corpus, as.character)
resumes$CleanedResume <- lemmatize_strings(resumes$CleanedResume)


# Tokenization and TF-IDF
tokens <- word_tokenizer(resumes$CleanedResume)
it <- itoken(tokens, progressbar = FALSE)
vocab <- create_vocabulary(it)
vocab <- prune_vocabulary(vocab, term_count_min = 10)
vectorizer <- vocab_vectorizer(vocab)
dtm <- create_dtm(it, vectorizer)
dtm_sparse <- Matrix(dtm, sparse = TRUE)

# Save vectorizer
saveRDS(vectorizer, "vectorizer.rds")

# Convert target to factor
resumes$Category <- as.factor(resumes$Category)

# Ensure target levels are valid R variable names
levels(resumes$Category) <- make.names(levels(resumes$Category))

# ---------------------------
# 3. Split Data
# ---------------------------
set.seed(123)
train_index <- createDataPartition(resumes$Category, p = 0.8, list = FALSE)
train_data <- dtm_sparse[train_index, ]
test_data <- dtm_sparse[-train_index, ]
train_labels <- resumes$Category[train_index]
test_labels <- resumes$Category[-train_index]

# ---------------------------
# 4. Train Model
# ---------------------------
cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

model <- train(
  x = train_data,
  y = train_labels,
  method = "xgbTree",
  trControl = trainControl(
    method = "cv",
    number = 5,
    verboseIter = TRUE,
    classProbs = TRUE,
    savePredictions = "final"
  )
)

stopCluster(cl)

saveRDS(model, "resume_screening_model.rds")
cat("Model training complete. Model and vectorizer saved successfully.\n")

# ---------------------------
# 5. Plot Evaluation Graphs
# ---------------------------

# ---- ROC Curve (Binary Only) ----
if (length(levels(test_labels)) == 2) {
  pred_probs <- predict(model, newdata = test_data, type = "prob")
  y_test <- ifelse(test_labels == levels(test_labels)[2], 1, 0)  # Convert to binary 0/1
  roc_obj <- roc(y_test, pred_probs[,2])
  
  plot(roc_obj, col = "#2c7fb8", lwd = 2,
       main = paste("ROC Curve (AUC =", round(auc(roc_obj), 3), ")"))
} else {
  cat("ROC Curve skipped: only available for binary classification.\n")
}

# ---- Confusion Matrix Heatmap ----
pred_classes <- predict(model, newdata = test_data)
conf_mat <- confusionMatrix(pred_classes, test_labels)

conf_df <- as.data.frame(conf_mat$table)
colnames(conf_df) <- c("Predicted", "Actual", "Freq")

ggplot(conf_df, aes(x = Actual, y = Predicted, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 6) +
  scale_fill_gradient(low = "#deebf7", high = "#3182bd") +
  labs(title = "Confusion Matrix Heatmap") +
  theme_minimal()

# ---- Performance Metrics Bar Graph ----
pred_labels <- predict(model, newdata = test_data)
conf_mat <- confusionMatrix(pred_labels, test_labels)

# ---- Compute Metrics ----
accuracy <- conf_mat$overall["Accuracy"]

# If multiclass: take mean of each class's metric
if (is.matrix(conf_mat$byClass)) {
  precision <- mean(conf_mat$byClass[, "Precision"], na.rm = TRUE)
  recall <- mean(conf_mat$byClass[, "Recall"], na.rm = TRUE)
  f1 <- mean(conf_mat$byClass[, "F1"], na.rm = TRUE)
} else {
  precision <- conf_mat$byClass["Precision"]
  recall <- conf_mat$byClass["Recall"]
  f1 <- conf_mat$byClass["F1"]
}

# ---- Build Performance Data Frame ----
perf_metrics <- c(
  Accuracy = accuracy,
  Precision = precision,
  Recall = recall,
  F1 = f1
)

perf_df <- data.frame(Metric = names(perf_metrics),
                      Value = as.numeric(perf_metrics))

# ---- Plot ----
ggplot(perf_df, aes(x = Metric, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", width = 0.6) +
  scale_fill_brewer(palette = "Set2") +
  ylim(0, 1) +
  labs(title = "Model Performance Metrics", y = "Score") +
  theme_minimal()

# ---- Print Accuracy to Console ----
cat("Model Accuracy:", round(accuracy, 4), "\n")


