# Nigeria Inflation Rate Analysis
![image](https://github.com/user-attachments/assets/671a18f4-1358-4746-9449-265da6c98b53)

## Key Insights
- Negative Correlation Between Crude Oil Prices and Inflation: The regression analysis reveals a negative correlation between crude oil prices and inflation rates. This suggests that as oil prices decrease, inflation rates tend to rise, highlighting the complex dynamics between global oil markets and local economic conditions in Nigeria.

- Sectoral Sensitivity to Oil Prices: Among the various CPI components, the energy sector showed the highest sensitivity to changes in crude oil prices. This indicates that fluctuations in oil prices have a significant impact on energy costs, which in turn affects the overall inflation rate.

- Volatility Analysis: The crude oil market's volatility significantly impacts Nigeria's inflation rates, given the country's reliance on oil exports. This analysis can help policymakers understand the need for diversity in  economic strategies to reduce the risks associated with oil price volatility.

## Table of Content
- [Project Overview](#project-overview)
- [Questions the Analysis Answers](#questions-the-analysis-answers)
- [Dataset](#dataset)
- [Data Cleaning and Analysis](#data-cleaning-and-analysis)
- [Data Visualization with Python](#data-visualization-with-python)
- [Conclusion](#conclusion)

## Project Overview
This project explores the dynamics of inflation in Nigeria from 2008 to 2024. It focuses on how key economic indicators such as crude oil prices, production levels, and various Consumer Price Index (CPI) components influence inflation rates. Using a structured approach, I cleaned the dataset, imported it into a PostgreSQL database, performed a comprehensive analyses, and visualized the results using Python. This README file contains details of the entire process, the challenges I encountered, and all of the findings I made from the analysis.

## Questions the Analysis Answers
The economic state of our country has been so high lately.  I had these questions in mind, so I decided to answer them with this analyis.

1. How have inflation rates in Nigeria changed over time from 2008 to 2024?
2. What is the relationship between crude oil prices and inflation rates in Nigeria?
3. How do various CPI components (such as food, energy, health, transport, communication, and education) respond to changes in crude oil prices?
4. Which sector has the highest risk in response to crude oil price changes?
5. How did inflation rates differ between the periods 2008-2016 and 2017-2024?
6. What are the implications of a negative correlation between crude oil prices and inflation for Nigeria’s economy?

## Dataset
The dataset was gotten from [Kaggle](https://www.kaggle.com/datasets/iamhardy/nigeria-inflation-rates) -  a website that contains different datasets that helps anyone practice their skills in data analysis, data science and other related fields. There, you can find everything you need to know about the dataset. 

## Data Cleaning and Analysis
### 1. **Data Cleaning with Microsoft Excel:**
The datset was not clean initially it inculeded some missing values and incorrect data formats. I used *Microsoft Excel* to perform the following cleaning tasks:

- Removed Rows with Missing Values: I identified rows with missing values and decided to replace them. For numerical columns such as crude_oil_price, production, and export, I replaced missing values with the median of the column to avoid skewing the data.
- Formatted Data Types: I ensured all data types were consistent. For instance, months were converted from numeric values to their respective names (e.g., 1 to January) to have better readability and to conduct a better analysis .
- Checked for Duplicates: *Fortunately* for me, there were no duplicates in the dataset.

### 2. **Importing Data into PostgreSQL:**
With a cleaned dataset, I moved on to PostgreSQL for more advanced data manipulation and analysis. Using pgAdmin 4, I created a new table to store the dataset. Here is how I did it:

- Created a Table in pgAdmin 4: I defined the table schema to match the structure of the cleaned dataset, specifying appropriate data types for each column.

```sql
CREATE TABLE InflationRates (
    Year integer,
	Month text, 
    inflation_rate DOUBLE PRECISION,
    crude_oil_price DOUBLE PRECISION,
    production DOUBLE PRECISION,
    crude_oil_export DOUBLE PRECISION,
    cpi_food DOUBLE PRECISION,
    cpi_energy DOUBLE PRECISION,
    cpi_health DOUBLE PRECISION,
    cpi_transport DOUBLE PRECISION,
    cpi_communication DOUBLE PRECISION,
    cpi_education DOUBLE PRECISION
);
```
- Imported the Dataset: After creating the table, I right clicked on the already created created table and clicked on the option to import or export a table, then selected the file and imported it 

![Screenshot 2024-08-27 211833](https://github.com/user-attachments/assets/9058ef16-f839-40c4-867d-e782ee387a17) ![Screenshot 2024-08-27 212923](https://github.com/user-attachments/assets/b4dafff2-bef3-4640-99f6-4418fc0e470b)


### 3. **Data Analysis in PostgreSQL :**
After I sucsessfully imported the dataset into PostgreSQL, I began analyzing the data to unveil trends and insights. This analysis focused on several key areas:

- Inflation Rate Comparison: I compared inflation rates between two distinct periods, 2008-2016 and 2017-2024, to understand how inflation has evolved over time.
```sql
select round(avg(inflation_rate)::numeric, 2) as overall_avg_inflationrate, 
round(avg(case when year between 2008 and 2016 then inflation_rate end)::numeric,2) as avg_inflationrate_2008_2016,
round(avg(case when year between 2017 and 2024 then inflation_rate end)::numeric, 2) as avg_inflationrate_2017_2024
from inflationrates;
```
*Result*

The analysis revealed that there was a huge increase in inflation rates from the year 2017-2024 compared to the year 2008-2016
![Screenshot 2024-08-27 213747](https://github.com/user-attachments/assets/9d47ddd8-dcda-4aa2-a684-dcc427654a0d)

- Correlation & Regression Analysis: I examined the relationship between crude oil prices and various CPI components to understand how oil price fluctuations impact inflation. I also performed linear regression to help quantify the impact of crude oil prices on each CPI component. This helped identify which sectors are most sensitive to changes in oil prices.
```sql
--correlation analysis
select corr(inflation_rate, crude_oil_price) as correlation_coefficient
from inflationrates;

--regression analysis
select regr_slope(inflation_rate, crude_oil_price) as slope,
    regr_intercept(inflation_rate, crude_oil_price) as intercept
from inflationrates;
```
*Results*

![Screenshot 2024-08-27 215407](https://github.com/user-attachments/assets/50dc20dc-cb8e-40da-9128-2bb2686f44fd) ![Screenshot 2024-08-27 220228](https://github.com/user-attachments/assets/df8300f1-875d-470d-bbd2-93428cbc6d67)

Performing these analyses revealed to me that there is a weak negative correlation, and an inverse relationship between inflation rates and the price of crude oil sold. This means when the price of crude oil sold to foriegn parties increases, the rate of inflation decreases. The correlation is a weak one which suggests the price crude oil is sold does not, in all cases, affect the the rate of inflation in Nigeria.
- Sectoral Risk Analysis: I also carried out sectoral risk analysis to determine which CPI component has the highest risk with respect to crude oil prices. This analysis is very important to understand how vulnerable different sectors are to the volatility of oil prices.
``` sql
select avg(cpi_health) as avg_cpi_health,
		stddev(cpi_health) as stddev_cpi_health,
		avg(cpi_food) as avg_cpi_food,
		stddev(cpi_food) as stddev_cpi_food,
		avg(cpi_energy) as avg_cpi_energy,
		stddev(cpi_energy) as stddev_cpi_energy,
		avg(cpi_transport) as avg_cpi_transport,
		stddev(cpi_transport) as stddev_cpi_transport,
		avg(cpi_education) as avg_cpi_education,
		stddev(cpi_education) as stddev_cpi_education
from inflationrates;

--correlation of cpi components with respect to crude oil price,
--to know the cpi component with the highest risk
select 
    round(corr(cpi_food, crude_oil_price)::numeric, 2) as corr_cpi_food_crude_oil,
    round(corr(cpi_energy, crude_oil_price)::numeric, 2) as corr_cpi_energy_crude_oil,
    round(corr(cpi_health, crude_oil_price)::numeric, 2) as corr_cpi_health_crude_oil,
	round(corr(cpi_transport, crude_oil_price)::numeric, 2) as corr_cpi_transport_crude_oil,
	round(corr(cpi_education, crude_oil_price)::numeric, 2) as corr_cpi_transport_crude_oil
from 
    inflationrates;
--regression analysis of cpi components to know which
--component has the highest risk
select
   	round(regr_slope(cpi_food, crude_oil_price)::numeric, 2) as slope_cpi_food_crude_oil,
	round(regr_intercept(cpi_food, crude_oil_price)::numeric, 2) as intercept_cpi_food_crude_oil,
    round(regr_slope(cpi_energy, crude_oil_price)::numeric, 2) as slope_cpi_energy_crude_oil,
    round(regr_intercept(cpi_energy, crude_oil_price)::numeric, 2) as intercept_cpi_energy_crude_oil,
    round(regr_slope(cpi_health, crude_oil_price)::numeric, 2) as slope_cpi_health_crude_oil,
    round(regr_intercept(cpi_health, crude_oil_price)::numeric, 2) as intercept_cpi_health_crude_oil,
	round(regr_slope(cpi_transport, crude_oil_price)::numeric, 2) as slope_cpi_health_crude_oil,
	round(regr_intercept(cpi_transport, crude_oil_price)::numeric, 2) as intercept_cpi_transport_crude_oil,
	round(regr_slope(cpi_education, crude_oil_price)::numeric, 2) as slope_cpi_education_crude_oil,
	round(regr_intercept(cpi_education, crude_oil_price)::numeric, 2) as intercept_cpi_education_crude_oil
from
    inflationrates;
```
*Results*:

**correlation coefficients**
![Screenshot 2024-08-27 220946](https://github.com/user-attachments/assets/d43f3a14-d60b-4d1c-9a2a-fe945e6021fa)
**regression slope and intercepts**
![Screenshot 2024-08-27 221019](https://github.com/user-attachments/assets/6337665c-7071-4629-8cc3-db0bf96abbb9) ![Screenshot 2024-08-27 221034](https://github.com/user-attachments/assets/2c4a9ae9-e59c-475e-9954-8db9c4cf79e9)

From this result, we can conclude the Energy sector has the highest risk when it comes to changes in crude oil prices because it has the highest absolute correlation amongst the other sectors (-0.16) and it has the steepest negative slope (-0.74)
**NOTE** the (-) only indicates if the correlation is positive or negative. 

## Data Visualization with Python
To better understand the results from the PostgreSQL analysis and to present them in a more digestible format, I used Python's visualization libraries, such as Matplotlib and Seaborn.

### Visualizing the Results
- Inflation Rate Trends: I used Python to visualize the trend in inflation rates from 2008 to 2024. This line chart provides a clear picture of how inflation has changed over the years, highlighting periods of high and low inflation.
![image](https://github.com/user-attachments/assets/d2d9b8f5-f97a-439b-bf47-2ea058025c4b)

As we can see in the chart, the inflation rate spiked after the year 2016. This led me to find out the difference in inflation rates between the years 2008-2016 and 2017-2024 during my analysis
- Correlation Analysis: With the use of scatter plots, I visualized the correlation between crude oil prices and inflation rates. This helped illustrate the relationship and showed how inflation rates responded to changes in oil prices.
![image](https://github.com/user-attachments/assets/eaf5cd7d-426a-4956-b703-6c94aace6abb)

This plot also confirms the analysis that there is a weak negative relationship between rate of inflation and crude oil prices.

- Regression Analysis Visualization: I created regression plots for each CPI component to visualize the sectoral risk analysis. These plots clearly depicted how each sector's CPI responded to changes in crude oil prices, allowing for a straightforward comparison of risk levels across sectors.

![image](https://github.com/user-attachments/assets/37d566d1-1a42-4d9b-aa0b-07eddcb52524)


## Conclusion
This project provided a comprehensive analysis of Nigeria's inflation dynamics over the past two decades. By leveraging data cleaning techniques, PostgreSQL for database management, and Python for data visualization, I was able to derive meaningful insights into how crude oil prices influence various sectors of the Nigerian economy. The findings highlight the importance of robust economic policies that can withstand global market fluctuations, particularly for a country that is  heavily reliant on oil exports.
