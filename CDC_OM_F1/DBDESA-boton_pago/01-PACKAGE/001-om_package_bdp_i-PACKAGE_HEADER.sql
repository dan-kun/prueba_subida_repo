CREATE OR REPLACE package boton_pago.om_package_bdp_i is

  -- Author  : CRISTANCHO!
  -- Created : om_package_AA2_I
  -- Purpose : Paquete para el proceso de desafiliacion de una linea prepago

--
PROCEDURE DESAFFILIATE_LINE (P_GSM_EMAIL_ID  IN VARCHAR2,
                             ERROR_ID         OUT NUMBER,
                             ERROR_DESCR      OUT VARCHAR2);
--

end om_package_BDP_I;
/