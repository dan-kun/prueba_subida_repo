-- Create table
create table OMPROD.CFG_PRGCODE
(
  ID_PRGCODE       VARCHAR2(10) not null,
  ID_PRGCODE_GROUP NUMBER,
  DESCRIPTION      VARCHAR2(100),
  SEND_SMS         NUMBER,
  SEND_EMAIL       NUMBER
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.CFG_PRGCODE
  add constraint PK_PRGCODE primary key (ID_PRGCODE)
  using index;
