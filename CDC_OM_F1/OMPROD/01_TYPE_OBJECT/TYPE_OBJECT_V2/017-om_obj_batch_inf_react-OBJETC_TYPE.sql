CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_react AS OBJECT(ID_BILLING_ACCOUNT          VARCHAR2(20),
                                                        ID_CONTRACT                 VARCHAR2(20),
                                                        GSM                         VARCHAR2(20),
                                                        SIMCARD                     VARCHAR2(20),
                                                        IMSI                        VARCHAR2(20),
                                                        ID_PLAN                     VARCHAR2(20),
                                                        ID_PACKAGE                  VARCHAR2(20),
                                                        ID_SERVICE                  VARCHAR2(20));