use PortfolioProjects;
select * from CovidDeaths
where continent is not null
order by 3,4;


select * from CovidVaccinations
order by 3,4

--Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2 

-- Looking for total case vs total deaths
 
 select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
 from CovidDeaths
 where continent is not null
 and Location like '%states%'
 order by 1,2


 --Looking for total cases vs population
 --Shows what percentage of population got covid

  select Location, date, population, total_cases,  (total_cases/population)*100 as percentageofpopulationInfected
 from CovidDeaths
 where continent is not null
 and Location like '%states%'
 order by 1,2

 --Loooking at the countries with Highest Infection rate compared to population
 select Location, population, max(total_cases) as HighestInfectioncount,  max((total_cases/population))*100 as percentageofpopulationInfected
 from CovidDeaths
 --where Location like 'India'
 group by population, location
 order by percentageofpopulationInfected desc


 --Show countries with highest death count per population
 select Location, max(total_deaths) as Totaldeathcount from CovidDeaths
 --where Location like '%states%'
 where continent is not null
 group by location
 order by Totaldeathcount desc
  
--Let's break things by continent
select continent, max(total_deaths) as Totaldeathcount from CovidDeaths
 --where Location like '%states%'
 where continent is not null
 group by continent
 order by Totaldeathcount desc


select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as Deathspercentage from CovidDeaths
where continent is not null
--group by date
order by 1,2

 
-- Looking at total population vs total vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated 
from CovidDeaths as dea
join
CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2



with Popvsvac (Continent, location, date, population, new_vaccinations,  RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated from 
CovidDeaths as dea
join
CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population) * 100 
from Popvsvac

-- Temp table
Create table #percentagepopulationvaccinated
(
continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric

)

Insert into #percentagepopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated from 
CovidDeaths as dea
join
CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null

select *, (RollingPeopleVaccinated/population) * 100 
from  #percentagepopulationvaccinated

select * from #percentagepopulationvaccinated


--Creating view to store data for later visulizations
Create view percentagepopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated from 
CovidDeaths as dea
join
CovidVaccinations as vac
on dea.location = vac.location
and dea.date = vac.date

select * from percentagepopulationvaccinated






