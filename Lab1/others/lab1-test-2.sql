use lab1;
# select * from Book;

drop procedure if exists test_updateID;

delimiter //
create procedure test_updateID(ID_prev char(8), ID_new char(8))
BEGIN
    declare state int default 0;
    declare cs_BookID char(8);
    declare cs_ReaderID char(8);
    declare cs_BorrowDate date;
    declare cs_ReturnDate date;
    declare cs_BookName varchar(20);
    declare cs_BookAuthor varchar(10);
    declare cs_BookPrice float;
    declare cs_BookStatus int;

    declare cs_borrow Cursor 
    For select Book_ID, Reader_ID, Borrow_Date, Return_Date 
    from Borrow where Book_ID=ID_prev;
    
	Open cs_borrow;
	Repeat
		Fetch cs_borrow Into cs_BookID, cs_ReaderID, cs_BorrowDate, cs_ReturnDate;
        delete from Borrow 
        where 
			Book_ID=ID_prev
			and cs_BookID=Book_ID 
			and cs_ReaderID=Reader_ID 
			and cs_BorrowDate=Borrow_Date 
            and cs_ReturnDate=Return_Date;
        Insert into Borrow(Book_ID,Reader_ID,Borrow_Date,Return_Date)
        value (ID_new, cs_ReaderID, cs_BorrowDate, cs_ReturnDate);
		Until state=1
	End Repeat;
    close cs_borrow;
END;
//

select * from Borrow;
call test_updateID('b6','b99');

select * from Borrow;