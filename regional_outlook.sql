2. REGIONAL OUTLOOK
Instructions:

1/ Answering these questions will help you add information into the template.
2/Use these questions as guides to write SQL queries.
3/Use the output from the query to answer these questions.
4/Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
Based on the table you created, ....

/******************************************************************************/

/*a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?

b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?

c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?

answer:
r_region	                      pct_round_2016	          pct_round_1990

East Asia & Pacific	            26.36	                    25.78
Europe & Central Asia	          38.04	                    37.28
Latin America & Caribbean	      46.16	                    51.03
Middle East & North Africa	     2.07	                     1.78
North America	                  36.04	                    35.65
South Asia	                    17.51	                    16.51
Sub-Saharan Africa	            28.79	                    30.67
World	                          31.38	                    32.42
*/


WITH total_area_per_region_2016 AS (
  SELECT DISTINCT r_region,
  fa_year,
  SUM(la_total_area_sq_mi * 2.59) OVER win_regions AS sum_total_area_km,
  SUM(fa_forest_area_sqkm) OVER win_regions AS sum_total_forest_km,
  (SUM(fa_forest_area_sqkm) OVER win_regions / SUM(la_total_area_sq_mi * 2.59) OVER win_regions)*100 AS pct_forest_2016 
  FROM forestation
  WHERE fa_year = 2016
  
  WINDOW win_regions AS (PARTITION BY r_region ORDER BY r_region)
),
total_area_per_region_1990 AS (
  SELECT DISTINCT r_region,
  fa_year,
  SUM(la_total_area_sq_mi * 2.59) OVER win_regions AS sum_total_area_km,
  SUM(fa_forest_area_sqkm) OVER win_regions AS sum_total_forest_km,
  (SUM(fa_forest_area_sqkm) OVER win_regions / SUM(la_total_area_sq_mi * 2.59) OVER win_regions)*100 AS pct_forest_1990
  FROM forestation
  WHERE fa_year = 1990
  
  WINDOW win_regions AS (PARTITION BY r_region ORDER BY r_region)
)
SELECT 
total_area_per_region_2016.r_region,
ROUND(CAST(pct_forest_2016 AS NUMERIC), 2) AS pct_round_2016,
ROUND(CAST(pct_forest_1990 AS NUMERIC), 2) AS pct_round_1990
FROM total_area_per_region_2016
JOIN total_area_per_region_1990
ON total_area_per_region_2016.r_region = total_area_per_region_1990.r_region
ORDER BY total_area_per_region_2016.r_region;



