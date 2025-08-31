use datawarehouse_project;
GO

if object_id('Bronze.cust_info','U') is not NULL -- to check if table with saamme name exists if yes then drop it and create one with following features
    drop table Bronze.cust_info;

create TABLE Bronze.cust_info(
    customer_id nvarchar(50),
    customer_unique_id nvarchar(50),
    customer_zip_code_prefix nvarchar(50),
    customer_city nvarchar(50),
    customer_state nvarchar(50)
)

if object_id('Bronze.geo_locationinfo','U') is not NULL
    drop table Bronze.geo_locationinfo;

create table Bronze.geo_locationinfo(
    geolocation_zip_code_prefix nvarchar(50),
    geolocation_lattitude float,
    geolocation_longitude float,
    geolocation_city nvarchar(50),
    geolocation_state nvarchar(50)
)

if object_id('Bronze.orders_orderitem','U') is not NULL
    drop table Bronze.orders_orderitem;

create table Bronze.orders_orderitem(
    order_id nvarchar(50),
    order_item_id int,
    product_id nvarchar(50),
    seller_id nvarchar(50),
    shipping_limit_date datetime2,
    price float,
    freight_value float
)

if object_id('Bronze.orders_orderpayment','U') is not null
    drop table Bronze.orders_orderpayment;

create table Bronze.orders_orderpayment(
    order_id nvarchar(50),
    payment_sequential int,
    payment_type nvarchar(50),
    payment_installments int,
    payment_value float
)

if object_id('Bronze.orders_orderreviews','U') is not NULL
    drop table Bronze.orders_orderreviews;

create table Bronze.orders_orderreviews(
    review_id nvarchar(50),
    order_id nvarchar(50),
    review_score float,
    review_comment_title nvarchar(50),
    review_comment_message nvarchar(1000),
    review_creation_date datetime2,
    review_answer_timestamp datetime2
)

if object_id('Bronze.orders_main','U') is not NULL
    drop table Bronze.orders_main;

create table Bronze.orders_main(
    order_id nvarchar(50),
    customer_id nvarchar(50),
    order_status nvarchar(50),
    order_purchase_timestamp datetime2,
    order_approved_at datetime2,
    order_delivered_carrier_date datetime2,
    order_delivered_customer_date datetime2,
    order_estimated_delivery_date datetime2
)

if object_id('Bronze.products_main','U') is not null
    drop table Bronze.products_main;

create table Bronze.products_main(
    product_id nvarchar(50),
    product_category_name nvarchar(50),
    product_name_length int,
    product_description_length int,
    product_photo_qty int,
    product_weight_gm float,
    product_length_cm float,
    product_height_cm float,
    product_width_cm float
)

if object_id('Bronze.sellers_main','U') is not NULL
    drop table Bronze.sellers_main;

create table Bronze.sellers_main(
    seller_id nvarchar(50),
    seller_zip_code_prefix nvarchar(50),
    seller_city nvarchar(50),
    seller_state nvarchar(50)
)

if object_id('Bronze.product_category_translation','U') is not null
    drop table Bronze.product_category_translation;

create table Bronze.product_category_translation(
    product_category_name nvarchar(100),
    product_category_name_english nvarchar(100)
)

if object_id('Bronze.customer_personal_info') is not NULL
drop table Bronze.customer_personal_info;

create table Bronze.customer_personal_info (
    customer_unique_id nvarchar(50),
    full_name nvarchar(50),
    age nvarchar(50),
    occupation nvarchar(50)
);