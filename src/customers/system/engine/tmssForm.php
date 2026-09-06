<?php

require_once('tmssFormDocument.php');
require_once('tmssFormInput.php');


class tmssForm {



  # Properties
  
  private $go_doc;              # DOCUMENT
  //private $go_tree;             # TREE
  //private $go_tables;           # TABLE
  private $go_inputs;           # INPUT
  //private $go_messagebox;      # MESSAGEBOX
	//private $cv_svewsrt;		      # campos de orden de grilla
	//private $cv_lvewfldcnt;		    # cantidad de campos
	//private $cv_svewmaxrec;       # cantidad máxima de registros
	//private $cv_avewfld    =array();  # campos
	//private $cv_avewfldflt =array();	# filtro
	//private $cv_avewfldflt2=array();	# filtro hasta
  //private $cv_smsgtxt;          # mensaje - texto
  //private $cv_smsgtyp;          # mensaje - tipo
  //private $cv_smsginf;          # mensaje - información adicional



  # methods
  
  
  /**
   * class constructor
   */
  function __construct() {
    $this->go_doc      = new tmssDocument();
    $this->go_inputs   = new tmssInput();
  }


  /**
   * class destructor
   */
  function __destruct() {
#    set go_doc      = nothing
#    set go_tree     = nothing
#    set go_tables   = nothing
#    set go_inputs   = nothing
#    set go_messagebox = nothing
  }  
  
  /**
   * database class
   */
  function doc() {
    return $this->go_doc;
  }


  /**
   * input class
   */
  function inputs() {
    return $this->go_inputs;
  }


/*
  ' TREEs
  public property get Tree()
    set tree = go_tree
  end property

  ' TABLEs
  public property get Tables()
    set tables = go_tables
  end property
*/

  
  /*
  ' MESSAGE BOXs
  public property get MessageBox()
    set messagebox = go_messagebox
  end property

  ' mensaje informativo
  public property Let Message(lp_msg)
    cv_smsgtyp = "O"
    cv_smsgtxt = lp_msg
    cv_smsginf = ""
  end property

  public function Message2(lp_typ, lp_msg, lp_inf)
    cv_smsgtyp = lp_typ
    cv_smsgtxt = lp_msg
    cv_smsginf = lp_inf
  end function

  public property get MessageText()
    MessageText = cv_smsgtxt
  end property
  public property get MessageType()
    MessageType = cv_smsgtyp
  end property
  
  ' Escribe en el formulario un mensaje informativo
  Public Sub DisplayMessage()
    response.write "<SCR"+"IPT>window.top.tmssMessage('" + cv_smsgtyp + "','" + replace(cv_smsgtxt,"'","´") + "');</SCR"+"IPT>"
  End Sub
  */

}


/*

'-----------------------------------------------------------------------------
'
' C L A S E    -    T R E E
'
' Nombre : tmssTree
' Tarea  : clase para la administración los arboles
'
'-----------------------------------------------------------------------------
Class tmssTree

  dim lv_sdat


  ' Constructor de la clase
  Private Sub Class_Initialize()
    lv_sdat=""
  End Sub


  ' Destructor de la clase
  Private Sub Class_Terminate()
  End Sub


  ' Crea una lista tipo arbol
  Public Function Create(lp_sid)
  End Function


  ' Agrega un nodo al arbol
  Public Function AddNode(lp_sid, lp_scod, lp_stxt, lp_smnuchl, lp_smnupar, lp_value)
    lv_sdat = lv_sdat & lp_sid & vbTab & lp_scod & vbTab & lp_stxt & vbTab & lp_smnuchl & vbTab & lp_smnupar & vbTab & lp_value & vbCrLf
  End Function


  ' Escribe el arbol
  Public Function Write(lp_sid, lp_sdat, lv_breadonly)
    response.write GetCode(lp_sid, lp_sdat, lv_breadonly)
  End Function


  
  ' Devuelve el código HTML del botón
  Public Function GetCode(lp_sid, lp_sdat, lv_breadonly)
    dim lv_sbuffer
    lv_sbuffer = ""
    lv_sbuffer = lv_sbuffer & "<ul id='"&lp_sid&"'>"
    lv_sbuffer = lv_sbuffer & LoadFolder(lp_sid, "", lp_sdat, lv_breadonly)
    lv_sbuffer = lv_sbuffer & "</ul>"
    lv_sbuffer = "<SCR"&"IPT>" & _
                  "$(document).ready(function(){ " & _
                    "$('#" & lp_sid & "').Tree();" & _
                  "});" & _
                  "</SCR"&"IPT>" & lv_sbuffer
'                    "$('#" & lp_sid & "').removeAttr('style');" & _
'                    "$('#" & lp_sid & "').css('line-height','inherit').css('float','inherit').css('text-align','inherit');" & _
'                    "$('#" & lp_sid & "').css('fieldset label','');" & _

    GetCode = lv_sbuffer
  End Function

  Private Function LoadFolder(lp_sid, lp_smnuchl, lp_sdat, lv_breadonly)
    dim lv_odat, lv_orow
    dim lv_lcount, lv_sbuffer, lv_stmp, lv_sval

    lv_sbuffer = ""
    lv_odat = Split( lv_sdat , vbCrLf )
    for lv_lcount = 0 to ubound(lv_odat)-1
      lv_orow = Split( lv_odat(lv_lcount) , vbTab )

      '-- mismo arbol, punto de partida encontrado, opciones que dependen de..
      if lv_orow(0)=lp_sid and lv_orow(4)=lp_smnuchl then

        '-- es una carpeta (mnuchl con valor)
        if not lv_orow(3)="" then

          '-- me aseguro que la carpeta tenga contenido antes de armar el arbol
          lv_stmp = LoadFolder(lp_sid, lv_orow(3), lp_sdat, lv_breadonly )
          if not lv_stmp="" then
            lv_sbuffer = lv_sbuffer & "<LI><label><INPUT type='checkbox' name='"&lv_orow(0)&"' value='"&lv_orow(1)&"'>"&lv_orow(2)&"</label><UL>" & lv_stmp & "</UL></LI>"
          end if

        '-- es un nodo
        else
          lv_sval = ""
          if instr(lp_sdat,lv_orow(1)&vbCrLf)>0 then lv_sval="CHECKED"
          lv_sbuffer = lv_sbuffer & "<LI><label><INPUT type='checkbox' name='"&lv_orow(0)&"' value='"&lv_orow(1)&"' " & lv_sval & ">"&lv_orow(2)&"</label></LI>"
        end if

      end if
    next
    LoadFolder = lv_sbuffer
  End Function



End Class



'-----------------------------------------------------------------------------
'
' C L A S E    -    T A B L E
'
' Nombre : tmssTable
' Tarea  : clase para la administración de tablas de ingreso de datos
' Scripts: tmssForm.js  - check_delrow(object, ???, ???)
'
'-----------------------------------------------------------------------------
Class tmssTable

  private go_db
  private go_sec
  private go_input
  private lv_tblid
  private gv_scols

  private lv_badd
  private lv_bdel
  private lv_stlb

  ' Constructor de la clase
  Private Sub Class_Initialize()
    set go_input = new tmssInput
    lv_badd = true
    lv_bdel = true
    lv_stlb = ""
  End Sub


  ' Destructor de la clase
  Private Sub Class_Terminate()
    set go_input = nothing
    set go_sec = nothing
    set go_db = nothing
  End Sub


  ' DATABASE
  Public Property Let DBClass(lp_db)
    set go_db = lp_db
  	go_input.DBClass = lp_db
  End Property


  ' INPUTs
  public property get Inputs()
    set inputs = go_input
  end property
  

  ' SECURITY
  Public Property Let SECClass(lp_sec)
    set go_sec = lp_sec
  	go_input.SECClass = lp_sec
  End Property


  ' Crea una nueva tabla de ingreso de datos
  Public Sub Create(lp_id)
    lv_tblid = lp_id
  End Sub

  Public Property Get AllowAdd()
    allowadd = lv_badd
  End Property
  Public Property Let AllowAdd(lp_val)
    lv_badd = lp_val
  End Property
  Public Property Get AllowDel()
    allowdel = lv_bdel
  End Property
  Public Property Let AllowDel(lp_val)
    lv_bdel = lp_val
  End Property


  ' devuelve la cantidad de columnas de una tabla
  public property get CountColumns(lp_id)
    Dim lv_adat, lv_lcount
    CountColumns = 0
    lv_adat = Split( gv_scols , vbCrLf )
    for lv_lcount = 0 to ubound(lv_adat)-1
      if Split( lv_adat(lv_lcount) , vbTab )(0)=lp_id then CountColumns = CountColumns + 1
    next
  end property


  ' Agrega una columna a la tabla de ingreso de datos
  ' Recibe : String. id de la columna
  '          String. título de la columna
  '          String. definición de campo
  '          String. valor por default
  '          String. JavaScript al hacer click en el botón asociado al campo
  '          String. JavaScript al presionar una tecla en el campo
  '          Int.    Flag de solo lectua (1-solo lectura)
  '          Int.    Flag de campo clave (1-campo clave)
  '          Int.    Flag de campo oculto (1-campo oculto)
  Public Sub AddColumn(lp_id, lp_title, lp_domain, lp_defval, lp_jsfncprm, lp_jsfndkeyprs, lp_breadonly, lp_key, lp_hidden)
    gv_scols = gv_scols & lv_tblid & vbTab & lp_id & vbTab & lp_title & vbTab & lp_domain & vbTab & _
                          lp_defval & vbTab & lp_jsfncprm & vbTab & lp_jsfndkeyprs & vbTab & _
                          lp_breadonly & vbTab & lp_key & vbTab & lp_hidden & vbCrLf
  End Sub
  

  ' Agrega un botón a la barra de herramientas (a la izquierda)
  ' Recibe : String. id del botón de la barra de herramientas
  '          Strnig. imagen del botón
  '          String. texto del botón
  '          String. javascript del botón al hacer click
  Public Sub AddButton(lp_tlb, lp_id, lp_img, lp_txt, lp_lbl, lp_disabled, lp_jsonclick)
    dim lo_btn
    set lo_btn=new tmssButton
    lv_stlb = lv_stlb & go_db.iif(lv_stlb="","",vbCrLf) & lp_tlb & vbTab & lo_btn.GetCode2(lp_tlb & "_" & lp_id, lp_img, lp_txt, lp_lbl, lp_disabled, lp_jsonclick)
  End Sub


  ' Escribe la tabla de ingreso de datos en el documento de salida
  ' Recibe : String. id de la tabla
  '          Array.  datos de la tabla
  '          Int.    flag de solo lectura (1-solo lectura)
  ' Comentarios: La tabla de datos es un array de datos separados por "~", y debe
  '              coincidir la cantidad de datos enviados con las columnas de la
  '              tabla
  Public Sub Write(lp_id, lp_data, lp_readonly)
    response.write GetCode(lp_id, lp_data, "", lp_readonly)
  End Sub


  ' lee los datos de la tabla desde el FORM
  ' Recibe : String. id de la tabla
  '          Array.  array de datos
  ' Entrega: Número. cantidad de registros leídos
  Public Function ReadData(lp_id, lp_array)

    dim lv_lcount, lv_lcount2
    dim lv_ltotrows
    dim lv_acol, lv_adat
    dim lv_sbuffer
    dim lv_sreqvalues
    
    go_input.reqvalues = ""
    
    ' obtengo la cantidad de registros de la tabla
    lv_ltotrows = request.form(lp_id & "_tot_rows")

    lv_adat = Split( gv_scols , vbCrLf )

    ' para cada fila
    for lv_lcount = 0 to lv_ltotrows

      ' recupero los datos de todos los campos
      lv_sreqvalues = ""
      for lv_lcount2 = 0 to ubound( lv_adat )-1
        lv_acol = split( lv_adat(lv_lcount2) , vbTab )
        ' si la columna corresponde con la tabla indicada
        if lv_acol(0) = lp_id then
          lv_sbuffer = request.form( lp_id & "_" & lv_acol(1) & lv_lcount )
          if instr(lp_id & "_" & lv_acol(1), go_input.reqfields)>0 and lv_sbuffer="" then
            lv_sreqvalues = lv_sreqvalues & "|" & lp_id & "_" & lv_acol(1) & lv_lcount
          end if
          lp_array(lv_lcount) = lp_array(lv_lcount) & request.form( lp_id & "_" & lv_acol(1) & lv_lcount ) & "~"
        end if
      next

      ' si quedaron solo espacios, los vacío
      if trim(replace(lp_array(lv_lcount),"~","")) = "" then
        lp_array(lv_lcount) = ""
      elseif not lv_sreqvalues="" then
        go_input.reqvalues = go_input.reqvalues & lv_sreqvalues
      end if

    next
    
    ReadData = lv_ltotrows
    
  End Function




  ' Escribe la tabla de ingreso de datos en el documento de salida
  ' Recibe : String. id de la tabla
  '          Array.  datos de la tabla
  '          Array.  config de la tabla
  '          Int.    flag de solo lectura (1-solo lectura)
  ' Comentarios: La tabla de datos es un array de datos separados por vbTab, y debe
  '              coincidir la cantidad de datos enviados con las columnas de la
  '              tabla
  Public Function GetCode(lp_id, lp_data, lp_cfg, lp_readonly)
    dim lv_sbuffer, lv_adata, lv_srow
    dim lv_lcount, lv_lcount2, lv_lcount3
    dim lv_rowcnt
    dim lv_skey
    dim lv_ltotcols
    dim lv_adat, lv_acol

    lv_sbuffer = ""
    lp_id = replace(lp_id,"'",chr(34))

    ' obtengo la cantidad de columnas de la tabla
    lv_ltotcols = CountColumns( lp_id )

    lv_adat = Split( gv_scols , vbCrLf )

    '-- MODELO
    if lp_readonly = 0 then
      lv_sbuffer = lv_sbuffer & "<DIV id='"&lp_id&"_tbl_src' class='tmss-ui-display-none'>" & _
                                "<TABLE><TBODY><TR id='"&lp_id&"_tr_~' name='"&lp_id&"_tr_~' key=''>" & _
                                "<td><input type='checkbox' name='"&lp_id&"_chk_row' nodelete='1'></td>"
      for lv_lcount2 = 0 to ubound(lv_adat)-1
        lv_acol = split( lv_adat(lv_lcount2) , vbTab )
        if lv_acol(0)=lp_id then  ' si la columna corresponde con la tabla indicada
          ' si la tabla es solo lectura, todos los campos lo son
          if lp_readonly=1 then lv_acol(7)=1
          lv_sbuffer = lv_sbuffer & "<TD " & go_db.iif(lv_acol(9)=1,"class='tmss-ui-display-none'","") & " nowrap >" & _
                                    go_input.gethtmlcode( lp_id&"_"&lv_acol(1)&"~", lv_acol(3), "", lv_acol(5), lv_acol(6), "", "", "", "", "", lv_acol(7) ) & _
                                    "</TD>"
        end if
      next
      lv_sbuffer = lv_sbuffer & "</TR></TBODY></TABLE>" & _
                                "</DIV>"
    end if

    lv_sbuffer = lv_sbuffer & "<DIV id='" & lp_id & "'>"

    '-- barra de herramientas
    dim lv_odat, lv_sbuffer2
    if lv_bdel=true then AddButton lp_id, "tlb_del", "ui-icon-trash", "", "-", go_db.iif(lp_readonly=1,true,false), "tmssTableDelRow('"&lp_id&"');"
    if lv_badd=true then AddButton lp_id, "tlb_add", "ui-icon-plus", "", "+", go_db.iif(lp_readonly=1,true,false), "tmssTableAddRow('"&lp_id&"');"
    lv_odat = Split(lv_stlb,vbCrLf)
    lv_sbuffer2 = ""
    for lv_lcount2 = ubound(lv_odat) to 0 step -1
      if split(lv_odat(lv_lcount2),vbTab)(0)=lp_id then
        lv_sbuffer2 = lv_sbuffer2 & split(lv_odat(lv_lcount2),vbTab)(1)
      end if
    next
    if not lv_sbuffer2="" then lv_sbuffer = lv_sbuffer & "<div id='"&lp_id&"_tlb' class='ui-widget-header ui-corner-all'>" & lv_sbuffer2 & "</div>"


    '-- títulos
    lv_sbuffer = lv_sbuffer & "<TABLE id='"&lp_id&"_tbl' class='tmss-ui-table'>" & _
                            "<THEAD>" & _
                            "<TR>" & _
                            "<TH>" & _
                              "<input type='hidden' name='"&lp_id&"_key' value=''>" & _
                              "<input type='hidden' name='"&lp_id&"_nodelete' value='1'>" & _
                              go_db.iif(lp_readonly=1,"&nbsp;","<input type='checkbox' id='"&lp_id&"_chk_hdr'>") & _
                            "</TH>"
    for lv_lcount = 0 to ubound(lv_adat)-1
      lv_acol = Split( lv_adat(lv_lcount) , vbTab )
      if lv_acol(0)=lp_id then lv_sbuffer=lv_sbuffer & "<TH " & go_db.iif(lv_acol(9)=1,"class='tmss-ui-display-none'","") & ">" & lv_acol(2) & "</TH>"
    next
    lv_sbuffer=lv_sbuffer &   "</TR>"
    lv_sbuffer=lv_sbuffer & "</THEAD>"

    '-- DATOS
    lv_rowcnt=-1
    lv_sbuffer = lv_sbuffer & "<TBODY>"
    for lv_lcount = 0 to ubound( lp_data )-1
      lv_adata = split( lp_data(lv_lcount) , "~" )
      '-- verifico que los datos recibidos y la cantidad de columnas coincidan
      if ubound(lv_adata)=lv_ltotcols then
        lv_lcount3 = 0
        lv_srow = ""
        lv_skey = ""
        lv_rowcnt = lv_rowcnt + 1
        for lv_lcount2 = 0 to ubound(lv_adat)-1
          lv_acol = split( lv_adat(lv_lcount2) , vbTab )
          if lv_acol(0)=lp_id then  ' si la columna corresponde con la tabla indicada
            if lv_acol(8)=1 then  ' si la columna es parte de la clave
              if not lv_skey="" then lv_skey=lv_skey & "_"
              lv_skey=lv_skey & lv_adata(lv_lcount3)
            end if
            ' si la tabla es solo lectura, todos los campos lo son
            if lp_readonly=1 then lv_acol(7)=1
            lv_srow = lv_srow & "<TD " & go_db.iif(lv_acol(9)=1,"class='tmss-ui-display-none'","") & " nowrap >" & _
                                replace( go_input.gethtmlcode( lp_id&"_"&lv_acol(1)&lv_rowcnt, lv_acol(3), lv_adata(lv_lcount3), lv_acol(5), lv_acol(6), "if(event.keyCode==13){tmssTableNxtFld(this.id);}", "", "", "", "", lv_acol(7) ) , "~" , lv_lcount ) & _
                                "</TD>"
            lv_lcount3 = lv_lcount3 + 1
          end if
        next
        lv_sbuffer = lv_sbuffer & "<TR id='"&lp_id&"_tr_"&lv_rowcnt&"' name='"&lp_id&"_tr_"&lv_rowcnt&"'>" & _
                                    "<TD>" & _
                                      "<input type='hidden' name='"&lp_id&"_key' value='"&lv_skey&"'>" & _
                                      "<input type='hidden' name='"&lp_id&"_nodelete' value=''>" & _
                                      go_db.iif(lp_readonly=1,"&nbsp;","<input type='checkbox' name='"&lp_id&"_chk_row'>") & _
                                    "</TD>" & _
                                    lv_srow & _
                                  "</TR>"
      end if

    next

    lv_sbuffer = lv_sbuffer & "</TBODY>" & _
                              "</TABLE>" & _
                              "<input type='hidden' name='" & lp_id & "_tot_rows" & "' id='" & lp_id & "_tot_rows' value='" & lv_rowcnt & "'>" & _
                              "<input type='hidden' name='" & lp_id & "_del" & "'      id='" & lp_id & "_del'      value=''>" & _
                              "</DIV>" & _
                              "<scr"&"ipt>" & _
                              "$('#"&lp_id&"_chk_hdr').click( function(){ tmssCheckboxHeaderCheck('"&lp_id&"_chk_hdr','"&lp_id&"_chk_row'); });" & _
                              go_db.iif(lp_readonly=0 and lv_badd=true, "tmssTableAddRow('"&lp_id&"');", "") & _
                              "</scr"&"ipt>"

    GetCode = lv_sbuffer

  End Function



End Class
*/

?>