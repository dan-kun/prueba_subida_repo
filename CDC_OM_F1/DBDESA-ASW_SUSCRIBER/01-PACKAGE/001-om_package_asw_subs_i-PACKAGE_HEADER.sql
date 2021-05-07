CREATE OR REPLACE package ASW_SUSCRIBER.om_package_asw_subs_i is

  -- Author  : CRISTANCHO!
  -- Created : 26.10.2020 09:46
  -- Purpose : Paquete para el proceso de desafiliacion de una linea prepago

--
PROCEDURE DESAFFILIATE_LINE (P_PORTAL_USER_ID  IN VARCHAR2,
                             ERROR_ID         OUT NUMBER,
                             ERROR_DESCR      OUT VARCHAR2);
--

end om_package_ASW_SUBS_I;
/