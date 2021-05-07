-- Create table
create table OMPROD.OM_ORD_IL
(
  ID_ORDER          VARCHAR2(10) not null,
  ID_ORDER_IL       VARCHAR2(10) not null,
  IL_ORDER_NO       VARCHAR2(20),
  IL_TASK_NO        VARCHAR2(20),
  ORD_IL_STATUS     NUMBER not null,
  ORD_IL_STATUS_MSG VARCHAR2(250),
  CREATED_DT        DATE not null,
  CREATED_WHO       VARCHAR2(20) not null,
  ACTIVE_DT         DATE not null,
  CHANGE_DT         DATE not null,
  CHANGE_WHO        VARCHAR2(20) not null,
  INACTIVE_DT       DATE
);
-- Add comments to the columns
comment on column OMPROD.OM_ORD_IL.ID_ORDER
  is 'ID DE LA ORDEN';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_ORD_IL
  add constraint PK_OM_ORD_IL primary key (ID_ORDER_IL)
  using index;
alter table OMPROD.OM_ORD_IL
  add constraint FK_OM_ORD_IL foreign key (ID_ORDER)
  references OMPROD.OM_ORDER (ID_ORDER);
alter table OMPROD.OM_ORD_IL
  add constraint FK_OM_STATUS_IL foreign key (ORD_IL_STATUS)
  references OMPROD.CFG_STATUS_PROCESS (ID_STATUS);
