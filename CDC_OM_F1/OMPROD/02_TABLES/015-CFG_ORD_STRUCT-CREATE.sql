-- Create table
create table OMPROD.CFG_ORD_STRUCT
(
  ID_ORD_STRUCT     VARCHAR2(10) not null,
  ID_ORD_TYPE       VARCHAR2(10) not null,
  ID_ORD_ITEM_TYPE  VARCHAR2(10) not null,
  IS_REQUIRED       NUMBER(1) not null,
  ID_REQUIRED_GROUP NUMBER,
  MAX_ALLOWED       NUMBER,
  ATTR1             VARCHAR2(144),
  ATTR2             VARCHAR2(144),
  ATTR3             VARCHAR2(144),
  CREATED_DT        DATE not null,
  CREATED_WHO       VARCHAR2(20) not null,
  ACTIVE_DT         DATE not null,
  CHANGE_DT         DATE not null,
  CHANGE_WHO        VARCHAR2(20) not null,
  INACTIVE_DT       DATE
);
-- Add comments to the columns
comment on column OMPROD.CFG_ORD_STRUCT.IS_REQUIRED
  is '0=NO, 1=SI';
comment on column OMPROD.CFG_ORD_STRUCT.MAX_ALLOWED
  is '0=ILIMITADO';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_ORD_STRUCT
  add constraint PK_ORD_STRUCTURE primary key (ID_ORD_STRUCT)
  using index;
alter table OMPROD.CFG_ORD_STRUCT
  add constraint FK_ORD_STRUCTURE foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
alter table OMPROD.CFG_ORD_STRUCT
  add constraint FK_ORD_STRUCTURE1 foreign key (ID_ORD_ITEM_TYPE)
  references OMPROD.CFG_ORD_ITEM_TYPES (ID_ORD_ITEM_TYPE);
