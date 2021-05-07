CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_notifi AS OBJECT(ID_BILLING_ACCOUNT          VARCHAR2(20),
                                                         ID_CONTRACT                 VARCHAR2(20),
                                                         GSM                         VARCHAR2(20),
                                                         EMAIL                       VARCHAR2(50),
                                                         TYPE_NOTIFICATION           NUMBER,
                                                         MESSAGE_ID                  VARCHAR2(20));