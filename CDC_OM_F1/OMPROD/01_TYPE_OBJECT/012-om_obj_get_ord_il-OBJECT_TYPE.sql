CREATE OR REPLACE TYPE OMPROD.om_obj_get_ord_il AS OBJECT
(
  id_order          VARCHAR2(10),
  id_order_il       VARCHAR2(10),
  il_order_no       VARCHAR2(20),
  il_task_no        VARCHAR2(20),
  ord_il_status     NUMBER,
  ord_il_status_msg VARCHAR2(250)
);