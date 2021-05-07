-- Create table
create table OMPROD.OM_ORD_ACCOUNT
(
  ID_ORD_ACCOUNT        VARCHAR2(10) not null,
  ID_ORD_TYPE           VARCHAR2(10) not null,
  CUS_TYPE_ID           VARCHAR2(10),
  CUS_NUM_ID            VARCHAR2(50),
  ID_BILLING            VARCHAR2(10) not null,
  ID_BILLING_ACCOUNT    VARCHAR2(10),
  ORD_ACN_STATUS        NUMBER not null,
  ORD_ACN_STATUS_MSG    VARCHAR2(255),
  CUSTOMER_NAME         VARCHAR2(255),
  PRGCODE               VARCHAR2(10),
  OPEN_AMOUNT           NUMBER,
  INSTALLMENT_AMOUNT    NUMBER,
  INVOICE_NUMBER        VARCHAR2(144),
  INV_BILLINGDATE       DATE,
  INV_DUEDATE           DATE,
  INS_DUEDATE           DATE,
  EMAIL                 VARCHAR2(255),
  RECONNECTION_CHARGE   NUMBER,
  ADMINISTRATIVE_CHARGE NUMBER,
  CREATED_DT            DATE not null,
  CREATED_WHO           VARCHAR2(20) not null,
  ACTIVE_DT             DATE not null,
  CHANGE_DT             DATE not null,
  CHANGE_WHO            VARCHAR2(20) not null,
  INACTIVE_DT           DATE,
  ACK                   VARCHAR2(50)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table OMPROD.OM_ORD_ACCOUNT
  add constraint PK_ORD_ACCOUNT primary key (ID_ORD_ACCOUNT)
  using index;
alter table OMPROD.OM_ORD_ACCOUNT
  add constraint FK_ORD_ACCOUNT foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
alter table OMPROD.OM_ORD_ACCOUNT
  add constraint FK_ORD_ACCOUNT1 foreign key (ID_BILLING)
  references OMPROD.CFG_BILLING (ID_BILLING);
alter table OMPROD.OM_ORD_ACCOUNT
  add constraint FK_ORD_PRGCODE foreign key (PRGCODE)
  references OMPROD.CFG_PRGCODE (ID_PRGCODE);
alter table OMPROD.OM_ORD_ACCOUNT
  add constraint FK_ORD_STATUS_PROCESS foreign key (ORD_ACN_STATUS)
  references OMPROD.CFG_STATUS_PROCESS (ID_STATUS);
