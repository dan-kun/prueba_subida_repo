-- Create table
create table OMPROD.CFG_ORD_ACCOUNT_STRUCT_PROCESS
(
  ID_ORD_ACCOUNT_STRUCT  VARCHAR2(10) not null,
  ID_ORD_TYPE            VARCHAR2(10) not null,
  ID_ORD_ACCOUNT_PROCESS VARCHAR2(10) not null,
  PRIORITY               NUMBER not null,
  CREATED_DT             DATE not null,
  CREATED_WHO            VARCHAR2(20) not null,
  ACTIVE_DT              DATE not null,
  CHANGE_DT              DATE not null,
  CHANGE_WHO             VARCHAR2(20) not null,
  INACTIVE_DT            DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_ORD_ACCOUNT_STRUCT_PROCESS
  add constraint PK_ORD_ACCOUNT_STRUCT primary key (ID_ORD_TYPE, ID_ORD_ACCOUNT_PROCESS)
  using index;
alter table OMPROD.CFG_ORD_ACCOUNT_STRUCT_PROCESS
  add constraint FK_ID_ORDER_TYPE foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
alter table OMPROD.CFG_ORD_ACCOUNT_STRUCT_PROCESS
  add constraint FK_ORD_ACCOUNT_PROCESS foreign key (ID_ORD_ACCOUNT_PROCESS)
  references OMPROD.CFG_ORD_ACCOUNT_PROCESS (ID_ORD_ACCOUNT_PROCESS);
