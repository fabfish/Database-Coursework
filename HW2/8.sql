use test;

drop view course_info;

create view course_info as
select * from Course natural join SC;

# select * from course_info;

#select cname, type, average_score, fail_rate 

#order by field(type, 2, 0, 1, 3); 