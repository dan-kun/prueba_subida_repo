CREATE OR REPLACE TYPE OMPROD.om_obj_batch_ord_account AS OBJECT
(
  id_billing_account    VARCHAR2(10),
  customer_name         VARCHAR2(30),
  cus_type_id           VARCHAR2(10),
  cus_num_id            VARCHAR2(50),
  email                 VARCHAR2(30),
  prgcode               VARCHAR2(10),
  open_amount           NUMBER,
  installment_amount    NUMBER,
  invoice_number        VARCHAR2(144),
--  inv_billingdate       DATE,
--  inv_duedate           DATE,
--  ins_duedate           DATE,
  inv_billingdate       VARCHAR2(50),
  inv_duedate           VARCHAR2(50),
  ins_duedate           VARCHAR2(50),
  reconnection_charge   NUMBER,
  administrative_charge NUMBER,
  list_order            OMPROD.om_list_batch_ord
);