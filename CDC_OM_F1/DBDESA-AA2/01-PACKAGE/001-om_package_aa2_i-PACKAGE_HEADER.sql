CREATE OR REPLACE package AA2.om_package_aa2_i is

  -- Author  : CRISTANCHO!
  -- Created :26.10.2020 09:36
  -- Purpose : Paquete para el proceso de desafiliacion de una linea prepago

--
PROCEDURE DESAFFILIATE_LINE (V_GSM  IN VARCHAR2,
                             ERROR_ID         OUT NUMBER,
                             ERROR_DESCR      OUT VARCHAR2);
--

end om_package_AA2_I;
/