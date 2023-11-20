USE nyc_taxi;
SELECT * FROM taxi;
SELECT * FROM weather;
-- first we will check for number of trips, average distance and average time under each climate condition
SELECT
    CASE
        WHEN precipitation = 0 THEN 'no rain'
        WHEN precipitation BETWEEN 0.01 AND 0.5 THEN 'light rain'
        WHEN precipitation > 0.5 THEN 'rain'
        ELSE 'other'
    END AS rain_category,
    CASE
        WHEN new_snow = 0 THEN 'no snow'
        WHEN new_snow BETWEEN 0.01 AND 0.5 THEN 'light snow'
        WHEN new_snow > 0.5 THEN 'snow'
        ELSE 'other'
    END AS snow_category,
    COUNT(*) AS number_of_trips,
    ROUND(AVG(distance), 2) AS avg_distance_mi,
    ROUND(STDDEV(distance), 2) AS stdev_distance_mi,
    ROUND(AVG(duration), 2) AS avg_trip_duration_min,
    ROUND(STDDEV(duration), 2) AS stdev_trip_duration_min
FROM taxi
JOIN weather ON weather.date = taxi.date
WHERE 
    (precipitation = 0 OR precipitation BETWEEN 0.01 AND 0.5 OR precipitation > 0.5)
    AND
    (new_snow = 0 OR new_snow BETWEEN 0.01 AND 0.5 OR new_snow > 0.5)
GROUP BY rain_category, snow_category;

-- Find number of trips per day of week, and the average price per km and price per min

SELECT week_day, COUNT(*) AS number_of_trips,
ROUND(AVG(total/distance),2) AS avg_price_mi,
ROUND(AVG(distance),2) AS avg_duration,
ROUND(AVG(duration),2) AS avg_duration

FROM taxi
GROUP BY week_day order by number_of_trips DESC;

-- we will do the same query now but checking for the hour when the trip was done

SELECT
    week_day,
    COUNT(*) AS number_of_trips,
    MAX(total) AS max_price,
    MAX(distance) AS max_dist,
    MIN(total) AS min_price,
    MIN(distance) AS min_dis
FROM taxi
GROUP BY week_day
ORDER BY number_of_trips DESC;

-- time to chek if the hour of the day show differences:
SELECT 
    time_slot,
    ROUND(AVG((distance/duration)), 2) as avg_speed,
    ROUND(AVG(total), 2) as avg_cost,
    ROUND(AVG(distance), 2) as avg
FROM (
    SELECT 
        CASE
            WHEN hour BETWEEN 6 AND 9 THEN '6-9h'
            WHEN hour BETWEEN 10 AND 16 THEN '10-16h'
            WHEN hour BETWEEN 17 AND 19 THEN '17-19h'
            WHEN hour BETWEEN 20 AND 23 OR hour = 0 THEN '20-00h'
            WHEN hour BETWEEN 1 AND 5 THEN '00-5h'
        END AS time_slot,
        distance,
        duration,
        total
    FROM taxi
    WHERE 
        hour BETWEEN 6 AND 9
        OR hour BETWEEN 10 AND 16 
        OR hour BETWEEN 17 AND 19
        OR hour BETWEEN 20 AND 23 OR hour = 0
        OR hour BETWEEN 1 AND 5
) AS subquery
GROUP BY time_slot
ORDER BY time_slot DESC;
