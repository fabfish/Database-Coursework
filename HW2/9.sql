use test;

drop view fail;
create view fail as
select sno, cno from SC
where score<60;

drop view fail_again;
create view fail_again as
select sno, cno, count(*) as fail_num from fail
group by sno,cno;

select sno, sname, cno, cname 
from Student natural join SC natural join Course natural join fail_again
where fail_num>=2
group by sno, cno;