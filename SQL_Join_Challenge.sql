
--RELATIVELY SIMPLE JOINS--
--What languages are spoken in the United States? (12) Brazil? (not Spanish...) Switzerland? (6)
--CODE:
  SELECT
  c.name AS country_name,
  cl.language AS country_languages,
  cl.percentage AS ratio
  FROM
  countries c JOIN
  countrylanguages cl ON c.code = cl.countrycode
  WHERE
  c.code = 'USA'
  ORDER BY
  cl.percentage DESC,
  c.name,
  cl.language
  --Brazil
    SELECT
    c.name AS country_name,
    cl.language AS country_languages,
    cl.percentage AS ratio
  FROM
    countries c JOIN
    countrylanguages cl ON c.code = cl.countrycode
  WHERE
    c.code = 'BRA'
  ORDER BY
    cl.percentage DESC,
    cl.language,
    c.name
    --Switzerland
  SELECT
    c.name AS country_name,
    cl.language AS country_languages,
    cl.percentage AS ratio
  FROM
    countries c JOIN
    countrylanguages cl ON c.code = cl.countrycode
  WHERE
    c.code = 'CHE'
  ORDER BY
    cl.percentage DESC,
    cl.language,
    c.name

  --What are the cities of the US? (274) India? (341)
  --CODE
    --US
    SELECT
      c.name AS city_name
    FROM
      cities c JOIN
      countries cont ON (c.countrycode = cont.code)
    WHERE
      cont.code = 'USA'
    ORDER BY
     c.name
    --India
    SELECT
    c.name AS city_name
    FROM
      cities c JOIN
      countries cont ON (c.countrycode = cont.code)
    WHERE
      cont.code = 'IND'
    ORDER BY
     c.name

--LANGUANGES--
--What are the official languages of Switzerland? (4 languages)
--CODE
  SELECT
    c.name AS country_name,
    cl.language AS language_name
  FROM
    countries c JOIN
    countrylanguages cl ON (cl.countrycode = c.code)
  WHERE
    c.code = 'CHE' AND cl.isofficial = TRUE
  ORDER BY
   c.name

--Which country or contries speak the most languages? (12 languages)
--CODE:
   SELECT
    COUNT(cl.language) AS lang_count,
    c.name AS country_name
  FROM
    countries c JOIN
    countrylanguages cl ON (c.code = cl.countrycode)
  GROUP BY
   c.name
  ORDER BY
    lang_count DESC

--Which country or contries have the most offficial languages? (4 languages)
--CODE:
  SELECT
    COUNT(cl.language) AS lang_count,
    c.name AS country_name
  FROM
    countries c JOIN
    countrylanguages cl ON (c.code = cl.countrycode)
  WHERE
    cl.isofficial = TRUE
  GROUP BY
   c.name
  ORDER BY
    lang_count DESC

--Which languages are spoken in the ten largest (area) countries?
--CODE:
  WITH largest_countries AS
  	(SELECT code, name, surfacearea
  	 FROM countries
  	 WHERE surfacearea >0
  	 ORDER BY surfacearea DESC
  	 LIMIT 10)

  SELECT DISTINCT
    cl.language AS lang_spoken,
    lc.name AS country_name,
    lc.surfacearea AS area
  FROM
    largest_countries lc JOIN
    countrylanguages cl ON (lc.code = cl.countrycode)
  WHERE
    cl.isofficial = TRUE
  GROUP BY
   cl.language,
   lc.name,
   lc.surfacearea

--What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0)
--CODE:
  WITH poorest_countries AS
    (SELECT DISTINCT code, name, gnp/population AS gnp_capita
     FROM countries
     WHERE gnp > 0
     ORDER BY gnp_capita
     LIMIT 20)

  SELECT
    cl.language AS lang_spoken,
    pc.name AS country_name,
    pc.gnp_capita AS gnp_per_cap
  FROM
    poorest_countries pc JOIN
    countrylanguages cl ON (pc.code = cl.countrycode)
  GROUP BY
    cl.language,
    pc.name,
    pc.gnp_capita
  ORDER BY
    pc.name
--Are there any countries without an official language?
--CODE:
  SELECT
    cl.language AS lang_spoken,
    c.name AS country_name,
    cl.isofficial AS is_official
  FROM
    countries c JOIN
    countrylanguages cl ON (c.code = cl.countrycode)
  WHERE cl.countrycode NOT IN (
    SELECT countrycode -- Selects countries with an official language that will be excluded by the "not in".
  	FROM countrylanguages
  	WHERE isofficial = TRUE)
  GROUP BY
   cl.language,
   c.name,
   cl.isofficial
  ORDER BY
   c.name
--What are the languages spoken in the countries with no official language? (49 countries, 172 languages, incl. English)
--CODE
  SELECT DISTINCT
    cl.language AS lang_spoken,
    c.name AS country_name,
    cl.isofficial AS is_official
  FROM
    countries c JOIN
    countrylanguages cl ON (c.code = cl.countrycode)
  WHERE cl.countrycode NOT IN (
          SELECT countrycode
  	FROM countrylanguages
  	WHERE isofficial = TRUE)
  GROUP BY
   cl.language,
   c.name,
   cl.isofficial
  ORDER BY
   cl.language

--Which countries have the highest proportion of official language speakers? The lowest?
--CODE:
--lowest ::

  SELECT DISTINCT
    cl.language AS lang_spoken,
    c.name AS country_name,
    cl.isofficial AS is_official,
    cl.percentage AS ratio
  FROM
    countries c JOIN
    countrylanguages cl ON (c.code = cl.countrycode)
  WHERE
   isofficial = TRUE AND cl.percentage > 0
  GROUP BY
   cl.language,
   c.name,
   cl.isofficial,
   cl.percentage
  ORDER BY
   ratio

   --highest:

   SELECT DISTINCT
     cl.language AS lang_spoken,
     c.name AS country_name,
     cl.isofficial AS is_official,
     cl.percentage AS ratio
   FROM
     countries c JOIN
     countrylanguages cl ON (c.code = cl.countrycode)
   WHERE
    isofficial = TRUE AND cl.percentage > 0
   GROUP BY
    cl.language,
    c.name,
    cl.isofficial,
    cl.percentage
   ORDER BY
    ratio DESC

--What is the most spoken language in the world?
--CODE:
  SELECT DISTINCT
    cl.language AS lang_spoken,
    c.name AS country_name,
    cl.isofficial AS is_official,
    c.population AS number_speakers,
    cl.percentage AS ratio
  FROM
    countries c JOIN
    countrylanguages cl ON (c.code = cl.countrycode)
  WHERE
    isofficial = TRUE
  GROUP BY
    cl.language,
    c.name,
    cl.isofficial,
    c.population,
    cl.percentage
  ORDER BY
    c.population DESC
  LIMIT 1

-- CITIES
--What is the population of the United States? What is the city population of the United States?
--Population::
  SELECT
    cs.population AS country_population,
    cs.name AS country_name
  FROM
    cities c JOIN
    countries cs ON (c.countrycode = cs.code)
  WHERE
    cs.code = 'USA'
  LIMIT 1

--City population
  SELECT
    SUM(c.population) AS city_population,
    cs.code
  FROM
    cities c JOIN
    countries cs ON (c.countrycode = cs.code)
  WHERE
    c.countrycode = 'USA'
  GROUP BY
    cs.code

--What is the population of the India? What is the city population of the India?
--CODE:
--population of India
  SELECT
    cs.population AS country_population,
    cs.name AS country_name
  FROM
    cities c JOIN
    countries cs ON (c.countrycode = cs.code)
  WHERE
    cs.code = 'IND'
  LIMIT 1
-- city population
  SELECT
    SUM(c.population) AS city_population,
    cs.code
  FROM
    cities c JOIN
    countries cs ON (c.countrycode = cs.code)
  WHERE
    c.countrycode = 'IND'
  GROUP BY
    cs.code

--Which countries have no cities? (7 not really contries...)
--CODE
--Method 1
with no_city_countries AS (
SELECT
  countries.code as code
FROM
  countries

except


SELECT distinct
  countries.code
FROM
  public.cities,
  public.countries
WHERE
  cities.countrycode = countries.code
)


select countries.name
from no_city_countries, countries
where
no_city_countries.code = countries.code
--Just country's code

  SELECT
    countries.code as code
  FROM
    countries

  except

  SELECT distinct
    countries.code
  FROM
    public.cities,
    public.countries
  WHERE
    cities.countrycode = countries.code

--LANGUAGES AND CITIES
--What is the total population of cities where English is the offical language? Spanish? Hint: The official language of a city is based on country.
--CODE:
