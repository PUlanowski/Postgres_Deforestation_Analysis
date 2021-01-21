Steps to Complete
1/ Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.
2/ The forest_area and land_area tables join on both country_code AND year.
3/ The regions table joins these based on only country_code.
4/ In the ‘forestation’ View, include the following:
  All of the columns of the origin tables
  A new column that provides the percent of the land area that is designated as forest.
5/ Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).

/******************************************************************************/
CREATE VIEW forestation AS
SELECT
  /*full selection from forest area*/
  fa.country_code AS fa_country_code,
  fa.country_name AS fa_country_name,
  fa.year AS fa_year,
  fa.forest_area_sqkm AS fa_forest_area_sqkm,

  /*full selection from land area*/
  la.country_code AS la_country_code,
  la.country_name As la_country_name,
  la.year AS la_year,
  la.total_area_sq_mi AS la_total_area_sq_mi,

  /*full selection from regions*/
  r.country_name AS r_country_name,
  r.country_code AS r_country_code,
  r.region AS r_region,
  r.income_group AS r_income_group,
/*additional column to see % of forestation, no rounding*/
(fa.forest_area_sqkm / (la.total_area_sq_mi*2.59))*100 AS forestation_percent

  FROM forest_area AS fa
    JOIN land_area as la
    ON fa.country_code = la.country_code
      AND fa.year = la.year

    JOIN regions AS r
    ON fa.country_code = r.country_code;
