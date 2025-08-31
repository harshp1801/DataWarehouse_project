print '====================================================== Dropping table cust info table ==========================================================='

if object_id('Silver.cust_info','U') is not NULL -- to check if table with saamme name exists if yes then drop it and create one with following features
    drop table Silver.cust_info;

print '================================================ Defining cust_info tables and its feature ======================================================'

create TABLE Silver.cust_info(
    customer_id nvarchar(50),
    customer_unique_id nvarchar(50),
    customer_zip_code_prefix nvarchar(10),
    customer_city nvarchar(30),
    customer_state nvarchar(10),
    full_name nvarchar(30),
    age INT,
    occupation NVARCHAR(20),
    dwh_create_date datetime2 default getdate()
)

print '================================================================ Done =========================================================================='


print '==================================================== Dropping Geo Location Table =================================================================='

if object_id('Silver.geo_locationinfo','U') is not NULL
    drop table Silver.geo_locationinfo;

print '============================================= Creating geo location table and its feature ========================================================='

create table Silver.geo_locationinfo(
    geolocation_zip_code_prefix nvarchar(10),
    geolocation_lattitude float,
    geolocation_longitude float,
    geolocation_city nvarchar(20),
    geolocation_state_code nvarchar(10),
    dwh_create_date datetime2 default getdate()
)

print '================================================================ Done =========================================================================='

print '================================================== Dropping table order reviews ================================================================'

if object_id('Silver.orders_orderreviews','U') is not NULL
    drop table Silver.orders_orderreviews;

print '================================================= Creating table order reviews ================================================================'

create table Silver.orders_orderreviews(
    review_id nvarchar(50),
    order_id nvarchar(50),
    review_score float,
    review_comment_title nvarchar(max),
    review_comment_message nvarchar(max),
    review_creation_date datetime2,
    review_answer_timestamp datetime2,
    dwh_create_date datetime2 default getdate()
)

print '================================================================ Done =========================================================================='

print '================================================== Dropping table orders main table =============================================================='

if object_id('Silver.orders_main','U') is not NULL
    drop table Silver.orders_main;

print '================================================= Creating orders main table and its features ===================================================='

create table Silver.orders_main(
    order_id nvarchar(50),
    customer_id nvarchar(50),
    product_id nvarchar(50),
    seller_id nvarchar(50),
    order_status nvarchar(20),
    order_approved_at datetime2,
    order_delivered_carrier_date datetime2,
    order_delivered_customer_date datetime2,
    order_estimated_delivery_date datetime2,
    order_purchase_timestamp datetime2,
    shipping_limit_date datetime2,
    quantity INT,
    price float,
    freight_value float,
    total_price float,
    dwh_create_date datetime2 default getdate()
);

PRINT '============================================================= Done =============================================================================='

print '====================================================== Dropping order Payment table ================================================================'

if object_id('Silver.orders_orderpayment','U') is not NULL
    drop table Silver.orders_orderpayment;

print '=============================================== Creating order payment table and its feature ======================================================='

create table Silver.orders_orderpayment(
    order_id nvarchar(50),
    payment_sequential int,
    payment_type nvarchar(20),
    payment_installments int,
    payment_value float,
    dwh_create_date datetime2 default getdate()
)

PRINT '============================================================= Done =============================================================================='

print '===================================================== Dropping products main table ============================================================='

if object_id('Silver.products_main','U') is not null
    drop table Silver.products_main;

print '=================================================== Creating table products main ==============================================================='

create table Silver.products_main(
    product_id nvarchar(50),
    product_category_name nvarchar(100),
    product_name_length int,
    product_description_length int,
    product_photo_qty int,
    product_weight_gm float,
    product_length_cm float,
    product_height_cm float,
    product_width_cm float,
    product_category_name_english nvarchar(100),
    dwh_create_date datetime2 default getdate()
)

PRINT '============================================================= Done =============================================================================='

print '===================================================== Dropping table sellers table ==============================================================='

if object_id('Silver.sellers_main','U') is not NULL
    drop table Silver.sellers_main;

print '===================================================== Creating sellers main table ================================================================'

create table Silver.sellers_main(
    seller_id nvarchar(50),
    seller_zip_code_prefix nvarchar(50),
    seller_city nvarchar(50),
    seller_state nvarchar(50),
    dwh_create_date datetime2 default getdate()
)

PRINT '============================================================= Done =============================================================================='

