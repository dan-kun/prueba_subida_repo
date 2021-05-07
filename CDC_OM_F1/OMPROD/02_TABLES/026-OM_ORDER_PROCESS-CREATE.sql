-- Create table
create table OMPROD.OM_ORDER_PROCESS
(
  ID_ORDER                 VARCHAR2(10) not null,
  ID_ORD_PROCESS           VARCHAR2(10) not null,
  ORDER_PROCESS_STATUS     NUMBER not null,
  ORDER_PROCESS_STATUS_MSG VARCHAR2(255),
  CREATED_DT               DATE not null,
  CREATED_WHO              VARCHAR2(20) not null,
  ACTIVE_DT                DATE not null,
  CHANGE_DT                DATE not null,
  CHANGE_WHO               VARCHAR2(20) not null,
  INACTIVE_DT              DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_ORDER_PROCESS
  add constraint PK_OM_ORDER_PROCESS primary key (ID_ORD_PROCESS, ID_ORDER)
  using index;
alter table OMPROD.OM_ORDER_PROCESS
  add constraint FK_OM_ORDER_PROCESS1 foreign key (ID_ORDER)
  references OMPROD.OM_ORDER (ID_ORDER);
alter table OMPROD.OM_ORDER_PROCESS
  add constraint FK_OM_ORDER_PROCESS2 foreign key (ID_ORD_PROCESS)
  references OMPROD.CFG_ORD_PROCESS (ID_ORD_PROCESS);
