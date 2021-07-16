use lab1;

# 1
select ID, address from Reader
where name = "Rose";

# 2
select Book.name, Borrow.Borrow_Date 
from Book, Reader, Borrow
where Borrow.Reader_ID = Reader.ID 
	and Borrow.book_ID = Book.ID 
    and Reader.name = "Rose";

# 3
select Reader.name from Reader
where Reader.ID not in
(
	select Reader.ID 
    from Borrow, Reader
    where Borrow.Reader_ID = Reader.ID
);

# 4
select distinct Book.name, Book.price 
from Book
where author = "Ullman";

# 5
select Book.ID, Book.name from Book
where Book.ID in
(
	select Book.ID 
    from Borrow, Book, Reader
    where Borrow.book_ID = Book.ID 
		and Borrow.Reader_ID = Reader.ID 
        and Borrow.Return_Date is NULL 
        and Reader.name = "李林"
);

# 6
select Reader.name from Reader
where Reader.ID in
(
	select Reader.ID 
    from Borrow, Reader
	where Borrow.Reader_ID = Reader.ID
    group by Reader.ID
    having count(*) > 3
);

# 7
select distinct Reader.name, Reader.ID from Reader
where Reader.name not in
(
	select distinct Reader.name 
    from Reader, Borrow
	where Borrow.Reader_ID = Reader.ID 
		and Borrow.book_ID in
		(
			select Borrow.book_ID 
			from Borrow, Reader
			where Borrow.Reader_ID = Reader.ID 
				and Reader.name = "李林"
		)
);

# 8
select Book.name, Book.ID from Book
where Book.name like "%Oracle%";

# 9
drop view if exists Custom_View;

create view Custom_View as 
select Reader_ID as ReaderID,
	Reader.name as ReaderName, 
    Book_ID as BookID, 
    Book.name as BookName,
    timestampdiff(day, Borrow.Borrow_Date, ifnull(Borrow.Return_Date, now())) as RentTime
from Book, Borrow, Reader
where Borrow.Reader_ID = Reader.ID 
	and Borrow.Book_ID = Book.ID;

SELECT 
    a.ReaderID, COUNT(*) AS BookNum
FROM
    Custom_View AS a,
    Borrow AS b
WHERE
    a.ReaderID = b.Reader_ID
        AND a.BookID = B.book_ID
        AND TIMESTAMPDIFF(DAY, b.Borrow_Date, NOW()) <= 365
GROUP BY a.ReaderID;

select * from Custom_View;
