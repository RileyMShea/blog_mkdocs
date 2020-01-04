# Links to valid documentation for 1Z0-071

## Oracle 12c: General
Anything you might need to know for the exam can be found in the links below


[THE SQL REFERENCE](https://docs.oracle.com/database/121/SQLRF/title.htm)

* Most everything about DDL, DML, Transaction SQL

[OFFICAL INTERVAL REFERENCE](https://docs.oracle.com/database/121/SQLRF/expressions009.htm#SQLRF52084)


[TIME INTERVAL REFERENCE](https://www.oracletutorial.com/oracle-basics/oracle-interval/)

!!! warning "Unofficial Resource"

* I experienced at least a couple questions on inline time intervals that this page seems to
cover thoroughly and more succinctly then the official docs 


[PRIVILEGES](https://docs.oracle.com/database/121/DBSEG/authorization.htm)

* Should be everything needed for:
    * `GRANT` / `REVOKE`
    * `SYSTEM` / `OBJECT`
    
[SQL*PLUS REFERENCE](https://docs.oracle.com/database/121/SQPUG/ch_four.htm#SQPUG014)

* Very little to know here for the exam. Know about:
    * `DESC[CRIBE]`
    * `ACCEPT`
    * `VERIFY`
    * How to connect: `sqlplus sys as sysdba` or `sqlplus username/password`
    
I did not see a single question on anything specific to SQL*PLUS on the exam so just
sticking to the UCERTIFY and official resources should be sufficient.

[EVERYTHING](https://docs.oracle.com/database/121/nav/portal_4.htm)

* If you can't find what you need in the other links, this should contain links to everything u could possibly need.


The PUBLIC role is a special role that every database user account automatically has when the account is created.
By default, it has no privileges granted to it, but it does have numerous grants, mostly to Java objects.
You cannot drop the PUBLIC role, and a manual grant or revoke of this role has no meaning, because the user account
will always assume this role. Because all database user accounts assume the PUBLIC role, it does not appear in the
DBA_ROLES and SESSION_ROLES data dictionary views.

