<?php		
	// url del formulario
  $lv_lnk = "?prg=syslngtra&prm_lngcod=".$vew_data->lngcod; 

	// campos requeridos
	$vew_input->RequiredFields( array('lngcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->lngcod; 

	// titulo
	$lv_title = $vew_lang->language;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'LNT';
	
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
						<div class="col-md-5">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->translation; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php if($vew_actcod=='01'){ ?>
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-2"><?= $vew_lang->language; ?></label>
                      <div class="col-sm-10">
                        <select id="lngcodsve" name="lngcodsve" class="form-control <?= ($vew_data->lngcod!=''?'tmssAlwaysDisabled':''); ?>" <?= ($vew_data->lngcod!=''?'redaonly="readonly"':''); ?>>
                          <option value="" data-lngtxt=""></option>
                          <?php foreach($vew_data->lng as $lv_row){ echo '<option value="'.$lv_row['lngcod'].'" data-lngtxt="'.$lv_row['lngtxt'].'">'.$lv_row['lngcod'].'</option>'; } ?>
                        </select>
                      </div>
                    </div>
                  <?php } ?>
									<?= vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('lngtxt', 'doccmt1x50', $vew_data->lngtxt, $lv_always_disabled) )); ?>
									<?= vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); ?>
                </div>
              </div><!-- /card -->
						</div><!-- /col -->
						<div class="col-md-7">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <div class="form-group tmss-form-group">
                      <div class="col-xs-9"><input type="text" class="form-control tmssAlwaysEnabled" placeholder="Buscar..." id="lngtxtfnd" name="lngtxtfnd" value=""></div>
                      <div class="col-xs-3"><span id="count" class="pull-right"><strong><?= count($vew_data->txt); ?></strong></span></div>
                    </div>
                  </div>
              	</div>
                <div class="card-body tmss-card-body-edit">              
                  <table class="table table-condensed table-hover tmss-vertbl-scroll" id="tmssTable">
                    <thead><tr><th class="wdt-250"><?= $vew_lang->key; ?></th><th class="wdt-350"><?= $vew_lang->text; ?></th><th class="wdt-350"><?= $vew_lang->translation; ?></th></tr></thead>
                    <tbody>
                      <?php
                        foreach($vew_data->txt as $lv_key=>$lv_val){
                          echo '<tr data-key="'.$lv_key.'"><td>'.$lv_key.'</td><td>'.htmlentities($lv_val).'</td><td>'. (isset($vew_data->tra[$lv_key])?htmlentities($vew_data->tra[$lv_key]):'').'</td></tr>';
                        }
                      ?>
                    </tbody>
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

    <?php if($vew_data->lngcod==''){ ?>
    	// carga inicial de variables al seleccionar idioma
      $("#<?= $lv_sec; ?> #lngcodsve").on("change",function(){
      	$("#<?= $lv_sec; ?> #lngtxt").prop("value",  $(this).find("option:selected").data("lngtxt") );
        var lv_pstdat = [{name:"lngcod",value: $(this).find("option:selected").val()}];
        tmssCallProcess("?prg=syslng&act=18",lv_pstdat,function(data){
          var lv_buf = "";          
					Object.keys(data).forEach(function(key){
        		lv_buf += "<tr data-key='"+key+"'><td>"+key+"</td><td>"+data[key]+"</td><td></td></tr>";
    			});          
          $("#<?= $lv_sec; ?> #tmssTable tbody").html( lv_buf );
          
          // attach de eventos
          $("#<?= $lv_sec; ?> #tmssTable tbody tr").on("click",function(){
            <?= $lv_sec; ?>_showDialog( "02", $(this).find("td:first").text(), $(this).find("td:first").next().text(), $(this).find("td:last").text() );
          });
        })
			});      
    <?php } ?>

		<?php if(!$vew_readonly){ ?>      
    // attach de eventos de traducciones
    $(function(){      
			$("#<?= $lv_sec; ?> #tmssTable tbody tr").on("click",function(){
				<?= $lv_sec; ?>_showDialog( "02", $(this).find("td:first").text(), $(this).find("td:first").next().text(), $(this).find("td:last").text() );
			});
		});
		
		function <?= $lv_sec; ?>_showDialog( lp_act, lp_lngvar, lp_lngvartxt, lp_lngtratxt ){
			var lv_msg = ""
			lv_msg += "<div>";
			lv_msg += "<div class='form-group tmss-form-group'><label class='col-xs-2 control-label'><?= $vew_lang->variable; ?></label><div class='col-xs-10'><input type='text' class='form-control' id='lngvar' value='"+lp_lngvar+"' readonly='readonly'></div></div>";
			lv_msg += "<div class='form-group  tmss-form-group'><label class='col-xs-2 control-label'><?= $vew_lang->text; ?></label><div class='col-xs-10'><input type='text' class='form-control' id='lngvartxt' value='"+lp_lngvartxt+"' readonly='readonly'></div></div>";
			lv_msg += "<div class='form-group  tmss-form-group'><label class='col-xs-2 control-label'><?= $vew_lang->translation; ?></label><div class='col-xs-10'><input type='text' class='form-control' id='lngtratxt' value='"+lp_lngtratxt+"'></div></div>";
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
												var lv_lngtratxt = dialogItself.getModalBody().find("#lngtratxt").prop("value");
												if ( lv_lngvar.trim()=="" ) { toastr.warning("Debe indicar una variable.");
												} else if ( lv_lngtratxt.trim()=="" ) { toastr.warning("Debe indicar una traducci&oacute;n.");
												} else { 
                          $("#<?= $lv_sec; ?> #tmssTable tbody tr[data-key='"+lv_lngvar.trim()+"'] td:last").html( lv_lngtratxt );
                          dialogItself.close();
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
        
        <?php if($vew_actcod=='01'){?>
        	if($("#<?= $lv_sec; ?> #lngcodsve").val().trim()==""){
            toastr.warning("Debe indicar un idioma.");
            $("#<?= $lv_sec; ?> #lngcodsve").focus();
            return false;
          }
        	$("#<?= $lv_sec; ?> #lngcod").prop( "value", $("#<?= $lv_sec; ?> #lngcodsve").val() );
      	<?php } ?>        
        
        var lv_buffer = [];
        $("#<?= $lv_sec; ?> #tmssTable tbody tr").each(function(){
          if( $(this).find("td:last").html().trim()!="" ){
          	lv_buffer.push( {"name":$(this).find("td:first").html().trim().toLowerCase(),"value":$(this).find("td:last").html().trim()} );
          }
        });
        $("#<?= $lv_sec; ?> #syslngtxt").text( JSON.stringify(lv_buffer) );        
      }
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>      
</section>