-- Create table
create table OMPROD.CFG_PRGCODE_GROUP
(
  ID_PRGCODE_GROUP NUMBER not null,
  DESCRIPTION      VARCHAR2(200) not null,
  GROUP_IMG        VARCHAR2(10) not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_PRGCODE_GROUP
  add constraint PK_ID_PRG_GROUP primary key (ID_PRGCODE_GROUP)
  using index;
alter table OMPROD.CFG_PRGCODE_GROUP
  add constraint K_GROUP_IMG unique (GROUP_IMG)
  using index;