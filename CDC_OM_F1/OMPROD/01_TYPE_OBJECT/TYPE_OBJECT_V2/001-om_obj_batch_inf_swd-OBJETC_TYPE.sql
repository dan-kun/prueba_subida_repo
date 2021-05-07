CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_swd AS OBJECT
(
  id_transaction          VARCHAR2(10),
  id_billing_account      VARCHAR2(20),
  id_contract             VARCHAR2(20),
  gsm                     VARCHAR2(20),
  simcard                 VARCHAR2(20),
  imsi                    VARCHAR2(20),
  date_process            VARCHAR2(20),
  date_simswap            VARCHAR2(20)
);