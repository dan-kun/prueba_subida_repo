-- Create table
create table OMPROD.CFG_SERVICES
(
  ID_BILLING        VARCHAR2(10) not null,
  ID_SERVICE        VARCHAR2(20) not null,
  DESCRIPTION       VARCHAR2(144) not null,
  SHORT_DESCRIPTION VARCHAR2(50),
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_SERVICES
  add constraint PK_CFG_SERVICE primary key (ID_BILLING, ID_SERVICE)
  using index;
alter table OMPROD.CFG_SERVICES
  add constraint FK_CFG_SERVICE foreign key (ID_BILLING)
  references OMPROD.CFG_BILLING (ID_BILLING);
