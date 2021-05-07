CREATE OR REPLACE package OMPRD.om_pack_order_administration as

-- cristancho 14.08.2020 09:19


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
                                      );

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
                                          );

    procedure change_status_order_il (
                                            v_id_order              VARCHAR2,
                                            v_id_order_il_no        VARCHAR2,
                                            v_id_task_no            VARCHAR2,
                                            v_status_new            NUMBER,
                                            v_status_description    VARCHAR2,
                                            error_id                out number,
                                            error_descr             out VARCHAR2
                                        );

    procedure change_status_process (
                                        v_id_ord              VARCHAR2,
                                        v_id_ord_process      VARCHAR2,
                                        v_status_new          NUMBER,
                                        v_status_description  VARCHAR2,
                                        v_user                VARCHAR2,
                                        error_id              out number,
                                        error_descr           out VARCHAR2
                                    );

    procedure change_status_account_process (
                                              v_id_ord_account       VARCHAR2,
                                              v_id_ord_account_process VARCHAR2,
                                              v_status_new           NUMBER,
                                              v_status_description   VARCHAR2,
                                              v_user                 VARCHAR2,
                                              error_id               out number,
                                              error_descr            out VARCHAR2
                                          );

    procedure change_status_order (
                                    v_id_ord              VARCHAR2,
                                    v_status_new          NUMBER,
                                    v_status_description  VARCHAR2,
                                    v_user                VARCHAR2,
                                    error_id              out number,
                                    error_descr           out VARCHAR2
                                  );

    procedure change_status_Account_order (
                                            v_id_ord_account      VARCHAR2,
                                            v_status_new          NUMBER,
                                            v_status_description  VARCHAR2,
                                            v_user                VARCHAR2,
                                            error_id              out number,
                                            error_descr           out VARCHAR2
                            );

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
                                  );

    procedure get_sms (
                        v_id_any_type_order   VARCHAR2,
                        v_message_id          VARCHAR2,
                        v_response_sms        OUT VARCHAR2,
                        error_id              out number,
                        error_descr           out VARCHAR2
                            );

    procedure get_email (
                          v_id_any_type_order   VARCHAR2,
                          v_message_id          VARCHAR2,
                          v_response_email      OUT CLOB,
                          v_issue               OUT VARCHAR2,
                          v_group_prg_code      OUT VARCHAR2,
                          error_id              out number,
                          error_descr           out VARCHAR2
                              );

    procedure get_param_configuration_sms (
                                              v_sms_Generic             VARCHAR2,
                                              v_parameter_table         OUT VARCHAR2,
                                              v_parameter_replace_table OUT VARCHAR2
                                    );

    procedure get_value_field_tables_orders (
                                                v_id_any_type_order           VARCHAR2,
                                                v_field                       VARCHAR2,
                                                v_field_value             OUT VARCHAR2,
                                                error_id                  out number,
                                                error_descr               out VARCHAR2
                                    );

    procedure customize_email_template (
                                                v_id_any_type_order            VARCHAR2,
                                                v_template_email               CLOB,
                                                v_email_customize_response OUT CLOB,
                                                error_id                   OUT NUMBER,
                                                error_descr                OUT VARCHAR2
                                    );



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
                        );

   PROCEDURE get_list_all_order (
                            v_id_batch                IN  VARCHAR2,
                            v_id_ord_account          IN  VARCHAR2,
                            v_id_order                IN  VARCHAR2,
                            v_detail_batch_control     OUT SYS_REFCURSOR,
                            v_om_list_get_all_order   OUT om_list_get_all_order,
                            V_email_report            OUT CLOB,
                            v_des_process             OUT VARCHAR2,
                            error_id                  OUT NUMBER,
                            error_descr               OUT VARCHAR2

   );


    PROCEDURE get_order_account (
                                    v_id_ord_account      IN  VARCHAR2,
                                    v_om_obj_ord_account  OUT om_obj_get_ord_account,  -- D
                                    error_id              out number,
                                    error_descr           out VARCHAR2
                                );

    PROCEDURE get_inf_order_account_by_order (
                                                  v_id_order               IN  VARCHAR2,
                                                  v_om_obj_ord_account     OUT om_obj_get_ord_account,  -- D
                                                  v_id_ord_account         OUT VARCHAR2,
                                                  v_count_order            OUT NUMBER,
                                                  v_count_order_in_process OUT NUMBER,
                                                  v_count_order_processed  OUT NUMBER,
                                                  error_id                 out number,
                                                  error_descr              out VARCHAR2
                            );


    PROCEDURE get_order (
                            v_id_order            IN  VARCHAR2,
                            v_om_obj_get_ord      OUT om_obj_get_ord,  -- D
                            error_id              out number,
                            error_descr           out VARCHAR2
                        );

    PROCEDURE get_list_order (
                                v_id_ord_account      IN  VARCHAR2,
                                v_om_list_get_ord     OUT om_list_get_ord,
                                error_id              out number,
                                error_descr           out VARCHAR2
                              );

    PROCEDURE get_process(
                          v_id_order              IN  VARCHAR2,
                          v_om_list_get_process   OUT om_list_get_process,
                          error_id                OUT number,
                          error_descr             OUT VARCHAR
                        );

    PROCEDURE get_process_account(
                                  v_id_ord_account                IN  VARCHAR2,
                                  v_om_list_get_account_process   OUT om_list_get_account_process,
                                  error_id                        OUT number,
                                  error_descr                     OUT VARCHAR
                    );

    PROCEDURE get_list_order_il (
                                  v_id_order            IN  VARCHAR2,
                                  v_om_list_get_ord_il  OUT om_list_get_ord_il,
                                  error_id              out number,
                                  error_descr           out VARCHAR2
                        );

     PROCEDURE GET_XML_IL   (
                            V_ID_ORDER_IL      VARCHAR,
                            V_XML              OUT CLOB,
                            ERROR_ID           OUT NUMBER,
                            ERROR_DESCR        OUT VARCHAR2);

      PROCEDURE get_batch_billing_presement (
                                            batch_billing_presement    out sys_refcursor,
                                            error_id           out number,
                                            error_descr        out varchar2);

      PROCEDURE get_batch_change_plan (   v_data_change_plan out sys_refcursor,
                                          error_id           out number,
                                          error_descr        out varchar2);

      PROCEDURE get_batch_change_segmentation (   v_data_change_segmentation out sys_refcursor,
                                                  error_id           out number,
                                                  error_descr        out varchar2);

      PROCEDURE get_batch_simswap_delay (         v_data_simswap_delay out sys_refcursor,
                                                  error_id             out number,
                                                  error_descr          out varchar2);

      PROCEDURE update_batch_simswap_delay (      v_id_transaction         VARCHAR2,
                                                  v_id_batch               VARCHAR2,
                                                  v_id_ord_account         VARCHAR2,
                                                  v_id_ord                 VARCHAR2,
                                                  v_processed              VARCHAR2,
                                                  v_description            VARCHAR2,
                                                  error_id             out number,
                                                  error_descr          out varchar2);

      PROCEDURE get_batch_occ (               v_data_occ out sys_refcursor,
                                                        error_id             out number,
                                                        error_descr          out varchar2);

      PROCEDURE get_batch_generic_notification (        v_data_generic_notification out sys_refcursor,
                                                        error_id                    out number,
                                                        error_descr                 out varchar2);

      PROCEDURE get_batch_cancellation (               v_data_cancellation out sys_refcursor,
                                                        error_id             out number,
                                                        error_descr          out varchar2);

      PROCEDURE get_batch_suspe (                 v_data_susp out sys_refcursor,
                                                        error_id             out number,
                                                        error_descr          out varchar2);

      PROCEDURE get_batch_react (                 v_data_react out sys_refcursor,
                                                  error_id             out number,
                                                  error_descr          out varchar2);

      PROCEDURE create_group_notification (             v_type_notification         NUMBER := 0 ,-- 0 = SMS 1 =EMAIL 2 = AMBOS
                                                              v_om_list_notification      om_list_notification,
                                                              v_id_notification_lote      OUT VARCHAR2,
                                                              error_id                    out number,
                                                              error_descr                 out varchar2);

      procedure get_lot_notification_cur (
                                                    v_number_noti                   number,
                                                    v_id_notification_lote_send OUT VARCHAR2,
                                                    v_om_lot_list_control_noti  OUT sys_refcursor,
                                                    v_quantity_lot              OUT NUMBER,
                                                    error_id                    OUT NUMBER,
                                                    error_descr                 OUT VARCHAR2
                                        );
      procedure get_lot_notification_est (
                                                            v_number_noti                   number,
                                                            v_max_register                  NUMBER,
                                                            v_number_avalaible          OUT NUMBER,
                                                            v_id_notification_lote_send OUT VARCHAR2,
                                                            v_om_list_control_notification OUT om_list_control_notification,
                                                            v_quantity_lot              OUT NUMBER,
                                                            error_id                    OUT NUMBER,
                                                            error_descr                 OUT VARCHAR2
                                                );
      procedure update_lot_notification (
                                                    v_om_list_control_noti_status   om_list_control_noti_status,
                                                    error_id                    OUT NUMBER,
                                                    error_descr                 OUT VARCHAR2
                                        );
     procedure closed_order_contract (
                                          v_id_ord              VARCHAR2,
                                          v_status_description  VARCHAR2,
                                          v_user                VARCHAR2,
                                          error_id              out number,
                                          error_descr           out VARCHAR2
                                      );

end om_pack_order_administration;
/
