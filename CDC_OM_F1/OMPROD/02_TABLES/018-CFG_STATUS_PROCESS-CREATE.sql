-- Create table
create table OMPROD.CFG_STATUS_PROCESS
(
  ID_STATUS   NUMBER not null,
  DESCRIPTION VARCHAR2(100) not null,
  ATTR1       VARCHAR2(100),
  ATTR2       VARCHAR2(100),
  CREATED_DT  DATE not null,
  CREATED_WHO VARCHAR2(20) not null,
  ACTIVE_DT   DATE not null,
  CHANGE_DT   DATE not null,
  CHANGE_WHO  VARCHAR2(20) not null,
  INACTIVE_DT DATE
);
-- Add comments to the table
comment on table OMPROD.CFG_STATUS_PROCESS
  is 'Tabla de estatus para los procesos de OM';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.CFG_STATUS_PROCESS
  add constraint ID_STATUS_PROCESS primary key (ID_STATUS)
  using index;
