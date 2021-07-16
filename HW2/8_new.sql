use test;

# drop view fail_view;

# create view fail_view as
# select cno, ifnull(count(*), 0) as fail_num from SC
# where score<60
# group by cno;

# select * 
# from fail_view right outer join Course on Course.cno=fail_view.cno
# group by Course.cno;

drop view fail_rate_view;
create view fail_rate_view as
select cno, fail_num, attend_num, fail_num / attend_num as fail_rate
from
(
	select cno, ifnull(count(*), 0) as fail_num from SC
	where score<60
	group by cno
) as A natural join
(
	select cno, count(*) as attend_num from SC
	group by cno
) as B;

drop view fail_view;
create view fail_view as
select Course.cno, fail_rate from fail_rate_view 
right outer join Course on Course.cno=fail_rate_view.cno
group by Course.cno;

select 
	cno, 
    type,
	avg(score) as avg_score, 
    max(score) as max_score, 
    min(score) as min_score,
    ifnull(fail_rate, 0) as fail_rate
from 
	SC natural join Course natural join fail_view
group by cno
order by field(type, 2, 0, 1, 3);