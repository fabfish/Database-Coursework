use lab1;

drop procedure if exists updateBook_ID;

delimiter //
create procedure updateBook_ID(ID_prev char(8), ID_new char(8))
BEGIN
    declare state int default 0;
    declare cs_BookID char(8);
    declare cs_ReaderID char(8);
    declare cs_BorrowDate date;
    declare cs_ReturnDate date;
    declare BookName varchar(20);
    declare BookAuthor varchar(10);
    declare BookPrice float;
    declare BookStatus int;
#    declare cs_borrow cursor for select Book_ID, Reader_ID, Borrow_Date, Return_Date 
#		from Borrow where Book_ID=ID_prev;
#	DECLARE CONTINUE HANDLER FOR NOT FOUND SET state=1;

    select name, author, price, status 
		into BookName, BookAuthor, BookPrice, BookStatus
		from Book where ID=ID_prev;
	Insert into Book(ID, name, author, price, status)
		value (ID_new, BookName, BookAuthor, BookPrice, BookStatus);        
    
#	Open cs_borrow;
#	Repeat
#		Fetch cs_borrow Into cs_BookID, cs_ReaderID, cs_BorrowDate, cs_ReturnDate;
#		if cs_BookID=ID_prev then
#			select 1+1;
#			Insert into Borrow(Book_ID,Reader_ID,Borrow_Date,Return_Date)
#				value (ID_new, cs_ReaderID, cs_BorrowDate, cs_ReturnDate);
#		end if;
#		Until state=1
#	End Repeat;
#	close cs_borrow; 
    
    update Borrow set Book_ID= ID_new where Book_ID=ID_prev;
    delete from Book where ID=ID_prev;
END;
//
delimiter ;

call updateBook_ID('b6','b99');

