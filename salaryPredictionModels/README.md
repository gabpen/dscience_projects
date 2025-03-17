
# **Salary Prediction: k-NN vs. Linear Regression**  

## Overview

This project compares k-Nearest Neighbors (k-NN) regression and Linear Regression to predict data science salaries in South America. By analyzing key job-related factors, the models estimate salary ranges based on education level, years of experience, company rating, country-specific indicators, and English proficiency.  

The Elbow Method was used to determine the optimal number of neighbors (k = 3) for k-NN, ensuring a balance between accuracy and generalization. Both models were assessed using R^2 and RMSE, demonstrating that k-NN provides better predictive performance, capturing salary variations more effectively than the linear model.  

**Disclaimer:** The dataset used in this project **does not contain real-world data**. It consists of **simulated values** and should not be used for actual salary analysis or decision-making.  

## Features 

- **Salary Estimation:** Predict salaries for data science positions based on key job-related factors.  
- **Model Comparison:** Evaluate and compare the performance of k-NN and Linear Regression.  
- **Elbow Method Analysis:** Determine the best k value for k-NN regression.  
- **Performance Metrics:** Assess models using R^2 (coefficient of determination) and RMSE (Root Mean Squared Error).  

## **Technologies Used**  

- **Python:** Core programming language for model implementation.  
- **Scikit-learn:** Used for machine learning models, data preprocessing, and performance evaluation.  
- **Pandas:** Library for handling and manipulating data.  
- **NumPy:** Numerical computations and array handling.  
- **Matplotlib & Seaborn:** Data visualization tools for analysis.  

## **How to Use**  

1. **Clone the Repository:** Download the project files from the repository.  
2. **Install Dependencies:** Ensure all required Python packages are installed.  
3. **Run the Notebook:** Open and execute `salary_prediction_models.ipynb` in Jupyter Notebook or Google Colab.  
4. **Make Predictions:** Adjust job characteristics and use the trained models to estimate salaries.  

## **Example Showcase**  

### **Prediction Example**  

To demonstrate the model, a salary prediction is generated for a **data scientist position** with the following characteristics:  

- **English Proficiency:** Yes  
- **Education Level:** Postgraduate Degree (6)  
- **Years of Experience:** 2 years  
- **Company Score:** 7.5 (High-rated workplace)  
- **Country Score:** 34.0  

These values are processed through the trained model to estimate the expected salary, providing insights into potential earnings for similar job roles.  

## **Conclusion**  

This project demonstrates the effectiveness of machine learning models in predicting salaries for data science positions. The results show that k-NN outperforms Linear Regression, making it a more reliable choice for capturing salary variations. The model can be further improved by incorporating additional features or testing alternative algorithms.  

**Disclaimer:** This dataset is entirely **simulated** and should not be used for real-world analysis or decision-making.  