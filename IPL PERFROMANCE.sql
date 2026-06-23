create database ipl_performance_analysis;
use ipl_performance_analysis;

create table innings (
Inning_No int primary key,
Match_date date,
Season int,
Opponent varchar(50),
Venue varchar(50),
Runs int,
Balls int,
Fours int,
Sixes int,
Strike_Rate decimal(6,2),
Batting_Position int,
Dismissal varchar(50),
Result varchar(50),
Boundary_Runs int,
Boundary_Percetange decimal(6,2)
);


-- 1. Full table
select * from innings;

-- 2. total numbers of row
select count(*) from innings;

-- 3. null value check 
select * from innings 
where runs is null 
or balls is null 
or season is null; 

-- 4. duplicate records check
select inning_no,
count(*) from innings 
group by inning_no
having count(*) >1;

-- 5. total matches,total runs, highest score,total fours,total sixes
select count(*) as Matches,
sum(runs) as total_runs,
max(runs) as higest_score,
sum(fours) as total_fours,
sum(sixes) as total_sixes
from innings;

-- 6 overall strike rate
select sum(runs)/sum(balls)*100 as career_strike_rate
from innings;

-- 7. not out
Select count(*) as Not_outs
from innings 
where dismissal = "Not Out" ;

-- 8 Batting avg
SELECT 
round(SUM(runs) / (COUNT(*) - SUM(CASE WHEN dismissal = 'Not Out' THEN 1 ELSE 0 END)),2) AS batting_average
FROM innings;

-- 9. not_out  
select * from innings
where dismissal = "Not Out"; 
                              
                              -- SEASON WISE
-- 10. Runs by seasons
select season,
sum(runs) as total_runs
from innings
group by season;

-- 11. strike rate by season 
select season,
round(sum(runs)/sum(balls)*100,2) as Batting_strike_rate
from innings
group by season;

-- 12. Season wise batting_avg 
select season,
round(SUM(runs) / (COUNT(*) - SUM(CASE WHEN dismissal = 'Not Out' THEN 1 ELSE 0 END)),2) AS batting_average
from innings
group by season;

-- 13 highest score according to seasons
select season,
max(runs) as highest_run
from innings
group by season;

-- 14. Runs vs each team 
select opponent,
sum(runs) as runs
from innings
group by opponent
order by runs desc;

-- 15 Avg vs each team
select opponent,
round(sum(runs)/(count(*)-sum(case when dismissal = "Not Out" then 1 else 0 end)),2) as batting_avg
from innings
group by opponent
order by batting_avg desc;

-- 16. Strike rate vs each team 
select opponent,
(sum(runs)/sum(balls)*100)as strike_rate
from innings
group by opponent
order by  strike_rate desc;

-- -- 17. Best opponent by run
select Opponent,
sum(runs) as total_runs
from innings 
group by opponent
order by total_runs desc
limit 1 ;

-- 18. Best opponent by avg
select opponent,
round(sum(runs)/(count(*)-sum(case when dismissal = "Not Out" then 1 else 0 end)),2) as batting_avg
from innings
group by opponent
order by batting_avg desc
limit 1;

-- 19. Best opp by Sr
select opponent,
round(sum(runs)/sum(balls)*100) as batting_SR
from innings
group by opponent
order by batting_SR desc
limit 1;

-- 20. worst opponent by run
select Opponent,
sum(runs) as total_runs
from innings 
group by opponent
order by total_runs asc
limit 1 ;

-- 21 worst opponent by avg
select opponent,
round(sum(runs)/(count(*)-sum(case when dismissal = "Not Out" then 1 else 0 end)),2) as batting_avg
from innings
group by opponent
order by batting_avg asc
limit 1;

-- 22. Best opp by Sr
select opponent,
round(sum(runs)/sum(balls)*100) as batting_SR
from innings
group by opponent
order by batting_SR asc
limit 1;

--           Venue analysis

-- 23. Runs by venue
select venue,
count(inning_no) as innings,
sum(runs) as runs
from innings
group by venue
order by runs desc;

-- 24. Avg by venue
select venue,
round(sum(runs)/(count(*)-sum(case when dismissal = "Not Out" then 1 else 0 end)),2) as Batting_avg
from innings
group by venue
order by batting_avg desc;

-- 25. home vs away comaprison
select case 
when venue = "Ahmedabad" then "Home" else "Away" end as match_type,
count(*) as innings,
sum(runs) as runs,
sum(balls) as balls,
sum(fours) as fours,
sum(sixes) as sixes,
round(sum(runs)/(count(*)-sum(case when dismissal = "Not Out" then 1 else 0 end)),2) as Batting_avg,
round(sum(runs)/sum(balls)*100) as batting_SR
from innings 
group by match_type;

--                 Match result analysis

-- 26. Avg in wins 
select result,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg
from innings 
where result = "win"
group by result;

-- 27. Avg in losses
select result,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg
from innings 
where result = "loss"
group by result;

-- 28. Strike rate in wins vs losses
select result,
round(sum(runs)/sum(balls)*100,2) as Batting_SR
from innings
group by result;

--                Batting position analysis
-- 29. innings at each position
select batting_position,
count(*) as no_innings,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg,
round(sum(runs)/sum(balls)*100,2) as Batting_SR
from innings
group by batting_position
order by batting_position asc;


--                   Dismissal analysis
-- 30. dismissal freq
SELECT dismissal,
COUNT(*) AS frequency
FROM innings
GROUP BY dismissal
ORDER BY frequency DESC;

--        Advance Queries 
-- 31 Top 10 innings stats
select  match_date,
		opponent,
        venue,
        runs,
        balls,
        strike_rate,
        result
from innings
order by runs desc
limit 10;

-- 32. no. of 50s and 100s
SELECT
SUM(CASE WHEN runs >= 50 AND runs < 100 THEN 1 ELSE 0 END) AS fifties,
SUM(CASE WHEN runs >= 100 THEN 1 ELSE 0 END) AS hundreds
FROM innings;
                
                -- View
-- 33 vw season stats
create view vw_season_stats as 
select season,
count(*) as innings,
sum(runs) as total_runs,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg,
round(sum(runs)/sum(balls)*100,2) as Batting_SR,
max(runs) as highest_run,
SUM(CASE WHEN runs >= 50 AND runs < 100 THEN 1 ELSE 0 END) AS fifties,
SUM(CASE WHEN runs >= 100 THEN 1 ELSE 0 END) AS hundreds
from innings 
group by season;

select * from vw_season_stats;

-- 34. vw_opponent_stats 
create view vw_opponent_stats as 
select opponent,
count(*) as innings,
sum(runs) as total_runs,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg,
round(sum(runs)/sum(balls)*100,2) as Batting_SR,
max(runs) as highest_run,
SUM(CASE WHEN runs >= 50 AND runs < 100 THEN 1 ELSE 0 END) AS fifties,
SUM(CASE WHEN runs >= 100 THEN 1 ELSE 0 END) AS hundreds
from innings 
group by opponent
order by total_runs desc;

select * from vw_opponent_stats;

-- 35. vw_venue_stats 
create view vw_venue_stats as 
select venue,
count(*) as innings,
sum(runs) as total_runs,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg,
round(sum(runs)/sum(balls)*100,2) as Batting_SR,
max(runs) as highest_run,
SUM(CASE WHEN runs >= 50 AND runs < 100 THEN 1 ELSE 0 END) AS fifties,
SUM(CASE WHEN runs >= 100 THEN 1 ELSE 0 END) AS hundreds
from innings 
group by venue
order by total_runs desc;

select * from vw_venue_stats;

-- 36. vw_result_stats 
create view vw_result_stats as 
select result,
count(*) as innings,
sum(runs) as total_runs,
round(sum(runs)/(count(*)-sum(case when dismissal ="Not Out" then 1 else 0 end)),2) as batting_avg,
round(sum(runs)/sum(balls)*100,2) as Batting_SR,
max(runs) as highest_run,
SUM(CASE WHEN runs >= 50 AND runs < 100 THEN 1 ELSE 0 END) AS fifties,
SUM(CASE WHEN runs >= 100 THEN 1 ELSE 0 END) AS hundreds
from innings 
group by result;

select * from vw_result_stats;

-- 39. total runs by boundaries
select sum(Boundary_Runs) as runs_by_boundaries
from innings;

-- 40. Runs without bouundaries
select sum(runs)-sum(Boundary_Runs) as runs_without_boundaries
from innings;

-- 41 no. of not out 
select count(*) 
from innings
where dismissal = "Not Out";

-- 42 career boundary % 
select (sum(boundary_runs)/sum(runs)*100) as boundary_per
from innings;

-- 43. no.  of win
select count(*) as no_win
from innings 
where result ="win";

select venue,
count(*) as not_out
from innings
where dismissal = "Not Out"
group  by venue;

select * from innings 
where runs = "108";

