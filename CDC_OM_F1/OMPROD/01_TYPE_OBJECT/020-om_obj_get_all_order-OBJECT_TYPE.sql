CREATE OR REPLACE TYPE OMPROD.om_obj_get_all_order AS OBJECT
(

order_level              NUMBER,
id_ord_type              VARCHAR2(10),            -- PD
id_billing               VARCHAR2(10),            -- PD
id_billing_account       VARCHAR2(10),            -- PD
customer_name            VARCHAR2(255),           -- PD
email                    VARCHAR2(255),           -- PD
ack                      VARCHAR2(50),            -- PD
v_user                   VARCHAR2(50),            -- PD
obj_om_obj_ord_account   OMPROD.om_obj_get_ord_account,  -- D
list_om_list_get_ord     OMPROD.om_list_get_ord          -- D
);