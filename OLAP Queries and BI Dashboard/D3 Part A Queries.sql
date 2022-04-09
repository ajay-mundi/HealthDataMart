/* D3 Part 1 Queries */

/* a. Drill Down and Roll Up - 2 queries */

/* drill down [The QOL drill down to country and year] */
/* 
 * Since the raw data is recorded on a yearly basis for each country, 
 * it is not meaningful to drill down further to months or city.
 * (the same data for all months in a certain year)
 */
SELECT Con."Continent", Con."Country", D."Decade", D."Year", F."QOL_Measure"
FROM public."FactTable" AS F, public."Month" AS D, public."Country" AS Con
WHERE F."Month_Key" = D."Month_Key" AND F."Country_Key" = Con."Country_Key"
GROUP BY (Con."Continent", Con."Country", D."Decade", D."Year", F."QOL_Measure")
ORDER BY Con."Continent", Con."Country", D."Year"

/* roll up [The average QOL roll up to continent] */
/* 
 * Roll up to observe the QOL for each continent as a whole
 */
SELECT Con."Continent", D."Decade", D."Year", AVG(F."QOL_Measure") AS average_QOL
FROM public."FactTable" AS F, public."Month" AS D, public."Country" AS Con
WHERE F."Month_Key" = D."Month_Key" AND F."Country_Key" = Con."Country_Key"
GROUP BY (Con."Continent", D."Decade", D."Year")
ORDER BY Con."Continent", D."Decade", D."Year"


/* b. Slice - 1 query */

/* slice [Measures in decade 20] */
/* 
 * When processing the data, we noticed 2009 has
 * the highest number of natural disasters.
 * We wanted to see if that makes an impact on the measures
 * so slice on the date dimension (2009 is in 20 decade).
 */
SELECT Con."Continent", Con."Country", D."Decade", D."Year", F."Dev_Measure", F."QOL_Measure", F."HDI_Measure"
FROM public."FactTable" AS F
INNER JOIN public."Month" AS D ON F."Month_Key" = D."Month_Key"
INNER JOIN public."Country" AS Con ON F."Country_Key" = Con."Country_Key" 
WHERE D."Decade" = 20
GROUP BY (Con."Continent", Con."Country", D."Decade", D."Year", F."Dev_Measure", F."QOL_Measure", F."HDI_Measure")
ORDER BY Con."Continent", Con."Country", D."Year"


/* c. Dice - 2 queries */

/* dice [The HDI of Canada and Indonesia each year from 20 decade to 21 decade] */
/* 
 * Canada is a developed country and Indonesia is a developing country.
 * Create a dice to compare their HDI.
 */
SELECT Con."Continent", Con."Country", D."Decade", D."Year", F."HDI_Measure"
FROM public."FactTable" AS F
INNER JOIN public."Month" AS D ON F."Month_Key" = D."Month_Key"
INNER JOIN public."Country" AS Con ON F."Country_Key" = Con."Country_Key" 
WHERE (D."Decade" = 20 OR D."Decade" = 21)
AND (Con."Country" = 'Canada' OR Con."Country" = 'Indonesia')
GROUP BY (Con."Continent", Con."Country", D."Decade", D."Year", F."HDI_Measure")
ORDER BY Con."Continent", Con."Country", D."Year"

/* dice [The QOL of Burundi and Canada when the puiblic education spending is >5% total GDP] */
/* 
 * We wanted to observe if the public education spending has
 * a big effect on QOL in a country.
 * We selected a underdeveloped country and a developed country
 * to contrast and compare QOL.
 */
SELECT Con."Continent", Con."Country", D."Year", E."Public_Education_Spending", F."QOL_Measure"
FROM public."FactTable" AS F
INNER JOIN public."Education" AS E ON F."Education_Key" = E."Education_Key"
INNER JOIN public."Country" AS Con ON F."Country_Key" = Con."Country_Key"
INNER JOIN public."Month" AS D ON F."Month_Key" = D."Month_Key"
WHERE (E."Public_Education_Spending" > 5)
AND (Con."Country" = 'Burundi' OR Con."Country" = 'Canada')
GROUP BY (Con."Continent", Con."Country", D."Year", E."Public_Education_Spending", F."QOL_Measure")
ORDER BY Con."Continent", Con."Country", D."Year"


/* d. Combining OLAP operations - 4 queries */

/* combine [Contrast QOL and the % population have access to basic sanitation (ABS) for each country]*/
/*
 * Drill down to the country level.
 * Slice on the QUlityofLife dimension with ABS < 60
 */
SELECT Con."Continent", Con."Country", D."Year", Q."Access_To_Basic_Sanitation_Total", F."QOL_Measure"
FROM public."FactTable" AS F
INNER JOIN public."QualityofLife" AS Q ON F."QOL_Key" = Q."QOL_Key"
INNER JOIN public."Country" AS Con ON F."Country_Key" = Con."Country_Key"
INNER JOIN public."Month" AS D ON F."Month_Key" = D."Month_Key"
WHERE (Q."Access_To_Basic_Sanitation_Total" < 60)
GROUP BY (Con."Continent", Con."Country", D."Year", Q."Access_To_Basic_Sanitation_Total", F."QOL_Measure")
ORDER BY Con."Continent", Con."Country", D."Year"

/* combine [Explore data characteristics on access to basic sanitation (ABS) and QOL for Africa and North America] */
/*
 * Roll up to continent level and dice to 2 continents and 2 decades
 * to study from the bigger picture.
 */

SELECT Con."Continent", D."Year", AVG(Q."Access_To_Basic_Sanitation_Total") AS average_sanitation, AVG(F."QOL_Measure") AS average_QOL
FROM public."FactTable" AS F
INNER JOIN public."QualityofLife" AS Q ON F."QOL_Key" = Q."QOL_Key"
INNER JOIN public."Country" AS Con ON F."Country_Key" = Con."Country_Key"
INNER JOIN public."Month" AS D ON F."Month_Key" = D."Month_Key"
WHERE (Con."Continent" = 'Africa' OR Con."Continent" = 'North America')
AND (D."Decade" = 21 OR D."Decade" = 22)
GROUP BY (Con."Continent", D."Year")
ORDER BY Con."Continent", D."Year"

/* combine [The lowest QOL rating of the decade for countries in Africa and North America showing total deaths casued by natural disasters] */
/*
 * Roll up to decade level.
 * Dice on the country dimension and the date dimension
 */
SELECT Con."Continent", Con."Country", D."Decade", SUM(E."Total_Deaths") AS total_deaths, MAX(F."QOL_Measure") AS lowest_QOL
FROM public."FactTable" AS F, public."Event" AS E, public."Country" AS Con, public."Month" AS D
WHERE F."Event_Key" = E."Event_Key" AND F."Country_Key" = Con."Country_Key" AND F."Month_Key" = D."Month_Key"
AND (Con."Continent" = 'Africa' OR Con."Continent" = 'North America')
AND (D."Decade" = 20 OR D."Decade" = 21)
GROUP BY (Con."Continent", Con."Country", D."Decade")
ORDER BY Con."Continent", Con."Country", D."Decade"

/* combine [HDI rating when life expectancy is way below average or above average] */
/* 
 * Drill down to year.
 * Dice on the population dimension and the date dimension.
 * The average for world life expectancy is about 72 years.
 */
SELECT Con."Continent", Con."Country", D."Year", P."Life_Exp_Birth_Total_Yr", F."HDI_Measure"
FROM public."FactTable" AS F, public."Population" AS P, public."Country" AS Con, public."Month" AS D
WHERE F."Population_Key" = P."Population_Key" AND F."Country_Key" = Con."Country_Key" AND F."Month_Key" = D."Month_Key"
AND (P."Life_Exp_Birth_Total_Yr" < 55 OR P."Life_Exp_Birth_Total_Yr" > 73)
AND (D."Decade" = 20 OR D."Decade" = 21)
GROUP BY ("Continent", Con."Country", D."Year", P."Life_Exp_Birth_Total_Yr", F."HDI_Measure")
ORDER BY Con."Continent", Con."Country", D."Year"


/* D3 Part 2 Queries */

/* a. Iceberg queries - 1 query */

/* iceberg Query [Top 10 for average QOL on decade] */
SELECT D."Decade", Con."Country", AVG(F."QOL_Measure") AS average_QOL
FROM public."FactTable" AS F, public."Month" AS D, public."Country" AS Con
WHERE F."Month_Key" = D."Month_Key" AND F."Country_Key" = Con."Country_Key"
GROUP BY (D."Decade", Con."Country")
ORDER BY average_QOL ASC
LIMIT 10


/* b. Windowing queries - 1 query */

/* windowing [Compare each country's yearly HDI with the average HDI of the continent for that year] */
SELECT D."Year", Con."Continent", Con."Country", F."HDI_Measure", 
AVG(F."HDI_Measure") OVER (PARTITION BY Con."Continent") AS average_HDI_continent
FROM public."FactTable" AS F, public."Month" AS D, public."Country" AS Con
WHERE F."Month_Key" = D."Month_Key" AND F."Country_Key" = Con."Country_Key"
GROUP BY (D."Year", Con."Continent", Con."Country", F."HDI_Measure")
ORDER BY D."Year", Con."Continent", Con."Country"


/* c. Window clause - 1 query */

/* window clause [Compare each country's yearly QOL with the 2 years moving average] */
SELECT Con."Continent", Con."Country", D."Year", F."QOL_Measure", 
AVG(F."QOL_Measure") OVER W AS moving_avg_QOL
FROM public."FactTable" AS F, public."Month" AS D, public."Country" AS Con
WHERE F."Month_Key" = D."Month_Key" AND F."Country_Key" = Con."Country_Key"
GROUP BY (D."Year", Con."Continent", Con."Country", F."QOL_Measure")
WINDOW W AS
(PARTITION BY Con."Country" ORDER BY D."Year" RANGE BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY Con."Continent", Con."Country", D."Year"
