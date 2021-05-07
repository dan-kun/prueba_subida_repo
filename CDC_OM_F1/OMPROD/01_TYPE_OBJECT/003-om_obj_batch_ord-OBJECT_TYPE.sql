CREATE OR REPLACE TYPE OMPROD.om_obj_batch_ord AS OBJECT
(
  id_billing_account      VARCHAR2(10),
  customer_name           VARCHAR2(30),
  cus_type_id             VARCHAR2(10),
  cus_num_id              VARCHAR2(50),
  co_code                 VARCHAR2(10),
  msisdn                  VARCHAR2(144),
  email                   VARCHAR2(255),
  list_ord_item           OMPROD.om_list_ord_item
);
