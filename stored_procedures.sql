insert into customer (ssn,name,phone,email,age) values("SSN58534","Arun","2323232","da@j.com",12);
insert into hotel (name,street,town,state,zip,avgrating,phone,email) values
("Hotel Plaza","Symphony Street","Truro","MA","02115",0,"+1 656-334-6296","plaza@hmz.com");
insert into hotel (name,street,town,state,zip,avgrating,phone,email) values
("Hotel Banquet","Harrison Street","Truro","MA","02115",0,"+1 616-334-6296","banquet@hmz.com");

insert into roomcategory (category,hasFridge,hasBalcony,hasBathtub,description) values
("Deluxe",true,false,false,"Enjoy Deluxe previlige, clean rooms with built in fridge");
insert into roomcategory (category,hasFridge,hasBalcony,hasBathtub,description) values
("Ultra",true,true,false,"Enjoy Ultra previlige, clean rooms with a balcony and built in fridge!");
insert into roomcategory (category,hasFridge,hasBalcony,hasBathtub,description) values
("Suite",true,true,true,"Enjoy our best Suite previlige, clean rooms with  a balcony, bathtub and built in fridge");

insert into rooms (roomno,hotelid,category,floor,capacity) values (1,1,"Deluxe",1,3);
insert into rooms (roomno,hotelid,category,floor,capacity) values (2,1,"Deluxe",1,3);
insert into rooms (roomno,hotelid,category,floor,capacity) values (3,1,"Deluxe",1,3);
insert into rooms (roomno,hotelid,category,floor,capacity) values (4,1,"Deluxe",1,3);

insert into rooms (roomno,hotelid,category,floor,capacity) values (5,1,"Ultra",1,4);
insert into rooms (roomno,hotelid,category,floor,capacity) values (6,1,"Ultra",1,4);
insert into rooms (roomno,hotelid,category,floor,capacity) values (7,1,"Ultra",1,4);

insert into rooms (roomno,hotelid,category,floor,capacity) values (8,2,"Ultra",1,4);
insert into rooms (roomno,hotelid,category,floor,capacity) values (9,2,"Ultra",1,4);
insert into rooms (roomno,hotelid,category,floor,capacity) values (10,2,"Ultra",1,4);

insert into rooms (roomno,hotelid,category,floor,capacity) values (11,2,"Suite",2,4);
insert into rooms (roomno,hotelid,category,floor,capacity) values (12,2,"Suite",2,4);
insert into rooms (roomno,hotelid,category,floor,capacity) values (13,2,"Suite",2,4);

insert into amenities (name ,description) values ("Swimming pool","Exquisite swimming pool");
insert into amenities (name ,description) values ("Heating","Heating available 24*7");
insert into amenities (name ,description) values ("Bar","In house bar!");
insert into amenities (name ,description) values ("Dining","Best room service!");
-- set foreign_key_checks=0;


insert into amenitiesathotel (hotelid,amenityId) values (1,1);
insert into amenitiesathotel (hotelid,amenityId) values (1,2);
insert into amenitiesathotel (hotelid,amenityId) values (1,3);
insert into amenitiesathotel (hotelid,amenityId) values (1,4);
insert into amenitiesathotel (hotelid,amenityId) values (2,1);
insert into amenitiesathotel (hotelid,amenityId) values (2,3);

drop table amenitiesathotel;

select * from hotel;
select * from amenities;



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


drop procedure if exists getAvailableHotels;
delimiter //
create procedure getAvailableHotels(
		in  dateInput date
    )
	begin
	select hotel.id,hotel.name,hotel.phone,hotel.email,street,town,state,getTotalRoomsAvailableForHotel(hotel.id,dateInput) as totalAvailableRooms,
    zip,avgrating,group_concat(amenities.name) as amenities,group_concat(amenities.description) as amenitiesDescription from hotel
        inner join amenitiesathotel on hotel.id=amenitiesathotel.hotelid
        inner join amenities on amenities.id=amenitiesathotel.amenityid
        group by hotel.id,hotel.name,hotel.phone,hotel.email,street,town,state,zip,avgrating;
    end //
delimiter ;
call getAvailableHotels(CURDATE());



drop procedure if exists getHotelCategoryWiseAvailability;
delimiter //
create procedure getHotelCategoryWiseAvailability(in hotelIdInput int,in reqStartDate date,in reqEndDate date)
	begin
		if(datediff(reqEndDate,reqStartDate)< 1 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Enter days atleast 1 day apart';
       end if;
       
		select hotel.id ,category as roomCategory,(count(roomno) -
		(select count(*) from booking inner join rooms using(roomNo) where hotel=hotelIdInput 
        and (
        reqStartDate between startDate and endDate
			or
		reqEndDate between startDate and endDate   
        )
        
        and rooms.category=roomCategory))
		as availableRooms
		from hotel inner join rooms on hotel.id = rooms.hotelid
		where hotel.id=hotelIdInput group by hotel.id,category;
    end //
delimiter ;
call getHotelCategoryWiseAvailability(1,CURDATE(),CURDATE() + INTERVAL 1 DAY);

drop function if exists getTotalRoomsAvailableForHotel;
delimiter //
create function getTotalRoomsAvailableForHotel(
	hotelIdInput int,dateInput date)
	returns int
    deterministic reads sql data
	begin
		declare totalAvailableRooms int default 0;
		select  sum(availableRooms) into totalAvailableRooms  from
		(	select hotel.id ,category as roomCategory,(count(roomno) -
		(select count(*) from booking inner join rooms using(roomNo) where hotel=hotelIdInput 
        and dateInput between startDate and endDate
        and rooms.category=roomCategory))
		as availableRooms
		from hotel inner join rooms on hotel.id = rooms.hotelid
		where hotel.id=hotelIdInput group by hotel.id,category) as t;
        return totalAvailableRooms;
    end //
delimiter ;

select getTotalRoomsAvailableForHotel(1,CURDATE());





drop procedure if exists createBooking;
delimiter //
create procedure createBooking(
in hotelIdInput int,
in customerIdInput int,
in startDateInput date,
in endDateInput date,
in roomCategory char(50),
in roomNoInput int
)
	begin
    -- check if room no and hotel id is valid
	
	   declare countOfRoomsWithGivenInfo int default 0;
	   declare bookingsCountOfRoomNoWithinStartAndEndDate int default 0;
	   declare availableRoomNo int default roomNoInput;
       
       if(datediff(endDateInput,startDateInput)< 1 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'You have to book a room for atleast a day';
       end if;
       
        if(roomNoInput is not null) then -- check for other bookings of the same room if booking is to be made for a specific room
			
			select count(*) into countOfRoomsWithGivenInfo  from rooms
			inner join hotel on hotel.id=rooms.hotelid where hotelid=hotelIdInput and roomno=roomNoINput;
			
			if (countOfRoomsWithGivenInfo !=1) then
					SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Hotel and room id combination is invalid';
			end if;

			select count(*) into bookingsCountOfRoomNoWithinStartAndEndDate from booking where (endDate between
			startDateInput and endDateInput or startDate between startDateInput and endDateInput)
            and hotel=hotelIdInput and roomNo=roomNoInput;
			if(bookingsCountOfRoomNoWithinStartAndEndDate!=0) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Room already booked in the requested date frame';
			end if;
        else -- choise first available room, if a specific room was not requested by the function call
			select roomNo into availableRoomNo from rooms where rooms.hotelid=hotelIdInput and rooms.category=roomCategory and not exists(
            select * from booking where roomNo=rooms.roomNo and (endDate between
			startDateInput and endDateInput or startDate between startDateInput and endDateInput)
            ) limit 1;
            
            if(availableRoomNo is null) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'No room is found, please try again';
            end if;
	
		end if;

        
		insert into booking (customer,hotel,startDate,endDate,roomNo) values (customerIdInput,hotelIdInput,startDateInput,endDateInput,availableRoomNo);
    end //
delimiter ;
-- select * from booking;
-- truncate table booking;
call createBooking(1,1,curdate(),curdate()+ INTERVAL 1 DAY,null,1);
call createBooking(1,1,curdate(),curdate()+ INTERVAL 1 DAY,"Deluxe",null);

