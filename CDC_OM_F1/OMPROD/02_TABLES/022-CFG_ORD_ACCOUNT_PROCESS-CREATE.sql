-- Create table
create table OMPROD.CFG_ORD_ACCOUNT_PROCESS
(
  ID_ORD_ACCOUNT_PROCESS VARCHAR2(10) not null,
  DESCRIPTION            VARCHAR2(144) not null,
  SHORT_DESCRIPTION      VARCHAR2(50),
  ID_EXTERNAL_APP        VARCHAR2(10) not null,
  CREATED_DT             DATE not null,
  CREATE_WHO             VARCHAR2(20) not null,
  ACTIVE_DT              DATE not null,
  CHANGE_DT              DATE not null,
  CHANGE_WHO             VARCHAR2(20) not null,
  INACTIVE_DT            DATE
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_ORD_ACCOUNT_PROCESS
  add constraint PK_ORD_ACCOUNT_PROCESS primary key (ID_ORD_ACCOUNT_PROCESS)
  using index;
alter table OMPROD.CFG_ORD_ACCOUNT_PROCESS
  add constraint FK_APP_ORD_ACCOUNT_PROCESS foreign key (ID_EXTERNAL_APP)
  references OMPROD.CFG_EXTERNAL_APP (ID_EXTERNAL_APP);
