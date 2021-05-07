create or replace package OMPROD.om_pack_configuration as

-- cristancho 14.08.2020 09:19

  procedure get_struct_canonica_order (struct_canonica    out sys_refcursor,
                                       error_id           out number,
                                       error_descr        out varchar2);

  procedure get_struct_order (struct_canonica         out sys_refcursor,
                              struct_order_inventory  out sys_refcursor,
                              struct_order_process    out sys_refcursor,
                              struct_order_message    out sys_refcursor,
                              error_id                out number,
                              error_descr             out varchar2);

  
    PROCEDURE validate_life_cycle_for_states(
                                        v_status_new        NUMBER,
                                        v_status_OLD        NUMBER,
                                        error_id           out number,
                                        error_descr        out varchar2
    );


end om_pack_configuration;
/