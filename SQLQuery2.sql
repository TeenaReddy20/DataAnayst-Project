Select *
FROM project1.. CovidDeaths
Where continent is not null
order by 3,4

--SELECT * 
--From CovidVaccinations
--order by 3,4

--Select Location, date, total_cases, new_cases, total_deaths, population
--From CovidDeaths
--order by 1,2

----Looking at Total cases vs Total Deaths

--Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From CovidDeaths
--Where location like '%india%'
--order by 1,2

--Looking at Total cases vs population

Select Location, date, total_cases, Population, (total_cases/population)*100 as Percentageofpopulationinfected
From project1.. CovidDeaths
Where continent is not null
--Where location like '%india%'
order by 1,2

--looking at countries with highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as Percentageofpopulationinfected
From project1.. CovidDeaths
Where continent is not null
Group by Location, population
order by Percentageofpopulationinfected desc

--countries with highest Death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From project1.. CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--breaking it down to continents
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From project1.. CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- showing the continents with the highest death counts
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From project1.. CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Global deaths
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project1.. CovidDeaths
Where continent is not null
Group by date
order by 1,2


--Global deaths without dates
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project1.. CovidDeaths
Where continent is not null
--Group by date
order by 1,2


--Looking at total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccinated
From project1.. CovidDeaths dea
Join project1.. CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


--CTE
WITH PopvsVac (continent, location, date, population, vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccinated
From project1.. CovidDeaths dea
Join project1.. CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100
From PopvsVac

--Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccinated
From project1.. CovidDeaths dea
Join project1.. CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--creating view to store data for later visualizations

DROP VIEW IF EXISTS PercentPopulationVaccinated;
GO

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccinated
From project1.. CovidDeaths dea
Join project1.. CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select *
From PercentPopulationVaccinated