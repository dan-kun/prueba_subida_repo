-- Create table
create table OMPROD.OM_BATCH_BILLING_PRESEMENT
(
  ID_BILLING_ACCOUNT VARCHAR2(10),
  PRGCODE            VARCHAR2(10),
  BILLCICLE          VARCHAR2(10),
  PAYMENT_METHOD     VARCHAR2(20),
  ID_CONTRACT        VARCHAR2(20),
  GSM                VARCHAR2(20),
  EMAIL              VARCHAR2(30),
  ID_PLAN            VARCHAR2(20),
  DATE_OPERATION     DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_BATCH_BILLING_PRESEMENT
  add constraint UNIQUE_GSM unique (ID_BILLING_ACCOUNT, GSM)
  using index;
