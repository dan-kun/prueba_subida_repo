CREATE OR REPLACE TYPE OMPROD.om_obj_get_ord_account AS OBJECT
(
  id_ord_account           VARCHAR2(10),
  id_ord_type              VARCHAR2(10),
  cus_type_id              VARCHAR2(10),
  cus_num_id               VARCHAR2(50),
  id_billing               VARCHAR2(10),
  id_billing_account       VARCHAR2(10),
  ord_acn_status           NUMBER,
  ord_acn_status_msg       VARCHAR2(255),
  customer_name            VARCHAR2(255),
  prgcode                  VARCHAR2(10),
  open_amount              NUMBER,
  installment_amount       NUMBER,
  invoice_number           VARCHAR2(144),
  inv_billingdate          DATE,
  inv_duedate              DATE,
  ins_duedate              DATE,
  email                    VARCHAR2(255),
  reconnection_charge      NUMBER,
  administrative_charge    NUMBER,
  list_get_account_process OMPROD.om_list_get_account_process
);