-- Create table
create table OMPROD.OM_CONTROL_NOTIFICATION
(
  ID_NOTIFICATION           VARCHAR2(200) not null,
  ID_NOTIFICATION_LOTE      VARCHAR2(200) not null,
  ID_NOTIFICATION_LOTE_SEND VARCHAR2(200),
  TYPE_NOTIFICATION         NUMBER not null,
  ID_BATCH                  VARCHAR2(400),
  ID_ORD_ACCOUNT            VARCHAR2(10),
  ID_ORDER                  VARCHAR2(10) not null,
  MESSAGE_ID                VARCHAR2(10) not null,
  STATUS                    NUMBER,
  DESCRIPTION               VARCHAR2(300),
  CREATED_DT                DATE not null,
  INACTIVE_DT               DATE
);
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_CONTROL_NOTIFICATION
  add constraint PK_ID_NOTIFICATION primary key (ID_NOTIFICATION, ID_NOTIFICATION_LOTE)
  using index;
-- Create/Recreate indexes
create index INDEX_ID_ORD on OMPROD.OM_CONTROL_NOTIFICATION (ID_ORDER);
create index INDEX_ID_ORD_ACCOUNT on OMPROD.OM_CONTROL_NOTIFICATION (ID_ORD_ACCOUNT);
create unique index UNIQUE_OM_CONTROL on OMPROD.OM_CONTROL_NOTIFICATION (ID_NOTIFICATION);
