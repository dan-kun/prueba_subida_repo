CREATE OR REPLACE PACKAGE BODY OMPROD.OM_CREATE_XML AS
-- Add node to ty_xmlelement
procedure add_node(
                   p_tb_xmlelements  in out  ty_xmlelement,
                   p_tb_index_nodes  in out  ty_varchar2,
                   p_index_id        in      varchar2,
                   p_parent_index_id in      varchar2,
                   p_node_name       in      varchar2,
                   p_text_value      in      varchar2,
                   p_attribs         in      ty_xmlattrib
                  )
is
begin

   -- Add node
   p_tb_xmlelements.extend;
   p_tb_index_nodes( p_index_id ) := p_tb_xmlelements.last;
   p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_attribs := OM_CREATE_XML.ty_xmlattrib();
   p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_parent := p_tb_xmlelements( p_tb_index_nodes( p_parent_index_id ) ).p_node;
   p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_element_name := p_node_name;
   p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_text_value := p_text_value;

   -- Add attribs
   if p_attribs is not null then
      p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_attribs := OM_CREATE_XML.ty_xmlattrib();
      for i_att in 1..p_attribs.count() loop
          p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_attribs.extend();
          p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_attribs(i_att).p_attrib_name := p_attribs(i_att).p_attrib_name;
          p_tb_xmlelements( p_tb_index_nodes( p_index_id ) ).p_attribs(i_att).p_attrib_value := p_attribs(i_att).p_attrib_value;
      end loop;
   end if;

end add_node;

-- Write node to XML
procedure write_node(
                     p_domdoc    in out   dbms_xmldom.DOMDocument,
                     p_reg_nodo  in out   ry_xmlelement
                    )
is
begin

   -- Write node
   p_reg_nodo.p_element := dbms_xmldom.createElement(p_domdoc, p_reg_nodo.p_element_name );

   if p_reg_nodo.p_attribs is not null then
       if p_reg_nodo.p_attribs.count() > 0 then
          for i_att in 1..p_reg_nodo.p_attribs.count() loop
             dbms_xmldom.setAttribute(
                                      p_reg_nodo.p_element,
                                      p_reg_nodo.p_attribs(i_att).p_attrib_name,
                                      p_reg_nodo.p_attribs(i_att).p_attrib_value
                                     );
          end loop;
       end if;
   end if;

   p_reg_nodo.p_node := dbms_xmldom.appendChild(p_reg_nodo.p_parent,dbms_xmldom.makeNode(p_reg_nodo.p_element));
   p_reg_nodo.p_text := dbms_xmldom.createTextNode(p_domdoc, p_reg_nodo.p_text_value );
   p_reg_nodo.p_textnode := dbms_xmldom.appendChild(p_reg_nodo.p_node,dbms_xmldom.makeNode(p_reg_nodo.p_text));

end write_node;

END OM_CREATE_XML;
/