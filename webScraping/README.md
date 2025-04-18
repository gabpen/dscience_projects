
# **LinkedIn Job Scraper for Panama City**  

## Overview

This project is a web scraper designed to extract job postings for Data Scientists in Panama City from LinkedIn. Using Python, BeautifulSoup, and Requests, it automates job searches, extracts key details (job title, company, location, and job URL), and enables further analysis of job demand in the region. While the default search is set to Data Scientist roles in Panama City, the scraper can be customized to retrieve job listings for any position in one or multiple countries.

## Features 

- **Automated Job Search:** Scrapes LinkedIn for job listings based on a specified job title and location.  
- **Pagination Handling:** Iterates through multiple result pages to gather comprehensive job data.  
- **Data Cleaning:** Extracts and formats job details to ensure structured and readable output.  
- **Custom Headers:** Uses a User-Agent header to avoid detection and minimize request blocks.  
- **Error Handling:** Implements exception handling to manage network issues and missing data fields.  

## **Technologies Used**  

- **Python:** Core programming language.  
- **Requests:** Handles HTTP requests to fetch job search pages.  
- **BeautifulSoup:** Parses HTML to extract job details.  
- **Regular Expressions (re):** Cleans and formats extracted text.  
- **Time.sleep():** Prevents excessive requests to avoid being blocked.  

## How It Works 

1. **Generate a LinkedIn Job Search URL:** Uses keywords (`position`) and `location` to create a search URL.  
2. **Send an HTTP Request to LinkedIn:** Retrieves the job listing page using `requests.get()`.  
3. **Parse the HTML with BeautifulSoup:** Extracts job titles, companies, locations, and job URLs from the page.
4. **Loop Through Multiple Pages:** Continues scraping until no more jobs are found.
5. **Store and Display Data:** Saves job listings in a structured format for further analysis.  

## Limitations

- LinkedIn may block excessive requests.
- Results may be limited for unregistered users. 
- Pagination stops when no more listings are found.

## Conclusion

This LinkedIn Job Scraper for Panama City provides an efficient way to automate job searches and analyze demand for Data Scientist roles. By extracting and structuring key job details, it helps job seekers, recruiters, and analysts gain insights into hiring trends. While the default settings focus on Panama City, the scraper can be easily customized to search for any job position in multiple countries, making it a versatile tool for labor market analysis.