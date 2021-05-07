create or replace package body OMPRD.om_pack_batch_process AS

    procedure create_information_swd ( v_om_list_batch_inf_swd    in om_list_batch_inf_swd,
                                       error_id           out number,
                                       error_descr        out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';
      IF v_om_list_batch_inf_swd IS NOT NULL AND v_om_list_batch_inf_swd.COUNT > 0 THEN
        for i in v_om_list_batch_inf_swd.first .. v_om_list_batch_inf_swd.last LOOP
          BEGIN
            INSERT INTO OM_BATCH_SIMSWAP_DELAY  VALUES(
                                            v_om_list_batch_inf_swd(i).id_transaction,                                      --id_transaction,
                                            NULL,                                                                           --id_batch,
                                            NULL,                                                                           --id_ord_account,
                                            NULL,                                                                           --id_ord,
                                            v_om_list_batch_inf_swd(i).id_billing_account,                                  --id_billing_account,
                                            v_om_list_batch_inf_swd(i).id_contract,                                         --id_contract,
                                            v_om_list_batch_inf_swd(i).gsm,                                                 --gsm,
                                            v_om_list_batch_inf_swd(i).simcard,                                             --simcard,
                                            v_om_list_batch_inf_swd(i).imsi,                                                --imsi,
                                            To_Date(v_om_list_batch_inf_swd(i).date_process,'DD/MM/YYYY HH24:MI:SS'),         --date_process,
                                            To_Date(v_om_list_batch_inf_swd(i).date_simswap,'DD/MM/YYYY HH24:MI:SS'),         --date_simswap,
                                            null,                                                                           --processed,
                                            NULL                                                                            --description

            );
          EXCEPTION
            WHEN Others THEN
              INSERT INTO OM_BATCH_SIMSWAP_DELAY  VALUES(
                                    Nvl(v_om_list_batch_inf_swd(i).id_transaction,'0'),                                      --id_transaction,
                                    NULL,                                                                            --id_batch,
                                    NULL,                                                                            --id_ord_account,
                                    NULL,                                                                            --id_ord,
                                    Nvl(v_om_list_batch_inf_swd(i).id_billing_account,'0'),                          --id_billing_account,
                                    Nvl(v_om_list_batch_inf_swd(i).id_contract,'0'),                                 --id_contract,
                                    Nvl(v_om_list_batch_inf_swd(i).gsm,'0'),                                         --gsm,
                                    Nvl(v_om_list_batch_inf_swd(i).simcard,'0'),                                     --simcard,
                                    Nvl(v_om_list_batch_inf_swd(i).imsi,'0'),                                                 --imsi,
                                    Nvl(To_Date(v_om_list_batch_inf_swd(i).date_process,'DD/MM/YYYY HH24:MI:SS'),sysdate),         --date_process,
                                    Nvl(To_Date(v_om_list_batch_inf_swd(i).date_simswap,'DD/MM/YYYY HH24:MI:SS'),sysdate),         --date_simswap,
                                    'ERROR',                                                                           --processed,
                                    'EXIEN PARAMETROS REQUERIDOS QUE VIENEN EN NULL '                                       --description

                );

          END;

        END LOOP;
      END IF;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_information_swd] ' || SQLERRM;
    END create_information_swd;

    procedure create_information_occ ( v_om_list_batch_inf_occ    in  om_list_batch_inf_occ,
                                       error_id                   out number,
                                       error_descr                out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';
      --
      IF v_om_list_batch_inf_occ IS NOT NULL  AND v_om_list_batch_inf_occ.COUNT > 0 THEN
        --
        for i in v_om_list_batch_inf_occ.first .. v_om_list_batch_inf_occ.last LOOP
          --
          INSERT INTO om_batch_occ VALUES(
            v_om_list_batch_inf_occ(i).id_billing_account,                             --  id_billing_account VARCHAR2(20)
            v_om_list_batch_inf_occ(i).id_contract,                                    --  id_contract        VARCHAR2(20)
            v_om_list_batch_inf_occ(i).id_plan,                                        --  id_plan            VARCHAR2(20)
            v_om_list_batch_inf_occ(i).id_package_service,                             --  id_package_service VARCHAR2(20)
            v_om_list_batch_inf_occ(i).id_service,                                     --  id_service         VARCHAR2(20)
            v_om_list_batch_inf_occ(i).type_money,                                     --  type_money         VARCHAR2(20)
            v_om_list_batch_inf_occ(i).cost,                                           --  cost               NUMBER
            v_om_list_batch_inf_occ(i).description,                                    --  description        VARCHAR2(30)
            v_om_list_batch_inf_occ(i).gsm,                                            --  gsm                VARCHAR2(20)
            v_om_list_batch_inf_occ(i).level_add_occn,                                 --  level_add_occn     NUMBER
            To_Date(v_om_list_batch_inf_occ(i).date_operaction,'DD/MM/YYYY HH24:MI:SS'), --  date_operaction    DATE
            v_om_list_batch_inf_occ(i).fupackidpub,                                    --  fupackidpub        VARCHAR2(20)
            To_Date(v_om_list_batch_inf_occ(i).efdate,'DD/MM/YYYY HH24:MI:SS'),          --  efdate             DATE
            v_om_list_batch_inf_occ(i).numperiods,                                     --  numperiods         NUMBER
            v_om_list_batch_inf_occ(i).fupseq,                                         --  fupseq             VARCHAR2(20)
            v_om_list_batch_inf_occ(i).elemversion,                                    --  elemversion        VARCHAR2(20)
            v_om_list_batch_inf_occ(i).freeunitsamount                                --  freeunitsamount    VARCHAR2(20)
          );
        --
        END LOOP;
      --
      END IF;
      --
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_information_occ] ' || SQLERRM;
    END create_information_occ;

    procedure create_information_presement (v_om_list_batch_presement  in  om_list_batch_inf_presement,
                                            error_id                   out number,
                                            error_descr                out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if v_om_list_batch_presement is not null and v_om_list_batch_presement.count > 0 then

        for i in v_om_list_batch_presement.first .. v_om_list_batch_presement.last LOOP

          INSERT INTO om_batch_billing_presement VALUES(
            v_om_list_batch_presement(i).ID_BILLING_ACCOUNT,                                       --  id_billing_account VARCHAR2(20)
            v_om_list_batch_presement(i).PRGCODE,                                                  --  PRGCODE            VARCHAR2(10)
            v_om_list_batch_presement(i).BILLCICLE,                                                --  BILLCICLE          VARCHAR2(10)
            v_om_list_batch_presement(i).PAYMENT_METHOD,                                           --  PAYMENT_METHOD     VARCHAR2(20)
            v_om_list_batch_presement(i).ID_CONTRACT,                                              --  ID_CONTRACT        VARCHAR2(20)
            v_om_list_batch_presement(i).GSM,                                                      --  GSM                VARCHAR2(20)
            v_om_list_batch_presement(i).EMAIL,                                                    --  EMAIL              VARCHAR2(30)
            v_om_list_batch_presement(i).ID_PLAN,                                                  --  ID_PLAN            VARCHAR2(20)
            to_date(v_om_list_batch_presement(i).DATE_OPERATION,'DD/MM/YYYY HH24:MI:SS'));        --  DATE_OPERATION     DATE


        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_information_presement] ' || SQLERRM;
    END create_information_presement;


    procedure create_information_change_pm (v_om_list_batch_change_pm  in  om_list_batch_inf_change_pm,
                                            error_id                   out number,
                                            error_descr                out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if v_om_list_batch_change_pm is not null and v_om_list_batch_change_pm.count > 0 then

        for i in v_om_list_batch_change_pm.first .. v_om_list_batch_change_pm.last LOOP

          INSERT INTO om_batch_change_plan VALUES(
            v_om_list_batch_change_pm(i).ID_BILLING_ACCOUNT,                                       --  id_billing_account VARCHAR2(20)
            v_om_list_batch_change_pm(i).ID_CONTRACT_PUBLIC,                                       --  ID_CONTRACT_PUBLIC            VARCHAR2(10)
            v_om_list_batch_change_pm(i).GSM,                                                      --  GSM          VARCHAR2(10)
            v_om_list_batch_change_pm(i).ID_PLAN_PUBLIC,                                           --  ID_PLAN_PUBLIC     VARCHAR2(20)
            v_om_list_batch_change_pm(i).ID_PLAN_PRIVATE,                                          --  ID_PLAN_PRIVATE        VARCHAR2(20)
            v_om_list_batch_change_pm(i).DESCRIPTION_PLAN,                                         --  DESCRIPTION_PLAN                VARCHAR2(20)
            v_om_list_batch_change_pm(i).CHANGE_PLAN_DELAY,                                        --  CHANGE_PLAN_DELAY              VARCHAR2(30)
            to_date(v_om_list_batch_change_pm(i).DATE_OPERATION,'DD/MM/YYYY HH24:MI:SS'));         --  DATE_OPERATION     DATE


        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_information_change_pm] ' || SQLERRM;
    END create_information_change_pm;


    procedure create_inf_segment_bulk (v_om_list_batch_segment_bulk  in  om_list_batch_inf_segment_bulk,
                                       error_id                      out number,
                                       error_descr                   out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if v_om_list_batch_segment_bulk is not null and v_om_list_batch_segment_bulk.count > 0 then

        for i in v_om_list_batch_segment_bulk.first .. v_om_list_batch_segment_bulk.last LOOP

          INSERT INTO om_batch_segmentation VALUES(
            v_om_list_batch_segment_bulk(i).ID_ACCOUNT,                      --  ID_ACCOUNT                  VARCHAR2(20)
            v_om_list_batch_segment_bulk(i).ID_CONTRACT,                     --  ID_CONTRACT                 VARCHAR2(10)
            v_om_list_batch_segment_bulk(i).GSM,                             --  GSM                         VARCHAR2(10)
            v_om_list_batch_segment_bulk(i).DESCRIPTION_SEGMENTATION,        --  DESCRIPTION_SEGMENTATION     VARCHAR2(20)
            v_om_list_batch_segment_bulk(i).ACTION_LEVEL);                   --  ACTION_LEVEL                 VARCHAR2(20)


        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_information_segment_bulk] ' || SQLERRM;
    END create_inf_segment_bulk;


    procedure create_inf_notificaction(v_om_list_batch_noti  in  om_list_batch_inf_noti,
                                       error_id              out number,
                                       error_descr           out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if v_om_list_batch_noti is not null and v_om_list_batch_noti.count > 0 then

        for i in v_om_list_batch_noti.first .. v_om_list_batch_noti.last LOOP

          INSERT INTO om_batch_generic_notification VALUES(
            v_om_list_batch_noti(i).ID_BILLING_ACCOUNT,           --  ID_BILLING_ACCOUNT        VARCHAR2(20)
            v_om_list_batch_noti(i).ID_CONTRACT,                  --  ID_CONTRACT               VARCHAR2(20)
            v_om_list_batch_noti(i).GSM ,                         --  GSM                       VARCHAR2(20)
            v_om_list_batch_noti(i).EMAIL ,                       --  EMAIL                     VARCHAR2(50)
            v_om_list_batch_noti(i).TYPE_NOTIFICATION,            --  TYPE_NOTIFICATION         number
            v_om_list_batch_noti(i).MESSAGE_ID);                  --  MESSAGE_ID                VARCHAR2(20)

        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_inf_notificaction] ' || SQLERRM;
    END create_inf_notificaction;


    procedure create_inf_cancellations(v_om_list_batch_cancellations  in  om_list_batch_inf_cancel,
                                       error_id                       out number,
                                       error_descr                    out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if v_om_list_batch_cancellations is not null and v_om_list_batch_cancellations.count > 0 then

        for i in v_om_list_batch_cancellations.first .. v_om_list_batch_cancellations.last LOOP

          INSERT INTO om_batch_cancellation VALUES(
            v_om_list_batch_cancellations(i).ID_BILLING_ACCOUNT,           --  ID_BILLING_ACCOUNT        VARCHAR2(20)
            v_om_list_batch_cancellations(i).ID_CONTRACT,                  --  ID_CONTRACT               VARCHAR2(20)
            v_om_list_batch_cancellations(i).ID_PLAN ,                     --  ID_PLAN                   VARCHAR2(20)
            v_om_list_batch_cancellations(i).GSM ,                         --  GSM                       VARCHAR2(20)
            v_om_list_batch_cancellations(i).SIMCARD,                      --  SIMCARD                   VARCHAR2(20)
            v_om_list_batch_cancellations(i).IMSI,                         --  IMSI                      VARCHAR2(20)
            v_om_list_batch_cancellations(i).LEVEL_CANCELLATION,           --  LEVEL_CANCELLATION        number
            v_om_list_batch_cancellations(i).DESCRIPTION_OPERATION,        --  DESCRIPTION_OPERATION     VARCHAR2(50)
            v_om_list_batch_cancellations(i).TYPE_SIM);                    --  TYPE_SIM                      VARCHAR2(20)

        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_inf_cancellations] ' || SQLERRM;
    END create_inf_cancellations;

    procedure create_inf_susp(v_om_list_batch_susp  in  om_list_batch_inf_susp,
                              error_id              out number,
                              error_descr           out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if v_om_list_batch_susp is not null and v_om_list_batch_susp.count > 0 then

        for i in v_om_list_batch_susp.first .. v_om_list_batch_susp.last LOOP

          INSERT INTO om_batch_suspen VALUES(
            v_om_list_batch_susp(i).ID_BILLING_ACCOUNT,           --  ID_BILLING_ACCOUNT        VARCHAR2(20)
            v_om_list_batch_susp(i).ID_ORD_TYPE,                  --  ID_ORD_TYPE               VARCHAR2(20)
            v_om_list_batch_susp(i).IS_ORD_TIPY_ACTIONABLE ,      --  IS_ORD_TIPY_ACTIONABLE    VARCHAR2(20)
            v_om_list_batch_susp(i).ID_CONTRACT ,                 --  ID_CONTRACT               VARCHAR2(20)
            v_om_list_batch_susp(i).GSM,                          --  GSM                   VARCHAR2(20)
            v_om_list_batch_susp(i).SIMCARD,                      --  SIMCARD                      VARCHAR2(20)
            v_om_list_batch_susp(i).IMSI,                         --  IMSI        number
            v_om_list_batch_susp(i).ID_PLAN,                      --  ID_PLAN     VARCHAR2(50)
            v_om_list_batch_susp(i).TYPE_SIM);                    --  TYPE_SIM                      VARCHAR2(20)

        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_inf_susp] ' || SQLERRM;
    END create_inf_susp;

    procedure create_inf_react(om_list_batch_inf_react in  om_list_batch_inf_react,
                               error_id              out number,
                               error_descr           out varchar2)
    IS
    BEGIN
      error_id    := 0;
      error_descr := 'ejecucion exitosa';

      if om_list_batch_inf_react is not null and om_list_batch_inf_react.count > 0 then

        for i in om_list_batch_inf_react.first .. om_list_batch_inf_react.last LOOP

          INSERT INTO om_batch_reactiva VALUES(
            om_list_batch_inf_react(i).ID_BILLING_ACCOUNT,           --  ID_BILLING_ACCOUNT        VARCHAR2(20)
            om_list_batch_inf_react(i).ID_CONTRACT,                  --  ID_CONTRACT               VARCHAR2(20)
            om_list_batch_inf_react(i).GSM,                          --  GSM                       VARCHAR2(20)
            om_list_batch_inf_react(i).SIMCARD,                      --  SIMCARD                   VARCHAR2(20)
            om_list_batch_inf_react(i).IMSI,                         --  IMSI                      number
            om_list_batch_inf_react(i).ID_PLAN,                      --  ID_PLAN                   VARCHAR2(20)
            om_list_batch_inf_react(i).ID_PACKAGE,                   --  ID_PACKAGE                VARCHAR2(20)
            om_list_batch_inf_react(i).ID_SERVICE);                  --  ID_SERVICE                VARCHAR2(20)

        end loop;
      end if;
      COMMIT;

    exception
    when others then
      error_id    := -50000;
      error_descr := '[om_pack_batch_process.create_inf_react] ' || SQLERRM;
    END create_inf_react;

end om_pack_batch_process;
/