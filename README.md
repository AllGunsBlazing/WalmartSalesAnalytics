# 🛒 Walmart Sales Data Analysis: Unlocking Business Insights 📊

**Project Goal:** To extract valuable business insights from Walmart sales data using a combination of Python for data handling and SQL for in-depth analysis. This end-to-end project demonstrates a practical data analysis workflow.

---

## 🚀 Project Journey: Step-by-Step

Here's a breakdown of the stages involved in this data analysis project:

1.  **🛠️ Setting Up Your Workspace:**
    * **Tools:** VS Code, Python, SQL (MySQL)
    * **Objective:** Organise your project environment for efficient development.

2.  **🔑 Connecting to Kaggle API:**
    * **Action:** Obtain and configure your Kaggle API token to directly download datasets.
    * **How-to:** [Kaggle Profile Settings](https://www.kaggle.com/) → Download `kaggle.json` → Place in `.kaggle` folder → Use `kaggle datasets download -d <dataset-path>`.

3.  **💾 Downloading the Sales Data:**
    * **Source:** Walmart Sales Dataset on Kaggle.
    * **Link:** [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
    * **Storage:** Data will be saved in the `data/` directory.

4.  **🐍 Installing Libraries & Loading Data:**
    * **Install:** Run `pip install pandas numpy sqlalchemy mysql-connector-python psycopg2`.
    * **Load:** Use Pandas to read the downloaded data for initial processing.

5.  **🔍 Exploring the Dataset:**
    * **Goal:** Understand the data's structure, columns, types, and identify any initial quirks.
    * **Techniques:** Employ `.info()`, `.describe()`, and `.head()` for a quick overview.

6.  **🧹 Data Cleaning & Preparation:**
    * **Actions:**
        * Remove duplicate entries.
        * Handle missing values appropriately.
        * Ensure consistent data types.
        * Format currency values.
        * Validate the cleaned data.

7.  **✨ Feature Engineering:**
    * **Creation:** Calculate the `Total Amount` (unit price × quantity) and add it as a new column.
    * **Benefit:** Simplifies subsequent SQL analysis.

8.  **📤 Loading Data to SQL Databases:**
    * **Databases:** MySQL.
    * **Method:** Use `sqlalchemy` in Python to establish connections and load the cleaned data into tables.
    * **Verification:** Run basic SQL queries to confirm successful data loading.

9.  **📊 SQL Analysis: Key Business Insights Through Strategic Queries**

    This section highlights a few strategic SQL queries that were instrumental in uncovering key business insights from the Walmart sales data.

    **1. Highest-Rated Category per Branch:**
       - **Objective:** Identify the top-rated product category within each Walmart branch using ranking based on average ratings.
       ```sql
       SELECT branch, category, avg_rating
       FROM (
           SELECT
               branch,
               category,
               AVG(rating) AS avg_rating,
               RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
           FROM walmart
           GROUP BY branch, category
       ) AS ranked
       WHERE rank = 1;
       ```

    **2. Busiest Day for Each Branch:**
       - **Objective:** Determine the day of the week with the highest transaction volume for each branch to understand peak operational times.
       ```sql
       SELECT branch, day_name, no_transactions
       FROM (
           SELECT
               branch,
               DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
               COUNT(*) AS no_transactions,
               RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
           FROM walmart
           GROUP BY branch, day_name
       ) AS ranked
       WHERE rank = 1;
       ```

    **3. Top Branches with Revenue Decrease (Year-over-Year):**
       - **Objective:** Identify the branches that experienced the most significant decline in revenue compared to the previous year, providing insights into potentially struggling locations.
       ```sql
       WITH revenue_2022 AS (
           SELECT
               branch,
               SUM(total) AS revenue
           FROM walmart
           WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
           GROUP BY branch
       ),
       revenue_2023 AS (
           SELECT
               branch,
               SUM(total) AS revenue
           FROM walmart
           WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
           GROUP BY branch
       )
       SELECT
           r2022.branch,
           r2022.revenue AS last_year_revenue,
           r2023.revenue AS current_year_revenue,
           ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
       FROM revenue_2022 AS r2022
       JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
       WHERE r2022.revenue > r2023.revenue
       ORDER BY revenue_decrease_ratio DESC
       LIMIT 3; -- Limiting to a few for brevity
       ```

10. **📢 Sharing & Documenting the Project:**
    * **Documentation:** Maintain clear records in Markdown or Jupyter Notebooks.
    * **Publishing:** Share the project on GitHub, including:
        * This `README.md` file.
        * Jupyter Notebooks (if used).
        * SQL scripts (`sql_queries/`).
        * Instructions to access data (`data/`).

---

## ⚙️ System Requirements

* **Python Version:** 3.8+
* **SQL Databases:** MySQL
* **Python Libraries:** `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`, `psycopg2`
* **Access:** Kaggle API Key

## 🚀 Quick Start

1.  **Clone the Repository:**
    ```bash
    git clone <repo-url>
    ```
2.  **Install Dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
3.  Follow the project steps to set up your Kaggle API, download the data, and begin the analysis!

---

## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---
## 📈 Key Findings & Insights 

This section will be populated with the results of the SQL analysis, including:

* **Sales Performance:** Top categories, best-performing branches, and popular payment methods.
* **Profitability Analysis:** Most profitable product lines and locations.
* **Customer Behavior:** Insights into ratings, payment preferences, and peak shopping times.

## 🔮 Future Enhancements

Potential improvements and expansions for this project:

* Integration with visualization tools like Power BI or Tableau for interactive dashboards.
* Incorporating additional datasets for a more comprehensive analysis.
* Automating the data pipeline for real-time data updates and analysis.

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

* **Data Source:** The valuable Walmart Sales Dataset provided by Kaggle.
* **Inspiration:** Real-world business challenges and Walmart's strategies in sales and supply chain.
