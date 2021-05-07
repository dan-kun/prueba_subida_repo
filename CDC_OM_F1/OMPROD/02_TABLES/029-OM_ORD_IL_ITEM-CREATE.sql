-- Create table
create table OMPROD.OM_ORD_IL_ITEM
(
  ID_ORDER_IL  VARCHAR2(10) not null,
  ELEMENT_TYPE NUMBER not null,
  PARAM_NAME   VARCHAR2(144) not null,
  PARAM_VALUE  VARCHAR2(144)
);
-- Add comments to the columns
comment on column OMPROD.OM_ORD_IL_ITEM.ELEMENT_TYPE
  is '0=PARAMETRO, 1=REQ_ATTR';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_ORD_IL_ITEM
  add constraint PK_OM_ORD_IL_ITEM primary key (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME)
  using index;
alter table OMPROD.OM_ORD_IL_ITEM
  add constraint FK_OM_ORD_IL_ITEM foreign key (ID_ORDER_IL)
  references OMPROD.OM_ORD_IL (ID_ORDER_IL);
 -- disable;
