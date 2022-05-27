
/*PROBLEM 1*/
/*This query finds the total number of crimes recorded in the CRIME table*/
select count(*) as total_number_of_crimes 
from CHICAGO_CRIME_DATA

/*PROBLEM 2*/
/*This query lists community areas with per capita income less than 11000.*/
select COMMUNITY_AREA_NAME, COMMUNITY_AREA_NUMBER,PER_CAPITA_INCOME 
from CENSUS_DATA 
where PER_CAPITA_INCOME < 11000

/*PROBLEM 3*/
/*This query lists all case numbers for crimes involving minors?(children are not considered minors for the purposes of crime analysis)*/
select CASE_NUMBER from CHICAGO_CRIME_DATA 
where lower(DESCRIPTION) LIKE '%minor%'

/*PROBLEM 4*/
/*This query lists all kidnapping crimes involving a child*/
select * from CHICAGO_CRIME_DATA 
where lower(PRIMARY_TYPE) like '%kidnap%' and lower(DESCRIPTION) like '%child%'

/*PROBLEM 5*/
/*This query lists all crimes taking place in school areas.*/
select * from CHICAGO_CRIME_DATA 
where lower(LOCATION_DESCRIPTION) like '%school%';

/*PROBLEM 6*/
/*This query lists the average safety score for each type of school*/
select SCHOOL_TYPE, AVG(SAFETY_SCORE) as AVERAGE_SCORE 
from CHICAGO_PUBLIC_SCHOOLS 
group by SCHOOL_TYPE

/*PROBLEM 7*/
/*This query lists community areas with highest % of households below poverty line in descending*/
select COMMUNITY_AREA_NAME, COMMUNITY_AREA_NUMBER, PERCENT_HOUSEHOLDS_BELOW_POVERTY 
from CENSUS_DATA 
order by PERCENT_HOUSEHOLDS_BELOW_POVERTY desc;

/*PROBLEM 8*/
/*This query shows the area number of the area that is most crime prone*/
select COMMUNITY_AREA_NUMBER from CENSUS_DATA 
where PERCENT_HOUSEHOLDS_BELOW_POVERTY = (SELECT max(PERCENT_HOUSEHOLDS_BELOW_POVERTY) from CENSUS_DATA)

/*PROBLEM 9*/
/*This query finds the name of the community area with highest hardship index*/
select COMMUNITY_AREA_NAME from CENSUS_DATA 
where HARDSHIP_INDEX = (select MAX(HARDSHIP_INDEX) from CENSUS_DATA)

/*PROBLEM 10*/
/*This query determines the Community Area Name with the most number of crimes*/
select COMMUNITY_AREA_NAME from CENSUS_DATA 
where COMMUNITY_AREA_NUMBER = (select COMMUNITY_AREA_NUMBER 
                                from (select COMMUNITY_AREA_NUMBER, count(*) as freq 
                                        from CHICAGO_CRIME_DATA 
                                        group by COMMUNITY_AREA_NUMBER) as sub
                                        where freq = (select MAX(freq) from sub) and COMMUNITY_AREA_NUMBER IS NOT NULL);

/*PROBLEM 11*/
/*This query lists schools in areas with a hardship index of 98*/
SELECT A.NAME_OF_SCHOOL, B.COMMUNITY_AREA_NAME, A.AVERAGE_STUDENT_ATTENDANCE 
from chicago_public_schools A INNER JOIN chicago_socioeconomic_data B 
ON A.COMMUNITY_AREA_NUMBER=B.COMMUNITY_AREA_NUMBER 
where B.HARDSHIP_INDEX=98;


