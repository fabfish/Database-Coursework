# HW2

PB18111740 余致远

## 1

```mysql
SELECT 
    sno, sname
FROM
    Student
WHERE
    sname LIKE '%科%';
```

## 2

```mysql
SELECT 
    cno, cname
FROM
    Course
WHERE
    type = 0 AND credit >= 3
```

## 3

```mysql
select distinct sno, sname from Student
where exists
(
	select * from Course natural join SC
    where score is null and type=3 and Student.sno=sno
);
```

## 4

```mysql
select sno, sname, timestampdiff(YEAR,birthdate,now()) as age
from Student
group by sno, sname
having age>20;
```

## 5

```mysql
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
```

## 6

```mysql
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
```

## 7

```mysql
use test;

# select sno, avg(score) as average_score, sum(score) as sum_score 
# from SC natural join Course 
# where type=0
# group by sno;

# drop view temp;

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
```

## 8

```mysql
use test;

# drop view fail_view;

# create view fail_view as
# select cno, ifnull(count(*), 0) as fail_num from SC
# where score<60
# group by cno;

# select * 
# from fail_view right outer join Course on Course.cno=fail_view.cno
# group by Course.cno;

# drop view fail_rate_view;
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

# use outer join to fix the table with null

# drop view fail_view;
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
```

## 9

```mysql
use test;

# drop view fail;
create view fail as
select sno, cno from SC
where score<60;

# drop view fail_again;
create view fail_again as
select sno, cno, count(*) as fail_num from fail
group by sno,cno;

select sno, sname, cno, cname 
from Student natural join SC natural join Course natural join fail_again
where fail_num>=2
group by sno, cno;
```

## 10

```mysql
use test;

# drop view term_view;
create view term_view as
select sno, cno, max(term) as max_term from SC
group by sno, cno;

select * from term_view;
delete from SC as SC_new 
where SC_new.term <>
(
	select max_term from term_view 
    where
		term_view.cno=SC_new.cno 
        and term_view.sno=SC_new.sno
)
```

