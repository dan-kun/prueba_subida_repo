create or replace package body OMPRD.om_pack_configuration as

  procedure get_struct_canonica_order (struct_canonica    out sys_refcursor,
                                       error_id           out number,
                                       error_descr        out varchar2)
  IS
  begin

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

    begin

      open struct_canonica for
       select
       a.id_ord_type, a.description AS descriptionOrder, c.description AS descriptionChannel , a.id_channel, a.action, a.id_action, a.order_level,
       b.param_name, b.data_type, b.min_required, b.max_allowed
                    FROM        CFG_ORD_TYPES      a
                    INNER JOIN  CFG_ORD_CAN_STRUCT b ON (a.id_ord_type = b.id_ord_type)
                    INNER JOIN  CFG_CHANNEL        c ON (a.id_channel = c.id_channel)
       ORDER BY a.id_ord_type, a.id_channel, a.action;

        dbms_output.put_line('valor de las filas devueltas: ' || struct_canonica%rowCount);
      IF struct_canonica%NOTFOUND = true THEN
          error_id    := -20000;
          error_descr := '[om_pack_configuration.get_struct_canonica_order] no existen registros cargados';
      END IF;
    exception
      when no_data_found then
        error_id    := -50000;
        error_descr := '[om_pack_configuration.get_struct_canonica_order]';
      when others then
        error_id    := -50000;
        error_descr := '[om_pack_configuration.get_struct_canonica_order]';
    end;

  --exception
  --  when others then
  end;

      procedure get_struct_order       (struct_canonica         out sys_refcursor,
                                        struct_order_inventory  out sys_refcursor,
                                        struct_order_process    out sys_refcursor,
                                        struct_order_message    out sys_refcursor,
                                        error_id                out number,
                                        error_descr             out varchar2)
  IS
  begin

    error_id    := 0;
    error_descr := 'ejecucion exitosa';

    begin

      open struct_canonica for
       select
         a.id_ord_type, a.description AS descriptionOrder, c.description AS descriptionChannel , a.id_channel, a.action, a.id_action, a.order_level,
         b.param_name, b.data_type, b.min_required, b.max_allowed
           FROM        CFG_ORD_TYPES      a
           INNER JOIN  CFG_ORD_CAN_STRUCT b ON (a.id_ord_type = b.id_ord_type)
           INNER JOIN  CFG_CHANNEL        c ON (a.id_channel = c.id_channel)
       ORDER BY a.id_ord_type, a.id_channel, a.action;

      open struct_order_inventory for
        select
          a.id_ord_type
         ,b.id_ord_struct, b.id_ord_item_type, c.description AS TipoOrderType, b.is_required, b.id_required_group,b.max_allowed, b.attr1, b.attr2, b.attr3
          FROM        CFG_ORD_TYPES      a
          INNER JOIN  CFG_ORD_STRUCT     b ON ( a.id_ord_type = b.id_ord_type)
          INNER JOIN  CFG_ORD_ITEM_TYPES c ON ( b.id_ord_item_type = c.id_ord_item_type)
        ORDER BY  a.id_ord_type,id_ord_item_type;

      open struct_order_process for
       select
         d.id_ord_type, d.id_ord_process, d.id_ord_struct, d.priority
        ,e.description AS OrderProcess, e.id_external_app
        ,f.description AS appExterna
          FROM        CFG_ORD_STRUCT_PROCESS d
          INNER JOIN  CFG_ORD_PROCESS        e ON ( d.id_ord_process = e.id_ord_process)
          INNER JOIN  CFG_EXTERNAL_APP       f ON ( e.id_external_app = f.id_external_app )
       ORDER BY  d.id_ord_type, priority;

      open struct_order_message for
        SELECT id_ord_type, message_id, message, html_template  FROM cfg_ord_sms;

    exception
      when others then
        error_id    := SQLCODE;
        error_descr := '[om_pack_configuration.get_struct_canonica_order] ' || SQLERRM;
    end;

  end get_struct_order;


    PROCEDURE validate_life_cycle_for_states(
                                        v_status_new        NUMBER,
                                        v_status_OLD        NUMBER,
                                        error_id           out number,
                                        error_descr        out varchar2
    )
    IS
    cantStatus NUMBER := 0 ;
    ispermitted BOOLEAN;
    BEGIN

      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      IF v_status_new = v_status_OLD  THEN
        ERROR_ID    := -20001;
        ERROR_DESCR := 'El nuevo estatus debe ser diferente al anterior';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;

      SELECT Count(1) INTO cantStatus FROM  cfg_status_process WHERE id_status IN (v_status_new,v_status_OLD);

      IF cantStatus != 2  THEN
        ERROR_ID    := -20000;
        ERROR_DESCR := 'Estatus no configurado en la tabla: cfg_status_process';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;

      CASE
        WHEN v_status_OLD = 5 AND v_status_new = 4 THEN  -- De creada a iniciada
          ispermitted := TRUE;
        WHEN v_status_OLD = 4 AND v_status_new = 1 THEN  -- De Iniciada a cancelada
          ispermitted := TRUE;
        WHEN v_status_OLD = 4 AND v_status_new = 3 THEN  -- De Iniciada a en Proceso
          ispermitted := TRUE;
        WHEN v_status_OLD = 4 AND v_status_new = 2 THEN  -- De Iniciada a Error
          ispermitted := TRUE;
        WHEN v_status_OLD = 4 AND v_status_new = 0 THEN  -- De Iniciada a Error
          ispermitted := TRUE;
        WHEN v_status_OLD = 3 AND v_status_new = 0 THEN  -- De en-Proceso a Completada
          ispermitted := TRUE;
        WHEN v_status_OLD = 3 AND v_status_new = 2 THEN  -- De en-Proceso a Error
          ispermitted := TRUE;
        WHEN v_status_OLD = 2 AND v_status_new = 6 THEN  -- De error a relanzar
          ispermitted := TRUE;
        WHEN v_status_OLD = 6 AND v_status_new = 7 THEN  -- De relanzar a relanzar-Iniciado
          ispermitted := TRUE;
        WHEN v_status_OLD = 6 AND v_status_new = 8 THEN  -- De relanzar a relanzar-en-Proceso
          ispermitted := TRUE;
        WHEN v_status_OLD = 6 AND v_status_new = 9 THEN  -- De relanzar a relanzar-en-Error
          ispermitted := TRUE;
        WHEN v_status_OLD = 6 AND v_status_new = 10 THEN -- De relanzar a relanzar-Completada
          ispermitted := TRUE;
        WHEN v_status_OLD = 2 AND v_status_new = 2 THEN -- De relanzar a relanzar-Completada
        ispermitted := TRUE;
        ELSE
          ispermitted := FALSE;
      END CASE;

      IF ispermitted = false THEN
        ERROR_ID    := -20002;
        ERROR_DESCR := 'Cambio de estatus no Permitido';
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
      END IF;

    EXCEPTION
      WHEN Others THEN
      error_id    := SQLCODE;
      error_descr := '[om_pack_configuration.validate_life_cycle_for_states] ' || SQLERRM;
    END validate_life_cycle_for_states;

end om_pack_configuration;
/