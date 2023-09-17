USE Covid;

-- Likelihood of dying with the covid virus of countries
SELECT d.location, d.date, d.total_cases, d.total_deaths, Round((d.total_deaths/d.total_cases)*100, 2) AS death_percentage
FROM dbo.CovidDeaths d
WHERE d.continent IS NOT NULL
ORDER BY location, date;

-- Population infection percentage of the covid virus of countries
SELECT d.location, d.date, v.population, d.total_cases, Round((d.total_cases/v.population)*100, 2) AS infection_percentage
FROM dbo.CovidDeaths d
LEFT JOIN dbo.CovidVaccines v on (d.location = v.location AND d.date = v.date)
WHERE d.continent IS NOT NULL
ORDER BY location, date;

-- Peak infection rate of countries
SELECT d.location, v.population, MAX(d.total_cases) AS highest_count, ROUND(MAX((d.total_cases/v.population) * 100), 2) AS population_percentage_affected
FROM dbo.CovidDeaths d
LEFT JOIN dbo.CovidVaccines v on (d.location = v.location AND d.date = v.date)
WHERE d.continent IS NOT NULL
GROUP BY d.location, v.population
ORDER BY population_percentage_affected DESC;

-- Highest death count of countries
SELECT d.location, MAX(d.total_deaths) as total_death_count
FROM dbo.CovidDeaths d
WHERE d.continent IS NOT NULL
GROUP BY d.location
ORDER BY total_death_count DESC;

-- Total death count of continents
SELECT d.location, MAX(d.total_deaths) as total_death_count
FROM dbo.CovidDeaths d
WHERE d.continent IS NULL 
	AND d.location NOT LIKE '%income%' 
	AND d.location NOT IN ('World', 'European Union')
GROUP BY d.location
ORDER BY total_death_count DESC;

-- Population vaccination with rolling count by country
WITH PopulationVsVaccination
AS (
	SELECT d.continent, d.location, d.date, v.population, v.new_vaccinations, 
		SUM(v.new_vaccinations) OVER (
			PARTITION BY d.location
			ORDER BY d.location, d.date) AS rolling_vaccinated_people
	FROM dbo.CovidDeaths d
	LEFT JOIN dbo.CovidVaccines v on (d.location = v.location AND d.date = v.date)
	WHERE d.continent IS NOT NULL
)

SELECT *, ROUND((rolling_vaccinated_people/population)*100, 2) AS rolling_percentage_vaccinated
FROM PopulationVsVaccination
ORDER BY location, date;
