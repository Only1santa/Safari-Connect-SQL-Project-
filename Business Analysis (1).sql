
-- Test
SELECT * FROM v_clean_trips LIMIT 10;


/* Question - 1 : Route Analysis Which routes earn the most? 
Which are most popular? Which is most efficient per seat sold?

Specific route codes with KES figures - A clear top route and a clear underperformer.
*/

-- first step - Create Route name for the Distinct Route codes
-- Calculate Total_Revenue

with route_name as(
     select distinct route_code, route_from || ' - ' || route_to as name
     from v_clean_trips
),
total_revenue_per_route as(
     select route_code, 
     count(route_code) as popular,
     sum(seats_booked) as total_seats,
     sum(total_fare) as total_revenue
     from v_clean_trips
     group by route_code
)
select tr.route_code,rn.name, tr.popular, tr.total_seats, tr.total_revenue,
rank() over (order by total_revenue desc) as Most_earning_route,
rank() over (order by total_seats, total_revenue desc) as Most_efficient
from total_revenue_per_route tr
inner join route_name rn
on rn.route_code = tr.route_code;



/*Driver Performance Who are the best drivers? 
 * Does driver rating affect passenger satisfaction? : No passenger satisfaction does not affect driver ratings	 
 *Named drivers with revenue and rating figures. 
 *A promotion recommendation with data behind it.
 *(Kelvin Omondi  with an average rating of 4.5(in 3rd postion) and still 
 *second best revenue_generator with a total revenue of 30,855)
-- */
with driver_performance as(
	select driver_name, 
	avg(driver_rating)as driver_rating,
	round(avg(
	case
		when satisfaction = 'No Rating' then null
		when satisfaction = 'Satisfied' then 3
		when satisfaction = 'Unsatisfied' then 1
		when satisfaction = 'Neutral' then 2
		end ),1)
	as avg_passenger_satisfaction,
	sum(total_fare) as revenue_generated
	from v_clean_trips
	group by driver_name
)
select 
	driver_name, 
	revenue_generated,
	rank() over (order by  revenue_generated desc) as Top_Revenue_earner,
	driver_rating,
	avg_passenger_satisfaction,
	rank() over (order by driver_rating desc, revenue_generated) as Top_Rated
from driver_performance 
order by Top_Rated;

select distinct satisfaction from v_clean_trips;


/*
 Revenue Trends How is revenue changing month by month? 
 What are our best and worst months?	Month-over-month change with % growth. 
 A trend direction - growing or declining?
 * */

select total_fare, calculated_fare
from v_clean_trips;


with total_revenue as (
select
     month_label,
     sum(total_fare) as monthly_revenue
from v_clean_trips
group by month_label
),
revenue_trend as(
	select 
	month_label,
	monthly_revenue,
	lag( monthly_revenue,1) over (order by TO_DATE(month_label, 'Month YYYY')) as previous_month_revenue
from total_revenue
)
select
month_label,
monthly_revenue,
previous_month_revenue,
round(100 *(monthly_revenue - previous_month_revenue)/previous_month_revenue,1) as percentage_growth
from revenue_trend 
order by TO_DATE(month_label, 'Month YYYY');

/*WITH monthly AS (
    SELECT 
        TO_CHAR(departure_date, 'YYYY-MM') AS month,
        COUNT(*) AS bookings,
        SUM(total_fare) AS revenue
    FROM v_clean_trips
    GROUP BY TO_CHAR(departure_date, 'YYYY-MM')
)
SELECT 
    month,
    bookings,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    revenue - LAG(revenue) OVER (ORDER BY month) AS change,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 1) AS change_pct
FROM monthly;*/

select * FROM v_clean_trips;
select * from safari_connect.bookings b;