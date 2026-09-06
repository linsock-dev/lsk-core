<?php
	// url del formulario
  $lv_lnk = '?prg=sysappiaa&prm_sysappiaacod='.$vew_data->sysappiaacod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysappiaatxt','sysappiaaprv','sysappiaamdl','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysappiaacod;

	// titulo
	$lv_title = $vew_lang->artificialintelligence;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'IAA';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea class="d-none" id="sysappiaauac" name="sysappiaauac"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysappiaacod; ?><?= gethtml('sysappiaacod','hidden', $vew_data->sysappiaacod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-5">
              
               <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('sysappiaacodext', 'doccmt1x20', $vew_data->sysappiaacodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysappiaatxt', 'doccmt1x50', $vew_data->sysappiaatxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
										echo '<hr>';
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->model,			'input'=>gethtml('sysappiaamdlcod', 'sysappiaamdl_lst', $vew_data->sysappiaamdlcod, $lv_default) ));
										if( $vew_readonly ) {
											echo vew_boot($lv_col210, array('label'=>$vew_lang->key, 'input'=>gethtml('','doccmt1x50', ($vew_data->sysappiaakey!=''?'****************':''),$lv_always_disabled) ));
										} else {
											echo vew_boot($lv_col210, array('label'=>$vew_lang->key, 'input'=>gethtml('sysappiaakey', 'doccmt1x50', '', $lv_default) ));
										}
									?>
						    </div>
              </div>
						</div>
						<div class="col-md-7">
							<div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->activations; ?> 
                    <a href="#" class="card-icon" id="hlpVar"><i class="far fa-book"></i></a>
                  </div>
              	</div>
              </div>
              <div id="sysappiaahot" name="sysappiaahot"></div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?> #sysappiaaprv").on("change",function(){
      $("#<?= $lv_sec; ?> #sysappiaaprv ")
    });
    
    //diccionario de variables en el campo mensaje
    $("#<?= $lv_sec; ?> #hlpVar").click(function(){
      var lv_dat = "<div><table class='table'><tbody>"
      		+"<tr><td colspan=2 class='bg-primary'><b>Recursos Humanos</b></td></tr>"
      		+"<tr><td class='text-center'>@@HHR_WRK_STE_DES</td><td>Organigrama. Puestos de Trabajo. Asistente para mejorar la descripcion del puesto de trabajo.</td></tr>"
      		+"<tr><td class='text-center'>@@HHR_WRK_STE_SKI</td><td>Organigrama. Puestos de Trabajo. Asistente para detemrinar habilidades requeridas en funcion de la descripcion del puesto de trabajo.</td></tr>"
      		+"</tbody></table></div>";
      BootstrapDialog.show({
        title: "<?= $vew_lang->information; ?>",
        message: $(lv_dat),
        closable: true,
        draggable: true,
      });
    })    
  </script>
	<script>
  	// A C T I V A C I O N E S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_hotdocact != undefined ) {
				if ( prop=="icn" ) {
          let lv_class="btn-default";
					var lv_data = <?= $lv_sec; ?>_hotdocact.getDataAtRowProp( row, "sysappiaaactprmppt" );
					if( lv_data!="" && lv_data!=null && lv_data!=undefined ) { lv_class="btn-success"; }
					var lv_data2 = <?= $lv_sec; ?>_hotdocact.getDataAtRowProp( row, "sysappiaaactprmjsn" );
					if( lv_data2!="" && lv_data2!=null && lv_data2!=undefined ) { lv_class="btn-success"; }
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showParameters("+row+");' class='btn "+lv_class+" btn-sm'><i class='fa fa-ellipsis-h'></i></a>";
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotactdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysappiaahot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>,
			colHeaders: [ "<?= $vew_lang->use; ?>", "<?= $vew_lang->key; ?>", "<?= $vew_lang->parameters; ?>", "<?= $vew_lang->usercontrol; ?>" ],
			columns: [
        {type: "checkbox", data: "sysappiaaactuse", width: 10, className: "htCenter" <?= ($vew_readonly ? ', readOnly: true' : ''); ?>},
        {type: "text", data: "sysappiaaacttxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ? ', readOnly: true' : ''); ?> },
				{type: "text", data: "icn", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false },
        {type: "text", data: "sysappiaaactatr", width: 22, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ? ', readOnly: true' : ''); ?>}
			]
		};
    
		var <?= $lv_sec; ?>_hotdocact;
    tmssLoadScript("handsontable", function () {
      tmssCallProcessNoBackdrop( "?prg=sysappiaaact&act=tasklist&prm_vewcod=VEW_SYS_APP_IAA", [], function (data) {
          const lv_sysappiaaact = data.data || [];
          const lv_sysappiaauac = <?= json_encode( json_decode($vew_data->sysappiaauac, true) ?? [], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES ); ?>;

          // indexo las activaciones asignadas por código externo
          const lv_uacidx = {};
          lv_sysappiaauac.forEach(row => { if (row.SysAppIaaActCodExt) { lv_uacidx[row.SysAppIaaActCodExt] = row; } });

          // merge final
          const lv_dat = lv_sysappiaaact.map(lv_sysact => {
            const lv_uac = lv_uacidx[lv_sysact.sysappiaaactcodext];
						
            return {
              sysappiaaactuse: !!lv_uac,
              sysappiaaactcod: lv_sysact.sysappiaaactcod,
              sysappiaacod: lv_sysact.sysappiaacod,
              sysappiaaactcodext: lv_sysact.sysappiaaactcodext,
              sysappiaaacttxt: lv_sysact.sysappiaaacttxt,
              sysappiaaactprmppt: lv_sysact.sysappiaaactprmppt,
              sysappiaaactprmjsn: lv_sysact.sysappiaaactprmjsn ?? {},
              sysappiaaactatr: lv_uac?.SysAppIaaActAtr ?? lv_sysact.sysappiaaactatr ?? {}
            };
          });
          
          <?= $lv_sec; ?>_hotdocact = new Handsontable( <?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset );
          <?= $lv_sec; ?>_hotdocact.loadData(lv_dat);
          <?= $lv_sec; ?>_hotdocact.render();
        }
      );
    });
        
    function <?= $lv_sec; ?>_showParameters(lp_row){
      var lv_pmt = <?= $lv_sec; ?>_hotdocact.getDataAtRowProp(lp_row,"sysappiaaactprmppt");
      var lv_prm = <?= $lv_sec; ?>_hotdocact.getDataAtRowProp(lp_row,"sysappiaaactprmjsn");
      if(lv_pmt==null || lv_pmt==undefined){ lv_pmt=""; }
      let lv_frm = 	"<div>"
                    	+"<div class='form-group'><label class='control-label'>Prompt Model (Texto)</label><div><textarea id='sysappiaaactprmppt' name='sysappiaaactprmppt' rows='5' class='form-control tmssAlwaysEnabled'></textarea></div></div>"
                    	+"<div class='form-group'><label class='control-label'>Parametros (JSON)</label><div><textarea id='sysappiaaactprmjsn' name='sysappiaaactprmjsn' rows='5' class='form-control tmssAlwaysEnabled'></textarea></div></div>"
                  	+"</div>";
      BootstrapDialog.show({
        title: "<?= $vew_lang->parameters; ?>",
        message: $(lv_frm),
        draggable: true,
        closable: true,
        size: BootstrapDialog.SIZE_WIDE,
        buttons: [<?php if(!$vew_readonly){ ?>  
                    {	id:"btn-accept", label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                      let lv_dat = dialog.$modalBody.find("#sysappiaaactprmppt").val();
                      <?= $lv_sec; ?>_hotdocact.setDataAtRowProp(lp_row, "sysappiaaactprmppt", lv_dat);
                      let lv_dat2 = dialog.$modalBody.find("#sysappiaaactprmjsn").val();
                      <?= $lv_sec; ?>_hotdocact.setDataAtRowProp(lp_row, "sysappiaaactprmjsn", lv_dat2);
                      dialog.close();
                      }
                    }
                  <?php } ?>],
      	onshow: function(dialog){
          dialog.$modalBody.find("#sysappiaaactprmppt").text( lv_pmt );
          dialog.$modalBody.find("#sysappiaaactprmjsn").text( lv_prm );
        }
      });
    }

	</script>
  <script>
    // función para diferenciar entre filas automáticas y filas configuradas por el usuario
    function  <?= $lv_sec; ?>_isEmptyHotRow(lp_row) {
      return Object.values(lp_row).every(v =>
        v === null || v === undefined || v === ""
      );
    }
    
  	function <?= $lv_sec; ?>_fncext( lp_prm ) {
      var lv_err = true;
      <?= $lv_sec; ?>_hotdocact.deselectCell();
      var lo_dat = <?= $lv_sec; ?>_hotdocact.getSourceData();
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				// obtengo datos de handsontable
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
          // si es una fila vacía automática, no la tengo en cuenta para la validación
          if ( <?= $lv_sec; ?>_isEmptyHotRow(lo_dat[i]) ){
            continue;
          }
          
          // solo pusheo las filas que estén checkeadas por el usuario
          if ( lo_dat[i]["sysappiaaacttxt"] !== undefined && lo_dat[i]["sysappiaaacttxt"] !== "" && lo_dat[i]["sysappiaaactuse"] ) {
            lv_arr.push({
                "sysappiaaactcod": lo_dat[i]["sysappiaaactcod"],
                "sysappiaaactcodext": lo_dat[i]["sysappiaaactcodext"],
                "sysappiaaacttxt": lo_dat[i]["sysappiaaacttxt"],
                "sysappiaaactatr":  JSON.parse(lo_dat[i]["sysappiaaactatr"])
            });
					}else if (lo_dat.length > 0){
            toastr.warning("Complete el nombre de la activaci&oacute;n."); return false;
          }
				}
				
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysappiaauac").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #sysappiaauac").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
  </script>
 	<?php include('grldocfrmscr.frm'); ?>
</section>