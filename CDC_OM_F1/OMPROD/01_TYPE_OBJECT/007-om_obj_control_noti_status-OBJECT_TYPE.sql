CREATE OR REPLACE TYPE OMPROD.om_obj_control_noti_status AS OBJECT
(
  id_notification              VARCHAR2(200), -- id unico para cada transaccion
  id_notification_lote_send    VARCHAR2(200), -- id del lote enviado
  status                       number,
  descripcion                  VARCHAR2(200)
);
