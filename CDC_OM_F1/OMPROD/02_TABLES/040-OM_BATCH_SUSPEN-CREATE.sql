-- Create table
create table OMPROD.OM_BATCH_SUSPEN
(
  ID_BILLING_ACCOUNT     VARCHAR2(20) not null,
  ID_ORD_TYPE            VARCHAR2(20) not null,
  IS_ORD_TIPY_ACTIONABLE VARCHAR2(20),
  ID_CONTRACT            VARCHAR2(20),
  GSM                    VARCHAR2(20) not null,
  SIMCARD                VARCHAR2(20),
  IMSI                   VARCHAR2(20),
  ID_PLAN                VARCHAR2(20)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.OM_BATCH_SUSPEN
  add constraint PK_BATCH_SUSPEND primary key (ID_BILLING_ACCOUNT, ID_ORD_TYPE, GSM)
  using index;
alter table OMPROD.OM_BATCH_SUSPEN
  add constraint FK_BATCH_SUSP_ORDER_TYPE foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
