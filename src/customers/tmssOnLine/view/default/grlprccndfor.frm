<?php
	// url del formulario
  $lv_lnk = '?prg=grlprccndfor';

	// campos requeridos
	$vew_input->RequiredFields( array('prccndfortxt','prccndforsrctyp','prccndforsrc','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prccndforcod;

	// titulo
	$lv_title = $vew_lang->formula;
	
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PCF';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('prccndforsrczcu', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prccndforcod; ?><?= gethtml('prccndforcod', 'hidden', $vew_data->prccndforcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,  			'input'=>gethtml('prccndforcodext', 'doccmt1x20', $vew_data->prccndforcodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('prccndfortxt', 'doccmt1x50', $vew_data->prccndfortxt, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type,				'input'=>gethtml('prccndforsrctyp', 'prccndforsrctyp', $vew_data->prccndforsrctyp, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                    echo '<hr>';
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->notes,			'input'=>gethtml('prccndforcmt', 'doccmt4x50', utf8_decode($vew_data->prccndforcmt), $lv_default) ));
                  ?>
                  <hr>
                  <div class="form-group  tmss-form-group">
                    <label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->references; ?></label>
                    <div class="col-sm-10">
                      <table class="table table-striped table-condensed table-bordered">
                        <tbody>
                          <tr>
                            <td><b>Operadores Logicos</b></td>
                            <td><b>Operadores Matematicos</b></td>
                            <td><b>Operadores Condicionales</b></td>
                          </tr>
                          <tr>
                            <td>><br><<br>=<br><><br>>=<br><=</td>
                            <td>+<br>-<br>*<br>/</td>
                            <td>SI<br>O<br>Y<br>DAY<br>MONTH<br>YEAR</td>
                          </tr>
                          <tr>
                            <td><b>Constantes</b></td>
                            <td><b>Variables</b></td>
                            <td><b>Comentarios</b></td>
                          </tr>
                          <tr>
                            <td>@@TRUE<br>@@FALSE<br>@@HOY<br>@@VACIO</td>
                            <td>[catalogo.variable]</td>
                            <td>Formato Fecha: YYYY.MM.DD<br>Decimales: , (coma)</td>
                          </tr>
                          <tr>
                            <td colspan="2"><b>Referencias</b></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td>@@VALOR.ROWnnnnn<br>@@CANTIDAD.ROWnnnnn<br>@@TOTAL.ROWnnnnn</td>
                            <td>@@VALOR<br>@@CANTIDAD<br>@@TOTAL</td>
                            <td>&nbsp;</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
						<div class="col-sm-6">
							<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <div id="divsrc">
                    <?= vew_boot($lv_colsm210, array('label'=>$vew_lang->source, 'input'=>gethtml('prccndforsrcsrc', 'doccmt5x50', $vew_doc->getTagValue($vew_data->prccndforsrc,'src'), $lv_default) )); ?>
                  </div>						
                  <div id="divfor">
                    <?php
                      echo vew_boot($lv_colsm39, array('label'=>'<span class="pull-left">'.$vew_lang->value.'</span><a href="#" class="btn btn-default btn-small pull-right" id="prccndforsrcvalchk" data-field="prccndforsrcval"><i class="fas fa-spell-check"></i></a>',	'input'=>gethtml('prccndforsrcval', 'doccmt5x50', $vew_doc->getTagValue($vew_data->prccndforsrc,'val'), $lv_default) ));
                      echo vew_boot($lv_colsm39, array('label'=>'<span class="pull-left">'.$vew_lang->quantity.'</span><a href="#" class="btn btn-default btn-small pull-right" id="prccndforsrcqtychk" data-field="prccndforsrcqty"><i class="fas fa-spell-check"></i></a>','input'=>gethtml('prccndforsrcqty','doccmt5x50', $vew_doc->getTagValue($vew_data->prccndforsrc,'qty'), $lv_default) ));
                      echo vew_boot($lv_colsm39, array('label'=>'<span class="pull-left">'.$vew_lang->unit.'</span>', 'input'=>gethtml('prccndforsrcunt', array(''=>'','%'=>'%'), $vew_doc->getTagValue($vew_data->prccndforsrc,'unt'), $lv_default) ));
                      echo vew_boot($lv_colsm39, array('label'=>'<span class="pull-left">'.$vew_lang->total.'</span><a href="#" class="btn btn-default btn-small pull-right" id="prccndforsrctotchk" data-field="prccndforsrctot"><i class="fas fa-spell-check"></i></a>',	'input'=>gethtml('prccndforsrctot', 'doccmt5x50', $vew_doc->getTagValue($vew_data->prccndforsrc,'tot'), $lv_default) ));
                    ?>
                    <div class="form-group  tmss-form-group">
                      <label class="col-sm-3 control-label">
                        Variables Catalogo ZCU 
                        <a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
                      </label>
                      <div class="col-sm-9" id="zcutbl"></div>
                    </div>
                  </div>
                </div>
              </div>
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
    
  </form>
	<script>
    var gv_<?= $lv_sec; ?>_zcucfg = {
      readOnly: "<?= $vew_readonly?>",
      headerData: [{title: "<?= $vew_lang->key; ?>", width: "50%"}, {title: "<?= $vew_lang->value; ?>", width: "50%"}],
      columnsData: [{id: "zcukey"},
                   {id: "zcuval"}],
      showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
    };
    
    var gv_<?= $lv_sec; ?>_zcudat = [<?php
      $lv_buffer='';
      if($vew_data->prccndforsrczcu!=''){
        $lv_arr = json_decode( html_entity_decode($vew_data->prccndforsrczcu),true );
        foreach($lv_arr as $lv_row){
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
              'zcukey:"'.$lv_row['zcukey'].'",'.
              'zcuval:"'.$lv_row['zcuval'].'"'.
              '}'; 
        }
      }
      echo $lv_buffer;
    ?>];
    
    var go_<?= $lv_sec; ?>_zcutbl = new tmssTable($("#<?= $lv_sec; ?> #zcutbl"), gv_<?= $lv_sec; ?>_zcucfg);
    
    $(function(){
      go_<?= $lv_sec; ?>_zcutbl.loadData(gv_<?= $lv_sec; ?>_zcudat);
    });
  </script>
  <script>
		// TIPO
		$("#<?= $lv_sec; ?> #prccndforsrctyp").on("change",function(e){
      $("#<?= $lv_sec; ?> #divsrc").toggleClass("hidden", $(this).val()!="1");
      $("#<?= $lv_sec; ?> #divfor").toggleClass("hidden", $(this).val()=="1");
		});
    
		$(function(){
			$("#<?= $lv_sec; ?> #prccndforsrctyp").trigger("change");
		});
  </script>
  <script>
		// VERIFICAR - VALOR / CANTIDAD / TOTAL
		$("#<?= $lv_sec; ?> #prccndforsrcvalchk, #<?= $lv_sec; ?> #prccndforsrcqtychk, #<?= $lv_sec; ?> #prccndforsrctotchk").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_simulate($("#<?= $lv_sec; ?> #"+$(this).data("field")));
		});
		
		// SIMULAR
		function <?= $lv_sec; ?>_simulate( lp_fld ){
			var lv_fld = [];
			var lv_val = $(lp_fld).val();
			var lv_str;
			var lv_found;
			var lv_buffer;
			var lv_out = [];
			
			//obtener todas las variables
			lv_str = -1;
			for(var i=0;i<lv_val.length;i++){
				if(lv_val.substr(i,1)=="["){
					lv_str = i;
				} else if(lv_val.substr(i,1)=="]" && lv_str>-1){
					lv_fld.push( lv_val.substr(lv_str+1,i-lv_str-1) );
					lv_str = -1;
				}
			}
			
			//quitar duplicados
			for(var i=0;i<lv_fld.length;i++){
				for(var x=lv_fld.length-1;x>i;x--){
					if(lv_fld[x].toUpperCase()==lv_fld[i].toUpperCase()){ 
						lv_fld.splice(x,1);
					}
				}
			}
			
			if(lv_fld.length>0){
				
				// armar vista
				lv_buffer = "<table class='table table-condensed table-striped'><tbody>";
				for(var i=0;i<lv_fld.length;i++){
					lv_buffer+="<tr><td>"+lv_fld[i]+"</td><td><input type='text' data-fldnme='"+lv_fld[i]+"'></td></tr>";
				}
				lv_buffer += "</tbody></table>";
			
				// mostrar popup
				BootstrapDialog.show({
					title: "<?= $vew_lang->simulate; ?>",
					message: $(lv_buffer),
					buttons:[{label: "<?= $vew_lang->cancel; ?>", cssClass:"btn-danger", action: function(dialog) { dialog.close(); }}
									,{label: "<?= $vew_lang->simulate;?>",cssClass:"btn-success",action: function(dialog) {
											dialog.$modalBody.find("input").each(function(){
												var lv_obj = {};
												lv_obj[$(this).data("fldnme")] = $(this).val();
												lv_out.push(lv_obj);
											});
											var lv_pstdat = [{name:"formula",value:$(lp_fld).prop("value")},{name:"data",value:JSON.stringify(lv_out)}];
											tmssCallProcess("?prg=grlprccndfor&act=evalFormula",lv_pstdat,function(data){
												if(data.errcod!=0){
													toastr.warning("Error: "+data.errtxt);
												} else {
													toastr.success("Resultado: "+data.resultado);
												}
											});

											//dialog.close();
										}
									}]
					});
			} else {
				var lv_pstdat = [{name:"formula",value:$(lp_fld).prop("value")},{name:"data",value:lv_out}];
				tmssCallProcess("?prg=grlprccndfor&act=evalFormula",lv_pstdat,function(data){
					if(data.errcod!=0){
						toastr.danger("Error: "+data.errtxt);
					} else {
						toastr.success("Resultado: "+data.resultado);
					}
				});
			}
		}
	</script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			
			if(lp_prm["action"]=="00"){
         
				var lv_zcuarr = go_<?= $lv_sec; ?>_zcutbl.getData();
        
        // validaciones
        for(let i=0; i < lv_zcuarr.length; i++){
          if(lv_zcuarr[i]["zcukey"] == "" || lv_zcuarr[i]["zcuval"] == ""){
							toastr.warning("Todas las variables deben tener clave y valor.");
              return false;
          }
        }
        
        for(let i=0; i < lv_zcuarr.length - 1; i++){
          for(let j=1; j < lv_zcuarr.length; j++){
            if(lv_zcuarr[i]["zcukey"] == lv_zcuarr[j]["zcukey"]){
							toastr.warning("Existen variables con claves repetidas.");
              return false;
            }
          }
        }
        
        $("#<?= $lv_sec; ?> #prccndforsrczcu").val( JSON.stringify( lv_zcuarr ) );
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>