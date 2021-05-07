CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_change_pm AS OBJECT(ID_BILLING_ACCOUNT VARCHAR2(20),
                                                            ID_CONTRACT_PUBLIC VARCHAR2(20),
                                                            GSM                VARCHAR2(20),
                                                            ID_PLAN_PUBLIC     VARCHAR2(10),
                                                            ID_PLAN_PRIVATE    VARCHAR2(10),
                                                            DESCRIPTION_PLAN   VARCHAR2(50),
                                                            CHANGE_PLAN_DELAY  NUMBER,
                                                            DATE_OPERATION     VARCHAR2(20));