CREATE OR REPLACE TYPE OMPROD.om_obj_ord_account AS OBJECT
(
  cus_type_id           VARCHAR2(10),
  cus_num_id            VARCHAR2(50),
  prgcode               VARCHAR2(10),
  open_amount           NUMBER,
  installment_amount    NUMBER,
  invoice_number        VARCHAR2(144),
  inv_billingdate       DATE,
  inv_duedate           DATE,
  ins_duedate           DATE,
--  inv_billingdate     VARCHAR2(50),
--  inv_duedate         VARCHAR2(50),
--  ins_duedate         VARCHAR2(50),
  reconnection_charge   NUMBER,
  administrative_charge NUMBER
);