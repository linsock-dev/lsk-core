<?php
	// url del formulario
  $lv_lnk = '?prg=grlrptdsg';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->reports;
	
	// módulo y programa
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'RPL';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['sveR']=array('per'=>false);
  $vew_tbl['sveL']=array('per'=>false);
  $vew_tbl['canc']=array('per'=>false);
  $vew_tbl['rfrsh']=array('per'=>true,'pos'=>'','ttl'=>$vew_lang->refresh,'icn'=>'fas fa-sync-alt','css'=>'tmss-Opt','acc'=>$lv_sec.'_fnc({action: '.chr(39).'getreportlist'.chr(39).'});');
?> 
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('rptcod','hidden',''); ?>
		<?= gethtml('rptsys','hidden',''); ?>
    <?= gethtml('vewfldflt','hidden',''); ?>
		
		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
					<div class="card" id="grlrptlst">
						<div class="card-header"><div class="card-title"><?= $vew_lang->reports; ?></div></div>
						<div class="card-body tmss-card-body-edit"></div>				
					</div>
				</div>
				<div class="col-sm-8">
					<div class="card" id="rptfrm">
						<div class="card-header"><div class="card-title" style="text-transform:capitalize;"><?= $vew_lang->reports; ?></div></div>
						<div class="card-body tmss-card-body-edit"></div>				
					</div>
				</div>
			</div>
		</div>
	</form>
	<script>
		var lv_<?= $lv_sec; ?>_rptfltdat=[];
		tmssLoadScript("jstree",function(){
			$("#<?= $lv_sec; ?> #grlrptlst .card-body").jstree({
				"core": { "expand_selected_onload" : false, "themes": {	"responsive": true }, "data": 
					<?php
						// muestro la jerarquia del reporte
						$created_path = array(); 
						$lv_buffer = '[';
						foreach($vew_data as $lv_row){							
							$lv_patharr = explode('\\',$lv_row['rpthietxt']);
							$parent = '#';
							$path = '';
							foreach($lv_patharr as $lv_val) {
								$path .= "#$lv_val";
								if(!in_array($path,$created_path)){
									$lv_buffer .= '{ "id" : "'.$path.'", "parent" : "'.$parent.'", "text" : "'.$lv_val.'", "icon":"far fa-folder" },';
									array_push($created_path,$path);
								}
								$parent = $path;
							}
							$lv_buffer .= '{ "id" : "'.$lv_row['rptcod'].'", "parent" : "'.$parent.'", "text" : "'.$lv_row['rpttxt'].'", "icon":"fas fa-file", "data" : {rptcod: '.$lv_row['rptcod'].', rptsys: '.$lv_row['rptsys'].'} },';
						}
						$lv_buffer .= ']';
						echo $lv_buffer;
					?>
				}
			}).on("select_node.jstree",function(evt, data){
				var lv_title = data.node.text;
				if(data.node.data!=undefined) {
					var lv_pstdat = [{name:"rptcod", value:data.node.data["rptcod"]},
                           {name:"rptsys", value:data.node.data["rptsys"]},
                           {name:"sec", value:"<?= $lv_sec; ?>"}];
          $("#<?= $lv_sec; ?> #rptsys").prop("value", data.node.data["rptsys"]);
					tmssCallProcess("?prg=grlrptdsg&act=getreportdefinition", lv_pstdat, function( data ) {
            if (data.errtyp == "E") {toastr.warning("Ocurrió un error: "+data.errtxt); return;}
						$("#<?= $lv_sec; ?> #rptcod").prop("value",data.rpt.rptcod);
            let lv_vewcod = data.vewcod;
            var lv_btn = "<a href='#' class='card-icon' onclick='<?= $lv_sec; ?>_showReport();' title='<?= $vew_lang->execute; ?>'><i class='far fa-bolt'></i> <?= $vew_lang->execute; ?></a>"
												+"<a href='#' class='card-icon' onclick='<?= $lv_sec; ?>_clearReportFilter();' title='<?= $vew_lang->clear; ?>'><i class='far fa-broom-wide'></i></a>"
												+"<a href='#' class='card-icon' onclick='<?= $lv_sec; ?>_showReportFilters();' title='<?= $vew_lang->filters; ?>'><i class='far fa-ellipsis'></i></a>";
						
            $("#<?= $lv_sec; ?> #rptfrm").data("vewcod",lv_vewcod);
            $("#<?= $lv_sec; ?> #rptfrm .card-body").data("vewfltcod",data.vewfltcod);
            $("#<?= $lv_sec; ?> #rptfrm .card-title").html( lv_title.toLowerCase()+lv_btn );
						
            
						// armo estructura de filtros
						var lv_rptatr = JSON.parse( data.rpt.rptatr );
						var lv_rptflt = JSON.parse( (lv_rptatr.rptflt==""?"[]":lv_rptatr.rptflt) );
						lv_<?= $lv_sec; ?>_rptfltdat = [];
						for(var i=0; i<lv_rptflt.length; i++){
							// busco la definicion del campo
							for(var x=0; x<data.def.length; x++){
                // reviso campo por campo si son filtrables y lo separo del alias
								if( lv_rptflt[i].rptsrccolcod==data.def[x].rptsrccolcod ){
									lv_<?= $lv_sec; ?>_rptfltdat.push( 
                    																	{fldttl: data.def[x].rptsrccoltxt, 
																											fldcod: data.def[x].rptsrccolcodext.toLowerCase(), 
																											fldtyp: data.def[x].sysfldinptyp, 
																											flttyp: "", 
																											fldvalstr: "", 
																											fldvalend: "",
                                                     	isoblfld: lv_rptflt[i].isoblfld}
                                                   );
									break;
								}
							}
						}
						lv_<?= $lv_sec; ?>_rptfltdat.push( {fldttl: "", fldcod: "vewmaxrec", fldtyp: "", flttyp: "", fldvalstr: "100", fldvalend: "", isoblfld:""} );
						
						// muestro filtro en seccion
						tmssFilterShowInline( $("#<?= $lv_sec; ?> #rptfrm .card-body"), lv_<?= $lv_sec; ?>_rptfltdat );					
            
						// Ya viene el filtro por defecto lo aplico
            if (data.vewfldfltdat) {
              $("#<?= $lv_sec; ?> #vewfldflt").val(data.vewfldfltdat);
              tmssFilterSetFormData($("#<?= $lv_sec; ?> #rptfrm .card-body"), data.vewfldfltdat);
            }
					});
				}
			});
		});
    

    // CLEAR REPORT FILTER. vacia el formulario de filtros actual
		function <?= $lv_sec; ?>_clearReportFilter(){
      clearFilterForm( $("#<?= $lv_sec; ?> #rptfrm .card-body") );
    }
    
    
    // SHOW REPORT FILTERS. muestra los filtros grabados para el reporte
    function <?= $lv_sec; ?>_showReportFilters(){
      var lv_frm = $("#<?= $lv_sec; ?> #rptfrm .card-body");
      var lv_vewcod = $("#<?= $lv_sec; ?> #rptfrm").data("vewcod");
      showFilterSaved( lv_vewcod, lv_frm);
    }
    
    
    // SHOW REPORT. ejecuta un reporte
    function <?= $lv_sec; ?>_showReport() {
			var lv_frm = $("#<?= $lv_sec; ?> #rptfrm .card-body");
			var lv_fltdata = tmssFilterGetData( lv_frm );
			var lv_dat = tmssFilterParseToInternal( lv_fltdata );
      var lv_oblflds = lv_fltdata.filter(item => item.isoblfld === "X");
      // recorro el array de campos obligatorios para validar que ninguno de ellos se esté pasando vacío.
      let lv_buffer = [];
      for (var i=0; i<lv_oblflds.length; i++){
      	if ( $("a[data-fldcod='"+lv_oblflds[i].fldcod+"']").parent().next().prop("value") == "" && !$("a[data-fldcod='"+lv_oblflds[i].fldcod+"']").parent().next().prop("disabled") ){
          lv_buffer.push(lv_oblflds[i].fldttl)
        }
      }
      // si alguno de los filtros obligatorios está vacío, advierto al usuario e interrumpo la ejecución
      if ( lv_buffer != "" ){ toastr.warning("Los siguientes filtros son obligatorios: "+lv_buffer.join(', ')+". Por favor, ingrese alg&uacute;n valor para dichos campos."); return; }
			lv_<?= $lv_sec; ?>_rptfltdat = lv_fltdata;
			$("#<?= $lv_sec; ?> #fltcnt").text( (lv_dat["fltqty"]==0?"":lv_dat["fltqty"]) );
			$("#<?= $lv_sec; ?> #vewmaxrec").prop("value", lv_dat["maxrec"]);
      $("#<?= $lv_sec; ?> #vewfldflt").prop("value", lv_dat["fltstr"] );
			var lv_pstdat = $("#<?= $lv_sec; ?>_frm").serializeArray();
      lv_pstdat.push({name: "vewcod", value: $("#<?= $lv_sec; ?> #rptfrm").data("vewcod") });
      lv_pstdat.push({name: "vewfltcod", value: $("#<?= $lv_sec; ?> #rptfrm .card-body").data("vewfltcod") });
      // aplicar sanitización solo a vewfldflt
      for (let i = 0; i < lv_pstdat.length; i++) {
        if (lv_pstdat[i].name === "vewfldflt") {
            lv_pstdat[i].value = <?= $lv_sec; ?>_tmssFixTabs(lv_pstdat[i].value);
            break;
        }
      }
			tmssLink("?prg=grlrptdsg&act=show",[{target:"_new_section",post_data:lv_pstdat}]);
		}
    
    
    function <?= $lv_sec; ?>_tmssFixTabs(lp_str) {
      if (!lp_str) return "";
      return lp_str.replace(/\\t/g, "\t");
    }

    
    function <?= $lv_sec; ?>_fncbckext(data) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="getreportlist") {
					toastr.info("Documento actualizado.");
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
    
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>