-- Create table
create table OMPROD.OM_ORDER_ITEM
(
  ID_ORDER_ITEM         VARCHAR2(10) not null,
  ID_ORDER              VARCHAR2(10) not null,
  ID_ORD_ITEM_TYPE      VARCHAR2(10) not null,
  ITEM_VALUE            VARCHAR2(255) not null,
  ATTR1_VALUE           VARCHAR2(144),
  ATTR2_VALUE           VARCHAR2(144),
  ATTR3_VALUE           VARCHAR2(144),
  ORDER_ITEM_STATUS     NUMBER not null,
  ORDER_ITEM_STATUS_MSG VARCHAR2(255),
  CREATED_DT            DATE not null,
  CREATED_WHO           VARCHAR2(20) not null,
  ACTIVE_DT             DATE not null,
  CHANGE_DT             DATE not null,
  CHANGE_WHO            VARCHAR2(20) not null,
  INACTIVE_DT           DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_ORDER_ITEM
  add constraint PK_OM_ORDER_ITEM primary key (ID_ORDER_ITEM)
  using index;
alter table OMPROD.OM_ORDER_ITEM
  add constraint FK_OM_ORDER_ITEM foreign key (ID_ORDER)
  references OMPROD.OM_ORDER (ID_ORDER);
alter table OMPROD.OM_ORDER_ITEM
  add constraint FK_OM_ORDER_ITEM1 foreign key (ID_ORD_ITEM_TYPE)
  references OMPROD.CFG_ORD_ITEM_TYPES (ID_ORD_ITEM_TYPE);
alter table OMPROD.OM_ORDER_ITEM
  add constraint FK_OM_STATUS_ITEM foreign key (ORDER_ITEM_STATUS)
  references OMPROD.CFG_STATUS_PROCESS (ID_STATUS);
-- Create/Recreate indexes
create index INDEX_ID_ORDER on OMPROD.OM_ORDER_ITEM (ID_ORDER);