-- Create table
create table OMPROD.CFG_ORD_STRUCT_PROCESS
(
  ID_ORD_STRUCT  VARCHAR2(10) not null,
  ID_ORD_TYPE    VARCHAR2(10) not null,
  ID_ORD_PROCESS VARCHAR2(10) not null,
  PRIORITY       NUMBER not null,
  CREATED_DT     DATE not null,
  CREATED_WHO    VARCHAR2(20) not null,
  ACTIVE_DT      DATE not null,
  CHANGE_DT      DATE not null,
  CHANGE_WHO     VARCHAR2(20) not null,
  INACTIVE_DT    DATE
);
-- Add comments to the columns
comment on column OMPROD.CFG_ORD_STRUCT_PROCESS.PRIORITY
  is 'Orden de ejecucion del proceso';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_ORD_STRUCT_PROCESS
  add constraint PK_ORD_STRUCT primary key (ID_ORD_TYPE, ID_ORD_PROCESS)
  using index;
alter table OMPROD.CFG_ORD_STRUCT_PROCESS
  add constraint FK_ORD_STRUCT foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
alter table OMPROD.CFG_ORD_STRUCT_PROCESS
  add constraint FK_ORD_STRUCT1 foreign key (ID_ORD_PROCESS)
  references OMPROD.CFG_ORD_PROCESS (ID_ORD_PROCESS);
