<?php
	// url del formulario 
  $lv_lnk = "?prg=sysint&prm_sysintcod=".$vew_data->sysintcod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysinttxt','sysinturl','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysintcod;

	// titulo
	$lv_title = $vew_lang->parameters;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'ITZ';

	// librer?a de estilos bootstrap
	include_once('_library.frm');

	$lv_inturl = $vew_doc->getTagValue($vew_data->sysintatr,'int_url');
	
	if ($vew_sec->hasPermission('SYS','ITV','03')) {
		$vew_tbl['cnvL'] = array('pos'=>'L', 'per'=>true, 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'icn'=>'far fa-star-half','id'=>'btnsysitv', 'acc'=>'', 'ttl'=>$vew_lang->conversions);	
		$vew_tbl['cnvR'] = array('pos'=>'R', 'per'=>true, 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'icn'=>'far fa-star-half','id'=>'btnsysitv', 'acc'=>'', 'ttl'=>$vew_lang->conversions);	
	}

	if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,10) ){
    $vew_tbl['exeL'] = array('pos'=>'L', 'per'=>true, 'css'=>'btn navbar-btn btn-success tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'icn'=>'far fa-flag','id'=>'btnexeL', 'acc'=>'', 'ttl'=>$vew_lang->execute);	
    $vew_tbl['exeR'] = array('pos'=>'R', 'per'=>true, 'css'=>'btn navbar-btn btn-success tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'icn'=>'far fa-flag','id'=>'btnexeR', 'acc'=>'', 'ttl'=>$vew_lang->execute);	
  }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysintcod; ?><?= gethtml('sysintcod','hidden',$vew_data->sysintcod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->interface; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('sysintcodext','doccmt1x20', $vew_data->sysintcodext,$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysinttxt',	'doccmt1x50',	$vew_data->sysinttxt,	$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->url,        'input'=>gethtml('sysinturl','doccmt1x400',$vew_data->sysinturl,$lv_default)));
										echo vew_boot($lv_col210, array('label'=>'e-mails errores', 'input'=>gethtml('sysinterrntf','doccmt5x50',$vew_data->sysinterrntf,$lv_default)));
                  	echo vew_boot($lv_col210, array('label'=>'', 'input'=>'<small>Indicar una direccion de correo por linea</small>'));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div>
                            
							<div class="card">
								<div class="card-header"><div class="card-title">LOGS<a class="card-icon" id="btnlogrfh" title="<?= $vew_lang->refresh; ?>"><i class="far fa-refresh"></i></a></div></div>
								<div class="card-body tmss-card-body-edit" style="max-height:400px;overflow-y:scroll;">
									<table class="table table-condensed table-bordered" id="tbllog">
										<thead><tr><th width="50"><?= $vew_lang->type; ?></th><th width="150"><?= $vew_lang->date; ?></th><th><?= $vew_lang->description; ?></th></tr></thead>
										<tbody></tbody>
									</table>
								</div>
							</div>
              
						</div><!-- /col-md-6 -->
						<div class="col-md-6">
              
							<div class="card tmss-hot-ttl">
								<div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
							</div>
              <textarea id="sysintatr" name="sysintatr" class="hidden"></textarea>
              <div id="sysintatrhot" name="sysintatrhot"></div>								

              <div class="card">
								<div class="card-header">
                  <div class="card-title"><?= $vew_lang->frequency; ?>
                    <?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && $vew_actcod!='01' && $vew_actcod!='001' ){?> 
                    	<a class="card-icon" id="btnfrqrfh" title="<?= $vew_lang->refresh; ?>"><i class="far fa-refresh"></i></a>
                    	<a class="card-icon" id="btnaddfrq" title="a&ntilde;adir frecuencia"><i class="fas fa-plus "></i></a>
                    	<a class="card-icon hidden" id="btndltfrq" title="remover frecuencia/s"><i class="fas fa-trash"></i></a>
                    <?php }?>
                  </div>
                </div>
								<div class="card-body tmss-card-body-edit">
									<table class="table table-condensed" id="tblfrq">
										<thead><tr><th><?= $vew_lang->frequency; ?></th><th width="50"></th></tr></thead>
										<tbody></tbody>
									</table>
                </div>
							</div>
              
						</div>
					</div>
				</div> <!-- /tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    // FREQUENCY - REFRESH
    $("#<?= $lv_sec; ?> #btnfrqrfh").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> #tblfrq tbody").empty().append("<tr><td colspan=9 class='text-center'><i class='far fa-spinner fa-spin'></i></td></tr>");
      var lv_pstdat = [{name:"srcobjtyp",value:"SYS_INT"},{name:"srcobjcod",value:"<?= $vew_data->sysintcod; ?>"}];
      tmssCallProcessNoBackdrop("?prg=sysint&act=getFrequencyList",lv_pstdat,function(data){
      	$("#<?= $lv_sec; ?> #tblfrq tbody").empty();
        if(data.length==0){
        	var lv_buffer = "<tr><td colspan=9 class='text-center'><b>No se encontraron registros.</b></td></tr>";
			    $("#<?= $lv_sec; ?> #tblfrq tbody").append( lv_buffer );
        } else {
          for(var i=0; i<data.length; i++){
            /*
                  if($vew_data->lstfrq!=NULL && $vew_data->lstfrq!=array())
                    foreach($vew_data->lstfrq as $lv_row){		
                      echo '<div class="form-group tmss-form-group sysintfrq">'
                              .'<div class="col-xs-1 '.($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'':'hidden').'"><input type="checkbox"></div>'
                              .'<a href="#"  class="col-xs-11 " data-tskcod="'.$lv_row['tskcod'].'">'.$lv_row['tsktxt'].'</a>'
                            .'</div>';
                    } 
            */  
          }
        }
      });
    });
    
    function <?= $lv_sec; ?>_refreshLog(){
      $("#<?= $lv_sec; ?> #tbllog tbody").empty().append("<tr><td colspan=9 class='text-center'><i class='far fa-spinner fa-spin'></i></td></tr>");
      var lv_pstdat = [{name:"srcobjtyp",value:"SYS_INT"},{name:"srcobjcod",value:"<?= $vew_data->sysintcod; ?>"}];
      tmssCallProcessNoBackdrop("?prg=sysint&act=getlog",lv_pstdat,function(data){
        var lv_buffer = '';
      	$("#<?= $lv_sec; ?> #tbllog tbody").empty();
        if(data.length==0){
        	var lv_buffer = "<tr><td colspan=9 class='text-center'><b>No se encontraron registros.</b></td></tr>";
			    $("#<?= $lv_sec; ?> #tbllog tbody").append( lv_buffer );
        } else {
          for(var i=0; i<data.length; i++){
            var lv_bg = (data[i].applogerrtyp=="S"?"bg-success":(data[i].applogerrtyp="E"?"bg-danger":"bg-warning"));
            var lv_icon = (data[i].applogerrtyp=="S"?"far fa-check text-success":(data[i].applogerrtyp="E"?"far fa-times text-danger":"far fa-minus text-warning"));
            lv_buffer += "<tr class='"+lv_bg+"'><td class='text-center'><i class='"+lv_icon+"'></i>"
                        +"<td>"+moment(data[i].ctedte.date,"YYYY-MM-DD HH:SS").format("DD.MM.YYYY HH:SS")+"</td>"
                        +"<td>"+data[i].applogerrcod+" - "+data[i].applogerrtxt
                          +"<div name='divapplogtecinf' data-id='"+data[i].applogcod+"' class='container-fluid form-group hidden'>"
                            +"<label class='control-label'>Log extendido</label><textarea class='form-control' readonly='readonly' rows=10>"+data[i].applogtxt+"</textarea>"
                            +"<label class='control-label'>Info Tecnica</label><textarea class='form-control' readonly='readonly' rows=10>"+data[i].applogtecinf+"</textarea>"
                          +"</div>"
                        +"</td>"
                        +"<td width=50><a href='#' class='card-icon' name='btnapplogtecinf' data-id='"+data[i].applogcod+"'><i class='fas fa-ellipsis-h-alt'></i></a></td>"
                        +"</tr>";
          }
			    $("#<?= $lv_sec; ?> #tbllog tbody").append( lv_buffer );
          $("#<?= $lv_sec; ?> a[name=btnapplogtecinf]").on("click",function(e){e.preventDefault();
          	var lv_data = $("#<?= $lv_sec; ?> div[name=divapplogtecinf][data-id='"+$(this).data("id")+"']").clone().removeClass("hidden");
            BootstrapDialog.show({
              title: "<?= $vew_lang->technicalinfo; ?>",
              message: $(lv_data),
              type: BootstrapDialog.TYPE_PRIMARY,
              closable: true,
              draggable: true
            });    
					});
        }
      });    
    }
    // LOGS - REFRESH
    $("#<?= $lv_sec; ?> #btnlogrfh").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_refreshLog(); });
    
    // EXECUTE
		$("#<?= $lv_sec; ?> #btnexeL, #<?= $lv_sec; ?> #btnexeR").on("click",function(e){ e.preventDefault(); 
      BootstrapDialog.confirm({
        title: "Ejecutar Interfaz",
        message:"Desea ejecutar la interfaz ahora ?",
        type: BootstrapDialog.TYPE_WARNING,
        callback: function(result){
          if(result){
            var lv_pstdat = [{name:"sysintcod",value:"<?= $vew_data->sysintcod; ?>"}];
            tmssCallProcessErr( "?prg=sysint&act=10", lv_pstdat , function(data){
              toastr.info("Interfaz ejecutada.");
              <?= $lv_sec; ?>_refreshLog();
            }, function(data){
              toastr.warning("Error al ejecutar la interfaz:<br>"+data.errcod+": "+data.errtxt);
              <?= $lv_sec; ?>_refreshLog();              
            });
          }
        }
      });                                                        
		});    
    
    $(function(){
      <?= $lv_sec; ?>_refreshLog();
      $("#<?= $lv_sec; ?> #btnfrqrfh").trigger("click"); 
    });
  </script>
	<script>
		$("#<?= $lv_sec; ?> #btnsysitv").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [{name:"sysintcod",value:"<?= $vew_data->sysintcod; ?>"}];
			tmssLink("?prg=sysintcnv&act=03",[{target: "_new_section", post_data: lv_pstdat}]);
		});

    // AÑADIR FRECUENCIA
    $("#<?= $lv_sec; ?> #btnaddfrq").on("click",function(e){ e.preventDefault();
      <?= $lv_sec; ?>_openDialog('01',null);
    });
    
    // MODIFICAR FRECUNCIA
    $("#<?= $lv_sec; ?> #frqlst").on("click",".sysintfrq a",function(e){ e.preventDefault();
      actcod="<?=($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'02':'03')?>";
      <?= $lv_sec; ?>_openDialog(actcod,$(this).data("tskcod"));
    });
    
    // REMOVER FREQUENCIA/S
    $("#<?= $lv_sec; ?> #btndltfrq").click(function(e){e.preventDefault();
       $("#<?= $lv_sec; ?> #frqlst .sysintfrq input[type='checkbox']:checked").each((index,chk)=>{
         lv_tskcod=$(chk).parent().parent().find("a").data("tskcod");
       	var lv_pstdat = [{name:"tskcod", value:lv_tskcod }];
				tmssCallProcess("?prg=grldattsk&act="+"04",lv_pstdat,function(data){
          if(data.errcod!=0)toastr.warning("no se pudo borrar alguna frecuencia.");
          else $(chk).parent().parent().remove();
       });               
    	});  
      $("#<?= $lv_sec; ?> #frqlst .sysintfrq input[type='checkbox']:checked").prop('checked', false);
      <?= $lv_sec; ?>_validarCheckbox()    
    });
    
		// CHECK FREQUENCIA
    $("#<?= $lv_sec; ?> #frqlst").on("click",".sysintfrq input[type='checkbox']",<?=$lv_sec; ?>_validarCheckbox);
    function <?= $lv_sec; ?>_validarCheckbox(){
       if($("#<?= $lv_sec; ?> #frqlst .sysintfrq input[type='checkbox']:checked").length>0){
       	$("#<?= $lv_sec; ?> #btndltfrq").removeClass("hidden");
       }else{
        $("#<?= $lv_sec; ?> #btndltfrq").addClass("hidden");
       }
     }
    
    // DIALOG FRECUENCIAS
    function <?= $lv_sec; ?>_openDialog(actcod,tskcod=null){
      var lv_cfg = {};
      lv_cfg["frq"] = ["U","D", "W", "M"];
			lv_cfg["tmetyp"] = "TF";
      //lv_cfg["dtetyp"] = "DS";
      //lv_cfg["readonly"] = "<?= $vew_readonly; ?>";
			var lv_pstdat = [{name:"cfg", value: JSON.stringify(lv_cfg)}, {name:"srcobjtyp", value:"<?=$lv_mdlcod.'_'.$lv_prgcod?>"}, {name:"srcobjcod001", value:"<?=$vew_data->sysintcod?>"}];
      if(tskcod!=null)lv_pstdat.push({name:"tskcod", value:tskcod});
			tmssCallProcess("?prg=grldattsk&act="+actcod,lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->frequency; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
          closable: true,
          draggable: true,
         	buttons: [{ label: "<?=($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') ?$vew_lang->close:$vew_lang->cancel); ?>", cssClass: "btn-default'", action: function(dialog){ dialog.close(); } },
                    {	label: "<?= $vew_lang->save ?>", cssClass: "btn-success <?=($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'':'hidden');?> ",	action: function(dialog){dialog.$modalBody.find("#btnsubmit").trigger("click");}}],
          onhide: function(dialog){
        		//recupero codigo y texto
            lv_tskcod=dialog.$modalBody.find("#tskcod").val();
            lv_tsktxt=dialog.$modalBody.find("#tsktxt").val();
            //actualizo o inserto
            if(lv_tskcod!=""){
              if($("#<?= $lv_sec; ?> .sysintfrq a[data-tskcod="+lv_tskcod+"]").length){
                $("#<?= $lv_sec; ?> .sysintfrq a[data-tskcod="+lv_tskcod+"]").first().text(lv_tsktxt);
              }else{
                <?= $lv_sec; ?>_insertFrequency(lv_tskcod,lv_tsktxt);
              }
            }
          }
				});
    	});
  	}
    
    //insertar frecuencia
    function <?= $lv_sec; ?>_insertFrequency(lp_tskcod,lp_tsktxt){
      $("#frqlst").append("<div class='form-group tmss-form-group sysintfrq'>"
                    +"<div class='col-xs-1 <?=($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'':'hidden');?>'><input type='checkbox'></div>"
                   	+"<a href='#'  class='col-xs-11' data-tskcod='"+lp_tskcod+"'>"+lp_tsktxt+" </a>"
										+"</div>");
    }    
	</script>
	<script>
		var <?= $lv_sec; ?>_hotatr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotatrcnt = $("#<?= $lv_sec; ?> #sysintatrhot")[0];
		var <?= $lv_sec; ?>_hotatrset = {
			height: 200,
			stretchH: "all",
      contextMenu:false,
			autoWrapRow: true,
			rowHeaders: true,
      <?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "Atributo", "Valor" ],
			columns: [
				{	type: "text", data: "intatrcod", width: 100, renderer: <?= $lv_sec; ?>_hotatr_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{	type: "text", data: "intatrval", renderer: <?= $lv_sec; ?>_hotatr_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>
		};
		var <?= $lv_sec; ?>_hotatr;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotatr = new Handsontable(<?= $lv_sec; ?>_hotatrcnt, <?= $lv_sec; ?>_hotatrset);
			var lv_dat = [<?php
        $lv_buffer = '';
				$lv_dat = $vew_doc->getArrayFromXML( $vew_data->sysintatr );
				foreach($lv_dat as $lv_key=>$lv_val){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{intatrcod:"'.$lv_key.'",intatrval:"'.$lv_val.'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotatr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotatr.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) {
				var lo_dat = <?= $lv_sec; ?>_hotatr.getSourceData();
				var lv_buf = "";
				for (var i=0; i<lo_dat.length; i++) {
					if(lo_dat[i]["intatrcod"]!="" && lo_dat[i]["intatrcod"]!=null && lo_dat[i]["intatrcod"]!=undefined){
						lv_buf += "<"+lo_dat[i]["intatrcod"]+">"+(lo_dat[i]["intatrval"]==null ? "" : lo_dat[i]["intatrval"])+"</"+lo_dat[i]["intatrcod"]+">";
					}
				}
				$("#<?= $lv_sec; ?> #sysintatr").text(lv_buf);
			}
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>