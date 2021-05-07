create or replace package OMPRD.om_pack_batch_process as

-- Cristancho 25.01.2021 11:40
    procedure create_information_swd ( v_om_list_batch_inf_swd    in om_list_batch_inf_swd,
                                       error_id                   out number,
                                       error_descr                out varchar2);
    --
    procedure create_information_occ ( v_om_list_batch_inf_occ    in  om_list_batch_inf_occ,
                                       error_id                   out number,
                                       error_descr                out varchar2);
    --                                   
    procedure create_information_presement (v_om_list_batch_presement  in  om_list_batch_inf_presement,
                                            error_id                   out number,
                                            error_descr                out varchar2);
    --                                        
    procedure create_information_change_pm (v_om_list_batch_change_pm  in  om_list_batch_inf_change_pm,
                                            error_id                   out number,
                                            error_descr                out varchar2);
    --
    procedure create_inf_segment_bulk (v_om_list_batch_segment_bulk  in  om_list_batch_inf_segment_bulk,
                                       error_id                      out number,
                                       error_descr                   out varchar2);
    --
    procedure create_inf_notificaction(v_om_list_batch_noti  in  om_list_batch_inf_noti,
                                       error_id              out number,
                                       error_descr           out varchar2);
    --
    procedure create_inf_cancellations(v_om_list_batch_cancellations  in  om_list_batch_inf_cancel,
                                       error_id                       out number,
                                       error_descr                    out varchar2);
    --
    procedure create_inf_susp(v_om_list_batch_susp  in  om_list_batch_inf_susp,
                              error_id              out number,
                              error_descr           out varchar2);
    --
    procedure create_inf_react(om_list_batch_inf_react in  om_list_batch_inf_react,
                               error_id                out number,
                               error_descr             out varchar2);
    --
end om_pack_batch_process;
/