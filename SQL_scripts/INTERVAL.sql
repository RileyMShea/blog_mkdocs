--Almost works: Missing Parenthesis
select sysdate - HIREDATE YEAR TO MONTH
from emp;

--fixed
select (sysdate - HIREDATE) YEAR TO MONTH "intervals"
from emp;

+-----------------------------+
|(SYSDATE-HIREDATE)YEARTOMONTH|
+-----------------------------+
|NULL                         |
|NULL                         |
|39-1                         |
|38-10                        |
|38-9                         |
|38-3                         |
|38-8                         |
|38-7                         |
|32-9                         |
|38-2                         |
|38-4                         |
|32-7                         |
|38-1                         |
|38-1                         |
|37-11                        |
|NULL                         |
+-----------------------------+

select interval '5' HOUR + interval '5' HOUR
from dual;

--Almost work
select INTERVAL 5 hour,  -- missing `''` around `5`
       sysdate - HIREDATE YEAR TO MONTH, -- missing `()` around sysdate
       INTERVAL


from dual;

select INTERVAL '533' day(3)
from dual;
select INTERVAL '533' day(3, 2)
from dual;



select '5' day
from dual;

--YEAR INTERVAL
-- ALL RETURNS ARE YM INTERVALS
SELECT INTERVAL '9' YEAR            A_,
       INTERVAL '0' YEAR(0)         B, -- 0 appears to be only valid value
       INTERVAL '0-0' YEAR TO MONTH C,
       INTERVAL '123456789' YEAR(9) j,
--        INTERVAL '12345.6789' YEAR(9,4), --Err; Whole Numbers only, Not scale param for YEAR.
       INTERVAL '123456789' YEAR(9) C
--        INTERVAL '' YEAR(0) --Err; Empty string not allowed
--        INTERVAL '1' YEAR(0) --Err; Interval too small
from dual;

--DAY INTERVAL
-- ALL RETURNS ARE YM INTERVALS
SELECT INTERVAL '9' DAY            A_,
       INTERVAL '0' DAY(0)         B, -- 0 appears to be only valid value
       INTERVAL '123' DAY          B, -- 0 appears to be only valid value
--        INTERVAL '0-0' DAY TO MONTH C,
       INTERVAL '123456789' DAY(9) j,
--        INTERVAL '12345.6789' DAY(9,4), --Err; Whole Numbers only, Not scale param for DAY.
       INTERVAL '123456789' DAY(9) C
--        INTERVAL '' DAY(0) --Err; Empty string not allowed
--        INTERVAL '1' DAY(0) --Err; Interval too small
from dual;

--DAY INTERVAL
select INTERVAL '5' DAY                     as A, --Most Basic Example
       INTERVAL '5' DAY(2)                  as A, --SAME as above but explicit precision
--        INTERVAL '566' DAY(9,3), -- ERR; Can't have scale param
--        INTERVAL '4.7' DAY(9), --Err; Nothing with a decimal
       INTERVAL '0' DAY(0)                  as B, --Zero is the Smallest possible DAY precision
       length('0') none,
--        INTERVAL '' DAY(0) as B, --Err; empty str not allowed
       INTERVAL '0000000000000000000000000000000000000000000000000000000000000' DAY(0) as C, --Near Unlimited Zeroes work
       length('000000000000000000000000000000000000000000000000000000000000') as C, --Near Unlimited Zeroes work
       INTERVAL '000000000000000000' DAY(2) as D, --Near Unlimited Zeroes work
       INTERVAL '000000088' DAY                E, --Up to 9 Digits work with preceding zeros
       INTERVAL '000012345' DAY(5)             F, --Up to 9 Digits work with preceding zeros
--        INTERVAL 0 DAY, --Err; Can't use Number literal as interval
--        INTERVAL '' DAY(1), --Err; Can't have an empty value
--        INTERVAL '1' DAY(0), --Err; Precision too small
       INTERVAL '113456789' DAY(9)          as G  -- 9 is the max value
from dual;

select INTERVAL '1234567' SECOND A, --Note Second uniquely
       INTERVAL '6000001.1234567' SECOND B,
       INTERVAL '1234567.123456789' SECOND C,
       INTERVAL '6000001.123456789' SECOND B,
       INTERVAL '600001.123456789' SECOND B,
       INTERVAL '15.6789' SECOND(2,3) B,
       INTERVAL '123456789.123456789' SECOND(9,9) B,
       INTERVAL '0' SECOND(0) b,
--        INTERVAL '0' DAY TO SECOND b,
       INTERVAL '11 10:09:08.123456789' DAY TO SECOND(9) I,
       INTERVAL '30.12345' SECOND(2,4) C,
       INTERVAL '0.123456789' SECOND(0,0) b,
       INTERVAL '123456789.123456789' SECOND(9,0) b
from dual;


select INTERVAL '555' DAY(3), INTERVAL '555' DAY(3)
from dual;


--almost
select INTERVAL '5.555555'
from dual;
select INTERVAL '566' DAY(9, 3)
from dual;


--Unintended

select CAST('1234.1234' AS NUMBER(6,2)) from dual;