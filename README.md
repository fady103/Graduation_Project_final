# Smart Health Checker

An AI-powered medical diagnostic system that integrates lab test analysis and radiology image classification using machine learning to assist healthcare providers in delivering faster and more accurate diagnoses — especially in underserved and remote regions.

## Project Overview

Smart Health Checker is a multi-platform application (Web + Mobile) designed to:
- Analyze clinical lab data and X-ray images.
- Provide real-time disease prediction and medical advice.
- Generate structured reports for medical professionals.
- Serve areas with limited access to healthcare (e.g. conflict zones, rural areas, epidemics).

## Key Features

-  **Lab Test Classifiers**: Diagnose diseases using blood and clinical biomarkers.
-  **Radiology X-ray Analysis**: Classify chest X-rays (e.g. Pneumonia, COVID-19, TB).
-  **PDF Report Generator**: Automatically generate downloadable medical reports.
-  **Real-time Predictions**: Instant feedback after image upload or data entry.
-  **Historical Tracking**: View and manage past reports.
-  **Profile System**: Login, manage account, and view user details.

## Diseases Supported

- Diabetes
- Anemia
- Liver Disease
- Parkinson’s Disease
- Pneumonia
- COVID-19
- Tuberculosis
- Viral Infections

## Tools & Technologies

| Component          | Technologies Used |
|--------------------|--------------------|
| **Frontend**       | Flutter (Mobile UI) |
| **Backend**        | FastAPI, PHP |
| **ML Libraries**   | Scikit-learn, Pandas, TensorFlow, Keras, OpenCV |
| **Database**       | MySQL |
| **Visualization**  | Seaborn, Matplotlib |

## Machine Learning Models

| Disease        | Best Model Used             | Accuracy |
|----------------|-----------------------------|----------|
| Diabetes       | Random Forest               | 96%      |
| Anemia         | Logistic Regression         | High     |
| Pneumonia      | CNN                         | 89.4%    |
| COVID-19       | CNN                         | 89.1%    |
| Parkinson’s    | Random Forest, SVM, KNN     | –        |

## Datasets

All datasets were collected from **[Kaggle](https://www.kaggle.com/)** or local medical labs.  
- Parkinson's Dataset: [Link](https://www.kaggle.com/datasets/rabieelkharoua/parkinsons-disease-dataset-analysis/data)
- Pneumonia Dataset: [Link](https://www.kaggle.com/datasets/paultimothymooney/chest-xray-pneumonia)
- COVID-19 Dataset: [Link](https://www.kaggle.com/datasets/tawsifurrahman/covid19-radiography-database)
- Tuberculosis Dataset: [Link](https://www.kaggle.com/datasets/tawsifurrahman/tuberculosis-tb-chest-xray-dataset)
- Liver Disease: [Link](https://www.kaggle.com/datasets/rabieelkharoua/predict-liver-disease-1700-records-dataset/data)
- Viral Infection Dataset: [Link](https://www.kaggle.com/datasets/brsahan/viral-infection-study-dataset)

## Evaluation Metrics

- Accuracy
- Confusion Matrix
- Classification Report (Precision, Recall, F1-score)

## Installation Guide

1. Clone the repository:
   ```bash
   git clone https://github.com/fady103/Graduation_Project_final.git
   cd Graduation_Project_final
   ```