drop trigger if exists updateStatus;

delimiter //
Create Trigger updateStatus After insert ON Borrow
For Each Row
BEGIN
	if new.Return_date is null then
		update Book set status=1
        where ID = new.Book_ID and status = 0;
	else 
		update Book set status=0
        where ID = new.Book_ID and status = 1;
	end if;
END; //
delimiter ;

select * from Book;
insert into Borrow value('b10', 'r5', '2020-04-10', '2020-04-10');
select * from Book;