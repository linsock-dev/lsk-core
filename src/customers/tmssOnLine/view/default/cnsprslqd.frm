<?php
	// url del formulario
  $lv_lnk = "?prg=cnsprslqd&prm_cnsprslqdcod=".$vew_data->cnsprslqdcod;

	// campos requeridos
	$vew_input->RequiredFields( array('cnsprslqddte','cnsprslqdtxt','srcobjtxt', 'srcobjcod001','cnsprslqdstrdte','cnsprslqdenddte', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->cnsprslqdcod;

	// titulo
	$lv_title = $vew_lang->liquidation;
	
	// módulo y programa
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'LQP';

	// librería de estilos bootstrap
	include_once('_library.frm');
	
	/* valores x default */
	if ( $vew_data->cnsprslqdcod=='' && $vew_readonly==false ) {
		$vew_data->cnsprslqddte = date('d/m/Y');
		$vew_data->docsts = 'A';
		
		$lv_curdte = new DateTime( date('Y-m-d') );
		if ( $lv_curdte->format('d')>10 ) {
			$lv_strdte = new DateTime(date('Y-m-d'));
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_strdte->modify('first day of this month');
			$lv_enddte->modify('last day of this month');
		} else {
			$lv_strdte = new DateTime(date('Y-m-d'));
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_strdte->modify('first day of last month');
			$lv_enddte->modify('last day of last month');
		}

		$vew_data->cnsprslqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->cnsprslqdenddte = $lv_enddte->format('d/m/Y');		
	} 
  // si no se hace una copia del array, no se puede modificar
    $lo_srv =is_array($vew_data->srv)?$vew_data->srv:array();	
	
	$lv_prnfrm = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'print_form');	
	$lv_cusdaturl = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'cnsprslqdcusurl');
	
	// BOTONES
	$vew_tbl['modL'] = array('pos'=>'L','per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'ttl'=>$vew_lang->modify);
	$vew_tbl['delL'] = array('pos'=>'L','per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'14'), 'ttl'=>$vew_lang->delete,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'14'.chr(39).'});');
	$vew_tbl['accL'] = array('pos'=>'L','per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'ttl'=>$vew_lang->accounting,'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['prn'] = array('pos'=>'L','per'=>$vew_data->docsts=='C' && $lv_prnfrm!='', 'ttl'=>$vew_lang->print, 'id'=>'btnprn','icn'=>'fas fa-print','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit','acc'=>'');
	$vew_tbl['nxtL'] = array('pos'=>'L', 'per'=>true, 'id'=>'btnnxt1', 'ttl'=>$vew_lang->data, 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-desk-btn','acc'=>''); 
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('srcobjtyp','hidden','CNS_TSK'); ?>

		<textarea id="cnsprslqdopnsrvids" name="cnsprslqdopnsrvids" class="hidden"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->cnsprslqdcod; ?><?= gethtml('cnsprslqdcod','hidden',$vew_data->cnsprslqdcod); ?></strong></h4></li>
			</ul>
      
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->LIQUIDATION; ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?> 
                    </span> 
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('cnsprslqdtxt', 'doccmt1x50', $vew_data->cnsprslqdtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->squad , 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->srcobjcod001==''?$vew_readonly:true) ), array('input'=>gethtml('srcobjtxt', 'doccmt1x50', $vew_data->srcobjtxt, ($vew_data->cnsprslqdcod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo gethtml('srcobjcod001', 'hidden',	$vew_data->srcobjcod001);
                  	echo vew_boot($lv_col255, array('label'=>$vew_lang->status,	
																								'input1'=>gethtml('docsts', ($vew_readonly?'docstsacc':'docsts'),	$vew_data->docsts, $lv_default),
																								'input2'=>'<h4 style="margin-top: 8px; margin-bottom: 5px;" class="'.($vew_data->sysdoctrecod=='C'?'text-success':($vew_data->sysdoctrecod=='P'?'text-warning':'')).'">'.strtoupper($vew_data->sysdoctretxt).'</h4>' 
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
                    <span class="tmss-card-icon">
                      <i class="fas fa-dollar-sign"></i>
                    </span>	
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col244, array('label'=>$vew_lang->date, 'input'=>gethtml('cnsprslqddte', 'docdte', $vew_data->cnsprslqddte, ($vew_data->cnsprslqdcod==''?$lv_default:$lv_always_disabled) ) ));
                		echo vew_boot($lv_col255, array('label'=>$vew_lang->period, 'input'=>gethtml('cnsprslqdstrdte',	'docdte',	$vew_data->cnsprslqdstrdte,	$lv_default), 'input2'=>gethtml('cnsprslqdenddte',	'docdte',	$vew_data->cnsprslqdenddte,	$lv_default) ));
                  ?>
                </div>
              </div>
            </div> <!-- /col-6 -->
					</div>
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <?= $lv_title; ?>
                <span class="tmss-card-icon font-weight-bold" id="cnsprslqdtot">
                  <strong><?= number_format(floatval($vew_data->cnsprslqdtot),2,',','.'); ?></strong>
                </span>
              </div>
            </div>
            <div class="card-body tmss-card-body-edt">
              <table class="table table-condensed table-hover" id="opnsrvtbl">
                <thead>
                  <tr>
                    <th><?= ($vew_readonly?'':'<input type="checkbox" id="itmchkhdr">'); ?></th>
                    <th width="100" >Obra</th>
                    <th width="100" >Fecha</th>
                    <th width="100" >Tarea</th>
                    <th>Descripci&oacute;n</th>
                    <th width="100" >Cantidad</th>
                    <th width="100" >Unidad</th>
                    <th width="150" class="text-right">Importe</th>
                    <th width="100" class="text-right">Recargo</th>
                    <th width="150" class="text-right">SubTotal</th>
                  </tr>
                </thead>
                <tbody>
                  <?php
							$lv_buffer = '';
							foreach( $lo_srv as $lv_row ){
                $lv_dat=json_decode($lv_row['cnsprslqddocatr001']);
								$lv_buffer .= '<tr class="bg-secondary">
                                <td><input type="checkbox" name="itmchk" class="'.($vew_readonly?'hidden':'').'"
                                            data-refobjtyp="' . $lv_row['refobjtyp'] . '"
                                            data-refobjcod001="' . $lv_row['refobjcod001'] . '"
                                            data-refobjcod002="' . $lv_row['refobjcod002'] . '"
                                            data-cnsprslqddocqty="' . $lv_row['cnsprslqddocqty'] . '"
                                            data-matuntcod="' . $lv_row['matuntcod'] . '"
                                            data-cnsprslqddocprc="' . $lv_row['cnsprslqddocprc'] . '"
                                            data-cnsprslqddoctot="' . $lv_row['cnsprslqddoctot'] . '"
                                            data-cnsprslqddocatr001="' . htmlspecialchars($lv_row['cnsprslqddocatr001']) . '"
                                          ></td>
                                <td>' . ($lv_row['stetxt']??'') . '</td>
                                <td>' . ($lv_row['steevtdtetxt']??'') . '</td>
                                <td>' . $lv_row['tskcodext'] . '</td>
                                <td>' . $lv_row['tsktxt'] . '</td>
                                <td>' . number_format($lv_row['cnsprslqddocqty'], 0) . '</td>
                                <td>' . $lv_row['matuntcod'] . '</td>
                                <td class="text-right">' . number_format($lv_row['cnsprslqddocprc'], 2) . '</td>
                                <td class="text-right">' . number_format($lv_row['tskrec'], 2) . '</td>
                                <td class="text-right">' . number_format($lv_row['cnsprslqddoctot'], 2) . '</td>
                              </tr>
                              ';
							}
							echo $lv_buffer;
						?>
                </tbody>
              </table>
            </div> <!-- /card-body -->
          </div> <!-- /card -->
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		function <?= $lv_sec; ?>_calcTotal() {
      var lv_srvids = "";
      var lv_srvtot = 0;
      var lv_srvdoc = [];
      var lv_tot = 0;
      //obtengo prestaciones marcadas 
      $("#<?= $lv_sec; ?> #opnsrvtbl tbody tr td input[name='itmchk']:checked").each(function(){
        lv_tot += $(this).data("cnsprslqddoctot");

        lv_srvdoc.push({ 
          "cnsprslqddoccod":$(this).data("cnsprslqddoccod"),
          "refobjtyp":$(this).data("refobjtyp"),
          "refobjcod001":$(this).data("refobjcod001"),
          "refobjcod002":$(this).data("refobjcod002"),
          "cnsprslqddocqty":$(this).data("cnsprslqddocqty"),
          "matuntcod":$(this).data("matuntcod"),
          "cnsprslqddocprc":$(this).data("cnsprslqddocprc"),
          "cnsprslqddoctot":$(this).data("cnsprslqddoctot"),
          "cnsprslqddocatr001":JSON.stringify($(this).data("cnsprslqddocatr001"))                       
          });
     	});
      $("#<?= $lv_sec; ?> #cnsprslqdopnsrvids").text( JSON.stringify(lv_srvdoc) );
      $("#<?= $lv_sec; ?> #cnsprslqdtot").text( Number(lv_tot).toLocaleString() );
    }
    
    var lv_hdrchk = false;
    // prestaciones checkbox - cabecera
    $("#<?= $lv_sec; ?> #itmchkhdr").on("change",function(e){e.preventDefault();
      lv_hdrchk = true;
      $("#<?= $lv_sec; ?> #opnsrvtbl tbody tr td input[name='itmchk']").prop("checked", $(this).is(":checked") ).trigger("change"); 
      <?= $lv_sec; ?>_calcTotal();
      lv_hdrchk = false;
    });

		// DATOS
		$("#<?= $lv_sec; ?> #btnnxt1").on("click", function(e) {
			// valido datos mínimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
      
			// obtener datos
			var lv_pstdat = $("#<?= $lv_sec; ?>_frm").serializeArray();
			lv_pstdat.push({name:"srcobjcod001",value:$("#<?= $lv_sec; ?> #srcobjcod001").val()},
                     {name:"sec",value:"<?= $lv_sec; ?>"},
										{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>});
			tmssCallProcess("?prg=cnsprslqd&act=23",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #opnsrvtbl tbody").empty();
        var lv_dat;
        data.data.forEach(function(lp_row) {
          lv_dat = JSON.parse(lp_row.steevtdocatr);
          let lv_row = $(`<tr class="bg-secondary">
														<td><input type="checkbox" name="itmchk"  ${(lp_row.cnsprslqddoccod??"")!=""?"checked":""}
															data-refobjtyp="CNS_EVT"
															data-refobjcod001=${lp_row.steevtdoccod}
															data-refobjcod002=${lp_row.steevtcod}
															data-cnsprslqddocqty=${lv_dat.tskqty}
															data-matuntcod=${lv_dat.tskuntcod}
															data-cnsprslqddocprc=${lv_dat.tskprc}
															data-cnsprslqddoctot=${lv_dat.tsktot}
															data-cnsprslqddocatr001
														></td>
														<td>${lp_row.stetxt}</td>
                            <td>${lp_row.steevtdtetxt}</td>
                            <td>${lv_dat.tskcodext}</td>
                            <td>${lv_dat.tsktxt}</td>
                            <td>${Number(lv_dat.tskqty)}</td>
                            <td>${lv_dat.tskuntcod}</td>
                            <td class="text-right">${Number(lv_dat.tskprc).toLocaleString()}</td>
                            <td class="text-right">${Number(lv_dat.tskrec).toFixed(2)}</td>
                            <td class="text-right">${Number(lv_dat.tsktot).toLocaleString()}</td>
                          </tr>`);
          $(lv_row).find("input").attr("data-cnsprslqddocatr001", lp_row.steevtdocatr);

          $("#<?= $lv_sec; ?> #opnsrvtbl tbody").append(lv_row);
        });
        
        // adjunto evento para checkbox
        $("#<?= $lv_sec; ?> #opnsrvtbl input:checkbox").on("change",function(e){ 
          if($(this).is($(this).parents("table").find(":checkbox:first"))){ 
            $(this).parents("table").find(":checkbox").prop("checked", $(this).prop("checked"));
          }else{
            $(this).parents("table").find(":checkbox:first").prop("checked", $(this).parents("table").find(":checkbox:not(:first):checked").length-1 == $(this).parents("table").find(":checkbox:not(:first)").length-1);
          }
          <?= $lv_sec; ?>_calcTotal();
        });
        
        $("#<?= $lv_sec; ?> #itmchkhdr").prop("checked", $("#<?= $lv_sec; ?> #opnsrvtbl").find("tbody :checkbox:checked").length == $("#<?= $lv_sec; ?> #opnsrvtbl").find("tbody :checkbox").length && $("#<?= $lv_sec; ?> #opnsrvtbl").find("tbody :checkbox").length);
        
        <?= $lv_sec; ?>_calcTotal();
			});
		});
		
    
		// CONTABILIZAR
		function <?= $lv_sec; ?>_accounting() {
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "¿Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		}
		
		// IMPRIMIR
		$("#<?= $lv_sec; ?> #btnprn").on("click",function(e){
			// mostrar formulario
			window.open("<?= $lv_prnfrm; ?>&prm_cnsprslqdcod="+$("#<?= $lv_sec; ?> #cnsprslqdcod").prop("value") );
		});
		
		<?php if ($vew_data->cnsprslqdcod!='' && $vew_actcod=='02' ) { ?>
			$("#<?= $lv_sec; ?> #btnnxt1").trigger("click");
		<?php } ?>
	</script>
	<script>		
		// cnstsktxt
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"srcobjtxt" : "cnstsktxt", "srcobjcod001" : "cnstskcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "cnstsk", lo_get);
    
		// curcod
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"curcod" : "curcod"}, "typeahead":false }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";
    // server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				}else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>