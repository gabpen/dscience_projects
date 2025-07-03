
# Data Science Portfolio

Welcome to my portfolio repository — a curated collection of data science projects showcasing my ability to work across the full data pipeline. From data acquisition and preprocessing to modeling, evaluation, and visualization, these projects highlight my hands-on experience with supervised learning, statistical modeling, computer vision, and interactive tools. I focus on building reproducible, interpretable, and production-ready workflows that turn complex datasets into actionable insights.

---

## What’s Inside

Each folder contains a self-contained project, complete with code, documentation, and visual results. Key themes include labor economics, statistical modeling, and machine learning for development. Highlights include:

### 🔗 Quick Access to Projects

* [`job-scraper-panama`](webScraping/) – Automates job scraping from LinkedIn for Panama City
* [`latam-ds-job-market`](laborMarketEDA/) – Analyzes the data science job market in Latin America
* [`salary-prediction`](salaryPredictionModels/) – Compares k-NN and Linear Regression for salary prediction
* [`economic-indicators-dashboard`](streamlitEconomicIndicators/) – Interactive dashboard for economic data
* [`ocr-image-processing`](imageProcessing/) – Text extraction and face detection from images
* [`recidivism-survival-analysis`](survivalAnalysis/) – Survival models for recidivism risk
* [`cranio-growth-longitudinal`](LongitudinalData/) – Mixed-effects models for growth trajectories
* [`poverty-cnn-sustainlab`](satelliteDeepLearning/) – CNNs to predict poverty using satellite imagery

---

## 📂 New: Poverty Prediction with Satellite Imagery

This project applies **Convolutional Neural Networks (CNNs)** to estimate poverty levels in Africa using the SustainBench SDG1 dataset on poverty change. It compares ResNet18, ResNet50, and EfficientNet-B0 using 5-fold cross-validation. Users can choose between **true-color** or **false-color** band compositions when preparing the satellite imagery.

🔍 **Key Features:**

* Predicts poverty with satellite images where on-the-ground data is scarce
* Includes model evaluation (MAE, R²), training visualizations, and final performance comparison across CNNs
* Offers a configurable setup for band composition (RGB vs. NIR-R-G)

📁 **Tools:** PyTorch · Scikit-learn · OpenCV · PIL · Pandas · NumPy

🧪 [Full project details here](satelliteDeepLearning/) — including visualizations and code to reproduce results.

---

## Technologies Used

Python · R · PyTorch · pandas · scikit-learn · NumPy · Streamlit · statsmodels · OpenCV · Tesseract OCR · Torchvision · Matplotlib · Seaborn · ggplot2 · survminer · dplyr

---

## Why This Portfolio

This space brings together what I enjoy most: working with real-world data, designing tools with clear purpose, and communicating results visually and rigorously. It’s an evolving reflection of how I approach applied data science — always learning, experimenting, and iterating.

---

## 💡 Tip

Each project is designed to be replicable and adaptable. Feel free to explore, use, or reach out with questions and ideas.

---

## License

This repository is licensed under the MIT License. See the [LICENSE](https://mit-license.org) file for more details.

