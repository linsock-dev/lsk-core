<?php		
	// url del formulario
  $lv_lnk = "?prg=syslng&prm_lngcod=".$vew_data->lngcod; 

	// campos requeridos
	$vew_input->RequiredFields( array('lngcod','lngcodsve','lngtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->lngcod; 

	// titulo
	$lv_title = $vew_lang->language;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'LNG';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php include('grldocfrmtlb.frm'); ?>  
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea class="hidden" id="syslngtxt" name="syslngtxt"></textarea>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->lngcod; ?><?= gethtml('lngcod','hidden',$vew_data->lngcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->language; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    if($vew_actcod=='01'){echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('lngcodsve', 'doccmt1x20', '', $lv_default) ));}
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('lngtxt', 'doccmt1x50', $vew_data->lngtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="form-group tmss-form-group">
                    <div class="col-xs-9"><input type="text" class="form-control tmssAlwaysEnabled" placeholder="Buscar..." id="lngtxtfnd" name="lngtxtfnd" value=""></div>
                    <div class="col-xs-3">
                      <?php if(!$vew_readonly){ ?><a href="#" class="btn btn-success" id="btnadd"><i class="fas fa-plus"></i></a><?php } ?>
                      <span id="count" class="pull-right"><strong><?= count($vew_data->txt); ?></strong></span>
                    </div>
                	</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <table class="table table-condensed table-hover tmss-vertbl-scroll" id="tmssTable">
                    <thead><tr><th class="wdt-250"><?= $vew_lang->key; ?></th><th class="wdt-650"><?= $vew_lang->text; ?></th></tr></thead>
                    <tbody><?php $lv_arr=$vew_data->txt; asort($lv_arr); foreach($lv_arr as $lv_key=>$lv_val){ echo '<tr data-key="'.$lv_key.'"><td>'.$lv_key.'</td><td>'.htmlentities($lv_val).'</td></tr>'; } ?></tbody>
                  </table>
                </div>
              </div><!-- /card -->
						</div><!-- /col -->
					</div><!-- /row -->
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		// busqueda
		$("#<?= $lv_sec; ?> #lngtxtfnd").on("keyup",function(e){
			var lv_found;
			var lv_count=0;
		  var lv_txt = $("#<?= $lv_sec; ?> #lngtxtfnd").prop("value").toUpperCase();
			$("#<?= $lv_sec; ?> #tmssTable > tbody > tr").each(function(){
				lv_found = false;
				$(this).find("td").each(function(){
					if($(this).text().toUpperCase().indexOf(lv_txt)>-1){ lv_found=true; }
				});
				if(lv_found==false && lv_txt!=""){
					$(this).addClass("hidden");
				} else {
					$(this).removeClass("hidden");
					lv_count++;
				}
		  });
			$("#<?= $lv_sec; ?> #count").text( lv_count );
		});	

		<?php if(!$vew_readonly){ ?>
		$(function(){
			$("#<?= $lv_sec; ?> #tmssTable tbody tr").on("click",function(){
				<?= $lv_sec; ?>_showDialog( "02", $(this).find("td:first").text(), $(this).find("td:last").text() );
			});
		});

		// btnadd
		$("#<?= $lv_sec; ?> #btnadd").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_showDialog( "01", "", $("#<?= $lv_sec; ?> #lngtxtfnd").prop("value") );
		});
				
		function <?= $lv_sec; ?>_showDialog( lp_act, lp_lngvar, lp_lngvartxt ){
			var lv_msg = "";
			lv_msg += "<div>";
			lv_msg += "<div class='form-group tmss-form-group'><label class='col-xs-2 control-label'><?= $vew_lang->variable; ?></label><div class='col-xs-10'><input type='text' class='form-control' id='lngvar' value='"+lp_lngvar+"' "+(lp_lngvar!=""?"readonly='readonly'":"")+"></div></div>";
			lv_msg += "<div class='form-group  tmss-form-group'><label class='col-xs-2 control-label'><?= $vew_lang->text; ?></label><div class='col-xs-10'><input type='text' class='form-control' id='lngvartxt' value='"+lp_lngvartxt+"'></div></div>";
			lv_msg += "</div>";
			BootstrapDialog.show({
				title: "<?= $vew_lang->translation; ?>",
				message: $(lv_msg),
				buttons: [{	label: "Borrar", cssClass: "btn-warning pull-left",	action: function(dialogItself){
											var lv_lngvar = dialogItself.getModalBody().find("#lngvar").prop("value");
											if(lv_lngvar!=""){ $("#<?= $lv_sec; ?> #tmssTable tbody tr[data-key='"+lv_lngvar+"']").remove(); }
          						dialogItself.close();
									}},
									{ label: "Cancelar", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "Aceptar", cssClass: "btn-success",	action: function(dialogItself){
												var lv_lngvar = dialogItself.getModalBody().find("#lngvar").prop("value");
												var lv_lngvartxt = dialogItself.getModalBody().find("#lngvartxt").prop("value");
												if ( lv_lngvar.trim()=="" ) { toastr.warning("Debe indicar una variable.");
												} else if ( lv_lngvartxt.trim()=="" ) { toastr.warning("Debe indicar una traducci&oacute;n.");
												} else if ( lp_act=="01" ) {
													if( $("#<?= $lv_sec; ?> #tmssTable tbody tr[data-key='"+lv_lngvar.trim()+"']").length>0 ) { toastr.warning("La traducci&oacute;n ya existe.");
													} else { $("<tr data-key='"+lv_lngvar+"'><td>"+lv_lngvar+"</td><td>"+lv_lngvartxt+"</td></tr>").appendTo( $("#<?= $lv_sec; ?> #tmssTable tbody") ); dialogItself.close(); }
												} else if ( lp_act=="02" ) {
													$("#<?= $lv_sec; ?> #tmssTable tbody tr[data-key='"+lv_lngvar.trim()+"'] td:last").html(lv_lngvartxt); dialogItself.close();
												}
											}
										}]
			});
		}
		<?php } ?>
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
    	if(lp_prm["action"]=="00"){
        var lv_buffer = [];
        $("#<?= $lv_sec; ?> #tmssTable tbody tr").each(function(){
          lv_buffer.push( {"name":$(this).find("td:first").html().trim().toLowerCase(),"value":$(this).find("td:last").html().trim()} );
        })
        $("#<?= $lv_sec; ?> #syslngtxt").text( JSON.stringify(lv_buffer) );
        
        <?php if($vew_actcod=='01'){?>
        	$("#<?= $lv_sec; ?> #lngcod").prop( "value", $("#<?= $lv_sec; ?> #lngcodsve").val() );
      	<?php } ?>
        
      }
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>  
</section>