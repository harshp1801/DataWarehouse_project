create or alter procedure Bronze.load_bronze_schema as 
Begin
    Declare @start_time Datetime2, @end_time Datetime2, @start_batch_time Datetime2, @end_batch_time Datetime2;
        Begin Try
            set @start_time = getdate();
            print '===================================== Truncating Table cust_info ======================================================';
            truncate table Bronze.cust_info;
            print '======================================================= Done ==========================================================';

            print '===================================== Inserting customer information in table cust_info ===============================';
            bulk insert Bronze.cust_info
            from '\var\opt\mssql\import\olist_dataset\olist_customers_dataset.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '======================================================= Done ==========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Customer Info Table';

            set @start_time = getdate();
            print '===================================== Truncating Table Geolocation info ===============================================';
            truncate table Bronze.geo_locationinfo;
            print '======================================================= Done ==========================================================';

            print '=========================== Inserting Geolocation information in table geolocation_info ===============================';
            Bulk insert Bronze.geo_locationinfo
            from '\var\opt\mssql\import\olist_dataset\olist_geolocation_dataset.csv'
            with (
                firstrow = 2,
                fieldterminator = ',', 
                rowterminator = '\n',
                tablock
            );
            print '======================================================= Done ==========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Geo Location Table';

            set @start_time = getdate();
            print '=========================================== Truncating table Orders_main ==============================================';
            TRUNCATE table Bronze.orders_main;
            print '======================================================= Done ==========================================================';

            print '============================== Inserting Orders information in orders_main table ======================================';
            Bulk insert Bronze.orders_main
            from '\var\opt\mssql\import\olist_dataset\olist_orders_dataset.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '======================================================= Done ==========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Orders Table';

            set @start_time = getdate();
            print '=========================================== Truncating table orderitems ===============================================';
            truncate table Bronze.orders_orderitem;
            print '======================================================= Done ==========================================================';

            print '================================ Inserting item information in orders_orderitems table ================================';
            Bulk insert Bronze.orders_orderitem
            from '\var\opt\mssql\import\olist_dataset\olist_order_items_dataset.csv'
            with(
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '======================================================= Done ==========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Order Items Table';

            set @start_time = getdate();
            print '========================================== Truncating table orderpayments =============================================';
            truncate table Bronze.orders_orderpayment;
            print '======================================================= Done ==========================================================';

            print '============================== Inserting payment information in orders_orderpayment table =============================';
            bulk insert Bronze.orders_orderpayment
            from '\var\opt\mssql\import\olist_dataset\olist_order_payments_dataset.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '======================================================== Done =========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Order Payments Table';

            set @start_time = getdate();
            print '========================================= Truncating table orderreviews ===============================================';
            truncate table Bronze.orders_orderreviews;
            print '======================================================== Done =========================================================';

            print '============================= Inserting review information in orders_orderreview table ================================';
            bulk insert Bronze.orders_orderreviews
            from '\var\opt\mssql\import\olist_dataset\cleaned_reviews.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                fieldquote = '"',
                FORMAT = 'CSV',
                tablock
            );
            print '======================================================== Done =========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Order Review Table';

            set @start_time = getdate();
            print '========================================== Truncating table products_main =============================================';
            truncate table Bronze.products_main;
            print '======================================================== Done =========================================================';

            print '=========================== Inserting products information in products_main table =====================================';
            bulk insert Bronze.products_main
            from '\var\opt\mssql\import\olist_dataset\olist_products_dataset.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '========================================================= Done ========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Products Table';

            set @start_time = getdate();
            print '============================== Truncating table product_category_translation ==========================================';
            truncate table Bronze.product_category_translation;
            print '========================================================= Done ========================================================';

            print '===================== Inserting translation information in product_category_translation table =========================';
            bulk insert Bronze.product_category_translation
            from '\var\opt\mssql\import\olist_dataset\product_category_name_translation.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '========================================================= Done ========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Product Category Translation Table';

            set @start_time = getdate();
            print '============================================= Truncating table sellers_main ===========================================';
            truncate table Bronze.sellers_main;
            print '========================================================= Done ========================================================';

            print '======================== Inserting Sellers or shippers information in sellers_main table ==============================';
            bulk insert Bronze.sellers_main
            from '\var\opt\mssql\import\olist_dataset\olist_sellers_dataset.csv'
            with (
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '========================================================= Done ========================================================';
            set @end_time = getdate();
            print cast(Datediff(second,@start_time,@end_time) as NVARCHAR)  + ' Seconds to perform operations on Sellers Table';
            
            set @start_time = GETDATE();
            print '================================ Truncating Customers Personal Info Table =============================================';
            TRUNCATE table Bronze.customer_personal_info;
            print '========================================================= Done ========================================================';

            print '=========================== Insering Customer Information in customer_personal_info Table =============================';
            bulk insert Bronze.customer_personal_info
            from '\var\opt\mssql\import\olist_dataset\olist_synthetic_customer_personal_info.csv'
            with(
                firstrow = 2,
                fieldterminator = ',',
                rowterminator = '\n',
                tablock
            );
            print '========================================================= Done ========================================================';
            set @end_time = GETDATE();
            print cast(datediff(second,@start_time,@end_time) as nvarchar) + ' Seconds to perform operations on Personal Info table';

        End TRY
        Begin CATCH
            print '====================================================== Error Occured ==================================================';
            print 'Error Message : '+ Error_message();
            print 'Error Number : ' + cast(error_number() as varchar);
            print '=======================================================================================================================';
        End CATCH
END