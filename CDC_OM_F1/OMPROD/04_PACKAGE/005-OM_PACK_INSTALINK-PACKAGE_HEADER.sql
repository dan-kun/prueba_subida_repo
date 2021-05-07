create or replace package OMPROD.OM_PACK_INSTALINK is

  -- Author  : KMG
  -- Created : 09/09/2020 08:32:05 p.m.
  -- Purpose : Paquete que contendra toda la logica de negocios relacionada a INSTALINK

  PROCEDURE GET_XML_IL   (P_ID_ORDER_IL      VARCHAR,
                          P_XML              OUT CLOB,
                          ERROR_ID           OUT NUMBER,
                          ERROR_DESCR        OUT VARCHAR2); 

PROCEDURE PREPARE_ORDER_IL   (P_ID_ORDER             VARCHAR2,
                              ERROR_ID               OUT NUMBER,
                              ERROR_DESCR            OUT VARCHAR2);                           

PROCEDURE GET_SIM_TYPE   (P_IMSI                  VARCHAR2,
                          P_SIM_TYPE             OUT NUMBER,
                          ERROR_ID               OUT NUMBER,
                          ERROR_DESCR            OUT VARCHAR2);

end OM_PACK_INSTALINK;
/