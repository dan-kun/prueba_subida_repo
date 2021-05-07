CREATE OR REPLACE package body OMPRD.om_pack_order_administration AS

  PROCEDURE get_batch_change_plan (         v_data_change_plan out sys_refcursor,
                                            error_id           out number,
                                            error_descr        out varchar2)
  IS
  BEGIN

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

      open v_data_change_plan for
           SELECT * FROM OM_BATCH_CHANGE_PLAN A ORDER BY A.ID_BILLING_ACCOUNT;

    exception
      when no_data_found then
        error_id    := -50001;
        error_descr := '[om_pack_order_administration.get_batch_change_plan]';
      when others then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_batch_change_plan]';

  END get_batch_change_plan;

  PROCEDURE get_batch_change_segmentation (   v_data_change_segmentation out sys_refcursor,
                                                  error_id           out number,
                                                  error_descr        out varchar2)
  IS
  BEGIN

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

      open v_data_change_segmentation for
           SELECT * FROM OM_BATCH_SEGMENTATION A ORDER BY A.id_account;

    exception
      when no_data_found then
        error_id    := -50002;
        error_descr := '[om_pack_order_administration.get_batch_change_segmentation]';
      when others then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_batch_change_segmentation]';

  END get_batch_change_segmentation;

  PROCEDURE get_batch_simswap_delay (               v_data_simswap_delay out sys_refcursor,
                                                    error_id             out number,
                                                    error_descr          out varchar2)
    IS
    BEGIN

       error_id    := 0;
      error_descr := 'ejecucion exitosa';

        open v_data_simswap_delay for
            SELECT * FROM OM_BATCH_SIMSWAP_DELAY WHERE processed IS NULL OR Upper(processed) = 'NO' ;

      exception
        when no_data_found then
          error_id    := -50002;
          error_descr := '[om_pack_order_administration.get_batch_simswap_delay]';
        when others then
          error_id    := -50000;
          error_descr := '[om_pack_order_administration.get_batch_simswap_delay]';

    END get_batch_simswap_delay;

    PROCEDURE get_batch_occ (               v_data_occ out sys_refcursor,
                                                        error_id             out number,
                                                        error_descr          out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

        open v_data_occ for
            SELECT * FROM OM_BATCH_OCC  ;

      exception
        when no_data_found then
          error_id    := -50002;
          error_descr := '[om_pack_order_administration.get_batch_occ]';
        when others then
          error_id    := -50000;
          error_descr := '[om_pack_order_administration.get_batch_occ]';

    END get_batch_occ;

    PROCEDURE get_batch_generic_notification (        v_data_generic_notification out sys_refcursor,
                                                      error_id                    out number,
                                                      error_descr                 out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

        open v_data_generic_notification for
            SELECT * FROM om_batch_generic_notification  ;

      exception
        when no_data_found then
          error_id    := -50003;
          error_descr := '[om_pack_order_administration.get_batch_generic_notification]';
        when others then
          error_id    := -50000;
          error_descr := '[om_pack_order_administration.get_batch_generic_notification]';

    END get_batch_generic_notification;


   PROCEDURE update_batch_simswap_delay (           v_id_transaction         VARCHAR2,
                                                    v_id_batch               VARCHAR2,
                                                    v_id_ord_account         VARCHAR2,
                                                    v_id_ord                 VARCHAR2,
                                                    v_processed              VARCHAR2,
                                                    v_description            VARCHAR2,
                                                    error_id             out number,
                                                    error_descr          out varchar2)
    IS
    BEGIN

      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      UPDATE OM_BATCH_SIMSWAP_DELAY SET id_batch = v_id_batch, id_ord_account = v_id_ord_account,
      id_ord = v_id_ord, processed = v_id_ord , description = v_description
         WHERE id_transaction = v_id_transaction;

      IF SQL%NOTFOUND THEN
      error_id    := -50001;
      error_descr := 'No se actualiza nigun registro';
      END IF;

      exception
        when no_data_found then
          error_id    := -50003;
          error_descr := '[om_pack_order_administration.get_batch_simswap_delay]';
        when others then
          error_id    := -50000;
          error_descr := '[om_pack_order_administration.get_batch_simswap_delay]';

    END update_batch_simswap_delay;

  procedure get_notification (
                                    v_id_any_type_order   VARCHAR2,
                                    v_type_message        NUMBER, -- 0 sms / 1 email / 2 ambos
                                    v_message_id          VARCHAR2,
                                    v_response_sms        OUT VARCHAR2,
                                    v_response_email      OUT CLOB,
                                    v_issue               OUT VARCHAR2,
                                    v_group_prg_code      OUT VARCHAR2,
                                    error_id              out number,
                                    error_descr           out VARCHAR2
                                )
  IS
  v_id_ord_type             VARCHAR2(20) := NULL;
  v_sms_Generic             VARCHAR2(200) := NULL;
  v_parameter_table         VARCHAR2(200);
  v_parameter_replace_table VARCHAR2(200);
  v_table_using             VARCHAR2(50);
  v_table_using_condition   VARCHAR2(50);
  sql_statement             VARCHAR2(500) := NULL;
  BEGIN

    error_id := 0;
    error_descr := 'Ejecucion exitosa';

--    IF  ( v_type_message IN (1,2) ) THEN
--        ERROR_ID    := -20222;
--        ERROR_DESCR := 'La opcion 1,2 se encuentran en desarrollo';
--        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
--      END IF;


    IF v_type_message = 0 THEN

      om_pack_order_administration.get_sms(v_id_any_type_order, v_message_id, v_response_sms, error_id, error_descr );

    ELSIF v_type_message = 1 THEN

      om_pack_order_administration.get_email(v_id_any_type_order, v_message_id, v_response_email, v_issue, v_group_prg_code, error_id, error_descr);

    ELSIF v_type_message = 2 THEN

      om_pack_order_administration.get_sms(v_id_any_type_order, v_message_id, v_response_sms, error_id, error_descr );
      om_pack_order_administration.get_email(v_id_any_type_order, v_message_id, v_response_email, v_issue , v_group_prg_code,error_id, error_descr);

    ELSE

      ERROR_ID    := -20002;
      ERROR_DESCR := 'El valor de v_type_message debe ser 0 -> Sms | 1 -> email | 2 -> email/sms  ';
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);

    END IF;

    dbms_output.put_line('valor v_id_ord_type: ' || v_id_ord_type);

  EXCEPTION
    WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_order_administratiid_ord_accounton.get_notification] ' || SQLERRM;

  END get_notification;

  procedure get_sms (
                                  v_id_any_type_order   VARCHAR2,
                                  v_message_id          VARCHAR2,
                                  v_response_sms        OUT VARCHAR2,
                                  error_id              out number,
                                  error_descr           out VARCHAR2
                              )
  IS
  v_id_ord_type             VARCHAR2(20) := NULL;
  v_sms_Generic             VARCHAR2(200) := NULL;
  v_parameter_table         VARCHAR2(200);
  v_parameter_replace_table VARCHAR2(500);
  v_table_using             VARCHAR2(50);
  v_table_using_condition   VARCHAR2(50);
  sql_statement             VARCHAR2(500) := NULL;
  v_parameter_conf          NUMBER;
  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';

    BEGIN
      SELECT id_ord_type, message INTO v_id_ord_type, v_sms_Generic
        FROM      OM_ORD_ACCOUNT a
        left JOIN CFG_ORD_SMS b USING (id_ord_type) WHERE  id_ord_account = v_id_any_type_order AND Nvl(a.prgcode,'0') = Nvl(b.prgcode,'0')
        AND message_id = v_message_id
         ;

        v_table_using := 'from OM_ORD_ACCOUNT a';
        v_table_using_condition := 'WHERE a.id_ord_account =';

    EXCEPTION
      when no_data_found THEN
        BEGIN
          SELECT id_ord_type, message INTO v_id_ord_type ,v_sms_Generic
            FROM      OM_ORDER  a
            left JOIN CFG_ORD_SMS b USING (id_ord_type) WHERE  id_order = v_id_any_type_order AND Nvl(a.prgcode,'0') = Nvl(b.prgcode,'0')
            AND message_id = v_message_id
            ;

            v_table_using := 'from OM_ORDER a';
            v_table_using_condition := 'WHERE a.id_order =';

        EXCEPTION
          when no_data_found THEN
            ERROR_ID    := -20000;
            ERROR_DESCR := 'No se encontro coincidencias para el v_id_any_type_order: ' || v_id_any_type_order || ' en las tablas: OM_ORD_ACCOUNT|OM_ORDER'   ;
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
        END;
    END;

    IF  v_sms_Generic IS NULL THEN
      ERROR_ID    := -20001;
      ERROR_DESCR := 'No existe mensajes SMS configurados para la orden: ' || v_id_any_type_order || ' de tipo id_ord_type: ' || v_id_ord_type  ;
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END IF;

     select REGEXP_COUNT( v_sms_Generic, '@') INTO v_parameter_conf from dual;

    IF  (v_parameter_conf > 0)  THEN
      om_pack_order_administration.get_param_configuration_sms( v_sms_Generic, v_parameter_table, v_parameter_replace_table);

--      Dbms_Output.Put_Line('v_sms_Generic: ' || v_sms_Generic );
--      Dbms_Output.Put_Line('v_parameter_table: ' || v_parameter_table );
--      Dbms_Output.Put_Line('v_parameter_replace_table: ' || v_parameter_replace_table );
      sql_statement := ('select ' || v_parameter_replace_table || ' '
                                  || v_table_using || ' INNER JOIN CFG_ORD_SMS b on  (a.id_ord_type = b.id_ord_type) '
                                  || v_table_using_condition || ''''|| v_id_any_type_order || '''' || ' AND a.prgcode = b.prgcode'
                                  || ' AND B.message_id = '|| '''' || v_message_id || '''' );
      BEGIN
        EXECUTE IMMEDIATE sql_statement INTO v_response_sms;
      EXCEPTION
        WHEN Others THEN
        ERROR_ID    := -20002;
        ERROR_DESCR := 'Error obtenido: ' || SQLERRM || ' No se pudo realizar la consulta: ' || sql_statement  ;
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END;
      dbms_output.put_line('sql_statement v_id_ord_type: ' || sql_statement);
    ELSE
      v_response_sms :=  v_sms_Generic;
    END IF;

  EXCEPTION
    WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_order_administratiid_ord_accounton.get_sms] ' || SQLERRM;
  END get_sms;

  procedure get_email (
                      v_id_any_type_order   VARCHAR2,
                      v_message_id          VARCHAR2,
                      v_response_email      OUT CLOB,
                      v_issue               OUT VARCHAR2,
                      v_group_prg_code      OUT VARCHAR2,
                      error_id              out number,
                      error_descr           out VARCHAR2
                          )
  IS
  html_generic CLOB;
  numRep       NUMBER;
--  response_issue VARCHAR2(200);
  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';

    BEGIN

      SELECT html_template, issue, group_img INTO html_generic, v_issue, v_group_prg_code
        FROM      OM_ORD_ACCOUNT a
        left JOIN CFG_ORD_SMS b USING (id_ord_type) WHERE  id_ord_account = v_id_any_type_order AND Nvl(a.prgcode,'0') = b.prgcode  AND b.message_id = v_message_id;

      customize_email_template(v_id_any_type_order,html_generic,v_response_email,error_id,error_descr);

    EXCEPTION
      when no_data_found THEN
        BEGIN
          SELECT html_template, issue, group_img INTO html_generic, v_issue, v_group_prg_code
            FROM      OM_ORDER a
            left JOIN CFG_ORD_SMS b USING (id_ord_type) WHERE  id_order = v_id_any_type_order AND Nvl(a.prgcode,'0') = b.prgcode AND b.message_id = v_message_id ;

        customize_email_template(v_id_any_type_order,html_generic,v_response_email,error_id,error_descr);

        EXCEPTION
          when no_data_found THEN
            ERROR_ID    := -20000;
            ERROR_DESCR := 'No se encontro coincidencias para el v_id_any_type_order: ' || v_id_any_type_order || ' en las tablas: OM_ORD_ACCOUNT|OM_ORDER'   ;
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
        END;
    END;

    select REGEXP_COUNT( v_issue , '@') INTO numRep from dual;

    IF numRep != 0 THEN

      customize_email_template(v_id_any_type_order,v_issue,v_issue,error_id,error_descr);

    END IF;

  EXCEPTION
    WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_order_administration_ord_accounton.get_email] ' || SQLERRM;

  END get_email;

    procedure change_status_Account_order (
                                      v_id_ord_account      VARCHAR2,
                                      v_status_new          NUMBER,
                                      v_status_description  VARCHAR2,
                                      v_user                VARCHAR2,
                                      error_id              out number,
                                      error_descr           out VARCHAR2
                            )
    IS
    v_status_old number;
    BEGIN

      error_id := 0;
      error_descr := 'Ejecucion exitosa';

      BEGIN
        SELECT ord_acn_status INTO v_status_old FROM OM_ORD_ACCOUNT WHERE id_ord_account = v_id_ord_account;
      EXCEPTION
        WHEN No_Data_Found THEN
          ERROR_ID    := -20000;
          ERROR_DESCR := 'No se encontro el id_ord_account: ' || v_id_ord_account  ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END;

      IF v_user IS null THEN
        ERROR_ID    := -20001;
        ERROR_DESCR := 'Es requerido: v_user';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;

      IF v_status_new = 2 AND  v_status_old = 2   THEN
        NULL;
      ELSE
        om_pack_configuration.validate_life_cycle_for_states( v_status_new, v_status_old, error_id, error_descr );
        UPDATE OM_ORD_ACCOUNT SET
          ord_acn_status = v_status_new,
          ord_acn_status_msg = v_status_description,
          change_dt = SYSDATE,
          change_who = v_user
        WHERE id_ord_account = v_id_ord_account ;
        COMMIT;
      END IF;

      EXCEPTION
        WHEN Others THEN
          ROLLBACK;
          error_id    := SQLCODE;
          error_descr := '[om_pack_order_administration_ord_accounton.change_status_Account_order] ' || SQLERRM;
    END change_status_Account_order;


    procedure change_status_order(v_id_ord             VARCHAR2,
                                v_status_new         NUMBER,
                                v_status_description VARCHAR2,
                                v_user               VARCHAR2,
                                error_id             out number,
                                error_descr          out VARCHAR2) IS
    v_status_old            NUMBER;
    v_count_process_open    NUMBER;
    v_order_status_msg      OM_ORDER.order_status_msg%type;
    v_id_ord_account        OM_ORD_ACCOUNT.id_ord_account%type;
    v_data_om_order_account OM_ORD_ACCOUNT%ROWTYPE := null;
    v_count_order_open      NUMBER;
    v_id_order_type         VARCHAR2(20);
    v_id_transation_simsw   VARCHAR2(20);
    v_id_batch              VARCHAR2(29);
    BEGIN

      error_id    := 0;
      error_descr := 'Ejecucion exitosa';

      BEGIN
        SELECT order_status
          INTO v_status_old
          FROM OM_ORDER
        WHERE id_order = v_id_ord;
      EXCEPTION
        WHEN No_Data_Found THEN
          ERROR_ID    := -20000;
          ERROR_DESCR := 'No se encontro el id_order: ' || v_id_ord;
          RAISE_APPLICATION_ERROR(ERROR_ID, ERROR_DESCR);
      END;

      IF v_user IS null THEN
        ERROR_ID    := -20001;
        ERROR_DESCR := 'Es requerido: v_user';
        RAISE_APPLICATION_ERROR(ERROR_ID, ERROR_DESCR);
      END IF;

      --restricciones en el cambio de estatus para la orden
      om_pack_configuration.validate_life_cycle_for_states(v_status_new,
                                                          v_status_old,
                                                          error_id,
                                                          error_descr);

      IF v_status_new IN (0, 2) THEN
        -- restricion NO SE PUEDEN COMPLETAR ORDENES CON PROCESOS ABIERTOS  v_id_ord
        --restricciones en el cambio de estatus para la orden
        BEGIN
          SELECT Count(1)
            INTO v_count_process_open
            FROM OM_ORDER_PROCESS
          WHERE id_order = v_id_ord
            AND order_process_status NOT IN (0, 1, 2);
          IF v_count_process_open > 0 AND v_status_new = 0 THEN
            ERROR_ID    := -20010;
            ERROR_DESCR := 'No se puede completar ordenen: ' || v_id_ord ||
                          ' porque tiene: ' || v_count_process_open ||
                          ' proceso(s) sin completar';
            RAISE_APPLICATION_ERROR(ERROR_ID, ERROR_DESCR);
          END IF;
        EXCEPTION
          WHEN no_data_found THEN
            ERROR_ID    := -20009;
            ERROR_DESCR := 'Orden sin procesos: ' || v_id_ord;
            RAISE_APPLICATION_ERROR(ERROR_ID, ERROR_DESCR);
        END;
        -- restricion NO SE PUEDEN COMPLETAR ORDENES CON PROCESOS ABIERTOS  v_id_ord

        -- Cambio de estatus para la orden de tipo cuenta dependiendo de la orden de tipo contrato
        -- validacion si la orden pertenece a una orden de tipo cuenta
        BEGIN
          v_id_ord_account := NULL;
          select id_ord_account
            INTO v_id_ord_account
            FROM OM_ORDER
          WHERE id_order = v_id_ord;
        EXCEPTION
          WHEN Others THEN
            v_id_ord_account := NULL;
        END;
        -- validacion si la orden pertenece a una orden de tipo cuenta
        IF v_id_ord_account IS NOT NULL THEN

          BEGIN
            SELECT *
              INTO v_data_om_order_account
              FROM OM_ORD_ACCOUNT
            WHERE id_ord_account = v_id_ord_account;
          EXCEPTION
            WHEN Others THEN
              v_data_om_order_account := NULL;
          END;
          IF v_status_new = 0 THEN
          Dbms_Output.Put_Line(1);
            IF v_data_om_order_account.id_ord_account IS NOT NULL THEN
            Dbms_Output.Put_Line(2);
              IF v_data_om_order_account.ord_acn_status NOT IN (0, 2) THEN
              Dbms_Output.Put_Line(3);
              Dbms_Output.Put_Line(v_id_ord_account);
                SELECT Count(1)
                  INTO v_count_order_open
                  FROM om_order a
                WHERE id_ord_account = v_id_ord_account AND order_status != 0;
                IF v_count_order_open = 1 THEN
                Dbms_Output.Put_Line(4);
                  change_status_Account_order(v_id_ord_account,
                                              0,
                                              'Ord Exito',
                                              v_user,
                                              error_id,
                                              error_descr);
                END IF;
              END IF;
            END IF;
          ELSE
            -- CASO DE ORDEN EN ERROR
            Dbms_Output.Put_Line(11);
            IF v_data_om_order_account.id_ord_account IS NOT NULL THEN
            Dbms_Output.Put_Line(22);
              IF v_data_om_order_account.ord_acn_status NOT IN (0, 2) THEN
              Dbms_Output.Put_Line(33);
                change_status_Account_order(v_id_ord_account,
                                            2,
                                            'Ord Error',
                                            v_user,
                                            error_id,
                                            error_descr);
              END IF;
            END IF;
          END IF;
        END IF;

      END IF;
      -- Cambio de estatus para la orden de tipo cuenta dependiendo de la orden de tipo contrato CASO EXITOSO

      -- Manejo de estatus mssg
      BEGIN
        SELECT order_status_msg
          INTO v_order_status_msg
          FROM om_order
        WHERE id_order = v_id_ord;
        v_order_status_msg := v_order_status_msg || '->' ||
                              v_status_description;
        IF v_order_status_msg IS NULL THEN
          v_order_status_msg := v_status_description;
        END IF;
      EXCEPTION
        WHEN Others THEN
          ERROR_ID    := -20008;
          ERROR_DESCR := 'error con la orden: ' || v_id_ord;
          RAISE_APPLICATION_ERROR(ERROR_ID, ERROR_DESCR);
      END;
      -- Manejo de estatus mssg

      UPDATE OM_ORDER
        SET order_status     = v_status_new,
            order_status_msg = v_order_status_msg,
            change_dt        = SYSDATE,
            change_who       = v_user
      WHERE id_order = v_id_ord;

      -- manejo de las actualizacion para las ordenes BATCH de tipo simswap con DELAY

        BEGIN
        SELECT id_ord_type, id_ord_account
          INTO v_id_order_type, v_id_ord_account
        FROM om_order
          WHERE
          id_order = v_id_ord;
        EXCEPTION
          WHEN Others THEN
            v_id_order_type := NULL;
            v_id_ord_account := NULL;
        END;


        BEGIN     -- v_id_batch
          SELECT id_batch INTO v_id_batch FROM om_batch_control WHERE id_order = v_id_ord OR id_ord_account = v_id_ord_account AND ROWNUM <2;
        EXCEPTION
          WHEN Others THEN
            v_id_batch := NULL;
        END;

        IF v_id_order_type = 'OT-039' THEN
          BEGIN

              SELECT item_value
                INTO v_id_transation_simsw
              FROM OM_ORDER_ITEM
                WHERE
                          id_order = v_id_ord
                      AND id_ord_item_type = 'OIT-035';

                UPDATE om_batch_simswap_delay SET (processed) = (
                                                                  CASE v_status_new
                                                                      WHEN 0 THEN 'EXITO'
                                                                      WHEN 3 THEN 'EN PROCESO'
                                                                      WHEN 2 THEN 'ERROR'
                                                                      ELSE 'ERROR'
                                                                  END),
                                                   description = v_order_status_msg,
                                                   id_ord = v_id_ord,
                                                   id_ord_account = v_id_ord_account,
                                                   id_batch = v_id_batch
                WHERE id_transaction = v_id_transation_simsw ;

          EXCEPTION
            WHEN Others THEN
              NULL;
          END;
        END IF;
      -- manejo de las actualizacion para las ordenes BATCH de tipo simswap con DELAY

      COMMIT;

    EXCEPTION
      WHEN Others THEN
        ROLLBACK;
        error_id    := SQLCODE;
        error_descr := '[om_pack_order_administration.change_status_order] ' ||
                      SQLERRM;
    END change_status_order;



    procedure change_status_process (
                                    v_id_ord              VARCHAR2,
                                    v_id_ord_process      VARCHAR2,
                                    v_status_new          NUMBER,
                                    v_status_description  VARCHAR2,
                                    v_user                VARCHAR2,
                                    error_id              out number,
                                    error_descr           out VARCHAR2
                                    )
    IS
    v_status_old number;
    v_order_status_msg om_order.order_status_msg%type;
    BEGIN

      error_id := 0;
      error_descr := 'Ejecucion exitosa';

      BEGIN
        SELECT order_process_status INTO v_status_old FROM OM_ORDER_PROCESS WHERE id_order = v_id_ord AND id_ord_process = v_id_ord_process;
      EXCEPTION
        WHEN No_Data_Found THEN
          ERROR_ID    := -20002;
          ERROR_DESCR := 'No se encontro el id_ord_process: ' || v_id_ord_process || ' para la orden: ' || v_id_ord ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END;

      IF v_user IS null THEN
        ERROR_ID    := -20001;
        ERROR_DESCR := 'Es requerido: v_user';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;

      om_pack_configuration.validate_life_cycle_for_states( v_status_new, v_status_old, error_id, error_descr );

      UPDATE OM_ORDER_PROCESS SET
        order_process_status = v_status_new,
        order_process_status_msg = v_status_description,
        change_dt = SYSDATE,
        change_who = v_user
      WHERE id_order = v_id_ord AND id_ord_process = v_id_ord_process  ;

      BEGIN
        SELECT order_status_msg INTO v_order_status_msg FROM om_order WHERE id_order = v_id_ord;
        v_order_status_msg := v_order_status_msg || '->' || v_status_description;
        IF v_order_status_msg IS NULL  THEN
          v_order_status_msg :=  v_status_description  ;
        END  IF;
      EXCEPTION
        WHEN No_Data_found THEN
          ERROR_ID    := -20007;
          ERROR_DESCR := 'No se encontro el id_ord: ' || v_id_ord ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END;

      UPDATE om_order SET order_status_msg = v_order_status_msg WHERE id_order = v_id_ord;

      COMMIT;

    EXCEPTION
      WHEN Others THEN
        ROLLBACK;
        error_id    := SQLCODE;
        error_descr := '[om_pack_order_administration.change_status_process] ' || SQLERRM;
    end change_status_process;

    procedure change_status_account_process (
                                              v_id_ord_account         VARCHAR2,
                                              v_id_ord_account_process VARCHAR2,
                                              v_status_new             NUMBER,
                                              v_status_description     VARCHAR2,
                                              v_user                   VARCHAR2,
                                              error_id                 out number,
                                              error_descr              out VARCHAR2
                                      )
    IS
    v_status_old number;
    v_order_status_msg OM_ORD_ACCOUNT.ord_acn_status_msg%type;
    BEGIN
      error_id := 0;
      error_descr := 'Ejecucion exitosa';

      BEGIN
        SELECT ord_account_process_status INTO v_status_old FROM om_ord_account_process WHERE id_ord_account = v_id_ord_account AND id_ord_account_process = v_id_ord_account_process;
      EXCEPTION
        WHEN No_Data_Found THEN
          ERROR_ID    := -20010;
          ERROR_DESCR := 'No se encontro el id_ord_account_process: ' || v_id_ord_account_process || ' para la orden_account: ' || v_id_ord_account ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END;

      IF v_user IS null THEN
        ERROR_ID    := -200011;
        ERROR_DESCR := 'Es requerido: v_user';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;

      om_pack_configuration.validate_life_cycle_for_states( v_status_new, v_status_old, error_id, error_descr );

      UPDATE om_ord_account_process SET
        ord_account_process_status = v_status_new,
        ord_account_process_status_msg = v_status_description,
        change_dt = SYSDATE,
        change_who = v_user
      WHERE id_ord_account = v_id_ord_account AND id_ord_account_process = v_id_ord_account_process  ;

      BEGIN
        SELECT ord_acn_status_msg INTO v_order_status_msg FROM OM_ORD_ACCOUNT WHERE id_ord_account = v_id_ord_account;
        v_order_status_msg := v_order_status_msg || '->' || v_status_description;
        IF v_order_status_msg IS NULL  THEN
          v_order_status_msg :=  v_status_description  ;
        END  IF;
      EXCEPTION
        WHEN No_Data_found THEN
          ERROR_ID    := -200011;
          ERROR_DESCR := 'No se encontro el id_ord_account: ' || v_id_ord_account ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END;

      UPDATE OM_ORD_ACCOUNT SET ord_acn_status_msg = v_order_status_msg WHERE id_ord_account = v_id_ord_account;

      COMMIT;

    EXCEPTION
      WHEN Others THEN
        ROLLBACK;
        error_id    := SQLCODE;
        error_descr := '[om_pack_order_administration.change_status_account_process] ' || SQLERRM;

    END change_status_account_process;

    procedure create_order            (
                                        v_id_ord_type          VARCHAR2,            -- PD
                                        v_id_billing           varchar2,            -- PD
                                        v_id_billing_account   VARCHAR2,            -- PD
                                        v_user                 VARCHAR2,            -- PD
                                        v_customer_name        VARCHAR2,            -- PD
                                        v_email                VARCHAR2,            -- PD
                                        v_ack                  VARCHAR2,            -- PD
                                        v_om_obj_ord_account   om_obj_ord_account,  -- D
                                        v_om_obj_consumption   om_obj_consumption,  -- P
                                        v_om_list_ord          om_list_ord,         -- D
                                        v_id_ord_account       IN OUT  VARCHAR2,
                                        v_id_ord               IN OUT  VARCHAR2,
                                        v_om_obj_get_all_order OUT om_obj_get_all_order,
                                        error_id               out number,
                                        error_descr            out VARCHAR2
                                        )
      IS

      v_order_level number := 0; --  0 cuenta || 1 contrato
      v_id_oi OM_ORDER_ITEM.id_order_item%TYPE := NULL;

      v_c_order_item_missing       sys_refcursor;
      v_all_order_item_missing     VARCHAR2(500);

      c1rec                        VARCHAR2(10);
      auxCont                      NUMBER := 0;

      v_get_order_level            NUMBER;
      v_get_id_ord_type            VARCHAR2(10);
      v_get_id_billing             VARCHAR2(10);
      v_get_id_billing_account     VARCHAR2(10);
      v_get_customer_name          VARCHAR2(255);
      v_get_email                  VARCHAR2(255);
      v_get_ack                    VARCHAR2(50);
      v_get_user                   VARCHAR2(50);
      v_get_om_obj_ord_account     om_obj_get_ord_account;
      v_get_om_list_get_ord        om_list_get_ord ;

      v_prgcode                    OM_ORD_ACCOUNT.prgcode%TYPE;
      v_prgcode_exist              NUMBER;

      v_isProcessInstalink         VARCHAR2(1) := '1' ; -- 1 = proceso de Instalink activo 0 = proceso instalink desactivado

      v_id_Plan                    VARCHAR2(20);
      v_is_sms_by_plan             VARCHAR2(1) := '1' ; -- 1 = proceso de envio de sms activo 0 = proceso envio de sms desactivado
      v_is_email_by_plan           VARCHAR2(1) := '1' ; -- 1 = proceso de envio de email activo 0 = proceso envio de email desactivado

--      v_error_validate_plan        NUMBER := 0 ;        -- 1 error validando

      v_CABLE VARCHAR2(50);

      v_active_cuoba VARCHAR2(50) := '1' ; -- 1 = activa el cuoba 0 = no se activa el cuoba
      BEGIN

        error_id := 0;
        error_descr := 'Ejecucion exitosa';

        BEGIN  -- validar que el order Item Exista
          select order_level INTO v_order_level from CFG_ORD_TYPES WHERE id_ord_type = v_id_ord_type;
        EXCEPTION
          WHEN No_Data_Found THEN
            ERROR_ID    := -20000;
            ERROR_DESCR := 'Sin coincidencias para el id_ord_type: ' || v_id_ord_type ;
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          WHEN Others THEN
            ERROR_ID    := -20001;
            ERROR_DESCR := 'Eror al manejar: ' || v_id_ord_type ;
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
        END;

        IF (v_order_level = 0 ) THEN   -- Ordenes de tipo cuenta

          IF v_om_obj_ord_account IS null THEN
            ERROR_ID    := -20002;
            ERROR_DESCR := 'Entrada requerida: "om_obj_ord_account"';
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          END IF;

          IF v_id_ord_account IS null THEN  -- validar si es una orden nueva o una carga de data

            SELECT 'OC-'|| om_seq_id_order_account.NEXTVAL INTO v_id_ord_account FROM dual;

            v_prgcode := v_om_obj_ord_account.prgcode;

            -- crear la nueva orden de tipo cuenta
            INSERT INTO om_ord_account
                VALUES(   v_id_ord_account,                              --  id_ord_account
                          v_id_ord_type,                                 --  id_ord_type
                          v_om_obj_ord_account.cus_type_id,              --  cus_type_id
                          v_om_obj_ord_account.cus_num_id,               --  cus_num_id
                          v_id_billing,                                  --  id_billing
                          v_id_billing_account,                          --  id_billing_account
                          5,                                             --  ord_acn_status
                          NULL,                                          --  ord_acn_status_msg
                          v_customer_name,                               --  customer_name
                          v_prgcode,                                     --  prgcode
                          v_om_obj_ord_account.open_amount,              --  open_amount
                          v_om_obj_ord_account.installment_amount,       --  installment_amount
                          v_om_obj_ord_account.invoice_number,           --  invoice_number
                          v_om_obj_ord_account.inv_billingdate,          --  inv_billingdate
                          v_om_obj_ord_account.inv_duedate,              --  inv_duedate
                          v_om_obj_ord_account.ins_duedate,              --  ins_duedate
                          v_email,                                       --  email
--                          'Kevinn_gomez@digitel.com.ve',
                          v_om_obj_ord_account.reconnection_charge,      --  reconnection_charge
                          v_om_obj_ord_account.administrative_charge,    --  administrative_charge
                          SYSDATE,                                       --  created_dt
                          v_user,                                        --  created_who
                          SYSDATE,                                       --  active_dt
                          SYSDATE,                                       --  change_dt
                          v_user,                                        --  change_who
                          NULL,                                          --  inactive_dt
                          v_ack                                          -- valor del ack
                );
          -- CREAR REGISTROS PARA LOS PROCESOS tipo cuenta
          BEGIN
              for i in (SELECT id_ord_account_process FROM cfg_ord_account_struct_process  WHERE id_ord_type = v_id_ord_type )
              LOOP
                INSERT INTO om_ord_account_process VALUES(
                    v_id_ord_account,              --id_ord_account,
                    i.id_ord_account_process,      --id_ord_account_process,
                    5,                             --ord_account_process_status,
                    NULL,                          --order_process_status_msg,
                    SYSDATE,                       --created_dt,
                    v_user,                        --created_who,
                    SYSDATE,                       --active_dt,
                    SYSDATE,                       --change_dt,
                    v_user,                        --change_who,
                    null                          --inactive_dt,
                );
              end loop;
            EXCEPTION
              WHEN Others THEN
                ERROR_ID    := -20006;
                ERROR_DESCR := 'Error al crear los procesos: ' || SQLERRM;
                RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          END;
          -- CREAR REGISTROS PARA LOS PROCESOS tipo cuenta
          -- Iniciar la orden y sus procesos
          UPDATE om_ord_account SET (ord_acn_status) = (4) WHERE id_ord_account = v_id_ord_account ;
          IF SQL%NOTFOUND THEN
            ERROR_ID    := -20007;
            ERROR_DESCR := 'la orden_account: '|| v_id_ord_account || ' No se pudo inicializar ' || SQLERRM;
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          END IF;
          UPDATE om_ord_account_process SET (ord_account_process_status) = (4) WHERE id_ord_account = v_id_ord_account;
          IF SQL%NOTFOUND THEN
          ERROR_ID    := -20007;
          ERROR_DESCR := 'No se encontraron procesos configurados a nivel cuenta para el id_ord_type: ' ||v_id_ord_type || ' v_id_ord_account: ' || v_id_ord_account || ' '|| SQLERRM;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          END IF;
        -- Iniciar la orden y sus procesos

        ELSE  -- el proceso corresponde a una carga de data

          IF v_om_list_ord IS NULL OR v_om_list_ord.Count = 0 THEN
            ERROR_ID    := -20012;
            ERROR_DESCR := 'Entrada requerida: "v_om_list_ord"';
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          END IF;

          SELECT prgcode INTO v_prgcode FROM om_ord_account WHERE id_ord_account = v_id_ord_account ;

          for i in v_om_list_ord.first .. v_om_list_ord.last LOOP

            SELECT 'OR-'|| om_seq_id_order.NEXTVAL INTO v_id_ord FROM dual;
            --dbms_output.put_line('external_id: '|| v_om_list_ord(i).msisdn);
            --dbms_output.put_line('reserve_status: '|| v_om_list_ord(i).cus_num_id);
            INSERT INTO OM_ORDER
              VALUES(
                v_id_ord,                                    -- id_order,
                v_id_ord_type,                               -- id_ord_type,
                v_id_ord_account,                            -- id_ord_account,
                v_om_list_ord(i).cus_type_id,                -- cus_type_id,
                v_om_list_ord(i).cus_num_id,                 -- cus_num_id,
                v_id_billing,                                -- id_billing,
                v_id_billing_account,                        -- id_billing_account,
                v_om_list_ord(i).co_code,                    -- co_code,
                v_om_list_ord(i).msisdn,                     -- msisdn,
                5,                                           -- order_status,
                NULL,                                        -- order_status_msg,
                NULL,                                        -- id_external_app_err,
                NULL,                                        -- id_external_app_err_msg,
                v_customer_name,                             -- customer_name,
                v_prgcode ,                                  -- prgcode, v_om_obj_ord_account.prgcode
                v_om_obj_ord_account.open_amount,            -- open_amount,
                v_om_obj_ord_account.installment_amount,     -- installment_amount,
                v_om_obj_ord_account.invoice_number,         -- invoice_number,
                v_om_obj_ord_account.inv_billingdate,        -- inv_billingdate,
                v_om_obj_ord_account.inv_duedate,            -- inv_duedate,
                v_om_obj_ord_account.ins_duedate,            -- ins_duedate,
                v_om_list_ord(i).email,                      -- email,
--                'Kevinn_gomez@digitel.com.ve',
                v_om_obj_ord_account.reconnection_charge,    -- reconnection_charge,
                v_om_obj_ord_account.administrative_charge,  -- administrative_charge,
                NULL,                                        -- threshold_id,    **********
                NULL,                                        -- th_consumption,  **********
                NULL,                                        -- th_unit,         **********
                SYSDATE,                                     -- created_dt,      **********
                v_user,                                      -- created_who,
                SYSDATE,                                     -- active_dt,
                SYSDATE,                                     -- change_dt,
                v_user,                                      -- who,
                NULL,                                        -- inactive_dt
                v_ack,                                       -- ack
                NULL                                         -- tm_code
              );

            -- Validacion de la estructura de la orden
            v_all_order_item_missing := NULL;

            open v_c_order_item_missing for
            SELECT id_ord_item_type  FROM CFG_ORD_STRUCT WHERE is_required = 1 AND inactive_dt IS NULL AND id_ord_type = v_id_ord_type
            MINUS
            SELECT id_ord_item_type FROM TABLE(v_om_list_ord(i).list_ord_item);

            BEGIN
	            LOOP
	                FETCH v_c_order_item_missing INTO c1rec;
	                EXIT WHEN v_c_order_item_missing%NOTFOUND;
                  v_all_order_item_missing := v_all_order_item_missing || '/' || c1rec ;
	            END LOOP;
	            CLOSE v_c_order_item_missing;
            END;

            Dbms_Output.put_line( 'Valores de order item faltantes: '|| v_all_order_item_missing  );

            IF v_all_order_item_missing IS NOT null THEN
              IF v_id_ord_type = 'OT-034' AND v_all_order_item_missing LIKE '%OIT-008' THEN
                UPDATE OM_ORDER
                  SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                      order_status       = 2,
                      order_status_msg   = 'Error la orden no tiene servicios a activar falta: ' || v_all_order_item_missing
                WHERE id_order = v_id_ord ;
              ELSE
                UPDATE OM_ORDER
                  SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                      order_status       = 2,
                      order_status_msg   = 'Error en la validacion de la estructura de la orden! es requerido: ' || v_all_order_item_missing
                WHERE id_order = v_id_ord ;
              END IF;
            ELSE
              -- CREAR REGISTROS PARA EL INVENTARIO
              BEGIN
                for j in v_om_list_ord(i).list_ord_item.first .. v_om_list_ord(i).list_ord_item.last LOOP

                  -- esto pertenece al cable
                  IF v_om_list_ord(i).list_ord_item(j).id_ord_item_type = 'OIT-005' THEN
--                    v_CABLE := '52';
                    v_CABLE := v_om_list_ord(i).list_ord_item(j).value_ord_item_type;
                  ELSE
                    v_CABLE := v_om_list_ord(i).list_ord_item(j).value_ord_item_type;
                  END IF;
                  -- esto pertenece al cable

                  SELECT 'OI-'|| om_seq_id_order_item.NEXTVAL INTO v_id_oi FROM dual;
                  INSERT INTO OM_ORDER_ITEM VALUES(
                    v_id_oi,                                                     -- id_order_item Auto Generado
                    v_id_ord,                                                    -- id_order
                    v_om_list_ord(i).list_ord_item(j).id_ord_item_type,      -- id_ord_item_type,
  --                  v_om_list_ord(i).list_ord_item(j).value_ord_item_type,   -- item_value,
                    v_CABLE,                                                   -- ELIMINAR CABLE
                    ' ',                                                         -- attr1_value,
                    ' ',                                                         -- attr2_value,
                    ' ',                                                         -- attr3_value,
                    4,                                                           -- order_item_status,
                    NULL,                                                        -- order_item_status_msg,
                    SYSDATE,                                                     -- created_dt,
                    v_user,                                                      -- created_who,
                    SYSDATE,                                                     -- active_dt,
                    SYSDATE,                                                     -- change_dt,
                    v_user,                                                      -- change_who,
                    null                                                         -- inactive_dt
                  );
                END LOOP;

              EXCEPTION
                WHEN Others THEN
                  UPDATE OM_ORDER
                    SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                        order_status       = 2,
                        order_status_msg   = 'Error Creando los OrderItem '
                  WHERE id_order = v_id_ord ;
              END;
              UPDATE OM_ORDER SET (order_status) = (4), order_status_msg = null WHERE id_order = v_id_ord;
              -- CREAR REGISTROS PARA EL INVENTARIO
              om_pack_instalink.PREPARE_ORDER_IL(v_id_ord,ERROR_ID,ERROR_DESCR);
            END IF;
            -- Validacion de la estructura de la orden

            -- CREAR REGISTROS PARA LOS PROCESOS
            Dbms_Output.Put_Line('creando los proceso: v_id_ord_type' || v_id_ord_type || 'v_prgcode: ' || v_prgcode );
            BEGIN
              for j in (  --SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS  WHERE id_ord_type = v_id_ord_type
                  SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS
                    WHERE id_ord_type = v_id_ord_type AND id_ord_process NOT IN (
                      SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS  WHERE id_ord_type = v_id_ord_type AND id_ord_process IN ( 'OP-001', 'OP-007' )
                        MINUS
                      (SELECT CASE send_sms WHEN 0 THEN NULL ELSE 'OP-001'  end AS id_ord_process FROM cfg_prgcode WHERE id_prgcode = v_prgcode
                        UNION ALL
                       SELECT CASE send_email WHEN 0 THEN NULL ELSE 'OP-007' END AS id_ord_process  FROM cfg_prgcode WHERE id_prgcode = v_prgcode
                      )
                    )
              )
              LOOP
                -- validar el orderItem que me indica si se debe ejecutar el proceso de Instalink
                BEGIN
                    SELECT item_value INTO v_isProcessInstalink FROM OM_ORDER_ITEM
                      WHERE id_order = v_id_ord AND id_ord_item_type = 'OIT-007';
                EXCEPTION
                  WHEN Others THEN
                    v_isProcessInstalink := '1';
                END;
                -- validar el orderItem que me indica si se debe ejecutar el proceso de Instalink

                -- validar si se tiene un plan y si se corresponde a enviar sms/email
                BEGIN
                  v_id_Plan          := NULL;
                  SELECT item_value INTO v_id_Plan FROM OM_ORDER_ITEM
                    WHERE id_order = v_id_ord AND id_ord_item_type = 'OIT-005';

                  -- ubicar si para ese plan se le permite enviar sms/email
                  -- el campo attr1 indica si se le puede enviar sms
                  -- el campo attr2 indica si se le puede enviar email
                  -- POR DEFECTOS SI TENGO ALGUN PROBLEMA CON EL PLAN VOY A CARGAR AMBOS PROCESOS (ENVIO SMS/EMAIL)
                  BEGIN
                    select
                      (CASE Nvl(attr1, '0') WHEN '0' THEN '0' ELSE '1'  END) AS envioSMS,
                      (CASE Nvl(attr2, '0') WHEN '0' THEN '0' ELSE '1'  END) AS envioEmail INTO v_is_sms_by_plan, v_is_email_by_plan
                    from CFG_PLAN WHERE id_plan = v_id_Plan;
                  EXCEPTION
                    WHEN Others THEN
                      v_is_sms_by_plan   := '1';           -- 1 = proceso de envio de sms activo 0 = proceso envio de sms desactivado
                      v_is_email_by_plan := '1';           -- 1 = proceso de envio de email activo 0 = proceso envio de email desactivado
                  END;
                  -- ubicar si para ese plan se le permite enviar sms/email
                EXCEPTION
                  WHEN Others THEN
                    v_is_sms_by_plan   := '1';           -- 1 = proceso de envio de sms activo 0 = proceso envio de sms desactivado
                    v_is_email_by_plan := '1';           -- 1 = proceso de envio de email activo 0 = proceso envio de email desactivado
                END;
                -- validar si se tiene un plan y si se corresponde a enviar sms/email

                -- validar si debo agregar o no el proceso de activacion del cuoba

                BEGIN
                  SELECT item_value INTO v_active_cuoba  FROM  (
                    SELECT item_value FROM OM_ORDER_ITEM WHERE id_ord_item_type = 'OIT-034' AND id_order in (v_id_ord)
                    minus
                    SELECT item_value FROM OM_ORDER_ITEM WHERE id_ord_item_type = 'OIT-008' AND id_order in (v_id_ord)
                  );
                 v_active_cuoba := '0';

                EXCEPTION
                  WHEN Too_Many_Rows THEN
                    v_active_cuoba := '0';
                  WHEN Others THEN
                    v_active_cuoba := '1' ;
                END;

                -- validar si debo agregar o no el proceso de activacion del cuoba

                -- 0 = El proceso IL apagado 1 = El proceso IL encendido
                IF v_isProcessInstalink = '0'   AND j.id_ord_process = 'OP-003' THEN   -- proceso IL apagado con idProceso del il
                  NULL;
                ELSIF  v_is_sms_by_plan = '0'   AND j.id_ord_process = 'OP-001' THEN   -- proceso de smsS agado con bandera por plan
                  NULL;
                ELSIF  v_is_email_by_plan = '0' AND j.id_ord_process = 'OP-007' THEN   -- proceso de email apagado con bandera por plan
                  NULL;
                ELSIF v_active_cuoba = '0'      AND  v_id_ord_type = 'OT-034' AND j.id_ord_process = 'OP-012' THEN      -- el activar cuoba esta desactivado y ademas es un orderType de ti acco
                  NULL;
                ELSE
                      INSERT INTO OM_ORDER_PROCESS VALUES(
                      v_id_ord,                      --id_order,
                      j.id_ord_process,              --id_ord_process,
                      5,                             --order_process_status,
                      NULL,                          --order_process_status_msg,
                      SYSDATE,                       --created_dt,
                      v_user,                        --created_who,
                      SYSDATE,                       --active_dt,
                      SYSDATE,                       --change_dt,
                      v_user,                        --change_who,
                      null                          --inactive_dt,
                    );
                END IF;

              end loop;
            EXCEPTION
              WHEN Others THEN
                ERROR_ID    := -20006;
                ERROR_DESCR := 'Error al crear los procesos: ' || SQLERRM;
                RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
            END;

            UPDATE OM_ORDER_PROCESS SET (order_process_status) = (4) WHERE id_order = v_id_ord ;
            IF SQL%NOTFOUND THEN
              UPDATE OM_ORDER SET (order_status) = (2), order_status_msg = 'Error creando procesos de la orden' WHERE id_order = v_id_ord;
            END IF;
            -- CREAR REGISTROS PARA LOS PROCESOS
          end loop;

        END IF;

            -- get de la orden creada obtener la orden creada
            get_all_order(
                          v_id_ord_account,
                          NULL,
                          NULL,
                          v_get_order_level,
                          v_get_id_ord_type,
                          v_get_id_billing,
                          v_get_id_billing_account,
                          v_get_customer_name,
                          v_get_email,
                          v_get_ack,
                          v_get_user,
                          v_get_om_obj_ord_account,
                          v_get_om_list_get_ord,
                          error_id,
                          error_descr
                            );

        v_om_obj_get_all_order := om_obj_get_all_order(

                          v_get_order_level,
                          v_get_id_ord_type,
                          v_get_id_billing,
                          v_get_id_billing_account,
                          v_get_customer_name,
                          v_get_email,
                          v_get_ack,
                          v_get_user,
                          v_get_om_obj_ord_account,
                          v_get_om_list_get_ord
        );
        -- get de la orden creada obtener la orden creada

          COMMIT;
        ELSE    -- Ordenes de tipo contrato

        -- a este flujo solo le falta crear las ordenes de instalink

          IF v_om_obj_consumption IS null THEN
            ERROR_ID    := -20003;
            ERROR_DESCR := 'Entrada requerida: "om_obj_consumption"';
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
          END IF;

          IF v_id_ord IS NULL THEN -- validar si es una orden nueva o una carga de data

            SELECT 'OR-'|| om_seq_id_order.NEXTVAL INTO v_id_ord FROM dual;

            INSERT INTO OM_ORDER
                    VALUES(
                      v_id_ord,                                    -- id_order,
                      v_id_ord_type,                               -- id_ord_type,
                      NULL,                                        -- id_ord_account,
                      NULL,                                        -- cus_type_id,
                      NULL,                                        -- cus_num_id,
                      v_id_billing,                                -- id_billing,
                      v_id_billing_account,                        -- id_billing_account,
                      v_om_obj_consumption.co_code,                -- co_code,
                      v_om_obj_consumption.msisdn,                 -- msisdn,
                      5,                                           -- order_status,
                      NULL,                                        -- order_status_msg,
                      'APP-006',                                   -- id_external_app_err,  ***************> CABLE
                      ' ',                                         -- id_external_app_err_msg,
                      v_customer_name,                             -- customer_name,
                      '0',                                        -- prgcode,
                      NULL,                                        -- open_amount,
                      NULL,                                        -- installment_amount,
                      NULL,                                        -- invoice_number,
                      NULL,                                        -- inv_billingdate,
                      NULL,                                        -- inv_duedate,
                      NULL,                                        -- ins_duedate,
                      v_email,                                     -- email,
--                      'Kevinn_gomez@digitel.com.ve',
                      NULL,                                        -- reconnection_charge,
                      NULL,                                        -- administrative_charge,
                      v_om_obj_consumption.threshold_id,           -- threshold_id,
                      v_om_obj_consumption.th_consumption,         -- th_consumption,
                      v_om_obj_consumption.th_unit,                -- th_unit,
                      SYSDATE,                                     -- created_dt,
                      v_user,                                      -- created_who,
                      SYSDATE,                                     -- active_dt,
                      SYSDATE,                                     -- change_dt,
                      v_user,                                      -- change_who,
                      NULL,                                        -- inactive_dt
                      v_ack,                                       -- ack
                      v_om_obj_consumption.tm_code                 -- tm_code
                    );

            -- CREAR REGISTROS PARA LOS PROCESOS
            BEGIN

              for i in (SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS  WHERE id_ord_type = v_id_ord_type )
              LOOP
                INSERT INTO OM_ORDER_PROCESS VALUES(
                    v_id_ord,                      --id_order,
                    i.id_ord_process,              --id_ord_process,
                    5,                             --order_process_status,
                    NULL,                          --order_process_status_msg,
                    SYSDATE,                       --created_dt,
                    v_user,                        --created_who,
                    SYSDATE,                       --active_dt,
                    SYSDATE,                       --change_dt,
                    v_user,                        --change_who,
                    null                          --inactive_dt,
                );
              end loop;

            EXCEPTION
              WHEN Others THEN
                ERROR_ID    := -20006;
                ERROR_DESCR := 'Error al crear los procesos: ' || SQLERRM;
                RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);

            END;
            -- CREAR REGISTROS PARA LOS PROCESO

            -- Actualizar las ordenes a estatus iniciado siempre que no tenga que actualizar

--            SELECT Count(1) INTO auxCont FROM CFG_ORD_STRUCT WHERE is_required = 1 AND inactive_dt IS NULL AND id_ord_type = v_id_ord_type;

--             IF auxCont = 0 THEN
              -- iniciar la orden y sus procesos
              --iniciar orden
              BEGIN
                UPDATE OM_ORDER SET (order_status) = (4) WHERE id_order = v_id_ord ;
              EXCEPTION
                WHEN Others THEN
                ERROR_ID    := SQLCODE;
                ERROR_DESCR := 'Error Creando los OrderItem:: ' || SQLERRM ;
                RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
              END;
              --iniciar procesos
              BEGIN
                UPDATE OM_ORDER_PROCESS SET (order_process_status) = (4) WHERE id_order = v_id_ord;
                IF SQL%NOTFOUND THEN
                  ERROR_ID    := -20007;
                  ERROR_DESCR := 'No se encontraron procesos configurados a nivel de contrato para el v_id_ord_type: ' ||v_id_ord_type || ' v_id_ord: ' || v_id_ord || ' '|| SQLERRM;
                  RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                END IF;
              EXCEPTION
                WHEN Others THEN
                ERROR_ID    := SQLCODE;
                ERROR_DESCR := 'Error Creando los OrderItem:: ' || SQLERRM ;
                RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
              END;
              -- iniciar la orden y sus procesos

              -- --Proceso para crear las ordenes de Instalink
              -- get de la orden creada obtener la orden creada
              get_all_order(
                              null,
                              v_id_ord,
                              NULL,
                              v_get_order_level,
                              v_get_id_ord_type,
                              v_get_id_billing,
                              v_get_id_billing_account,
                              v_get_customer_name,
                              v_get_email,
                              v_get_ack,
                              v_get_user,
                              v_get_om_obj_ord_account,
                              v_get_om_list_get_ord,
                              error_id,
                              error_descr
                               );

              v_om_obj_get_all_order := om_obj_get_all_order(

                                v_get_order_level,
                                v_get_id_ord_type,
                                v_get_id_billing,
                                v_get_id_billing_account,
                                v_get_customer_name,
                                v_get_email,
                                v_get_ack,
                                v_get_user,
                                v_get_om_obj_ord_account,
                                v_get_om_list_get_ord
              );
            -- get de la orden creada obtener la orden creada

--             END IF;

          ELSE   -- las ordenes ya se crearon se procedera a realizar la carga de la data
            -- Validacion de la estructura de la orden para los order Items

            SELECT Count(1) INTO auxCont FROM CFG_ORD_STRUCT WHERE is_required = 1 AND inactive_dt IS NULL AND id_ord_type = v_id_ord_type;

              IF auxCont > 0 THEN

                IF v_om_obj_consumption.list_ord_item IS null THEN
                  ERROR_ID    := -20004;
                  ERROR_DESCR := 'Entrada requerida: "om_obj_consumption.list_ord_item"';
                  RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                END IF;
                -- Validar si el inventario ya fue cargado
                auxCont := 0;

                BEGIN
                  SELECT 1 INTO auxCont FROM dual WHERE EXISTS (SELECT * FROM OM_ORDER_ITEM WHERE id_order = v_id_ord );
                EXCEPTION
                  WHEN Others THEN
                  NULL;
                END;

                IF auxCont > 0 THEN
                  ERROR_ID    := -20006;
                  ERROR_DESCR := 'Order Items Ya cargados para la orden: ' || v_id_ord ;
                  RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                END IF;

                -- Validar si el inventario ya fue cargado

                -- Validacion de la estructura de la orden
                v_all_order_item_missing := NULL;

                open v_c_order_item_missing for
                SELECT id_ord_item_type  FROM CFG_ORD_STRUCT WHERE is_required = 1 AND inactive_dt IS NULL AND id_ord_type = v_id_ord_type
                MINUS
                SELECT id_ord_item_type FROM TABLE(v_om_obj_consumption.list_ord_item);


                BEGIN
	                LOOP
	                    FETCH v_c_order_item_missing INTO c1rec;
	                    EXIT WHEN v_c_order_item_missing%NOTFOUND;
                      v_all_order_item_missing := v_all_order_item_missing || '/' || c1rec ;
	                END LOOP;
	                CLOSE v_c_order_item_missing;
                END;

                Dbms_Output.put_line( 'Valores de order item faltantes: '|| v_all_order_item_missing  );

                IF v_all_order_item_missing IS NOT null THEN
                  IF v_id_ord_type = 'OT-034' AND v_all_order_item_missing LIKE '%OIT-008' THEN
                    UPDATE OM_ORDER
                      SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                          order_status       = 2,
                          order_status_msg   = 'Error la orden no tiene servicios a activar falta: ' || v_all_order_item_missing
                    WHERE id_order = v_id_ord ;
                  ELSE
                    UPDATE OM_ORDER
                      SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                          order_status       = 2,
                          order_status_msg   = 'Error en la validacion de la estructura de la orden! es requerido: ' || v_all_order_item_missing
                    WHERE id_order = v_id_ord ;
                  END IF;
                  COMMIT;
                  ERROR_ID    := -20005;
                  ERROR_DESCR := 'Error en la validacion de la estructura de la orden! es requerido: ' || v_all_order_item_missing ;
                  RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                END IF;
              END IF;
              -- Validacion de la estructura de la orden

              -- CREAR REGISTROS PARA EL INVENTARIO
              BEGIN
                for i in v_om_obj_consumption.list_ord_item.first .. v_om_obj_consumption.list_ord_item.last LOOP

                  SELECT 'OI-'|| om_seq_id_order_item.NEXTVAL INTO v_id_oi FROM dual;
                  INSERT INTO OM_ORDER_ITEM VALUES(
                    v_id_oi,                                                     -- id_order_item Auto Generado
                    v_id_ord,                                                    -- id_order
                    v_om_obj_consumption.list_ord_item(i).id_ord_item_type,      -- id_ord_item_type,
                    v_om_obj_consumption.list_ord_item(i).value_ord_item_type,   -- item_value,
                    ' ',                                                         -- attr1_value,
                    ' ',                                                         -- attr2_value,
                    ' ',                                                         -- attr3_value,
                    4,                                                           -- order_item_status,
                    NULL,                                                        -- order_item_status_msg,
                    SYSDATE,                                                     -- created_dt,
                    v_user,                                                      -- created_who,
                    SYSDATE,                                                     -- active_dt,
                    SYSDATE,                                                     -- change_dt,
                    v_user,                                                      -- change_who,
                    null                                                         -- inactive_dt
                  );
                END LOOP;

              EXCEPTION
                WHEN Others THEN
                  ROLLBACK;
                  UPDATE OM_ORDER
                    SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                        order_status       = 2,
                        order_status_msg   = 'Error Creando los OrderItem '
                  WHERE id_order = v_id_ord ;

                  COMMIT;

                  ERROR_ID    := SQLCODE;
                  ERROR_DESCR := 'Error Creando los OrderItem:: ' || SQLERRM ;
                  RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
              END;
              -- CREAR REGISTROS PARA EL INVENTARIO
                          -- get de la orden creada obtener la orden creada

              om_pack_instalink.PREPARE_ORDER_IL(v_id_ord,ERROR_ID,ERROR_DESCR);

              get_all_order(
                              null,
                              v_id_ord,
                              NULL,
                              v_get_order_level,
                              v_get_id_ord_type,
                              v_get_id_billing,
                              v_get_id_billing_account,
                              v_get_customer_name,
                              v_get_email,
                              v_get_ack,
                              v_get_user,
                              v_get_om_obj_ord_account,
                              v_get_om_list_get_ord,
                              error_id,
                              error_descr
                               );

              v_om_obj_get_all_order := om_obj_get_all_order(

                                v_get_order_level,
                                v_get_id_ord_type,
                                v_get_id_billing,
                                v_get_id_billing_account,
                                v_get_customer_name,
                                v_get_email,
                                v_get_ack,
                                v_get_user,
                                v_get_om_obj_ord_account,
                                v_get_om_list_get_ord
              );
          END IF; -- validar si es una orden nueva o una carga de data
        END IF; -- Ordenes de tipo contrato

        COMMIT;

        EXCEPTION
          WHEN Others THEN
          ROLLBACK;
          error_id    := SQLCODE;
          error_descr := '[om_pack_order_administration.create_order] ' || SQLERRM;
    end create_order;

     procedure create_order_batch      (
                                          v_id_ord_type                  VARCHAR2,
                                          v_user                         VARCHAR2,
                                          v_ack                          VARCHAR2,
                                          v_om_list_ord_account_batch    om_list_ord_account_batch, -- lista de cuentas con ordenes
                                          v_om_list_batch_ord            om_list_batch_ord,         -- lista de ordenes
                                          v_id_batch                OUT  VARCHAR2,
                                          v_om_list_get_all_order   OUT  om_list_get_all_order,
                                          error_id                  out  number,
                                          error_descr               out  VARCHAR2
                                      )
    IS

    v_id_billing                   VARCHAR2(20) := 'BI-001';
    v_om_obj_BATCH_ord_account     om_obj_BATCH_ord_account;
    v_om_list_ord_item             om_list_ord_item;
    v_id_ord_account               VARCHAR2(20);
    v_id_ord                       VARCHAR2(20);
    v_summary_process_ACCOUNT      VARCHAR2(250);
    v_summary_process_ORD_CON      VARCHAR2(250);
    v_summary_process_control      VARCHAR2(500);
    v_PLAN                         VARCHAR2(50);
    v_all_order_item_missing       VARCHAR2(500);
    v_c_order_item_missing         sys_refcursor;
    c1rec                          VARCHAR2(10);
    v_id_oi                        OM_ORDER_ITEM.id_order_item%TYPE := NULL;
    v_status                       NUMBER;
    v_error_plan                   NUMBER := 0;
    v_error_ord_account            VARCHAR2(50);
    v_prgcode                      OM_ORD_ACCOUNT.prgcode%TYPE;
    v_id_Plan                       VARCHAR2(20);

    v_isProcessInstalink           VARCHAR2(1) := '1' ; -- 1 = proceso de Instalink activo 0 = proceso instalink desactivado
    v_is_sms_by_plan               VARCHAR2(1) := '1' ; -- 1 = proceso de envio de sms activo 0 = proceso envio de sms desactivado
    v_is_email_by_plan             VARCHAR2(1) := '1' ; -- 1 = proceso de envio de email activo 0 = proceso envio de email desactivado


    v_om_obj_get_all_order         om_obj_get_all_order; -- restructurar
    v_index                        NUMBER;
    v_get_order_level              NUMBER;
    v_get_id_ord_type              VARCHAR2(10);
    v_get_id_billing               VARCHAR2(10);
    v_get_id_billing_account       VARCHAR2(10);
    v_get_customer_name            VARCHAR2(255);
    v_get_email                    VARCHAR2(255);
    v_get_ack                      VARCHAR2(50);
    v_get_user                     VARCHAR2(50);
    v_get_om_obj_ord_account       om_obj_get_ord_account;
    v_get_om_list_get_ord          om_list_get_ord ;

    v_level_add_occ                 VARCHAR2(20);
    v_type_notification             VARCHAR2(20);   -- 0 = SMS 1 =EMAIL 2 = AMBOS
    v_level_cancellation            VARCHAR2(1);    -- 0 = nivel de cuenta 1 = nivel de contrato 2 = nivel de cuenta sin contratos
    v_level_operation               VARCHAR2(1);    -- 0 = bloqueo 1 = reactivacion
    BEGIN

      error_id := 0;
      error_descr := 'Ejecucion exitosa';

      IF v_om_list_ord_account_batch IS NOT NULL AND v_om_list_ord_account_batch.Count > 0 THEN
        v_summary_process_ACCOUNT := NULL;
        -- generar id de batchProcess
          SELECT 'BP-'|| om_seq_id_batch_process.NEXTVAL INTO v_id_batch FROM dual;
        -- generar id de batchProcess
        FOR i in v_om_list_ord_account_batch.first .. v_om_list_ord_account_batch.last LOOP

          Dbms_Output.Put_Line( v_om_list_ord_account_batch(i).id_billing_account );

          -- CREAR ORDEN DE TIPO CUENTA
          SELECT 'OC-'|| om_seq_id_order_account.NEXTVAL INTO v_id_ord_account FROM dual;

          v_prgcode := Nvl(v_om_list_ord_account_batch(i).prgcode, '0');

          Dbms_Output.Put_Line(v_id_ord_account);
              -- crear la nueva orden de tipo cuenta
            INSERT INTO om_ord_account
                VALUES(   v_id_ord_account,                                                               --  id_ord_account
                          v_id_ord_type,                                                                  --  id_ord_type
                          v_om_list_ord_account_batch(i).cus_type_id,                                     --  cus_type_id
                          v_om_list_ord_account_batch(i).cus_num_id,                                      --  cus_num_id
                          v_id_billing,                                                                   --  id_billing
                          v_om_list_ord_account_batch(i).id_billing_account,                              --  id_billing_account
                          5,                                                                              --  ord_acn_status
                          NULL,                                                                           --  ord_acn_status_msg
                          v_om_list_ord_account_batch(i).customer_name,                                   --  customer_name
                          v_om_list_ord_account_batch(i).prgcode,                                         --  prgcode
                          v_om_list_ord_account_batch(i).open_amount,                                     --  open_amount
                          v_om_list_ord_account_batch(i).installment_amount,                              --  installment_amount
                          v_om_list_ord_account_batch(i).invoice_number,                                  --  invoice_number
                          To_Date(v_om_list_ord_account_batch(i).inv_billingdate,'DD/MM/YYYY HH24:MI'),   --  inv_billingdate
                          To_Date(v_om_list_ord_account_batch(i).inv_duedate,    'DD/MM/YYYY HH24:MI'),   --  inv_duedate
                          To_Date(v_om_list_ord_account_batch(i).ins_duedate,    'DD/MM/YYYY HH24:MI'),   --  ins_duedate
                          v_om_list_ord_account_batch(i).email,                                           --  email
                          v_om_list_ord_account_batch(i).reconnection_charge,                             --  reconnection_charge
                          v_om_list_ord_account_batch(i).administrative_charge,                           --  administrative_charge
                          SYSDATE,                                                                        --  created_dt
                          v_user,                                                                         --  created_who
                          SYSDATE,                                                                        --  active_dt
                          SYSDATE,                                                                        --  change_dt
                          v_user,                                                                         --  change_who
                          NULL,                                                                           --  inactive_dt
                          v_ack                                                                           -- valor del ack
                );
          --
          -- CREAR REGISTROS PARA LOS PROCESOS tipo cuenta

          -- ubicar el nivel de la ejecucion de los procesos para las cancelaciones masivas
          BEGIN
            FOR h in v_om_list_ord_account_batch(1).list_order(1).list_ord_item.first .. v_om_list_ord_account_batch(1).list_order(1).list_ord_item.last LOOP
              IF v_om_list_ord_account_batch(1).list_order(1).list_ord_item(h).id_ord_item_type = 'OIT-031' THEN
                  v_level_cancellation := v_om_list_ord_account_batch(1).list_order(1).list_ord_item(h).value_ord_item_type;
                  END IF;
            END LOOP;
          EXCEPTION
            WHEN Others THEN
            v_level_cancellation := '1';
          END;
          -- ubicar el nivel de la ejecucion de los procesos para las cancelaciones masivas

             Dbms_Output.Put_Line('level cancellation---------------> ' || v_level_cancellation );
              BEGIN
                for k in (SELECT id_ord_account_process FROM cfg_ord_account_struct_process  WHERE id_ord_type = v_id_ord_type )
                LOOP
                  IF v_level_cancellation = '1' AND (k.id_ord_account_process = 'OAP-005' OR k.id_ord_account_process = 'OAP-006') THEN
                    NULL;
                  ELSE
                    INSERT INTO om_ord_account_process VALUES(
                        v_id_ord_account,              --id_ord_account,
                        k.id_ord_account_process,      --id_ord_account_process,
                        5,                             --ord_account_process_status,
                        NULL,                          --order_process_status_msg,
                        SYSDATE,                       --created_dt,
                        v_user,                        --created_who,
                        SYSDATE,                       --active_dt,
                        SYSDATE,                       --change_dt,
                        v_user,                        --change_who,
                        null                          --inactive_dt,
                    );
                  END IF;
                END LOOP;
              EXCEPTION
                WHEN Others THEN
                  ERROR_ID    := -20006;
                  ERROR_DESCR := 'Error al crear los procesos: ' || SQLERRM;
                  RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
              END;
          -- CREAR REGISTROS PARA LOS PROCESOS tipo cuenta
          -- Iniciar la orden y sus procesos
          UPDATE om_ord_account SET (ord_acn_status) = (4) WHERE id_ord_account = v_id_ord_account ;
          IF SQL%NOTFOUND THEN
            v_summary_process_ACCOUNT := 'Error actualizando la orden: ' || v_id_ord_account || 'SQLERRM: ' || SQLERRM ;
          END IF;
          UPDATE om_ord_account_process SET (ord_account_process_status) = (4) WHERE id_ord_account = v_id_ord_account;
          IF SQL%NOTFOUND THEN
            v_summary_process_ACCOUNT := 'Error actualizando los procesos de la orden: ' || v_id_ord_account || 'SQLERRM: ' || SQLERRM ;
          END IF;
        -- Iniciar la orden y sus procesos

          --
          -- CREAR ORDEN DE TIPO CUENTA

          -- VALIDAR QUE VENGA CONTRATOS
          IF v_om_list_ord_account_batch(i).list_order IS NULL OR v_om_list_ord_account_batch(i).list_order.Count = 0 THEN
            v_summary_process_ACCOUNT := 'No existe contratos a cargar para la idOrden: ' || v_id_ord_account || 'SQLERRM: ' || SQLERRM ;
            UPDATE OM_ORD_ACCOUNT
                  SET
                      ord_acn_status       = 2,
                      ord_acn_status_msg   = 'Sin contratos'
            WHERE  id_ord_account = v_id_ord_account ;
          END IF;
          -- VALIDAR QUE VENGA CONTRATOS

          -- CREAR ORDENES DE TIPO CONTRATO
          FOR j in v_om_list_ord_account_batch(i).list_order.first .. v_om_list_ord_account_batch(i).list_order.last LOOP

            Dbms_Output.Put_Line(v_om_list_ord_account_batch(i).list_order(j).msisdn);
            v_summary_process_ORD_CON := NULL;

            SELECT 'OR-'|| om_seq_id_order.NEXTVAL INTO v_id_ord FROM dual;
            Dbms_Output.Put_Line(v_id_ord);

            INSERT INTO OM_ORDER
              VALUES(
                v_id_ord,                                                                            -- id_order,
                v_id_ord_type,                                                                       -- id_ord_type,
                v_id_ord_account,                                                                    -- id_ord_account,
                v_om_list_ord_account_batch(i).list_order(j).cus_type_id,                            -- cus_type_id,
                v_om_list_ord_account_batch(i).list_order(j).cus_num_id,                             -- cus_num_id,
                v_id_billing,                                                                        -- id_billing,
                v_om_list_ord_account_batch(i).list_order(j).id_billing_account,                     -- id_billing_account,
                v_om_list_ord_account_batch(i).list_order(j).co_code,                                -- co_code,
                v_om_list_ord_account_batch(i).list_order(j).msisdn,                                 -- msisdn,
                4,                                                                                   -- order_status,
                NULL,                                                                                -- order_status_msg,
                NULL,                                                                                -- id_external_app_err,
                NULL,                                                                                -- id_external_app_err_msg,
                v_om_list_ord_account_batch(i).list_order(j).customer_name,                          -- customer_name,
                v_om_list_ord_account_batch(i).prgcode ,                                             -- prgcode, v_om_obj_ord_account.prgcode
                v_om_list_ord_account_batch(i).open_amount,                                          -- open_amount,
                v_om_list_ord_account_batch(i).installment_amount,                                   -- installment_amount,
                v_om_list_ord_account_batch(i).invoice_number,                                       -- invoice_number,
                To_Date(v_om_list_ord_account_batch(i).inv_billingdate,'DD/MM/YYYY HH24:MI'),        -- inv_billingdate,
                To_Date(v_om_list_ord_account_batch(i).inv_duedate,    'DD/MM/YYYY HH24:MI'),        -- inv_duedate,
                To_Date(v_om_list_ord_account_batch(i).ins_duedate,    'DD/MM/YYYY HH24:MI'),        -- ins_duedate,
                v_om_list_ord_account_batch(i).list_order(j).email,                                  -- email,
                v_om_list_ord_account_batch(i).reconnection_charge,                                  -- reconnection_charge,
                v_om_list_ord_account_batch(i).administrative_charge,                                -- administrative_charge,
                NULL,                                                                                -- threshold_id,    **********
                NULL,                                                                                -- th_consumption,  **********
                NULL,                                                                                -- th_unit,         **********
                SYSDATE,                                                                             -- created_dt,      **********
                v_user,                                                                              -- created_who,
                SYSDATE,                                                                             -- active_dt,
                SYSDATE,                                                                             -- change_dt,
                v_user,                                                                              -- who,
                NULL,                                                                                -- inactive_dt
                v_ack,                                                                               -- ack
                NULL                                                                                 -- tm_code
              );

          -- CREAR ORDER ITEMS

          --VALIDACION DE LA ESTRUCTURA DE LA ORDEN
          v_all_order_item_missing := NULL;

          open v_c_order_item_missing for
          SELECT id_ord_item_type  FROM CFG_ORD_STRUCT WHERE is_required = 1 AND inactive_dt IS NULL AND id_ord_type = v_id_ord_type
          MINUS
          SELECT id_ord_item_type FROM TABLE(v_om_list_ord_account_batch(i).list_order(j).list_ord_item);

          BEGIN
	          LOOP
	              FETCH v_c_order_item_missing INTO c1rec;
	              EXIT WHEN v_c_order_item_missing%NOTFOUND;
                v_all_order_item_missing := v_all_order_item_missing || '/' || c1rec ;
	          END LOOP;
	          CLOSE v_c_order_item_missing;
          END;

          Dbms_Output.put_line( 'Valores de order item faltantes: '|| v_all_order_item_missing  );

          IF v_all_order_item_missing IS NOT null THEN
            UPDATE OM_ORDER
              SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                  order_status       = 2,
                  order_status_msg   = 'Error en la validacion de la estructura de la orden! es requerido: ' || v_all_order_item_missing
            WHERE id_order = v_id_ord ;

            UPDATE OM_ORD_ACCOUNT
                  SET
                      ord_acn_status       = 2,
                      ord_acn_status_msg   = 'OrderItems requeridos'
            WHERE  id_ord_account = v_id_ord_account ;

            v_summary_process_ORD_CON :=    'Error en la validacion la estructura de las ordenes, orderItems requeridos';

          ELSE
            BEGIN

              v_error_plan  := 0;

              FOR h in v_om_list_ord_account_batch(i).list_order(j).list_ord_item.first .. v_om_list_ord_account_batch(i).list_order(j).list_ord_item.last LOOP

                v_status := 4;

                Dbms_Output.Put_Line('===========' || v_status);
                -- esto pertenece al cable
                IF v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).id_ord_item_type = 'OIT-005' THEN
  --                v_PLAN := '52';
                  v_PLAN := v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).value_ord_item_type;
                  BEGIN
                    SELECT 2, 1 INTO v_status, v_error_plan FROM dual
                      WHERE
                      NOT EXISTS  ( select * from CFG_PLAN WHERE id_plan = v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).value_ord_item_type);
                    EXCEPTION
                      WHEN no_data_found THEN
                      v_status := 4;
                      Dbms_Output.Put_Line('===========' || v_status);
                  END;
                ELSE
                  v_PLAN := v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).value_ord_item_type;
                END IF;

                v_level_add_occ := '999';
                IF v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).id_ord_item_type = 'OIT-016' THEN
                  v_level_add_occ := v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).value_ord_item_type;
                END IF;

                SELECT 'OI-'|| om_seq_id_order_item.NEXTVAL INTO v_id_oi FROM dual;
                INSERT INTO OM_ORDER_ITEM VALUES(
                  v_id_oi,                                                                         -- id_order_item Auto Generado
                  v_id_ord,                                                                        -- id_order
                  v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).id_ord_item_type,  -- id_ord_item_type,
    --                  v_om_list_ord(i).list_ord_item(j).value_ord_item_type,                     -- item_value,
                  v_PLAN,                                                                         -- ELIMINAR CABLE
                  ' ',                                                                             -- attr1_value,
                  ' ',                                                                             -- attr2_value,
                  ' ',                                                                             -- attr3_value,
                  v_status,                                                                        -- order_item_status,
                  NULL,                                                                            -- order_item_status_msg,
                  SYSDATE,                                                                         -- created_dt,
                  v_user,                                                                          -- created_who,
                  SYSDATE,                                                                         -- active_dt,
                  SYSDATE,                                                                         -- change_dt,
                  v_user,                                                                          -- change_who,
                  null                                                                             -- inactive_dt
                );
              END LOOP;

              IF v_error_plan = 1 AND v_level_add_occ NOT IN ('2','3','999')  THEN
                UPDATE OM_ORDER
                  SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                      order_status       = 2,
                      order_status_msg   = 'Error plan no registrado en el OM '
                WHERE id_order = v_id_ord ;

                UPDATE OM_ORD_ACCOUNT
                      SET
                          ord_acn_status       = 2
                WHERE  id_ord_account = v_id_ord_account ;

              END IF;
            om_pack_instalink.PREPARE_ORDER_IL(v_id_ord,ERROR_ID,ERROR_DESCR);

            EXCEPTION
              WHEN Others THEN
                UPDATE OM_ORDER
                  SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                      order_status       = 2,
                      order_status_msg   = 'Error Creando los OrderItem '
                WHERE id_order = v_id_ord ;

                UPDATE OM_ORD_ACCOUNT
                      SET
                          ord_acn_status       = 2
                WHERE  id_ord_account = v_id_ord_account ;
                v_summary_process_ORD_CON := 'Error Creando los OrderItem';
            END;

          END IF;
          -- CREAR ORDER ITEMS

          -- CREAR PROCESOS
          -- CREAR REGISTROS PARA LOS PROCESOS
          Dbms_Output.Put_Line('creando los proceso: v_id_ord_type' || v_id_ord_type || 'v_prgcode: ' || v_prgcode );
          BEGIN
            for o in (  --SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS  WHERE id_ord_type = v_id_ord_type
                SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS
                  WHERE id_ord_type = v_id_ord_type AND id_ord_process NOT IN (
                    SELECT id_ord_process FROM CFG_ORD_STRUCT_PROCESS  WHERE id_ord_type = v_id_ord_type AND id_ord_process IN ( 'OP-001', 'OP-007' )
                      MINUS
                    (SELECT CASE send_sms WHEN 0 THEN NULL ELSE 'OP-001'  end AS id_ord_process FROM cfg_prgcode WHERE id_prgcode = v_prgcode
                      UNION ALL
                      SELECT CASE send_email WHEN 0 THEN NULL ELSE 'OP-007' END AS id_ord_process  FROM cfg_prgcode WHERE id_prgcode = v_prgcode
                    )
                  )
            )
            LOOP
              -- validar el orderItem que me indica si se debe ejecutar el proceso de Instalink
              BEGIN
                  SELECT item_value INTO v_isProcessInstalink FROM OM_ORDER_ITEM
                    WHERE id_order = v_id_ord AND id_ord_item_type = 'OIT-007';
              EXCEPTION
                WHEN Others THEN
                  v_isProcessInstalink := '1';
              END;
              -- validar el orderItem que me indica si se debe ejecutar el proceso de Instalink

              -- validar si se tiene un plan y si se corresponde a enviar sms/email
              BEGIN
                v_id_Plan          := NULL;
                SELECT item_value INTO v_id_Plan FROM OM_ORDER_ITEM
                  WHERE id_order = v_id_ord AND id_ord_item_type = 'OIT-005';

                -- ubicar si para ese plan se le permite enviar sms/email
                -- el campo attr1 indica si se le puede enviar sms
                -- el campo attr2 indica si se le puede enviar email
                -- POR DEFECTOS SI TENGO ALGUN PROBLEMA CON EL PLAN VOY A CARGAR AMBOS PROCESOS (ENVIO SMS/EMAIL)
                BEGIN
                  select
                    (CASE Nvl(attr1, '0') WHEN '0' THEN '0' ELSE '1'  END) AS envioSMS,
                    (CASE Nvl(attr2, '0') WHEN '0' THEN '0' ELSE '1'  END) AS envioEmail INTO v_is_sms_by_plan, v_is_email_by_plan
                  from CFG_PLAN WHERE id_plan = v_id_Plan;
                EXCEPTION
                  WHEN Others THEN
                    v_is_sms_by_plan   := '1';           -- 1 = proceso de envio de sms activo 0 = proceso envio de sms desactivado
                    v_is_email_by_plan := '1';           -- 1 = proceso de envio de email activo 0 = proceso envio de email desactivado
                END;
                -- ubicar si para ese plan se le permite enviar sms/email
              EXCEPTION
                WHEN Others THEN
                  v_is_sms_by_plan   := '1';           -- 1 = proceso de envio de sms activo 0 = proceso envio de sms desactivado
                  v_is_email_by_plan := '1';           -- 1 = proceso de envio de email activo 0 = proceso envio de email desactivado
                END;
                -- validar si se tiene un plan y si se corresponde a enviar sms/email
                Dbms_Output.Put_Line('.;.;.;.;.;.;.;.;.;.;.;.;.;.;.;' || v_type_notification );

                 -- validar el tipo de notificacion requerido para las notificaciones genericas
                v_type_notification := '2';
--                IF v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).id_ord_item_type = 'OIT-029' THEN
--                 Dbms_Output.Put_Line('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- v_type_notification ' ||v_type_notification);
--                v_type_notification := v_om_list_ord_account_batch(i).list_order(j).list_ord_item(h).value_ord_item_type;
--                 Dbms_Output.Put_Line('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- v_type_notification ' ||v_type_notification);
--                END IF;

                BEGIN
                  SELECT item_value INTO v_type_notification FROM OM_ORDER_ITEM
                  WHERE id_order = v_id_ord AND id_ord_item_type = 'OIT-029';

                EXCEPTION
                  WHEN Others THEN
                  v_type_notification := '2';
                END;

                -- validar el tipo de mensaje para la orden;


                -- validar el nivel de la operacion v_level_operation
                BEGIN
                  SELECT item_value INTO v_level_operation FROM OM_ORDER_ITEM
                  WHERE id_order = v_id_ord AND id_ord_item_type = 'OIT-033';

                EXCEPTION
                  WHEN Others THEN
                  v_level_operation := '1';
                END;
                -- validar el nivel de la operacion v_level_operation


                -- 0 = El proceso IL apagado 1 = El proceso IL encendido
                IF v_isProcessInstalink = '0'   AND o.id_ord_process = 'OP-003' THEN   -- proceso IL apagado con idProceso del il
                  NULL;
                ELSIF  v_is_sms_by_plan = '0'   AND o.id_ord_process = 'OP-001' THEN   -- proceso de smsS apgado con bandera por plan
                  NULL;
                ELSIF  v_is_email_by_plan = '0' AND o.id_ord_process = 'OP-007' THEN   -- proceso de email apagado con bandera por plan
                  NULL;
                ELSIF v_type_notification = '0' AND o.id_ord_process = 'OP-007'  THEN  -- si es 0 no debe enviar email SOLO SMS
                  NULL;
                ELSIF v_type_notification = '1' AND o.id_ord_process = 'OP-001'  THEN  -- si es 1 no debe enviar sms SOLO EMAIL
                  NULL;
                ELSIF v_id_ord_type = 'OT-042'  AND v_level_cancellation = '1' AND o.id_ord_process = 'OP-001' THEN  -- si es cancelacion el nivel es de tipo contrato y es el proceso 010
                  NULL;
                ELSIF v_id_ord_type = 'OT-043'  AND v_level_operation in ('0','1') AND o.id_ord_process in ('OP-017') THEN  -- si es cancelacion el nivel es de tipo contrato y es el proceso 010
                  NULL;
                ELSIF v_id_ord_type = 'OT-043'  AND v_level_operation in ('2') AND o.id_ord_process in ('OP-016') THEN  -- si es cancelacion el nivel es de tipo contrato y es el proceso 010
                  NULL;
                ELSIF v_level_cancellation = '2' then
                  NULL;

                ELSE
                      INSERT INTO OM_ORDER_PROCESS VALUES(
                      v_id_ord,                      --id_order,
                      o.id_ord_process,              --id_ord_process,
                      4,                             --order_process_status,
                      NULL,                          --order_process_status_msg,
                      SYSDATE,                       --created_dt,
                      v_user,                        --created_who,
                      SYSDATE,                       --active_dt,
                      SYSDATE,                       --change_dt,
                      v_user,                        --change_who,
                      null                          --inactive_dt,
                    );
                END IF;

            end loop;
          EXCEPTION
            WHEN Others THEN
              UPDATE OM_ORDER
                SET id_external_app_err = 'APP-006',-- id_external_app_err,  ***************> CABLE
                    order_status       = 2,
                    order_status_msg   = 'Error Creando los OrderItem '
              WHERE id_order = v_id_ord ;

              UPDATE OM_ORD_ACCOUNT
                    SET
                        ord_acn_status       = 2
              WHERE  id_ord_account = v_id_ord_account ;
              v_summary_process_ORD_CON := 'Error Creando los procesos';

          END;

  --            UPDATE OM_ORDER_PROCESS SET (order_process_status) = (4) WHERE id_order = v_id_ord ;
  --            IF SQL%NOTFOUND THEN
  --              UPDATE OM_ORDER SET (order_status) = (2), order_status_msg = 'Error creando procesos de la orden' WHERE id_order = v_id_ord;
  --            END IF;
  --            -- CREAR REGISTROS PARA LOS PROCESOS
          -- CREAR PROCESOS

          END LOOP;
          -- CREAR ORDEN DE TIPO CUENTA

          -- CREAR REGISTRO EN LA TABLA DE CONTROL
          Dbms_Output.Put_Line(v_id_ord);

          v_summary_process_control := Nvl(v_summary_process_ACCOUNT, 'Orden de cuenta iniciado con exito');
          v_summary_process_control := v_summary_process_control || '|' || Nvl(v_summary_process_ORD_CON, 'Ordenes de Contrato iniciadas con exitos');

          BEGIN
            SELECT 'ERROR EN VALIDACION'  INTO v_error_ord_account FROM om_ord_account WHERE id_ord_account = v_id_ord_account AND ord_acn_status = 2;
            v_summary_process_control := v_summary_process_control || '|' || v_error_ord_account;
          EXCEPTION
            WHEN No_Data_Found THEN
              v_summary_process_control := v_summary_process_control || '|' || 'Exito al procesar';
          END;

          INSERT INTO om_batch_control VALUES(
            v_id_batch,                                                    -- id_batch       VARCHAR2(400) NOT NULL,
            v_id_ord_account,                                              -- id_ord_account VARCHAR2(10)  NULL,
            '0',                                                           -- id_order       VARCHAR2(10)  NULL,
            NULL,                                                          -- attr1          VARCHAR2(20)  NULL,
            NULL,                                                          -- attr2          VARCHAR2(20)  NULL,
            v_ack,                                                         -- ack            VARCHAR2(20)  NOT NULL,
            SYSDATE,                                                       -- created_dt     DATE          NOT NULL,
            v_user,                                                        -- created_who    VARCHAR2(20)  NOT NULL,
            SYSDATE,                                                       -- active_dt      DATE          NOT NULL,
            SYSDATE,                                                       -- change_dt      DATE          NOT NULL,
            v_user,                                                        -- change_who     VARCHAR2(20)  NOT NULL
            v_summary_process_control  -- summary_process
            );
          -- CREAR REGISTRO EN LA TABLA DE CONTROL


        END LOOP; -- recorrer las ordenes de tipo cuenta

      END IF;

    COMMIT;

    -- obtener una lista de las ordenes creadas
    v_index := 1;
    Dbms_Output.Put_Line('Lectura de las ordenes de tipo cuenta en una cuenta batch');
    v_om_list_get_all_order := om_list_get_all_order();
    FOR p IN (SELECT * FROM om_batch_control WHERE id_batch = v_id_batch) LOOP

    v_om_list_get_all_order.extend;

    om_pack_order_administration_2.get_all_order(
                                                  P.id_ord_account,
                                                  NULL,
                                                  NULL,
                                                  v_get_order_level,
                                                  v_get_id_ord_type,
                                                  v_get_id_billing,
                                                  v_get_id_billing_account,
                                                  v_get_customer_name,
                                                  v_get_email,
                                                  v_get_ack,
                                                  v_get_user,
                                                  v_get_om_obj_ord_account,
                                                  v_get_om_list_get_ord,
                                                  error_id,
                                                  error_descr
                                                 );

    v_om_list_get_all_order(v_index) := om_obj_get_all_order(
                                                              v_get_order_level,
                                                              v_get_id_ord_type,
                                                              v_get_id_billing,
                                                              v_get_id_billing_account,
                                                              v_get_customer_name,
                                                              v_get_email,
                                                              v_get_ack,
                                                              v_get_user,
                                                              v_get_om_obj_ord_account,
                                                              v_get_om_list_get_ord
                                                            );

    v_index := v_index + 1;
    END LOOP;
    -- obtener una lista de las ordenes creadas

    EXCEPTION
      WHEN Others THEN
        error_id    := SQLCODE;
        error_descr := '[om_pack_order_administration_2.create_order_batch] ' || SQLERRM;

    END create_order_batch;


  procedure get_param_configuration_sms (
                                               v_sms_Generic             VARCHAR2,
                                               v_parameter_table         OUT VARCHAR2,
                                               v_parameter_replace_table OUT VARCHAR2

                                    )
  IS
  numRep NUMBER;
  numPositionIni NUMBER;
  numPositionFin NUMBER;
  itera_param VARCHAR2(1000);
  i NUMBER;
  BEGIN

    select REGEXP_COUNT( v_sms_Generic, '@') INTO numRep from dual;

    i := 1;

    WHILE i <= numRep
      LOOP

        -- dbms_output.put_line(' valor de del primer @: ' || i  );

        Select INSTR( v_sms_Generic, '@',1,i ) INTO numPositionIni from dual;
        --    dbms_output.put_line('posicion del @: ' || numPositionIni);

        Select INSTR( v_sms_Generic, ' ', numPositionIni,1  ) INTO numPositionFin from dual;
        --    dbms_output.put_line('posicion del espacio: ' || numPositionFin);

        SELECT substr(v_sms_Generic, (numPositionIni + 1), ( numPositionFin - (numPositionIni+1) ) ) INTO itera_param FROM  dual;
        --    dbms_output.put_line('itera_param: ' || itera_param);

        SELECT REPLACE(itera_param, ',', '' ) INTO itera_param FROM dual;

        IF v_parameter_table IS null  THEN
--          IF itera_param = 'prgcode' THEN
--            itera_param := 'a.'||itera_param;
--          END IF;
          v_parameter_table :=  itera_param;
          v_parameter_replace_table  := 'REPLACE (message, ''@' || itera_param || ''', ' || itera_param || ' || '''||' ' ||  ''''||    ' )';
        ELSE
--          IF itera_param = 'prgcode' THEN
--            itera_param := 'a.'||itera_param;
--          END IF;
          v_parameter_table := v_parameter_table || ', ' || itera_param;
          v_parameter_replace_table  := 'REPLACE (' || v_parameter_replace_table || ', ''@' || itera_param || ''',' || itera_param || ' || '''||' ' ||  ''''||    ' )';

        END IF;

        -- dbms_output.put_line('itera_param1111: ' || ''''|| itera_param || '''');

        i := i +1 ;

    END LOOP;

    v_parameter_replace_table := v_parameter_replace_table || ' as sms';
    v_parameter_replace_table := REPLACE( v_parameter_replace_table , ' prgcode', ' a.prgcode');

    -- dbms_output.put_line('valor de las variables: ' || v_parameter_table);
    -- dbms_output.put_line('valor de las variables para el remplazo: ' || v_parameter_replace_table);

  --EXCEPTION
  --  WHEN Others THEN
  END;

  procedure get_value_field_tables_orders (
                                                v_id_any_type_order           VARCHAR2,
                                                v_field                       VARCHAR2,
                                                v_field_value             OUT VARCHAR2,
                                                error_id                  out number,
                                                error_descr               out VARCHAR2
                                    )
  IS
  --  v_field                 VARCHAR2(1000) := 'id_ord_account';
  --  v_field_value           VARCHAR2(1000);
  --  v_id_any_type_order     VARCHAR2(100) := 'OC-227';
    v_id_order              VARCHAR2(100) := NULL;
    v_id_order_account      VARCHAR2(100) := NULL;
    v_sql_om_order_account  VARCHAR2(100);
    v_numRep                NUMBER;
  --  error_id                NUMBER;
  --  error_descr             VARCHAR2(500);
    sql_statement           VARCHAR2(1000) := NULL;
  BEGIN

    error_id := 0;
    error_descr := 'Ejecucion exitosa';

    select REGEXP_COUNT( v_id_any_type_order, 'OC') INTO v_numRep from dual;

    IF v_numRep = 1  THEN
      v_id_order_account := v_id_any_type_order;
      Dbms_Output.Put_Line('id tipo orden de cuenta');
    ELSE
      select REGEXP_COUNT( v_id_any_type_order, 'OR') INTO v_numRep from dual;
      IF v_numRep = 1 THEN
        v_id_order := v_id_any_type_order;
        Dbms_Output.Put_Line('Id tipo Contrato');
      ELSE
        ERROR_ID    := -20002;
        ERROR_DESCR := 'El valor del Idintificador no Corresponde con la nomenclatura "OC-XXX"/"OR-XXX"';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;
    END IF;

    IF v_id_order IS NOT NULL THEN
      sql_statement := 'SELECT '|| v_field || ' from OM_ORDER WHERE id_order = ' || '''' || v_id_order || '''';
    ELSE
      sql_statement := 'SELECT '|| v_field || ' from OM_ORD_ACCOUNT WHERE id_ord_account = ' || '''' || v_id_order_account || '''' ;
    END IF;

    BEGIN
        EXECUTE IMMEDIATE sql_statement INTO v_field_value;
      EXCEPTION
        WHEN Others THEN
        ERROR_ID    := -20000;
        ERROR_DESCR := 'Error obtenido: ' || SQLERRM || ' No se pudo realizar la consulta: ' || sql_statement  ;
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END;

    Dbms_Output.Put_Line('Valor del v_field recibido : ' || v_field || ' es v_field_value: ' || v_field_value );

  EXCEPTION
    WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_order_administration.get_value_field_tables_orders] ' || SQLERRM;
  END get_value_field_tables_orders;

  procedure customize_email_template (
                                            v_id_any_type_order            VARCHAR2,
                                            v_template_email           IN  CLOB,
                                            v_email_customize_response OUT CLOB,
                                            error_id                   OUT NUMBER,
                                            error_descr                OUT VARCHAR2
                                )
  IS
--  v_email_customize_response CLOB;
  i NUMBER ;
  numRep NUMBER;
  numRepPunto NUMBER;
  numPositionIni NUMBER;
  numPositionFin NUMBER;
  itera_param VARCHAR2(200);
  value_param VARCHAR2 (200);

  BEGIN

    error_id := 0;
    error_descr := 'Ejecucion exitosa';

    Dbms_Output.Put_Line('111111111111111111');

    v_email_customize_response :=  v_template_email;

    Dbms_Output.Put_Line(v_template_email);

    select REGEXP_COUNT( v_template_email, '@') INTO numRep from dual;

    i := 1;

    WHILE i <= numRep
      LOOP

        --dbms_output.put_line(' valor de del primer @: ' || i  );

        Select INSTR( v_template_email, '@',1,i ) INTO numPositionIni from dual;
        --    dbms_output.put_line('posicion del @: ' || numPositionIni);


        Select INSTR( v_template_email, ' ', numPositionIni,1  ) INTO numPositionFin from dual;
        --    dbms_output.put_line('posicion del espacio: ' || numPositionFin);

        SELECT substr(v_template_email, (numPositionIni + 1), ( numPositionFin - (numPositionIni+1) ) ) INTO itera_param FROM  dual;
        --    dbms_output.put_line('itera_param: ' || itera_param);

        SELECT REPLACE(itera_param, ',', '' ) INTO itera_param FROM dual;

        select REGEXP_COUNT( itera_param, '\.',1) INTO numRepPunto from dual;


        --Dbms_Output.Put_Line('++numRepPunto: ' || numRepPunto);

        IF numRepPunto >= 1 THEN

          SELECT INSTR( itera_param,'.')  INTO numPositionIni FROM dual;
          SELECT substr(itera_param, 1, numPositionIni -1 ) INTO itera_param  FROM dual;

       --   dbms_output.put_line('itera_param luego del proceso: ' || itera_param);

        END IF;

        IF itera_param IS NOT NULL OR itera_param != '' THEN

        --  Dbms_Output.Put_Line('valor a enviar al sp de consumo: ' || itera_param );

          om_pack_order_administration.get_value_field_tables_orders( v_id_any_type_order, itera_param, value_param, error_id, error_descr);

        --  Dbms_Output.Put_Line('** valor retornado por el sp: ' || value_param );

           v_email_customize_response :=  REPLACE(v_email_customize_response, '@'||itera_param, value_param )  ;


        END IF;

        i := i +1 ;

    END LOOP;

     --Dbms_Output.Put_Line( v_email_customize_response );

  EXCEPTION
    WHEN Others THEN
     error_id    := SQLCODE;
     error_descr := '[om_pack_order_administration.customize_email_template] ' || SQLERRM;
  END customize_email_template;

  procedure get_all_order (
                          v_id_ord_account       IN  VARCHAR2,
                          v_id_order             IN  varchar2,
                          v_il_task_no           IN  VARCHAR2,
                          v_order_level          OUT NUMBER,
                          v_id_ord_type          OUT VARCHAR2,            -- PD
                          v_id_billing           OUT varchar2,            -- PD
                          v_id_billing_account   OUT VARCHAR2,            -- PD
                          v_customer_name        OUT VARCHAR2,            -- PD
                          v_email                OUT VARCHAR2,            -- PD
                          v_ack                  OUT VARCHAR2,            -- PD
                          v_user                 OUT VARCHAR2,            -- PD
                          v_om_obj_ord_account   OUT om_obj_get_ord_account,  -- D
                          v_om_list_get_ord      OUT om_list_get_ord,         -- D
                          error_id               out number,
                          error_descr            out VARCHAR2
                      )
 IS
 v_om_obj_get_ord       om_obj_get_ord;
 v_id_order_consult     VARCHAR2(10);
 BEGIN

    error_id := 0;
    error_descr := 'Ejecucion exitosa';

    IF  v_id_ord_account IS null THEN
      IF v_id_order IS NULL  THEN
        IF v_il_task_no IS NULL THEN
          ERROR_ID    := -20000;
          ERROR_DESCR := 'Es requerido al menos un valor para continuar con la busqueda';
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
        END IF;
      END IF;
    END IF;

    IF v_id_ord_account IS NOT null  THEN

      get_order_account( v_id_ord_account, v_om_obj_ord_account, error_id, error_descr);

      v_id_ord_type        := v_om_obj_ord_account.id_ord_type;
      v_id_billing         := v_om_obj_ord_account.id_billing ;
      v_id_billing_account := v_om_obj_ord_account.id_billing_account ;
      v_customer_name      := v_om_obj_ord_account.customer_name ;
      v_email              := v_om_obj_ord_account.email ;

      SELECT order_level INTO v_order_level FROM CFG_ORD_TYPES WHERE id_ord_type = v_id_ord_type  ;

      get_list_order( v_id_ord_account, v_om_list_get_ord, error_id, error_descr);

      --dbms_output.put_line('v_om_obj_ord_account: ' || v_om_obj_ord_account.ord_acn_status);

      BEGIN
      SELECT ack, change_who INTO v_ack ,v_user  FROM OM_ORD_ACCOUNT  WHERE id_ord_account = v_id_ord_account;
      EXCEPTION
        WHEN Others THEN
        error_id    := -20011;
        error_descr := 'error al obtener ack y usuario';
      END;

    ELSE

      IF v_il_task_no IS NOT NULL THEN
      BEGIN
          select distinct id_order INTO v_id_order_consult from OM_ORD_IL WHERE il_task_no = v_il_task_no;
        EXCEPTION
          WHEN no_data_found THEN
          ERROR_ID    := -20015;
          ERROR_DESCR := 'Error no se encontro orden asociada para el v_il_task_no: ' || v_il_task_no ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
        END;
      ELSE -- introducieron un id order
       v_id_order_consult := v_id_order;
      END IF;

      get_order( v_id_order_consult, v_om_obj_get_ord, error_id, error_descr  );

      v_om_list_get_ord := om_list_get_ord();
      v_om_list_get_ord.extend;
      v_om_list_get_ord(1) := v_om_obj_get_ord;

      v_id_ord_type        := v_om_obj_get_ord.id_ord_type;
      v_id_billing         := v_om_obj_get_ord.id_billing ;
      v_id_billing_account := v_om_obj_get_ord.id_billing_account ;
      v_customer_name      := v_om_obj_get_ord.customer_name ;
      v_email              := v_om_obj_get_ord.email ;

      SELECT order_level INTO v_order_level FROM CFG_ORD_TYPES WHERE id_ord_type = v_id_ord_type  ;

      BEGIN
      SELECT Nvl(ack,'Sin valor ACK'), change_who INTO v_ack, v_user  FROM om_order  WHERE id_order = v_id_order_consult;
      EXCEPTION
        WHEN Others THEN
        error_id    := -20011;
        error_descr := 'error al obtener ack y usuario';
      END;

    END IF;

 EXCEPTION
   WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_order_administration_ord_accounton.get_all_order] ' || SQLERRM;
 END get_all_order;

  PROCEDURE get_inf_order_account_by_order (
                            v_id_order               IN  VARCHAR2,
                            v_om_obj_ord_account     OUT om_obj_get_ord_account,  -- D
                            v_id_ord_account         OUT VARCHAR2,
                            v_count_order            OUT NUMBER,
                            v_count_order_in_process OUT NUMBER,
                            v_count_order_processed  OUT NUMBER,
                            error_id                 out number,
                            error_descr              out VARCHAR2
                        )
  IS
  BEGIN
    BEGIN
     SELECT id_ord_account INTO v_id_ord_account FROM OM_ORDER WHERE id_order = v_id_order ;
    EXCEPTION
      WHEN Others THEN
      ERROR_ID    := -20000;
      ERROR_DESCR := 'No se encontro coincidencias para el id_order: ' || v_id_order || ' en las tabla: OM_ORDER'   ;
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END;

    SELECT Count(1) INTO v_count_order FROM om_order WHERE id_ord_account = v_id_ord_account;

    SELECT Count(1) INTO v_count_order_in_process FROM om_order WHERE id_ord_account = v_id_ord_account AND order_status NOT IN (0,2);

    SELECT Count(1) INTO v_count_order_processed FROM om_order WHERE id_ord_account = v_id_ord_account AND order_status  IN (0,2);


    get_order_account (  v_id_ord_account, v_om_obj_ord_account, error_id, error_descr) ;

  EXCEPTION
    WHEN Others THEN
    error_id    := SQLCODE;
    error_descr := '[om_pack_order_administration_ord_accounton.get_all_order] ' || SQLERRM;
  END;

  PROCEDURE get_order_account (
                                  v_id_ord_account      IN  VARCHAR2,
                                  v_om_obj_ord_account  OUT om_obj_get_ord_account,  -- D
                                  error_id              out number,
                                  error_descr           out VARCHAR2
                              )
  IS
  v_data_om_ord_account om_ord_account%ROWTYPE;
  v_om_list_get_account_process om_list_get_account_process  ;
  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';
    Dbms_Output.Put_Line('aaaaaaaaaaaaa');       --  v_om_list_get_account_process ;

    get_process_account(v_id_ord_account, v_om_list_get_account_process, error_id, error_descr);

--    Dbms_Output.Put_Line('valor retronado: ' || v_om_list_get_account_process(1).ord_account_process_status);

    Dbms_Output.Put_Line( 'solicitud de procesos de tripo orden ');

    BEGIN
      SELECT  * into v_data_om_ord_account FROM om_ord_account WHERE id_ord_account = v_id_ord_account;

      v_om_obj_ord_account := om_obj_get_ord_account(
                                                      v_data_om_ord_account.id_ord_account,
                                                      v_data_om_ord_account.id_ord_type,
                                                      v_data_om_ord_account.cus_type_id,
                                                      v_data_om_ord_account.cus_num_id,
                                                      v_data_om_ord_account.id_billing,
                                                      v_data_om_ord_account.id_billing_account,
                                                      v_data_om_ord_account.ord_acn_status,
                                                      v_data_om_ord_account.ord_acn_status_msg,
                                                      v_data_om_ord_account.customer_name,
                                                      v_data_om_ord_account.prgcode,
                                                      v_data_om_ord_account.open_amount,
                                                      v_data_om_ord_account.installment_amount,
                                                      v_data_om_ord_account.invoice_number,
                                                      v_data_om_ord_account.inv_billingdate,
                                                      v_data_om_ord_account.inv_duedate,
                                                      v_data_om_ord_account.ins_duedate,
                                                      v_data_om_ord_account.email,
                                                      v_data_om_ord_account.reconnection_charge,
                                                      v_data_om_ord_account.administrative_charge,
                                                      v_om_list_get_account_process
                                                    );
    EXCEPTION
      WHEN NO_data_found  THEN
      ERROR_ID    := -20000;
      ERROR_DESCR := 'No se encontro coincidencias para el id_ord_accoun: ' || v_id_ord_account || ' en las tablas: OM_ORD_ACCOUNT'   ;
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END;

  EXCEPTION
    WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_order_administratiid_ord_accounton.get_order_account] ' || SQLERRM;
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
  END get_order_account;


 PROCEDURE get_list_all_order (
                            v_id_batch                IN  VARCHAR2,
                            v_id_ord_account          IN  VARCHAR2,
                            v_id_order                IN  VARCHAR2,
                            v_detail_batch_control    OUT SYS_REFCURSOR,
                            v_om_list_get_all_order   OUT om_list_get_all_order,
                            V_email_report            OUT CLOB,
                            v_des_process             OUT VARCHAR2,
                            error_id                  OUT NUMBER,
                            error_descr               OUT VARCHAR2

   )
 IS
    v_om_list_batch_ord            om_list_batch_ord;         -- lista de ordenes
    v_om_obj_get_all_order         om_obj_get_all_order; -- restructurar
    v_index                        NUMBER;
    v_get_order_level              NUMBER;
    v_get_id_ord_type              VARCHAR2(10);
    v_get_id_billing               VARCHAR2(10);
    v_get_id_billing_account       VARCHAR2(10);
    v_get_customer_name            VARCHAR2(255);
    v_get_email                    VARCHAR2(255);
    v_get_ack                      VARCHAR2(50);
    v_get_user                     VARCHAR2(50);
    v_get_om_obj_ord_account       om_obj_get_ord_account;
    v_get_om_list_get_ord          om_list_get_ord ;
 BEGIN
  v_index := 1;

  error_id := 0;
  error_descr := 'Ejecucion exitosa';


  open v_detail_batch_control FOR
  SELECT * FROM om_batch_control WHERE id_batch = v_id_batch;

  Dbms_Output.Put_Line('Lectura de las ordenes de tipo cuenta en una cuenta batch: ' || v_id_batch);
  v_om_list_get_all_order := om_list_get_all_order();
  FOR p IN (SELECT * FROM om_batch_control WHERE id_batch = v_id_batch ) LOOP

    Dbms_Output.Put_Line('CUENTA: ' || P.id_ord_account);

    v_om_list_get_all_order.extend;

  om_pack_order_administration.get_all_order(
                P.id_ord_account,
                NULL,
                NULL,
                v_get_order_level,
                v_get_id_ord_type,
                v_get_id_billing,
                v_get_id_billing_account,
                v_get_customer_name,
                v_get_email,
                v_get_ack,
                v_get_user,
                v_get_om_obj_ord_account,
                v_get_om_list_get_ord,
                error_id,
                error_descr
                  );
   Dbms_Output.Put_Line('v_get_id_ord_type: '|| v_get_id_ord_type);


  v_om_list_get_all_order(v_index) := om_obj_get_all_order(
                                                            v_get_order_level,
                                                            v_get_id_ord_type,
                                                            v_get_id_billing,
                                                            v_get_id_billing_account,
                                                            v_get_customer_name,
                                                            v_get_email,
                                                            v_get_ack,
                                                            v_get_user,
                                                            v_get_om_obj_ord_account,
                                                            v_get_om_list_get_ord
                                                          );

  v_index := v_index + 1;
  END LOOP;
  -- obtener una lista de las ordenes creadas

   --Dbms_Output.Put_Line('valor de la lista luego de llenarla: ' || v_om_list_get_all_order(1).id_billing_account);
   --Dbms_Output.Put_Line('valor de la lista luego de llenarla: ' || v_om_list_get_all_order(2).id_billing_account);

   BEGIN
   SELECT html_template INTO V_email_report FROM  CFG_ORD_SMS  WHERE id_ord_type = 'OT-037';

   SELECT distinct(description) INTO v_des_process FROM om_batch_control a INNER JOIN OM_ORD_ACCOUNT B ON(A.id_ord_account = B.id_ord_account)
                                   INNER JOIN CFG_ORD_TYPES  C ON(B.id_ord_type = C.id_ord_type)
                                   WHERE id_batch = v_id_batch;

   EXCEPTION
     WHEN Others THEN
     error_id    := SQLCODE;
     error_descr := '[om_pack_order_administratiid_ord_accounton.get_list_all_order] '||' error cargando el email del reporte' || SQLERRM;
   END;



 EXCEPTION
   WHEN Others THEN
     error_id    := SQLCODE;
     error_descr := '[om_pack_order_administratiid_ord_accounton.get_list_all_order] ' || SQLERRM;
     -- RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);

 END get_list_all_order;




  PROCEDURE get_list_order (
                            v_id_ord_account      IN  VARCHAR2,
                            v_om_list_get_ord     OUT om_list_get_ord,
                            error_id              out number,
                            error_descr           out VARCHAR2
                            )
  IS
   v_index1 NUMBER := 1;
   v_om_obj_get_ord om_obj_get_ord;
  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';

    v_om_list_get_ord := om_list_get_ord();

    FOR i IN ( SELECT * FROM OM_ORDER WHERE id_ord_account = v_id_ord_account )  LOOP
      v_om_list_get_ord.extend;
      get_order( i.id_order, v_om_obj_get_ord, error_id, error_descr  );
      v_om_list_get_ord(v_index1) := v_om_obj_get_ord;
      v_index1 := v_index1 + 1;
    END LOOP;

    --    dbms_output.put_line(' v_om_list_get_ord.item_value : ' || v_om_list_get_ord(2).msisdn);

  END get_list_order;



  PROCEDURE get_order (
                          v_id_order            IN  VARCHAR2,
                          v_om_obj_get_ord      OUT om_obj_get_ord,  -- D
                          error_id              out number,
                          error_descr           out VARCHAR2
                      )
  IS
  v_data_om_order OM_ORDER%ROWTYPE;
  v_om_list_get_ord_item om_list_get_ord_item := om_list_get_ord_item();
  v_om_list_get_process om_list_get_process := om_list_get_process();
  v_om_list_get_ord_il om_list_get_ord_il := om_list_get_ord_il();
  v_index NUMBER := 1 ;
  v_attr1_value VARCHAR2(144);
  v_package_service VARCHAR2(30);
  BEGIN

    error_id := 0;
    error_descr := 'Ejecucion exitosa';
    BEGIN
      SELECT  * into v_data_om_order FROM OM_ORDER WHERE id_order = v_id_order;
    EXCEPTION
      WHEN NO_data_found  THEN
      ERROR_ID    := -20000;
      ERROR_DESCR := 'No se encontro coincidencias para el id_order: ' || v_id_order || ' en las tablas: OM_ORDER'   ;
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END;

    BEGIN
      FOR i_order_item IN ( select * from OM_ORDER_ITEM WHERE id_order = v_id_order ) LOOP
      -- ubicando el paquete del servicio
      IF i_order_item.id_ord_item_type = 'OIT-001' OR i_order_item.id_ord_item_type = 'OIT-008' THEN
        BEGIN
        select attr1 INTO v_package_service from CFG_SERVICES WHERE id_service = i_order_item.item_value;
        v_attr1_value := v_package_service;
        EXCEPTION
          WHEN Others THEN
            v_attr1_value := 'Package not avalaible';
        END;
      ELSE
        v_attr1_value := i_order_item.attr1_value;
      END IF;
      -- ubicando el paquete del servicio
        v_om_list_get_ord_item.extend;
        v_om_list_get_ord_item( v_index ) := om_obj_get_ord_item(
                                                                  i_order_item.id_order_item,
                                                                  i_order_item.id_order,
                                                                  i_order_item.id_ord_item_type,
                                                                  i_order_item.item_value,
                                                                  v_attr1_value,
                                                                  i_order_item.attr2_value,
                                                                  i_order_item.attr3_value,
                                                                  i_order_item.order_item_status,
                                                                  i_order_item.order_item_status_msg
        );
        v_index := v_index + 1;
--        dbms_output.put_line('i_order_item.item_value: ' || i_order_item.item_value);
      END LOOP;

      -- Recuperar los procesos para una orden
      get_process(v_id_order,v_om_list_get_process,error_id,error_descr);
      --      dbms_output.put_line('Valor de la listaaaa: ' || v_om_list_get_ord_item(1).item_value);

      BEGIN
      Dbms_Output.Put_Line('inicio');
        get_list_order_il(v_id_order,v_om_list_get_ord_il, error_id, error_descr);
        Dbms_Output.Put_Line('Luego de la ejecucion');
      EXCEPTION
        WHEN others THEN -- sin ordenes de Instalink para recuperar
        Dbms_Output.Put_Line('paso por aquiiiiii');
          v_om_list_get_ord_il := NULL;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);

      END;


      v_om_obj_get_ord := om_obj_get_ord(
                                          v_data_om_order.id_order,
                                          v_data_om_order.id_ord_type,
                                          v_data_om_order.id_ord_account,
                                          v_data_om_order.cus_type_id,
                                          v_data_om_order.cus_num_id,
                                          v_data_om_order.id_billing,
                                          v_data_om_order.id_billing_account,
                                          v_data_om_order.co_code,
                                          v_data_om_order.msisdn,
                                          v_data_om_order.order_status,
                                          v_data_om_order.order_status_msg,
                                          v_data_om_order.id_external_app_err,
                                          v_data_om_order.id_external_app_err_msg,
                                          v_data_om_order.customer_name,
                                          v_data_om_order.prgcode,
                                          v_data_om_order.open_amount,
                                          v_data_om_order.installment_amount,
                                          v_data_om_order.invoice_number,
                                          v_data_om_order.inv_billingdate,
                                          v_data_om_order.inv_duedate,
                                          v_data_om_order.ins_duedate,
                                          v_data_om_order.email,
                                          v_data_om_order.reconnection_charge,
                                          v_data_om_order.administrative_charge,
                                          v_data_om_order.threshold_id,
                                          v_data_om_order.th_consumption,
                                          v_data_om_order.th_unit,
                                          v_data_om_order.tm_code,
                                          v_om_list_get_ord_item,
                                          v_om_list_get_process,
                                          v_om_list_get_ord_il
                                                    );
    END;
--    dbms_output.put_line('v_data_om_order: ' || v_data_om_order.id_ord_type);
  EXCEPTION
    WHEN Others THEN
      error_id := SQLCODE;
      error_descr := '[om_pack_order_administration.get_order] ' || SQLERRM;
  END get_order;

  PROCEDURE get_process(
                        v_id_order              IN  VARCHAR2,
                        v_om_list_get_process   OUT om_list_get_process,
                        error_id                OUT number,
                        error_descr             OUT VARCHAR
                      )
  IS
  v_index NUMBER := 1 ;
  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';
    v_om_list_get_process :=  om_list_get_process();
    FOR i IN (
        SELECT a.id_order,a.id_ord_process, a.order_process_status, a.order_process_status_msg, a.created_dt, a.created_who, a.active_dt, a.change_dt, a.change_who, a.inactive_dt
                            FROM OM_ORDER_PROCESS a
                                      INNER JOIN OM_ORDER b               ON (a.id_order    = b.id_order)
                                      INNER JOIN CFG_ORD_STRUCT_PROCESS c ON (c.id_ord_type = b.id_ord_type AND a.id_ord_process = c.id_ord_process)
                                      WHERE a.id_order = v_id_order
                                  ORDER BY priority
    ) LOOP
      v_om_list_get_process.extend;
      v_om_list_get_process(v_index) := om_obj_get_process(
                                                            i.id_order,
                                                            i.id_ord_process,
                                                            i.order_process_status,
                                                            i.order_process_status_msg
                                                          );
      v_index := v_index + 1;
    END LOOP;

    IF  v_om_list_get_process.Count = 0 OR v_om_list_get_process IS null  THEN
      error_id := -20999;
      error_descr := 'No existen procesos registrados para el id_order: ' || v_id_order;
      Raise_Application_Error( error_id, error_descr);
    END IF;

    EXCEPTION
      WHEN Others THEN
        error_id := SQLCODE;
        error_descr := '[om_pack_order_administration.get_process] ' || SQLERRM;
  END get_process;

  PROCEDURE get_process_account(
                                  v_id_ord_account                IN  VARCHAR2,
                                  v_om_list_get_account_process   OUT om_list_get_account_process,
                                  error_id                        OUT number,
                                  error_descr                     OUT VARCHAR
                    )
  IS
  v_index NUMBER := 1 ;

  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';
    v_om_list_get_account_process := om_list_get_account_process();
    FOR i IN (
              SELECT a.id_ord_account, a.id_ord_account_process, a.ord_account_process_status, a.ord_account_process_status_msg, a.create_dt, a.create_who, a.active_dt, a.change_dt, a.change_who, a.inactive_dt
                                  FROM om_ord_account_process a
                                            INNER JOIN OM_ORD_ACCOUNT b                  ON (a.id_ord_account    = b.id_ord_account)
                                            INNER JOIN cfg_ord_account_struct_process c  ON (c.id_ord_type = b.id_ord_type
                                                                                            AND a.id_ord_account_process = c.id_ord_account_process)
                                            WHERE a.id_ord_account = v_id_ord_account
                                        ORDER BY priority

    ) LOOP
      v_om_list_get_account_process.extend;
      v_om_list_get_account_process(v_index) := om_obj_get_account_process(
                                                            i.id_ord_account,
                                                            i.id_ord_account_process,
                                                            i.ord_account_process_status,
                                                            i.ord_account_process_status_msg
                                                          );
      v_index := v_index + 1;
    END LOOP;

--    Dbms_Output.Put_Line('aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii' || '*'||v_id_ord_account||'*' );

     Dbms_Output.Put_Line('valor del proceso recibido: '||v_id_ord_account );

    IF v_om_list_get_account_process.Count = 0 THEN
      error_id := -20888;
      error_descr := 'No existen procesos registrados para el v_id_ord_account: ' || v_id_ord_account;
      Raise_Application_Error( error_id, error_descr);
    END IF;

    EXCEPTION
      WHEN Others THEN
        error_id := SQLCODE;
        error_descr := '[om_pack_order_administration.get_process_account] ' || SQLERRM;
  END get_process_account;



  PROCEDURE get_list_order_il (
                      v_id_order            IN  VARCHAR2,
                      v_om_list_get_ord_il  OUT om_list_get_ord_il,
                      error_id              out number,
                      error_descr           out VARCHAR2
                    )
  IS
   v_index NUMBER := 1 ;
  BEGIN
    error_id := 0;
    error_descr := 'Ejecucion exitosa';
    v_om_list_get_ord_il := om_list_get_ord_il();
      FOR i IN ( SELECT * FROM OM_ORD_IL WHERE ID_ORDER = v_id_order ORDER BY   To_Number(regexp_replace(id_order_il, '[aA-zZ]+\-', ''))) LOOP
        v_om_list_get_ord_il.extend;
        v_om_list_get_ord_il(v_index) := om_obj_get_ord_il(
                                                            i.id_order,
                                                            i.id_order_il,
                                                            i.il_order_no,
                                                            i.il_task_no,
                                                            i.ord_il_status,
                                                            i.ord_il_status_msg
                                                            );
        v_index := v_index + 1;
      END LOOP;

    --      IF v_om_list_get_ord_il.Count = 0 THEN
    --        error_id := -20010;
    --        error_descr := 'Sin ordenes de il para la orden: ' || v_id_order ;
    --        Raise_Application_Error( error_id, error_descr);
    --      END IF;

  EXCEPTION
    WHEN Others THEN
      error_id := SQLCODE;
      error_descr := '[om_pack_order_administration.get_list_order_il] ' || SQLERRM;
  END get_list_order_il;

    PROCEDURE GET_XML_IL   (
                      V_ID_ORDER_IL      VARCHAR,
                      V_XML              OUT CLOB,
                      ERROR_ID           OUT NUMBER,
                      ERROR_DESCR        OUT VARCHAR2)
  IS
  v_data_om_order OM_ORDER%ROWTYPE;
  v_imsi VARCHAR2(50);
  v_id_order VARCHAR(50);
  BEGIN

     error_id := 0;
     error_descr := 'Ejecucion exitosa';

    SELECT id_order INTO v_id_order FROM OM_ORD_IL WHERE id_order_il = V_ID_ORDER_IL;

    SELECT * INTO v_data_om_order FROM OM_ORDER WHERE id_order = v_id_order;

    SELECT item_value INTO v_imsi FROM OM_ORDER_ITEM WHERE id_ord_item_type = 'OIT-003' AND id_order = v_id_order ;


--     V_XML := '<?xml version="1.0"?>' ||
--              '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"> '||
--              '  <soap:Header>' ||
--              '    <wsse:UsernameToken>' ||
--              '      <wsse:Username>POSBATCH</wsse:Username>' ||
--              '      <wsse:Password>Digitel412</wsse:Password>' ||
--              '    </wsse:UsernameToken>' ||
--              '    <wsa:Action>http://localhost:44280/axis/services/SOAPApi</wsa:Action>' ||
--              '    <wsa:MessageID>CRM360</wsa:MessageID>' ||
--              '    <wsa:ReplyTo>' ||
--              '      <wsa:Address>http://10.192.98.108:7010/om-service-request-0.0.1/responseServlet</wsa:Address>' ||
----              '      <wsa:Address>http://10.192.98.54:7003/ServisRequestIL/ResponseILServlet</wsa:Address>' ||
--              '    </wsa:ReplyTo>' ||
--              '  </soap:Header>' ||
--              '  <soap:Body>' ||
--              '    <REQUEST xmlns="http://www.comptel.com/ilink/api/soap/2005/09" NE_TYPE="HLR" REQ_TYPE="1" REQ_USER="POSBATCH">' ||
--              '      <Parameter name="BSTINST" value="POST"/>' ||
--              '      <Parameter name="IMSI1" value="734027010340018"/>' ||
--              '      <Parameter name="MSISDN1" value="582546811038"/>' ||
--              '      <Parameter name="ORDER_NO" value="2546811038"/>' ||
--              '      <Parameter name="ORDER_TYPE" value="CREATE_SUBSCRIBER"/>' ||
--              '      <Parameter name="SUB_TYPE" value="14"/>' ||
--              '      <Parameter name="VMS_REQUEST" value="1"/>' ||
--              '      <Parameter name="VMS_SERVICE" value="320"/>' ||
--              '    </REQUEST>' ||
--              '  </soap:Body>' ||
--              '</soap:Envelope>'
--          ;

     V_XML := '<?xml version="1.0"?>' ||
              '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:wsa="http://www.w3.org/2005/08/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"> '||
              '  <soap:Header>' ||
              '    <wsse:UsernameToken>' ||
              '      <wsse:Username>POSBATCH</wsse:Username>' ||
              '      <wsse:Password>Digitel412</wsse:Password>' ||
              '    </wsse:UsernameToken>' ||
              '    <wsa:Action>http://localhost:44280/axis/services/SOAPApi</wsa:Action>' ||
              '    <wsa:MessageID>CRM360</wsa:MessageID>' ||
              '    <wsa:ReplyTo>' ||
--              '      <wsa:Address>http://10.192.98.108:7010/om-service-request-0.0.1/responseServlet</wsa:Address>' ||
              '      <wsa:Address>http://10.192.98.54:7003/ServisRequestIL/ResponseILServlet</wsa:Address>' ||
              '    </wsa:ReplyTo>' ||
              '  </soap:Header>' ||
              '  <soap:Body>' ||
              '    <REQUEST xmlns="http://www.comptel.com/ilink/api/soap/2005/09" NE_TYPE="HLR" REQ_TYPE="1" REQ_USER="soapapi">' ||
              '      <Parameter name="BSTINST" value="POST"/>' ||
              '      <Parameter name="IMSI1" value="'||v_imsi||'"/>' ||
              '      <Parameter name="MSISDN1" value="' || v_data_om_order.msisdn ||'"/>' ||
              '      <Parameter name="ORDER_NO" value="' || v_data_om_order.msisdn || '"/>' ||
              '      <Parameter name="ORDER_TYPE" value="MODIFY_SUBSCRIBER"/>' ||
              '      <Parameter name="GPRS_REQUEST" value="1"/>' ||
              '      <Parameter name="LTE_LOCK_REQUEST" value="1"/>' ||
              '    </REQUEST>' ||
              '  </soap:Body>' ||
              '</soap:Envelope>'
          ;


  EXCEPTION
    WHEN Others THEN
    ERROR_ID    := SQLCODE;
    ERROR_DESCR := '[om_pack_order_administration.GET_XML_IL]:  '|| SQLERRM;
  END GET_XML_IL;


  procedure change_status_order_il (
                                          v_id_order              VARCHAR2,
                                          v_id_order_il_no        VARCHAR2,
                                          v_id_task_no            VARCHAR2,
                                          v_status_new            NUMBER,
                                          v_status_description    VARCHAR2,
                                          error_id                out number,
                                          error_descr             out VARCHAR2
                                      )
  IS
  v_status_old NUMBER := 99;
  BEGIN

    error_id := 0;
    error_descr := 'Ejecucion exitosa';

  -- *****************
  -- *****************
   -- codigo que inserta si no existe momentaneo debe ser eliminado el el flujo normal

      BEGIN
        SELECT ord_il_status INTO v_status_old FROM OM_ORD_IL WHERE id_order = v_id_order AND id_order_il = v_id_order_il_no ; --AND id_ord_process = v_id_ord_process;
      EXCEPTION
        WHEN No_Data_Found THEN
--          ERROR_ID    := -20002;
--          ERROR_DESCR := 'No se encontro el id_ord_process: ' || v_id_ord_process || ' para la orden: ' || v_id_ord ;
--          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
        Dbms_Output.Put_Line('No existe el la orden en la tabla! procesos TEMPORAL');
      END;
      IF v_status_old != 99 THEN
        om_pack_configuration.validate_life_cycle_for_states( v_status_new, v_status_old, error_id, error_descr );
      END IF;

      UPDATE OM_ORD_IL SET
--        id_order          =   v_id_order,                         --id_order
--        id_order_il       =   'IL-'||om_seq_id_order_il.NEXTVAL,  --id_order_il
--        il_order_no       =   v_id_task_no,                       --il_order_no
        il_task_no        =   v_id_task_no,                       --il_task_no
        ord_il_status     =   v_status_new,                       --ord_il_status
        ord_il_status_msg =   v_status_description,               --ord_il_status_msg
--        created_dt        =   SYSDATE,                            --created_dt
--        created_who       =   'Cristancho',                       --created_who
--        active_dt         =   SYSDATE,                            --active_dt
        change_dt         =   SYSDATE                            --change_dt
--        change_who        =   'Cristancho',                       --change_who
--        inactive_dt       =   SYSDATE                             --inactive_dt
      WHERE
          id_order =  v_id_order
      AND id_order_il = v_id_order_il_no
        ;

       IF SQL%NOTFOUND THEN
          Dbms_Output.Put_Line('No existe la orden cargada!! se inserta...');
          INSERT  INTO OM_ORD_IL  VALUES(
            v_id_order,                         --id_order
            'IL-'||om_seq_id_order_il.NEXTVAL,  --id_order_il
            v_id_task_no,                       --il_order_no
            v_id_task_no,                       --il_task_no
            v_status_new,                       --ord_il_status
            v_status_description,               --ord_il_status_msg
            SYSDATE,                            --created_dt
            'Cristancho',                       --created_who
            SYSDATE,                            --active_dt
            SYSDATE,                            --change_dt
            'Cristancho',                       --change_who
            SYSDATE                             --inactive_dt
          );
       END IF;
   -- codigo que inserta si no existe momentaneo debe ser eliminado el el flujo normal
  -- *****************
  -- *****************
  COMMIT;
  EXCEPTION
    WHEN Others THEN
     error_id := SQLCODE;
     error_descr := '[om_pack_order_administration.change_status_order_il] ' || SQLERRM;
     ROLLBACK;
  END change_status_order_il;

 PROCEDURE get_batch_billing_presement (batch_billing_presement    out sys_refcursor,
                                       error_id           out number,
                                       error_descr        out varchar2)
    IS
    begin

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

    begin

      open batch_billing_presement for

           SELECT
           A.ID_BILLING_ACCOUNT, A.ID_CONTRACT, A.ID_PLAN, A.GSM, A.PRGCODE, A.PAYMENT_METHOD, A.BILLCICLE,
           A.EMAIL, A.DATE_OPERATION

           FROM OM_BATCH_BILLING_PRESEMENT A ORDER BY A.ID_BILLING_ACCOUNT, A.ID_CONTRACT, A.ID_PLAN;

           dbms_output.put_line('valor de las filas devueltas: ' || batch_billing_presement%rowCount);
      IF batch_billing_presement%NOTFOUND = true THEN
          error_id    := -20000;
          error_descr := '[om_pack_order_administration.get_om_batch_billing_presement] no existen registros cargados';
      END IF;
    exception
      when no_data_found then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_om_batch_billing_presement]';
      when others then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_om_batch_billing_presement]';
    END get_batch_billing_presement;

  END get_batch_billing_presement;

  PROCEDURE get_batch_cancellation (               v_data_cancellation out sys_refcursor,
                                                          error_id             out number,
                                                          error_descr          out varchar2)
    is
    BEGIN
        error_id    := 0;
        error_descr := 'ejecucion exitosa';

          open v_data_cancellation for
              SELECT * FROM om_batch_cancellation  ;

        exception
          when no_data_found then
            error_id    := -50000;
            error_descr := '[om_pack_order_administration.get_batch_cancellation]';
          when others then
            error_id    := -50000;
            error_descr := '[om_pack_order_administration.get_batch_cancellation]';

    END get_batch_cancellation;

    PROCEDURE get_batch_suspe (                          v_data_susp out sys_refcursor,
                                                        error_id             out number,
                                                        error_descr          out varchar2)
   IS
   BEGIN

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

    UPDATE om_batch_suspen SET (is_ord_tipy_actionable) = ('NO')
          WHERE id_ord_type IN (
                                SELECT id_ord_type FROM om_batch_suspen -- WHERE 1 != 1
                                        MINUS
                                SELECT id_ord_type FROM CFG_ORD_TYPES WHERE id_channel = 'BATCH' AND ID_ACTION LIKE '1_'
                               );

    UPDATE om_batch_suspen SET (is_ord_tipy_actionable) = ('SI') WHERE is_ord_tipy_actionable != 'NO' OR is_ord_tipy_actionable IS NULL  ;

    COMMIT;

      open v_data_susp for
          SELECT id_billing_account, b.id_ord_type, is_ord_tipy_actionable, id_contract, gsm,
                 simcard, imsi, id_plan, attr1 AS id_package, c.id_service, SubStr(id_action,2) AS level_operation, type_sim
          FROM       om_batch_suspen a
          INNER JOIN cfg_ord_types   b ON (a.id_ord_type = b.id_ord_type)
          INNER JOIN cfg_services    c ON (b.action = c.id_service)
          ORDER BY  is_ord_tipy_actionable DESC,a.id_ord_type, id_billing_account ;
    exception
      when no_data_found then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_batch_suspe]';
      when others then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_batch_suspe]';

   END get_batch_suspe;

   PROCEDURE get_batch_react (                 v_data_react out sys_refcursor,
                                                  error_id             out number,
                                                  error_descr          out VARCHAR2 )
   IS
   BEGIN

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

      open v_data_react for
          SELECT * FROM om_batch_reactiva  ;

    exception
      when no_data_found then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_batch_react]';
      when others then
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.get_batch_react]';

   END get_batch_react;

  PROCEDURE create_group_notification (             v_type_notification         NUMBER := 0 ,-- 0 = SMS 1 =EMAIL 2 = AMBOS
                                                                v_om_list_notification      om_list_notification,
                                                                v_id_notification_lote      OUT VARCHAR2,
                                                                error_id                    out number,
                                                                error_descr                 out varchar2)
  IS
  v_id_notification       VARCHAR2(200);
  v_om_obj_notification om_obj_notification;
  v_is_list_empity NUMBER := 0;
  BEGIN

--    IF v_om_list_notification IS null THEN
--      v_is_list_empity := 1 ;
--      ERROR_ID    := -20000;
--      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
--    END IF;

    SELECT 'GNOTI-'|| om_seq_id_notification_lote.NEXTVAL INTO v_id_notification_lote FROM dual;
      FOR i in v_om_list_notification.first .. v_om_list_notification.last LOOP

        SELECT 'N-'|| om_seq_id_notification.NEXTVAL INTO v_id_notification FROM dual;

        Dbms_Output.Put_Line(v_om_list_notification(i).id_batch);

        INSERT INTO om_control_notification  VALUES(
          v_id_notification,                          -- id_notification
          v_id_notification_lote,                     -- id_notification_lote
          NULL,                                       -- id_notification_lote_send
          v_type_notification,                        -- type_notification
          v_om_list_notification(i).id_batch,         -- id_batch
          v_om_list_notification(i).id_ord_account,   -- id_ord_account
          v_om_list_notification(i).id_order,         -- id_order
          v_om_list_notification(i).message_id,        -- message_id
          4,                                          -- status
          NULL,                                       -- description
          SYSDATE,                                    -- created_dt
          null                                        -- inactive_dt
        );

      UPDATE OM_ORDER_PROCESS SET (order_process_status) = (0) WHERE id_order = v_om_list_notification(i).id_order AND id_ord_process = 'OP-001';

--       BEGIN
--        closed_order_contract (v_om_list_notification(i).id_order,'EXITO BD','Cristian',error_id,error_descr  );
--       EXCEPTION
--         WHEN Others THEN
--         NULL;
--       END;

      END LOOP;

      COMMIT;

  Dbms_Output.Put_Line('v_id_notification: '|| v_id_notification );
  error_id := 0;
  error_descr := 'Ejecucion exitosa';

  EXCEPTION
    WHEN Others THEN
        v_id_notification_lote := NULL;
        error_id    := -50008;
        error_descr := '[om_pack_order_administration.create_group_notification]' || SQLERRM;

        IF error_id = -20000 OR v_is_list_empity = 1 THEN
        Dbms_Output.Put_Line('******************************************');
        error_id := 0;
        ERROR_DESCR := '[om_pack_order_administration.create_group_notification] om_list_notification vacia! sin registros para procesar ' ;
        END IF;

  END create_group_notification;

  procedure get_lot_notification_cur (
                                                  v_number_noti                   number,
                                                  v_id_notification_lote_send OUT VARCHAR2,
                                                  v_om_lot_list_control_noti  OUT sys_refcursor,
                                                  v_quantity_lot              OUT NUMBER,
                                                  error_id                    OUT NUMBER,
                                                  error_descr                 OUT VARCHAR2
                                      )
    IS
    v_om_list_control_notification  om_list_control_notification;
    v_quantity_register_avaible NUMBER;

    v_response_sms        VARCHAR2(200);
    v_response_email      CLOB;
    v_issue               VARCHAR2(200);
    v_group_prg_code      VARCHAR2(100);

    v_msisdn               VARCHAR2(20);

    BEGIN

      -- Cantida de registro disponible para la operacion
      SELECT Count (1) INTO v_quantity_register_avaible  FROM om_control_notification WHERE status = 4 ;
      Dbms_Output.Put_Line('Cantida total de registros disponibles: ' || v_quantity_register_avaible );
      Dbms_Output.Put_Line('Cantidad de notificaciones por lote: ' || v_number_noti);
      --  cantidad de lote por operacion
      SELECT Ceil(v_quantity_register_avaible/v_number_noti) INTO v_quantity_lot FROM dual;
      Dbms_Output.Put_Line('Numero de lote para el envio; ' || v_quantity_lot );
      -- id de lote de envio
      SELECT 'LSEND-'|| om_seq_id_noti_lote_send.NEXTVAL INTO v_id_notification_lote_send FROM dual;

      IF v_quantity_register_avaible = 0 THEN
            ERROR_ID    := -20002;
            ERROR_DESCR := 'Sin registros para procesar' ;
            RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;


        v_om_list_control_notification := om_list_control_notification();

  --      open v_om_lot_list_control_noti FOR
  --      SELECT rownum,a.ROWID, a.* FROM om_control_notification a
  --            WHERE  status = 4;

        FOR i IN (SELECT rownum,a.ROWID, a.* FROM om_control_notification a
              WHERE  status = 4 AND ROWNUM <= 20) LOOP


          -- Ubicar los sms para cada orden ...
          BEGIN
            om_pack_order_administration.get_notification(i.id_order, 0, i.message_id, v_response_sms, v_response_email, v_issue, v_group_prg_code, error_id, error_descr  );

            SELECT msisdn INTO v_msisdn  FROM om_order WHERE id_order = i.id_order;

            v_om_list_control_notification.extend;
            v_om_list_control_notification(i.ROWNUM):= om_obj_control_notification(
                                                                              i.id_notification,             -- id_notification              VARCHAR2(200), -- id unico para cada transaccion
                                                                              v_id_notification_lote_send,       -- id_notification_lote_send    VARCHAR2(200), -- id del lote enviado
                                                                              v_msisdn,                          -- gsm                          VARCHAR2(20),
                                                                              v_response_sms                     -- sms                          VARCHAR2(200)
            );

            Dbms_Output.Put_Line(v_response_sms);
            UPDATE om_control_notification SET (status) = (3), id_notification_lote_send = v_id_notification_lote_send, description = '->ENVIADO' WHERE ROWID = i.ROWID  ;


            BEGIN
            SELECT msisdn INTO v_msisdn FROM om_order WHERE id_order = i.id_order ;
            EXCEPTION
              WHEN Others THEN
              UPDATE om_control_notification SET (status) = (2), id_notification_lote_send = v_id_notification_lote_send ,description = description || '->Error encontrando la orden'   WHERE ROWID = i.ROWID  ;
            END;

          EXCEPTION
            WHEN Others THEN
              NULL;
              UPDATE om_control_notification SET (status) = (2), id_notification_lote_send = v_id_notification_lote_send, description = description || '->Error obteniendo el mensaje'   WHERE ROWID = i.ROWID  ;
          END;
          -- Ubicar los sms para cada orden ...

        END LOOP;

        open v_om_lot_list_control_noti FOR
        SELECT * FROM TABLE(v_om_list_control_notification);

  --        FOR i IN v_om_list_control_notification.first .. v_om_list_control_notification.last LOOP
  --        Dbms_Output.Put_Line('--------');

  --         Dbms_Output.Put_Line(v_om_list_control_notification(i).id_notification);
  --         Dbms_Output.Put_Line(v_om_list_control_notification(i).id_notification_lote_send);
  --         Dbms_Output.Put_Line(v_om_list_control_notification(i).gsm);
  --         Dbms_Output.Put_Line(v_om_list_control_notification(i).sms);

  --        END LOOP;
        -- quitar! solo para desarrollo!!!!!!
  --        UPDATE om_control_notification SET (status) = (4) ;
  --        ROLLBACK;
      COMMIT;

      error_id := 0;
      error_descr := 'Ejecucion exitosa';

    EXCEPTION
      WHEN Others THEN
      IF error_id IS null THEN
        error_id    := -50000;
      END IF;

      error_descr := '[om_pack_order_administration.get_lot_notification]' || SQLERRM ;
      v_id_notification_lote_send := NULL;
      ROLLBACK;
    END get_lot_notification_cur;

    procedure get_lot_notification_est (
                                            v_number_noti                   number,
                                            v_max_register                  NUMBER,
                                            v_number_avalaible          OUT NUMBER,
                                            v_id_notification_lote_send OUT VARCHAR2,
                                            v_om_list_control_notification OUT om_list_control_notification,
                                            v_quantity_lot              OUT NUMBER,
                                            error_id                    OUT NUMBER,
                                            error_descr                 OUT VARCHAR2
                                        )
  IS

--  v_om_list_control_notification  om_list_control_notification;
  v_quantity_register_avaible NUMBER;

  v_response_sms        VARCHAR2(200);
  v_response_email      CLOB;
  v_issue               VARCHAR2(200);
  v_group_prg_code      VARCHAR2(100);

  v_msisdn               VARCHAR2(20);
  cont NUMBER := 1;

  BEGIN
   -- Cantida de registro disponible para la operacion
    SELECT Count (1) INTO v_quantity_register_avaible  FROM om_control_notification WHERE status = 4 ;
    Dbms_Output.Put_Line('Cantida total de registros disponibles: ' || v_quantity_register_avaible );
    Dbms_Output.Put_Line('Cantidad de notificaciones por lote: ' || v_number_noti);
    --  cantidad de lote por operacion
    SELECT Ceil(v_quantity_register_avaible/v_number_noti) INTO v_quantity_lot FROM dual;
    Dbms_Output.Put_Line('Numero de lote para el envio; ' || v_quantity_lot );
    -- id de lote de envio
    SELECT 'LSEND-'|| om_seq_id_noti_lote_send.NEXTVAL INTO v_id_notification_lote_send FROM dual;

    IF v_quantity_register_avaible = 0 THEN
          ERROR_ID    := -20002;
          ERROR_DESCR := 'Sin registros para procesar' ;
          RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END IF;

      v_om_list_control_notification := om_list_control_notification();

--      open v_om_lot_list_control_noti FOR
--      SELECT rownum,a.ROWID, a.* FROM om_control_notification a
--            WHERE  status = 4;

      FOR i IN (SELECT rownum,a.ROWID, a.* FROM om_control_notification a
            WHERE  status = 4 AND ROWNUM <= v_max_register) LOOP


        -- Ubicar los sms para cada orden ...
        BEGIN
          om_pack_order_administration.get_notification(i.id_order, 0, i.message_id, v_response_sms, v_response_email, v_issue, v_group_prg_code, error_id, error_descr  );

          SELECT msisdn INTO v_msisdn  FROM om_order WHERE id_order = i.id_order;

          v_om_list_control_notification.extend;
          v_om_list_control_notification(i.ROWNUM):= om_obj_control_notification(
                                                                            i.id_notification,             -- id_notification              VARCHAR2(200), -- id unico para cada transaccion
                                                                            v_id_notification_lote_send,       -- id_notification_lote_send    VARCHAR2(200), -- id del lote enviado
                                                                            v_msisdn,                          -- gsm                          VARCHAR2(20),
                                                                            v_response_sms                     -- sms                          VARCHAR2(200)
          );

--          Dbms_Output.Put_Line(v_response_sms);
          UPDATE om_control_notification SET (status) = (3), id_notification_lote_send = v_id_notification_lote_send, description = '->ENVIADO' WHERE ROWID = i.ROWID  ;

          BEGIN
          SELECT msisdn INTO v_msisdn FROM om_order WHERE id_order = i.id_order ;
          EXCEPTION
            WHEN Others THEN
            UPDATE om_control_notification SET (status) = (2), id_notification_lote_send = v_id_notification_lote_send ,
            description = description || '->Error encontrando la orden'   WHERE ROWID = i.ROWID  ;
          END;

        EXCEPTION
          WHEN Others THEN
            NULL;
            UPDATE om_control_notification SET (status) = (2), id_notification_lote_send = v_id_notification_lote_send,
            description = description || '->Error obteniendo el mensaje'   WHERE ROWID = i.ROWID  ;
        END;
        -- Ubicar los sms para cada orden ...

      END LOOP;

--        FOR i IN v_om_list_control_notification.first .. v_om_list_control_notification.last LOOP
--          Dbms_Output.Put_Line('--------');
--          Dbms_Output.Put_Line(cont);

--          Dbms_Output.Put_Line(v_om_list_control_notification(i).id_notification);
--          Dbms_Output.Put_Line(v_om_list_control_notification(i).id_notification_lote_send);
--          Dbms_Output.Put_Line(v_om_list_control_notification(i).gsm);
--          Dbms_Output.Put_Line(v_om_list_control_notification(i).sms);
--          cont := cont +1;
--        END LOOP;

        SELECT Count (1) INTO v_number_avalaible  FROM om_control_notification WHERE status = 4 ;

--        Dbms_Output.Put_Line( 'v_number_avalaible: ' || v_number_avalaible  );
--        quitar! solo para desarrollo!!!!!!
--        UPDATE om_control_notification SET (status) = (4) ;
--        ROLLBACK;
    COMMIT;

    error_id := 0;
    error_descr := 'Ejecucion exitosa';
  EXCEPTION
    WHEN Others THEN
    IF error_id IS null THEN
       error_id    := -50000;
    END IF;

    error_descr := '[om_pack_order_administration.get_lot_notification]' || SQLERRM ;
    v_id_notification_lote_send := NULL;
     ROLLBACK;
  END get_lot_notification_est;

  procedure update_lot_notification (
                                          v_om_list_control_noti_status   om_list_control_noti_status,
                                          error_id                    OUT NUMBER,
                                          error_descr                 OUT VARCHAR2
                              )

    IS

    BEGIN

      FOR i IN v_om_list_control_noti_status.first .. v_om_list_control_noti_status.last LOOP

        BEGIN
          UPDATE om_control_notification SET
            status = v_om_list_control_noti_status(i).status,
            description = description || '->' || v_om_list_control_noti_status(i).descripcion
            WHERE
                    id_notification = v_om_list_control_noti_status(i).id_notification and
                    id_notification_lote_send = v_om_list_control_noti_status(i).id_notification_lote_send
                  ;

        EXCEPTION
          WHEN Others THEN
            Dbms_Output.Put_Line(SQLERRM );
        END;

        Dbms_Output.Put_Line(v_om_list_control_noti_status(i).id_notification);
        Dbms_Output.Put_Line(v_om_list_control_noti_status(i).id_notification_lote_send);
        Dbms_Output.Put_Line(v_om_list_control_noti_status(i).status);
        Dbms_Output.Put_Line(v_om_list_control_noti_status(i).descripcion);

      END LOOP;
      error_id := 0;
      error_descr := 'Ejecucion exitosa';
      COMMIT;
    EXCEPTION
      WHEN Others THEN
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.update_lot_notification]' || SQLERRM ;
    END update_lot_notification;


    procedure closed_order_contract (
                                                v_id_ord              VARCHAR2,
                                                v_status_description  VARCHAR2,
                                                v_user                VARCHAR2,
                                                error_id              out number,
                                                error_descr           out VARCHAR2
                                            )
      IS
      v_number_process_no_completed NUMBER;
      BEGIN

        SELECT Count(1) INTO v_number_process_no_completed FROM OM_ORDER_PROCESS  WHERE id_order = v_id_ord AND order_process_status NOT IN (0);

        IF v_number_process_no_completed = 0 THEN

          change_status_order( v_id_ord, 0 ,v_status_description, v_user, error_id, error_descr);

        END IF;

        error_id := 0;
        error_descr := 'Ejecucion exitosa';
      COMMIT;
      EXCEPTION
        WHEN Others THEN
        error_id    := -50000;
        error_descr := '[om_pack_order_administration.closed_order_contract]' || SQLERRM ;
      END closed_order_contract;

end om_pack_order_administration;
/

