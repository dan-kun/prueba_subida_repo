CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_susp AS OBJECT(ID_BILLING_ACCOUNT          VARCHAR2(20),
                                                       ID_ORD_TYPE                 VARCHAR2(20),
                                                       IS_ORD_TIPY_ACTIONABLE      VARCHAR2(20),
                                                       ID_CONTRACT                 VARCHAR2(20),
                                                       GSM                         VARCHAR2(20),
                                                       SIMCARD                     VARCHAR2(20),
                                                       IMSI                        VARCHAR2(20),
                                                       ID_PLAN                     VARCHAR2(20),
                                                       TYPE_SIM                    VARCHAR2(20));