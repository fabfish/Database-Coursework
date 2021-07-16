use test;

drop view term_view;
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