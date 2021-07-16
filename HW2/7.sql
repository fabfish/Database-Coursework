use test;

# select sno, avg(score) as average_score, sum(score) as sum_score 
# from SC natural join Course 
# where type=0
# group by sno;

drop view temp;

create view temp as 
select * from Student natural join
(
	select sno, avg(score) as average_score, sum(score) as sum_score 
	from SC natural join Course
	where type=0
	group by sno
) as A;

select sname, sno, average_score, sum_score 
from temp
where
(
	# count those whose score <= this.score
	select count(*) from temp as B
    where temp.average_score>=B.average_score
) >= ceil((select count(*) from Student)/2)
# half the students's score <= this.score
order by average_score desc limit 10;