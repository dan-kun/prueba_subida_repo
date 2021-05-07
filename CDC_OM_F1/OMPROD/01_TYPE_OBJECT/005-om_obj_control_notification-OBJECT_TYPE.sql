CREATE OR REPLACE TYPE OMPROD.om_obj_control_notification AS OBJECT
(
  id_notification              VARCHAR2(200), -- id unico para cada transaccion
  id_notification_lote_send    VARCHAR2(200), -- id del lote enviado
  gsm                          VARCHAR2(20),
  sms                          VARCHAR2(200)
);