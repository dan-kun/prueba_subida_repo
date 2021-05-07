-- Create table
create table OMPROD.CFG_EXTERNAL_APP
(
  ID_EXTERNAL_APP   VARCHAR2(10) not null,
  DESCRIPTION       VARCHAR2(144) not null,
  SHORT_DESCRIPTION VARCHAR2(50),
  CREATED_DT        DATE not null,
  CREATED_WHO       VARCHAR2(20) not null,
  ACTIVE_DT         DATE not null,
  CHANGE_DT         DATE not null,
  CHANGE_WHO        VARCHAR2(20) not null,
  INACTIVE_DT       DATE
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_EXTERNAL_APP
  add constraint PK_EXTERNAL_APP primary key (ID_EXTERNAL_APP)
  using index;
