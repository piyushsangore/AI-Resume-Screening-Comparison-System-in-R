# AI Resume Screening & Comparison System in R

An end-to-end AI-powered Resume Screening and Comparison System built using R, Machine Learning (XGBoost), and NLP techniques. This system automates resume classification and intelligently ranks candidates based on their relevance to a job description.

📌 Project Overview

Modern recruitment involves processing hundreds of resumes for a single job role, which is:

⏱️ Time-consuming

⚠️ Prone to human bias

❌ Inconsistent

This project addresses these challenges by building an intelligent system that:

Classifies resumes into job roles

Compares resumes against job descriptions

Ranks candidates using similarity scoring

The system is deployed using an interactive Shiny web application for real-time usage.

🎯 Objectives

Automate resume screening using machine learning

Apply NLP techniques for text preprocessing

Classify resumes using XGBoost model

Compare resumes using Cosine Similarity

Provide a user-friendly interface for recruiters

⚙️ Tech Stack
Category	Technologies
Language	R
Machine Learning	XGBoost
NLP	tm, text2vec, textstem
Data Handling	dplyr, Matrix
Web Framework	Shiny
Visualization	Confusion Matrix, Accuracy Plot
🧠 System Workflow
Resume Input
     ↓
Text Preprocessing
     ↓
TF-IDF Vectorization
     ↓
XGBoost Model
     ↓
Predicted Job Category

Comparison Module:
Resume + Job Description → Cosine Similarity → Ranking
🔍 Key Features

✅ Resume classification into predefined job roles
✅ NLP-based preprocessing (cleaning, tokenization, lemmatization)
✅ TF-IDF vectorization for feature extraction
✅ Multi-resume comparison using cosine similarity
✅ Ranking resumes based on job relevance
✅ Interactive Shiny-based UI
✅ Real-time prediction and visualization

📂 Project Structure
📁 AI-Resume-Screening-Comparison-System-in-R
│
├── app.R                         # Main Shiny Application
├── model_training.R              # Model training script
├── resume_screening_model.rds    # Trained XGBoost model
├── vectorizer.rds                # TF-IDF vectorizer
├── gpt_dataset.csv               # Dataset used for training
├── confusion_matrix.png          # Model evaluation image
├── accuracy_plot.png             # Training performance graph
├── README.md                     # Project documentation
📊 Model Details

Algorithm: XGBoost (Gradient Boosting Trees)

Feature Extraction: TF-IDF

Preprocessing:

Lowercasing

Stopword removal

Punctuation & number removal

Lemmatization

📈 Performance

Accuracy: ~99%

High precision and recall across categories

Minor overlap in similar roles (e.g., backend vs cloud)

🖥️ Application Modules
🔹 1. Resume Screening

Upload resume (.txt / .csv)

System preprocesses and vectorizes text

Predicts job category using trained model

🔹 2. Resume Comparison

Upload multiple resumes

Enter job description

System computes cosine similarity

Displays ranked resumes

Highlights best candidate

📊 Visual Outputs

Confusion Matrix (classification performance)

Accuracy & Loss Graph (training behavior)

Ranked Resume Table (comparison results)

🧪 Core Concepts Used

Natural Language Processing (NLP)

TF-IDF Vectorization

Gradient Boosting (XGBoost)

Cosine Similarity

Sparse Matrix Representation

Supervised Machine Learning

▶️ Installation & Setup
1️⃣ Clone the Repository
git clone https://github.com/piyushsangore/AI-Resume-Screening-Comparison-System-in-R.git
cd AI-Resume-Screening-Comparison-System-in-R
2️⃣ Install Required Packages
install.packages(c("shiny", "tm", "text2vec", "xgboost", "textstem", "dplyr", "Matrix"))
3️⃣ Run the Application
shiny::runApp()
🚀 Future Scope

Multilingual resume support

Integration with job portals

Resume improvement suggestions

Feedback-based model learning

Deep learning-based semantic matching

👨‍💻 Contributors

Piyush Sangore

Arya Sawant

Akash Shejul

Ritik Kumar Singh

Shyamsundar More

🎓 Academic Context

Developed as part of
Computer Science and Engineering (Artificial Intelligence)
at Vishwakarma Institute of Technology, Pune

📬 Contact

GitHub: https://github.com/piyushsangore

⭐ Support

If you found this project useful:

⭐ Star the repository

🔁 Share with others

📜 License

This project is developed for academic and research purposes.
