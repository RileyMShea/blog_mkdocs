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
