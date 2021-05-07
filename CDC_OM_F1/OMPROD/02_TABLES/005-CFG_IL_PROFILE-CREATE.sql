-- Create table
create table OMPROD.CFG_IL_PROFILE
(
  ID_PROFILE_IL     VARCHAR2(10) not null,
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
alter table OMPROD.CFG_IL_PROFILE
  add constraint PK_CFG_IL_PROFILE primary key (ID_PROFILE_IL)
  using index;
