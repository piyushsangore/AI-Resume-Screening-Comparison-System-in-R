# 🚀 AI Resume Screening & Comparison System in R

An end-to-end **AI-powered Resume Screening and Comparison System** built using **R**, integrating **Machine Learning (XGBoost)** and **Natural Language Processing (NLP)** techniques to automate resume classification and rank candidates based on job relevance.

---

## 📌 Overview

Recruitment processes today involve handling a large number of resumes, making manual screening inefficient, inconsistent, and prone to bias. This system provides an automated and scalable solution that:

- Classifies resumes into predefined job roles  
- Matches resumes against job descriptions  
- Ranks candidates based on semantic similarity  
- Provides real-time results via an interactive interface  

The system is deployed using a **Shiny web application**, enabling easy usage for both technical and non-technical users.

---

## 🎯 Objectives

- Automate resume screening using machine learning  
- Apply NLP techniques for structured text processing  
- Implement similarity-based resume ranking  
- Build an interactive user interface  
- Enable real-time prediction and analysis  

---

## 🧠 System Architecture


Resume Input
↓
Text Preprocessing
↓
TF-IDF Vectorization
↓
XGBoost Model (Classification)
↓
Predicted Category

Comparison Module:

Resume + Job Description
↓
TF-IDF Representation
↓
Cosine Similarity
↓
Resume Ranking


---

## ⚙️ Tech Stack

| Category | Technologies |
|----------|-------------|
| Language | R |
| Machine Learning | XGBoost |
| NLP | tm, text2vec, textstem |
| Data Processing | dplyr, Matrix |
| Web Framework | Shiny |
| Visualization | Confusion Matrix, Accuracy Graph |

---

## 🔍 Key Features

- Resume classification using **XGBoost**
- Text preprocessing (cleaning, tokenization, lemmatization)
- Feature extraction using **TF-IDF**
- Resume-to-job matching using **cosine similarity**
- Ranking of multiple resumes based on relevance
- Interactive UI using **Shiny**
- Real-time prediction and comparison

---

## 📂 Project Structure


AI-Resume-Screening-Comparison-System-in-R/
│
├── app.R
├── model_training.R
├── resume_screening_model.rds
├── vectorizer.rds
├── gpt_dataset.csv
├── confusion_matrix.png
├── accuracy_plot.png
├── README.md


---

## 📊 Model Details

- **Algorithm:** XGBoost (Gradient Boosting Trees)
- **Feature Engineering:** TF-IDF Vectorization
- **Preprocessing Steps:**
  - Lowercasing
  - Stopword removal
  - Punctuation removal
  - Number removal
  - Lemmatization

### 📈 Performance

- Accuracy: ~99%
- High precision, recall, and F1-score
- Robust classification across multiple job categories

---

## 🖥️ Application Modules

### 🔹 Resume Classification
- Upload resume (.txt / .csv)
- System preprocesses and vectorizes text
- Predicts job category using trained model

### 🔹 Resume Comparison
- Upload multiple resumes
- Enter job description
- Computes cosine similarity
- Displays ranked resumes
- Highlights best candidate

---

## 📊 Visual Outputs

- Confusion Matrix (Model Performance)  
- Accuracy and Loss Graph  
- Ranked Resume Comparison Table  

---

## 🧪 Core Concepts

- Natural Language Processing (NLP)  
- TF-IDF (Term Frequency–Inverse Document Frequency)  
- Gradient Boosting (XGBoost)  
- Cosine Similarity  
- Sparse Matrix Representation  
- Supervised Machine Learning  

---

## ▶️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/piyushsangore/AI-Resume-Screening-Comparison-System-in-R.git
cd AI-Resume-Screening-Comparison-System-in-R
2. Install Required Packages
install.packages(c("shiny", "tm", "text2vec", "xgboost", "textstem", "dplyr", "Matrix"))
3. Run the Application
shiny::runApp()
```

🚀 Future Scope

Multilingual resume processing

Integration with job portals (LinkedIn, Naukri)

Resume improvement suggestions

Feedback-driven model updates

Deep learning-based semantic matching

👨‍💻 Contributors

Piyush Sangore

Arya Sawant

Akash Shejul

Ritik Kumar Singh

Shyamsundar More

🎓 Academic Context

Developed under
Computer Science and Engineering (Artificial Intelligence)
Vishwakarma Institute of Technology, Pune

📬 Contact

GitHub: https://github.com/piyushsangore

⭐ Support

If you found this project useful:

Star the repository

Fork the project

Share it

📜 License

This project is intended for academic and research purposes.


---

