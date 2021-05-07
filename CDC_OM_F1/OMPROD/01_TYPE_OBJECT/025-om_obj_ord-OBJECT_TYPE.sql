CREATE OR REPLACE TYPE OMPROD.om_obj_ord AS OBJECT
(
  cus_type_id             VARCHAR2(10),
  cus_num_id              VARCHAR2(50),
  co_code                 VARCHAR2(10),
  msisdn                  VARCHAR2(144),
  email                   VARCHAR2(255),  -- eliminar email por usuario
  list_ord_item           OMPROD.om_list_ord_item
);