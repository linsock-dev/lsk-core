<?php
  // url del formulario
  $lv_lnk = '?prg=sysdocfrm&prm_sysdocfrmcod='.$vew_data->sysdocfrmcod;

  // campos requeridos
  $vew_input->RequiredFields( array('sysdocfrmtxt', 'docsts') );

  // clave del documento
  $lv_dockey = $vew_data->sysdocfrmcod;

  // titulo
  $lv_title = $vew_lang->forms;

  // módulo y programa
  $lv_mdlcod = 'SYS';
  $lv_prgcod = 'FRM';

  // librería de estilos bootstrap
  include_once('_library.frm');
	if($vew_actcod == '03'){  
    $vew_tbl['prevR'] = array('pos'=>'R', 'per'=>true, 'ttl'=>'', 'id'=>'btnshw', 'icn'=>'far fa-projector', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn', 'acc'=>'');
    $vew_tbl['prevD'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->form, 'id'=>'btnshw', 'icn'=>'far fa-projector', 'css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>'');
  }
?>
<style>
  .tmssFormLayout .tmssElement{
    margin: 3px 0px;
  }
  
  .tmssElement *[disabled]{ cursor:default }
  
  .tmssFormLayout{
    overflow-y:auto;
		max-height: calc(100vH - 290px);
    overflow-x:visible;
    padding:15px 0px 15px 0px;
  }
  
	.tmssCardBodyMaxHeight{
		max-height: calc(100vH - 290px);
		overflow-y: scroll;
	}
	
	.tmssElement.active{
		background-color: lightgoldenrodyellow;
		border-radius: 15px;
		border: gold 2px solid;
	}
  
  .tmssElement.error{
    border-radius: 15px;
    border: orangered 2px solid;
	}
  .tmssElement *[disabled]{ cursor:default }
  
  .tmssFormLayout .tmssElement .inputObject.hidden{
    display: block!important;
    background-image: url("data:image/svg+xml,%3csvg width='100%25' height='100%25' xmlns='http://www.w3.org/2000/svg'%3e%3crect width='100%25' height='100%25' fill='none' stroke='%23676464FF' stroke-width='3' stroke-dasharray='10' stroke-dashoffset='0' stroke-linecap='square'/%3e%3c/svg%3e");
  }
</style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('sysdocfrmfld', 'hidden', ''); ?>
    
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" <?= ($vew_actcod=='01'?'class="active"':'') ?> ><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li role="presentation" <?= ($vew_actcod!='01'?'class="active"':'') ?> ><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->layout; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->sysdocfrmcod; ?><?= gethtml('sysdocfrmcod', 'hidden', $vew_data->sysdocfrmcod); ?></strong></h4></li>
      </ul>
      <div class="tab-content tmss-tab-content">
				
        <!-- GENERAL -->
        <div role="tabpanel" class="tab-pane <?= ($vew_actcod=='01'?'active':'') ?>" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->general; ?></div></div>
                <div class="card-body">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			 'input'=>gethtml('sysdocfrmcodext', 'doccmt1x20', $vew_data->sysdocfrmcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('sysdocfrmtxt', 'doccmt1x50', $vew_data->sysdocfrmtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			 'input'=>gethtml('docsts', 		'docsts',	$vew_data->docsts, $lv_default ) ));
                  ?>
                </div>
              </div><!-- /card -->
            </div><!-- /col-sm-6 -->
          </div><!-- /row -->
        </div><!-- /tab001 -->

        <!-- LAYOUT -->
        <div role="tabpanel" class="tab-pane <?= ($vew_actcod!='01'?'active':'') ?>" id="<?= $lv_sec; ?>_tab002">
          <div class="row">
						
						<!-- HERRAMIENTAS -->
            <div class="<?= ($vew_readonly?'hidden':'col-sm-2'); ?>">
              <div class="card tmssElementContainer">
                <div class="card-header"><div class="card-title"><?= $vew_lang->elements; ?></div></div>
                <div class="card-body tmss-card-body-edit tmssCardBodyMaxHeight">
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="TEXT"><i class="far fa-input-text"></i> Text</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="NUMBER"><i class="far fa-input-numeric"></i> Number</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="LABEL"><i class="far fa-font"></i> Label</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="DATE"><i class="far fa-calendar"></i> Date</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="BUTTON"><i class="far fa-stop"></i> Button</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="CHECKBOX"><i class="far fa-square-check"></i> Checkbox</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="LIST"><i class="far fa-list"></i> List</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="FILE"><i class="far fa-file"></i> File</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="COMBO"><i class="far fa-list-dropdown"></i> Combo</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="TEXTAREA"><i class="far fa-text"></i> TextArea</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="TYPEAHEAD"><i class="far fa-i-cursor"></i> Typeahead</a>
                  <a href="#" class="tmssElement tmssElementDraggable card-opt-body text-left" data-code="HR"><i class="far fa-horizontal-rule"></i> Line</a>
                </div>
              </div><!-- /card -->
            </div><!-- /col-sm-2 -->
						
						<!-- FORMULARIO -->
            <div class="<?= ($vew_readonly?'col-sm-9':'col-sm-7'); ?>">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->form; ?></div></div>								
								<div class="card-body tmssFormLayout">
									<?php
										foreach ($vew_data->sysdocfrmfld as $lv_row) {
											echo '<div class="tmssElement" id="'.$lv_row['sysdocfrmfldcod'].'" data-code="'.$lv_row['sysfldinptyp'].'" ></div>';
										}
									?>
								</div>
							</div><!-- /card -->
            </div><!-- /col-sm-7 -->

						<!-- ATRIBUTOS -->
            <div class="col-sm-3">
              <div class="card attributeContainer">
                <div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
                <div class="card-body tmss-card-body-edit tmssCardBodyMaxHeight">
									<span></span>
									<hr>
									<?= ($vew_readonly?'':'<div class="text-center"><div class="btn btn-danger hidden" id="btnDelAtr"><i class="far fa-trash"></i> '.$vew_lang->delete.'</div></div>'); ?>
								</div>
              </div>
            </div>
						
          </div><!-- /row -->
        </div><!-- /tab002 -->
      </div><!-- /tab-content -->
    </div><!-- /container-fluid -->
  </form>
  <script>
    // PREVIEW. muestra el formulario en modo previsualización
    $("#<?= $lv_sec; ?> #btnshw").click(function(){
     if(tmssCheckRequiredFields($("#<?= $lv_sec; ?>_frm"))){
       //Si esta en modo de 'mostrar' vista entonces exite sysdocfrmcod
      <?php if($vew_actcod =='03') {     ?> 
        var lo_dat =   [{"name": "sysdocfrmcod", "value" : $("#<?= $lv_sec; ?> #sysdocfrmcod").val()}];
        <?php }else{?> 
      	//Caso de preview mientras se modifica o se carga un nuevo formulario
       	// cambio la tab
  			$("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").trigger("click");
       	//<?= $lv_sec;?>_serializeForm(true)
       // var lo_dat = 
       <?php } ?> 
             tmssCallProcess("?prg=grldatfrm&act=05", lo_dat, function(data){
            BootstrapDialog.show({
              title:"<?= $vew_lang->form; ?>",
              message:$(data),
              draggable:true,
              closable:true,
              type:BootstrapDialog.TYPE_PRIMARY,
              size:BootstrapDialog.SIZE_WIDE
            });
          });
     }
    });
  </script>
  <script>
    // defino HTML de elementos
    var gv_<?= $lv_sec; ?>_elmHtml = {};
    gv_<?= $lv_sec; ?>_elmHtml["TEXT"] 			= "<?= str_replace( '"', '\'', gethtml( '', 'doccmt1x50', '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["DATE"] 			= "<?= str_replace( '"', '\'', gethtml( '', 'docdte', '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["LIST"] 			= "<?= str_replace( '"', '\'', gethtml( '', array(''=>''), '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["FILE"] 			= "<?= str_replace( '"', '\'', gethtml( '', 'flefle', '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["COMBO"] 		= "<?= str_replace( '"', '\'', gethtml( '', array(''=>''), '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["NUMBER"] 		= "<?= str_replace( '"', '\'', gethtml( '', 'docqty', '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["TEXTAREA"] 	= "<?= str_replace( '"', '\'', gethtml( '', 'doccmt5x50', '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>";
    gv_<?= $lv_sec; ?>_elmHtml["BUTTON"] 		= "<a href='#' css='btn btn-default inputObject'></a>";
    gv_<?= $lv_sec; ?>_elmHtml["CHECKBOX"] 	= "<?= str_replace( '"', '\'', gethtml( '', 'checkbox', '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ) ?>".replace( "data-size='xs'", "data-size='md'" );
    gv_<?= $lv_sec; ?>_elmHtml["LABEL"] 		= "";
    gv_<?= $lv_sec; ?>_elmHtml["HR"] 				= "";
    gv_<?= $lv_sec; ?>_elmHtml["TYPEAHEAD"]	= "<?= str_replace( '"', '\'', vew_boot(
																												array('style'=>'search', 'readonly'=>$vew_readonly),
																												array('input'=>gethtml('', 'typeahead', '', array( 'atrval'=>array('css'=>'form-control inputObject') ))))) ?>";

    // Array de atributos------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    var gv_<?= $lv_sec; ?>_elmHtmlAttr =<?php
			//crea estructura inicial de array
			$lo_elmArr = array( 'TEXT'=>'{ ', 'LABEL'=>'{ ', 'DATE'=>'{ ', 'LIST'=>'{ ', 'FILE'=>'{ ', 'COMBO'=>'{ ', 'NUMBER'=>'{ ', 'TEXTAREA'=>'{ ', 'BUTTON'=>'{ ', 'CHECKBOX'=>'{ ', 'HR'=>'{ ', 'TYPEAHEAD'=>'{ ', 'CUSTOM'=>'{ ' );
      //recorre el array de atributos
      foreach( $vew_data->sysdocfrmfldatr as $lv_row ){
        //recorre el array de elementos
        foreach( explode( ';', $lv_row['sysdocfrmfldatrelm'] ) as $lv_row2 ){
          $lo_elmArr[$lv_row2] .= ($lo_elmArr[$lv_row2]!='{ '?', ':'').'"'.$lv_row['sysdocfrmfldatrtxt'].'":{"code":"'.$lv_row['sysdocfrmfldatrcod'].'"
                                                                                                            ,"sysfld":"'.$lv_row['sysfld'].'"
                                                                                                            ,"input":"'.str_replace( '"', '\'', gethtml( '', $lv_row['sysfld'], '', array( 'atrval'=>array('css'=>'form-control inputObject') ) ) ).'"
                                                                                                            ,"obj":"'.( $lv_row['sysdocfrmfldatrobj'] == null ? "input"  : $lv_row['sysdocfrmfldatrobj'] ).'"
                                                                                                            ,"tgt":"'.( $lv_row['sysdocfrmfldatrtgt'] == null ? ""  : $lv_row['sysdocfrmfldatrtgt'] ).'"
                                                                                                            ,"def":"'.( $lv_row['sysdocfrmfldatrdef'] == null ? ""  : $lv_row['sysdocfrmfldatrdef'] ).'"
                                                                                                            ,"rpl":"'.( $lv_row['sysdocfrmfldatrrpl'] == null ? "0" : $lv_row['sysdocfrmfldatrrpl'] ).'"}';
        }
      };
  		foreach( $lo_elmArr as &$lv_row ){ $lv_row .= ' }'; }
  		unset($lv_row);
  		echo json_encode($lo_elmArr);
    ?>;
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //Array de atributos de los elementos grabados----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    var gv_<?= $lv_sec; ?>_elmHtmlSveAttr = <?php
      //array de elementos
      $lo_elm = array();

      //recorre los elementos grabados
      foreach ($vew_data->sysdocfrmfld as $lv_row){
        //crea el json de los atributos
        $lv_atrs = '{';
        
        //recorre los atributos del elemento
        foreach(json_decode($lv_row['sysdocfrmfldatr']) as $lv_row2){
          //recorre todos los atributos
          foreach($vew_data->sysdocfrmfldatr as $lv_row3 ){
            //revisa que se encuentre el atributo en el array de atributos
            if( $lv_row3['sysdocfrmfldatrcod'] != $lv_row2->sysdocfrmfldatrcod ){ continue; }
            //se crea el json del atributos
             if (json_last_error() === JSON_ERROR_NONE) {
                // si es un json valido, caso de los filtros.
                $lv_atr = '"' . $lv_row2->sysdocfrmfldatrcod . '":' . json_encode($lv_row2->sysdocfrmfldatrval);
            } else {
                // si no es un json valido
                $lv_atr = '"' . $lv_row2->sysdocfrmfldatrcod . '":"' . $lv_row2->sysdocfrmfldatrval . '"';
            }
            break;
          }

          //agrega el json del atributo al json de atributos
          $lv_atrs .= ($lv_atrs!='{'?', ':'').$lv_atr;
        }

        //cierra el json de atributos
        $lv_atrs .= '}';
        //agrega el json de el elemento y los atributos al array
        $lo_elm[$lv_row['sysdocfrmfldcod']] = $lv_atrs;
      }
      //hace echo del array de los elementos
      echo json_encode($lo_elm);
    ?>;
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //array de elementos borrados
    var gv_<?= $lv_sec; ?>_delElm = [];
  </script>
  <script>
    //accion que se realizan cuando se carga el formulario
    $(function(){
      $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement").each(function(){
        //agrega los elementos grabados al formulario
        <?= $lv_sec; ?>_addElement( $(this) );

        // asigna los valores grabados de los atributos
        // recupera atributos guardados del elemento
        var lv_saved_arr = JSON.parse(gv_<?= $lv_sec; ?>_elmHtmlSveAttr[ $(this).attr("id") ].replace(/\n/g, "\\n"));
        // recupera atributos de la definición del elemento
        var lv_elementAttr_arr = JSON.parse(gv_<?= $lv_sec; ?>_elmHtmlAttr[$(this).data("code")]);

        // aplica los valores guardados
        for (let lo_attr of Object.values(lv_elementAttr_arr)) {
          if(lv_saved_arr[lo_attr.code] !== undefined){
             lo_attr.def = lv_saved_arr[lo_attr.code].replace(/"/g, "'");
            <?= $lv_sec; ?>_applyAttribute( $(this), lo_attr );
          } 
        }
      })
    })
  </script>
  <script>
    // BORRADO. confirma si se desea borrar un elemento del formulario
    $("#<?= $lv_sec; ?>").on("click", "#btnDelAtr", function(e){
      e.preventDefault;
      
      var lv_element = $("#<?= $lv_sec; ?> .tmssElement.active");
      var lv_name = (lv_element.find(".inputObject").attr("name") !== undefined ? lv_element.find(".inputObject").attr("name"):"");
      
      BootstrapDialog.confirm({
        title: "Borrar elemento "+lv_name,
        message: "&iquest;Desea borrar el elemento "+lv_name+"?",
        type: BootstrapDialog.TYPE_WARNING,
        callback: function(result) {
          if(!result){ return; } 
          
          var lv_element = $("#<?= $lv_sec; ?> .tmssElement.active");
          
          //agrega elemento al array de elementos borrados si tiene una id (de base de datos)
      		if( lv_element.attr("id") !== undefined ){ gv_<?= $lv_sec; ?>_delElm.push( lv_element.attr("id") ); }
          
          lv_element.remove();
          <?= $lv_sec; ?>_hideAttributes();
        }
      });
    });
    
			
    //desmarca el elemento marcado y marca el elemento obtenido por parametro-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    function <?= $lv_sec; ?>_addHighlight( lp_element ){
      $("#<?= $lv_sec; ?> .tmssElement.active").removeClass("active");
      //<?= $lv_sec; ?>_removeHighlight( $("#<?= $lv_sec; ?> .tmssElement.active") );
      lp_element.addClass("active");
    }
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //muestra los atributos---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //construye la card de atributos, los valores de los input los toma de los data de los elementos
    function <?= $lv_sec; ?>_showAttributes( lp_element ){ 
      //vacia la card de atributos
      <?= $lv_sec; ?>_hideAttributes();

      //obtiene los atributos y los indices del objeto
      var lo_atrs = JSON.parse(gv_<?= $lv_sec; ?>_elmHtmlAttr[lp_element.data("code")]);
      for (let [lv_attrnme, lo_attr] of Object.entries(lo_atrs)) {
        //arma el label
        var lv_lbl = "<label class='col-sm-4 control-label'>"+lv_attrnme+"</label>";
        
        //arma los inputs
        var lo_inp = <?= $lv_sec; ?>_makeAttrInput(lp_element, lo_attr);
        
        //arma el elemento entero del atributo y lo añade a la lista de atributos
        $("#<?= $lv_sec; ?> .attributeContainer .card-body span:first").append( $( "<div class='form-group tmss-form-group'>"+lv_lbl+"</div>" ).append(lo_inp) );
      }

      //actualiza el titulo de la tarjeta
      $("#<?= $lv_sec; ?> .attributeContainer .card-title").text( "<?= $vew_lang->attributes; ?>" + " - " + ( lp_element.data("code")[0].toUpperCase() + lp_element.data("code").slice(1).toLowerCase() ) );
      
      //muestra el boton de borrado
			$("#<?= $lv_sec; ?> #btnDelAtr").removeClass("hidden");
    }
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //arma un input-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    function <?= $lv_sec; ?>_makeAttrInput( lp_element, lp_attribute ){
      //arma el input del atributo
      var lo_inp = $("<div class='col-sm-8'>"+lp_attribute.input+"</div>");
			var lv_tgt, lv_val;
      
      //define los data de los input
      lo_inp.find(".inputObject").each(function(){
        //completa los campos data
        $(this).data("tgt", lp_attribute.tgt);
        $(this).data("rpl", lp_attribute.rpl);
        $(this).data("obj", lp_attribute.obj);
        $(this).data("sysfld", lp_attribute.sysfld);
        $(this).data("code", lp_attribute.code);
        if( <?= ($vew_readonly?"true":"false") ?> == true ){ $(this).attr("readonly", ""); }

      	// elemento sobre el que se aplicarán los cambios en el atributo
        lv_tgt = lp_element.find( $(this).data("obj") == "LABEL" || lp_element.find(".inputObject").length == 0 ? ".labelObject" : ".inputObject" );
      	
        if((lp_attribute.tgt == "class" || lp_attribute.tgt == "style") && (lp_element.data("code") == "CHECKBOX" || lp_element.data("code") == "BUTTON")){
          lv_tgt = lv_tgt.parents("div").eq(0);
        }
        
        if( $(this).is("textarea") ){ 
          $(this).text(lv_tgt.data( $(this).data("code") ));
        }else{ 
          lv_val = $(this).data("tgt") != "text" ? lv_tgt.data( $(this).data("code") ) : lv_tgt.text();
          if($(this).is("select")){
            lv_val = lv_val.toLowerCase();
          }
          $(this).val( lv_val ); 
        }
      });

      return lo_inp;
    }
    
    // evento change para actualizar los atributos de los elementos
    $("#<?= $lv_sec; ?> .attributeContainer").on("change", ".inputObject", function(e){
      
      //obtiene el elemento
      var lo_elm = $("#<?= $lv_sec; ?> .tmssElement.active");
			
      var lo_attr = $(this).data();
      lo_attr['def'] = $(this).val();
      
      //llama la funcion para aplicar el atributo al elemento
      <?= $lv_sec; ?>_applyAttribute( lo_elm, lo_attr );
    });
    
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    // vacía los atributos y oculta el botón de eliminar
    function <?= $lv_sec; ?>_hideAttributes(){ 
      $("#<?= $lv_sec; ?> .attributeContainer .card-body span:first").empty();
			$("#<?= $lv_sec; ?> #btnDelAtr").addClass("hidden");
			$("#<?= $lv_sec; ?> .attributeContainer .card-title").text("<?= $vew_lang->attributes; ?>");
    }

    //aplica el valor inicial de un atributo a un elemento--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    function <?= $lv_sec; ?>_applyAttribute( lp_element, lp_attribute ){   
      
      if( lp_attribute.tgt == "" ){ return; }

      // elemento sobre el que se aplicarán los cambios en el atributo
      var lo_attrObject = lp_element.find( lp_attribute.obj == "LABEL" || lp_element.find(".inputObject").length == 0 ? ".labelObject" : ".inputObject" );

      if((lp_attribute.tgt == "class" || lp_attribute.tgt == "style") && (lp_element.data("code") == "CHECKBOX" || lp_element.data("code") == "BUTTON")){
        // cambia elemento destino del atributo si es clase o style para checkbox o button
        lo_attrObject = lo_attrObject.parents("div").eq(0);
      }
      
      // se eliminan del atributo los valores ingresados por el usuario
      if(lo_attrObject.data(lp_attribute.code) !== undefined && lo_attrObject.attr( lp_attribute.tgt ) !== undefined){
         lo_attrObject.attr( lp_attribute.tgt , lo_attrObject.attr( lp_attribute.tgt ).replace(lo_attrObject.data(lp_attribute.code), ""));
      }
      
      // se guarda el valor definido del atributo para mantener un seguimiento luego
      lo_attrObject.data( lp_attribute.code, lp_attribute.def );
      
      /* define el valor del atributo: 
      		rpl 0 (no reemplazar): se junta el valor definido del atributo y el valor que tenga el elemento
          rpl 1 (reemplazar): solo se usa el valor definido del atributo
    	*/
      var lv_val =  lp_attribute.def + ( lp_attribute.rpl == "0" ? " "+( lo_attrObject.attr( lp_attribute.tgt ) !== undefined ? lo_attrObject.attr( lp_attribute.tgt ) : "" ).trim() : "" );

      // si se remplaza el valor y este es vacio, se elimina el atributo
      if( lp_attribute.rpl == "1" && lv_val === ""){ 
        lo_attrObject.removeAttr( lp_attribute.tgt ); 
      }else{
        //aplica el valor del atributo
        switch (lp_attribute.tgt) {
          case "text":
            lo_attrObject.text( lv_val );
            break;
            
          case "options":
            //separa las opciones
            var lv_opt_arr = lv_val.split(/\n/gm);
            //vacia las opciones por defecto del elemento
            lo_attrObject.find('option').remove();

            // recorre las opciones
            for(var i=0; i < lv_opt_arr.length; i++){
              if( lv_opt_arr[i].trim().length == 0 ){ 
                // si la linea está vacía, la modifica para que sea una opción con valor vacío
                lv_opt_arr[i] = (i+1)+"| ";
              }else if(!lv_opt_arr[i].includes("|")){
              	// se asegura que haya un divisor
                lv_opt_arr[i] = lv_opt_arr[i]+"|"+lv_opt_arr[i];
              }

              // si el largo es 1, la opción solo contiene un separador. Se asigna el iterador como clave y valor
              if( lv_opt_arr[i].length == 1 ){ lv_opt_arr[i] = (i+1)+lv_opt_arr[i]+(i+1); }

              // divide la opción en clave y valor
              var lo_opt = lv_opt_arr[i].split("|");

              // si no hay clave, se asigna como clave el valor
              if( lo_opt[0].length == 0 ){ lo_opt[0] = lo_opt[1]; }

              // asignar opción
              lo_attrObject.append($('<option>', {value: lo_opt[0], text: lo_opt[1]}));
            }
            break;
            
          case "value":
            if(lp_element.data("code") == "CHECKBOX"){
            	lo_attrObject.attr( "checked", (lv_val.toLowerCase() === "true" || lv_val.toLowerCase() === "si"  || lv_val.toLowerCase() === "yes" || lv_val.toLowerCase() === "1"? true : false) );
            }else{
              lo_attrObject.val( lv_val );
            }
            break;
            
          case "data-typpop": 
            lo_attrObject.next().find("a").toggleClass("hidden", lv_val.trim().toUpperCase() == "NO");
            lo_attrObject.parent("div:eq(0)").toggleClass("input-group", !(lv_val.trim().toUpperCase() == "NO"));
            
          default: lo_attrObject.attr( lp_attribute.tgt, lv_val );
        }
      }
    }
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //modifica el elemento para que este en el fomrulario---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //esto lo que hace es agregar el input y el formulario a los elementos cuando se agregan por primera vez y cuando se cargan elementos de la base de datos
    function <?= $lv_sec; ?>_addElement( lp_element ){
      //añade clase para marcar que ya esta convertido
      lp_element.addClass("tmssElementPlaced col-sm-12");
      
      // recupera HTML de elemento
      var lv_elm = gv_<?= $lv_sec; ?>_elmHtml[lp_element.data("code")]; 
      // arma div del elemento 
      lp_element.append( $( "<div class='"+(lv_elm != ""?"col-sm-2":"col-sm-12")+"'>"+ (lp_element.data("code") == "HR" ? "<hr class='labelObject'>":"<label class='labelObject'></label>")+"</div>"+ (lv_elm != ""?"<div class='col-sm-10'>":"") + lv_elm + (lv_elm != ""?"</div>":"") ) );

      //agrega el readonly a los elementos
      if(lp_element.data("code") == "BUTTON"){ lp_element.find(".inputObject").addClass("btn-disabled");return; }
      lp_element.find(".inputObject").attr("disabled", "");
    }
    //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    // click sobre elemento del formulario
    $("#<?= $lv_sec; ?> .tmssFormLayout").on("click", ".tmssElement", function(e){
        $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement.active").removeClass("active");
      	$(this).toggleClass("active");
        if($(this).hasClass("active")){
          <?= $lv_sec; ?>_showAttributes( $(this) );
        }else{
          <?= $lv_sec; ?>_hideAttributes( $(this) );
        }

        //evita que los elemntos superiores se enteren del evento
        e.stopPropagation();
      });
  </script>
  
  <?php if( $vew_actcod != '03' && $vew_actcod != '00' ){ ?>
  <script>
    tmssLoadScript("jquery-ui", function(){
      
      $("#<?= $lv_sec; ?> .tmssFormLayout").sortable({
        containment: ".tmssFormLayout",
        scroll: true,
        cursorAt: {top:20},
        helper: function(event, ui){ return $("#<?= $lv_sec; ?> .tmssElementContainer .tmssElement[data-code="+ui.data("code")+"]").clone().css("opacity","0.9"); },
        start: function(event, ui){ 
          //acomoda el placeholder del elemento
          <?= $lv_sec; ?>_addHighlight( ui.placeholder );
        	ui.placeholder.css({"visibility": "visible", 
                              "opacity": "0.9", 
                              "display":"flex"});
          ui.placeholder.height(ui.helper.height());
        },
        stop: function(event, ui){  
          if( ui.helper != null && ui.helper != undefined ){ ui.helper.remove(); }
          
          if(!ui.item.hasClass("tmssElementDraggable")){

            <?= $lv_sec; ?>_addHighlight( ui.item );
            <?= $lv_sec; ?>_showAttributes( ui.item );
          }
        }
      });
      
      $("#<?= $lv_sec; ?> .tmssElementContainer .tmssElement").draggable({
        connectToSortable:".tmssFormLayout", 
        helper: "clone"
      });
    });
    
    $("#<?= $lv_sec; ?> .tmssFormLayout").on("sortreceive", function(e, ui){ 
      // armo elemento
      var lv_element = $("<div class='tmssElement' data-code="+ui.item.data("code")+"></div>");
      <?= $lv_sec; ?>_addElement( lv_element );
    
      // recupera atributos de la definición del elemento
      var lv_elementAttr_arr = JSON.parse(gv_<?= $lv_sec; ?>_elmHtmlAttr[lv_element.data("code")]);

      // aplica atributos
      for (let lo_attr of Object.values(lv_elementAttr_arr)) {
        <?= $lv_sec; ?>_applyAttribute( lv_element, lo_attr );
      }
      
      $(this).children(".ui-draggable-dragging").replaceWith(lv_element); 
      <?= $lv_sec; ?>_addHighlight( lv_element );
      <?= $lv_sec; ?>_showAttributes( lv_element );
    });
  </script>
  <?php } ?>
  <script>
    // SERIALIZE FORM. Parsea los elementos y sus atributos
    // lp_includeDel: bool. Indica si se deben incluir los elementos eliminados.
    function <?= $lv_sec;?>_serializeForm(lp_includeDel){
      var lv_attribute_arr, lv_elementAttr_arr, lo_attrObject;
      var lv_element_arr = []; 
      
      //recorre cada elemento 
      $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement").each(function(i){ 
        //array de atributos del elemento
        lv_attribute_arr = [];
       // recupera atributos de la definición del elemento
        lv_elementAttr_arr = JSON.parse(gv_<?= $lv_sec; ?>_elmHtmlAttr[$(this).data("code")]);

        // guarda valores de los atributos
        for (let lo_attr of Object.values(lv_elementAttr_arr)) {
          
          lo_attrObject = $(this).find( lo_attr.obj == "LABEL" || $(this).find(".inputObject").length == 0 ? ".labelObject" : ".inputObject" );

          if((lo_attr.tgt == "class" || lo_attr.tgt == "style") && ($(this).data("code") == "CHECKBOX" || $(this).data("code") == "BUTTON")){
            lo_attrObject = lo_attrObject.parents("div").eq(0);
          }

          lv_attribute_arr.push( {"sysdocfrmfldatrcod": lo_attr.code,
                                  "sysdocfrmfldatrval": ( lo_attrObject.data( lo_attr.code ) != undefined ? lo_attrObject.data( lo_attr.code ).
                                                         replace(/'/g, '"') : "" ) } );
        }

        //arma el json del elemento
        lv_element_arr.push({	"sysdocfrmfldcod": ($(this).attr("id")!=undefined ? $(this).attr("id") : "" ), 
															"sysdocfrmfldcodext": $(this).find(".inputObject").attr("name"), 
															"sysfldinptyp" : $(this).data("code"), 
															"sysdocfrmfldord": i, 
															"sysdocfrmfldatr" : lv_attribute_arr, "deleted" : ""  } );
        //lv_element_arr.push( {"sysdocfrmfldcod": ( $(this).attr("id") != undefined ? $(this).attr("id") : "<?= $lv_sec; ?>_"+i ), "sysfldinptyp" : $(this).data("code"), "sysdocfrmfldord": i, "sysdocfrmfldatr" : lv_attribute_arr, "deleted" : ""  } );
      });

      if(lp_includeDel){
        //recorre los elementos eliminados
        for(let i=0; i < gv_<?= $lv_sec; ?>_delElm.length; i++){
          lv_element_arr.push( {"sysdocfrmfldcod" : gv_<?= $lv_sec; ?>_delElm[i], 
                              "sysfldinptyp" : "", 
                              "sysdocfrmfldord": "", 
                              "sysdocfrmfldatr" : "", 
                              "deleted" : "X" } );
        }
			}
      //convierte el array de elementos en texto y lo guarda en un elemento hidden
      $("#<?= $lv_sec; ?> #sysdocfrmfld").val( JSON.stringify( lv_element_arr ) );
    }
    
    function <?= $lv_sec; ?>_fncext( lp_prm ){
      
      //accion de grabado
      if( lp_prm["action"] == "00" ){
        // validación de ids duplicados
        var lv_name_arr = [];
        $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement").removeClass("error");
        $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement [name]").each(function(){
          if(lv_name_arr.indexOf($(this).attr("name")) != -1 ){
            $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement:has([name="+$(this).attr("name")+"])").addClass("error");
          }else{
            lv_name_arr.push($(this).attr("name"));
          }
        });	
        
        if($("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement.error").length > 0){ 
					toastr.warning("Hay elementos con IDs repetidos.");
          return false;
        }else{
          <?= $lv_sec;?>_serializeForm(true);
          
          //remueve el atributo requierd de los inputs del formulario
          $("#<?= $lv_sec; ?> .tmssFormLayout .tmssElement .inputObject").removeAttr("required");
      	}
    	}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section> 