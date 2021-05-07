-- Create table
create table OMPROD.CFG_IL
(
  ID_ELEMENT    VARCHAR2(10) not null,
  TYPE_ELEMENT  NUMBER not null,
  NAME_ELEMENT  VARCHAR2(144) not null,
  VALUE_ELEMENT VARCHAR2(144),
  PARENT_ID     VARCHAR2(10),
  CREATED_DT    DATE not null,
  CREATED_WHO   VARCHAR2(20) not null,
  ACTIVE_DT     DATE not null,
  CHANGE_DT     DATE not null,
  CHANGE_WHO    VARCHAR2(20) not null,
  INACTIVE_DT   DATE
);
-- Add comments to the columns 
comment on column OMPROD.CFG_IL.TYPE_ELEMENT
  is '0=ENVELOPE, 1=HEADER, 2=BODY, 3=ATRIBUTO';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_IL
  add constraint PK_CFG_IL primary key (ID_ELEMENT)
  using index;