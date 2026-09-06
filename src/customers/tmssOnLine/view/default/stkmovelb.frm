<?php	
	// url del formulario
  $lv_lnk = '?prg=stkmovelb&prm_stkmovelbcod='.$vew_data->stkmovelbcod;

	// campos requeridos
	$lv_reqfld = array('stkmovelbdte', 'strloccod', 'strloctxt', 'matcod', 'mattxt', 'matqty', 'matuntcod', 'docsts');
	$vew_input->RequiredFields( $lv_reqfld );

	// clave del documento
	$lv_dockey = $vew_data->stkmovelbcod; 

	// titulo
	$lv_title = $vew_lang->elaboration;

	// modulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'ELB';
	$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
	
	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	// valores X default
	if ($vew_data->stkmovelbcod=='') {
		$vew_data->stkmovelbdte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}
	
	$lv_matbchdet = ($vew_readonly?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matbchdet'));
	$lv_matbchdetspl = ($vew_readonly?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matbchdetspl'));
	$lv_matstkexc = ($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matstkexc'));
	$lv_matstkmis = ($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matstkmis'));
	$lv_matstkadd = ($vew_readonly?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matstkadd'));
	$lv_matlstdel = ($vew_readonly?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matlstdel'));

	$lv_matbchcre = (is_string($vew_data->invatr) && $vew_data->invatr != '') ? $vew_doc->getTagValue($vew_data->invatr,'matbchcre') : '';
	$lv_matsercre = (is_string($vew_data->invatr) && $vew_data->invatr != '') ? $vew_doc->getTagValue($vew_data->invatr,'matsercre') : '';
	$lv_stkmatbchman = (is_string($vew_data->invatr) && $vew_data->invatr != '') ? $vew_doc->getTagValue($vew_data->invatr,'stkmatbchman') : '';
	$lv_stkmatserman = (is_string($vew_data->invatr) && $vew_data->invatr != '') ? $vew_doc->getTagValue($vew_data->invatr,'stkmatserman') : '';

	// Botones por vista
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C','acc'=>'' );
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C','acc'=>'' );
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['del'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <style>
    .ht_nestingButton {  transform: scale(1.6); transform-origin: center; cursor: pointer !important; margin-right: 6px; }
  </style>
  <?php include("grldocfrmtlb.frm");?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod',	'hidden', ''); ?>
		<textarea class="d-none" id="stkmovelbmat" name="stkmovelbmat"></textarea>
    <input type="hidden" id="tmpmatbchcod" 		name="tmpmatbchcod" 		data-fldnme="matbchcod" 		value="">
    <input type="hidden" id="tmpmatbchcodext" name="tmpmatbchcodext" 	data-fldnme="matbchcodext" 	value="">
    <input type="hidden" id="tmpmatbchduedte" name="tmpmatbchduedte" 	data-fldnme="matbchduedte" 	value="">
    <input type="hidden" id="tmpmatsercod" 		name="tmpmatsercod" 		data-fldnme="matsercod" 		value="">
    <input type="hidden" id="tmpmatsercodext" name="tmpmatsercodext" 	data-fldnme="matsercodext" 	value="">
		<input type="hidden" id="tmpmatserduedte" name="tmpmatserduedte" 	data-fldnme="matserduedte" 	value="">
    <textarea class="d-none" id="matsercodextlst" name="matsercodextlst"></textarea>
		<input type="hidden" id="matbchcod" name="matbchcod" 	data-fldnme="matbchcod" 	value="">
    <input type="hidden" id="matbchduedte" name="matbchduedte" 	data-fldnme="matbchduedte" 	value="">
    <input type="hidden" id="matbchcodext" name="matbchcodext" 	data-fldnme="matbchcodext" 	value="">
    <?= gethtml('srccntcod',	'hidden', $vew_data->srccntcod ); ?>
    <?= gethtml('stkmovdoccod',	'hidden', $vew_data->stkmovdoccod ); ?>
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<?php if($vew_data->stkmovdoccod!='' && $vew_data->docsts=='C'){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->notification; ?></a></li><?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmovelbcod; ?><?= gethtml('stkmovelbcod', 'hidden', $vew_data->stkmovelbcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">
                    	<span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    	<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <!-- ELABORACION -->
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210,	array('label'=>$vew_lang->storelocation, 
                                                    'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                      array('input'=>gethtml('strloctxt', 'typeahead', $vew_data->strloctxt, $lv_default) ))
                                                     ));
                  	echo gethtml('strloccod', 'hidden', $vew_data->strloccod);
                   	echo vew_boot($lv_col210, array("label"=>$vew_lang->date, 	"input"=>gethtml("stkmovelbdte",		"docdte",		$vew_data->stkmovelbdte,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	
                                                    'input1'=>gethtml('docsts','stkdocsts',$vew_data->docsts, $lv_default)
                                                    ));
                  ?>                  
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->data; ?>
                  </div>
                </div>
                <!-- DATOS -->
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->MATERIALSLIST, 
                                  'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                    array('input'=>gethtml('matlsttxt', 'typeahead', $vew_data->matlsttxt, $lv_default) ))
                                  ));
                  	echo gethtml('matlstcod', 'hidden', $vew_data->matlstcod);
                   	echo vew_boot($lv_col210,array('label'=>$vew_lang->MATERIAL,'input'=>gethtml('mattxt', 'mattxt', $vew_data->mattxt, $lv_always_disabled)));
                  	echo gethtml('matcod', 'hidden', $vew_data->matcod);

                    echo vew_boot(array($lv_col273, $lv_colxs1244), array('label'=>$vew_lang->quantity, 
                                                    'input1'=>gethtml('matqty',	'docnum0600',	$vew_data->matqty,	$lv_default),
                                                    'input2'=>vew_boot(array('style'=>'search', 'readonly'=>true), 
                                                                       array('input'=>gethtml('matuntcod', 'matuntcod', $vew_data->matuntcod, $lv_always_disabled) ))
                                                    ));
                  ?>                  
                </div>
              </div>              
						</div>
					</div>
          <div class="card tmss-hot-ttl">
            <div class="card-header">
            	<div class="card-title">
                <?= $vew_lang->COMPOSITION ;?>       
              	<?php if(!$vew_readonly){ ?>    
              			<a href="#" id="<?= $lv_sec; ?>_btnDeleteSelected" class="card-icon text-center tmssHiddeOnRead d-none" title="Eliminar seleccionados" onmousedown="<?= $lv_sec; ?>_deleteSelectedRows(); return false;">
                    <i class="fas fa-trash"></i>
                  </a>
               	<?php } ?>
              	<a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnstkchk" title="<?= $vew_lang->availabilitycheck; ?>"><i class="fas fa-sliders-h"></i></a>
                <?php if($lv_matbchdet!='') { ?><a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnmatbchdet" title="<?= $vew_lang->batchdetermination; ?>"><i class="fas fa-qrcode"></i></a> <?php } ?>
                <a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnupdlst" title="<?= $vew_lang->listrefresh; ?>"><i class="fas fa-sync"></i></a>
              </div>
            </div>
          </div>
					<div id="stkmovelbmathot" name="stkmovelbmathot"></div>
				</div> <!-- fin tab001 -->
				<!-- MATERIALES -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div id="stkmovelbntfdiv"></div>
				</div>
				
			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->
  </form>	
  <script>
    function <?= $lv_sec; ?>_deleteSelectedRows() {
      var lv_btn = document.getElementById("<?= $lv_sec; ?>_btnDeleteSelected");
      if(lv_btn && lv_btn.classList.contains("disabled")) return;
      var hot = <?= $lv_sec; ?>_hotmat;
      var data = hot.getSourceData();
      var lv_hotsel = hot.getSelected();
      if(lv_hotsel) {
        lv_hotsel.forEach(([startRow, startCol, endRow, endCol]) => {
            for (var i = endRow; i >= startRow; i--) {
              if (data[i] && "matcod" in data[i]) {
                <?= $lv_sec; ?>_hotmat.alter("remove_row", i);
              }
            }
        });
        <?= $lv_sec; ?>_hotmat.render();
      }
    }
  </script>
	<script>
    //SI ESTA CONTABILIZADO SE MUESTRA EN READONLY
		<?php if($vew_data->stkmovdoccod!='' && $vew_data->docsts=='C'){ ?>
		tmssCallProcess("?prg=stkmovelb&act=10", [{name:"stkmovelbcod",value:"<?= $vew_data->stkmovelbcod; ?>"}], function(data){
			$("#stkmovelbntfdiv").replaceWith(data);
      $("#<?= $lv_sec; ?> #matbchcodext").prop("readonly", true);
      $("#<?= $lv_sec; ?> #matbchduedte").prop("readonly", true);
		});
		<?php } ?>
    //Actualizar la lista de materiales y sus cantidades requeridas 
		function <?= $lv_sec; ?>_refreshList() {
			if( <?= $lv_sec; ?>_hotmat!=undefined ) {
				var lv_matcod = $("#<?= $lv_sec; ?> #matcod").prop("value");
        var lv_matbchcodext = <?= $lv_sec; ?>_hotmat.getDataAtCol(8);
				var lv_matqty = $("#<?= $lv_sec; ?> #matqty").prop("value");
				var lv_matuntcod = $("#<?= $lv_sec; ?> #matuntcod").prop("value");
				var lv_strloccod = $("#<?= $lv_sec; ?> #strloccod").prop("value");
        var lv_matlstcod = $("#<?= $lv_sec; ?> #matlstcod").prop("value");
				if(lv_matcod==""){ return false; }
				if(parseFloat(lv_matqty)==0){ return false; }
				if(lv_matuntcod==""){ return false; }
				if(lv_strloccod==""){ return false; }
				tmssCallProcess("?prg=stkmovelb&act=28", [{name:"matcod",value:lv_matcod},{name:"matlstcod",value:lv_matlstcod},{name:"matqty",value:lv_matqty},{name:"matuntcod",value:lv_matuntcod},{name:"strloccod",value:lv_strloccod},{name:"matbchcodext",value:lv_matbchcodext}], function(data){          
          var lv_chghot = true;
          var lv_new_dat = [];
          if(lv_chghot){
            //Si se hicieron modificaciones entonces elimino las filas que estan actualmente en la handson para empezar de 0
             var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
              if(lv_dat!== undefined){
                for (var i = 0; i < lv_dat.length; i++) {
                  if (lv_dat[i]["stkmovelbmatcod"] && lv_dat[i]["stkmovelbmatcod"] !== undefined) {
                    lv_dat[i]["deleted"] = "X";
                    <?= $lv_sec; ?>_hotmatdel.push(lv_dat[i]);
                  }
                  // También registrar los hijos para borrarse en el servidor
                  if (Array.isArray(lv_dat[i]["__children"])) {
                    lv_dat[i]["__children"].forEach(function(lv_child) {
                      if (lv_child["stkmovelbmatcod"] && lv_child["stkmovelbmatcod"] !== undefined) {
                        lv_child["deleted"] = "X";
                        <?= $lv_sec; ?>_hotmatdel.push(lv_child);
                      }
                    });
                  }
                }
            	}
          }
					for (var i=0; i<data.length; i++) {
						var lv_matcod = data[i]["matcod"];
						var lv_mattxt = data[i]["mattxt"];
						var lv_bse = data[i]["matqtybse"];
						var lv_stk = data[i]["matqtystk"];
						var lv_stkrel = data[i]["matstkrel"];
						var lv_tot = lv_matqty * lv_bse;
						var lv_dif = ( lv_stkrel!="" ? ( lv_stk < lv_tot ? lv_stk - lv_tot : 0 ) : 0 );  
            //Si hubo un cambio en la lista de materiales que modifica la cantidad de materiales involucrados se reinicia la handson.
            if(lv_chghot){
            	if(<?= ($vew_readonly?1:0); ?>==0 ) {
                lv_new_dat.push({
                   "matcod": lv_matcod,
                   "mattxt": lv_mattxt,
                   "matqtybse": lv_bse,
                   "matqtystk": lv_stk,
                   "matqtytot": lv_tot,
                   "matqtydif": lv_dif,
                   "matusepck": 1,
                   "matuntcod": data[i]["matuntcod"],
                   "matusebch": data[i]["matusebch"],
                   "matuseser": data[i]["matuseser"],
                   "__children": []
                });
              }
            }else{
              var lv_rowtot = lv_tot;
          	// actualizo: denominacion, cantidad de lista de materiales, stock
              for (var x=0; x<lo_hot.length; x++) {
                if( lo_hot.length!=0 ) {
                  if( (lo_hot[x]["matcod"]!=undefined ? lo_hot[x]["matcod"] : 0)==lv_matcod && lo_hot[x]?.__children) {
                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(x, "matqtybse", lv_bse );
                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(x, "matqtystk", lv_stk );
                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(x, "matqtytot",lv_tot);
                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(x, "matqtydif", lv_dif );
                  }
                }
              }
            }
					}
          if (lv_chghot) {
            <?= $lv_sec; ?>_hotmat.loadData(lv_new_dat);
            if (<?=($lv_matstkadd != '')?'true':'false'?>) {
               <?=$lv_sec;?>_addBlankRow();
            }
          }
					<?= $lv_sec; ?>_hotmat.render();
				});
			}
		}
		
		// REFRESH LIST
		$("#<?= $lv_sec; ?> #btnupdlst").on("click",function(e){ e.preventDefault();                                                            
			var lv_matcod = $("#<?= $lv_sec; ?> #matcod").prop("value");
      var lv_matbchcodext = <?= $lv_sec; ?>_hotmat.getDataAtCol(8);
			var lv_matqty = $("#<?= $lv_sec; ?> #matqty").prop("value");
			var lv_matuntcod = $("#<?= $lv_sec; ?> #matuntcod").prop("value");
			var lv_strloccod = $("#<?= $lv_sec; ?> #strloccod").prop("value");
			if(lv_matcod==""){ toastr.warning("Debe indicar un material."); return false; }
      if(parseFloat(lv_matqty)==0){ toastr.warning("Debe indicar una cantidad."); return false; }
			if(lv_matuntcod==""){ toastr.warning("No se pudo determinar la unidad de medida del material."); return false; }
			if(lv_strloccod==""){ toastr.warning("Debe indicar un almacen de elaboracion."); return false; }
			<?= $lv_sec; ?>_refreshList();
		});
    
		//MATQTY REFRESH LIST
    $("#<?= $lv_sec; ?> #matqty").on("change",function(e){$("#<?= $lv_sec; ?> #btnupdlst").trigger("click")});
    
    // MATLSTTXT
		var lo_get = {"fldsec" : "<?=$lv_sec;?>", "fldasg":{ "matlstcod":"matlstcod", "matlsttxt":"matlsttxt", "matuntcod":"matuntcod","mattxt":"mattxt","matcod":"matcod" }, "fldflt":{"m.docsts":"A"},"typeahead":true};
  	tmssTypeahead($("#<?= $lv_sec; ?> #matlsttxt"), "stkmatlst", lo_get,{"afterAssign" :  lo_afterAssign=function(){if($("#<?= $lv_sec;?> #matqty").prop("value")!=""){$("#<?= $lv_sec; ?> #btnupdlst").trigger("click")}}});
    
		// ORIGEN de CONSUMO (almacen)
		var lo_get = {"fldsec" : "<?=$lv_sec;?>", "fldasg":{ "strloccod":"strloccod", "strloctxt":"strloctxt"}, "fldflt":{"s.docsts":"A"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #strloctxt"), "stkstrloc", lo_get);
    
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			var lo_dat = <?=$lv_sec;?>_hotmat.getSourceData();                                                         
     if(<?=$lv_sec?>_checkPicking(lo_dat)){return false}
			tmssCallProcess("?prg=stkmovelb&act=10", [{name:"stkmovelbcod",value:"<?= $vew_data->stkmovelbcod; ?>"},{name:"frmsec",value:"<?= $lv_sec; ?>"}], function(data){
				BootstrapDialog.show({
					title: "Contabilizar", 
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					closable: true,
          onHidden: function(dialog){
        		var lv_stkmovdoccod = dialog.getModalBody().find("#stkmovdoccod").val();
            $("#<?= $lv_sec; ?> #stkmovdoccod").val(lv_stkmovdoccod);
          },
					buttons:[ {label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogRef){dialogRef.close();} }, 
										{label: "<?= $vew_lang->accounting; ?>", cssClass: "btn-success", action: function(dialogRef){
                      // El handler de submit puede setear este flag si pasa validaciones
                      let lv_formOk = true;
                      // Sobreescribimos temporalmente el handler para capturar el resultado
                      let lv_form = dialogRef.getModalBody().find("form:first");
                      // Escuchamos si el submit fue bloqueado (return false lo cancela)
                      lv_form.off("submit.validation").on("submit.validation", function(e){
                          // Si llegamos aquí sin preventDefault previo, está ok
                          lv_formOk = true;
                      });
                      // Disparamos el submit
                      let lv_result = lv_form.triggerHandler("submit");
                      // triggerHandler devuelve false si algún handler hizo return false
                      if(lv_result === false){
                          return false; // Validación falló, no cerramos ni continuamos
                      }
                      var matbchcod = dialogRef.getModalBody().find("#matbchcod").val();
                      var matbchcodext = dialogRef.getModalBody().find("#matbchcodext").val();
											var matbchduedte = dialogRef.getModalBody().find("#matbchduedte").val();
                      $("#<?=$lv_sec;?> #matbchcod").prop("value",matbchcod);
                      $("#<?=$lv_sec;?> #matbchcodext").prop("value",matbchcodext);
                      $("#<?=$lv_sec;?> #matbchduedte").prop("value",matbchduedte);
                      var matsercodextlst = dialogRef.getModalBody().find("#matsercodextlst").val();
                      $("#<?= $lv_sec; ?> #matsercodextlst").prop("value", matsercodextlst);
                      <?=$lv_sec; ?>_fnc({action:"09"});
              				dialogRef.close();
										}
									}]
					});
			});
		});
		
	</script>
	<script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
    //Funcion para chequear el consumido
    function <?=$lv_sec;?>_checkPicking(lo_dat){
      var error = false;
      var lv_sums = {};
      var lv_totals = {};
      var lo_flat = <?=$lv_sec;?>_hotmat.getData();
      var numRows = <?=$lv_sec;?>_hotmat.countRows();
      for(var i=0; i<numRows; i++){
          var cod = <?=$lv_sec;?>_hotmat.getDataAtRowProp(i, "matcod");
          var blank = <?=$lv_sec;?>_hotmat.getDataAtRowProp(i, "blank");
          if(blank !== "X" && cod){
              lv_sums[cod] = (lv_sums[cod] || 0) + (parseFloat(<?=$lv_sec;?>_hotmat.getDataAtRowProp(i, "matqtypck"))||0);
              var tot = parseFloat(<?=$lv_sec;?>_hotmat.getDataAtRowProp(i, "matqtytot"));
              if(tot) { lv_totals[cod] = tot; }
          }
      }
      for(var i=0; i<numRows; i++){
          var cod = <?=$lv_sec;?>_hotmat.getDataAtRowProp(i, "matcod");
          var blank = <?=$lv_sec;?>_hotmat.getDataAtRowProp(i, "blank");
          if(blank !== "X" && cod){
              var lv_tot = lv_totals[cod] || 0;
              var lv_pck = lv_sums[cod] || 0;
              if (lv_tot != lv_pck) {
                  var lv_matstkmis = <?= ($lv_matstkmis == '' || $lv_matstkmis == null)?'100':$lv_matstkmis; ?>;
                  var lv_matstkexc = <?= ($lv_matstkexc == '' || $lv_matstkexc == null)?'100':$lv_matstkexc; ?>;
                  var lv_mis = Number(lv_matstkmis) / 100;
                  var lv_exc = Number(lv_matstkexc) / 100;
                  var lv_missed = lv_tot > lv_pck;
                  var lv_excess = lv_tot < lv_pck;
                  var lv_per = lv_tot * (lv_excess ? lv_exc : -lv_mis)
                  var lv_lim = Math.round(lv_tot + lv_per);
                  if ((lv_missed && lv_lim > lv_pck && lv_mis!=1) || (lv_excess && lv_lim < lv_pck && lv_exc!=1)) {
                    <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matqtypck"), "valid", false);
                    error = true;
                  }
              }
          }
      }
      if(error){toastr.warning("Las cantidades no deben excederse de un "+lv_matstkexc+"%. Ni deben faltar en un "+lv_matstkmis+"%");}
      <?=$lv_sec;?>_hotmat.render();
      return error;
    }
    //Funcion colapsar para la handsontable
		function <?=$lv_sec;?>_collapseAll(){
        plugin = <?=$lv_sec;?>_hotmat.getPlugin("nestedRows");
        plugin.collapsingUI.collapseAll();
    }
    function <?=$lv_sec;?>_addBlankRow(){
    	  var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
        var lv_newDat = lv_dat.filter(row => row.__children);
				lv_newDat.push({"__children":[],"blank":"X"});
        <?= $lv_sec; ?>_hotmat.loadData(lv_newDat);
        <?= $lv_sec; ?>_hotmat.render();
      }

    //Agregar una fila hija con base y req oculto.
    function <?= $lv_sec; ?>_addChildRow(row){
        var lv_dat = <?=$lv_sec;?>_hotmat.getSourceData();
        var lv_matcod = <?=$lv_sec;?>_hotmat.getDataAtRowProp(row,"matcod");
        var lv_newdat = [];
        
        // Deep clone roots to break Handsontable caching and prevent ghost nodes
        lv_dat.forEach(r => {
           if (!lv_newdat.find(x => x.matcod === r.matcod)) {
               lv_newdat.push(JSON.parse(JSON.stringify(r))); 
           }
        });
        
        var lv_prnt = lv_newdat.find(r => r.matcod === lv_matcod);
        if (!lv_prnt) return;
        
        if (!lv_prnt.__children) { lv_prnt.__children = []; }
        var lv_clone = {...lv_prnt};
        lv_clone.stkmovelbmatcod = "";
        lv_clone.matbchcodext = "";
        lv_clone.matbchcod = "";
        lv_clone.matsercodext = "";
        lv_clone.matsercod = "";
        lv_clone.matqtypck = "";
        lv_clone.matusepck = 1;
        lv_clone.matqtybse = "";
        lv_clone.matqtytot = "";
        lv_clone.matqtybsehid = "";
        delete lv_clone.__children;
        
        lv_prnt.__children.push(lv_clone);
        
        <?= $lv_sec; ?>_hotmat.loadData(lv_newdat);
        <?= $lv_sec; ?>_hotmat.render();
        
        // Seleccionar primer campo editable del hijo recien agregado
        setTimeout(function(){
          var lv_totalRows = <?= $lv_sec; ?>_hotmat.countRows();
          for(var r = lv_totalRows - 1; r >= 0; r--){
            var lv_cod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(r, "matcod");
            var lv_pck = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(r, "matqtypck");
            if(lv_cod === lv_matcod && (lv_pck === "" || lv_pck === null || lv_pck === undefined)){
              <?= $lv_sec; ?>_hotmat.selectCell(r, <?= $lv_sec; ?>_hotmat.propToCol("matqtypck"));
              break;
            }
          }
        }, 150);
    }
    var lv_prntnum = 0;
    var lv_matcod = [];
		var <?= $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (<?= $lv_sec; ?>_hotmat!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_phsrow = instance.toPhysicalRow(row);
				// sujeto a lote-serie
        var lv_matusebch = (<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matusebch")=="1"?true:false);
				var lv_matuseser = (<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matuseser")=="1"?true:false);
        var lv_matusepck = ((<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matusepck")??"1")=="1"?true:false);

        var lv_matbchcre = <?= (strtoupper($lv_matbchcre)=='X'?'true':'false'); ?>;
        var lv_matsercre = <?= (strtoupper($lv_matsercre)=='X'?'true':'false'); ?>;
        var lv_matbchman = <?= (strtoupper($lv_stkmatbchman)=='X'?'true':'false'); ?>;
        var lv_matserman = <?= (strtoupper($lv_stkmatserman)=='X'?'true':'false'); ?>;
        var lv_matstkadd = (<?=($lv_matstkadd != '')?'true':'false'?>);

        var lv_ro = <?= ($vew_readonly?'true':'false'); ?>;
        
        var lv_matbchcodext = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matbchcodext");
				var lv_matqtystk = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matqtystk");
				var lv_matqtytot = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matqtytot");
				var lv_matstkrel = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matstkrel");
				var lv_matstkdif = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matstkdif");
				var lv_sysdocrejcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"sysdocrejcod");
        var lv_blnkrow = (<?=$lv_sec;?>_hotmat.getDataAtRowProp(row,"blank")??"");
				lv_sysdocrejcod = (lv_sysdocrejcod==null || lv_sysdocrejcod==""?"0":lv_sysdocrejcod);

				if ( prop=="matcod" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);			
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else if ( prop=="mattxt" ) {
					Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
					var lv_isChild = <?= $lv_sec; ?>_hotmat.getPlugin('nestedRows').dataManager.getRowParent(row) != undefined;
					td.style.backgroundColor = (lv_ro || !lv_matstkadd || lv_isChild ?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || !lv_matstkadd || lv_isChild ?true:false);
				} else if ( prop=="matqtystk" || prop=="matqtytot" || prop=="matqtypck" || prop=="matqtydif" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = (prop=="matqtypck"?((lv_ro || !lv_matusepck)?lv_ro_color:lv_color):lv_ro_color);
					cellProperties.readOnly = (prop=="matqtypck"?((lv_ro || !lv_matusepck)?true:false):true);
					if( prop=="matqtydif" && lv_matqtystk<lv_matqtytot && lv_matstkrel!="" ){
						td.style.backgroundColor = "#FF0000";
						td.style.color = "#FFFFFF";
					}
				}else if(prop=="matqtybse"){
          Handsontable.renderers.NumericRenderer.apply(this, arguments);
          td.style.backgroundColor = (lv_blnkrow != "" && prop=="matqtybse"?((lv_ro)?lv_ro_color:lv_color):lv_ro_color);
					cellProperties.readOnly = (lv_blnkrow != "" && prop=="matqtybse"?((lv_ro)?true:false):true);
       	} else if ( prop=="matuntcod" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);			
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else if ( prop=="matbchcodext" ) {
          var codext = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matbchcodext");
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					var lv_errcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matbchdeterrcod");
					var lv_errtxt = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matbchdeterrtxt");
					if ( lv_errtxt!="" ) { cellProperties.comment = lv_errtxt; }
					var lv_col = (lv_errcod=="E"?"#FFAAAA":(lv_errcod=="W"?"#FFFFAA":""));
          td.style.backgroundColor = ( !lv_matusebch || lv_ro || !lv_matbchman ? lv_ro_color : lv_col);
					cellProperties.readOnly = ( !lv_matusebch || lv_ro || !lv_matbchman ? true:false);
				} else if ( prop=="icn" ) {
          $(td).empty();
          var lv_btn = "<div onclick='<?= $lv_sec; ?>_findBatch("+row+");' class='text-center cursor-pointer'><a href='#'><i class='fas fa-search'></i></a></div>";
          if ( lv_matusebch && "<?= ($vew_actcod!='03'?true:false) ?>" == "1" ){ $(td).empty().append(lv_btn); }
          td.style.backgroundColor = lv_ro_color;
        } else if ( prop=="icn_add" ) {
          $(td).empty();
          var lv_isTopLevel = <?= $lv_sec; ?>_hotmat.getPlugin('nestedRows').dataManager.getRowParent(row) == undefined;
          if(lv_isTopLevel && <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"mattxt") && !<?= ($vew_readonly?'true':'false'); ?>) {
            var lv_btn = "<div onclick='<?= $lv_sec; ?>_addChildRow("+lv_phsrow+");' class='text-center cursor-pointer'><a href='#'><i class='fas fa-plus'></i></a></div>";
            $(td).empty().append(lv_btn);
          }
          td.style.backgroundColor = lv_ro_color;
        } else if ( prop=="matsercodext") { 
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || !lv_matuseser || !lv_matserman ?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || !lv_matuseser || !lv_matserman ?true:false);
        }  else if ( prop=="matbchduedte") {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            td.style.backgroundColor = (lv_ro || !lv_matusebch || !lv_matbchman || lv_matbchcodext != '' ?lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro || !lv_matusebch || !lv_matbchman || lv_matbchcodext != '' ?true:false);
				} else if ( prop=="icn2" ) {
          $(td).empty();
					var lv_btn = "<div onclick='<?= $lv_sec; ?>_findSerial("+row+");' class='text-center cursor-pointer'><a href='#'><i class='fas fa-search'></i></a></div>";
					if ( lv_matuseser && "<?= ($vew_actcod!='03'?true:false) ?>" == "1" ){ $(td).empty().append(lv_btn); }
					td.style.backgroundColor = lv_ro_color;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotmatchg = [];
		var <?= $lv_sec; ?>_hotmatdel = [];
		var <?= $lv_sec; ?>_hotmatcnt = $("#<?= $lv_sec; ?> #stkmovelbmathot")[0];
		var <?= $lv_sec; ?>_hotmatset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly ?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
  		bindRowsWithHeaders: true,
      nestedRows: true,
      enterMoves: function(event) {
        // Enter sigue el mismo sentido que Tab
        var lv_editCols = [1,4, 6, 8, 9];
        var lv_sel = <?= $lv_sec; ?>_hotmat.getSelectedLast();
        if (!lv_sel) return {row: 1, col: 0};
        var lv_row = lv_sel[0], lv_col = lv_sel[1];
        var lv_nextColIdx = lv_editCols.indexOf(lv_col);
        if (lv_nextColIdx >= 0 && lv_nextColIdx < lv_editCols.length - 1) {
          var lv_delta = lv_editCols[lv_nextColIdx + 1] - lv_col;
          return {row: 0, col: lv_delta};
        }
        var lv_rowDelta = 1;
        var lv_colDelta = lv_editCols[0] - lv_col;
        return {row: lv_rowDelta, col: lv_colDelta};
      },
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "ID", "Denominacion", "Base",  "Requerido",  "Consumido", "UM", "Lote",<?= ( $vew_actcod!='03' && $vew_actcod!='00' && strtoupper($lv_stkmatbchman)=='X' ?'"",':''); ?> "Vto","Nro Serie",<?= ( $vew_actcod!='03' && $vew_actcod!='00' && strtoupper($lv_stkmatserman)=='X' ?'"",':''); ?>""],
			columns: [
				{type: "text", data: "matcod", width: 25, renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
            if (query === '') { return; }
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({
								url: "?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query,prm_sysdocclscod:"<?=$lv_matstkadd?>" }, minLength: 2,
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
								success: function (response) {
                  var lv_dat = [];
									<?= $lv_sec; ?>_hotmatchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotmatchg.push({		mattxt: response.data[i]["mattxt"], 
																												matcod: response.data[i]["matcod"], 
																												matcodext: response.data[i]["matcodext"], 
																												matuntcod: response.data[i]["matuntcod"],
																												matusebch: response.data[i]["matusebch"],
																												matuseser: response.data[i]["matuseser"],
																												matstkrel: response.data[i]["matstkrel"],
                      																	matbchcodext: response.data[i]["matstkrel"],
																												});
										lv_dat.push( response.data[i]["mattxt"] );
									}
									process( lv_dat );
								}
							});
						} else {
							<?= $lv_sec; ?>_hot_paste = false;
						}
					},
					strict: true
				},
				{type: "numeric", data: "matqtybse", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "matqtytot", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "matqtypck", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 30, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "text", data: "matbchcodext", width: 40, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
        <?php if( $vew_actcod!='03' && $vew_actcod!='00' && strtoupper($lv_stkmatbchman)=='X'){ ?>
				{type: "text", data: "icn", width: 20, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true },
				<?php } ?>
        {type: "date", data: "matbchduedte", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer , readOnly: true,
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: true,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{type: "text", data: "matsercodext",width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
        <?php if( $vew_actcod!='03' && $vew_actcod!='00' && strtoupper($lv_stkmatserman)=='X'){ ?>
        	,{type: "text", data: "icn2", width: 20, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true }
        <?php } ?>
          ,{type: "text", data: "icn_add", width: 20, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true }
			], 
			beforeChange : function(changes, source) {
				// AUTOCOMPLETE: asigno los datos adicionales a la fila
				if (changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hot_paste!=true) {
					if (changes[0][1]=="mattxt") {
						var lv_value = changes[0][3];
						for(var i=0 ; i < <?= $lv_sec; ?>_hotmatchg.length ; i++) {
							if (<?= $lv_sec; ?>_hotmatchg[i].mattxt == lv_value) {
								changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotmatchg[i].matcod) ]);
								changes.push([ changes[0][0], "matcodext", "", String(<?= $lv_sec; ?>_hotmatchg[i].matcodext) ]);
								changes.push([ changes[0][0], "matusebch", "", String(<?= $lv_sec; ?>_hotmatchg[i].matusebch) ]);
                changes.push([ changes[0][0], "matbchcodext", "", ""]);
								changes.push([ changes[0][0], "matuseser", "", String(<?= $lv_sec; ?>_hotmatchg[i].matuseser) ]);
                changes.push([ changes[0][0], "matbchduedte", "", "" ]);
                changes.push([ changes[0][0], "matsercodext", "", ""]);
								changes.push([ changes[0][0], "matstkrel", "", String(<?= $lv_sec; ?>_hotmatchg[i].matstkrel) ]);
								if (<?= $lv_sec; ?>_hotmat.getDataAtRowProp(changes[0][0],"matuntcod")!=String(<?= $lv_sec; ?>_hotmatchg[i].matuntcod) ) {
									changes.push([ changes[0][0], "matqty", "", "1" ]);
									changes.push([ changes[0][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotmatchg[i].matuntcod) ]);
								}
								<?= $lv_sec; ?>_hot_autocomplete = true;
							}
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
			var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
			for( var i=index; i<=index+amount-1; i++){
				if ( lv_dat[i]["docrefsrcqty"]!="" && lv_dat[i]["docrefsrcqty"]!=undefined ) {
					toastr.warning("No se pueden borrar posiciones que estan referenciadas por otros documentos.");
					return false;
				} else {
              if ( lv_dat[i]["stkmovelbmatcod"]!="" && lv_dat[i]["stkmovelbmatcod"]!=undefined ){
                  <?= $lv_sec; ?>_hotmatdel.push( lv_dat[i] );
              }
              // Si el padre tiene hijos, registrarlos también para borrado en el servidor
              if (Array.isArray(lv_dat[i]["__children"])) {
                lv_dat[i]["__children"].forEach(function(lv_child) {
                  if (lv_child["stkmovelbmatcod"] != "" && lv_child["stkmovelbmatcod"] != undefined) {
                    <?= $lv_sec; ?>_hotmatdel.push(lv_child);
                  }
                });
              }
			  }
          if(i == <?=$lv_sec;?>_hotmat.countSourceRows()-1 && <?=$lv_matstkadd!=''?'true':'false'?>){
            return false
          }
			  var lv_found=0;
			  var lv_newinx;
			  for( var x=<?= $lv_sec; ?>_hotdocerr.length-1; x>=0; x-- ) {
				  if( <?= $lv_sec; ?>_hotdocerr[x].endsWith("_"+i.toString()) ){
					  <?= $lv_sec; ?>_hotdocerr.splice(x,1);
					  lv_found=1;
				  } else if(lv_found==0) { 
					  lv_newinx = <?= $lv_sec; ?>_hotdocerr[x].split("_");
					  lv_newinx[1] = Number(lv_newinx[1])-1;
					  <?= $lv_sec; ?>_hotdocerr[x] = lv_newinx[0]+"_"+lv_newinx[1].toString();
				  }
			  }
		  }
		},
      afterValidate: function( isValid, value, row, prop, source) {
        if(source==="refresh") return;
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			},
      afterRemoveRow: function(index, amount, physicalRows, source) {
        if (source === "parent" || source === "auto") return;
      },
      afterOnCellMouseDown: function(event, coords, TD) {
        let lv_btn = $("#<?= $lv_sec; ?>_btnDeleteSelected");
        if (!lv_btn) return;
        if (coords.col === -1 && coords.row >= 0){
            lv_btn.show();
            $("#<?= $lv_sec; ?> #btnstkchk").hide();
            $("#<?= $lv_sec; ?> #btnmatbchdet").hide();
            $("#<?= $lv_sec; ?> #btnupdlst").hide();
        }else{
            lv_btn.hide();
            $("#<?= $lv_sec; ?> #btnstkchk").show();
            $("#<?= $lv_sec; ?> #btnmatbchdet").show();
            $("#<?= $lv_sec; ?> #btnupdlst").show();
        }
      },
      afterDeselect: function() {
        let lv_btn = $("#<?= $lv_sec; ?>_btnDeleteSelected");
        if (!lv_btn) return;
        lv_btn.hide();
        $("#<?= $lv_sec; ?> #btnstkchk").show();
        $("#<?= $lv_sec; ?> #btnmatbchdet").show();
        $("#<?= $lv_sec; ?> #btnupdlst").show();
        

      },
      afterChange: function (changes, source) {
        if (source === "loadData" || source === "autoclear" || !changes || source === "parent") return;
        changes.forEach(([row, prop, oldValue, newValue]) => {
          // si se borró el lote, limpio todos los campos relacionados a él
          if (prop === "matbchcodext" && (newValue === null || newValue === "")) {
            const lo_clrbchfld = { matbchcod:"", matbchcodext:"", matbchduedte:"" };
            Object.entries(lo_clrbchfld).forEach(([field, value]) => {
              this.setDataAtRowProp(row, field, value, 'autoclear');
            });
          }
         if(prop ==="mattxt" && oldValue !== newValue){
           if(row ==(<?= $lv_sec; ?>_hotmat.countSourceRows()-1) && "<?=$lv_matstkadd;?>" != "" && newValue!="" && <?=(!$vew_readonly?'true':'false');?>){<?=$lv_sec;?>_addBlankRow();}
         }
         if(prop ==="matqtybse" && oldValue !== newValue && (<?=$lv_sec;?>_hotmat.getDataAtRowProp(row,"blank")??"")!="X"){
         //MODIFICAR BASE HACE QUE CAMBIE EL TOTAL REQUERIDO.
          var lv_qty = $("#<?=$lv_sec;?> #matqty").prop("value");
          var lv_tot = newValue * lv_qty;
          var lv_dat = <?=$lv_sec;?>_hotmat.getSourceData();
          var lv_matcod = <?=$lv_sec;?>_hotmat.getDataAtRowProp(row,"matcod");
          lv_dat.forEach((r, idx) => {
             if(r.matcod === lv_matcod) {
                 <?=$lv_sec;?>_hotmat.setDataAtRowProp(idx, "matqtytot", lv_tot);
             }
          });
        }
        });
			},
		};
   
		var <?= $lv_sec; ?>_hotmat;	
		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			var lv_dat =<?php
				$lv_buffer='';
        $lv_matcod = '';
        $lv_hotmat = [];
        //Agrego filas cabeceras e hijos anidados correctamente
        foreach($vew_data->stkmovelbmat as $lv_row){ 
             $lv_tot = $lv_row['matqtybse'] * $vew_data->matqty;
             if(!array_key_exists($lv_row['matcod'],$lv_hotmat)){
                $lv_hotmat[$lv_row['matcod']] = [
                            'stkmovelbmatcod' =>$lv_row['stkmovelbmatcod'],
                            'matcod'=>$lv_row['matcod'],
                            'matcodext'=>$lv_row['matcodext'],
                            'mattxt'=>mb_convert_encoding($lv_row['mattxt'], 'UTF-8', 'ISO-8859-1'),
                            'matqtypck'=>(float)$lv_row['matqty'],
                            'matuntcod'=>$lv_row['matuntcod'],
                            'matqtybse' =>(float)$lv_row['matqtybse'],
                            'matqtytot' =>(float)$lv_tot,
                            'matusepck' => 1,
                            'matusebch'=>$lv_row['matusebch'],
                            'matbchcod'=>$lv_row['matbchcod'],
                            'matbchcodext'=>$lv_row['matbchcodext'],
                            'matbchduedte'=>($lv_row['matbchduedte']!=null?date_format($lv_row['matbchduedte'],'d/m/Y'):''),
                            'matuseser'=>$lv_row['matuseser'],
                            'matsercod'=>$lv_row['matsercod'],
                            'matsercodext'=>$lv_row['matsercodext'],
                            'matstkrel'=>$lv_row['matstkrel'],
                            'matqtybsehid'=>(float)$lv_row['matqtybse'],
                            '__children'=>[]
                        ]; 
             } else {
                $lv_hotmat[$lv_row['matcod']]['__children'][] = [
                            'stkmovelbmatcod' =>$lv_row['stkmovelbmatcod'],
                            'matcod'=>$lv_row['matcod'],
                            'matcodext'=>$lv_row['matcodext'],
                            'mattxt'=>mb_convert_encoding($lv_row['mattxt'], 'UTF-8', 'ISO-8859-1'),
                            'matqtypck'=>(float)$lv_row['matqty'],
                            'matuntcod'=>$lv_row['matuntcod'],
                            'matqtybse' =>'',
                            'matqtytot' =>'',
                            'matusepck' => 1,
                            'matusebch'=>$lv_row['matusebch'],
                            'matbchcod'=>$lv_row['matbchcod'],
                            'matbchcodext'=>$lv_row['matbchcodext'],
                            'matbchduedte'=>($lv_row['matbchduedte']!=null?date_format($lv_row['matbchduedte'],'d/m/Y'):''),
                            'matuseser'=>$lv_row['matuseser'],
                            'matsercod'=>$lv_row['matsercod'],
                            'matsercodext'=>$lv_row['matsercodext'],
                            'matstkrel'=>$lv_row['matstkrel'],
                            'matqtybsehid'=>(float)$lv_row['matqtybse']
                        ]; 
             }
          }
       $lv_hotmat = array_values($lv_hotmat);
       $lv_buffer = json_encode($lv_hotmat);
       echo $lv_buffer;
			?>;
      <?=$lv_sec; ?>_hotmatset["data"]=(lv_dat.length != 0)?lv_dat:[{"__children":[], "blank":"X"}];
      <?= $lv_sec; ?>_hotmat = new Handsontable(<?= $lv_sec; ?>_hotmatcnt, <?= $lv_sec; ?>_hotmatset);
      if(<?=$lv_matstkadd != ''?'true':'false'?>){ <?=$lv_sec;?>_addBlankRow();}  //Añadir fila vacia en caso de tener configurado materiales adicionales
      if(lv_dat.length == 0) <?=$lv_sec;?>_hotmat.alter("remove_row",0);			//Borrar fila temporal para no romper nestedRows
			<?= $lv_sec; ?>_hotmat.render();
      var lo_dat = <?=$lv_sec;?>_hotmat.getSourceData();
     	<?=$lv_sec?>_checkPicking(lo_dat);
		});
	</script>
	<script>
    // BUSCAR LOTE
		function <?= $lv_sec; ?>_findBatch( lv_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"matcod");
			if ( lv_matcod=="" || lv_matcod==undefined ) {
				toastr.warning("Debe seleccionar un material.");
			} else if ( $("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjcod':'strloccod'); ?>").prop("value")=="" ) {
				toastr.warning("Debe indicar el almacen.");
				$("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjtxt':'strloctxt'); ?>").focus();
			} else {
				$("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext, #<?= $lv_sec; ?> #tmpmatbchduedte").data("row",lv_row);
				tmssPopup("Buscar Lote","?prg=stkmatstk&prm_vewcod=VEW_STK_MAT_STK_BCH_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatbchcod:matbchcod],[tmpmatbchcodext:matbchcodext],[tmpmatbchduedte:matbchduedte]&prm_fldflt=[s.stkobjtyp:STK_STL],[s.stkobjcod:"+$("#<?= $lv_sec; ?> #strloccod").prop("value")+"],[not isnull(s.matbchcod_^0^):0],[s.matcod:"+lv_matcod+"]");
			}
		}
    $("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext, #<?= $lv_sec; ?> #tmpmatbchduedte").on("change",function(e) { 
			<?= $lv_sec; ?>_hotmat.setDataAtRowProp( $(this).data("row"), $(this).data("fldnme"), $(this).prop("value") );
		});
    
    
    // BUSCAR NRO DE SERIE
		function <?= $lv_sec; ?>_findSerial( lv_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"matcod");
			if ( lv_matcod=="" || lv_matcod==undefined ) {
				toastr.warning("Debe seleccionar un material.");
			} else if ( $("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjcod':'strloccod'); ?>").prop("value")=="" ) {
				toastr.warning("Debe indicar el almacen.");
				$("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjtxt':'strloctxt'); ?>").focus();
			} else {
				$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext, #<?= $lv_sec; ?> #tmpmatserduedte").data("row",lv_row);
				tmssPopup("Buscar n&uacute;mero de serie","?prg=stkmatser&prm_vewcod=VEW_STK_MAT_SER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatsercod:s.matsercod],[tmpmatsercodext:s.matsercodext]&prm_fldflt=[s.matcod:"+lv_matcod+"],[s.docsts:A],[stkobjcod:"+$("#<?= $lv_sec; ?> #strloccod").val()+"]");
			}
		}
    $("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext, #<?= $lv_sec; ?> #tmpmatserduedte").on("change",function(e) { 
			<?= $lv_sec; ?>_hotmat.setDataAtRowProp( $(this).data("row"), $(this).data("fldnme"), $(this).prop("value") );
		});
    
    
    // DETERMINAR LOTE
		$("#<?= $lv_sec; ?> #btnmatbchdet").on("click",function(e){ e.preventDefault();
			var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();                                                                                    
			if ( $("#<?= $lv_sec; ?> #strloccod").prop("value")=="" ) {
				toastr.warning("Debe indicar el almacen.");
      } else if ( $("#<?= $lv_sec; ?> #matqty").prop("value")=="" ) {
        toastr.warning("Debe indicar la cantidad");
			} else if ( lo_dat.length<=0 ) {
				toastr.warning("Debe ingrear al menos un material a determinar.");
			} else {
        // Recupero la cabecera de la handson
        for(var i = lo_dat.length-1; i >=0; i--){ 
          if ( !("matcod" in lo_dat[i]) || !("__children" in lo_dat[i])) {
             if (lo_dat[i]["stkmovelbmatcod"] && lo_dat[i]["stkmovelbmatcod"] !== undefined) {
                lo_dat[i]["deleted"] = "X";
                <?= $lv_sec; ?>_hotmatdel.push(lo_dat[i]);
              }
             lo_dat.splice(i, 1);
          }
        }       
				BootstrapDialog.confirm({
					title: "Determinar Lote", 
					message:"Desea realizar la determinaci&oacute;n de lotes?",
					type: BootstrapDialog.TYPE_PRIMARY,
					callback: function(result){
						if(result){
							//agrega el matqty a cada material
              for(var i = 0; i < lo_dat.length; i++){ 
                lo_dat[i].matqty = (lo_dat[i].matqtytot == undefined?1:lo_dat[i].matqtytot); 
              }
							var lo_datpst = [];
							lo_datpst.push( {name:"stkmovdocmat", value: JSON.stringify( lo_dat )} );
              lo_datpst.push( {name:"srcobjtyp", value: "STK_STL"} );
							lo_datpst.push( {name:"srcobjcod", value: $("#<?= $lv_sec; ?> #strloccod").prop("value")} );
							lo_datpst.push( {name:"srccntcod", value: $("#<?= $lv_sec; ?> #srccntcod").prop("value")} );
							lo_datpst.push( {name:"matbchdet", value: "<?= $lv_matbchdet; ?>"} );
							lo_datpst.push( {name:"matbchdetspl", value: "<?= $lv_matbchdetspl; ?>"} );
							tmssCallProcess("?prg=stkmatstk&act=25", lo_datpst, function(data){
								var lv_matcod = 0;
                var lv_dat = [];
                for(var i = 0; i < data.length; i++){
                  var lv_row = data[i];
                  // Campos de lote/serie segun disponibilidad
                  var lv_bch = (lv_row.matbchcodext=="" && lv_row.matusebch == "1" && lv_row.matbchdeterrtxt.startsWith("Stock insuficiente."))
                    ? {matbchcodext:"SIN LOTE", matusepck:"0"}
                    : {matbchcodext:lv_row.matbchcodext, matbchcod:lv_row.matbchcod, matbchduedte:lv_row.matbchduedte, matusebch:lv_row.matusebch, matuseser:lv_row.matuseser, matsercod:lv_row.matsercod, matusepck:"1"};
                  if(lv_row.matcod != lv_matcod){
                    lv_matcod = lv_row.matcod;
                    // Primera asignacion de lote → va directo al padre
                    lv_dat.push({...lv_row, matqtytot:parseFloat(lv_row.matqty), matqtybsehid:lv_row.matqtybse, matqtybse:"", ...lv_bch, __children:[]});
                  } else {
                    // Asignaciones adicionales → van como hijos
                    var lv_index = lv_dat.findIndex(x => x.matcod === lv_row.matcod);
                    lv_dat[lv_index]["__children"].push({matcod:lv_row.matcod, mattxt:lv_row.mattxt, matqtydif:lv_row.matqtydif, matqtystk:lv_row.matqtystk, matuntcod:lv_row.matuntcod, matqtytot:parseFloat(lv_row.matqty), matqtybsehid:lv_row.matqtybse, matqtybse:"", ...lv_bch});
                  }
                }
								<?= $lv_sec; ?>_hotmat.loadData( lv_dat );
                if(<?=($lv_matstkadd != '')?'true':'false'?>){<?=$lv_sec;?>_addBlankRow();}
								<?= $lv_sec; ?>_hotmat.render();
								toastr.info("Se realiz&oacute; la determinaci&oacute;n de lotes.");
							});
						}
					}
				});
			}
		});
    

    // VERIFICACION DISPONIBILIDAD
    $("#<?= $lv_sec; ?> #btnstkchk").on("click",function(e){ 
      e.preventDefault();
      var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();

      if ($("#<?= $lv_sec; ?> #strloccod").prop("value")=="" ) {
        toastr.warning("Debe indicar el almacen.");
        return;
      } 
      if (lo_dat.length<=0) {
        toastr.warning("Debe ingresar al menos un material a determinar.");
        return;
      } 

      BootstrapDialog.confirm({
        title: "<?= $vew_lang->availabilitycheck; ?>", 
        message:"Desea realizar la verificaci&oacute;n de disponiblidad?",
        type: BootstrapDialog.TYPE_PRIMARY,
        callback: function(result){
          if(result){	
            var lo_datpst = [];
            var lo_dat2 = [];

            <?php if( !$vew_readonly ){ ?>
              lo_dat2 = lo_dat.slice(0,(<?=strtoupper($lv_matstkadd)!=''?'true':'false'?>)?lo_dat.length-1:lo_dat.length);
              for(var i = lo_dat2.length - 1; i >= 0; i--){ if(!(lo_dat2[i]["__children"]) || lo_dat2[i]["__children"].length == 0 ) {lo_dat2[i]["row"]=i; lo_dat2[i]["matqtytot"]=lo_dat2[i]["matqtytot"]??lo_dat2[i]["matqtypck"];}else{lo_dat2.splice(i, 1);} }
            <?php } ?>
            lo_datpst.push( {name:"srcobjtyp", value: "STK_STL"} );
            lo_datpst.push( {name:"srcobjcod", value: $("#<?= $lv_sec; ?> #strloccod").prop("value")} );
            lo_datpst.push( {name:"srccntcod", value: $("#<?= $lv_sec; ?> #srccntcod").prop("value")} );
            lo_datpst.push( {name:"matarr", value: JSON.stringify( lo_dat2 )} );

            tmssCallProcess("?prg=stkmatstk&act=30", lo_datpst, function(data){
              var lv_tbl = "";

              // Detectar si hay algún lote cargado en toda la tabla
              var lv_hasbch = lo_dat2.some(r => r["matbchcodext"] && r["matbchcodext"] !== "");
              // Validación previa: si hay lotes, pero falta consumido → error
              if(lv_hasbch){                
                if( lo_dat2.some(r => ((r["matusepck"]??1)==1 && (!r["matqtypck"] || r["matqtypck"] === "")) )){
                  toastr.warning("Debe cargar lo consumido en todas las posiciones.");
                  return;
                }
              }
              
              for(var i=0; i<data.length; i++) {
                var lv_matqtytot = parseFloat(lo_dat2[i]["matqtytot"] || 0);
                var lv_matqtypck = parseFloat(lo_dat2[i]["matqtypck"] || 0);
                var lv_totstk = parseFloat(data[i]["matqtystk"] || 0);
								var lv_haspck = ((lo_dat2[i]["matbchcodext"] && lo_dat2[i]["matbchcodext"] !== "" )|| !lo_dat2[i]["__children"] )
                var lv_qty = lv_haspck ? lv_matqtypck : lv_matqtytot;

                if(data[i].errtyp=="E" || lv_qty > lv_totstk){
                  var lv_msg = (lv_qty > lv_totstk) 
                    ? "Cantidad ingresada ("+lv_qty+") mayor a stock disponible ("+lv_totstk+")."
                    : data[i]["errtxt"];
                  lv_tbl += "<tr><td><b>"+data[i]["mattxt"]+"</b><br>"+lv_msg+"</td></tr>";
                  <?= $lv_sec; ?>_hotmat.setCellMeta(data[i]["row"], lv_haspck ? <?= $lv_sec; ?>_hotmat.propToCol("matqtypck") : <?= $lv_sec; ?>_hotmat.propToCol("matqtytot"), "valid", false);
                } else {
                  <?= $lv_sec; ?>_hotmat.setCellMeta(data[i]["row"], lv_haspck ? <?= $lv_sec; ?>_hotmat.propToCol("matqtypck") : <?= $lv_sec; ?>_hotmat.propToCol("matqtytot"), "valid", true);                        
                }
              }

              <?= $lv_sec; ?>_hotmat.render();

              if(lv_tbl==""){
                toastr.success("Todas las posiciones con stock verificado.");                
              } else {
                lv_tbl = "<table class='table table-bordered table-hover table-condensed table-striped'><tbody>"+lv_tbl+"</tbody></table>";
                BootstrapDialog.show({
                  title: "<?= $vew_lang->availabilitycheck; ?>", 
                  message: $( lv_tbl ),
                  type: BootstrapDialog.TYPE_PRIMARY,
                  draggable: true,
                  closable: true
                });
              }
            });
          }
        }
      });
    });
	</script>
  <script>
		// server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {
      var lv_error = (data.hasOwnProperty("errcod")?(data.errcod==0?false:true):false);
			// BORRAR. documento borrado se cierra la seccion
			if(lv_error==false && gv_<?= $lv_sec; ?>_last_action=="04") {
				tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				return;
			
			// CONTABILIZAR. documento contabilizado, se actualiza seccion
			} else if(lv_error==false && gv_<?= $lv_sec; ?>_last_action=="09") {
				toastr.info("Documento <b>"+$("#<?= $lv_sec; ?> #stkmovdoccod").prop("value")+"</b> contabilizado.", "<?= $lv_title; ?>");
				<?= $lv_sec; ?>_fnc({action: "99"});
				return;
			
			// GRABADO/OTRO. documento grabado, se muestra pantalla actualizada
			} else if(lv_error==false) {
				$("#<?= $lv_sec; ?>").replaceWith( data );
				return;
				
			// ERROR MATERIAL. si el error esta relacionado a un material
			} else if( data.hasOwnProperty("errmat") && data.errmat != ""){
				var lv_mat = <?= $lv_sec; ?>_hotmat.getSourceData();
				var lv_errmat = JSON.parse( data.errmat );
				for(var x=0; x<lv_mat.length; x++){
					var lv_found=false;
					for(var i=0; i<lv_errmat.length; i++){
						if( lv_mat[x].matcod==lv_errmat[i].matcod && 
								(lv_errmat[i].hasOwnProperty("matbchcodext") ? lv_mat[x].matbchcodext==lv_errmat[i].matbchcodext : true ) && 
								(lv_errmat[i].hasOwnProperty("matsercodext") ? lv_mat[x].matsercodext==lv_errmat[i].matsercodext : true ) ){
							lv_found=true;
							<?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matqtypck"), "valid", false);
							if(lv_errmat[i].hasOwnProperty("matbchcodext")){ <?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matbchcodext"), "valid", false); }
							if(lv_errmat[i].hasOwnProperty("matbchcodext")){ <?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matbchduedte"), "valid", false); }
							if(lv_errmat[i].hasOwnProperty("matsercodext")){ <?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matsercodext"), "valid", false); }
						}
					}
					// fila valida, actualizo status
					if(lv_found==false){
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 2, "valid", true);
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 4, "valid", true);
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 6, "valid", true);
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 7, "valid", true);
					}
				}
				// render de tabla
				<?= $lv_sec; ?>_hotmat.render();

			// ERORR GENERAL. es un error general, se informa mensaje unicamente
			} else {
				toastr.warning(data.errcod+": "+data.errtxt);
				return;
			}
      if ( gv_<?= $lv_sec; ?>_last_action=="09" ) {
				if(data.errtyp=="S" || data.errtyp=="W"){
					toastr.info("Documento <b>"+$("#<?= $lv_sec; ?> #stkmovdoccod").prop("value")+"</b> contabilizado.", "<?= $lv_title; ?>");
					<?= $lv_sec; ?>_fnc({action: "99"});
					return;
				} else {
          toastr.warning(data.errelb+": "+data.errtxt);
          if(data.hasOwnProperty("errmat")){
            var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData(); //Datos handsontable
            var a = String.fromCharCode(9);
						var lv_err = JSON.parse( data.errmat );
            var lv_found;
            for(var i=0; i<lv_dat.length; i++){
              lv_found=false;
              if (!("__children" in lv_dat[i])){
                for(var x=0; x<lv_err.length; x++){
                  // errores de stock
                  if ( data.errcod==-601 && lv_err[x].matcod==lv_dat[i].matcod ) {
                    lv_found=true;
                    <?= $lv_sec; ?>_hotmat.setCellMeta(i, 4, "valid", false);
                  // errores de lote
                  } else if ( (data.errcod==-302 || data.errcod==-402 || data.errcod==-502 || data.errcod==-602) && lv_err[x].matbchcodext==lv_dat[i].matbchcodext ) {
                    lv_found=true;
                    <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matbchcodext"), "valid", false);
                    <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matbchduedte"), "valid", false);
                  // errores de nros de serie
                  } else if ( (data.errcod==-403 || data.errcod==-503 || data.errcod==-603) && lv_err[x].matsercodext==lv_dat[i].matsercodext ) {
                    lv_found=true;
                    <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matsercodext"), "valid", false);
                  } 
                }
                if(lv_found==false){
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, 2, "valid", true);
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, 4, "valid", true);
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, 6, "valid", true);
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, 7, "valid", true);
                }
            	}
            }
            <?= $lv_sec; ?>_hotmat.render();
          }
				}
			// others
			} 
    }
  </script>
  <script>
    var lv_limerr = false;
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      var error = true;
      var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				// obtengo datos de handsontable
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
          var pushRow = function(r, visualIdx) {
					  if ( r["mattxt"]!="" && r["mattxt"]!=undefined && ((r["matusepck"]??"1") == "1") ) {
              if(r["matbchcodext"] == undefined && r["matstkrel"] == "X"){
                <?= $lv_sec; ?>_hotmat.setCellMeta(visualIdx, <?= $lv_sec; ?>_hotmat.propToCol("matstkrel"), "valid", false);
                <?= $lv_sec; ?>_hotmat.setCellMeta(visualIdx, <?= $lv_sec; ?>_hotmat.propToCol("matbchcodext"), "valid", false); 
                error = false;
                <?= $lv_sec; ?>_hotmat.render();
              }else if(r["matqtypck"] == undefined || r["matqtypck"] == "" ){
                <?= $lv_sec; ?>_hotmat.setCellMeta(visualIdx, <?= $lv_sec; ?>_hotmat.propToCol("matqtypck"), "valid", false);
                error = false;;
                <?= $lv_sec; ?>_hotmat.render();
              }
              lv_arr.push({	"stkmovelbmatcod":r["stkmovelbmatcod"],
                            "matcod":r["matcod"],
                            "matcodext":r["matcodext"],
                            "mattxt":r["mattxt"],
                            "matqty":r["matqtypck"],
                            "matuntcod":r["matuntcod"],
                            "matbchcod":r["matbchcod"],
                            "matbchcodext":r["matbchcodext"],
                            "matsercod":r["matsercod"],
                            "matsercodext":r["matsercodext"],
                            "matbchduedte":r["matbchduedte"],
                            "matqtybse" : (r["matqtybsehid"] || r["matqtybse"])
                          });
            }
          };
          
          // nestedRows expone los hijos tanto dentro de __children como como entradas raíz separadas.
          // Saltear entradas que NO son raíz (no tienen __children como Array) para evitar duplicados.
          if (!Array.isArray(lo_dat[i]["__children"])) continue;

          var lv_hasChildren = lo_dat[i]["__children"].length > 0;
          if (!lv_hasChildren) {
            // Padre sin hijos → fila independiente (lote único o sin lote)
            pushRow(lo_dat[i], i);
          } else {
            // Padre con hijos → el padre es el registro base, los hijos son los lotes/series
            pushRow(lo_dat[i], i);
            lo_dat[i]["__children"].forEach((c) => { pushRow(c, i); });
          }
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotmatdel.length; i++) {
					lv_arr.push({	"stkmovelbmatcod":<?= $lv_sec; ?>_hotmatdel[i]["stkmovelbmatcod"], "deleted":"X" });
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #stkmovelbmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmovelbmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
      
      if(!error){ toastr.warning("Complete todos los campos."); return false; }
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>