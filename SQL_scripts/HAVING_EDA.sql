/*
 “When GROUP BY is not used, HAVING behaves like a WHERE clause.” The difference between where and having:
    WHERE filters ROWS
    HAVING filters groups
 */
SELECT MAX(SAL), 'wgu', COUNT(*) ct, min(COMM) min, median(deptno) med
from emp;

SELECT MAX(SAL), 'anything', COUNT(*), min(COMM), median(deptno)
from emp
having AVG(SAL) > 500;

SELECT MAX(SAL), 'anything', COUNT(*), min(COMM), median(deptno)
from emp
having avg(sal) <= 500;

SELECT MAX(SAL), 'anything', COUNT(*), min(COMM), median(deptno)
from emp
having count(*) = max(rownum);

select *
from emp;

select ename
from emp
where ename like '%SMI';

select ename
from emp
where ename like JOB;

select ename
from emp
where ename like '%S';

select *
from emp
where concat(ename, JOB) like ANY ('SMI%');

select ename
from emp
where ename like 'SXI%' or like 'SMI%';

select ename
from emp
where ename like 'SXI%'
   or ename like 'SMI%';

select ename
from emp
where lower(ename) like lower('SmI%');

select INTERVAL '13.2' Minute
from dual;

select sysdate
from dual
union
select systimestamp
from dual
union
select TO_DATE('2010-01-06', 'RRRR-MM-DD')
from dual;

select 5
from dual
union
select '10'
from dual;

select 3
from dual
intersect
select 3 f
from dual;

--good
select to_dsinterval('   1 101  :  50  :  50  ')
from dual;
select to_dsinterval('0 0:0:0')
from dual;
select to_dsinterval('001 01:01:0')
from dual;
select to_dsinterval('-123456789 23:59:59.123456789')
from dual;
/*
 +---------------------------------------------+
|TO_DSINTERVAL('-12345678923:59:59.123456789')|
+---------------------------------------------+
|-123456789 23:59:59.123456789                |
+---------------------------------------------+
 */
select to_dsinterval('-0  10 : 00:00')
from dual;


--bad
select to_dsinterval('1 0::0')
from dual;
select to_dsinterval('1 -0:0:0')
from dual;

select to_dsinterval('-1234567891 23:59:59.123456789')
from dual;
select to_dsinterval('-123456789 23:59:59.123456789')
from dual;
select to_dsinterval('-123456789 23:59:59.123456789')
from dual;

select SALARY
from EMPLOYEES
where LAST_NAME like '_King'
   or 'King';

select salary
from EMPLOYEES
where SALARY > count(*);

select ROWid,
       ROWNUM,
       row_number() over (order by SALARY desc)    row_ception,
       row_number() over (order by LAST_NAME desc) row_id,
       rank() over (order by rownum)
from EMPLOYEES
group by LAST_NAME;
order by SALARY;



SELECT department_id,
       first_name,
       last_name,
       salary,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary desc) rn
FROM employees;

SELECT department_id, first_name, last_name, salary
FROM (
         SELECT department_id,
                first_name,
                last_name,
                salary,
                ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary desc) rn
         FROM employees
     )
WHERE rn <= 3
ORDER BY department_id, salary DESC, last_name;


SELECT RANK(15500, .05) WITHIN GROUP
    (ORDER BY salary, commission_pct) "Rank"
FROM employees;

select *
from (select salary, COMMISSION_PCT, rank() over ( order by salary, COMMISSION_PCT) a
      from EMPLOYEES);
where a = 105;

select distinct *, dense_rank() over ( order by salary, COMMISSION_PCT) a
from EMPLOYEES;

select a.*, b.SALARY
from EMPLOYEES a,
     EMPLOYEES b;

select *, 'riley'
from dual;



create table scores_student
(
    student_num number,
    old_credit  number,
    new_credit  AS (student_num - old_credit)
);

insert into scores_student
values (10, 15);

insert into scores_student(student_num, old_credit)
values (null, 15);


drop table scores_student purge;

insert into scores_student(student_num, old_credit, new_credit)
values (10, 15, 22);

update scores_student
set new_credit = 10;


For this table find all

select to_date('02-FEB-20', 'DD-MON-RR'),
       to_date('02-FEB-20', 'DD-MON-RR') + 1,                -- add 1 day
       to_date('02-FEB-20', 'DD-MON-RR') + 1 / 24,           --add 1 hour
       to_date('02-FEB-20', 'DD-MON-RR') + 1 / 24 / 60,      --add 1 min
       to_date('02-FEB-20', 'DD-MON-RR') + 1 / 24 / 60 / 60, --add 1 sec
       to_date('02-FEB-20', 'DD-MON-RR') + .1-- add 2 hours 24 min(2.4hours)
from dual;


savepoint before;

merge into scores_student a
using (select 3 "a1", 22 "b2"
       from dual) b
on (a.old_credit = b."b2" OR 1 = 1)
WHEN NOT MATCHED THEN
    insert (a.student_num, a.old_credit)
    values (b."a1", b."b2")
WHEN MATCHED THEN
    update
    set a.student_num = a.old_credit + 1
    delete where a.old_credit = b."b2"
    where

select *
from scores_student;

rollback to before;

select 1, 2
from dual;

SELECT e.employee_id,
       e.last_name,
       d.department_id,
       d.location_id
from departments d
         join employees e
              on e.employee_id = d.department_id
                  OR e.manager_id != e.EMPLOYEE_ID;



SELECT e.employee_id,
       e.last_name,
       d.department_id,
       d.location_id
from departments d,
     join employees e
on e.employee_id = d.department_id
    OR e.manager_id != e.EMPLOYEE_ID;

SELECT e.last_name, e.employee_id, l.city, d.department_name
FROM employees e
         JOIN departments d
              USING (department_id)
         JOIN locations l
              USING (location_id);


SELECT e1.employee_id, e1.manager_id, e2.employee_id
FROM employees e1,
     employees e2
WHERE e1.manager_id = e2.employee_id;

SELECT e1.employee_id, e1.manager_id, e2.employee_id
FROM employees e1
         left join employees e2
                   on e1.manager_id = e2.employee_id;

SELECT *
from DICTIONARY
where TABLE_NAME like 'GV%'
OR TABLE_NAME LIKE 'GV\_%' escape '\';

SELECT *
from DICTIONARY
where TABLE_NAME like 'GV\_%' escape '\';

select * from GV$FS_FAILOVER_HISTOGRAM;
