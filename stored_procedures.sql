insert into customer (ssn,name,phone,email,age) values("SSN58534","Arun","2323232","da@j.com",12);
insert into hotel (name,street,town,state,zip,avgrating,phone,email) values 
("Hotel Plaza","Symphony Street","Truro","MA","02115",0,"+1 656-334-6296","plaza@hmz.com");
drop procedure if exists getUserBySSN;
delimiter //
create procedure getUserBySSN(
	in ssnI varchar(45) )
	begin
		select * from customer where ssn =ssnI;
    end //
delimiter ;
call getUserBySSN("SSN58534");

drop procedure if exists createUser;
delimiter //
create procedure createUser(
	in ssnI varchar(45) ,
    in nameI varchar(45) ,
    in phoneI varchar(45) ,
    in emailI varchar(45) ,
	in ageI int 
    )
	begin
		insert into customer (ssn,name,phone,email,age) values(ssnI,nameI,phoneI,emailI,ageI);
    end //
delimiter ;


