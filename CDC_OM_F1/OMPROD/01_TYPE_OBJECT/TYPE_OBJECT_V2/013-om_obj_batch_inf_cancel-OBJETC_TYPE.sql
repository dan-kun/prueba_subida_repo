CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_cancel AS OBJECT(ID_BILLING_ACCOUNT          VARCHAR2(20),
                                                         ID_CONTRACT                 VARCHAR2(20),
                                                         ID_PLAN                     VARCHAR2(20),
                                                         GSM                         VARCHAR2(20),
                                                         SIMCARD                     VARCHAR2(20),
                                                         IMSI                        VARCHAR2(20),
                                                         LEVEL_CANCELLATION          NUMBER,
                                                         DESCRIPTION_OPERATION       VARCHAR2(50),
                                                         TYPE_SIM                    VARCHAR2(20));