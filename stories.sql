--user story 1: I can sign in or join in the platform so I can rent a car through this application.

drop procedure if exists p_upsert_customer
GO
create procedure p_upsert_customer(
    @customer_firstname varchar(50), 
    @customer_lastname varchar(50), 
    @customer_username VARCHAR(50),
    @customer_phone varchar(50), 
    @customer_email varchar(50), 
    @customer_address varchar(50), 
    @customer_drilic varchar(50)
)as 
begin
    if exists(select*from customers
                    where customer_email=@customer_email)
    begin update customers set customer_firstname=@customer_firstname,
                           customer_lastname=@customer_lastname,
                           customer_username=@customer_username,
                           customer_phone=@customer_phone,
                           customer_email=@customer_email,
                           customer_address=@customer_address,
                           customer_drilic=@customer_drilic
                where customer_email=@customer_email 
    end
    else BEGIN
    declare @id int
    set @id = (select max(customer_id)+1 from customers)
    insert into customers(customer_firstname, customer_lastname, customer_username, customer_phone, customer_email, customer_address, customer_drilic)
        values(@customer_firstname, @customer_lastname,@customer_username, @customer_phone, @customer_email, @customer_address, @customer_drilic)
    END
END
GO

select * from customers
exec p_upsert_customer  @customer_firstname='joey', @customer_lastname='Chou', @customer_username='joey778', @customer_email='joey01@syr.edu', @customer_phone='3189135340' , @customer_address='301 University Avenue, Syracuse, NY', @customer_drilic='896654379'
select * from customers


--user story 2: I can check the avilibility of the car and I can see how much I need to pay
drop PROCEDURE if exists p_check_avail
go
create procedure [dbo].[p_check_avail](
@start datetime,@end datetime)
as begin 
select distinct car_id from cars left join orders ON cars.car_id=orders.order_car_id
where orders.order_end_date > @start and orders.order_is_complete = 0
union 
select distinct car_id from cars left join orders ON cars.car_id=orders.order_car_id
where orders.order_is_complete = 1
end

drop PROCEDURE if exists p_calcul
go
create procedure [dbo].[p_calcul](
@start datetime,@end datetime,@car_id int)
as begin 
select car_price*(datediff(DAY,@start,@end)) from cars where car_id=@car_id
end





--user story 3: I can rate for the car I rented after I finished my rental and I can write the comments for the car.
drop procedure if exists p_ratings
GO
create procedure p_ratings(
  @order int,
  @rating int,
  @comment varchar(500)
) as BEGIN
begin TRY
 begin transaction
  insert into reviews(review_order_id, review_rating, review_comment) VALUES
  (@order, @rating, @comment)
commit
end TRY
begin CATCH
print 'ROLLBACK'
ROLLBACK
;
THROW
end catch
END



--manager story 1: As a manager I can insert cars' information and update the car's detail.
drop PROCEDURE if exists p_update_car
go
create procedure [dbo].[p_update_car](@car_id int,
@car_brand varchar(20),
@car_model varchar(20),
@car_color varchar(20),
@car_year varchar(20),
@car_mileage int,
@car_category varchar(20),
@car_price money,
@car_license_plate varchar(50),
@car_location_id int)
as begin 
if ISNULL(@car_brand,'00') <>'00'
begin 
update cars set car_brand = @car_brand where car_id = @car_id
END
if ISNULL(@car_model,'00') <>'00'
begin 
update cars set car_model = @car_model where car_id = @car_id
END
if ISNULL(@car_color,'00') <>'00'
begin 
update cars set car_color = @car_color where car_id = @car_id
END
if ISNULL(@car_year,'00') <>'00'
begin 
update cars set car_year = @car_year where car_id = @car_id
END
if ISNULL(@car_mileage,'00') <>'00'
begin 
update cars set car_mileage = @car_mileage where car_id = @car_id
END
if ISNULL(@car_category,'00') <>'00'
begin 
update cars set car_category = @car_category where car_id = @car_id
END
if ISNULL(@car_price,'00') <>'00'
begin 
update cars set car_price = @car_price where car_id = @car_id
END
if ISNULL(@car_license_plate,'00') <>'00'
begin 
update cars set car_license_plate = @car_license_plate where car_id = @car_id
END
if ISNULL(@car_location_id,'00') <>'00'
begin 
update cars set car_location_id = @car_location_id where car_id = @car_id
END

end

drop PROCEDURE if exists p_insert_car
go
create procedure [dbo].[p_insert_car](
@car_brand varchar(20),
@car_model varchar(20),
@car_color varchar(20),
@car_year varchar(20),
@car_mileage int,
@car_category varchar(20),
@car_price money,
@car_license_plate varchar(50),
@car_location_id int)
as begin 
insert cars(car_brand,car_model,car_color,car_year,car_mileage,car_category,car_price,car_license_plate,car_location_id) values (@car_brand,
@car_model,@car_color,@car_year,@car_mileage,@car_category,@car_price,@car_license_plate,@car_location_id)

end


--manager story 2: As a manager, I can review the insurance history to make sure the car has effective insurance.
drop function if exists f_car_insurance
GO
create function f_car_insurance(@car_license_plate varchar(50))
returns TABLE AS
return(
    select * from cars
        join insurances on insurance_car_id=car_id
        WHERE car_license_plate=@car_license_plate)
GO

select * FROM f_car_insurance('2345SU')



--manage story 3: As a manager, I can update the statu of car when the order complete.
drop PROCEDURE if exists p_update_order_state
go
create procedure [dbo].[p_update_order_state](@order int)
as begin 
    update orders set order_is_complete = 1 where order_id=@order
end





