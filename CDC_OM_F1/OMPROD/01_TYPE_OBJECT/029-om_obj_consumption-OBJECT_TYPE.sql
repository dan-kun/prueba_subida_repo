CREATE OR REPLACE TYPE OMPROD.om_obj_consumption AS OBJECT
(
  co_code               VARCHAR2(10),
  msisdn                VARCHAR2(144),
  tm_code               VARCHAR2(144),
  threshold_id          VARCHAR2(10),
  th_consumption        NUMBER,
  th_unit               VARCHAR2(144),
  list_ord_item         OMPROD.om_list_ord_item
);