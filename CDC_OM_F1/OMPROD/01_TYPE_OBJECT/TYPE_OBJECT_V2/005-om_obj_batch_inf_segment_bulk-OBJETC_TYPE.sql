CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_segment_bulk AS OBJECT(ID_ACCOUNT                  VARCHAR2(30),
                                                               ID_CONTRACT                 VARCHAR2(30),
                                                               GSM                         VARCHAR2(20),
                                                               DESCRIPTION_SEGMENTATION    VARCHAR2(50),
                                                               ACTION_LEVEL                NUMBER);