Select *
From PortfolioProject ..CovidDeaths$
where continent is not Null
order by 3,4

-- select Data that we are going to be using 

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2


-- Looking at Total Caes vs Total Deaths 

-- Shows likelihood of dying if you conactcr covid in you country 
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%united kingdom%'
order by 1,2

--Loking at Total vs Population
--Shows what perentage of Population got Covid 

Select location, date, population, total_cases,  (total_cases/population)*100 as PerecntPopilationInfected
from PortfolioProject..CovidDeaths$
-- where location like '%united kingdom%'
order by 1,2


-- Looking at at Countries with Highest Infection Rate compred to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PerecntPopilationInfected
from PortfolioProject..CovidDeaths$
--where location like '%united kingdom%'
Group by location, population
order by PerecntPopilationInfected desc 

-- Showing Countries with Hights Death Count per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--Where loaction like '%United Kingdom%'
Where continent is not null 
Group by location
order by TotalDeathCount desc

--let's Break Things Down By Continent 




--Showing contintes with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--Where loaction like '%United Kingdom%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- Global Numbers

Select  SUM (new_cases) as total_cases, SUM (cast(new_deaths as int )) as total_deaths ,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPrecentage
From PortfolioProject..CovidDeaths$
--where location like '%united kingdom%'
where continent is not null 
--Group by date 
order by 1,2


-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject ..CovidVaccinations$ vac 
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--USE CTE

with PopvsVac(Continet, location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject ..CovidVaccinations$ vac 
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Temp Table

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
location nvarchar (255),
Date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int ,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject ..CovidVaccinations$ vac 
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later Visualizations

Create view PercentPopulationVaccinated1 as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int ,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject ..CovidVaccinations$ vac 
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *
from PercentPopulationVaccinated

