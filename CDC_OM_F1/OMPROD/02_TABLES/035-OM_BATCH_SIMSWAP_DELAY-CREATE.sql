-- Create table
create table OMPROD.OM_BATCH_SIMSWAP_DELAY
(
  ID_TRANSACTION     VARCHAR2(20) not null,
  ID_BATCH           VARCHAR2(20),
  ID_ORD_ACCOUNT     VARCHAR2(20),
  ID_ORD             VARCHAR2(20),
  ID_BILLING_ACCOUNT VARCHAR2(20) not null,
  ID_CONTRACT        VARCHAR2(20) not null,
  GSM                VARCHAR2(20) not null,
  SIMCARD            VARCHAR2(20) not null,
  IMSI               VARCHAR2(20) not null,
  DATE_PROCESS       DATE not null,
  DATE_SIMSWAP       DATE not null,
  PROCESSED          VARCHAR2(50),
  DESCRIPTION        VARCHAR2(200)
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_BATCH_SIMSWAP_DELAY
  add constraint PK_TRANSACTION_SIMSWAP primary key (ID_TRANSACTION)
  using index;