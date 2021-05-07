-- Create table
create table OMPROD.OM_ORDER
(
  ID_ORDER                VARCHAR2(10) not null,
  ID_ORD_TYPE             VARCHAR2(10) not null,
  ID_ORD_ACCOUNT          VARCHAR2(10),
  CUS_TYPE_ID             VARCHAR2(10),
  CUS_NUM_ID              VARCHAR2(50),
  ID_BILLING              VARCHAR2(10) not null,
  ID_BILLING_ACCOUNT      VARCHAR2(10),
  CO_CODE                 VARCHAR2(10) not null,
  MSISDN                  VARCHAR2(144) not null,
  ORDER_STATUS            NUMBER not null,
  ORDER_STATUS_MSG        VARCHAR2(400),
  ID_EXTERNAL_APP_ERR     VARCHAR2(10),
  ID_EXTERNAL_APP_ERR_MSG VARCHAR2(255),
  CUSTOMER_NAME           VARCHAR2(255),
  PRGCODE                 VARCHAR2(10),
  OPEN_AMOUNT             NUMBER,
  INSTALLMENT_AMOUNT      NUMBER,
  INVOICE_NUMBER          VARCHAR2(144),
  INV_BILLINGDATE         DATE,
  INV_DUEDATE             DATE,
  INS_DUEDATE             DATE,
  EMAIL                   VARCHAR2(255),
  RECONNECTION_CHARGE     NUMBER,
  ADMINISTRATIVE_CHARGE   NUMBER,
  THRESHOLD_ID            VARCHAR2(10),
  TH_CONSUMPTION          NUMBER,
  TH_UNIT                 VARCHAR2(144),
  CREATED_DT              DATE not null,
  CREATED_WHO             VARCHAR2(20) not null,
  ACTIVE_DT               DATE not null,
  CHANGE_DT               DATE not null,
  CHANGE_WHO              VARCHAR2(20) not null,
  INACTIVE_DT             DATE,
  ACK                     VARCHAR2(50),
  TM_CODE                 VARCHAR2(200)
);
-- Add comments to the columns
comment on column OMPROD.OM_ORDER.ID_ORDER
  is 'ID DE LA ORDEN';
-- Create/Recreate primary, unique and foreign key constraints
alter table OMPROD.OM_ORDER
  add constraint PK_OM_ORDER primary key (ID_ORDER)
  using index;
alter table OMPROD.OM_ORDER
  add constraint FK_OM_ORDER foreign key (ID_ORD_TYPE)
  references OMPROD.CFG_ORD_TYPES (ID_ORD_TYPE);
alter table OMPROD.OM_ORDER
  add constraint FK_OM_ORDER1 foreign key (ID_BILLING)
  references OMPROD.CFG_BILLING (ID_BILLING);
alter table OMPROD.OM_ORDER
  add constraint FK_OM_PRGCODE foreign key (PRGCODE)
  references OMPROD.CFG_PRGCODE (ID_PRGCODE);
alter table OMPROD.OM_ORDER
  add constraint FK_OM_STATUS_PROCESS foreign key (ORDER_STATUS)
  references OMPROD.CFG_STATUS_PROCESS (ID_STATUS);
