--standard
SELECT COUNT(*)
from emp;
--16


select Distinct MGR
from emp;
-- 7839
-- 7782
-- 7698
-- 7902
-- 7566
-- 7788


select MGR, COUNT(*), COUNT(EMPNO)
from emp
group by MGR
HAVING COUNT(*) > 3;

+----+--------+------------+
|MGR |COUNT(*)|COUNT(EMPNO)|
+----+--------+------------+
|NULL|4       |4           |
|7698|4       |4           |
+----+--------+------------+





--Note that Having can come before group by
select MGR, COUNT(*), COUNT(EMPNO)
from emp
HAVING COUNT(*) > 3
group by MGR;
+----+--------+------------+
|MGR |COUNT(*)|COUNT(EMPNO)|
+----+--------+------------+
|NULL|4       |4           |
|7698|4       |4           |
+----+--------+------------+



select * from emp;

select mgr, empno,
       count(*) over (partition by mgr) "MGR usage"
from emp;

select count(*)
from emp;



SELECT COUNT(*) "Total"
  FROM employees;

     Total
----------
       107

SELECT COUNT(*) "Allstars"
  FROM employees
  WHERE commission_pct > 0;


 Allstars
---------
       35

SELECT COUNT(*) "Allstars", length(COMMISSION_PCT)
FROM employees
having length(COMMISSION_PCT) > 0
group by length(COMMISSION_PCT);
-- having length(COMMISSION_PCT) > 0 ;

SELECT COUNT(commission_pct) "Count"
  FROM employees;

     Count
----------
        35

SELECT COUNT(DISTINCT manager_id) "Managers"
  FROM employees;

  Managers
----------
        18


select '''' quote_escapes
from dual;

select ' '' ' from dual;

select ''' from dual;

