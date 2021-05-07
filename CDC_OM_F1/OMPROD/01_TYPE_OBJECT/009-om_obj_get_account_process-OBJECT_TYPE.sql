CREATE OR REPLACE TYPE OMPROD.om_obj_get_account_process AS OBJECT
(
  id_ord_account                 VARCHAR2(10),
  id_ord_account_process         VARCHAR2(10),
  ord_account_process_status     NUMBER,
  ord_account_process_status_msg VARCHAR2(255)
);