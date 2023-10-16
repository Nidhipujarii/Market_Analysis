-- Demographic Insights
-- Who prefers energy drink more?
select * from query10;
SELECT gender, COUNT(*) AS total
FROM dim_repondents d
JOIN fact_survey_responses f
ON d.Respondent_ID = f.Respondent_ID
GROUP BY gender;

WITH CTE AS (
    SELECT 
        CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END AS Total_Male,
        CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END AS Total_Female,
        CASE WHEN Gender = 'Non-binary' THEN 1 ELSE 0 END AS Total_Non_binary
    FROM dim_repondents
)
SELECT 
    SUM(Total_Male) AS Total_Males,
    SUM(Total_Female) AS Total_Females,
    SUM(Total_Non_binary) AS Total_Non_binary
FROM CTE;

-- Which age group prefers energy drinks more?
select Age, count(*) as total
from dim_repondents d
join fact_survey_responses f
on d.Respondent_ID = f.Respondent_ID
group by Age
order by count(*) desc;

-- Which type of marketing reaches the most Youth (15-30)
select Marketing_channels,count(*) as channel_count
from dim_repondents d
join fact_survey_responses f
on d.Respondent_ID = f.Respondent_ID
where Age between '15-18' and '19-30'
group by Marketing_channels
order by channel_count desc;

-- consumer preference
-- What are the preferred ingredients of energy drinks among respondents
select ingredients_expected, count(ingredients_expected) as ingredients_count
from fact_survey_responses
group by ingredients_expected
order by ingredients_count desc;

-- What packaging preferences do respondents have for energy drinks?
select Packaging_preference, count(*) as preferences
from fact_survey_responses
group by Packaging_preference
order by preferences desc;

-- competition analysis
-- Who are the current market leaders
select Current_brands, count(*) as Brands_count
from fact_survey_responses
group by Current_brands
order by Brands_count desc;

-- What are the primary reasons consumers prefer those brands over ours?
select Reasons_for_choosing_brands, count(*) as reasons_weightage
from fact_survey_responses
where Current_brands <> 'Codex'
group by Reasons_for_choosing_brands
order by reasons_weightage desc;

-- Marketing Channels and Brand Awareness
-- Which marketing channel can be used to reach more customers?
select Marketing_channels,count(*) as channel_count
from fact_survey_responses f
group by Marketing_channels
order by channel_count desc;

-- How effective are different marketing strategies and channels in reaching our customers?
select Marketing_channels,count(*) as channel_count, 
round(count(*)/(select count(*) from fact_survey_responses)*100,2) as percentage_reached
from fact_survey_responses f
where Current_brands = 'CodeX'
group by Marketing_channels
order by channel_count desc;


-- Purchase Behaviour
-- What do people think about our brand? (overall rating)
select avg(case when Brand_perception = 'Positive' then 5
				when Brand_perception = 'Neutral' then 3
                when Brand_perception = 'Negative' then 1
                else 0 
                end) as avg_rating, COUNT(*) AS Respondent_Count
from fact_survey_responses
where Current_brands = 'Codex';

-- Which cities do we need to focus more on?
select City, count(*) total_customers
from dim_cities c
join dim_repondents r
on c.City_ID = r.City_ID
join fact_survey_responses f
on r.Respondent_ID = f.Respondent_ID
where Current_brands = 'Codex'
group by City
order by total_customers desc;

-- Purchase Behavior
-- Where do respondents prefer to purchase energy drinks?
select Purchase_location, count(*) as respondent_count
from fact_survey_responses
group by Purchase_location
order by respondent_count desc;

-- What are the typical consumption situations for energy drinks among respondents?
select Typical_consumption_situations, count(*) as respondent_count
from fact_survey_responses
group by Typical_consumption_situations
order by respondent_count desc;

-- What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
-- Determine the impact of price range on purchase decisions for 'Codex' energy drink
SELECT
  Price_range,
  COUNT(*) AS Purchase_Count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Price_range
ORDER BY Purchase_Count DESC;

-- Analyze the influence of limited edition packaging on purchase decisions for 'Codex' energy drink
SELECT
  Limited_edition_packaging,
  COUNT(*) AS Purchase_Count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Limited_edition_packaging
ORDER BY Purchase_Count DESC;

-- brand reputation
select Reasons_for_choosing_brands, count(*) as total_purchase
from fact_survey_responses
WHERE Current_brands = 'Codex'
group by Reasons_for_choosing_brands
order by total_purchase  desc;

-- improvements desired
select Improvements_desired, count(*) as total
from fact_survey_responses
WHERE Current_brands = 'Codex'
group by Improvements_desired
order by total desc;

-- Which area of business should we focus more on our product development? (Branding/taste/availability
-- Taste Analysis:
-- Calculate the average taste rating for 'Codex' energy drink
SELECT
  AVG(Taste_experience) AS Average_Taste_Rating
FROM fact_survey_responses
WHERE Current_brands = 'Codex';

-- Identify the distribution of taste ratings for 'Codex' energy drink
SELECT
  Taste_experience AS Taste_Rating,
  COUNT(*) AS Count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Taste_experience
ORDER BY Taste_Rating;

-- Availability analysis
-- Determine where customers typically purchase energy drinks
SELECT
  Purchase_location,
  COUNT(*) AS Count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Purchase_location
ORDER BY Count DESC;

-- Analyze the price range considered reasonable for 'Codex' energy drink
SELECT
  Price_range,
  COUNT(*) AS Count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Price_range
ORDER BY Price_range;


-- brand perception
-- Calculate the average brand perception rating for 'Codex' energy drink
SELECT
  AVG(CASE WHEN Brand_perception = 'Positive' THEN 1
           WHEN Brand_perception = 'Neutral' THEN 0
           WHEN Brand_perception = 'Negative' THEN -1
           ELSE NULL END) AS Average_Brand_Perception_Rating
FROM fact_survey_responses
WHERE Current_brands = 'Codex';

-- Determine the distribution of brand perceptions for 'Codex' energy drink
SELECT
  Brand_perception,
  COUNT(*) AS Count
FROM fact_survey_responses
WHERE Current_brands = 'Codex'
GROUP BY Brand_perception
ORDER BY Brand_perception;

-- taste rating
select Taste_experience
from fact_survey_responses
where Current_brands = 'Codex';
with cte as(
select sum(case when Taste_experience = 5 then 1 else 0 end) as 5_star,
	   sum(case when Taste_experience = 4 then 1 else 0 end) as 4_star,
       sum(case when Taste_experience = 3 then 1 else 0 end) as 3_star,
       sum(case when Taste_experience = 2 then 1 else 0 end) as 2_star,
       sum(case when Taste_experience = 1 then 1 else 0 end) as 1_star
from fact_survey_responses
where Current_brands = 'Codex')
SELECT '5 Stars' AS Rating, 5_star AS Count
FROM (
    SELECT SUM(CASE WHEN Taste_experience = 5 THEN 1 ELSE 0 END) AS 5_star
    FROM fact_survey_responses
    WHERE Current_brands = 'Codex'
) AS t
UNION ALL
SELECT '4 Stars' AS Rating, 4_star AS Count
FROM (
    SELECT SUM(CASE WHEN Taste_experience = 4 THEN 1 ELSE 0 END) AS 4_star
    FROM fact_survey_responses
    WHERE Current_brands = 'Codex'
) AS t
UNION ALL
SELECT '3 Stars' AS Rating, 3_star AS Count
FROM (
    SELECT SUM(CASE WHEN Taste_experience = 3 THEN 1 ELSE 0 END) AS 3_star
    FROM fact_survey_responses
    WHERE Current_brands = 'Codex'
) AS t
UNION ALL
SELECT '2 Stars' AS Rating, 2_star AS Count
FROM (
    SELECT SUM(CASE WHEN Taste_experience = 2 THEN 1 ELSE 0 END) AS 2_star
    FROM fact_survey_responses
    WHERE Current_brands = 'Codex'
) AS t
UNION ALL
SELECT '1 Star' AS Rating, 1_star AS Count
FROM (
    SELECT SUM(CASE WHEN Taste_experience = 1 THEN 1 ELSE 0 END) AS 1_star
    FROM fact_survey_responses
    WHERE Current_brands = 'Codex'
) AS t;
