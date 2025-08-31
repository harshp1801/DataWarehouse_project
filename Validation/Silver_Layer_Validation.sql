-- rechecking or revalidating silver.cust_info table
select * from silver.cust_info
where customer_id is null or customer_unique_id is null or customer_zip_code_prefix is null or customer_city is null or customer_state is null
go
select customer_id,count(*) from silver.cust_info
group by customer_id
having count(*)>1


with cte as (
select order_id,product_id,shipping_limit_date ,COUNT(order_item_id) quantity ,sum(price) price, sum(freight_value) freight_value from bronze.orders_orderitem
group by order_id,product_id,shipping_limit_date)

select count(*) from cte

-- rechecking silver.orders_main table

select * from silver.orders_main
where order_id is null or customer_id is null

select * from silver.orders_main
where product_id is null 

select * from(
SELECT *,
CASE
  WHEN order_purchase_timestamp <= order_approved_at AND
       order_approved_at <= order_delivered_carrier_date AND
       order_delivered_carrier_date <= order_delivered_customer_date
  THEN 1 ELSE 0
END as is_temporally_valid FROM silver.orders_main) as a 
where is_temporally_valid = 0

select * from silver.orders_main
where order_id in (select order_id from
(select order_id  ,count(*) cnt from silver.orders_main 
group by order_id 
HAVING count(*)>1) as a)

select seller_id from silver.orders_main
where seller_id not in (select seller_id from Silver.sellers_main)

select customer_id from silver.orders_main
where customer_id not in (select customer_id from silver.cust_info)

select count(*) from silver.orders_main
where product_id not in (select product_id from silver.products_main )

-- silver.geolocation table
select * from silver.geo_locationinfo
select geolocation_zip_code_prefix,count(*) from silver.geo_locationinfo
group by geolocation_zip_code_prefix

-- silver.orders_payment table

select * from silver.orders_orderpayment
select * from silver.orders_orderpayment
where payment_value is NULL
-- no null payments
select order_id,count(*) from silver.orders_orderpayment
group by order_id
having count(order_id)>1
-- accepted as some peoples have made payments in installments resulting in repetation of order_id

select * from silver.orders_orderpayment
where order_id not in (select order_id from silver.orders_main)

select sum(total_price) from Silver.orders_main
where order_id = '364f451ee38a4268d7c15d317021eb35'

select sum(payment_value) from silver.orders_orderpayment
where order_id = '364f451ee38a4268d7c15d317021eb35'

-- order review

select * from silver.orders_orderreviews
where order_id  not in (select order_id from silver.orders_main)

select * from silver.orders_orderreviews
where review_creation_date>review_answer_timestamp

select * from silver.orders_orderreviews
where order_id is null or review_id is null

-- products main

select * from silver.products_main
where product_category_name is null

select * from silver.products_main
where product_id is null


-- sellers table

select * from silver.sellers_main
select * from silver.sellers_main
where seller_id is null or seller_zip_code_prefix is null or seller_city is null or seller_state is null