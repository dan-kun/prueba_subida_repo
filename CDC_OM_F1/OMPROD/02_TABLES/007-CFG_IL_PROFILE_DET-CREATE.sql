-- Create table
create table OMPROD.CFG_IL_PROFILE_DET
(
  ID_PROFILE_IL VARCHAR2(10) not null,
  ID_ORDER_TYPE VARCHAR2(10) not null,
  SIM_TYPE      NUMBER not null,
  REQ_ATTR      NUMBER default 0 not null,
  PARAM_NAME    VARCHAR2(144) not null,
  PARAM_VALUE   VARCHAR2(144) not null,
  XML_NUMBER    NUMBER default 1 not null
);
-- Add comments to the columns
comment on column OMPROD.CFG_IL_PROFILE_DET.ID_ORDER_TYPE
  is 'ID_ORDER_TYPE';
comment on column OMPROD.CFG_IL_PROFILE_DET.SIM_TYPE
  is '0=ALL, 1=SIM, 2=USIM';
comment on column OMPROD.CFG_IL_PROFILE_DET.REQ_ATTR
  is '0=NO, 1=SI';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_IL_PROFILE_DET
  add constraint PK_CFG_IL_PROFILE_DET primary key (ID_PROFILE_IL, ID_ORDER_TYPE, SIM_TYPE, REQ_ATTR, PARAM_NAME)
  using index;
alter table OMPROD.CFG_IL_PROFILE_DET
  add constraint FK_CFG_IL_PROFILE_DET foreign key (ID_PROFILE_IL)
  references OMPROD.CFG_IL_PROFILE (ID_PROFILE_IL);
alter table OMPROD.CFG_IL_PROFILE_DET
  add constraint FK_CFG_IL_PROFILE_DET1 foreign key (ID_ORDER_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
