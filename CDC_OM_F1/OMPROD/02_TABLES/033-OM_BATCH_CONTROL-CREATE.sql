-- Create table
create table OMPROD.OM_BATCH_CONTROL
(
  ID_BATCH        VARCHAR2(400) not null,
  ID_ORD_ACCOUNT  VARCHAR2(10) not null,
  ID_ORDER        VARCHAR2(10) not null,
  ATTR1           VARCHAR2(20),
  ATTR2           VARCHAR2(20),
  ACK             VARCHAR2(20) not null,
  CREATED_DT      DATE not null,
  CREATED_WHO     VARCHAR2(20) not null,
  ACTIVE_DT       DATE not null,
  CHANGE_DT       DATE not null,
  CHANGE_WHO      VARCHAR2(20) not null,
  SUMMARY_PROCESS VARCHAR2(500)
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_BATCH_CONTROL
  add constraint PK_BATCH_CONTROL primary key (ID_BATCH, ID_ORD_ACCOUNT, ID_ORDER)
  using index;
