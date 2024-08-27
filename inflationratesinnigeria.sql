--creating table
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

--finding out the minimum year
select min(year)
from inflationrates;
--figuring out average inflation rate from year between 2008 and 2016
select avg(inflation_rate) as avg_inflationrate
from inflationrates 
where year between 2008 and 2016;

--figuring out the average inflation rate from year between 2016 and 2017
select avg(inflation_rate) as avg_inflationrate
from inflationrates
where year between 2017 and 2024;

-- difference in inflation rate from 2008- 2016 and 2017-2024
select round(avg(inflation_rate)::numeric, 2) as overall_avg_inflationrate, 
round(avg(case when year between 2008 and 2016 then inflation_rate end)::numeric,2) as avg_inflationrate_2008_2016,
round(avg(case when year between 2017 and 2024 then inflation_rate end)::numeric, 2) as avg_inflationrate_2017_2024
from inflationrates;

--finding out how the changes in crude oil prices affect inflation rates in nigera
--going to be performing a correlation and regression analysis
select *
from inflationrates;

select avg(inflation_rate) as avg_inflation_rate,
		min(inflation_rate) as min_inflation_rate,
		max(inflation_rate) as max_inflation_rate,
		avg(crude_oil_price) as avg_crude_oil_price,
		min(crude_oil_price) as min_crude_oil_price,
		max(crude_oil_price) as max_crude_oil_price
from inflationrates;

--calculating the correlation coefficient
select corr(inflation_rate, crude_oil_price) as correlation_coefficient
from inflationrates;
--it gives a negative correlation ie when the price of crude oil increases, inflation rate decreases

--regression analysis
select regr_slope(inflation_rate, crude_oil_price) as slope,
		regr_intercept(inflation_rate, crude_oil_price) as intercept
from inflationrates;

-- the negative slope gotten suggest that as crude oil price increases, inflation rates tend to decrease

select * from inflationrates;

--sectoral risk analysis
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

