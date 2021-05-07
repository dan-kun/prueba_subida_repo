CREATE OR REPLACE TYPE OMPROD.om_obj_notification AS OBJECT
(
  id_batch                VARCHAR2(10),
  id_ord_account          VARCHAR2(10),
  id_order                VARCHAR2(10),
  message_id              VARCHAR2(144)
);