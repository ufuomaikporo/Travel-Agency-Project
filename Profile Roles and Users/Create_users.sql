
REM----------------- Drop users ------------------------------------------

DROP USER blake;
DROP USER zohreh;
DROP USER jolanta;
DROP USER janet;
DROP USER judy;
DROP USER dennis;

DROP USER john;
DROP USER janice;
DROP USER bruce;
DROP USER beverly;
DROP USER jane;
DROP USER brian;

DROP USER eddie;
DROP USER jim;
DROP USER stanley;
DROP USER peter;
DROP USER jamal;
DROP USER susan;

REM----------------- Create user for owner -------------------------

CREATE USER blake IDENTIFIED BY travelxp123$
PROFILE owner_prof;

GRANT owner_txp TO blake;

REM---------------- Create user for manager -------------------------

CREATE USER jolanta IDENTIFIED BY travelxp123$
PROFILE manager_prof;

GRANT manager_txp TO jolanta;

REM------------- Create user for commission specialist -------------

CREATE USER zohreh IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT specialist_txp, senior_txp TO zohreh;

REM------------- Create users for other senior agents ---------------

CREATE USER janet IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT senior_txp TO janet;

CREATE USER judy IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT senior_txp TO judy;

CREATE USER dennis IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT senior_txp TO dennis;

REM---------------- Create users for intermediate agents --------------

CREATE USER john IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT intermediate_txp TO john;

CREATE USER janice IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT intermediate_txp TO janice;

CREATE USER bruce IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT intermediate_txp TO bruce;

CREATE USER beverly IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT intermediate_txp TO beverly;

CREATE USER jane IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT intermediate_txp TO jane;

CREATE USER brian IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT intermediate_txp TO brian;

REM--------------Create users for junior agents --------------------------

CREATE USER eddie IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT junior_txp TO eddie;

CREATE USER jim IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT junior_txp TO jim;

CREATE USER stanley IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT junior_txp TO stanley;

CREATE USER peter IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT junior_txp TO peter;

CREATE USER jamal IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT junior_txp TO jamal;

CREATE USER susan IDENTIFIED BY travelxp123$
PROFILE agent_prof;

GRANT junior_txp TO susan;
