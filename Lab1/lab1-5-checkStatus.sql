use lab1;

drop function if exists checkStatus;

delimiter //
Create Function checkStatus()
RETURNS int
Reads SQL data
BEGIN
    declare state int default 0;
    declare is_out int default 0;
    declare count_fault int default 0;
    declare cs_BookID char(8);
    declare cs_Status int;
    declare cs_book cursor for select ID, status from Book;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET state=1;
    
	Open cs_book;
	Repeat
		Fetch cs_book Into cs_BookID, cs_Status;
        set is_out=(select count(*) from Borrow where Book_ID=cs_BookID and Return_Date is null);
        if (cs_Status=0 and not is_out=0) or (cs_Status=1 and is_out=0) then
			set count_fault=count_fault+1;
		end if;        
		Until state=1
	End Repeat;
	close cs_book; 
	Return count_fault;
END;
//
delimiter ;

select checkStatus();
drop trigger if exists updateStatus;
select * from Book;
insert into Borrow value('b10', 'r5', '2020-04-10', NULL);
select checkStatus();