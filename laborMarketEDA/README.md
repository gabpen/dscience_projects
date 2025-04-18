
# Labor Market Analysis for Data Science Positions in Latin America

## Project Summary

This project presents an exploratory data analysis (EDA) of data science job postings in Latin America. It investigates key factors influencing salary levels, including education, experience, English proficiency, and national innovation indexes. Using statistical summaries, visualizations, and regression modeling, the project identifies regional trends and country-specific dynamics in the labor market.

## Features

- **Job Availability Analysis:** Identifies overrepresented and underrepresented countries based on job posting frequency using bar charts and summary statistics.
- **Salary Distribution Analysis:** Uses histograms, KDEs, and boxplots to examine salary trends, detect outliers, and assess wage dispersion across countries.
- **English Proficiency Impact:** Compares salary distributions between English speakers and non-speakers using descriptive statistics and boxplots.
- **Education and Experience Requirements:** Visualizes and compares the average years of education and work experience required by country.
- **Correlation Matrix:** Evaluates relationships between salary and explanatory variables using a heatmap to identify potential predictors.
- **Regression Modeling:** Builds a multivariate regression model to predict salaries and compares results at the regional and country-specific levels.

## Technologies Used

- **Python:** Main programming language for data analysis.
- **Pandas:** Data manipulation and transformation.
- **Seaborn & Matplotlib:** Visualization libraries for statistical graphics.
- **Statsmodels:** Used for building and interpreting regression models.
- **Jupyter Notebook / Google Colab:** For running and documenting the analysis workflow.

## How to Use

1. **Clone the Repository:** Download the project files or clone the repository to your local machine.
2. **Install Dependencies:** Ensure all required libraries (Pandas, Seaborn, Matplotlib, Statsmodels) are installed in your environment.
3. **Run the Analysis:** Open the notebook and run the cells step by step to explore the data and insights.
4. **Interpret the Results:** Use the generated tables, charts, and regression summaries to understand salary patterns and job requirements in the region.

## **Example Showcase**

### **Country: Ecuador**

#### **Key Observations:**

- **English proficiency** is the most influential factor in salary determination for data scientists.
- **Education and experience** remain strong predictors of salary, though with reduced impact compared to the regional model.
- The **innovation index (CountryScore)** has minimal influence due to lack of variability within the Ecuadorian dataset.
- The **perfect model fit (R² = 1.000)** and absence of autocorrelation suggest a strong and well-behaved regression model for Ecuador.

Boxplots, correlation matrices, and regression outputs collectively illustrate how these factors shape earnings in Ecuador’s data science labor market, providing a valuable reference for national workforce development strategies.

## Conclusion

This project offers a structured and data-driven approach to understanding salary trends and job characteristics in the region. It serves as a valuable resource for policymakers, researchers, and professionals seeking insights into the evolving demand for data science talent in Latin America.