create or replace package body OMPRD.om_pack_instalink is

PROCEDURE GET_XML_IL   (P_ID_ORDER_IL      VARCHAR,
                        P_XML              OUT CLOB,
                        ERROR_ID           OUT NUMBER,
                        ERROR_DESCR        OUT VARCHAR2)
IS


  L_ROOT_NODE DBMS_XMLDOM.DOMNODE;

  TB_XMLELEMENTS OM_CREATE_XML.TY_XMLELEMENT := OM_CREATE_XML.TY_XMLELEMENT();
  TB_INDEX OM_CREATE_XML.TY_VARCHAR2;
  TB_ATTRIBS OM_CREATE_XML.TY_XMLATTRIB := OM_CREATE_XML.TY_XMLATTRIB();

  V_NAME_TAG VARCHAR2(144);
  V_ID_TAG   VARCHAR2(10);
  L_DOMDOC   DBMS_XMLDOM.DOMDOCUMENT;
BEGIN
  ERROR_ID    := 0;
  ERROR_DESCR := 'Ejecucion Exitosa';

    DECLARE
      CURSOR CUR IS
        SELECT *
        FROM OM_ORD_IL T
        WHERE T.ID_ORDER_IL = P_ID_ORDER_IL;
    BEGIN
      FOR V_REG IN CUR LOOP

         -- CREATE AN EMPTY XML DOCUMENT
         L_DOMDOC := DBMS_XMLDOM.NEWDOMDOCUMENT;

         -- SET VERSION
         DBMS_XMLDOM.SETVERSION(L_DOMDOC, '1.0');
         DBMS_XMLDOM.SETCHARSET(L_DOMDOC, 'ISO-8859-1');
         --dbms_xmldom.setVersion(l_domdoc, '1.0" encoding="ISO-8859-1');

         -- CREATE A ROOT NODE

         SELECT CI.NAME_ELEMENT, CI.ID_ELEMENT INTO V_NAME_TAG, V_ID_TAG
         FROM  CFG_IL CI
         WHERE CI.PARENT_ID IS NULL
         AND   CI.TYPE_ELEMENT = 0;

         L_ROOT_NODE := DBMS_XMLDOM.MAKENODE(L_DOMDOC);
         TB_XMLELEMENTS.EXTEND;
         TB_INDEX(V_ID_TAG) := TB_XMLELEMENTS.LAST;

          DECLARE
            CURSOR CUR IS
               SELECT CIA.NAME_ELEMENT, CIA.VALUE_ELEMENT
               FROM CFG_IL CIA
               WHERE CIA.PARENT_ID = V_ID_TAG
               AND   TYPE_ELEMENT = 3;
               I NUMBER;
          BEGIN
            I := 1;
            FOR V_REG IN CUR LOOP
             TB_ATTRIBS.EXTEND();
             TB_ATTRIBS(I).P_ATTRIB_NAME := V_REG.NAME_ELEMENT;
             TB_ATTRIBS(I).P_ATTRIB_VALUE := V_REG.VALUE_ELEMENT;
             I:=I+1;
            END LOOP;
          END;

         TB_XMLELEMENTS(TB_INDEX(V_ID_TAG)).P_ATTRIBS      := TB_ATTRIBS;
         TB_XMLELEMENTS(TB_INDEX(V_ID_TAG)).P_PARENT       := L_ROOT_NODE;
         TB_XMLELEMENTS(TB_INDEX(V_ID_TAG)).P_ELEMENT_NAME := V_NAME_TAG;
         TB_XMLELEMENTS(TB_INDEX(V_ID_TAG)).P_TEXT_VALUE   := '';

         OM_CREATE_XML.WRITE_NODE(L_DOMDOC, TB_XMLELEMENTS(TB_INDEX(V_ID_TAG)));

         -- CREATE A NEW NODE WITH TEXT AND ATTRIBUTES
         -- HEADER


          DECLARE
            CURSOR CUR IS
               SELECT CI.NAME_ELEMENT, CI.ID_ELEMENT, CI.VALUE_ELEMENT, CI.PARENT_ID
               FROM  cfg_il CI
               WHERE CI.TYPE_ELEMENT NOT IN (0,3);
               I NUMBER;
          BEGIN
            I := 1;
            FOR V_REG4 IN CUR LOOP
              TB_ATTRIBS.DELETE;
              DECLARE
                CURSOR CUR IS
                   SELECT CIA.NAME_ELEMENT, CIA.VALUE_ELEMENT
                   FROM CFG_IL CIA
                   WHERE CIA.PARENT_ID = V_REG4.ID_ELEMENT
                   AND   TYPE_ELEMENT = 3;
                   I NUMBER;
              BEGIN
                I := 1;
                FOR V_REG1 IN CUR LOOP
                 TB_ATTRIBS.EXTEND();
                 TB_ATTRIBS(I).P_ATTRIB_NAME := V_REG1.NAME_ELEMENT;
                 TB_ATTRIBS(I).P_ATTRIB_VALUE := V_REG1.VALUE_ELEMENT;
                 I:=I+1;
                END LOOP;
              END;
              OM_CREATE_XML.ADD_NODE(TB_XMLELEMENTS, TB_INDEX, V_REG4.ID_ELEMENT, V_REG4.PARENT_ID, V_REG4.NAME_ELEMENT, V_REG4.VALUE_ELEMENT, TB_ATTRIBS );
              OM_CREATE_XML.WRITE_NODE(L_DOMDOC, TB_XMLELEMENTS(TB_INDEX(V_REG4.ID_ELEMENT)));
            END LOOP;
          END;

         SELECT CI.ID_ELEMENT
         INTO V_ID_TAG
         FROM  CFG_IL CI
         WHERE CI.TYPE_ELEMENT = 2;

      -- TAG REQUEST

          TB_ATTRIBS.DELETE;
          DECLARE
            CURSOR CUR IS
              SELECT IL.PARAM_NAME, IL.PARAM_VALUE
              FROM   OM_ORD_IL_ITEM IL
              WHERE  IL.ID_ORDER_IL = V_REG.ID_ORDER_IL
              AND    IL.ELEMENT_TYPE = 1;
              I NUMBER;
          BEGIN
            I := 1;
            FOR V_REG1 IN CUR LOOP
             TB_ATTRIBS.EXTEND();
             TB_ATTRIBS(I).P_ATTRIB_NAME := V_REG1.PARAM_NAME;
             TB_ATTRIBS(I).P_ATTRIB_VALUE := V_REG1.PARAM_VALUE;
             I:=I+1;
            END LOOP;
          END;
          OM_CREATE_XML.ADD_NODE(TB_XMLELEMENTS, TB_INDEX, 'ID-REG', V_ID_TAG, 'REQUEST', NULL, TB_ATTRIBS );
          OM_CREATE_XML.WRITE_NODE(L_DOMDOC, TB_XMLELEMENTS(TB_INDEX('ID-REG')));

      -- PARAMETERS

          DECLARE
            CURSOR CUR IS
              SELECT PARAM_NAME, PARAM_VALUE
              FROM   OM_ORD_IL_ITEM
              WHERE  ID_ORDER_IL = V_REG.ID_ORDER_IL
              AND    ELEMENT_TYPE = 0;
              I NUMBER;
          BEGIN
            I := 1;
            FOR V_REG1 IN CUR LOOP
             TB_ATTRIBS.DELETE;
             TB_ATTRIBS.EXTEND();
             TB_ATTRIBS(1).P_ATTRIB_NAME := 'name';
             TB_ATTRIBS(1).P_ATTRIB_VALUE := V_REG1.PARAM_NAME;
             TB_ATTRIBS.EXTEND();
             TB_ATTRIBS(2).P_ATTRIB_NAME := 'value';
             TB_ATTRIBS(2).P_ATTRIB_VALUE := V_REG1.PARAM_VALUE;

             OM_CREATE_XML.ADD_NODE(TB_XMLELEMENTS, TB_INDEX, 'PARAM-'||I, 'ID-REG', 'Parameter', NULL, TB_ATTRIBS );
             OM_CREATE_XML.WRITE_NODE(L_DOMDOC, TB_XMLELEMENTS(TB_INDEX('PARAM-'||I)));

             I:=I+1;
            END LOOP;
          END;

          P_XML := ' ';
          DBMS_XMLDOM.WRITETOCLOB (L_DOMDOC,P_XML);
          DBMS_XMLDOM.FREEDOCUMENT(L_DOMDOC);
      END LOOP;
    EXCEPTION
          WHEN OTHERS THEN
              ERROR_ID    := SQLCODE;
              ERROR_DESCR := '[OM_PACK_INSTALINK.GET_XML_IL]:  '||SQLERRM;
    END;
END GET_XML_IL;

PROCEDURE PREPARE_ORDER_IL   (P_ID_ORDER             VARCHAR2,
                              ERROR_ID               OUT NUMBER,
                              ERROR_DESCR            OUT VARCHAR2)
IS
  V_ID_ORDER_TYPE VARCHAR2(10);
  V_ORDER_STATUS  NUMBER;
  V_SEQ NUMBER;
  V_ORDER_IL_STATUS  NUMBER;
  V_ORDER_IL_STATUS_MESSAGE VARCHAR2(250);
  V_IMSI VARCHAR2(144);
  V_SIM_TYPE NUMBER;
  V_ID_ORDER_IL OM_LIST_ID_SERVICES;
  V_ID_PLAN VARCHAR2(10);
  V_PARAM_VALUE VARCHAR2(144);
  V_FLAG NUMBER;
  v_list_id_services OM_LIST_ID_SERVICES;
  V_XML_NUMBER NUMBER;
BEGIN
  ERROR_ID    := 0;
  ERROR_DESCR := 'Ejecucion Exitosa';
  V_ID_ORDER_IL := OM_LIST_ID_SERVICES();
  V_FLAG := 0;
  v_list_id_services := OM_LIST_ID_SERVICES();
  V_ORDER_IL_STATUS := 4;
  V_ORDER_IL_STATUS_MESSAGE := 'Orden de IL creada satisfactoriamente';
  V_XML_NUMBER := 0;

  DBMS_OUTPUT.put_line('INICIO');

--##VALIDAR ORDER_TYPE Y ORDER_STATUS
  SELECT IO.ID_ORD_TYPE, IO.ORDER_STATUS
  INTO   V_ID_ORDER_TYPE, V_ORDER_STATUS
  FROM   OM_ORDER IO
  WHERE  IO.ID_ORDER = P_ID_ORDER
  AND    IO.ACTIVE_DT <= SYSDATE
  AND   (IO.INACTIVE_DT IS NULL OR IO.INACTIVE_DT > SYSDATE);

  IF (V_ORDER_STATUS = 2) THEN
    ERROR_ID    := -20047;
    ERROR_DESCR := 'Orden en estado invalido';
    DBMS_OUTPUT.put_line('2719: '||ERROR_ID||ERROR_DESCR);
    RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
  END IF;


--## VALIDAR TIPO DE SIMCARD
--## SE DEBE OBTENER EL TIPO DE SIM(1=SIM, 2=USIM) DEL SP GET_SIM_TYPE
  BEGIN
    SELECT OI.ITEM_VALUE
    INTO  V_IMSI
    FROM  om_order_item OI
    WHERE OI.ID_ORD_ITEM_TYPE = 'OIT-003'
    AND   OI.ID_ORDER = P_ID_ORDER
    AND   OI.ACTIVE_DT <= SYSDATE
    AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);

    OM_PACK_INSTALINK.GET_SIM_TYPE(P_IMSI => V_IMSI,
                                  P_SIM_TYPE => V_SIM_TYPE,
                                  ERROR_ID => ERROR_ID,
                                  ERROR_DESCR => ERROR_DESCR);

    IF (ERROR_ID <> 0) THEN
      ERROR_ID    := -20049;
      ERROR_DESCR := 'Tipo de SIMCARD Invalida';
      RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        ERROR_ID    := -20022;
        ERROR_DESCR := 'IMSI INVALIDA';
      WHEN OTHERS THEN
        ERROR_ID    := SQLCODE;
        ERROR_DESCR := 'FLAG-001' || SQLERRM;
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
  END;

    --############# OBTENER PLAN

  BEGIN
    SELECT OI.ITEM_VALUE
    INTO  V_ID_PLAN
    FROM  om_order_item OI
    WHERE OI.ID_ORD_ITEM_TYPE = 'OIT-005'
    AND   OI.ID_ORDER = P_ID_ORDER
    AND   OI.ACTIVE_DT <= SYSDATE
    AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_ID_PLAN := NULL;
      WHEN OTHERS THEN
        ERROR_ID    := SQLCODE;
        ERROR_DESCR := 'FLAG-002' || SQLERRM;
        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
  END;

--################################################################################################
  IF (V_FLAG = 0) THEN

    DECLARE
      CURSOR CUR IS
        SELECT DISTINCT(P.XML_NUMBER) XML_NUMBER
        FROM   cfg_il_profile_det P,
               cfg_plan_il_profile PP
        WHERE  P.ID_PROFILE_IL  = PP.ID_PROFILE_IL
        AND    P.ID_ORDER_TYPE  = V_ID_ORDER_TYPE
        AND    P.SIM_TYPE         IN (V_SIM_TYPE,0)
        AND    PP.ID_PLAN       = V_ID_PLAN
        ORDER BY P.XML_NUMBER;
    BEGIN
      FOR V_REG1 IN CUR LOOP

        SELECT om_seq_id_order_il.NEXTVAL
        INTO V_SEQ FROM DUAL;

        V_ID_ORDER_IL.EXTEND;
        V_ID_ORDER_IL(V_REG1.XML_NUMBER) := CONCAT('OIL-',V_SEQ);

        DECLARE
          CURSOR CUR IS
            SELECT P.REQ_ATTR, P.PARAM_NAME, P.PARAM_VALUE, P.XML_NUMBER
            FROM   cfg_il_profile_det P,
                   cfg_plan_il_profile PP
            WHERE  P.ID_PROFILE_IL  = PP.ID_PROFILE_IL
            AND    P.ID_ORDER_TYPE  = V_ID_ORDER_TYPE
            AND    P.SIM_TYPE       IN (V_SIM_TYPE,0)
            AND    PP.ID_PLAN       = V_ID_PLAN
            AND    P.XML_NUMBER     = V_REG1.XML_NUMBER;
        BEGIN
          FOR V_REG IN CUR LOOP
              V_PARAM_VALUE:=V_REG.PARAM_VALUE;

              IF (SUBSTR(V_REG.PARAM_VALUE,1,1) = '@') THEN

                CASE SUBSTR(V_REG.PARAM_VALUE,2)
                  WHEN 'IMSI' THEN
                    SELECT OI.ITEM_VALUE
                    INTO  V_PARAM_VALUE
                    FROM  om_order_item OI
                    WHERE OI.ID_ORD_ITEM_TYPE = 'OIT-003'
                    AND   OI.ID_ORDER = P_ID_ORDER
                    AND   OI.ACTIVE_DT <= SYSDATE
                    AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);

                  WHEN 'MSISDN' THEN
                    BEGIN
                      SELECT MSISDN
                      INTO  V_PARAM_VALUE
                      FROM OM_ORDER O
                      WHERE ID_ORDER = P_ID_ORDER
                      AND   O.ACTIVE_DT <= SYSDATE
                      AND   (O.INACTIVE_DT IS NULL OR O.INACTIVE_DT > SYSDATE);


                      IF (SUBSTR(V_PARAM_VALUE,1,1) = '0') THEN
                         V_PARAM_VALUE := CONCAT('58',SUBSTR(V_PARAM_VALUE,2));
                      END IF;
                    END;

                  WHEN 'ORDER_NO' THEN
                    BEGIN
                      SELECT MSISDN
                      INTO  V_PARAM_VALUE
                      FROM OM_ORDER O
                      WHERE ID_ORDER = P_ID_ORDER
                      AND   O.ACTIVE_DT <= SYSDATE
                      AND   (O.INACTIVE_DT IS NULL OR O.INACTIVE_DT > SYSDATE);

                      IF (SUBSTR(V_PARAM_VALUE,1,1) = '0') THEN
                         V_PARAM_VALUE := CONCAT('58',SUBSTR(V_PARAM_VALUE,2));
                      END IF;
                    END;
                  ELSE
                    ERROR_ID    := -20050;
                    ERROR_DESCR := 'Parametro Invalido IL';
                    DBMS_OUTPUT.put_line('3004: '||ERROR_ID||ERROR_DESCR);
                    RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                END CASE;
              END IF;
              IF (V_REG.REQ_ATTR = 1) THEN
                insert into OM_ORD_IL_ITEM (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME, PARAM_VALUE)
                values (V_ID_ORDER_IL(V_REG1.XML_NUMBER), 1, V_REG.PARAM_NAME, V_PARAM_VALUE);
              ELSE
                insert into OM_ORD_IL_ITEM (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME, PARAM_VALUE)
                values (V_ID_ORDER_IL(V_REG1.XML_NUMBER), 0, V_REG.PARAM_NAME, V_PARAM_VALUE);
                END IF;
              V_XML_NUMBER := V_REG1.XML_NUMBER;
          END LOOP;
        END;
      END LOOP;
    END;
  END IF;

--################################################################################################
--############# PARAMETROS SEGUN SERVICIO, TIPO DE OPERACION
--############# Y TIPO DE SIM

    SELECT OI.ITEM_VALUE
    BULK COLLECT INTO v_list_id_services
    FROM  om_order_item OI,
          cfg_service_il_profile SP
    WHERE OI.ITEM_VALUE       = SP.ID_SERVICE
    and   OI.ID_ORD_ITEM_TYPE = 'OIT-001'
    AND   OI.ID_ORDER = P_ID_ORDER
    AND   OI.ACTIVE_DT <= SYSDATE
    AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);

  IF (v_list_id_services.Count > 0) THEN
    FOR i IN v_list_id_services.first .. v_list_id_services.last LOOP
    DECLARE
      CURSOR CUR IS
        SELECT DISTINCT(P.XML_NUMBER)
        FROM   cfg_il_profile_det P,
               cfg_service_il_profile SP
        WHERE  P.ID_PROFILE_IL  = SP.ID_PROFILE_IL
        AND    P.ID_ORDER_TYPE  = V_ID_ORDER_TYPE
        AND    P.SIM_TYPE         IN (V_SIM_TYPE,0)
        AND    SP.ID_SERVICE       = v_list_id_services(i)
        ORDER BY P.XML_NUMBER;
    BEGIN
      FOR V_REG2 IN CUR LOOP

        IF (V_ID_ORDER_IL(V_REG2.XML_NUMBER) IS NULL) THEN
          SELECT om_seq_id_order_il.NEXTVAL
          INTO V_SEQ FROM DUAL;
          V_ID_ORDER_IL.EXTEND;
          V_ID_ORDER_IL(V_REG2.XML_NUMBER) := CONCAT('OIL-',V_SEQ);
        END IF;
         DECLARE
          CURSOR CUR IS
            SELECT P.REQ_ATTR, P.PARAM_NAME, P.PARAM_VALUE
            FROM   cfg_il_profile_det P,
                   cfg_service_il_profile SP
            WHERE  P.ID_PROFILE_IL  = SP.ID_PROFILE_IL
            AND    P.ID_ORDER_TYPE  = V_ID_ORDER_TYPE
            AND    P.SIM_TYPE         IN (V_SIM_TYPE,0)
            AND    SP.ID_SERVICE       = v_list_id_services(i)
            AND    P.XML_NUMBER        = V_REG2.XML_NUMBER;
         BEGIN
          FOR V_REG IN CUR LOOP
              V_PARAM_VALUE:=V_REG.PARAM_VALUE;
              IF (SUBSTR(V_REG.PARAM_VALUE,1,1) = '@') THEN
                CASE SUBSTR(V_REG.PARAM_VALUE,2)
                  WHEN 'IMSI' THEN
                    SELECT OI.ITEM_VALUE
                    INTO  V_PARAM_VALUE
                    FROM  om_order_item OI
                    WHERE OI.ID_ORD_ITEM_TYPE = 'OIT-003'
                    AND   OI.ID_ORDER = P_ID_ORDER
                    AND   OI.ACTIVE_DT <= SYSDATE
                    AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);
                  WHEN 'MSISDN' THEN
                    BEGIN
                      SELECT MSISDN
                      INTO  V_PARAM_VALUE
                      FROM OM_ORDER O
                      WHERE ID_ORDER = P_ID_ORDER
                      AND   O.ACTIVE_DT <= SYSDATE
                      AND   (O.INACTIVE_DT IS NULL OR O.INACTIVE_DT > SYSDATE);

                      IF (SUBSTR(V_PARAM_VALUE,1,1) = '0') THEN
                         V_PARAM_VALUE := CONCAT('58',SUBSTR(V_PARAM_VALUE,2));
                      END IF;
                    END;
                  WHEN 'ORDER_NO' THEN
                    BEGIN
                      SELECT MSISDN
                      INTO  V_PARAM_VALUE
                      FROM OM_ORDER O
                      WHERE ID_ORDER = P_ID_ORDER
                      AND   O.ACTIVE_DT <= SYSDATE
                      AND   (O.INACTIVE_DT IS NULL OR O.INACTIVE_DT > SYSDATE);

                      IF (SUBSTR(V_PARAM_VALUE,1,1) = '0') THEN
                         V_PARAM_VALUE := CONCAT('58',SUBSTR(V_PARAM_VALUE,2));
                      END IF;
                    END;
                  ELSE
                    ERROR_ID    := -20050;
                    ERROR_DESCR := 'Parametro Invalido "IC_INST_IL"';
                    DBMS_OUTPUT.put_line('3251: '||ERROR_ID||ERROR_DESCR);
                    RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                END CASE;
              END IF;
              IF (V_REG.REQ_ATTR = 1) THEN
                BEGIN
                  insert into OM_ORD_IL_ITEM (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME, PARAM_VALUE)
                  values (V_ID_ORDER_IL(V_REG2.XML_NUMBER), 1, V_REG.PARAM_NAME, V_PARAM_VALUE);
                EXCEPTION
                  WHEN OTHERS THEN
                    UPDATE OM_ORD_IL_ITEM SET PARAM_VALUE = V_PARAM_VALUE
                    WHERE ID_ORDER_IL = V_ID_ORDER_IL(V_REG2.XML_NUMBER)
                    AND   PARAM_NAME = V_REG.PARAM_NAME;
                END;
              ELSE
                BEGIN
                  insert into OM_ORD_IL_ITEM (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME, PARAM_VALUE)
                  values (V_ID_ORDER_IL(V_REG2.XML_NUMBER), 0, V_REG.PARAM_NAME, V_PARAM_VALUE);
                EXCEPTION
                  WHEN OTHERS THEN
                    UPDATE OM_ORD_IL_ITEM SET PARAM_VALUE = V_PARAM_VALUE
                    WHERE  ID_ORDER_IL  = V_ID_ORDER_IL(V_REG2.XML_NUMBER)
                    AND    PARAM_NAME = V_REG.PARAM_NAME;
                END;
              END IF;
          END LOOP;
        END;
      END LOOP;
    END;
    END LOOP;
  END IF;

--###################################################################################################

    --############# OBTENER SERVICIOS DE SUSPENSION QUE SE DEBEN MANTENER


    DECLARE
      CURSOR CUR IS
        SELECT *
        FROM  om_order_item OI
        WHERE OI.ID_ORD_ITEM_TYPE = 'OIT-034'
        AND   OI.ID_ORDER = P_ID_ORDER
        AND   OI.ITEM_VALUE NOT IN (SELECT OI1.ITEM_VALUE
                                    FROM  om_order_item OI1
                                    WHERE OI1.ID_ORD_ITEM_TYPE = 'OIT-008'
                                    AND   OI1.ID_ORDER = P_ID_ORDER
                                    AND   OI1.ACTIVE_DT <= SYSDATE
                                    AND   (OI1.INACTIVE_DT IS NULL OR OI1.INACTIVE_DT > SYSDATE))
        AND   OI.ACTIVE_DT <= SYSDATE
        AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);
    BEGIN
      FOR V_REG IN CUR LOOP

        DECLARE
          CURSOR CUR IS
            SELECT DISTINCT(P.ID_SERV_SUSP) ID_SERV_SUSP
            FROM   cfg_il_profile_det_SUSP P,
                   cfg_plan_il_profile PP
            WHERE  P.ID_PROFILE_IL  = PP.ID_PROFILE_IL
            AND    P.ID_ORDER_TYPE  = V_ID_ORDER_TYPE
            AND    P.SIM_TYPE         IN (V_SIM_TYPE,0)
            AND    PP.ID_PLAN       = V_ID_PLAN
            AND    P.ID_SERV_SUSP   = V_REG.ITEM_VALUE
            ORDER BY P.ID_SERV_SUSP;
        BEGIN
          FOR V_REG1 IN CUR LOOP

            SELECT om_seq_id_order_il.NEXTVAL
            INTO V_SEQ FROM DUAL;

            V_ID_ORDER_IL.EXTEND;
            V_ID_ORDER_IL(V_ID_ORDER_IL.LAST) := CONCAT('OIL-',V_SEQ);

            DECLARE
              CURSOR CUR IS
                SELECT P.REQ_ATTR, P.PARAM_NAME, P.PARAM_VALUE
                FROM   cfg_il_profile_det_susp P,
                       cfg_plan_il_profile PP
                WHERE  P.ID_PROFILE_IL  = PP.ID_PROFILE_IL
                AND    P.ID_ORDER_TYPE  = V_ID_ORDER_TYPE
                AND    P.SIM_TYPE       IN (V_SIM_TYPE,0)
                AND    PP.ID_PLAN       = V_ID_PLAN
                AND    P.ID_SERV_SUSP   = V_REG1.ID_SERV_SUSP;
            BEGIN
              FOR V_REG IN CUR LOOP
                  V_PARAM_VALUE:=V_REG.PARAM_VALUE;

                  IF (SUBSTR(V_REG.PARAM_VALUE,1,1) = '@') THEN

                    CASE SUBSTR(V_REG.PARAM_VALUE,2)
                      WHEN 'IMSI' THEN
                        SELECT OI.ITEM_VALUE
                        INTO  V_PARAM_VALUE
                        FROM  om_order_item OI
                        WHERE OI.ID_ORD_ITEM_TYPE = 'OIT-003'
                        AND   OI.ID_ORDER = P_ID_ORDER
                        AND   OI.ACTIVE_DT <= SYSDATE
                        AND   (OI.INACTIVE_DT IS NULL OR OI.INACTIVE_DT > SYSDATE);

                      WHEN 'MSISDN' THEN
                        BEGIN
                          SELECT MSISDN
                          INTO  V_PARAM_VALUE
                          FROM OM_ORDER O
                          WHERE ID_ORDER = P_ID_ORDER
                          AND   O.ACTIVE_DT <= SYSDATE
                          AND   (O.INACTIVE_DT IS NULL OR O.INACTIVE_DT > SYSDATE);


                          IF (SUBSTR(V_PARAM_VALUE,1,1) = '0') THEN
                             V_PARAM_VALUE := CONCAT('58',SUBSTR(V_PARAM_VALUE,2));
                          END IF;
                        END;

                      WHEN 'ORDER_NO' THEN
                        BEGIN
                          SELECT MSISDN
                          INTO  V_PARAM_VALUE
                          FROM OM_ORDER O
                          WHERE ID_ORDER = P_ID_ORDER
                          AND   O.ACTIVE_DT <= SYSDATE
                          AND   (O.INACTIVE_DT IS NULL OR O.INACTIVE_DT > SYSDATE);

                          IF (SUBSTR(V_PARAM_VALUE,1,1) = '0') THEN
                             V_PARAM_VALUE := CONCAT('58',SUBSTR(V_PARAM_VALUE,2));
                          END IF;
                        END;
                      ELSE
                        ERROR_ID    := -20050;
                        ERROR_DESCR := 'Parametro Invalido IL';
                        DBMS_OUTPUT.put_line('3004: '||ERROR_ID||ERROR_DESCR);
                        RAISE_APPLICATION_ERROR(ERROR_ID,ERROR_DESCR);
                    END CASE;
                  END IF;
                  IF (V_REG.REQ_ATTR = 1) THEN
                    insert into OM_ORD_IL_ITEM (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME, PARAM_VALUE)
                    values (V_ID_ORDER_IL(V_ID_ORDER_IL.LAST), 1, V_REG.PARAM_NAME, V_PARAM_VALUE);
                  ELSE
                    insert into OM_ORD_IL_ITEM (ID_ORDER_IL, ELEMENT_TYPE, PARAM_NAME, PARAM_VALUE)
                    values (V_ID_ORDER_IL(V_ID_ORDER_IL.LAST), 0, V_REG.PARAM_NAME, V_PARAM_VALUE);
                    END IF;
              END LOOP;
            END;
          END LOOP;
        END;

      END LOOP;
    END;


--###################################################################################################
  IF (V_ID_ORDER_IL.COUNT > 0) THEN
    BEGIN
      FOR I IN V_ID_ORDER_IL.FIRST .. V_ID_ORDER_IL.LAST LOOP
        insert into om_ord_il (ID_ORDER, ID_ORDER_IL, IL_ORDER_NO, IL_TASK_NO, ORD_IL_STATUS, ORD_IL_STATUS_MSG, created_dt, created_who, active_dt, change_dt, change_who)
        values (P_ID_ORDER, V_ID_ORDER_IL(I), NULL, NULL, V_ORDER_IL_STATUS, V_ORDER_IL_STATUS_MESSAGE, sysdate, 'gapolinar', sysdate, sysdate, 'gapolinar');
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  ELSE
    ERROR_ID    := -20051;
    ERROR_DESCR := 'Plan sin configuracion de perfil asociado"';
    DBMS_OUTPUT.put_line('3298: '||ERROR_ID||ERROR_DESCR);
  END IF;
  commit;
EXCEPTION
      WHEN OTHERS THEN
        V_ORDER_IL_STATUS  := 2;
        V_ORDER_IL_STATUS_MESSAGE := 'Error al Generar la Orden de IL';

        IF (ERROR_ID = 0) THEN
          ERROR_ID    := -20000;
          ERROR_DESCR := 'Error al Generar la Orden de IL';
        END IF;

        IF (V_ID_ORDER_IL.COUNT > 0) THEN
          DBMS_OUTPUT.put_line('ERROR IF');
          FOR I IN V_ID_ORDER_IL.FIRST .. V_ID_ORDER_IL.LAST LOOP
            insert into om_ord_il (ID_ORDER, ID_ORDER_IL, IL_ORDER_NO, IL_TASK_NO, ORD_IL_STATUS, ORD_IL_STATUS_MSG, created_dt, created_who, active_dt, change_dt, change_who)
            values (P_ID_ORDER, V_ID_ORDER_IL(I), NULL, NULL, V_ORDER_IL_STATUS, V_ORDER_IL_STATUS_MESSAGE, sysdate, 'gapolinar', sysdate, sysdate, 'gapolinar');
          END LOOP;
        ELSE
          DBMS_OUTPUT.put_line('ERROR ELSE');
          ERROR_ID    := -20000;
          ERROR_DESCR := 'Error al Generar la Orden de IL';
        END IF;
END PREPARE_ORDER_IL;

PROCEDURE GET_SIM_TYPE   (P_IMSI                  VARCHAR2,
                          P_SIM_TYPE             OUT NUMBER,
                          ERROR_ID               OUT NUMBER,
                          ERROR_DESCR            OUT VARCHAR2)
IS
V_COUNT NUMBER;
BEGIN
  ERROR_ID    := 0;
  ERROR_DESCR := 'Ejecucion Exitosa';

  --######## P_SIM_TYPE = 1 (SIM)
  --######## P_SIM_TYPE = 2 (USIM)


  IF (P_IMSI IS NOT NULL) THEN

   select count(1)
   into v_count
   from CFG_IMSIS_RANGES i
   where (P_IMSI) between i.initial_range and i.final_range;

   IF (V_COUNT = 0) THEN
     P_SIM_TYPE := 1;
   ELSE
     P_SIM_TYPE := 2;
   END IF;

  ELSE
    ERROR_ID    := 1;
    ERROR_DESCR := 'IMSI invalida';
  END IF;

EXCEPTION
      WHEN OTHERS THEN
          ERROR_ID    := SQLCODE;
          ERROR_DESCR := '[OM_PACK_INSTALINK.GET_SIM_TYPE] '||SQLERRM;
END GET_SIM_TYPE;

end OM_PACK_INSTALINK;
/