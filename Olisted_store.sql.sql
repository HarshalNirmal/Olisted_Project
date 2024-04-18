create database olist_ecommerce;
use olist_ecommerce;

Select * from olist_customers_dataset;
Select * from olist_geolocation_dataset;
Select * from olist_order_items_dataset;
Select * from olist_order_payments_dataset;
Select * from olist_order_reviews_dataset;
Select * from olist_orders_dataset;
Select * from olist_products_dataset;
Select * from olist_sellers_dataset;
Select * from product_category_name_translation;

# 1st-KPI
# Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

Select
case when dayofweek(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) IN (5,6) then 'Weekend' else 'Weekday' end as Day_type,
count(distinct o.order_id) AS Total_orders,
round(sum(p.payment_value) ) as Total_Payments,
round(avg(p.payment_value)) as Average_payment
from
olist_orders_dataset o
join
olist_order_payments_dataset p
on o.order_id=p.order_id
group by
Day_type;

# 2nd-KPI
# Number of Orders with review score 5 and payment type as credit card

select
count(distinct p.order_id) as Number_of_orders
from
olist_order_payments_dataset p 
join
olist_order_reviews_dataset r
on p.order_id=r.order_id
Where p.payment_type='Credit_card'
and r.review_score=5;


# 3rd-KPI 
# Average number of days taken for order_delivered_customer_date for pet_shop

select
p.product_category_name as product_category_name,
round(AVG(DATEDIFF(o.order_delivered_customer_date,o.order_purchase_timestamp)))as Avg_delivery_time
FROM
olist_orders_dataset o
join
olist_order_items_dataset oi
on o.order_id=oi.order_id
join
olist_products_dataset p
on oi.product_id=p.product_id
where 
product_category_name='pet_shop';

# 4th-KPI 
# Average price and payment values from customers of sao paulo city

select
s.seller_city as City,
round(avg(oi.price)) as Avg_price,
round(avg(p.payment_value)) as Avg_payment_value
from
olist_order_payments_dataset p
join
olist_order_items_dataset oi 
on p.order_id=oi.order_id
join
olist_sellers_dataset s
on oi.seller_id=s.seller_id
Where seller_city='sao paulo';

# 5th-KPI 
# Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select
round(avg(datediff(o.order_delivered_customer_date,o.order_purchase_timestamp))) as Avg_shipping_days,
r.review_score as Review_score
from
olist_order_reviews_dataset r
join
olist_orders_dataset o
on r.order_id=o.order_id
where order_delivered_customer_date is not null
and order_purchase_timestamp is not null
group by
Review_score 
order by
Review_score asc;





