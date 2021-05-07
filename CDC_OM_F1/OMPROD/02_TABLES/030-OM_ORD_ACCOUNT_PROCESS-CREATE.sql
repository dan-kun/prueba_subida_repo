-- Create table
create table OMPROD.OM_ORD_ACCOUNT_PROCESS
(
  ID_ORD_ACCOUNT                 VARCHAR2(10) not null,
  ID_ORD_ACCOUNT_PROCESS         VARCHAR2(10) not null,
  ORD_ACCOUNT_PROCESS_STATUS     NUMBER not null,
  ORD_ACCOUNT_PROCESS_STATUS_MSG VARCHAR2(255),
  CREATE_DT                      DATE not null,
  CREATE_WHO                     VARCHAR2(20) not null,
  ACTIVE_DT                      DATE not null,
  CHANGE_DT                      DATE not null,
  CHANGE_WHO                     VARCHAR2(20) not null,
  INACTIVE_DT                    DATE
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.OM_ORD_ACCOUNT_PROCESS
  add constraint PK_OM_ORDER_ACCOUNT_PROCESS primary key (ID_ORD_ACCOUNT, ID_ORD_ACCOUNT_PROCESS)
  using index;
alter table OMPROD.OM_ORD_ACCOUNT_PROCESS
  add constraint FK_ID_ORDER_ACCOUNT foreign key (ID_ORD_ACCOUNT)
  references OMPROD.OM_ORD_ACCOUNT (ID_ORD_ACCOUNT);
alter table OMPROD.OM_ORD_ACCOUNT_PROCESS
  add constraint FK_ID_ORDER_ACCOUNT_PROCESS foreign key (ID_ORD_ACCOUNT_PROCESS)
  references OMPROD.CFG_ORD_ACCOUNT_PROCESS (ID_ORD_ACCOUNT_PROCESS);
