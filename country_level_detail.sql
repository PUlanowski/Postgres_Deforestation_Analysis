Instructions:

Answering these questions will help you add information into the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions.

/******************************************************************************/

/*
a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?

b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?
*/

WITH total_area_per_region_2016 AS (
  SELECT fa_country_name,
  r_region,
  fa_year,
  ROUND(fa_forest_area_sqkm) AS forest_area_sqkm_2016
  FROM forestation
  WHERE fa_year = 2016 AND fa_forest_area_sqkm IS NOT NULL
  ORDER BY forest_area_sqkm_2016 DESC
  ),
total_area_per_region_1990 AS (
  SELECT fa_country_name,
  r_region,
  fa_year,
  ROUND(fa_forest_area_sqkm) AS forest_area_sqkm_1990
  FROM forestation
  WHERE fa_year = 1990 AND fa_forest_area_sqkm IS NOT NULL
  ORDER BY forest_area_sqkm_1990 DESC

)
SELECT 
total_area_per_region_2016.fa_country_name,
total_area_per_region_2016.r_region,
forest_area_sqkm_2016,
forest_area_sqkm_1990,
(forest_area_sqkm_2016 - forest_area_sqkm_1990) AS forest_area_delta,
ROUND(CAST(((forest_area_sqkm_2016 - forest_area_sqkm_1990)/forest_area_sqkm_1990)*100 AS NUMERIC), 2) AS forest_pct_delta

FROM total_area_per_region_2016
JOIN total_area_per_region_1990
ON total_area_per_region_2016.fa_country_name = total_area_per_region_1990.fa_country_name
ORDER BY forest_area_delta DESC /*forest_pct_delta*/ ;
/* 
country forestation increase 3A
fa_country_name	    forest_area_sqkm_2016	forest_area_sqkm_1990	forest_area_delta
China	              2098635	              1571406	              527229
United States	      3103700	              3024500	              79200
India	              708604	              639390	              69214
Russian Federation	8148895	              8089500	              59395
Vietnam	            149020	              93630	                55390

*/


/* a
fa_country_name	r_region	                forest_area_delta
Brazil	        Latin America & Caribbean	541510
Indonesia	    East Asia & Pacific	        282194
Myanmar	        East Asia & Pacific	        107234
Nigeria	        Sub-Saharan Africa	        106506
Tanzania	    Sub-Saharan Africa	        102320
*/

/* b
fa_country_name  	r_region            	forest_pct_delta

Togo	      Sub-Saharan Africa	        -75.45
Nigeria	    Sub-Saharan Africa	        -61.8
Uganda	    Sub-Saharan Africa	        -59.13
Mauritania	Sub-Saharan Africa	        -46.75
Honduras	  Latin America & Caribbean	  -45.03

*/

/*c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?*/ 

WITH forest_2016 AS(
SELECT fa_country_name AS country,
r_region AS region,
ROUND(CAST(fa_forest_area_sqkm / (la_total_area_sq_mi * 2.59) AS NUMERIC) * 100, 2) AS pct_forest_2016
FROM forestation
WHERE fa_year = 2016
    AND fa_forest_area_sqkm != 0
    AND la_total_area_sq_mi != 0
ORDER BY pct_forest_2016 DESC
)
SELECT 
CASE WHEN pct_forest_2016 <= 25 THEN 'Q1'
     WHEN pct_forest_2016 > 25 AND pct_forest_2016 <=50 THEN 'Q2'
     WHEN pct_forest_2016 > 50 AND pct_forest_2016 <=75 THEN 'Q3'
     ELSE 'Q4'
END AS quartile,
COUNT(country)
FROM forest_2016
GROUP BY quartile
ORDER BY quartile;

/*
quartile	count
Q1      	  85
Q2	        73
Q3	        38
Q4	         9
*/

/*d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.*/

WITH forest_2016 AS(
SELECT fa_country_name AS country,
r_region AS region,
ROUND(CAST(fa_forest_area_sqkm / (la_total_area_sq_mi * 2.59) AS NUMERIC) * 100, 2) AS pct_forest_2016
FROM forestation
WHERE fa_year = 2016
    AND fa_forest_area_sqkm != 0
    AND la_total_area_sq_mi != 0
ORDER BY pct_forest_2016 DESC
)
SELECT 
CASE WHEN pct_forest_2016 <= 25 THEN 'Q1'
     WHEN pct_forest_2016 > 25 AND pct_forest_2016 <=50 THEN 'Q2'
     WHEN pct_forest_2016 > 50 AND pct_forest_2016 <=75 THEN 'Q3'
     ELSE 'Q4'
END AS quartile,
country,
region,
pct_forest_2016
FROM forest_2016
ORDER BY quartile DESC;

/*e. How many countries had a percent forestation higher than the United States in 2016?*/

/*answer: 94*/

WITH forest_2016 AS(
SELECT fa_country_name AS country,
r_region AS region,
ROUND(CAST(fa_forest_area_sqkm / (la_total_area_sq_mi * 2.59) AS NUMERIC) * 100, 2) AS pct_forest_2016
FROM forestation
WHERE fa_year = 2016
    AND fa_forest_area_sqkm != 0
    AND la_total_area_sq_mi != 0
ORDER BY pct_forest_2016 DESC
)
SELECT 
COUNT(*)
FROM forest_2016
WHERE pct_forest_2016 > (SELECT pct_forest_2016 FROM forest_2016 WHERE country = 'United States');
