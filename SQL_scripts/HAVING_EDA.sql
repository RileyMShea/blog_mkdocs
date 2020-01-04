/*
 “When GROUP BY is not used, HAVING behaves like a WHERE clause.” The difference between where and having:
    WHERE filters ROWS
    HAVING filters groups
 */
SELECT MAX(SAL), 'anything', COUNT(*)
from emp
having AVG(SAL) > 500;
