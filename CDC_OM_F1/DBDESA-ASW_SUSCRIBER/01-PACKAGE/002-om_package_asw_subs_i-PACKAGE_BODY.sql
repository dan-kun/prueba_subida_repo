CREATE OR REPLACE package body ASW_SUSCRIBER.om_package_asw_subs_i is

PROCEDURE DESAFFILIATE_LINE (P_PORTAL_USER_ID  IN VARCHAR2,
                             ERROR_ID         OUT NUMBER,
                             ERROR_DESCR      OUT VARCHAR2) IS

BEGIN
  --
  ERROR_ID    := 0;
  ERROR_DESCR := 'Ejecuci?n exitosa';
  --  Borrar Correo del suscriptor
  DELETE FROM user_contract
  WHERE PORTAL_USER_ID = P_PORTAL_USER_ID;

   IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_PORTAL_USER_ID;
    Raise_Application_Error( error_id, error_descr);
   END IF;


  -- Borrar registro del autenticador
  DELETE  FROM portal_user
  WHERE PORTAL_USER_ID = P_PORTAL_USER_ID;

  IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_PORTAL_USER_ID;
    Raise_Application_Error( error_id, error_descr);
  END IF;

  -- Se confirma el cambio
  DELETE  from  portal_user_new
  WHERE PORTAL_USER_ID = P_PORTAL_USER_ID;

  IF SQL%NOTFOUND THEN
    error_id := -20000;
    error_descr := 'No existe el gsm afiliado: ' || P_PORTAL_USER_ID;
    Raise_Application_Error( error_id, error_descr);
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    ERROR_ID    := SQLCODE;
    ERROR_DESCR := '[om_package_ASW_SUBS_I.DESAFFILIATE_LINE]: ' || SQLERRM;

END DESAFFILIATE_LINE;

end om_package_ASW_SUBS_I;
/