-- Select Data that im going to be using

Select Location , date , total_cases , new_cases , total_deaths,population
from CovidDeaths
order by 1,2

-- looking at total cases vs total deaths and the percentage of if you got infected in the country that im living in 

Select Location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as DeathsPercentage
from CovidDeaths 
where Location like '%Qatar%'
order by 1,2

-- Shows what percentage of population got Covid

Select Location , date  , population , total_cases, (total_cases/population)*100 as infectedPercentage
from CovidDeaths 
where Location like '%Qatar%'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location  , population ,max(total_cases)as HighestInfectioncount, max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths 
Group by location,population
order by PercentPopulationInfected desc

-- Shows Countries with Hightest death Count per Population and excluding continents

Select Location   ,max(cast (total_deaths as int))as totaldeathcount
from CovidDeaths 
where continent is not null
Group by location
order by totaldeathcount desc

-- Shows Continent with Hightest death Count per Population 

Select location  ,max(cast (total_deaths as int))as totaldeathcount
from CovidDeaths 
where continent is null
Group by location
order by totaldeathcount desc

-- showing contintents with the highest death count per population  with the error 

Select continent  ,max(cast (total_deaths as int))as totaldeathcount
from CovidDeaths 
where continent is not null
Group by continent
order by totaldeathcount desc

--showing global cases and death ans the deathpercentage


select sum(new_cases)globalcases, sum(cast(new_deaths as int ))as globaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathspercentage
from CovidDeaths
where continent is not null
order by 1,2

-- day by day

select date ,sum(new_cases)globalcases, sum(cast(new_deaths as int ))as globaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathspercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2


-- VACINATIONS TABLE

select * 
from CovidVaccinations

-- joining both tables togather

select *
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date


-- how many people in the world that had been vacinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location ,dea.date) as totalpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--using CTE

with populationandvaccination(continent,location, date,population,new_vaccination,countingpeoplevaccinated) 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location ,dea.date) as totalpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select*,(countingpeoplevaccinated/population)*100
from populationandvaccination

-- temp table
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
totalpeoplevaccinated numeric
)


insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location ,dea.date)
as totalpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select*,(totalpeoplevaccinated/population)*100
from #percentpopulationvaccinated



-- creating views to store data for visualizations

create view populationandvaccination as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location ,dea.date) as totalpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *
from populationandvaccination
--another view 
create view totaldeathcount as

Select continent  ,max(cast (total_deaths as int))as totaldeathcount
from CovidDeaths 
where continent is not null
Group by continent

select *
from totaldeathcount