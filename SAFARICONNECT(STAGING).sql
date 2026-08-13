create schema safari_connect;
set search_path to safari_connect;
create table safari_connect.booking_staging(
booking_id TEXT,
passenger_name TEXT,
passenger_phone TEXT,
passenger_gender TEXT,
passenger_city TEXT,
route_code TEXT,
route_from TEXT,
route_to TEXT,
vehicle_plate TEXT,
vehicle_type TEXT,
driver_name TEXT,
driver_rating TEXT,
departure_date TEXT,
departure_time TEXT,
seat_class TEXT,
seats_booked TEXT,
fare_per_seat TEXT,
total_fare TEXT,
payment_method TEXT,
booking_status TEXT,
trip_rating TEXT
);

select * from safari_connect.booking_staging;
select count(*) from safari_connect.booking_staging;
select * from safari_connect.booking_staging bs limit 10;


--Cleaning passenger_names======================================================================

select distinct passenger_name
from safari_connect.booking_staging bs 
order by bs.passenger_name;

update safari_connect.booking_staging bs 
set passenger_name = initcap(TRIM(passenger_name))
where bs.passenger_name != initcap(TRIM(passenger_name));

select passenger_name
from safari_connect.booking_staging bs
where bs.passenger_name =initcap(TRIM(passenger_name));




--Cleaning passenger_gender=========================================================================

select distinct passenger_gender ,
case
	when upper(trim(passenger_gender)) in ('FEMALE','F') then 'Female'
	when upper(trim(passenger_gender)) in ('MALE','M') then 'Male'
end as passenger_gender
from safari_connect.booking_staging;

update safari_connect.booking_staging bs 
set passenger_gender = case
	when upper(trim(passenger_gender)) in ('FEMALE','F') then 'Female'
	when upper(trim(passenger_gender)) in ('MALE','M') then 'Male'
	else passenger_gender
end;




--Cleaning passenger_phone ==========================================================
SELECT booking_id, passenger_phone
FROM safari_connect.booking_staging
WHERE passenger_phone LIKE '+254%' OR passenger_phone LIKE '%-%';   --identifying the dashes, and contacts with '+254'

select booking_id, passenger_phone,  REGEXP_REPLACE(passenger_phone,'[^0-9]','','g') as phone
from safari_connect.booking_staging bs 
WHERE passenger_phone LIKE '%-%';

update safari_connect.booking_staging bs 
set passenger_phone =  REGEXP_REPLACE(passenger_phone,'[^0-9]','','g')
WHERE passenger_phone LIKE '%-%';    --removing dashes



select booking_id, passenger_phone
    from safari_connect.booking_staging bs 
    WHERE passenger_phone ~ '^[0-9.]+E[+-][0-9]+$';




select booking_id, passenger_phone,  '0' || SUBSTRING(REGEXP_REPLACE(passenger_phone,'[^0-9]','','g'),4) as phn
from safari_connect.booking_staging bs 
WHERE passenger_phone LIKE '254%';



update  safari_connect.booking_staging 
set passenger_phone = '734333444'
where booking_id = 'BK0093';


update safari_connect.booking_staging bs 
set passenger_phone = '790123456'
where booking_id = 'BK0049';

update safari_connect.booking_staging bs 
set passenger_phone = '790123456'
where booking_id = 'BK0269';

select * from safari_connect.booking_staging bs 
where passenger_name = 'Karen Adhiambo';

update safari_connect.booking_staging bs 
set passenger_phone = '778901234'
where booking_id in ('BK0247','BK0027');

update safari_connect.booking_staging bs 
set passenger_phone = '756789012'
where booking_id in ('BK0225','BK0005');


update safari_connect.booking_staging bs 
set passenger_phone = '790999000'
where booking_id in ('BK0159');

update safari_connect.booking_staging bs 
set passenger_phone = '778777888'
where booking_id in ('BK0137');





select * from safari_connect.booking_staging;





update safari_connect.booking_staging bs
set passenger_phone = case booking_id
when 'BK0203' then '734567890'
when 'BK0181' then '712345678'
when 'BK0182' then '723456789'
when 'BK0204' then '0745678901'
when 'BK0006' then '0767890123'
when 'BK0226' then '0767890123'
when 'BK0028' then '0789012345'
when 'BK0248' then '0789012345'
when 'BK0270' then '701234567'
when 'BK0050' then '0701234567'
when 'BK0051' then '712111222'
when 'BK0052' then '0723222333'
when 'BK0094' then '745444555'
when 'BK0115' then '756555666'
when 'BK0116' then '0767666777'
when 'BK0138' then '789888999'
when 'BK0160' then '0701000111'
else passenger_phone
end;


update safari_connect.booking_staging bs
set passenger_phone = case booking_id
when 'BK9004' then '0745678901'
when 'BK0072' then '0723222333'
when 'BK0071' then '712111222'
else passenger_phone
end;

update safari_connect.booking_staging bs 
SET passenger_phone = '0' || passenger_phone
where length(passenger_phone) = 9 and passenger_phone like '7%';




  
--Cleaning passenger_city ===========================================================================
  select booking_id, passenger_name, passenger_city
  from safari_connect.booking_staging bs 
  where bs.passenger_city = initcap(TRIM(passenger_city)); --checking all the rows in the city column that are not written in proper case
  
  update safari_connect.booking_staging bs 
  set passenger_city = initcap(TRIM(passenger_city))
  where bs.passenger_city != initcap(TRIM(passenger_city));--rewritting every value in the passenger_city column to the correct format

   select booking_id, passenger_name, passenger_city
  from safari_connect.booking_staging bs
  where passenger_city = '';  --checking for blank values in Passenger_city column
   
  
   update safari_connect.booking_staging bs 
   set passenger_city = case passenger_name
   when 'Brian Otieno' then 'Mombasa'
   when 'Nathan Kipchoge' then 'Eldoret'
   when 'David Kamau' then 'Nairobi'
   when 'Felix Hassan' then 'Nairobi'
   when 'Henry Korir' then 'Nairobi'
   when 'Patrick Ngugi' then 'Nyeri'
   when 'James Gitonga' then 'Nairobi'
   when 'Liam Mutua' then 'Machakos'
   when 'Samuel Odhiambo' then 'Kisumu'
   when 'Victor Abdi' then 'Mombasa'
   else passenger_city
   end;
   
   
   
   
   --Cleaning vehicle type ================================================================
   update safari_connect.booking_staging bs
set vehicle_type =
case
	when UPPER(trim(vehicle_type)) in ('BUS') then 'Bus'
	when upper(trim(vehicle_type)) in ('MATATU') then 'Matatu'
	when upper(trim(vehicle_type)) in ('MINIBUS') then 'Minibus'
	else bs.vehicle_type
end;




select * from safari_connect.booking_staging;





--Cleaning driver_name ===========================================
update safari_connect.booking_staging
set driver_name = initcap(trim(driver_name))
where driver_name != initcap(trim(driver_name));





----Cleaning seat_class ========================================================
UPDATE safari_connect.booking_staging
SET seat_class = CASE
    WHEN UPPER(TRIM(seat_class)) IN ('ECONOMY','ECO','ECONOMY CLASS') THEN 'Economy'
    WHEN UPPER(TRIM(seat_class)) IN ('BUSINESS','BUS','BUSINESS CLASS') THEN 'Business'
    ELSE seat_class
END;

   
   
   
 ---cleaning Seats_booked =======================
 update safari_connect.booking_staging bs 
set seats_booked = ''
WHERE NULLIF(REGEXP_REPLACE(seats_booked,'[^0-9-]','','g'),'')::INTEGER < 1; 





--cleaning fare_per_seat and total_fare =============================================================
Select booking_id, total_fare, fare_per_seat FROM safari_connect.booking_staging
WHERE total_fare LIKE 'KES%' OR fare_per_seat LIKE 'KES%'; 

update safari_connect.booking_staging
set total_fare = REGEXP_REPLACE(total_fare,'[^0-9.]','','g')
where total_fare SIMILAR TO '%[^0-9.]%';

UPDATE safari_connect.booking_staging
SET fare_per_seat = REGEXP_REPLACE(fare_per_seat,'[^0-9.]','','g')
WHERE fare_per_seat SIMILAR TO '%[^0-9.]%';




---Cleaning Payment method =====================================================================
update safari_connect.booking_staging bs 
set payment_method = 
case
	when upper(trim(payment_method)) in ('MPESA', 'M-PESA') then 'M-Pesa'
	when upper(trim(payment_method)) in ('CASH') then 'Cash'
	when upper(trim(payment_method)) in ('CARD') then 'Card'
	else payment_method
end;




--Cleaning booking_status ==========================================================================
update safari_connect.booking_staging bs 
set booking_status = 
case
	when upper(trim(booking_status)) in ('CANCELLED') then 'Cancelled'
	when upper(trim(booking_status)) in ('COMPLETED') then 'Completed'
	when upper(trim(booking_status)) in ('NO SHOW') then 'No Show'
	else booking_status
end;





--Cleaning trip_rating ===================================================================
select distinct bs.trip_rating  from safari_connect.booking_staging bs; 
 
select bs.trip_rating  
from safari_connect.booking_staging bs
where bs.trip_rating not in ('1', '2', '3', '4', '5', ''); ---- select invalid trip ratings, valid trip_ratings are btn(1,2,3,4,5)

update safari_connect.booking_staging bs 
set trip_rating = null
where bs.trip_rating not in ('1', '2', '3', '4', '5', ''); 





---Cleaning departure_date ==============================================================
select distinct departure_date
from safari_connect.booking_staging bs ;

update safari_connect.booking_staging bs 
set departure_date = replace(departure_date, '-', '/');  ----removing (-) from the dates replacing with (/)

select    ---selecting first to see how the arrangement of my values in the departure_date column will be
    departure_date,
    CASE
        WHEN departure_date ~ '^\d{4}/\d{2}/\d{2}$'
             AND SPLIT_PART(departure_date, '/', 2)::INT <= 12
        THEN TO_CHAR(
            TO_DATE(departure_date, 'YYYY/MM/DD'),
            'YYYY/MM/DD'
        )
        WHEN departure_date ~ '^\d{4}/\d{2}/\d{2}$'
             AND SPLIT_PART(departure_date, '/', 2)::INT > 12
        THEN TO_CHAR(
            TO_DATE(departure_date, 'YYYY/DD/MM'),
            'YYYY/MM/DD'
        )
        WHEN departure_date ~ '^\d{2}/\d{2}/\d{4}$'
             AND SPLIT_PART(departure_date, '/', 2)::INT > 12
        THEN TO_CHAR(
            TO_DATE(departure_date, 'MM/DD/YYYY'),
            'YYYY/MM/DD'
        )
        WHEN departure_date ~ '^\d{2}/\d{2}/\d{4}$'
        THEN TO_CHAR(
            TO_DATE(departure_date, 'DD/MM/YYYY'),
            'YYYY/MM/DD'
        )
        ELSE departure_date
    END AS cleaned_date
FROM safari_connect.booking_staging;


UPDATE safari_connect.booking_staging  --now updating my table, departure_column into that format
SET departure_date =
    CASE
        WHEN departure_date ~ '^\d{4}/\d{2}/\d{2}$'
             AND SPLIT_PART(departure_date, '/', 2)::INT <= 12
        THEN TO_CHAR(
            TO_DATE(departure_date, 'YYYY/MM/DD'),
            'YYYY/MM/DD'
        )      -- YYYY/MM/DD
        WHEN departure_date ~ '^\d{4}/\d{2}/\d{2}$'
             AND SPLIT_PART(departure_date, '/', 2)::INT > 12
        THEN TO_CHAR(
            TO_DATE(departure_date, 'YYYY/DD/MM'),
            'YYYY/MM/DD'
        )    -- YYYY/DD/MM
        WHEN departure_date ~ '^\d{2}/\d{2}/\d{4}$'
             AND SPLIT_PART(departure_date, '/', 2)::INT > 12
        THEN TO_CHAR(
            TO_DATE(departure_date, 'MM/DD/YYYY'),
            'YYYY/MM/DD'
        )     -- MM/DD/YYYY
        WHEN departure_date ~ '^\d{2}/\d{2}/\d{4}$'
        THEN TO_CHAR(
            TO_DATE(departure_date, 'DD/MM/YYYY'),
            'YYYY/MM/DD'
        )      -- DD/MM/YYYY
        ELSE departure_date
    END;






-- Remove duplicates =============================================================
select booking_id, count(*) as count
from safari_connect.booking_staging bs 
group by bs.booking_id
having count(*) >1
order by booking_id;

SELECT ctid, booking_id
FROM safari_connect.booking_staging
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    from safari_connect.booking_staging
    GROUP BY booking_id
)
ORDER BY booking_id, ctid; ---this querry basically finds the duplicate rows in the table

-- Remove exact duplicates (keep first ctid)
DELETE FROM safari_connect.booking_staging 
WHERE ctid NOT IN 
    (SELECT MIN(ctid) FROM safari_connect.booking_staging GROUP BY booking_id);


select * from safari_connect.booking_staging;
set search_path to safari_connect;



