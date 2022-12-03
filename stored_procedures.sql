use final_project;
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




select curdate();
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
           
       if(datediff(startDateInput, curdate())< 0 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking has to be made in future or for today';
       end if;
       
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
        select bookingId from booking where customer=customerIdInput and hotel=hotelIdInput and startDate=startDateInput
        and endDate=endDateInput and roomNo=availableRoomNo;
    end //
delimiter ;
-- select * from booking;
-- truncate table booking;
call createBooking(1,1,curdate()-2,curdate()+ INTERVAL 1 DAY,"Deluxe",null);

call createBooking(1,1,curdate(),curdate()+ INTERVAL 1 DAY,null,1);
call createBooking(1,1,curdate(),curdate()+ INTERVAL 1 DAY,"Deluxe",null);


drop procedure if exists getUserBookings;
delimiter //
create procedure getUserBookings(in customerId int)
	begin
		select * from booking  inner join hotel on hotel.id = booking.hotel where customer=customerId;
    end //
delimiter ;
call getUserBookings(1);



drop procedure if exists addOccupantToBooking;
delimiter //
create procedure addOccupantToBooking(
	in bookingIdInput int,
	in ssnI varchar(45) , 
    in nameI varchar(45) ,
    in ageI int)
	begin
    declare bookedRoomCapacity int default 0;
	declare currentNumberOfOccupants int default 0;
    declare occupantSSNExists varchar(45) default null;
	declare exit handler for SQLEXCEPTION  
    begin
		rollback;
        SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Unable to create occupant, rolling back transaction';
	end;
    select capacity into bookedRoomCapacity from booking inner join rooms on  booking.roomNo=rooms.roomno where bookingId=bookingIdInput;
    if(bookedRoomCapacity is null) then
		SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid booking id has been entered';
    end if;
	if(currentNumberOfOccupants = bookedRoomCapacity) then
		SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'No more occupants can be added to this room type';
	end if;
    
    start transaction;
		select ssn into occupantSSNExists from occupant where ssn=ssnI;
        if(occupantSSNExists is null) then
        		insert into occupant (ssn,name,age) values (ssnI,nameI,ageI);
        end if;
        insert into occupantsinorder (bookingId,occuppantSSN) values (bookingIdInput,ssnI);
    commit;
    end //
delimiter ;
call addOccupantToBooking(1,"SS2K","DF",5);

select * from customer;
truncate table booking;
select * from occupant;
select * from occupantsinorder;



drop procedure if exists getOccupantDetailsForBooking;
delimiter //
create procedure getOccupantDetailsForBooking(in bookingIdIn int)
	begin
		select * from occupantsinorder inner join occupant on occupant.ssn=occupantsinorder.occuppantSSN where bookingid=bookingIdIn;
    end //
delimiter ;
call getOccupantDetailsForBooking(4);


drop procedure if exists deleteBooking;
delimiter //
create procedure deleteBooking(in bookingIdIn int)
	begin
		declare isCheckedInVar int default 0;
	   declare isCheckedOurVar int default 0;
       declare bookingIdVar int default -1;
		
       select bookingId,isCheckedIn,isCheckedOut into bookingIdVar,isCheckedInVar, isCheckedOurVar from
       booking where bookingId=bookingIdIn;
       if(bookingIdVar = -1) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
       end if;
       if(isCheckedInVar or isCheckedOurVar) then
       SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking is checked in/out, cannot modify';
       end if;
		delete from booking where bookingId=bookingIdIn;
    end //
delimiter ;
select * from booking;

drop procedure if exists deleteOccupantFromBooking;
delimiter //
create procedure deleteOccupantFromBooking(in ssnI varchar(45),in bookingIdI int)
	begin
	declare occupantBookingCount int default 0;
	declare exit handler for SQLEXCEPTION  
	begin
		rollback;
        SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Unable to delete occupant from booking';
	end;
    start transaction;
		select count(*) into  occupantBookingCount from occupantsinorder where occuppantSSN=ssnI;
		delete from occupantsinorder where occuppantSSN=ssnI;
        if(occupantBookingCount = 0) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Occupant not found';
        end if;
        if (occupantBookingCount = 1) then
        		delete from occupant where ssn=ssnI;
        end if;
	commit;
    end //
delimiter ;
call deleteOccupantFromBooking("SSHK",1);

use final_project;
drop procedure if  exists updateBooking;
delimiter //
	create procedure updateBooking(
	in startDateInput date,
	in endDateInput date,
    in bookingIdInput int
	)
	begin
	   declare isCheckedInVar int default 0;
	   declare isCheckedOurVar int default 0;
	   declare roomNoBooked int default -1;
		declare bookingIdVar int default -1;
	   declare conflictingBookings int default -1;

       select bookingId,isCheckedIn,isCheckedOut,roomNo into bookingIdVar,isCheckedInVar, isCheckedOurVar,roomNoBooked from
       booking where bookingId=bookingIdInput;
       
       if(bookingIdVar = -1) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
       end if;
       
       select count(*) into conflictingBookings from booking where bookingId!=bookingIdInput
       and roomNo=roomNoBooked and ((startDate between startDateInput
       and endDateInput) or (endDate between startDateInput and endDateInput));
       
        if(conflictingBookings>0) then
       SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Sorry, room already booked for these dates';
       end if;
       
       if(isCheckedInVar or isCheckedOurVar) then
       SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking is checked in/out, cannot modify';
       end if;

       if(datediff(startDateInput, curdate())< 0 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking has to be made in future or for today';
       end if;
       
       if(datediff(endDateInput,startDateInput)< 1 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'You have to book a room for atleast a day';
       end if;
		update booking set startDate=startDateInput , endDate=endDateInput where bookingId=bookingIdInput;
	end//
delimiter ;
call updateBooking(curdate()+ INTERVAL 8 day,curdate()+ INTERVAL 9 DAY,8);


use final_project;
drop procedure if  exists addRatingForBooking;
delimiter //
	create procedure addRatingForBooking(
	in bookingIdInput int,
	in ratingInput float
	)
	begin
		
	   declare isCheckedOurVar int default -1;
       select isCheckedOut into  isCheckedOurVar from booking where bookingId=bookingIdInput;
       if(isCheckedOurVar=-1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
       end if;
		if(isCheckedOurVar=0) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking has to be in checked out status to mark rating';
       end if;
       if(ratingInput < 0 or ratingInput >5) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Rating has to be between 0 and 5';
       end if;
	update booking set rating=ratingInput where bookingId=bookingIdInput;
    end//
delimiter ;

call addRatingForBooking(11,4.5);




drop trigger if exists updateHotelAverageRating;
delimiter //
	create trigger	updateHotelAverageRating
    after update on booking
    for each row
	begin
		declare bookingRatedCount int default 0;
		declare totalRating float default 0;
		declare hotelIdVar int default -1;
        select new.hotel into hotelIdVar;
        select count(*) into bookingRatedCount from booking where rating is not null and hotel=hotelIdVar;
		select sum(rating) into totalRating from booking where rating is not null  and hotel=hotelIdVar group by hotel;
        if(bookingRatedCount!=0) then
        update hotel set avgrating=(totalRating/bookingRatedCount) where id=hotelIdVar;
        end if;
    end//
delimiter ;

drop trigger if exists bookingCreatedTrigger;
delimiter //
	create trigger	bookingCreatedTrigger
    after insert on booking
    for each row
	begin
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("BOOKING_CREATED",new.bookingId,new.customer,new.hotel,concat("roomNo:",new.roomNo));
    end//
delimiter ;
-- call createBooking(1,1,curdate(),curdate()+ INTERVAL 1 DAY,"Deluxe",null);



-- call updateBooking(curdate()+ INTERVAL 8 day,curdate()+ INTERVAL 9 DAY,1);

drop trigger if exists occupantCreatedTrigger;
delimiter //
	create trigger	occupantCreatedTrigger
    after insert on occupantsinorder
    for each row
	begin
		declare bookingIdVar int default 0;
        declare hotelIdVar int default 0;
		declare customerIdVar int default 0;
		declare occupantNameVar varchar(45) default null;
		declare occupantAgeVar int default 0;

		select booking.bookingId ,booking.hotel,booking.customer,occupant.age,occupant.name into hotelIdVar,bookingIdVar,customerIdVar,occupantAgeVar,occupantNameVar
        from booking inner join occupantsinorder using(bookingId) inner join occupant on occupant.ssn=occupantsinorder.occuppantSSN
        where occupant.ssn=new.occuppantSSN;
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("OCCUPANT_ADDED",bookingIdVar,customerIdVar,hotelIdVar,
        concat("{'occuppantSSN':",new.occuppantSSN,",","'occupantName':",occupantNameVar,",","'occupantAge':",occupantAgeVar,"}"));
    end//
delimiter ;
call addOccupantToBooking(1,"S221K","DF",1);

drop trigger if exists occupantDeletedTrigger;
delimiter //
	create trigger	occupantDeletedTrigger
    before delete on occupantsinorder
    for each row
	begin
		declare bookingIdVar int default 0;
        declare hotelIdVar int default 0;
		declare customerIdVar int default 0;
		declare occupantNameVar varchar(45) default null;
		declare occupantAgeVar int default 0;

		select booking.bookingId ,booking.hotel,booking.customer,occupant.age,occupant.name into hotelIdVar,bookingIdVar,customerIdVar,occupantAgeVar,occupantNameVar
        from booking inner join occupantsinorder using(bookingId) inner join occupant on occupant.ssn=occupantsinorder.occuppantSSN
        where occupant.ssn=old.occuppantSSN;
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("OCCUPANT_DELETED",bookingIdVar,customerIdVar,hotelIdVar,
        concat("{'occuppantSSN':",old.occuppantSSN,",","'occupantName':",occupantNameVar,",","'occupantAge':",occupantAgeVar,"}"));
    end//
delimiter ;
-- call deleteOccupantFromBooking("S221K",1);

drop trigger if exists bookingUpdatedTrigger;
delimiter //
	create trigger	bookingUpdatedTrigger
    after update on booking
    for each row
	begin
		if new.startDate != old.startDate or new.endDate != old.endDate then
			insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
			("BOOKING_UPDATED",new.bookingId,new.customer,new.hotel,
			concat("{'roomNo':",new.roomNo,",","'startDate':",new.startDate,",","'endDate':",new.endDate,"}"));
        end if;
    end//
delimiter ;

drop trigger if exists bookingCheckedInTrigger;
delimiter //
	create trigger	bookingCheckedInTrigger
    after update on booking
    for each row
	begin
    if(new.isCheckedIn = 1 and old.isCheckedIn = 0) then
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("CHECKED_IN",new.bookingId,new.customer,new.hotel,concat("roomNo:",new.roomNo));
	end if;
    end//
delimiter ;


drop trigger if exists bookingCheckedOutTrigger;
delimiter //
	create trigger	bookingCheckedOutTrigger
    after update on booking
    for each row
	begin
    if(new.isCheckedOut = 1 and old.isCheckedOut = 0) then
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("CHECKED_OUT",new.bookingId,new.customer,new.hotel,concat("roomNo:",new.roomNo));
	end if;
    end//
delimiter ;


drop procedure if exists checkinBooking;
delimiter //
create procedure checkinBooking(
	in bookingIdInput int,
    in staffIdInput int)
	begin
	   declare isCheckedInVar int default -1;
	   declare isCheckedOutVar int default -1;
       select isCheckedIn,isCheckedOut into isCheckedInVar,isCheckedOutVar from booking where bookingId = bookingIdInput;
       if( isCheckedInVar =-1 or isCheckedOutVar =-1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
       end if;
	  if( isCheckedInVar =1 or isCheckedOutVar =1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid action, booking already checked in/out';
       end if;
       update booking set isCheckedIn=1 ,checkedInByStaffId=staffIdInput where bookingId=bookingIdInput;
    end //
delimiter ;
call checkinBooking(1,1);


drop procedure if exists checkoutBooking;
delimiter //
create procedure checkoutBooking(
	in bookingIdInput int,
       in staffIdInput int)
	begin
	   declare isCheckedInVar int default -1;
	   declare isCheckedOutVar int default -1;
       select isCheckedIn,isCheckedOut into isCheckedInVar,isCheckedOutVar from booking where bookingId = bookingIdInput;
       if( isCheckedInVar =-1 or isCheckedOutVar =-1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
       end if;
	  if( isCheckedInVar !=1 ) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid action, booking is not checked in';
       end if;
       
		if( isCheckedOutVar =1 ) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid action, booking is already checked out';
       end if;
       
       update booking set isCheckedOut=1,checkedOutByStaffId=staffIdInput where bookingId=bookingIdInput;
    end //
delimiter ;
call checkoutBooking(1,2);


drop procedure if exists createStaff;
delimiter //
create procedure createStaff(
	in nameInput varchar(45),
    in phoneInput varchar(45),
    in emailInput varchar(45),
	in ssnInput varchar(45),
	in ismanagerInput tinyint,
    in contractStartDateInput date,
	in contractEndDateInput date,
	in hotelidInput int
    )
	begin
    insert into staff (name,phone,email,ssn,ismanager,contractstartdate,contractenddate,hotelid)
    values
    (nameInput,phoneInput,emailInput,ssnInput,ismanagerInput,contractStartDateInput,contractEndDateInput,hotelidInput);
    end //
delimiter ;
call createStaff("Arun","+1767-287-4851","arun@hms.coom","ssn13",0,null,null,1);
call createStaff("Ujwal","+1767-287-4851","arun@hms.coom","ssn14",1,null,null,1);
call createStaff("Mandeep","+1767-287-4851","arun@hms.coom","ssn15",1,null,null,1);
select * from staff;

drop procedure if exists getBookingsForHotel;
delimiter //
create procedure getBookingsForHotel(
    in hotelId_in int
    )
    begin
        select * from booking where hotel = hotelId_in;
    end //
delimiter ;

drop procedure if exists getStaffById;
delimiter //
create procedure getStaffById(
    in staffId_in int
    )
    begin
        select * from staff where staffid = staffId_in;
    end //
delimiter ;


drop procedure if exists deleteStaff;
delimiter //
create procedure deleteStaff(
	in managerIdInput int,
    in staffIdToDelete int
    )
	begin
	  declare managerHotelId int default -1;
	  declare staffHotelId int default -1;
	  select hotelid into managerHotelId from staff where staffid = managerIdInput;
	  select hotelid into staffHotelId from staff where staffid = staffIdToDelete;
      if(managerHotelId = -1) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid manager hotel id';
      end if;
	 if(staffHotelId = -1) then
		SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid staff hotel id';
      end if;
	if(managerHotelId != staffHotelId ) then
		SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Mismatch between staff and manager hotel id';
      end if;
	delete from staff where staffid=staffIdToDelete;
    end //
delimiter ;
call deleteStaff(5,11);
delete from staff where staffid=1;
call createStaff("Ram","+1767-287-4851","arun@hms.coom","ssn16",0,null,null,1);
select * from staff; 
select * from booking;
select * from customer;
select * from hotel;