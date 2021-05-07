-- Create table
create table OMPROD.CFG_ORD_SMS
(
  ID_ORD_TYPE   VARCHAR2(10) not null,
  MESSAGE_ID    VARCHAR2(10) not null,
  MESSAGE       VARCHAR2(160),
  HTML_TEMPLATE CLOB,
  ISSUE         VARCHAR2(200) default 'asunto Configurable',
  PRGCODE       VARCHAR2(10) default 0 not null,
  GROUP_IMG     VARCHAR2(10) not null
);
-- Add comments to the columns
comment on column OMPROD.CFG_ORD_SMS.MESSAGE_ID
  is '0= id unico';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_ORD_SMS
  add constraint PK_ORD_SMS primary key (ID_ORD_TYPE, MESSAGE_ID, PRGCODE)
  using index;
alter table OMPROD.CFG_ORD_SMS
  add constraint FK_ORD_SMS foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
alter table OMPROD.CFG_ORD_SMS
  add constraint FK_PRGCODE_GROUP_IMG foreign key (GROUP_IMG)
  references OMPROD.CFG_PRGCODE_GROUP (GROUP_IMG);
alter table OMPROD.CFG_ORD_SMS
  add constraint FK_PRGCODE_SMS foreign key (PRGCODE)
  references OMPROD.CFG_PRGCODE (ID_PRGCODE);
-- Create/Recreate indexes
create index INDEX_ID_ORD_TYPE on OMPROD.CFG_ORD_SMS (ID_ORD_TYPE, MESSAGE_ID);
create index INDEX_ID_ORD_TYPE_U on OMPROD.CFG_ORD_SMS (ID_ORD_TYPE);
create index INDEX_PRGCODE on OMPROD.CFG_ORD_SMS (PRGCODE);
