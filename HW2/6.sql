use test;

# select sno from SC natural join Course
# where type=0 and score>=60;
    
select sno, sname from Student
where sno in
(
	select sno from SC natural join Course
    where type=0 and score>=60 
    group by sno
    having count(*)=
    (
		select count(*) from Course where type=0
    )
);

select sno, cno, count(*) from SC natural join Course
where type=0 and score>=60 
group by sno
having count(*)=
(
	select count(*) from Course where type=0
);

drop view temp;
create view temp as
select sno, cno from SC natural join Course
where type=0 and score>=60
group by sno, cno;

select sno, count(*) from temp
group by sno
having count(*)=(select count(*) from Course where type=0);