<?php
	/* url del formulario */
  $lv_lnk = "?prg=grldoccnt&prm_grldoccntcod=".$vew_data->grldoccntcod."&prm_srcobjtyp=".$vew_data->srcobjtyp."&prm_srcobjcod=".$vew_data->srcobjcod."&prm_grldoccntobjtyp=".$vew_data->grldoccntobjtyp."&prm_grldoccntobjcod=".$vew_data->grldoccntobjcod."&prm_bcksec=".$vew_data->bcksec;

	/* campos requeridos */
	$vew_input->RequiredFields( array('sysdocclscodcnt','sysdocclstxtcnt','cnttxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->grldoccntcod;

	/* titulo */
	$lv_title = $vew_lang->contact;

	/* m�dulo y programa */
	$lv_mdlcod = explode('_',$vew_data->srcobjtyp)[0];
	$lv_prgcod = explode('_',$vew_data->srcobjtyp)[1];
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
	
	if($lv_dockey == ''){
    $vew_actocod_old = $vew_actcod;
    
    // si no está definido el dockey y está en modo edición, es una creación o modificación por JSON
    if($vew_data->readonly == 'false'){
      $vew_actcod = '01';
      $vew_readonly = false;
      $vew_tbl['new'] = array('per'=>false);
      $vew_tbl['modL'] = array('per'=>false);
      $vew_tbl['modR'] = array('per'=>false);
      $vew_tbl['cpy'] = array('per'=>false);
      $vew_dropdown = false; 
    }else{
    	$vew_tbl['clsR'] = array('acc'=>$lv_sec.'_close();');
    }
  }
	$vew_tbl['sveL'] = array('acc'=>$lv_sec.'_save();');
	$vew_tbl['sveR'] = array('acc'=>$lv_sec.'_save();');

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdocclscod; ?>">
		<input type="hidden" id="srcobjtyp" name="srcobjtyp" value="<?= $vew_data->srcobjtyp; ?>">
		<input type="hidden" id="srcobjcod" name="srcobjcod" value="<?= $vew_data->srcobjcod; ?>">
		<input type="hidden" id="srcobjtxt" name="srcobjtxt" value="<?= strtoupper($vew_data->srcobjtxt); ?>">
    <input type="hidden" id="grldoccntobjtyp" name="grldoccntobjtyp" value="<?= $vew_data->grldoccntobjtyp; ?>">
		<input type="hidden" id="grldoccntobjcod" name="grldoccntobjcod" value="<?= $vew_data->grldoccntobjcod; ?>">
		<input type="hidden" id="grldoccntobjtxt" name="grldoccntobjtxt" value="<?= $vew_data->grldoccntobjtxt; ?>">
		<input type="hidden" id="mstcntcod" name="mstcntcod" value="<?= $vew_doc->getTagValue($vew_data->grldoccntatr, 'mstcntcod'); ?>">
		<input type="hidden" id="adrnum" name="adrnum" value="<?= $vew_data->adrnum; ?>">
		<input type="hidden" id="onetme" name="onetme" value="<?= ( $vew_data->buysuponetme != '' ? $vew_data->buysuponetme : ( $vew_data->slscusonetme != '' ? $vew_data->slscusonetme :  ( $vew_data->onetme != '' ? '1' : '' )  )); ?>">
		<input type="hidden" id="svemst" name="svemst" value="">

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->grldoccntcod; ?><?= gethtml('grldoccntcod','hidden', $vew_data->grldoccntcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon"><?= ucfirst(strtolower(  $vew_data->multiplecls != '' ? 'TODOS' : $vew_data->sysdoccls->sysdocclstxt  )); ?></span>
                    <?= gethtml('sysdocclscodcnt', 'hidden', $vew_data->multiplecls != '' ? $vew_data->multiplecls : $vew_data->sysdoccls->sysdocclscod ); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div id="rowdatgrl">
                    <?php
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('grldoccntobjtxt', 'doccmt1x50', utf8_decode($vew_data->grldoccntobjtxt), $lv_default) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                    ?>
                  </div>
                </div>
              </div>
						</div>
            <div class="col-md-6 pull-right"><?php include('grldattax.frm'); ?></div>
          </div> <!-- row -->
          <div class="row">
            <div class="col-md-6 pull-left"><?php include('grldatadr.frm'); ?></div>
            <div class="col-md-6 pull-right"><?php include('grldatadrcnt.frm'); ?></div>
					</div> <!-- row -->
				</div> <!-- tabpanel -->
      </div> <!-- tab-content -->
    </div> <!-- container-fluid -->

  </form>
	<script>

		function <?= $lv_sec; ?>_close(){
      // si no se está visualizando desde el JSON, recarga la grilla
      <?php if($vew_data->bcksec!='' && $lv_dockey != ''){ ?>if(typeof window["<?=$vew_data->bcksec;?>_CntRefresh"]!="undefined"){ <?=$vew_data->bcksec;?>_CntRefresh(); }<?php } ?>
			tmssTabSecCls( $("#<?= $lv_sec; ?>") );
		}
    
    function <?= $lv_sec; ?>_save(){
      // si no se está visualizando desde el JSON, recarga la grilla
      if($("#<?= $lv_sec; ?> #onetme").val() != 1){
        BootstrapDialog.show({
          //size: BootstrapDialog.SIZE_WIDE,
          title: "Grabar contacto",
          message: "&iquest;Desea grabar este contacto en ["+$("#<?= $lv_sec; ?> #srcobjtxt").val()+"]?",
          closable: false,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default pull-left", action: function(dialogItself){ dialogItself.close(); } },
            				{ label: "<?= $vew_lang->no; ?>", cssClass: "btn-danger", action: function(dialogItself){ 
            					<?= $lv_sec; ?>_fnc({action: "00"});
            					dialogItself.close();  
          					}},
                    {	label: "<?= $vew_lang->yes; ?>", cssClass: "btn-success",	action: function(dialogItself){
                      $("#<?= $lv_sec; ?> #svemst").val("X");
											<?= $lv_sec; ?>_fnc({action: "00"});
                      dialogItself.close();
                    }}]
        });
      }else{
        <?= $lv_sec; ?>_fnc({action: "00"});
      }
		}
    
	</script>
  <script>
  // form submit externo
  function <?= $lv_sec; ?>_fncext(lp_prm){
		// si se está visualizando desde el JSON, al grabar actualizo la grilla y al cancelar cierro la sección
    <?php if($lv_dockey == '' && $vew_data->readonly == 'false'){ ?>
      // se sobrescribe la función fncbckext para que no reemplace el contenido de la vista al realizar la acción como si fuera una vista normal
      function <?= $lv_sec; ?>_fncbckext(lp_prm){}
      
			// al grabar
			if ( lp_prm["action"]=="00" ) {
        
        if(tmssCheckRequiredFields("#<?= $lv_sec; ?>_frm")){
        	// serializa el formulario y después lo modifica para que el JSON quede 
          //{clave:valor, clave:valor, etc} en lugar de {name: clave, value: valor}, {name: clave, value: valor}, etc
          var lv_unindexed = $("#<?= $lv_sec; ?>_frm").serializeArray();
          var lv_indexed = {};

          $.map(lv_unindexed, function(n, i){
            lv_indexed[n['name']] = n['value'];
          });

          // si es una modificación, solo actualizo el nombre del contacto y el JSON en la grilla
          if($("#<?= $lv_sec; ?> #grldoccntcod").val() != ""){
            /*$("#<?= $vew_data->bcksec; ?> #grldoccnttbl tr[data-id='"+$("#<?= $lv_sec; ?> #grldoccntcod").val()+"'] .grldoccntfrm").val(JSON.stringify(lv_indexed));
            $("#<?= $vew_data->bcksec; ?> #grldoccnttbl tr[data-id='"+$("#<?= $lv_sec; ?> #grldoccntcod").val()+"'] .grldoccntobjtxt").text($("#<?= $lv_sec; ?> #grldoccntobjtxt").val().toUpperCase());*/
          }else{
          	// creo una fila en la grilla por cada clase de documento que tenga el contacto
        		// (generalmente una, salvo que se esté creando un contacto de un eventual, que se utilizará para todos los interlocutores)
            var lv_sysdoccls = $("#<?= $lv_sec; ?> #sysdocclscodcnt").val().split(";");
            var lv_buffer = "";
            for( var i=0; i<lv_sysdoccls.length; i++){
              lv_indexed['sysdocclscodcnt'] = lv_sysdoccls[i];
              <?php 
								if( is_array($vew_data->sysdoccls) ){
                	foreach($vew_data->sysdoccls as $lv_row){
                    ?>
                      if(lv_sysdoccls[i] == "<?= $lv_row['sysdocclscodcnt']; ?>"){
                        lv_indexed['sysdocclstxtcnt'] = "<?= $lv_row['sysdocclstxtcnt']; ?>";
                      }
              			<?php
                  }
                }else{
                  ?>
              			lv_indexed['sysdocclstxtcnt'] = "<?= $vew_data->sysdoccls->sysdocclstxt; ?>";
                  <?php
                }
              ?>
  							
            	lv_buffer+="<tr data-id=''>"
                      +"<td width='60' style='vertical-align: middle;'><img src='/library/images/icon_profile.png' class='img-responsive img-circle img-thumbnail'></td>"
                      +"<td style='vertical-align: middle;' data-cntcod='1'><a href='#' name='grldoccnttxt' data-id=''><h5><strong class='grldoccntobjtxt'>"+$("#<?= $lv_sec; ?> #grldoccntobjtxt:not([type=hidden])").val().toUpperCase()+"</strong><br><small>"+lv_indexed['sysdocclstxtcnt'].toUpperCase()+"</small></h5></a></td>"
                      +"<td style='vertical-align: middle;' class='hidden-xs'><a href='#'>"+($("#<?= $lv_sec; ?> #adreml").val() != undefined ? $("#<?= $lv_sec; ?> #adreml").val() : "")+"</a></td>"
                      +"<td style='vertical-align: middle;' class='hidden-xs hidden-sm'><a href='#''>"+($("#<?= $lv_sec; ?> #adrphn001").val() != undefined ? $("#<?= $lv_sec; ?> #adrphn001").val() : "")+"</a></td>"
                      +"<td style='vertical-align: middle;' class='hidden-xs hidden-sm hidden-md'><a href='#'>"+($("#<?= $lv_sec; ?> #adrmblphn").val() != undefined ? $("#<?= $lv_sec; ?> #adrmblphn").val() : "")+"</a></td>"
                      +"<td class='hidden'><input type='hidden' class='grldoccntfrm' name='grldoccntfrm' value='"+JSON.stringify(lv_indexed)+"'></td>"

              <?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && !$vew_readonly ) { ?> 
                lv_buffer += "<td width='60' style='vertical-align: middle;' class='text-center'><a href='#' id='grldoccntdellnk' class='btn btn-danger' title='<?= $vew_lang->delete; ?>'><span class='fas fa-trash-alt'></span></a></td>";
              <?php } ?>
              lv_buffer += "</tr>"; 
            }
            
            // si estaba en una modificación, reemplazo la fila existente
            <?php if($vew_actocod_old=='03' || $vew_actocod_old=='02'){ ?>
            	$($("#<?= $vew_data->bcksec; ?> #grldoccnttbl tbody tr")[<?= $vew_data->pos; ?>]).replaceWith( lv_buffer );
            // en creación agrego una fila nueva
            <?php }else{ ?>
            	$("#<?= $vew_data->bcksec; ?> #grldoccnttbl tbody").append( lv_buffer );
            <?php } ?>
            // es necesario sacar los eventos antes de volver a hacer el attach (botones borrar en la grilla)
            $("#<?= $vew_data->bcksec; ?> #grldoccnttbl").find("a").unbind("click");
            <?= $vew_data->bcksec ?>_attachEvents();
          }
          $("#<?= $lv_sec; ?> #btncls").trigger("click");
        }
      }else if(lp_prm["action"]=="98"){
        tmssTabSecCls( $("#<?= $lv_sec; ?>") );
      }
    <?php }else{ ?>
      //si se cargó el documento de la base de datos y no desde el JSON, funciona como una vista normal
      function <?= $lv_sec; ?>_fncbckext(lp_prm){
        if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
          if (gv_<?= $lv_sec; ?>_last_action=="04") {
            <?= $lv_sec; ?>_close();
            $("#<?= $vew_data->bcksec; ?> #grldoccnttbl tbody tr[data-id='<?= $lv_dockey ?>']").remove();
          } else if ( typeof data == "string" && data.substring(0,10)=="/*script*/" ) {
            eval( data );
          } else {
            $("#<?= $lv_sec; ?>").replaceWith( data );
          }
        }
      }
    <?php } ?>
    }    
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>