 <?php
/* 
VER:
prg:crmcnt act:dsh
Vista
*/
  // url del formulario
  $lv_lnk = "?prg=zcutp1_tmg&act=tkt";

  // campos requeridos
  $vew_input->RequiredFields( array() );

  // titulo
	$lv_title = $vew_lang->Contacts;

  // módulo y programa
  $lv_mdlcod = 'CRM';
  $lv_prgcod = 'CNT';

  // clave del documento
	$lv_dockey = '';

  // librería de estilos bootstrap
  include_once('_library.frm');

	$vew_tbl['rfrsh'] = array('pos'=>'D', 'id'=>'','per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'','icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_GridRefresh();');
	//$vew_tbl['fledwn'] array('pos'=>'D', 'id'=>'','per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'','icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_DownFile();');
	$vew_tbl['fledwn'] = array('pos'=>'D', 'id'=>'','per'=>true, 'ttl'=>'Descargar', 'id'=>'','icn'=>'far fa-download', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_DownFile();');
    
	$vew_tbl['sveL']['per'] = false;
	$vew_tbl['sveR']['per'] = false;
	$vew_tbl['modL']['per'] = false;
	$vew_tbl['modR']['per'] = false;
	$vew_tbl['canc']['per'] = false;
	$vew_tbl['delsep']['per'] = false;
	$vew_tbl['del']['per'] = false;
	$vew_tbl['cpy']['per'] = false;
  $vew_tbl['cpy']['per'] = false;
	$vew_tbl['new']['per'] = false;

  $lv_crmcntper = array(0=>'Hoy',7=>'Semana',30=>'Mes',365=>'A&ntilde;o');
	/* filtro de vista pre establecido */
	$lv_vewfldflt='';
  if ( isset($vew_prm['vewfldflt']) ) {
    $lv_vewfldflt = $vew_prm['vewfldflt'];
    unset($vew_prm['vewfldflt']);try {

    } catch (Exception $e) {

    }
  }

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <!--Temporal -->
    <input type="hidden" id="vewfldord" value="">
		<textarea style="display: none;" id="vewfldflt"></textarea>
    <textarea style="display: none;" id="vewfldfltpre"><?php echo $lv_vewfldflt; ?></textarea>
    <!--Temporal -->
    
    
    <div class="container-fluid">
      
			<div class="row">
				<div class="col-sm-3">
					<!-- Total de contactos -->
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-sky"><i class="fas fa-ticket-alt fa-3x"></i><small><?= ''; ?></small></div>
              <div class="dashboard-info">
                <h4><strong> <?= 'Mis Ticket'; ?> </strong></h4>
                <h3><strong> <?= '20'; ?> </strong></h3>
              </div>
					</div>
				</div>
        
        <div class="col-sm-3">
					<!-- Total de contactos -->
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-yellow"><i class="fas fa-ticket-alt fa-3x"></i><small><?= ''; ?></small></div>
              <div class="dashboard-info">
                <h4><strong> <?= 'Abiertos'; ?> </strong></h4>
                <h3><strong> <?= '6'; ?> </strong></h3>
              </div>
					</div>
				</div>
        
        <div class="col-sm-3">
					<!-- Total de contactos -->
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-red"><i class="fas fa-ticket-alt fa-3x"></i><small><?= ''; ?></small></div>
              <div class="dashboard-info">
                <h4><strong> <?= 'Mis Pendientes'; ?> </strong></h4>
                <h3><strong> <?= '4'; ?> </strong></h3>
              </div>
					</div>
				</div>
        
        <div class="col-sm-3">
					<!-- Total de contactos -->
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-green"><i class="fas fa-ticket-alt fa-3x"></i><small><?= ''; ?></small></div>
              <div class="dashboard-info">
                <h4><strong> <?= 'Finalizados'; ?> </strong></h4>
                <h3><strong> <?= '10'; ?> </strong></h3>
              </div>
					</div>
				</div>
			</div> <!-- /row -->
      <div class="row">
        <!-- contactos cerrados(ultimos 5) -->
				<div class="col-xs-12">
					<div class="card">
						<div class="card-header"><div class="card-title"> HOLA <?= $vew_sec->usrtxt; ?> !</div></div>
						<div class="card-body tmss-card-body-edit">
							<table class="table table-hover table-sm grid">
								<thead>
                  <tr>
                    <th><?= '<a href="#" id="btnnew" onclick=" "  class="btn btn-default navbar-btn" title=""><i class="far fa-file "></i><span class="hidden-xs"> '. $vew_lang->new .'</span></a>'; ?></th>
                    <th><div class="input-group"><input type="TEXT" id="find" name="find" value="" maxlength="250" autocomplete="off" class="form-control"><ul class="typeahead dropdown-menu"></ul><span class="input-group-btn"><a href="#" class="btn btn-default tmssInputBtn" tabindex="-1">&nbsp;<i class="far fa-magnifying-glass"></i></a></span></div></th>
                  </tr>
                </thead>
								<tbody>
									<?php
										$lv_buffer = '';
                  /*
	//									foreach ($vew_data->cnt['cls'] as $lv_row) {
											$lv_buffer.='<tr data-cntcod="1000"><td>'.'<strong># 1000</strong> <br>'
                        					.' Alta de productos y clas. de enfermedad <br>'
                        					.' <div> <span class="label label-default">Temasis</span> <span class="label label-default">Mejora</span></div>'
                        					.'</td>'
                        					.'<td>'
																	.'16-11-2021 <br>'
                        					.'<span class="label label-danger">En proceso</span><br>'
                        					.'</td>'
																	.'</tr>';
//										}
										echo $lv_buffer;
                  	$lv_buffer='<tr data-cntcod="1001"><td>'.'<strong># 1001</strong> <br>'
                        					.' Alta de productos y clas. de enfermedad <br>'
                        					.' <div> <span class="label label-default">Temasis</span> <span class="label label-default">Mejora</span></div>'
                        					.'</td>'
                        					.'<td>'
																	.'16-11-2021 <br>'
                        					.'<span class="label label-success">En proceso</span><br>'
                        					.'</td>'
																	.'</tr>';
//										}
                  	echo $lv_buffer;
                  	$lv_buffer='<tr data-cntcod="1002"><td>'.'<strong># 1002</strong> <br>'
                        					.' Alta de productos y clas. de enfermedad <br>'
                        					.' <div> <span class="label label-default">Temasis</span> <span class="label label-default">Mejora</span></div>'
                        					.'</td>'
                        					.'<td>'
																	.'16-11-2021 <br>'
                        					.'<span class="label label-warning">En proceso</span><br>'
                        					.'</td>'
																	.'</tr>';
//										}
                  	echo $lv_buffer;
                  	$lv_buffer='<tr data-cntcod="1003"><td>'.'<strong># 1003</strong> <br>'
                        					.' Alta de productos y clas. de enfermedad <br>'
                        					.' <div> <span class="label label-default">Temasis</span> <span class="label label-default">Mejora</span></div>'
                        					.'</td>'
                        					.'<td>'
																	.'16-11-2021 <br>'
                        					.'<span class="label label-primary">En proceso</span><br>'
                        					.'</td>'
																	.'</tr>';
//										}
                  */
                  	echo $lv_buffer;
                  	foreach($vew_data->crmcntlst as $lo_crmcntRow){
                      $lv_buffer='<tr data-cntcod="'.$lo_crmcntRow['crmcntcod'].'"><td>'.'<strong># '.$lo_crmcntRow['crmcntcod'].'</strong> <br>'
                        					.$lo_crmcntRow['crmcnttxt'].' <br>'
                        					.' <div> <span class="label label-default">'.$lo_crmcntRow['crmcnttyptxt'].'</span> <span class="label label-default">'.$lo_crmcntRow['crmcntmtvtxt'].'</span></div>'
                        					.'</td>'
                        					.'<td>'
																	.$lo_crmcntRow['crmcntdte'].' <br>'
                        					.'<span class="label label-default" '.$lo_crmcntRow['crmcntclr'].'>'.$lo_crmcntRow['crmcntststxt'].'</span><br>'
                        					.'</td>'
																	.'</tr>';
//										}
                  	echo $lv_buffer;
                      
                    }
									?>
								</tbody>
							</table>
						</div>
					</div>
				</div>
      </div>
		</div> <!-- /container-fluid -->
  </form>
  
  <!-- preferencias -->
	<div class="hidden">
		<div class="container-fluid" id="frmcfg">
			<?php
				echo vew_boot($lv_col39, array('label'=>$vew_lang->responsible,'input'=>gethtml('usrcod', 'doccmt1x50', $vew_data->cnt['cfg']['usrcod'], $lv_default) ));
				echo vew_boot($lv_col39, array('label'=>$vew_lang->period,'input'=>gethtml('strdte',$lv_crmcntper, $vew_data->cnt['cfg']['strdte'], $lv_default) ));
			?>
		</div>
	</div>

	<script>
    var gv_<?php echo $lv_sec; ?>_flt = [
                                        {'fldttl': '<?php echo 'Cliente'; ?>'			, 'fldcod': 'c.custxt'	, 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
                                        {'fldttl': '<?php echo 'Especialidad'; ?>', 'fldcod': 's.spctxt'	, 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
                                        {'fldttl': '<?php echo 'Prestador'; ?>'	 	, 'fldcod': 'p.prstxt'	, 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
                                        {'fldttl': '<?php echo 'Paciente'; ?>'		, 'fldcod': 'p.pattxt'	, 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''}
                                        ];
    function <?= $lv_sec; ?>_DownFile(){
      tmssFilterShowDialog(gv_<?php echo $lv_sec; ?>_flt,<?php echo $lv_sec; ?>_DownLoadEvlZip);
		}
    
    function <?php echo $lv_sec; ?>_DownLoadEvlZip(lp_flt) {
      var lv_fltint;
      if(lp_flt!=null){
        lv_fltint = tmssFilterParseToInternal(lp_flt);
        gv_<?php echo $lv_sec; ?>_flt = lp_flt;
        $("#<?php echo $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
      } else {
        lv_fltint = tmssFilterParseToInternal(gv_<?php echo $lv_sec; ?>_flt);
      }
      if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}
     
      /*
      
      let lv_flt = new Array();
    	lv_flt.push({name:"vewmaxrec",value:lv_fltint["maxrec"]});
      lv_flt.push({name:"vewfldflt",value:lv_fltint["fltstr"]});
      
      tmssLink("?prg=zcutp1&act=tpeevlpntbch", [{post_data:[{name:"vewmaxrec",value:lv_fltint["maxrec"]},{name:"vewfldflt",value:lv_fltint["fltstr"]}],target:"_new_window"}]);
      */
      
      tmssCallProcess("?prg=zcutp1&act=tpeevlpntbch", {vewmaxrec: lv_fltint["maxrec"], vewfldflt: lv_fltint["fltstr"]}, function(data){
        var a = document.createElement('a');
        debugger;
        var url = window.URL.createObjectURL(data);
        a.href = url;
        a.download = 'archivo.zip';
        document.body.append(a);
        a.click();
        a.remove();
        window.URL.revokeObjectURL(url);
      	
      });
    }

		function <?= $lv_sec; ?>_GridRefresh(){
			tmssLink("?prg=zcutp1_tmg&act=tkt", [{target: "_replace_with",target_id: "#<?= $lv_sec; ?>"}]);
		}

		$("#<?= $lv_sec; ?> .grid tbody tr").on("click",function(e){
      e.preventDefault;
      debugger;
			tmssLink("?prg=zcutp1_tmg&act=tkt03&prm_crmcntcod="+$(this).data("cntcod"), [{target: '_new_section',target_id: '#<?= $lv_sec; ?>'}]);
		});
    
    $("#<?= $lv_sec; ?> #btnnew").on("click",function(e){
      e.preventDefault;
      debugger;
			tmssLink("?prg=zcutp1_tpe&act=getosdeapi", [{target: '_new_section',target_id: '#<?= $lv_sec; ?>'}]);
		});

		$("#<?= $lv_sec; ?> #btnpref").on("click",function(e){e.preventDefault
			BootstrapDialog.show({
				title:"<?= $vew_lang->preferences ?>",
				message:$("#<?= $lv_sec; ?> #frmcfg").clone(),
				draggable: true,
				buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
									{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
										var lv_pref = [];
										lv_pref.push( {name:"usrcod", value:dialog.$modalBody.find("#usrcod").val()},{name:"strdte", value:dialog.$modalBody.find("#strdte").val()} );
										tmssLink("?prg=crmcnt&act=dsh&prm_sve=X", [{target: "_replace_with",target_id: "#<?= $lv_sec; ?>",post_data:lv_pref}]);
										dialog.close();
									}}]
			});
		});
	</script>
</section>