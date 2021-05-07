-- Create table
create table OMPROD.OM_BATCH_CHANGE_PLAN
(
  ID_BILLING_ACCOUNT VARCHAR2(10),
  ID_CONTRACT_PUBLIC VARCHAR2(20),
  GSM                VARCHAR2(15) not null,
  ID_PLAN_PUBLIC     VARCHAR2(10),
  ID_PLAN_PRIVATE    VARCHAR2(10),
  DESCRIPTION_PLAN   VARCHAR2(50),
  CHANGE_PLAN_DELAY  NUMBER,
  DATE_OPERATION     DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_BATCH_CHANGE_PLAN
  add constraint C_UNIQUE_GSM primary key (GSM)
  using index;
