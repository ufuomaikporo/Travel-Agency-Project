OPTIONS(SKIP=1, direct=false)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\agent\agent_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\agent\agent_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\agent\agent_data.dsc'

REPLACE INTO TABLE txp_admin.agent
FIELDS TERMINATED BY ','
TRAILING NULLCOLS 
(agent_id  SEQUENCE(100, 1),
 initials  CHAR,
 firstname CHAR,
 lastname  CHAR
)
