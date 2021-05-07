CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_presement AS OBJECT(ID_BILLING_ACCOUNT VARCHAR2(20),
                                                            PRGCODE            VARCHAR2(10),
                                                            BILLCICLE          VARCHAR2(10),
                                                            PAYMENT_METHOD     VARCHAR2(20),
                                                            ID_CONTRACT        VARCHAR2(20),
                                                            GSM                VARCHAR2(20),
                                                            EMAIL              VARCHAR2(30),
                                                            ID_PLAN            VARCHAR2(20),
                                                            DATE_OPERATION     VARCHAR2(20));