use lab1;

drop procedure if exists updateBook_ID;

delimiter //
create procedure updateBook_ID(ID_prev char(8), ID_new char(8))
BEGIN
    declare state int default 0;
    declare BookName varchar(20);
    declare BookAuthor varchar(10);
    declare BookPrice float;
    declare BookStatus int;
	if ID_new in (select ID from Book) then
		set state=1;
	end if;
    select name, author, price, status 
		into BookName, BookAuthor, BookPrice, BookStatus
		from Book where ID=ID_prev;
	Insert into Book(ID, name, author, price, status)
		value (ID_new, BookName, BookAuthor, BookPrice, BookStatus);        
    update Borrow set Book_ID= ID_new where Book_ID=ID_prev;
    delete from Book where ID=ID_prev;
END;
//
delimiter ;

select * from Book;
select * from Borrow;
call updateBook_ID('b99','b6');
select * from Book;
select * from Borrow;

