create database carent
use carent
GO

--down
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_car_location_id') 
alter table cars  drop CONSTRAINT fk_car_location_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_order_customer_id') 
alter table orders drop CONSTRAINT fk_order_customer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_order_payment_id ') 
alter table orders drop CONSTRAINT fk_order_payment_id


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_order_car_id') 
alter table orders drop CONSTRAINT fk_order_car_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_order_pickup_location_id') 
alter table orders drop CONSTRAINT fk_order_pickup_location_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_order_return_location_id') 
alter table orders drop CONSTRAINT fk_order_return_location_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_insurance_car_id') 
alter table insurances drop CONSTRAINT fk_insurance_car_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_payment_customer_id') 
alter table payments drop CONSTRAINT fk_payment_customer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_review_customer_id') 
alter table reviews drop CONSTRAINT fk_review_customer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
where CONSTRAINT_NAME='fk_review_order_id') 
alter table reviews drop CONSTRAINT fk_review_order_id


drop table if exists customers
GO
drop table if exists cars
GO
drop table if exists locations
Go 
drop table if exists orders
GO
drop table if exists insurances
go 
drop table if EXISTS reviews
go
drop table if EXISTS payments
go


--up metadata


--create table
create table customers( 
customer_id int identity not null, 
customer_firstname varchar(20) not null, 
customer_lastname varchar(20) not null, 
customer_username varchar(30) not null, 
customer_phone varchar(10) not null, 
customer_email varchar(50) NOT null,
customer_address varchar(50) not null, 
customer_drilic varchar(20) not null, 
constraint pk_customers_customer_id PRIMARY KEY(customer_id),
CONSTRAINT u_customer_email UNIQUE(customer_email), 
CONSTRAINT u_customer_drilic UNIQUE(customer_drilic), 
constraint u_customer_username UNIQUE(customer_username)
) 
GO

create table locations(
location_id int identity not null,
location_state VARCHAR(50) not null,
location_city VARCHAR(50) not null,
location_street VARCHAR(50) not null,
location_zip int not null,
constraint pk_locations_location_id PRIMARY KEY(location_id)
)
go 


create table cars( 
car_id int identity not null, 
car_brand varchar(50) not null, 
car_model varchar(50) not null, 
car_color varchar(50) not null, 
car_year varchar(50) not null,
car_mileage int not null,
car_category VARCHAR(50) not null,
car_price money not null,
car_license_plate VARCHAR(50) not null,
car_location_id INT not null
constraint pk_cars_car_id PRIMARY KEY(car_id),
CONSTRAINT u_car_license_plate UNIQUE(car_license_plate)
) 
alter table cars add
CONSTRAINT fk_car_location_id FOREIGN key(car_location_id) REFERENCES locations(location_id) 
GO


create table payments( 
payment_id int identity not null,
payment_account varchar(50) not null, 
payment_type varchar(50) not null, 
payment_date datetime not null,
payment_customer_id int not NULL
constraint pk_payment_id PRIMARY KEY(payment_id),
constraint u_payment_account unique(payment_account)
)
alter table payments add
CONSTRAINT fk_payment_customer_id FOREIGN key(payment_customer_id) REFERENCES customers(customer_id) 
GO


create table orders( 
order_id int identity not null, 
order_start_date datetime not null,
order_end_date datetime not null,
order_cost money null,
order_is_complete int null,
order_customer_id int null,
order_payment_id int not null,
order_car_id int not null,
order_pickup_location_id int not null,
order_return_location_id int not null
constraint pk_orders_order_id PRIMARY KEY(order_id),
constraint ck_orders_start_end_date check(order_start_date < order_end_date)
)
alter table orders add
CONSTRAINT fk_order_customer_id FOREIGN key(order_customer_id) REFERENCES customers(customer_id), 
CONSTRAINT fk_order_payment_id FOREIGN key(order_payment_id) REFERENCES payments(payment_id),
CONSTRAINT fk_order_car_id FOREIGN key(order_car_id) REFERENCES cars(car_id),
CONSTRAINT fk_order_pickup_location_id FOREIGN key(order_pickup_location_id) REFERENCES locations(location_id),
CONSTRAINT fk_order_return_location_id FOREIGN key(order_return_location_id) REFERENCES locations(location_id)
GO


create table insurances(
insurance_id int identity not null,
insurance_company varchar(50) not null,
insurance_number varchar(50) not null,
insurance_effective_date datetime not null,
insurance_expiration_date datetime not null,
insurance_bill money null,
insurance_description varchar(150) null,
insurance_car_id int not null,
constraint pk_insurances_insurance_id PRIMARY KEY(insurance_id),
CONSTRAINT u_insurance_number UNIQUE(insurance_number)
)
alter table insurances add
CONSTRAINT fk_insurance_car_id FOREIGN key(insurance_car_id) REFERENCES cars(car_id) 
GO


create table reviews( 
review_id int identity not null, 
review_rating int not null,
review_comment varchar(500) null,
review_customer_id int not null,
review_order_id int not null,
constraint pk_reviews_review_id PRIMARY KEY(review_id), 
CONSTRAINT u_review_order_id UNIQUE(review_order_id), 
constraint ck_review_rating check(review_rating>=0 and review_rating<=10)
)
alter table reviews add
CONSTRAINT fk_review_customer_id FOREIGN key(review_customer_id) REFERENCES customers(customer_id), 
CONSTRAINT fk_review_order_id FOREIGN key(review_order_id) REFERENCES orders(order_id) 
GO

--INSERT
--insert
insert into customers(customer_firstname, customer_lastname, customer_username, customer_phone, customer_email, customer_address, customer_drilic) VALUES 
('Yaping','Wang','ashley74747','6803560103','ywa380@syr.edu','150 Hnery street, Syracuse, NY','475647564'), 
('Zhiyu','Lin','jerry27364','3156409303','zlinhh19@syr.edu','919 e genesse street, Syracuse, NY','746754983'), 
('Kevin','Hsu','kk808','3155678990','zkuang34@syr.edu','300 University Avenue, Syracuse, NY','122156780'),
('Hans','Duan','hd7233','2608987334','hans25@gmail.com','234 marry street, Brooklyn, NY','383847365'),
('Ben','Wang','ben0810','3428847564','ben0810@gmail.com','345 real street, Brooklyn, NY','399876283'),
('Eric','Tien','eric0000','4532887364','ericyaa@gmail.com','333 wass street, Brooklyn, NY','485938475'),
('David','Lin','david888','9368734637','david666@gmail.com','666 hey street, Brooklyn, NY','334564578')
GO 
select * from customers 
GO


insert into locations(location_state,location_city,location_street,location_zip) VALUES
('NY','Syracuse','150 henry street','13210'),
('NY','Brooklyn','374 tree street','14203'),
('NY','Syracuse','767 layy street','14545'),
('NY','Queens','232 hype street','13234'),
('LA','Irvine','888 jump street','17878'),
('LA','Irvine','676 papa street','17465'),
('NY','Brooklyn','554 wee street','16454'),
('NY','Syracuse','787 mama street','13667'),
('NY','Queens','165 what street','13255'),
('LA','Irvine','165 lowkey street','17666')
Go
select * from locations
GO


insert into cars(car_brand,car_model,car_color,car_year,car_mileage,car_category,car_price,car_license_plate,car_location_id) VALUES
('Toyota','corolla','red','2015','5000','SUV','100','2345SU','1'),
('Toyota','sienna','black','2018','15030','standard','80','8766MP','1'),
('Toyota','corolla','black','2019','12635','compact','110','7763AA','3'),
('Toyota','camry','white','2015','8373','standard','110','7766EE','2'), 
('Toyota','camry','grey','2016','8767','standard','100','7657AH','2'),
('Audi','A5','grey','2017','10787','coupe','180','1651BA','1'),
('Audi','A5','black','2019','10219','coupe','190','6652CH','1'),
('Ford','mustang','black','2017','13343','coupe','140','7767MM','4'),
('Ford','mustang','white','2019','9890','coupe','160','5556AM','5'),
('Kia','rio','white','2019','9890','economy','95','6676CM','5'),
('Kia','rio','white','2018','13420','standard','80','5554YU','2'),
('Honda','odyssey','black','2018','14532','minivan','150','7788UU','3'),
('Honda','odyssey','black','2018','12230','minivan','165','6363HE','2'),
('Honda','odyssey','white','2016','16670','minivan','130','6119QP','2'),
('Honda','odyssey','white','2016','14930','minivan','140','9079WW','4') 
Go
select * from cars
GO

insert into payments(payment_account,payment_type,payment_date,payment_customer_id) VALUES
('4047890767899980','credit card','2022/01/06','5'),
('4510747387512563','credit card','2022/03/11','2'),
('6184766215561894','credit card','2022/03/09','3'),
('3806412935594473','credit card','2022/03/03','4'),
('8536210303723188','debit card','2022/03/22','5'),
('4500846096740233','debit card','2022/04/01','6'),
('4940633840876030','debit card','2022/04/13','7'),
('5858064301120099','debit card','2022/04/15','1'),
('9311467986236172','debit card','2022/02/18','1'),
('6638024357201131','debit card','2022/03/25','3')
Go
select * from payments
GO


insert into orders(order_start_date, order_end_date,order_cost,order_is_complete,order_customer_id,order_payment_id,order_car_id,order_pickup_location_id,order_return_location_id) VALUES
('2022/01/06','2022/01/09','325','1','5','1','1','1','3'),
('2022/03/11','2022/03/13','160','1','2','2','2','2','3'),
('2022/03/09','2022/03/10','110','1','3','3','3','5','4'),
('2022/03/03','2022/03/05','220','1','4','4','4','3','3'),
('2022/03/22','2022/03/24','200','1','5','5','5','2','1'),
('2022/04/01','2022/04/03','360','1','6','6','6','3','5'),
('2022/04/13','2022/04/14','190','1','7','7','7','5','4'),
('2022/04/15','2022/04/17','280','1','1','8','8','2','2'),
('2022/02/18','2022/02/20','320','1','3','9','9','4','1'),
('2022/03/25','2022/03/27','190','1','1','10','10','3','5')

Go
select * from orders
GO

insert into insurances(insurance_company,insurance_number,insurance_effective_date,insurance_expiration_date,insurance_bill,insurance_description,insurance_car_id) VALUES
('Allstate', '12345678910','2021/9/1','2022/9/30','790','null','1'),
('Allstate', '3808115257','2021/9/1','2022/9/30','990','null','2'),
('Allstate', '3563727780','2021/9/1','2022/9/30','990','null','3'),
('Allstate', '3436939330','2021/9/1','2022/9/30','990','null','4'),
('Allstate', '8155412201','2021/9/1','2022/9/30','990','null','5'),
('Allstate', '7669697680','2021/9/1','2022/9/30','2000','null','6'),
('Allstate', '1351660973','2021/9/1','2022/9/30','2000','null','7'),
('Allstate', '0880998988','2021/9/1','2022/9/30','1290','null','8'),
('Allstate', '9917504925','2021/9/1','2022/9/30','1290','null','9'),
('Allstate', '1677189927','2021/9/1','2022/9/30','1290','null','10'),
('Allstate', '1780336094','2021/9/1','2022/9/30','1290','null','11'),
('Allstate', '7571425976','2021/9/1','2022/9/30','1390','null','12'),
('Allstate', '3841513015','2021/9/1','2022/9/30','1390','null','13'),
('Allstate', '8516031393','2021/9/1','2022/9/30','1390','null','14'),
('Allstate', '3537629343','2021/9/1','2022/9/30','1390','null','15')
GO
select * from insurances
GO


insert into reviews(review_rating,review_comment,review_customer_id,review_order_id) VALUES
('10','very clean,pretty good experience','5','1'),
('9','clean, great car condition','2','2'),
('9','awesome smell on the car','3','3'),
('8','Everything is fine and clean','4','4'),
('10','Perfect car and services, can’t ask for more','5','5'),
('8','Great car but the price are a bit high','6','6'),
('10','the car is pretty new and the services they provide are perfect','7','7'),
('9','Great car, good experience','1','8'),
('10','The car is really new, totally worth the price','7','9'),
('10','Great car, great people! Highly recommend!','7','10')
GO
select * from reviews
GO

