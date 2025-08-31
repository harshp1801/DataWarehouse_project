
create view gold.dim_geolocation as(
select geolocation_zip_code_prefix,geolocation_city,geolocation_state_code,
            case 
            when geolocation_zip_code_prefix BETWEEN '69900' and '69999' then 'Acre'
            when geolocation_zip_code_prefix BETWEEN '57000' and '57999' then 'Alagoas'
            when geolocation_zip_code_prefix BETWEEN '68900' and '68999' then 'Amapa'
            when geolocation_zip_code_prefix BETWEEN '69900' and '69299' then 'Amazonas'
            when geolocation_zip_code_prefix BETWEEN '40000' and '48999' then 'Bahia'
            when geolocation_zip_code_prefix BETWEEN '60000' and '63999' then 'Ceara'
            when geolocation_zip_code_prefix BETWEEN '70000' and '73699' then 'Distrito Federal'
            when geolocation_zip_code_prefix BETWEEN '29000' and '29999' then 'Espirito Santo'
            when geolocation_zip_code_prefix BETWEEN '72800' and '76799' then 'Goias'
            when geolocation_zip_code_prefix BETWEEN '65000' and '65999' then 'Maranhao'
            when geolocation_zip_code_prefix BETWEEN '78000' and '78899' then 'Mato Grosso'
            when geolocation_zip_code_prefix BETWEEN '79000' and '79999' then 'Mato Grosso do sul'
            when geolocation_zip_code_prefix BETWEEN '30000' and '39999' then 'Minas Gerais'
            when geolocation_zip_code_prefix BETWEEN '66000' and '68899' then 'Para'
            when geolocation_zip_code_prefix BETWEEN '58000' and '58999' then 'Paraiba'
            when geolocation_zip_code_prefix BETWEEN '80000' and '87999' then 'Parana'
            when geolocation_zip_code_prefix BETWEEN '50000' and '56999' then 'Pernambuco'
            when geolocation_zip_code_prefix BETWEEN '64000' and '64999' then 'Piaui'
            when geolocation_zip_code_prefix BETWEEN '20000' and '28999' then 'Rio de Janerio'
            when geolocation_zip_code_prefix BETWEEN '59000' and '59999' then 'Rio Grande do Norte'
            when geolocation_zip_code_prefix BETWEEN '90000' and '99999' then 'Rio Grande do Sul'
            when geolocation_zip_code_prefix BETWEEN '76800' and '76999' then 'Rondonia'
            when geolocation_zip_code_prefix BETWEEN '69300' and '69399' then 'Roraima'
            when geolocation_zip_code_prefix BETWEEN '88000' and '89999' then 'Santa Catarina'
            when geolocation_zip_code_prefix BETWEEN '01000' and '19999' then 'Sao Paulo'
            when geolocation_zip_code_prefix BETWEEN '49000' and '49999' then 'Sergipe'
            when geolocation_zip_code_prefix BETWEEN '77000' and '77999' then 'Tocantins'
            end as 'geolocation_state'
from( select geolocation_zip_code_prefix,geolocation_city,geolocation_state_code,count(*) cnt, dense_rank() over (partition by geolocation_zip_code_prefix order by count(*) desc) rnk from silver.geo_locationinfo
group by geolocation_zip_code_prefix,geolocation_city,geolocation_state_code) as a
where rnk = 1)

GO

create view gold.dim_Customer_info as (
select customer_id ,
customer_unique_id Customer_UID,
full_name as customer_name,
age,
occupation,
customer_zip_code_prefix Zipcode,
customer_city City,
customer_state as State 
from silver.cust_info);

GO

create view gold.dim_payments as
(select
concat(order_id,payment_sequential) as payment_id,
order_id,
payment_sequential,
payment_type payment_mode,
payment_installments,
payment_value from silver.orders_orderpayment)

GO

create view gold.dim_reviews as
(select 
review_id,
order_id,
review_score,
review_comment_title,
review_comment_message,
review_creation_date,
review_answer_timestamp 
from silver.orders_orderreviews)

GO

create view gold.fact_orders as 
(SELECT
order_id,
customer_id,
product_id,
seller_id,
order_status,
order_approved_at,
order_delivered_carrier_date,
order_delivered_customer_date,
order_estimated_delivery_date,
order_purchase_timestamp,
shipping_limit_date,
quantity,
price,
freight_value,
total_price,
datediff(DAY,order_purchase_timestamp,order_delivered_customer_date) as days_to_deliver,
case 
when order_delivered_customer_date<order_estimated_delivery_date then 'Early Delivery' 
when order_delivered_customer_date = order_estimated_delivery_date then 'On time Delivery'
else 'Delayed Delivery' end as Delivery_Bucket 
from silver.orders_main)

GO

create view gold.dim_sellers as
(
select 
seller_id,
seller_zip_code_prefix,
seller_city,
seller_state from silver.sellers_main 
)

GO

create view gold.dim_products_main as 
(
select
product_id,
product_category_name,
product_weight_gm,
product_length_cm,
product_width_cm,
product_category_name_english
from 
silver.products_main)
