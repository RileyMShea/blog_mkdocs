SELECT *
from EMPLOYEES a
where exists(select ' '
    from DEPARTMENTS
    where a.DEPARTMENT_ID IN DEPARTMENT_ID);

select count(*)
from EMPLOYEES;

