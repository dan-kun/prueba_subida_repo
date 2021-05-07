-- Create table
create table OMPROD.CFG_SERVICE_IL_PROFILE
(
  ID_BILLING    VARCHAR2(10) not null,
  ID_SERVICE    VARCHAR2(20) not null,
  ID_PROFILE_IL VARCHAR2(10) not null,
  CREATED_DT    DATE not null,
  CREATED_WHO   VARCHAR2(20) not null,
  ACTIVE_DT     DATE not null,
  CHANGE_DT     DATE not null,
  CHANGE_WHO    VARCHAR2(20) not null,
  INACTIVE_DT   DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_SERVICE_IL_PROFILE
  add constraint PK_CFG_SERVICE_IL_PROFILE primary key (ID_BILLING, ID_SERVICE, ID_PROFILE_IL)
  using index;
alter table OMPROD.CFG_SERVICE_IL_PROFILE
  add constraint FK_CFG_SERVICE_IL_PROFILE1 foreign key (ID_PROFILE_IL)
  references OMPROD.CFG_IL_PROFILE (ID_PROFILE_IL);
alter table OMPROD.CFG_SERVICE_IL_PROFILE
  add constraint FK_CFG_SERVICE_IL_PROFILE2 foreign key (ID_BILLING, ID_SERVICE)
  references OMPROD.CFG_SERVICES (ID_BILLING, ID_SERVICE);
