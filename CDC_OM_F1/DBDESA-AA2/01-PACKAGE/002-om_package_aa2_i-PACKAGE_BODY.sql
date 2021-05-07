CREATE OR REPLACE package body AA2.om_package_aa2_i is

PROCEDURE DESAFFILIATE_LINE (V_GSM  IN VARCHAR2,
                             ERROR_ID         OUT NUMBER,
                             ERROR_DESCR      OUT VARCHAR2) IS

BEGIN
  --
  ERROR_ID    := 0;
  ERROR_DESCR := 'Ejecuci?n exitosa';
  --  Borrar Correo del suscriptor
  DELETE FROM subscriber_attribute
  WHERE SUBSCRIBER_ID = V_GSM;

   IF SQL%NOTFOUND THEN
      error_id := -20000;
      error_descr := 'No existe el gsm afiliado: ' || V_GSM;
      Raise_Application_Error( error_id, error_descr);
   END IF;

  -- Borrar registro del autenticador
  DELETE  FROM subscriber
  WHERE SUBSCRIBER_ID = V_GSM;

   IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || V_GSM;
    Raise_Application_Error( error_id, error_descr);
   END IF;

  --  Se confirman los cambios
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    ERROR_ID    := SQLCODE;
    ERROR_DESCR := '[om_package_AA2_I.DESAFFILIATE_LINE]: ' || SQLERRM;

END DESAFFILIATE_LINE;

end om_package_AA2_I;
/