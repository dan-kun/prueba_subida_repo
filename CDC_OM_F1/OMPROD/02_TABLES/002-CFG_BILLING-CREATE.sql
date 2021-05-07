-- Create table
create table OMPROD.CFG_BILLING
(
  ID_BILLING        VARCHAR2(10) not null,
  DESCRIPTION       VARCHAR2(144) not null,
  SHORT_DESCRIPTION VARCHAR2(50),
  MODALITY          NUMBER(1) not null,
  IS_DEFAULT        NUMBER(1) not null,
  CREATED_DT        DATE default SYSDATE not null,
  CREATED_WHO       VARCHAR2(20) default 'GAPOLINAR' not null,
  ACTIVE_DT         DATE default SYSDATE not null,
  CHANGE_DT         DATE default SYSDATE not null,
  CHANGE_WHO        VARCHAR2(20) default 'GAPOLINAR' not null,
  INACTIVE_DT       DATE
);
-- Add comments to the columns
comment on column OMPROD.CFG_BILLING.MODALITY
  is '0=POST, 1=PRE';
comment on column OMPROD.CFG_BILLING.IS_DEFAULT
  is '0=NO, 1=SI';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_BILLING
  add constraint PK_BILLING primary key (ID_BILLING)
  using index;
