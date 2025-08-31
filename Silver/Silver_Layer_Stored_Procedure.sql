create or alter procedure Silver.load_silver_schema as
Begin
    Declare @start_time Datetime2, @end_time Datetime2, @start_batch_time Datetime2, @end_batch_time Datetime2;
        Begin Try
            set @start_time = getdate();
            -- customers table
            print '================================================== Dropping Table Cust_info table ==============================================================='
            truncate table silver.cust_info;
            print '================================================================= Done =========================================================================='

            print '=============================================== Inserting values in cust_info table ============================================================='

            insert into silver.cust_info(
                customer_id,
                customer_unique_id,
                customer_zip_code_prefix,
                customer_city,
                customer_state,
                full_name,
                age,
                occupation
            )
            select 
            trim(cast(replace(customer_id,'"','') as nvarchar(50))) as customer_id,
            trim(cast(replace(cust_info.customer_unique_id,'"','') as nvarchar(50))) as customer_unique_id,
            cast(replace(customer_zip_code_prefix,'"','') as nvarchar(10)) as customer_zip_code_prefix,
            trim(cast(customer_city as nvarchar(30))) as customer_city,
            trim(cast(customer_state as nvarchar(10))) as customer_state,
            trim(cast(replace(full_name,'"','') as nvarchar(30))) as full_name,
            cast(replace(age,'"','') as int) as age,
            trim(cast(replace(Occupation,'"','') as nvarchar(20))) as Occupation
            from bronze.cust_info 
            left join bronze.customer_personal_info 
            on trim(cast(replace(cust_info.customer_unique_id,'"','') as nvarchar(20))) = trim(cast(replace(customer_personal_info.customer_unique_id,'"','') as nvarchar(20)));

            print '============================================================== Done ============================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on Customer Info table';

            set @start_time = getdate();
            -- orders_table
            print '==================================================== Dropping order item table =================================================================='
            truncate table silver.orders_main
            print '============================================================== Done ============================================================================='

            print '================================================ Creating CTE for order items table =============================================================';

            with aggrregated_order_items as (
            select order_id,product_id,seller_id,shipping_limit_date ,COUNT(order_item_id) quantity ,sum(price) price, sum(freight_value) freight_value from bronze.orders_orderitem
            group by order_id,product_id,shipping_limit_date,seller_id),

            cleaned_orders_main as (
                select order_id,
                customer_id,
                order_status,
                order_purchase_timestamp,
                cast(case 
                    when order_approved_at < order_purchase_timestamp or order_approved_at is null 
                    then order_purchase_timestamp 
                    else order_approved_at end as datetime2)as order_approved_at,
                order_delivered_carrier_date,
                order_delivered_customer_date,
                order_estimated_delivery_date
                from bronze.orders_main),

            cleaned_orders_main_v1 as (
                select order_id,
                customer_id,
                order_status,
                order_purchase_timestamp,
                order_approved_at,
                cast(case 
                    when (order_delivered_carrier_date is not null and order_approved_at is not null and  order_delivered_carrier_date < order_approved_at)
                    or (order_delivered_carrier_date is null and order_approved_at is not null)
                    then order_approved_at 
                    else order_delivered_carrier_date end as datetime2) as order_delivered_carrier_date,
                order_delivered_customer_date,
                order_estimated_delivery_date
            from cleaned_orders_main),
            
            cleaned_orders_main_v2 as (
                select order_id,
                customer_id,
                order_status,
                order_purchase_timestamp,
                order_approved_at,
                order_delivered_carrier_date,
                cast(case 
                    when (order_delivered_customer_date is not null and order_delivered_carrier_date is not null and order_delivered_customer_date<order_delivered_carrier_date)
                    or (order_delivered_customer_date is null and order_delivered_carrier_date is not null)
                    then order_delivered_carrier_date 
                    else order_delivered_customer_date end as datetime2) as order_delivered_customer_date,
                order_estimated_delivery_date
                from cleaned_orders_main_v1
            )


            insert into silver.orders_main(
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
                total_price
            )
            select 
            TRIM(cast(replace(cleaned_orders_main_v2.order_id,'"','') as nvarchar(50))) as order_id,
            Trim(cast(replace(customer_id,'"','') as nvarchar(50))) as customer_id,
            Trim(cast(replace(product_id,'"','') as nvarchar(50))) as product_id,
            Trim(cast(replace(seller_id,'"','') as nvarchar(50))) as seller_id,
            Trim(order_status) as order_status,
            cast(order_approved_at as datetime2)as order_approved_at,
            cast(order_delivered_carrier_date as datetime2) as order_delivered_carrier_date,
            cast(order_delivered_customer_date as datetime2) as order_delivered_customer_date,
            cast(order_estimated_delivery_date as datetime2) as order_estimated_delivery_date,
            cast(order_purchase_timestamp as DATETIME2) as order_purchase_timestamp,
            cast(shipping_limit_date as datetime2) as shipping_limit_date,
            cast(coalesce(quantity,0) as int) as quantity,
            cast(coalesce(price,0) as float) as price,
            cast(coalesce(freight_value,0) as float) as freight_value,
            cast(round(price+freight_value,2) as float) as total_price
            from cleaned_orders_main_v2 
            left join aggrregated_order_items on cleaned_orders_main_v2.order_id = aggrregated_order_items.order_id;

            print '================================================================ Done ==========================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on Orders table'

            -- orders_payment table
            set @start_time = getdate();
            print '==================================================== Dropping table orders payment =============================================================='
            truncate table silver.orders_orderpayment
            print '================================================================= Done =========================================================================='
            print '================================================= Inserting info in orders payment table ========================================================'

            INSERT into silver.orders_orderpayment(
                order_id,
                payment_sequential,
                payment_type,
                payment_installments,
                payment_value
            )

            select
            TRIM(cast(replace(order_id,'"','') as nvarchar(50))) as order_id,
            cast(payment_sequential as int) as payment_sequential,
            cast(payment_type as nvarchar(20)) as payment_type,
            cast(payment_installments as int) as payment_installments,
            cast(payment_value as float) as payment_value
            from Bronze.orders_orderpayment;

            print '================================================================ Done ==========================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on Orders Payment table'

            --geolocation table
            set @start_time = getdate();
            print '===================================================== Dropping table geo location ==============================================================='
            truncate table silver.geo_locationinfo;
            print '================================================================ Done ==========================================================================='

            print '=================================================== Inserting info in geo location table ========================================================'

            insert into silver.geo_locationinfo(
                geolocation_zip_code_prefix,
                geolocation_lattitude,
                geolocation_longitude,
                geolocation_city,
                geolocation_state_code
            )
            select 
            trim(cast(replace(geolocation_zip_code_prefix,'"','') as nvarchar(10))) as geolocation_zip_code_prefix,
            cast(geolocation_lattitude as float) as geolocation_lattitude,
            cast(geolocation_longitude as float) as geolocation_longitude,
            trim(cast(geolocation_city as nvarchar(20))) as geolocation_city,
            trim(cast(geolocation_state as nvarchar(10))) as geolocation_state_code
            from bronze.geo_locationinfo;

            print '============================================================== Done ============================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on geo location table'

            -- order review table
            set @start_time = getdate();
            print '=================================================== Dropping table order reviews ================================================================'
            truncate table silver.orders_orderreviews;
            print '============================================================== Done ============================================================================='

            print '================================================ Inserting table into order reviews ============================================================='

            insert into silver.orders_orderreviews(
                review_id,
                order_id,
                review_score,
                review_comment_title,
                review_comment_message,
                review_creation_date,
                review_answer_timestamp
            )
            select
            trim(cast(review_id as nvarchar(50))) as review_id,
            trim(cast(order_id as nvarchar(50))) as order_id,
            cast(review_score as float) as review_score,
            trim(cast(review_comment_title as nvarchar(max))) as review_comment_title,
            trim(cast(review_comment_message as nvarchar(max))) as review_comment_message,
            cast(review_creation_date as datetime2) as review_creation_date,
            cast(review_answer_timestamp as datetime2) as review_answer_timestamp
            from bronze.orders_orderreviews;

            print '============================================================== Done ============================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on Order reviews table'

            -- products table
            set @start_time = getdate();
            print '========================================================= Dropping table products ==============================================================='
            truncate table silver.products_main;
            print '============================================================== Done ============================================================================='

            print '=================================================== Inserting info in products main table ======================================================='

            insert into silver.products_main(
                product_id,
                product_category_name,
                product_name_length,
                product_description_length,
                product_photo_qty,
                product_weight_gm,
                product_length_cm,
                product_height_cm,
                product_width_cm,
                product_category_name_english
            )
            select 
            Trim(cast(replace(product_id,'"','') as nvarchar(50))) as product_id,
            trim(cast(products_main.product_category_name as nvarchar(50))) as product_category_name,
            cast(coalesce(product_name_length,0) as int) as product_name_length,
            cast(coalesce(product_description_length,0) as int) as product_description_length,
            cast(coalesce(product_photo_qty,0) as int) as product_photo_qty,
            cast(coalesce(product_weight_gm,0) as float) as product_weight_gm,
            cast(coalesce(product_length_cm,0) as float) as product_length_cm,
            cast(coalesce(product_height_cm,0) as float) as product_height_cm,
            cast(coalesce(product_width_cm,0) as float) as product_width_cm,
            trim(cast(left(product_category_name_english,len(product_category_name_english)-1) as nvarchar(max))) as product_category_name_english
            from bronze.products_main 
            left join Bronze.product_category_translation 
            on products_main.product_category_name = product_category_translation.product_category_name;

            print '============================================================== Done ============================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on Products table'

            -- sellers table
            set @start_time = getdate();
            print '========================================================= Dropping table Sellers ================================================================'
            truncate table silver.sellers_main
            print '============================================================== Done ============================================================================='

            print '==================================================== Inserting into sellers main table =========================================================='

            insert into silver.sellers_main(
                seller_id,
                seller_zip_code_prefix,
                seller_city,
                seller_state
            )
            select
            trim(cast(replace(seller_id,'"','') as nvarchar(50))) as seller_id,
            trim(cast(replace(seller_zip_code_prefix,'"','') as nvarchar(10))) as seller_zip_code_prefix,
            trim(cast(seller_city as nvarchar(20))) as seller_city,
            trim(cast(seller_state as nvarchar(10))) as seller_state from bronze.sellers_main

            print '============================================================== Done ============================================================================='
            set @end_time = getdate();
            print cast(datediff(second,@start_time,@end_time)as NVARCHAR) + ' Seconds to perform operations on Sellers table'
        End TRY
        Begin CATCH
            print '====================================================== Error Occured ============================================================================';
            print 'Error Message : '+ Error_message();
            print 'Error Number : ' + cast(error_number() as varchar);
            print '=================================================================================================================================================';
        End CATCH
END
