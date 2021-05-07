insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-001', 0, 'soap:Envelope', '', '', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-002', 1, 'soap:Header', '', 'TAG-001', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-003', 1, 'wsse:UsernameToken', '', 'TAG-002', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-004', 1, 'wsse:Username', 'OMBATCH', 'TAG-003', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-005', 1, 'wsse:Password', 'OM412D1G1T3L', 'TAG-003', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-006', 1, 'wsa:Action', 'http://localhost:44280/axis/services/SOAPApi', 'TAG-002', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-007', 1, 'wsa:MessageID', 'CRM360', 'TAG-002', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-008', 1, 'wsa:ReplyTo', '', 'TAG-002', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-009', 1, 'wsa:Address', '@repleTo', 'TAG-008', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('TAG-010', 2, 'soap:Body', '', 'TAG-001', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('ATTR-01', 3, 'xmlns:soap', 'http://www.w3.org/2003/05/soap-envelope', 'TAG-001', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('ATTR-02', 3, 'xmlns:wsa', 'http://www.w3.org/2005/08/addressing', 'TAG-001', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

insert into OMPRD.cfg_il (ID_ELEMENT, TYPE_ELEMENT, NAME_ELEMENT, VALUE_ELEMENT, PARENT_ID, CREATED_DT, CREATED_WHO, ACTIVE_DT, CHANGE_DT, CHANGE_WHO, INACTIVE_DT)
values ('ATTR-03', 3, 'xmlns:wsse', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd', 'TAG-001', to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', to_date('01-07-2020', 'dd-mm-yyyy'), to_date('01-07-2020', 'dd-mm-yyyy'), 'GAPOLINAR', null);

