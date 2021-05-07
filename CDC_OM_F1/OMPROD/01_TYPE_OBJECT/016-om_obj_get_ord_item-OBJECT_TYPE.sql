CREATE OR REPLACE TYPE OMPROD.om_obj_get_ord_item AS OBJECT
(
id_order_item         VARCHAR2(10),
id_order              VARCHAR2(10),
id_ord_item_type      VARCHAR2(10),
item_value            VARCHAR2(255),
attr1_value           VARCHAR2(144),
attr2_value           VARCHAR2(144),
attr3_value           VARCHAR2(144),
order_item_status     NUMBER,
order_item_status_msg VARCHAR2(255)
);
