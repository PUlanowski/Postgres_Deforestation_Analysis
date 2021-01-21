/*a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.*/

answer: 41282694.9

SELECT *
FROM forestation
WHERE fa_country_name = 'World'
	AND fa_year = 1990;

/*b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”*/

answer: 39958245.9

SELECT *
FROM forestation
WHERE fa_country_name = 'World'
	AND fa_year = 2016;

/*c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?*/

answer: 1324449

SELECT *
FROM forestation
WHERE fa_country_name = 'World'
	AND fa_year = 2016
  OR fa_country_name = 'World'
  AND fa_year = 1990;

/*d. What was the percent change in forest area of the world between 1990 and 2016?*/
answer: 3.20824258980244%

/*e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?*/
answer: in 2016 forest area lost was closest to total area of Peru (1279999.9891) km2

SELECT *,
(la_total_area_sq_mi * 2.59) AS la_total_area_sq_km
FROM forestation
WHERE (la_total_area_sq_mi * 2.59)
	/*applying 1% threshold to see which country will fits the best and iterate by
   1%, on 4% variation we finally have result*/
    BETWEEN 1324449 *0.96 AND 1324449 *1.04
    AND fa_year = 2016;
