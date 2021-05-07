CREATE OR REPLACE package body boton_pago.om_package_bdp_i is

PROCEDURE DESAFFILIATE_LINE (P_GSM_EMAIL_ID  IN VARCHAR2,
                             ERROR_ID         OUT NUMBER,
                             ERROR_DESCR      OUT VARCHAR2) IS

BEGIN
  --
  ERROR_ID    := 0;
  ERROR_DESCR := 'Ejecuci?n exitosa';
  --  Borrar preguntas de Seguridad
  DELETE FROM challenge_question_pb
  WHERE GSM_EMAIL_ID = P_GSM_EMAIL_ID;

   IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_GSM_EMAIL_ID;
    Raise_Application_Error( error_id, error_descr);
   END IF;
  -- ?  Borrar GSM afiliados (pago/recarga a 3ros)
  DELETE FROM membership_service_pb
  WHERE GSM_EMAIL_ID = P_GSM_EMAIL_ID;

   IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_GSM_EMAIL_ID;
    Raise_Application_Error( error_id, error_descr);
   END IF;
  --  ?  Borrar GSM afiliados (pago/recarga a 3ros)
  DELETE FROM payment_method_pb
  WHERE GSM_EMAIL_ID = P_GSM_EMAIL_ID;

   IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_GSM_EMAIL_ID;
    Raise_Application_Error( error_id, error_descr);
   END IF;
  -- ?  Borrar el registro de intentos fallidos para las preguntas de seguridad del usuario
  DELETE FROM user_pb
  WHERE GSM_EMAIL_ID = P_GSM_EMAIL_ID;

   IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_GSM_EMAIL_ID;
    Raise_Application_Error( error_id, error_descr);
   END IF;
  -- Se confirma los cambios
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    ERROR_ID    := SQLCODE;
    ERROR_DESCR := '[om_package_BDP_I.DESAFFILIATE_LINE]: ' || SQLERRM;

END DESAFFILIATE_LINE;

end om_package_BDP_I;
/