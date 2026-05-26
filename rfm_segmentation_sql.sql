-- CREATE DATABASE IF NOT EXISTS rfm_db;
use rfm_db;
select * from sales202501;
-- ================================================================================================================================================================================
-- step 1 :append all monthly sales tables together
-- ================================================================================================================================================================================
DROP TABLE IF EXISTS filter_table;
create  table sales_2025 as
select * from sales202501 
union all select * from sales202502
union all select * from sales202503
union all select * from sales202504
union all select * from sales202505
union all select * from sales202506
union all select * from sales202507
union all select * from sales202508
union all select * from sales202509
union all select * from sales202510
union all select * from sales202511
union all select * from sales202512;

select * from sales_2025;
-- =================================================================================================================================================================================
--  step 2: calculating recency , frequency , monetary , r, f, m ranks
-- combine views with CTEs
-- =================================================================================================================================================================================
Create or replace view rfm_metrics 
As
With present_date as(
  Select date('2026-03-06') as analysis_date
),
rfm as(
  Select 
	customerid,
	max(orderdate) as last_order_date,
	datediff((select analysis_date from present_date),max(orderdate)) as recency,
	count(*) as frequency,
	sum(ordervalue) as monetary
 from sales_2025
 group by customerid
)
select rfm.*,
       row_number() over(order by recency asc) as r_rank,
       row_number() over(order by frequency desc) as f_rank,
       row_number() over(order by monetary desc) as m_rank
from rfm;

select * from rfm_metrics order by r_rank;
select * from rfm_metrics order by r_rank desc;
select * from rfm_metrics order by f_rank desc;
select * from rfm_metrics order by f_rank ;
select * from rfm_metrics order by m_rank desc;
select * from rfm_metrics order by m_rank;
-- =================================================================================================================================================================================
-- step 3 :assign deciles (10 = best,1 = worst)
-- =================================================================================================================================================================================
create or replace view rfm_scores
as
select * ,
       ntile(10) over(order by r_rank desc) as r_score,
       ntile(10) over(order by f_rank desc) as f_score,
       ntile(10) over(order by m_rank desc) as m_score
from rfm_metrics;
-- =================================================================================================================================================================================
-- step 4 :total score
-- =================================================================================================================================================================================
create or replace view rfm_total_score
as
select
   customerid,
   recency,
   frequency,
   monetary,
   r_score,
   f_score,
   m_score,
   (r_score + f_score + m_score) as rfm_total_score
from rfm_scores
order by rfm_total_score desc;

select * from rfm_total_score;
-- =================================================================================================================================================================================
-- step : 5 bi ready rfm segments table
-- =================================================================================================================================================================================
DROP TABLE IF EXISTS rfm_segments_final;
create  table rfm_segments_final
as
select 
  customerid,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_total_score,
  case
    when rfm_total_score >=28 then 'champions' -- 28-30
    when rfm_total_score >=24 then 'loyal VIPs'
    when rfm_total_score >=20 then 'potential loyalists'
    when rfm_total_score >=16 then 'promising'
    when rfm_total_score >=12 then 'engaged'
    when rfm_total_score >=8 then 'requires attention'
    when rfm_total_score >=4 then 'at risk'
    else 'lost/inactive'
end as rfm_segment
from rfm_total_score
order by rfm_total_score desc;

select * from rfm_segments_final;

select rfm_segment,count(*) from rfm_segments_final
group by rfm_segment;
select count(*) from rfm_segments_final;