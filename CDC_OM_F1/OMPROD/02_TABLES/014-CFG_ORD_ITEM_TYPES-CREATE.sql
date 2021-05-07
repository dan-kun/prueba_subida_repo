-- Create table
create table OMPROD.CFG_ORD_ITEM_TYPES
(
  ID_ORD_ITEM_TYPE  VARCHAR2(10) not null,
  DESCRIPTION       VARCHAR2(144) not null,
  SHORT_DESCRIPTION VARCHAR2(50),
  CREATED_DT        DATE not null,
  CREATED_WHO       VARCHAR2(20) not null,
  ACTIVE_DT         DATE not null,
  CHANGE_DT         DATE not null,
  CHANGE_WHO        VARCHAR2(20) not null,
  INACTIVE_DT       DATE
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_ORD_ITEM_TYPES
  add constraint PK_ORD_ITEM_TYPES primary key (ID_ORD_ITEM_TYPE)
  using index;
