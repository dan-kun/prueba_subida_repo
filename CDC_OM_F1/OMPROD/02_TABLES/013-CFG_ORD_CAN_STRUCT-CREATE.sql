-- Create table
create table OMPROD.CFG_ORD_CAN_STRUCT
(
  ID_ORD_TYPE  VARCHAR2(10) not null,
  PARAM_NAME   VARCHAR2(255) not null,
  DATA_TYPE    NUMBER not null,
  MIN_REQUIRED NUMBER not null,
  MAX_ALLOWED  NUMBER not null
);
-- Add comments to the columns
comment on column OMPROD.CFG_ORD_CAN_STRUCT.ID_ORD_TYPE
  is 'ID DE LA ORDEN';
comment on column OMPROD.CFG_ORD_CAN_STRUCT.PARAM_NAME
  is 'NOMBRE DEL PARAMETRO';
comment on column OMPROD.CFG_ORD_CAN_STRUCT.DATA_TYPE
  is '0=STRING, 1=NUMBER';
comment on column OMPROD.CFG_ORD_CAN_STRUCT.MIN_REQUIRED
  is 'CANTIDAD MINIMA DEL PARAMETRO';
comment on column OMPROD.CFG_ORD_CAN_STRUCT.MAX_ALLOWED
  is 'CANTIDAD MAXIMA DEL PARAMETRO';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_ORD_CAN_STRUCT
  add constraint PK_ORD_CAN_STRUCT primary key (ID_ORD_TYPE, PARAM_NAME)
  using index;
alter table OMPROD.CFG_ORD_CAN_STRUCT
  add constraint FK_ORD_CAN_STRUCT foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
