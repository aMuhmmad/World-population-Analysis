-- get growth rate for latest year and the avgerage for last 5 years
WITH growthCTE AS
(
	SELECT 
		Country_Name,
		Country_Code,
		(_2022_YR2022 + _2021_YR2021 + _2020_YR2020 + _2019_YR2019 + _2018_YR2018) / 5 AS Average_growth_rate_last_5yrs,
		_2022_YR2022 AS Growth_rate_2022
	FROM Growth
),
-- Get female population and male population from  thier tables and join them on Total population table with growth rate from the growthCTE
-- Join with Area table to get the area and calculate the population density
all_population AS
(
	SELECT
		p.Country_Name,
		p.Country_Code,
		p.YR1970,
		p.YR1980,
		p.YR1990,
		p.YR2000,
		p.YR2014,
		p.YR2015,
		p.YR2016,
		p.YR2017,
		p.YR2018,
		p.YR2019,
		p.YR2020,
		p.YR2021,
		p.YR2022,
		g.Average_growth_rate_last_5yrs,
		g.Growth_rate_2022,
		mp._2022_YR2022 AS male_population_2022,
		fp._2022_YR2022 AS female_population_2022,
		YR2022 * 1.0 / (SELECT YR2022 FROM Total_population WHERE Country_Name = 'World') AS percentage_of_world_population_2022,
		a._2021_YR2021 AS [Area(km²)],
		(p.YR2022 /a._2021_YR2021) AS [population_density(people/km²)]
	FROM Total_population p
		JOIN growthCTE g
		ON p.Country_Name = g.Country_Name
		JOIN Male_population mp
		ON p.Country_Name = mp.Country_Name
		JOIN Female_population fp
		ON p.Country_Name = fp.Country_Name
		JOIN Area a
		ON p.Country_Name = a.Country_Name
)
---- Move regions into a seperate table
--select *
--into Region_population
--from all_population
--where Country_Name in (
--	'East Asia & Pacific',
--	'Europe & Central Asia',
--	'South Asia',
--	'Africa Eastern and Southern',
--	'Africa Western and Central',
--	'Middle East & North Africa',
--	'Sub-Saharan Africa',
--	'Arab World',
--	'Caribbean small states',
--	'Central Europe and the Baltics',
--	'Latin America & Caribbean',
--	'Pacific island small states',
--	'World'
--)

--Remove regions and anything not a country and store the results in a new table

select *
into World_population
from all_population
where Country_Name not in (
	'East Asia & Pacific',
	'Europe & Central Asia',
	'South Asia',
	'Africa Eastern and Southern',
	'Africa Western and Central',
	'Middle East & North Africa',
	'Sub-Saharan Africa',
	'Arab World',
	'Caribbean small states',
	'Central Europe and the Baltics',
	'Latin America & Caribbean',
	'Pacific island small states',
	'World'
)
and Country_Name not like '%IBRD%'
and Country_Name not like '%IDA%'
and Country_Name not like '%income%'
and Country_Name not like '%demographic%'
and Country_Name not like '%Euro%'
and Country_Name not like '%situations%'
and Country_Name not like '%HIPC%'
and Country_Name not like '%OECD%'
and Country_Name not like '%states%'
and Country_Name not like '%developed%'

