DROP ROLE junior_txp;
DROP ROLE intermediate_txp;
DROP ROLE senior_txp;
DROP ROLE manager_txp;
DROP ROLE specialist_txp;
DROP ROLE owner_txp;


REM--- Create junior agent role with necesarry privileges -------------

CREATE ROLE junior_txp;

GRANT CREATE SESSION TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON affiliation
 TO junior_txp;

GRANT SELECT ON agent TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON applied_reward
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON booking
 TO junior_txp;

GRANT SELECT ON class TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON client
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON credit_card
 TO junior_txp;

GRANT SELECT ON destination TO junior_txp;

GRANT SELECT ON fee
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON payment
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON product
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON product_supplier
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON reward_card
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON supplier
 TO junior_txp;

GRANT SELECT, INSERT, UPDATE ON trip
 TO junior_txp;

GRANT SELECT ON trip_type
 TO junior_txp;

REM---------------- Create intermediate agent role -----------------

CREATE ROLE intermediate_txp;

GRANT junior_txp TO intermediate_txp;

REM---------------- CREATE senior role --------------------------

CREATE ROLE senior_txp;

GRANT junior_txp TO senior_txp;

REM------------ CREATE role for commission specialist ---------------

CREATE ROLE specialist_txp;

GRANT CREATE SESSION TO specialist_txp;

GRANT SELECT ON affiliation
 TO specialist_txp;

GRANT SELECT ON agent
 TO specialist_txp;

GRANT SELECT ON applied_reward
 TO specialist_txp;

GRANT SELECT ON booking
 TO specialist_txp;

GRANT SELECT ON class
 TO specialist_txp;

GRANT SELECT ON client
 TO specialist_txp;

GRANT SELECT, INSERT, UPDATE ON commission
 TO specialist_txp;

GRANT SELECT ON credit_card
 TO specialist_txp;

GRANT SELECT ON destination
 TO specialist_txp;

GRANT SELECT ON fee
 TO specialist_txp;

GRANT SELECT ON payment
 TO specialist_txp;

GRANT SELECT ON product
 TO specialist_txp;

GRANT SELECT ON product_supplier
 TO specialist_txp;

GRANT SELECT ON reward_card
 TO specialist_txp;

GRANT SELECT ON supplier
 TO specialist_txp;

GRANT SELECT ON trip
 TO specialist_txp;

GRANT SELECT ON trip_type
 TO specialist_txp;

REM------------------CREATE manager role with necessary privileges------

CREATE ROLE manager_txp;

GRANT CREATE SESSION TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON affiliation
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON agent
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON applied_reward
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON booking
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON class
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON client
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON commission
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON credit_card
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON destination
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON fee
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON payment
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON product
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON product_supplier
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON reward_card
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON supplier
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON trip
 TO manager_txp;

GRANT SELECT, INSERT, UPDATE, DELETE ON trip_type
 TO manager_txp;

REM---------------CREATE owner role --------------------------

CREATE ROLE owner_txp;

GRANT CREATE SESSION TO owner_txp;

GRANT CREATE VIEW TO owner_txp;

GRANT SELECT ON affiliation
 TO owner_txp;

GRANT SELECT ON agent
 TO owner_txp;

GRANT SELECT ON applied_reward
 TO owner_txp;

GRANT SELECT ON booking
 TO owner_txp;

GRANT SELECT ON class
 TO owner_txp;

GRANT SELECT ON client
 TO owner_txp;

GRANT SELECT ON commission
 TO owner_txp;

GRANT SELECT ON credit_card
 TO owner_txp;

GRANT SELECT ON destination
 TO owner_txp;

GRANT SELECT ON fee
 TO owner_txp;

GRANT SELECT ON payment
 TO owner_txp;

GRANT SELECT ON product
 TO owner_txp;

GRANT SELECT ON product_supplier
 TO owner_txp;

GRANT SELECT ON reward_card
 TO owner_txp;

GRANT SELECT ON supplier
 TO owner_txp;

GRANT SELECT ON trip
 TO owner_txp;

GRANT SELECT ON trip_type
 TO owner_txp;
