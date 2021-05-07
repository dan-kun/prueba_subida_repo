-- Create table
create table OMPROD.OM_BATCH_SEGMENTATION
(
  ID_ACCOUNT               VARCHAR2(30) not null,
  ID_CONTRACT              VARCHAR2(30),
  GSM                      VARCHAR2(15),
  DESCRIPTION_SEGMENTATION VARCHAR2(50) not null,
  ACTION_LEVEL             NUMBER not null
)