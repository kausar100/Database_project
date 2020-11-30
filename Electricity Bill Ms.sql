--START PAGE
 @"E:\3rd year 1st semester\CSE 3110 database lab\1607100\Electricity Bill Ms(Background).sql";
SET SERVEROUTPUT ON;

--LOGIN/REGISTRATION PAGE
BEGIN
	DBMS_OUTPUT.PUT_LINE(chr(10));
	DBMS_OUTPUT.PUT_LINE('ENTER 1 FOR LOGIN');
	DBMS_OUTPUT.PUT_LINE('ENTER 2 FOR REGISTRATION');
END;
/

DECLARE
choice int;
user Admin.username%TYPE;
pass Admin.password%TYPE;
BEGIN

	choice := &choice;	
	user := '&userName';
	pass := '&passWord';
	IF choice=1 THEN	
		LOGIN_CONFIRMATION(user, pass);
	ELSE
		REGISTRATION_CONFIRMATION(user, pass);
	END IF;
END;
/


BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('INSERT NEW_CONSUMER_INFO');
END;
/

DECLARE	
	fName Consumer.first_name%type;
	lName Consumer.last_name%type;	
	phone Address.contact_no%type;
	rd_no Address.road_no%type;
	hs_no Address.house_no%type;
	ps_code Address.postal_code%type;
	
BEGIN
	fName := '&First_name';
	lName := '&Last_name';	
	phone := &Contact_no;
	rd_no := &Road_no;
	hs_no := &House_no;
	ps_code := &Postal_code;
	NEW_CONSUMER_INFO(fName,lName,phone,rd_no,hs_no,ps_code);		
END;
/
select * from consumer;
select * from address;

BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('INSERT NEW_CONSUMER_INFO');

END;
/
--bill payment info
select * from meter_details;
DECLARE
	mt_no  Meter_details.meter_no%TYPE;
BEGIN
	mt_no  := &meter_no;	
	BILL_PAYMENT_INFO(mt_no);
END;
/
select * from payment;
select * from receipt;

--SHOW SPECIFIC TABLE
BEGIN
	DBMS_OUTPUT.PUT_LINE(chr(10));
	DBMS_OUTPUT.PUT_LINE('ENTER 1 FOR VIEW METER_DETAILS TABLE DATA');
	DBMS_OUTPUT.PUT_LINE('ENTER 2 FOR VIEW CONSUMER TABLE DATA');
	DBMS_OUTPUT.PUT_LINE('ENTER 3 FOR VIEW ADDRESS TABLE DATA');
	DBMS_OUTPUT.PUT_LINE('ENTER 4 FOR VIEW PAYMENT TABLE DATA');
	DBMS_OUTPUT.PUT_LINE('ENTER 5 FOR VIEW RECEIPT TABLE DATA');
END;
/

DECLARE
ch int;
BEGIN
	ch := &choice;
	IF ch=1 THEN
		SHOW_METER_INFO;
		
	ELSIF ch=2 THEN
		SHOW_CONSUMER_INFO;

	ELSIF ch=3 THEN
		SHOW_ADDRESS_INFO;
		
	ELSIF ch=4 THEN
		SHOW_PAYMENT_INFO;
		
	ELSIF ch=5 THEN
		SHOW_RECEIPT_INFO;
	END IF;
END;
/

--UPDATE ADMIN TABLE
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('UPDATE ADMIN TABLE DATA');
END;
/

select username from Admin;
DECLARE
	ch int;
	usr Admin.username%type;
	old_pass Admin.password%type;
	new_pass Admin.password%type;
BEGIN
	usr :='&userName';
	old_pass :='&old_passWord';
	new_pass :='&new_passWord';	
	UPDATE_ADMIN_INFO(usr,old_pass,new_pass);
END;
/


--UPDATE METER_DETAILS TABLE
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('UPDATE METER_DETAILS TABLE DATA');
END;
/

select meter_no from meter_details;
DECLARE
	mt_no Meter_details.meter_no%TYPE;
	con_unit Meter_details.consume_unit%TYPE;
BEGIN
	mt_no := &Meter_no;
	con_unit := &Consume_unit;
	UPDATE_METER_INFO(mt_no,con_unit);
	NEW_BILL_INFO(mt_no,con_unit);
END;
/
SELECT * from meter_details;
SELECT * from payment;
SELECT * from receipt;

--UPDATE ADDRESS TABLE
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('UPDATE ADDRESS TABLE DATA');
END;
/
select add_id from address;
DECLARE
	add_id Address.add_id%TYPE;
	contact_no Address.contact_no%TYPE;
	road_no Address.road_no%TYPE;
	house_no Address.house_no%TYPE;
	postal_code Address.postal_code%TYPE;

BEGIN
	add_id := &add_id;
	contact_no := &Contact_no;
	road_no := &Road_no;
	house_no := &House_no;
	postal_code := &Postal_code;
	UPDATE_ADDRESS_INFO(add_id,contact_no,road_no,house_no,postal_code);
END;
/
select * from address;


--checking if fine exist or not
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('CHECKING IF FINE EXIST OR NOT...');
END;
/
select meter_no from meter_details;
DECLARE
mt_no Payment.meter_no%TYPE;
con_id Payment.consumer_id%TYPE;
BEGIN
		mt_no := &Meter_no;
		select consumer_id into con_id from Payment where meter_no=mt_no;
		IS_FINE(con_id);

END;
/

--SHOW CONSUMER PERSONAL INFORMATION
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('SHOW CONSUMER PERSONAL INFORMATION...');
END;
/
select con.first_name,con.meter_no,ad.contact_no,ad.road_no, ad.house_no, ad.postal_code
from Consumer con JOIN address ad
using (add_id);


--some aggregate function example
select COUNT(*) as number_of_meter from meter_details;
select MAX(consume_unit) as maximum_consume_unit from meter_details;
select avg(consume_unit) as average_consume_unit from meter_details;

--show no_of_meter for same consume_unit
select  count(meter_no) as no_of_meter,consume_unit  from meter_details
where meter_no > 0
group by consume_unit;


