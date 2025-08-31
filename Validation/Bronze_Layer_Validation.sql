-- for cust_info table
-- to check discrepency in data
select top(100) * from bronze.cust_info
-- at some places we have "" at start and end of customer_id, customer_unique_id need to take care of that also trim the string data if needed
-- check is customer_id is unique and id not null as it will work as the primary key for the customer_info table
select customer_id,count(*) from Bronze.cust_info
group by customer_id
having count(*)>1
-- check if any null value is present in the customer info table
select * from Bronze.cust_info
where customer_id is null or customer_unique_id is null or customer_zip_code_prefix is null or customer_city is null or customer_state is null

print '================================================================================================================================================'

-- for customer_personal_info table
-- to check discrepency in data
select top(100) * from bronze.customer_personal_info
-- at some places we have "" at start and end of customer_unique_id need to take care of that also trim the string data if needed
-- check is customer_unique_id is unique and is not null as it will work as the primary key for the customer_personal_info table
select customer_unique_id,count(*) from Bronze.customer_personal_info
group by customer_unique_id
having count(*)>1
-- check if any null value is present in the customer personal info table
select * from Bronze.customer_personal_info
where customer_unique_id is null or full_name is null or age is null or occupation is null
-- we can join customer_info and personal_info to create a silver.customers_main_table

print '================================================================================================================================================'

-- for geo_locationinfo table
-- to check discrepency in data
select top(100) * from bronze.geo_locationinfo 
-- at some places we have "" at start and end of geolocation_zip_code_prefix need to take care of that also trim the string data if needed
select distinct geolocation_city from Bronze.geo_locationinfo
-- check is geolocation_zip_code_prefix won't be unique aa multiple cities can have same zip code  and still it will work as the primary key for the geo_locationinfo table
select geolocation_zip_code_prefix,count(geolocation_city) from Bronze.geo_locationinfo
group by geolocation_zip_code_prefix
having count(geolocation_city)>1
-- check if any null value is present in the geo_locationinfo table
select * from bronze.geo_locationinfo 
where geolocation_zip_code_prefix is null or geolocation_lattitude is null or geolocation_longitude is null or geolocation_city is null or geolocation_state is null

print '================================================================================================================================================'

-- for orders_main table
-- to check discrepency in data
select top(100) * from bronze.orders_main 
-- at some places we have "" at start and end of order_id and customer_id need to take care of that also trim the string data if needed
-- check if order_id is unique and is not null as it will work as the primary key for the order_mains table
select order_id,count(*) from Bronze.orders_main
group by order_id
having count(*)>1
-- check if any null value is present in the orders_main table
select * from Bronze.orders_main
where order_id is null or order_approved_at is null or customer_id is null or order_delivered_carrier_date is null or order_delivered_customer_date is null or order_estimated_delivery_date is null or order_status is null or order_purchase_timestamp is null
-- there are nulls in order_delivered_carrier_date and order_delivered_customer_date this is mainly as those orders were in shipped stage or cancelled or invoiced at the time of data extraction 
-- further year, month columns can be created from this dates
select * from (
select *,
CASE
  WHEN order_purchase_timestamp <= order_approved_at AND
       order_approved_at <= order_delivered_carrier_date AND
       order_delivered_carrier_date <= order_delivered_customer_date
  THEN 1 ELSE 0
END as is_temporally_valid from bronze.orders_main) as a
where is_temporally_valid = 0
-- discrepancies in dates for few records have approved_at date> order_delivered_carrrier_date same errors with carrier date and delivered_customer_date;


print '================================================================================================================================================'

-- for orders_orderitem table
-- to check discrepency in data
select top(100) * from bronze.orders_orderitem 
-- at some places we have "" at start and end of order_id and produt_id and seller_id need to take care of that also trim the string data if needed
select order_item_id,count(*) from bronze.orders_orderitem
group by order_id
having count(*)>1
-- it is observed that the order_item is repeated here the repetation of order_item_id tells how many quantity of the product was bought by customer 
select * from bronze.orders_orderitem
where order_id is null or product_id is null or order_item_id is null or seller_id is null or shipping_limit_date is null or price is null or freight_value is null 
-- there are no nulls in orders_orderitems table, further year, month columns can be created from the shiping_limit_date column

select * from bronze.orders_orderitem
where order_id not in (select order_id from bronze.orders_main)

print '================================================================================================================================================'

-- for orders_orderpayment table
-- to check discrepency in data
select top(100) * from bronze.orders_orderpayment 
-- at some places we have "" at start and end of order_id need to take care of that also trim the string data if needed
select order_id,count(*) from bronze.orders_orderpayment
group by order_id
having count(*)>1
-- it is observed that the order_id is repeated here payment for such order_ids are done in installments 
select * from bronze.orders_orderpayment
where order_id is null or payment_installments is null or payment_sequential is null or payment_type is null or payment_value is null 
-- there are no nulls in orders_orderpayment table
select * from bronze.orders_orderpayment
where order_id not in (select order_id from bronze.orders_main)

print '================================================================================================================================================'

-- for product_main table
-- to check discrepency in data
select top(100) * from bronze.products_main 
-- at some places we have "" at start and end of produt_id need to take care of that also trim the string data if needed
select product_id,count(*) from bronze.products_main
group by product_id
having count(*)>1
-- it is observed that there are no duplicate product_id in the tbl 
-- check if any null value is present in the products_main tables
select count(*) from bronze.products_main
where product_id is null or product_category_name is null or product_description_length is null or product_height_cm is null or product_length_cm is null or 
product_name_length is null or product_photo_qty is null or product_weight_gm is null or product_width_cm is null
-- there are 611 record with nulls in columns of products_main


print '================================================================================================================================================='

-- for sellers_main table
-- to check discrepency in data
select top(100) * from bronze.sellers_main 
-- at some places we have "" at start and end of seller_id need to take care of that also trim the string data if needed
select seller_id,count(*) from bronze.sellers_main
group by seller_id
having count(*)>1
-- it is observed that there are no duplicate seller_id in the tbl 
-- check if any null value is present in the sellers_main tables
select count(*) from bronze.sellers_main
where seller_id is null or seller_zip_code_prefix is null or seller_city is null or seller_state is null 
-- there are no nulls in columns of products_main


