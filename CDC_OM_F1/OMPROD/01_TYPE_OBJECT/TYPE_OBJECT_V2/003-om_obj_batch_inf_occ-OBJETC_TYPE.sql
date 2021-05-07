CREATE OR REPLACE TYPE OMPRD.om_obj_batch_inf_occ AS OBJECT
(
id_billing_account VARCHAR2(20),
id_contract        VARCHAR2(20),
id_plan            VARCHAR2(20),
id_package_service VARCHAR2(20),
id_service         VARCHAR2(20),
type_money         VARCHAR2(20),
cost               NUMBER,
description        VARCHAR2(30),
gsm                VARCHAR2(20),
level_add_occn     NUMBER,
date_operaction    VARCHAR2(20),
fupackidpub        VARCHAR2(20),
efdate             VARCHAR2(20),
numperiods         NUMBER,
fupseq             VARCHAR2(20),
elemversion        VARCHAR2(20),
freeunitsamount    VARCHAR2(20)
);