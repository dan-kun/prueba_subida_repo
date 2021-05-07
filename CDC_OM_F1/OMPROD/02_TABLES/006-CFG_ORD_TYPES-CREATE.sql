-- Create table
create table OMPROD.CFG_ORD_TYPES
(
  ID_ORD_TYPE       VARCHAR2(10) not null,
  DESCRIPTION       VARCHAR2(144) not null,
  SHORT_DESCRIPTION VARCHAR2(50),
  ID_CHANNEL        VARCHAR2(10) not null,
  ACTION            VARCHAR2(10) not null,
  ID_ACTION         NUMBER not null,
  ORDER_LEVEL       NUMBER(1) not null,
  CREATED_DT        DATE not null,
  CREATED_WHO       VARCHAR2(20) not null,
  ACTIVE_DT         DATE not null,
  CHANGE_DT         DATE not null,
  CHANGE_WHO        VARCHAR2(20) not null,
  INACTIVE_DT       DATE
);
-- Add comments to the columns 
comment on column OMPROD.CFG_ORD_TYPES.ID_ACTION
  is '0=ALL';
comment on column OMPROD.CFG_ORD_TYPES.ORDER_LEVEL
  is '0=ACCOUNT, 1=CONTRACT';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_ORD_TYPES
  add constraint PK_ORD_TYPE primary key (ID_ORD_TYPE)
  using index;
alter table OMPROD.CFG_ORD_TYPES
  add constraint FK_ORD_TYPE foreign key (ID_CHANNEL)
  references OMPROD.CFG_CHANNEL (ID_CHANNEL);
