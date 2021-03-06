# Concept
---

!!! abstract
    After taking my first C993 exam attempt, I jotted down key areas/concepts from the
    exam for things which I didn't know or was unsure of.  Everything on this page is derived from those notes, so
    everything here is known to have applications to real-world exam content.

!!! warning "Legal Disclaimer"
    I did not write down any questions from the exam.  These are general observations that I remember from
    the exam.  I am not reproducing any exam questions here, only covering concepts necessary to answer questions like the ones that 
    I encountered on my first attempt.  These writings are my own and do not reflect the opinions of Oracle(c) or WGU(c).  
 








# How/where `COUNT(*)` works in different places of a query:
---
[Oracle 12c Official COUNT Docs](https://docs.oracle.com/database/121/SQLRF/functions046.htm#SQLRF00624)

They will try to put `COUNT(*)` in every conceivable place, of every query.

### Know how `COUNT(*)` works:

* In the `SELECT` only:
    * Counts every single row in a table, ^^including^^ `<null>`'s
* In the `GROUP BY`:
    
    

```sql
--In the SELECT and HAVING
select MGR, COUNT(*), COUNT(EMPNO)
from emp
group by MGR
HAVING COUNT(*) > 3;
/* Output
+----+--------+------------+
|MGR |COUNT(*)|COUNT(EMPNO)|
+----+--------+------------+
|NULL|4       |4           |
|7698|4       |4           |
+----+--------+------------+
*/
```

* Merge statements, exact flow
     * where the source and target table can be referenced
     * What is valid `WHEN MATCHED` , `WHEN NOT MATCHED`
* How `EXISTS` works with an alias to the outer table and no alias for the subquery inner table
* select 2 from dual a cross join dual b cross join dual c;

# Multiple single quotes

This section might seem a little insane.  If you're wondering if it's worth studying this, I had one question
from my last attempt that really wanted to make sure you knew how many single quotes, in what order,
would create a desired result vs an error. 


Quote Docs: https://docs.oracle.com/database/121/SQLRF/sql_elements003.htm#i42617

The general flow which I'll explain further in the examples below is:

* opening single quote to start character string `'`
* process each character 
* when another {==`'`==} is found:
    * check to see if the following character is also a `'`.  If it is, process
the two quotes as an escaped single quote.
    * If there is no immediate followup quote, process this `'` as the closing quote.


 

!!! info "4 singles quotes, which ones are escaped?"
    
    
    ```sql
    select '''' quote_escapes
    from dual;
    ```
    
    | QUOTE\_ESCAPES |
    | :--- |
    | ' |

    !!! info "Breakdown"
        * `{++'++}'''` The first quote char starts the string.
        *  `'{++''++}'` Next, Oracle see's the 2nd and third singles(`''`).  This is processed as an escaped single(`'`).
        *  `'''{++'++}` Finally, the last quote is processed. It isn't part of a pair, so it closes the string.
        
    A single-quote is returned.
    
    2 outer singles hold one escaped single(doubled for escape) 
    
!!! info "4 singles quotes... again?, which ones are escaped?"
    
    
    ```sql
    select '' '' quote_escapes
    from dual;
    ```
    
    !!! error "Result: Error"
    
        This time no quote escapes are attempted
        
        * `{++''++} ''` The first pair is a complete string.  It evaluates to `<null>` though because Oracle
        doesn't believe in empty strings :shrug:
        * `'' {++''++}` The second pair is also a complete string.
        * The problem is that the strings need either a `||` or `#!sql concat` to be joined
        
        !!! success "Possible Fixes"
        
            ```sql
            select '' || '' quote_escapes from dual;
            ```
            
            ```sql
            select concat('', '') quote_escapes from dual;
            ```
            
            ```sql
            select ' '' ' quote_escapes from dual;
            /*
            This example returns a single quote.
            */
            ```
            
        
!!! info "3 singles quotes, which ones are escaped?"
    
    
    ```sql
    select ''' quote_escapes
    from dual;
    ```
    
    !!! error "Result: Error"
        * `{++'++}''` The first quote char starts the string.
        *  `'{++''++}` Next Oracle see's the 2nd and third singles(`''`).  This is processed as an escaped single(`'`).
        * Since all thee single quotes have been processed, there is no closing quote.  An error results.
        

    
    

# `HAVING` before or without  `GROUP BY`?
---

!!! note
    AFAIK these are rarities you will never see outside the exam.  However I encountered at least a few
    questions on my first attempt that had possible answers which included: `HAVING` before a group by, and 
    `HAVING` without a `GROUP BY`.

Docs [^1]

## `HAVING` before a `GROUP BY`
---

`HAVING` can become before or after `GROUP BY` and it has zero impact on your query.  The only general
requirement is that they each come after the `WHERE`(if it exists) and before the `ORDER BY`.  AFAIK
they are the only two query clauses where the order doesn't matter.

## `HAVING` without `GROUP BY`
---

`HAVING` can be used without `GROUP BY`, but it is heavily restricted.

>  If you omit `#!sql group by`, all the rows not excluded by the where clause return as a single group.

Since you can only get a single group, you will only ever get a single row as a return.  Remember
 `where` filters rows, but `having` filters groups.  In this case though, there's only one group to be filtered.
So `HAVING`, in this `GROUP BY`-less statement will either keep the single row of aggregated output or filter it out.

```sql hl_lines="7 8"
FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE or WITH ROLLUP
HAVING
SELECT
DISTINCT
ORDER BY
FETCH
```



```sql

SELECT MAX(SAL), 'wgu', COUNT(*) ct, min(COMM) min, median(deptno) med
from emp;

```

| MAX\(SAL\) | 'WGU' | CT | MIN | MED |
| :--- | :--- | :--- | :--- | :--- |
| 5000 | wgu | 16 | 0 | 20 |


```sql
SELECT MAX(SAL), 'wgu', COUNT(*) ct, min(COMM) min, median(deptno) med
from emp
having avg(SAL) > 500;
```

# Interval Literals 
---

Oracle 12c Interval Literals Docs[^2]

!!! note
    Seeking to answer valid ways to specify interval literals. My first attempt had at least a couple questions 
    that tested to see if you knew the exact way to specify time interval literals, what they allowed, and different
    ways to get the same answer.
    the exam.

#### How to format the strings that go into Interval literals? Things like:

* `DAY` `YEAR`, `AS DAY TO SECOND`, `as hour to min`, `as hour to second`
* `12:00`, `12 00`, `12:00:00`?

!!! Note "Interval Precisions"

    Much like other data types, time intervals have default precision values that can't be exceeded
    by default.
    
    ## `INTERVAL` literals: `YEAR`, `MONTH`, `DAY`, `HOUR`, and `MINUTE`:
    ---
    
    * Default precision: 2
    !!! warning
        Note this is {++precision++}, which is how many total digits are available for use.  Do not confuse this with scale.
    * Min precision: 0
    * Max Precision: 9
    * {++Whole++} numbers as strings only, no decimals
    * Zeros can precede other digits. Up to a combined 9 ignoring actual precision. More on this below.
    * EACH keyword is ^^NOT^^ plural: ie using {--`DAYS`--} instead of {++`DAY`++} will throw an error
    
    ## `INTERVAL` literal: `SECOND` ( ^^**HEAVILY**^^ differs from the previous `INTERVAL` literals):
    ---
    
    Encouraged to read the [offical docs on SECOND](https://docs.oracle.com/database/121/SQLRF/sql_elements003.htm#SQLRF00221)
    
    Get ready for a mind-fuck
    
    For the `SECOND` interval, there are now ^^**two**^^ possible precisions:
    
    * `leading precision` and `fractional_seconds_precision`
    
    ### `leading_precision`
    
    * "How many digits are available for the whole number"
    * Default: 7
        * You won't find this number in any docs, but I tested it, and that's what it is :shrug:
    * Min: 0
    * Max: 9
    * Will never accept more than 9 digits(left of the decimal) regardless of precision
        * `#!sql INTERVAL '123456789' SECONDS(9)` will work
        * `#!sql INTERVAL '000000012' SECONDS(2)` will work. Zeros are "ignored" against precision
        * `#!sql INTERVAL '0000000012' SECONDS(2)` ^^won't^^ work. Soft limit on accepting 9 digits
            * The exception to the soft limit of 9 digits is a string of ^^only^^ zeros
            ```sql
            --Allows 60 zeroes before returning bad datetime/interval value error
            SELECT INTERVAL '0000000000000000000000000000000000000000000000000000000000000' DAY(0) FROM DUAL;
            ```
    
    
    ### `fractional_seconds_precision`   
     
    * Default fractional_seconds_precision: ==**6**==
    !!! note 
        This parameter is  ^^only^^ limiting the total fractional seconds stored in the interval.
        
        * It is ^^NOT^^ a limit that will cause an error when exceeded.
        * It is ^^NOT^^ like scale for `#!sql NUMBER(7,2)`.
        
        The ONLY thing `fractional_seconds_precision` does, is to limit and round to the number place specified
        
    * Min precision: 0 ( [Official 12c documentation](https://docs.oracle.com/database/121/SQLRF/sql_elements003.htm#SQLRF00221) says `1`) 
    
        !!! quote
        
            > `fractional_seconds_precision` is the number of digits in the fractional part of the SECOND datetime field. Accepted values are 1 to 9. The default is 6. 
        
        * `#!sql select INTERVAL '0.123456789' SECOND(0,0) from dual;` works for me on my Oracle 12c 
        ```sql
        /*
        
        Connected to:
        Oracle Database 12c Enterprise Edition Release 12.1.0.1.0 - 64bit Production
        
        SQL> select INTERVAL '0.123456789' SECOND(0,0) from dual;

        INTERVAL'0.12345678
        -------------------
        +00 00:00:00.000000
        */
        ```

    * Max Precsion: 9
    * ==^^Can^^ use decimals==
    
    !!! warning "`SECOND` Does ^^NOT^^ behave like `NUMBER`"
    
    
    
    
General form is:

`INTERVAL` `quoted_number` `interval type`


!!! Success "Working Examples"
    ```sql
    select INTERVAL '5' DAY from dual;
    select INTERVAL '5' YEAR from dual;
    select INTERVAL '5.555555' from dual;
    ```
!!! warning "Example Errors: *Almost* Correct"
    ```sql
    select INTERVAL '5' MINUTE TO DAY from dual;
    ```
    
    ??? faq "Why is this *almost* correct?"
        Smaller time interval can't come before bigger time-interval
        
    ```sql
    select INTERVAL '5.555555' from dual;
    ```
    
    ??? faq "Why is this *almost* correct?"
        Missing the actual `INTERVAL` type (ie `DAY` ... `SECOND`)
        
    ```sql
    select INTERVAL '533' day(3,2) from dual;
    ```
!!! danger "Examples: Unintended Output!"
    ```sql
    select '5' day from dual;
    ```
    
    ??? faq "Why is the output unintended?"
        The intention appears to get a `#!sql INTERVAL '5' DAY` but without the `INTERVAL`
        keyword it's just a `NUMBER` with a column alias of DAY.  Oracle allows this because 
        `DAY` is a keyword, but not a **RESERVED** keyword[^3]
        
        | DAY |
        | :--- |
        | 5 |
        
!!! success "Working conversion functions"
    
    ## `#!sql TO_DSINTERVAL()`

    * All values(except microseconds) must have a number even if it's zero:
        *  `MIN` and `SECOND` : 0-59
        * `HOUR`: 0-23
        * `DAY`: 0-999999999
        
    
    !!! fail
        ```sql
        --These won't work
        select to_dsinterval('1 0::0') from dual;
        select to_dsinterval('1 :0:0') from dual;
        select to_dsinterval('1 0:0:') from dual;
        select to_dsinterval('1:1:1') from dual;
        ```
    * If negative, the negative sign ==must== come first
    * 9 digits of precision are available for `DAYS`, 
    * 9 digits of precision are available for `MICROSECONDS`
    * {++At least++} one space must separate days and hours
        * More spaces can be put between each interval number with no effect
        !!! example "Example: Extra spaces"
            ```sql
            --All works the same
            select to_dsinterval('1   10:50:50') from dual;
            select to_dsinterval('1 10  :50    :50.234234234') from dual;
            select to_dsinterval('   1 10  :  50  :  50    ') from dual;
            ```
            
            !!! warning "Extra spaces can't separate a number"
                ```sql
                '  1  23  :  59  : 59  ' --works
                '1 2 3:5 9:5 9' --doesn't
                ```
            
        
    
    ```sql
    select to_dsinterval('-123456789 23:59:59.123456789') from dual;
    /*
     +---------------------------------------------+
    |TO_DSINTERVAL('-12345678923:59:59.123456789')|
    +---------------------------------------------+
    |-123456789 23:59:59.123456789                |
    +---------------------------------------------+
     */
    ```


# LIKE

[Official Docs: Like Condition](https://docs.oracle.com/database/121/SQLRF/conditions007.htm#SQLRF52142)

!!! warning

    `%` is a one-to-many wildcard characters.  The exception is `null`.  so `#!sql LIKE '%'` will match everything that isn't `null` or an
    empty string(which oracle stores as `null`)
    
    In contrast, underscore(`_`) is  ^^NOT^^ a zero-to-one wildcard character. It is exactly a single wildcard character. 
    
    
    
## `#!sql upper('%Mc')`
 
```sql
select ename
from emp
where ename like upper('smi%');
```

| ENAME |
| :--- |
| SMITH |

!!! error "Errors: Exam watch"

    These are similar to exam questions I remember.  They are almost correct by not quite.
    
    ```sql
    select ename
    from emp
    where ename like 'SXI%' or 'SMI%';
    ```    
        
    ```sql
    select ename
    from emp
    where ename like 'SXI%' or like 'SMI%';
    ```
    
    !!! success "correct usage of two LIKE on same column" 

        ```sql
        select ename
        from emp
        where ename like 'SXI%'
        or ename  like 'SMI%';
        ```    
        
```sql
select ename
from emp
where lower(ename) like lower('SMi%');
```

# Nested aggregations

!!! example "`MAX(COUNT(*))`"
 
# `INSTR` with a `' '` parameter

```sql
--Know what an example like this does
SELECT INSTR(empno, ' ')
FROM EMP;
```

# TODO
---

!!! note

    I'm planning to flesh out most/all of the rest of these bullet points into sections with explanations and examples.  Some of them are
    just brief notes to jog my memory and may not make sense to anyone but me.



    
* Knowing exactly what can be done to a `READ ONLY` table
* Set operators second table datatypes need to match? or be in same group only?



        
        
        
# adding decimals to a `DATE` 

Adding decimal values to a date works precisely.  That is, it doesn't round the decimal to a full day

```sql

select to_date('02-FEB-20', 'DD-MON-RR'),
       to_date('02-FEB-20', 'DD-MON-RR') + 1, -- add 1 day
       to_date('02-FEB-20', 'DD-MON-RR') + 1/24, --add 1 hour
       to_date('02-FEB-20', 'DD-MON-RR') + 1/24/60, --add 1 min
       to_date('02-FEB-20', 'DD-MON-RR') + 1/24/60/60, --add 1 sec
       to_date('02-FEB-20', 'DD-MON-RR') + .1-- add 2 hours 24 min(2.4hours)
       from dual;
/*
+--------------------------------+----------------------------------+-------------------------------------+----------------------------------------+-------------------------------------------+-------------------------------------------------------------+
|TO_DATE('02-FEB-20','DD-MON-RR')|TO_DATE('02-FEB-20','DD-MON-RR')+1|TO_DATE('02-FEB-20','DD-MON-RR')+1/24|TO_DATE('02-FEB-20','DD-MON-RR')+1/24/60|TO_DATE('02-FEB-20','DD-MON-RR')+1/24/60/60|TO_DATE('02-FEB-20','DD-MON-RR')+.1--ADD2HOURS24MIN(2.4HOURS)|
+--------------------------------+----------------------------------+-------------------------------------+----------------------------------------+-------------------------------------------+-------------------------------------------------------------+
|2020-02-02 00:00:00             |2020-02-03 00:00:00               |2020-02-02 01:00:00                  |2020-02-02 00:01:00                     |2020-02-02 00:00:01                        |2020-02-02 02:24:00                                          |
+--------------------------------+----------------------------------+-------------------------------------+----------------------------------------+-------------------------------------------+-------------------------------------------------------------+
*/
```


 
 
* Full outer with (+)'s
* Speed of Join
* speed of between is always faster than >= / <=
* Can public be revoked?
* Does every user start with public?
* Can roles be assigned to roles?
* sequences create a sequence with the least chance of spaces?
* Know sequences defaults (cache/nocache) cycle/nocycle etc
* reaffirm which grants (system/object) are retained after a revoke
* requirements of an ERD with a many-to-many, ie students that can have many
teachers, and teachers can have many students.
    * when referring to ERD's are primary keys relevant?
* reaffirm index's are only created on unique and primary keys?
* requirements to insert, update delete from a view.  Are the different?
* global temporary tables.  General knowledge and:
    * When they are created: Session start? different time
    * how actions from different sessions affect the table.    
    * can different users/sessions see other users/session versions of the table?
* virtual columns: general knowledge
* TO_CHAR with numbers:
    * does it truncate/round/floor decimals? '$1,000' 2324.434 => ?
    * how does it work with numbers bigger than its format? 
        * '$1,000' 334234 => ?
* How Distinct acts in aggregations
* learn coalesce first non-null expression in list
* Know all the different nuances of `HAVING`:
    * it CAN come before `GROUP BY`
    * it CAN be used without `GROUP BY`
    * Reference https://docs.oracle.com/javadb/10.8.3.0/ref/rrefsqlj14854.html
    
    
# General Notes
* Speed is important. I ran out of time, only getting 60/78 done
* The queries are very often not formatted, just one long line, no syntax
highlighting. Exceptions are queries using `MERGE`. `SET` operators
* You have the ability to right click answers you think are wrong as a visual aid
to yourself.  Potentially helpful, but be able careful of discounting a a choice
like this if you are struggling to find the answer after 
* Don't bother using the  "mark for later" you won't have time to go back 
* Questions seem to be mostly choose the two/three answers that will will execute correctly
    * Knowing two or three different ways to accomplish the same task is important
    since many questions are: which two/three of these have the same result
* Very few ERD diagrams (only 1 or two questions that I can remember)
* different queries to get the same result

# Thanks

Great thanks to my fellow C993 students and all contributors to the fabled "powerpoint slides".  With the scarcity of content on the 
2019 October exam changes, the slides have been a critical resource for me to study from.

The WGU C993 Slack group.

# Contributing

If you like this document and want to contribute(spelling, grammar, content, suggestions, etc) I welcome anyone wanting to contribute directly or
indirectly.  Currently this project is rolled into my "blog" but if there's interest I may migrate it elsewhere.

If you want to contribute to the page directly you can edit the markdown the page it's generated from
[here](https://github.com/RileyMShea/blog_mkdocs/edit/master/docs/2020/Oracle/post_attempt_1_notes.md).  It's written in markdown
that that has some extensions from [Material for mkDocs](https://squidfunk.github.io/mkdocs-material/), so it's hopefully fairly intuitive to 
edit.  After submitting someone just needs to approve the change and the site should get rebuilt automatically. 


If you have some experience with git, github, and markdown and want to be added as a repo collaborator who can approve
content changes/updates contact me via email or on our slack wgu sql.

Or if you prefer just leave a comment in the comment section below.


[^1]: https://docs.oracle.com/database/121/SQLRF/statements_10002.htm#i2078943
[^2]: Inline Intervals: https://www.oracletutorial.com/oracle-basics/oracle-interval/
[^3]: Reserved Keywords: https://docs.oracle.com/database/121/SQLRF/ap_keywd001.htm#SQLRF55621
