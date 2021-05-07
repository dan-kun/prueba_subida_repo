CREATE OR REPLACE PACKAGE OMPRD.OM_CREATE_XML IS

-- Declare XML types
   type ry_xmlattrib is record (
                                p_attrib_name     varchar2(512),
                                p_attrib_value    varchar2(32767)
                               );
   type ty_xmlattrib is table of ry_xmlattrib;

   type ry_xmlelement is record (
                                 p_parent         dbms_xmldom.DOMNode,
                                 p_element_name   varchar2(512),
                                 p_element        dbms_xmldom.DOMElement,
                                 p_attribs        ty_xmlattrib,
                                 p_node           dbms_xmldom.DOMNode,
                                 p_text_value     varchar2(32767),
                                 p_text           dbms_xmldom.DOMText,
                                 p_textnode       dbms_xmldom.DOMNode
                                );
   type ty_xmlelement is table of ry_xmlelement;

   type ty_varchar2 is table of varchar2(32767) index by varchar2(64);


-- Add node to ty_xmlelement
    procedure add_node(
                       p_tb_xmlelements  in out  ty_xmlelement,
                       p_tb_index_nodes  in out  ty_varchar2,
                       p_index_id        in      varchar2,
                       p_parent_index_id in      varchar2,
                       p_node_name       in      varchar2,
                       p_text_value      in      varchar2,
                       p_attribs         in      ty_xmlattrib
                      );
-- Write node to XML
   procedure write_node(
                        p_domdoc    in out   dbms_xmldom.DOMDocument,
                        p_reg_nodo  in out   ry_xmlelement
                       );

END OM_CREATE_XML;
/