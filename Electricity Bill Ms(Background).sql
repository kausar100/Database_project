drop table Admin;
drop table Receipt;
drop table Payment;
drop table Consumer;
drop table Address;
drop table Meter_details;



create table Admin(
    username varchar(20) NOT NULL,
    password varchar(10) NOT NULL ,
    PRIMARY KEY(username)
);



create table Meter_details(
    meter_no number NOT NULL,
    consume_unit number NOT NULL,
    PRIMARY KEY(meter_no)
);



create table Address(
    postal_code number NOT NULL,
    road_no number NOT NULL,
    contact_no number(11),
    house_no number NOT NULL,
    add_id number NOT NULL,
    PRIMARY KEY(add_id)
);



create table Consumer(
    consumer_id number NOT NULL,
    first_name varchar(20) NOT NULL,
    last_name varchar(20),
    add_id number NOT NULL,
    meter_no number NOT NULL,
    PRIMARY KEY(consumer_id),
    FOREIGN KEY(meter_no) REFERENCES Meter_details(meter_no) ON DELETE CASCADE,
    FOREIGN KEY(add_id) REFERENCES Address(add_id) ON DELETE CASCADE
);



create table Payment(
    consumer_id number NOT NULL,
    meter_no number NOT NULL,
    bill_amount number NOT NULL,
    payment_id number NOT NULL,
    payment_date date NOT NULL,
    PRIMARY KEY(payment_id),
    FOREIGN KEY(meter_no) REFERENCES Meter_details(meter_no) ON DELETE CASCADE,
    FOREIGN KEY(consumer_id) REFERENCES Consumer(consumer_id) ON DELETE CASCADE
);



create table Receipt(
    consumer_id number NOT NULL,
    Receipt_id number NOT NULL,
    vat_amount number NOT NULL,
    meter_no number NOT NULL,
    per_unit_cost number DEFAULT 10,
    bill_preparing_date date NOT NULL,
    bill_amount_without_fine number NOT NULL,
    bill_payment_date_without_fine date NOT NULL,
    bill_amount_with_fine number NOT NULL,
    bill_payment_date_with_fine date NOT NULL,
    PRIMARY KEY(Receipt_id ),
    FOREIGN KEY(meter_no) REFERENCES Meter_details(meter_no) ON DELETE CASCADE,
    FOREIGN KEY(consumer_id) REFERENCES Consumer(consumer_id) ON DELETE CASCADE
);


--LOGIN CONFIRMATION PROCEDURE
CREATE OR REPLACE PROCEDURE LOGIN_CONFIRMATION(user IN Admin.username%TYPE, pass IN Admin.password%TYPE) IS
    Temp int;      
BEGIN
	Select Count (*) Into Temp From Admin Where (username = user AND password = pass);

	IF(Temp = 1) THEN
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('CONGRATULATIONS LOG IN SUCCESSFUL !!!') ;
	ELSE
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('INVALID USERNAME OR PASSWORD !!!') ;
	END IF;
END ;
/


--REGISTRATION CONFIRMATION PROCEDURE
CREATE OR REPLACE PROCEDURE REGISTRATION_CONFIRMATION(user IN Admin.username%TYPE, pass IN Admin.password%TYPE) IS
      
BEGIN
	insert into admin values(user,pass);
	DBMS_OUTPUT.PUT_LINE(chr(10));
	DBMS_OUTPUT.PUT_LINE('REGISTRATION COMPLETED SUCCESSFUL');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA FOUND.');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('SOME UNKNOWN ERROR OCCURRED.');
END;
/



--show meter info
CREATE OR REPLACE PROCEDURE SHOW_METER_INFO IS
	
BEGIN
	FOR mtd IN(SELECT * FROM Meter_details)
	LOOP
		DBMS_OUTPUT.PUT_LINE ('METER_NO : ' || mtd.meter_no ||'    '||'CONSUME_UNIT : ' || mtd.consume_unit);
		DBMS_OUTPUT.PUT_LINE(chr(10));
	END LOOP;
END;
/

--show consumer info
CREATE OR REPLACE PROCEDURE SHOW_CONSUMER_INFO IS
	
BEGIN
	FOR cd IN(SELECT * FROM Consumer)
	LOOP
		DBMS_OUTPUT.PUT_LINE ('CONSUMER_ID : '||cd.consumer_id||'    '||'FIRST NAME : '||cd.first_name||'    '||'LAST NAME : '||cd.last_name);
		DBMS_OUTPUT.PUT_LINE('ADD_ID : '||cd.add_id||'    '||'METER_NO : '||cd.meter_no);
		DBMS_OUTPUT.PUT_LINE(chr(10));	
	END LOOP;
END;
/

--show Address info
CREATE OR REPLACE PROCEDURE SHOW_ADDRESS_INFO IS
	
BEGIN
	FOR add_data IN(SELECT * FROM Address)
	LOOP
		DBMS_OUTPUT.PUT_LINE ('CONTACT_NO : '||add_data.contact_no||'    '||'ADD_ID : '||add_data.add_id||'    '||'HOUSE_NO : '||add_data.house_no);
		DBMS_OUTPUT.PUT_LINE('POSTAL_CODE : '||add_data.postal_code||'    '||'ROAD_NO : '||add_data.road_no);
		DBMS_OUTPUT.PUT_LINE(chr(10));
	END LOOP;
END;
/

--show Payment info
CREATE OR REPLACE PROCEDURE SHOW_PAYMENT_INFO IS
	
BEGIN
	FOR pd IN(SELECT * FROM Payment)
	LOOP
		DBMS_OUTPUT.PUT_LINE ('CONSUMER_ID : '||pd.consumer_id||'    '||'METER_NO : '||pd.meter_no||'    '||'BILL_AMOUNT : '||pd.bill_amount);
		DBMS_OUTPUT.PUT_LINE('PAYMENT_ID : '||pd.payment_id||'    '||'PAYMENT_DATE : '||pd.payment_date);
		DBMS_OUTPUT.PUT_LINE(chr(10));
	
	END LOOP;
END;
/

--show Receipt info
CREATE OR REPLACE PROCEDURE SHOW_RECEIPT_INFO IS
	
BEGIN
	FOR rd IN(SELECT * FROM Receipt)
	LOOP
		DBMS_OUTPUT.PUT_LINE ('CONSUMER_ID : '||rd.consumer_id||'    '||'RECEIPT_ID : '||rd.Receipt_id||'    '||'METER_NO : '||rd.meter_no);
		DBMS_OUTPUT.PUT_LINE ('BILL_PREPARING_DATE : '||rd.bill_preparing_date ||'    '||'VAT_AMOUNT : '||rd.vat_amount||'    '||'PER_UNIT_COST : '||rd.per_unit_cost);
		DBMS_OUTPUT.PUT_LINE ('BILL_AMOUNT_WITHOUT_FINE : '||rd.bill_amount_without_fine ||'    '||'BILL_PAYMENT_DATE_WITHOUT_FINE : '||rd.bill_payment_date_without_fine);
		DBMS_OUTPUT.PUT_LINE ('BILL_AMOUNT_WITH_FINE : '||rd.bill_amount_with_fine||'    '||'BILL_PAYMENT_DATE_WITH_FINE : '||rd.bill_payment_date_with_fine);
		DBMS_OUTPUT.PUT_LINE(chr(10));
		
	END LOOP;
END;
/

--insert new consumer info
CREATE OR REPLACE PROCEDURE NEW_CONSUMER_INFO(fName IN Consumer.first_name%TYPE,lName IN Consumer.last_name%TYPE,phone IN Address.contact_no%TYPE,rd_no IN Address.road_no%TYPE,hs_no IN Address.house_no%TYPE,ps_code IN Address.postal_code%TYPE) IS	
	cnt number;
	mt_no  Meter_details.meter_no%TYPE;
	con_unit  Meter_details.consume_unit%TYPE;
	con_id Consumer.consumer_id%TYPE;
	add_id Address.add_id%type;
BEGIN
	select COUNT(*) into cnt from Meter_details;
	mt_no  := cnt+1;
	con_unit  := 0;
	select COUNT(*) into cnt from Consumer;
	con_id := cnt+1;
	select COUNT(*) into cnt from Address;
	add_id := cnt+1;
	
	insert into Meter_details values(mt_no,con_unit);
	insert into Address values(ps_code,rd_no,phone,hs_no,add_id);
	insert into Consumer values(con_id,fName,lName,add_id,mt_no);
	
	DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('NEW CONSUMER INFORMATION SUCCESSFULLY ADDED');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA FOUND.');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('SOME UNKNOWN ERROR OCCURRED.');	
END;
/

--bill payment info
CREATE OR REPLACE PROCEDURE BILL_PAYMENT_INFO(mt_no IN Meter_details.meter_no%TYPE) IS
	con_unit  Meter_details.consume_unit%TYPE;
	con_id  Consumer.consumer_id%TYPE;
	pay_id  Payment.payment_id%type;
	rs_id  Receipt.Receipt_id%type;
	ba Payment.bill_amount%type;
	pay_date Payment.payment_date%type;
	vat_amt Receipt.vat_amount%type;	
	puc Receipt.per_unit_cost%type;	
	bpred Receipt.bill_preparing_date%type;	
	bawoutf Receipt.bill_amount_without_fine%type;	
	bpdwoutf Receipt.bill_payment_date_without_fine%type;	
	bawf Receipt.bill_amount_with_fine%type;	
	bpdwf Receipt.bill_payment_date_with_fine%type;	
	lst_day date;
	cnt number;
	
BEGIN
	select consume_unit into con_unit from Meter_details
	where meter_no=mt_no;
	
	select consumer_id into con_id from Consumer
	where meter_no=mt_no;
	
	select COUNT(*) into cnt from Payment;
	pay_id  := cnt+1;
	
	select COUNT(*) into cnt from Receipt;
	rs_id  := cnt+1;
	
	
	ba := (con_unit*10);
	
	if(ba>500) then
		vat_amt := ba/10;
		bawoutf := (vat_amt+ba);
	else
		vat_amt := ba/5;
		bawoutf := (vat_amt+ba);
	end if;

	
	ba := bawoutf;
	puc := 10; 
	select sysdate into pay_date from dual;
	select last_day(sysdate) into lst_day from dual;
	bpred := lst_day-26;
	bpdwoutf := lst_day-10;
	bpdwf := lst_day-2;
	
	if(ba>500) then
		bawf := (ba+100);
	else
		bawf := (ba+50);
	end if;
	
	if con_unit=0 then
		ba := 0;
		vat_amt := 0;
		bawoutf := 0;
		bawf := 0;
	end if;
	
	insert into Payment values(con_id,mt_no,ba,pay_id,pay_date); 	
	insert into Receipt values(con_id,rs_id,vat_amt,mt_no,puc,bpred,bawoutf,bpdwoutf,bawf,bpdwf);

	DBMS_OUTPUT.PUT_LINE(chr(10));
	DBMS_OUTPUT.PUT_LINE('NEW CONSUMER INFORMATION SUCCESSFULLY ADDED');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA FOUND.');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('SOME UNKNOWN ERROR OCCURRED.');	
END;
/	

--update admin info
CREATE OR REPLACE PROCEDURE UPDATE_ADMIN_INFO(usern IN Admin.username%type,old_pass IN Admin.password%type,new_pass IN Admin.password%type)IS
	cnt number;
BEGIN
	select COUNT(*) into cnt from Admin where username=usern and password=old_pass;
	IF cnt=1 THEN
		UPDATE Admin SET password=new_pass where username=usern;
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('PASSWORD SUCCESSFULLY CHANGED..');
	ELSE
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('USER USERNAME OR PASSWORD INVALID');
	END IF;
END;
/


--update meter info
CREATE OR REPLACE PROCEDURE UPDATE_METER_INFO(mt_no IN Meter_details.meter_no%TYPE,con_unit IN Meter_details.consume_unit%TYPE)IS
	cnt number;
BEGIN
	select COUNT(*) into cnt from Meter_details where meter_no=mt_no;
	IF cnt=1 THEN
		UPDATE Meter_details SET consume_unit=con_unit where meter_no=mt_no;
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('CONSUME UNIT SUCCESSFULLY UPDATED..');
	ELSE
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('THESE METER NO DOES NOT EXIST...');
	END IF;
END;
/


--update Address info
CREATE OR REPLACE PROCEDURE UPDATE_ADDRESS_INFO(ad_id IN Address.add_id%TYPE,ph_no IN Address.contact_no%TYPE,rd_no IN Address.road_no%TYPE,hs_no IN Address.house_no%TYPE,ps_code IN Address.postal_code%TYPE)IS
	cnt number;
BEGIN
	select COUNT(*) into cnt from Address where add_id=ad_id;
	IF cnt=1 THEN
		UPDATE Address SET contact_no=ph_no, road_no=rd_no, house_no=hs_no, postal_code=ps_code where add_id=ad_id;
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('CONSUMER NEW ADDRESS INFORMATION SUCCESSFULLY UPDATED..');
	ELSE
		DBMS_OUTPUT.PUT_LINE(chr(10));
		DBMS_OUTPUT.PUT_LINE('THESE ADD ID DOES NOT EXIST...');
	END IF;
END;
/

--IS fine exist or not
CREATE OR REPLACE PROCEDURE IS_FINE(c_id in number) is
         P_D DATE;
         B_PD_WITHOUT_F  DATE;
      
  BEGIN
        SELECT PAYMENT_DATE INTO P_D FROM PAYMENT WHERE CONSUMER_ID=c_id;
          SELECT BILL_PAYMENT_DATE_WITHOUT_FINE INTO B_PD_WITHOUT_F FROM RECEIPT WHERE CONSUMER_ID=c_id;
  
        IF(B_PD_WITHOUT_F-P_D) >=0 THEN
  	 DBMS_OUTPUT.PUT_LINE('SUCCESSFULLY PAID');
       ELSE
   	DBMS_OUTPUT.PUT_LINE('YOU SHOULD PAY WITH FINE');
       END IF;
  END;
/


--Trigger
CREATE OR REPLACE TRIGGER admin_trig
AFTER INSERT
ON ADMIN 
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('NEW DATA ENTERED IN ADMIN TABLE');
END ;
/
CREATE OR REPLACE TRIGGER Meter_details_trig
AFTER INSERT
ON Meter_details
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('NEW DATA ENTERED IN METER_DETAILS TABLE');
END ;
/
CREATE OR REPLACE TRIGGER Address_trig
AFTER INSERT
ON Address
BEGIN
DBMS_OUTPUT.PUT_LINE(chr(10));
DBMS_OUTPUT.PUT_LINE('NEW DATA ENTERED IN ADDRESS TABLE');
END ;
/

--new bill info updated with consume_unit
CREATE OR REPLACE PROCEDURE NEW_BILL_INFO(mt_no IN Meter_details.meter_no%TYPE,con_unit IN Meter_details.consume_unit%TYPE) IS

	ba Payment.bill_amount%type;
	vat_amt Receipt.vat_amount%type;
	bawoutf Receipt.bill_amount_without_fine%type;
	bawf Receipt.bill_amount_without_fine%type;
BEGIN
	ba := (con_unit*10);
	if(ba>500) then
		vat_amt := ba/10;
		bawoutf := (vat_amt+ba);
	else
		vat_amt := ba/5;
		bawoutf := (vat_amt+ba);
	end if;
	
	ba := bawoutf;
	if(ba>500) then
		bawf := (ba+100);
	else
		bawf := (ba+50);
	end if;
	
	if con_unit=0 then
		ba := 0;
		vat_amt := 0;
		bawoutf := 0;
		bawf := 0;
	end if;
	
	update payment
	set bill_amount=ba
	where meter_no=mt_no;
	
	update receipt 
	set vat_amount = vat_amt
	where meter_no=mt_no;
	
	update receipt 
	set bill_amount_without_fine = bawoutf
	where meter_no=mt_no;

	update receipt
	set bill_amount_with_fine = bawf
	where meter_no=mt_no;

	DBMS_OUTPUT.PUT_LINE(chr(10));
	DBMS_OUTPUT.PUT_LINE('NEW BILL AMOUNT WITHOUT FINE AND WITH FINE UPDATED');
END ;
/