USE Kaggle
GO

SELECT *
FROM [dbo].[hotel_rec_destinations]
ORDER BY srch_destination_id ASC

SELECT TOP 1000000 *
INTO hotel_rec_destinations_last_mil
FROM hotel_rec_train
ORDER BY date_time DESC

SELECT *
FROM hotel_rec_destinations_last_mil

SELECT COUNT(DISTINCT user_location_country)
FROM hotel_rec_destinations_last_mil

--127468
-- 33972


-- 9441
-- 36627

SELECT user_id, COUNT(*)
FROM hotel_rec_destinations_last_mil
WHERE is_booking = 1
GROUP BY user_id
HAVING COUNT(*) = 1

-- feature engineeered query 1.
SELECT user_id
		, DATEDIFF(DAY,date_time,srch_co) AS days_till_booking
		, site_name
		, CASE WHEN hotel_continent = posa_continent THEN 1 ELSE 0 END AS is_same_continent
		, CASE WHEN hotel_country = user_location_country THEN 1 ELSE 0 END AS is_same_country
		, user_location_region
		, user_location_city
		, orig_destination_distance
		, is_mobile
		, is_package
		, channel
		, DATEDIFF(DAY, srch_ci,srch_co) AS num_days_booked
		, CASE WHEN srch_adults_cnt = 1 THEN 1 ELSE 0 END AS one_adult
		, CASE WHEN srch_adults_cnt = 2 THEN 1 ELSE 0 END AS two_adult
		, CASE WHEN srch_adults_cnt > 2 THEN 1 ELSE 0 END AS more_than_three_adult
		, CASE WHEN srch_children_cnt = 0 THEN 1 ELSE 0 END AS no_children
		, CASE WHEN srch_children_cnt > 0 THEN 1 ELSE 0 END AS has_children
		, srch_rm_cnt
		, hotel_market
		, srch_destination_id
		, is_booking
		, hotel_cluster
FROM hotel_rec_destinations_last_mil




-- feature engineeered query 2.
SELECT user_id
		, hotel_cluster
		, MAX(DATEDIFF(DAY,date_time,srch_co)) AS max_days_till_booking
		, MIN(DATEDIFF(DAY,date_time,srch_co)) AS min_days_till_booking
		, MAX(site_name) AS site_name
		, MAX(CASE WHEN hotel_continent = posa_continent THEN 1 ELSE 0 END) AS is_same_continent
		, MAX(CASE WHEN hotel_country = user_location_country THEN 1 ELSE 0 END) AS is_same_country
		, MAX(user_location_region) AS user_location_region
		, MAX(user_location_city) AS user_location_city
		, MAX(orig_destination_distance) AS max_orig_destination_distance
		, AVG(orig_destination_distance) AS avg_orig_destination_distance
		, MIN(orig_destination_distance) AS min_orig_destination_distance
		, MAX(CAST(is_mobile AS INT)) AS is_mobile
		, MAX(CAST(is_package AS INT)) AS is_package
		, MAX(channel) AS channel
		, MAX(DATEDIFF(DAY, srch_ci,srch_co)) AS max_num_days_booked
		, MIN(DATEDIFF(DAY, srch_ci,srch_co)) AS min_num_days_booked
		, CAST(ROUND(AVG(CASE WHEN srch_adults_cnt = 1 THEN 1.0 ELSE 0 END)*1.0,0) AS INT) AS one_adult
		, CAST(ROUND(AVG(CASE WHEN srch_adults_cnt = 2 THEN 1.0 ELSE 0 END)*1.0,0) AS INT) AS two_adult
		, CAST(ROUND(AVG(CASE WHEN srch_adults_cnt > 2 THEN 1.0 ELSE 0 END)*1.0,0) AS INT) AS more_than_three_adult
		, CAST(ROUND(AVG(CASE WHEN srch_children_cnt = 0 THEN 1.0 ELSE 0 END)*1.0,0) AS INT) AS no_children
		, CAST(ROUND(AVG(CASE WHEN srch_children_cnt > 0 THEN 1.0 ELSE 0 END)*1.0,0) AS INT) AS has_children
		, MAX(srch_rm_cnt) AS srch_rm_cnt
		, MAX(hotel_market) AS hotel_market
		, MAX(srch_destination_id) AS srch_destination_id
		, MAX(CAST(is_booking AS INT)) AS is_booking
		, COUNT(*) AS num_searches
FROM hotel_rec_destinations_last_mil
GROUP BY user_id ,
         hotel_cluster
		 ORDER BY 1, 2


-- start here to generate a ranking matrix.

DECLARE @hotel_clusters_select NVARCHAR(MAX) = ''
DECLARE @hotel_clusters_pivot NVARCHAR(MAX) = ''
DECLARE @hotel INT

DECLARE hotel_cursor CURSOR FOR 
SELECT DISTINCT hotel_cluster 
FROM hotel_rec_destinations_last_mil
ORDER BY hotel_cluster ASC 


OPEN hotel_cursor
FETCH NEXT FROM hotel_cursor INTO @hotel

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @hotel_clusters_pivot = @hotel_clusters_pivot + '[' + CAST(@hotel AS NVARCHAR(100)) + '], '
	SET @hotel_clusters_select = @hotel_clusters_select +  'ISNULL([' + CAST(@hotel AS NVARCHAR(100)) + '],0) AS ''hotel_cluster_' + CAST(@hotel AS NVARCHAR(100)) + ''', '

	FETCH NEXT FROM hotel_cursor INTO @hotel
END

CLOSE hotel_cursor
DEALLOCATE hotel_cursor

--SELECT @movie_titles_select

SET @hotel_clusters_pivot = SUBSTRING(@hotel_clusters_pivot, 1, LEN(@hotel_clusters_pivot)-1)
SET @hotel_clusters_select = SUBSTRING(@hotel_clusters_select, 1, LEN(@hotel_clusters_select)-1)

DECLARE @sql NVARCHAR(MAX) = ''

SET @sql = 
'SELECT [user_id], ' + @hotel_clusters_select + '
into hotel_rec_destinations_last_mil_ranking_v1
FROM (SELECT [user_id], hotel_cluster, CASE WHEN CAST(is_booking AS INT) = 1 THEN 5 ELSE 1 END AS is_booking FROM dbo.hotel_rec_destinations_last_mil) a
PIVOT
( SUM(is_booking)
	FOR hotel_cluster IN (' + @hotel_clusters_pivot + ')
) AS pvt
ORDER BY [user_id]'

--PRINT(@sql)
EXEC(@sql)

--DROP TABLE hotel_rec_destinations_last_mil_ranking_v1

SELECT *
FROM hotel_rec_destinations_last_mil_ranking_v1