CREATE OR REPLACE TYPE OMPROD.om_obj_get_process AS OBJECT
(
  id_order                 VARCHAR2(10),
  id_ord_process           VARCHAR2(10),
  order_process_status     NUMBER,
  order_process_status_msg VARCHAR2(255)
);