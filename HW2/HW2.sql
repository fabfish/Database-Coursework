use test;

select sno, sname from Student
where sname like '%科%';

select cno, cname from Course
where type=0 and credit>=3;

select distinct sno, sname from Student
where exists
(
	select * from Course natural join SC
    # where Student.sno=SC.sno and Course.cno=SC.cno and SC.score is null and Course.type=3
    where score is null and type=3 and Student.sno=sno
);

select sno, sname, timestampdiff(YEAR,birthdate,now()) as age
from Student
group by sno, sname
having age>20;

select sname from Student
where sno in
(
	select sno from SC natural join Course
    where type=0
    group by sno
    having sum(credit)>16
) and sno not in
(
	select sno from SC natural join Course
    where type=2 and score<=75
);
