# Things found in exam questions from my my first attempt
---

After taking my first C993 exam attempt, I jotted down key areas/concepts from the
exam which I didn't know or was unsure of.  Everything in this page is derived from those notes so
all the content on this page could theoretically show up as an exam question.

!!! warning "Legal Disclaimer"
    I did not write down any questions from the exam.  These are are general observations I remember from
    the exam.  I am not reproducing any exam questions here.  These writings are my own and do not
    reflect the opinions of Oracle(c) or WGU(c).  
 









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

TODO: add more with quote escapes combined with `||` , `concat()`

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
        * The problem is that the strings need either a `||` or `#!sql concat to be joined`
        
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
        

    
    
*  `'''` , (3 singles quotes; which ones are escaped)

* `HAVING`[^1] before or without  `GROUP BY`



* Nested aggregations `MAX(COUNT(*))`
* `INSTR` with a `' '` parameter

```sql
--Know what an example like this does
SELECT INSTR(empno, ' ')
FROM EMP;
```

    
* LIKE Upper('%Mc)
* LIKE '%mc' or 'MC'
* Knowing exactly what can be done to a read only table
* Set operators second table datatypes need to match? or be in same group only?

# Interval Literals 

Oracle 12c Interval Literals Docs[^2]

Seeking to answer valid ways to specify interval literals to from questions I was unsure of on
the exam.

#### How to format the strings that go into Interval literals? Things like:

* `DAY` `YEAR`, `AS DAY TO SECOND`, `as hour to min`, `as hour to second`
* `12:00`, `12 00`, `12:00:00`?

!!! Note "Interval Precisions"

    Much like other data types, time intervals have default precision values that can't be exceeded
    by default.
    
    ## `INTERVAL` literals: `YEAR`, `MONTH`, `DAY`, `HOUR`, and `MINUTE`:
    
    * Default precision: 2
    * Min precision: 0
    * Max Precsion: 9
    * Whole numbers as strings only, no decimals
    * Zeros can exceed precede other digits up to 9 ignoring actual precision
    * EACH keyword is ^^NOT^^ plural: ie using `DAYS` instead of `DAY` will throw an error
    
    ## `INTERVAL` literals: `SECOND` ( ^^**HEAVILY**^^ differs from the previous `INTERVAL` literals):
    Encouraged to read the [offical docs on SECOND](https://docs.oracle.com/database/121/SQLRF/sql_elements003.htm#SQLRF00221)
    
    Get ready for a mind-fuck
    
    There is now ^^**two**^^ possible precisions: `leading precision` and `fractional_seconds_precision`
    
    ### `leading_precision`
    
    * How many digits are available for the whole number
    * Default: 7
        * You won't find this number in any docs, but I tested it, and that's what it is :shrug:
    * Min: 0
    * Max: 9
    * Will never accept more than 9 digits(left of the decimal) regardless of precision
        * `#!sql 123456789 SECONDS(9)` will work
        * `#!sql 000000012 SECONDS(2)` will work. Zeros are "ignored" against precision
        * `#!sql 0000000012 SECONDS(2)` ^^won't^^ work. Soft limit on accepting 9 digits
            * The exception to the soft limit of 9 digits is a string of ^^only^^ zeros
            ```sql
            --Allows 60 zeroes before returning bad datetime/interval value error
            SELECT INTERVAL '0000000000000000000000000000000000000000000000000000000000000' DAY(0) FROM DUAL;
            ```
    
    
    ### `fractional_seconds_precision`   
     
    * Default fractional_seconds_precision: ==**6**==
    !!! note 
        This is  ^^only^^ limiting the total fractional seconds stored in the interval.
        
        * It is ^^NOT^^ a limit that will cause an error.
        * It is ^^NOT^^ like scale for `#!sql NUMBER(7,2)`
        
        The ONLY thing fractional_seconds_precision does, is to limit and round to the number specified
        
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
    
    ```
    
    ??? faq "Why is this *almost* correct?"
        TODO
    
    
    
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


        
        
        
* adding decimals (ie 0.5) to a DATE date type
* different queries to get the same result
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
* Speed is important ran out of time, only got 60/78 done
* The queries are very often not formatted, just one long line, no syntax
highlighting. Exception MERGE.  SET operators split selects
* You have the ability to right click answers you think are wrong as a visual aid
to yourself.  Potentially helpful but be able careful of discounting a a choice
like this if you are struggling to find the answer after 
* don't bother marking for later you won't have time to go back 
* questions seem to be mostly choose the two/three that will will execute correctly
* very few ERD diagrams (only 1 or two questions that I can remember)
* Knowing two or three different ways to accomplish the same task is important
since many questions are: which two/three of these have the same result




[^1]: https://docs.oracle.com/database/121/SQLRF/statements_10002.htm#i2078943
[^2]: Inline Intervals: https://www.oracletutorial.com/oracle-basics/oracle-interval/
[^3]: Reserved Keywords: https://docs.oracle.com/database/121/SQLRF/ap_keywd001.htm#SQLRF55621
