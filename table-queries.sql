USE Covid;
-- NOTE: USING TABLEAU PUBLIC FREE DOESN'T ALLOW SQL IMPORTS SO THESE 
-- QUERIES ARE USED TO BE SAVED IN EXCEL SHEETS AND IMPORTED INTO TABLEAU

-- Global numbers
-- Table 1
SELECT SUM(d.new_cases) AS total_cases, SUM(d.new_deaths) AS total_deaths, SUM(d.new_deaths)/sum(d.new_cases)*100 as fatality_rate
FROM dbo.CovidDeaths d
WHERE d.continent IS NOT NULL;

-- Total deaths per continent
-- Table 2
SELECT d.location, MAX(d.total_deaths) AS total_death_count
FROM dbo.CovidDeaths d
WHERE d.continent IS NULL 
	AND d.location NOT LIKE '%income%' 
	AND d.location NOT IN ('World', 'European Union')
GROUP BY d.location
ORDER BY total_death_count DESC;

-- Percent population infected by country
-- Table 3
SELECT d.location, v.population, MAX(d.total_cases) AS highest_cases, MAX((d.total_cases/v.population) * 100) AS population_infected_percentage
FROM dbo.CovidDeaths d
LEFT JOIN dbo.CovidVaccines v on (d.location = v.location AND d.date = v.date)
WHERE d.continent IS NOT NULL
GROUP BY d.location, v.population
ORDER BY population_infected_percentage DESC;

-- Percent population infected over time
-- Table 4
SELECT d.location, v.population, d.date, MAX(d.total_cases) AS case_count, MAX(d.total_cases/v.population)*100 AS population_percentage_infected
FROM dbo.CovidDeaths d
LEFT JOIN dbo.CovidVaccines v on (d.location = v.location AND d.date = v.date)
GROUP BY d.location, v.population, d.date
ORDER BY d.location, population_percentage_affected DESC;