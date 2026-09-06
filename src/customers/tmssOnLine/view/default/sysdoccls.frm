<?php
	// url del formulario
  $lv_lnk = "?prg=sysdoccls&prm_sysdocclscod=".$vew_data->sysdocclscod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysdocclstxt','objtyp','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysdocclscod;

	// titulo
	$lv_title = $vew_lang->documentclass;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DCL';

	$lv_canedit = $vew_sec->hasPermission("SYS","DCL","02");

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea class="hidden" id="sysdocclsatr_dat" name="sysdocclsatr_dat"></textarea>
		<textarea class="hidden" id="sysdocclsatrusr_dat" name="sysdocclsatrusr_dat"></textarea>
		<textarea class="hidden" id="sysdocclsfld" name="sysdocclsfld"><?= $vew_doc->getTagValue($vew_data->sysdocclsatr,'sysdocclsfld'); ?></textarea>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysdocclscod; ?><?= gethtml('sysdocclscod','hidden',$vew_data->sysdocclscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="<?= ($vew_data->sysdocclscod==''?'col-md-12':'col-md-10'); ?>">

							<div class="row">
								<div class="col-md-6">
                  
                  <div class="card">
                    <div class="card-header"><div class="card-title"><?= $vew_lang->documentclass; ?></div></div>
                    <div class="card-body">
                      <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('sysdocclscodext','doccmt1x10', $vew_data->sysdocclscodext, $lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('sysdocclstxt', 'doccmt1x50', $vew_data->sysdocclstxt, $lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('objtyp','objtypcod_lst', $vew_data->objtyp, ($vew_actcod=='01'?$lv_default:$lv_always_disabled) ) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod','autcod', $vew_data->autcod, $lv_default ) ));
                      	echo vew_boot($lv_col210, array("label"=>'Nro '.$vew_lang->external, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('docrngcodext', 'rngcod_btn', $vew_data->docrngcodext, $lv_default) )) ));
                        echo vew_boot($lv_col210, array('label'=>'Nro '.$vew_lang->internal, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('docrngcodint', 'rngcod_btn', $vew_data->docrngcodint, $lv_default) )) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                      ?>
                    </div>
                  </div>

                </div>
								<div class="col-md-6">
                
									<!-- CONFIGURACION -->
                  <div class="card">
                    <div class="card-header"><div class="card-title"><?= $vew_lang->settings; ?></div></div>
										<div class="card-body tmss-card-body-edit"><div id="sysdocclsatrtbl"></div></div>
                  </div>
									
									<!-- ATRIBUTOS -->
                  <div class="card">
                    <div class="card-header">
											<div class="card-title"><?= $vew_lang->attributes; ?>
												<a class="card-icon" id="btnAtrHlp"><i class="far fa-question"></i></a>
												<a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
											</div>
										</div>
										<div class="card-body tmss-card-body-edit"><div id="sysdocclsatrusrtbl"></div></div>
                  </div>
									
								</div><!-- /col-md-6 -->
							</div><!-- /row -->

						</div><!-- /col-dm-10 -->
						<div class="col-md-2 text-center <?= ($vew_data->sysdocclscod!=''?'':'hidden'); ?>">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->options; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <a href="#" class="card-opt-body text-left" id="btnmsg"><i class="far fa-paper-plane"></i> <?= $vew_lang->messageclasses; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btncnt"><i class="fas fa-users"></i> <?= $vew_lang->interlocutortypes; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnrej"><i class="fas fa-times"></i> <?= $vew_lang->rejectionreasons; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnrsn"><i class="far fa-comment-dots"></i> <?= $vew_lang->orderreasons; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnwrk"><i class="fas fa-sitemap"></i> <?= $vew_lang->workflow; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnfrm"><i class="fas fa-table-layout"></i> <?= $vew_lang->forms; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnreq"><i class="fas fa-pen-field"></i> <?= $vew_lang->fields; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnsts"><i class="far fa-check-square"></i> <?= $vew_lang->statuses; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btntxt"><i class="far fa-text"></i> <?= $vew_lang->texts; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btnfle"><i class="fas fa-files"></i> <?= $vew_lang->files; ?></a>
                </div>
							</div>
						</div> <!-- /col-md-2 -->
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// CONFIGURACION
		
		// muestra ayuda de parametro
		function <?= $lv_sec; ?>_showHelp(lp_row){
      var lv_rowdat = go_<?= $lv_sec; ?>_tblmap.getValuesAtRow(lp_row);
      var lv_hlp = lv_rowdat["hlp"];
      var lv_atrtxt = lv_rowdat["txt"];
      var lv_atrcod = lv_rowdat["cod"];
			BootstrapDialog.show({
				title: lv_atrtxt,
				message:$("<div class='container-fluid'><p>"+lv_hlp+"</p><br>Cod.: <b>"+lv_atrcod+"</b></div>"),
				draggable:true
			});
		}
		
		// configuro y creo la tabla
		var go_<?= $lv_sec; ?>_tblcfgmap = {
			readOnly: <?= ($vew_readonly?'true':'false'); ?>,
			allowAdd: false,
			select: false,
			headerData: [{title:"<?= $vew_lang->parameter; ?>", width:"49%"}, {title:"<?= $vew_lang->value; ?>", width:"50%"}, {title:"<?= $vew_lang->help; ?>", width:"1%"}],
			columnsData:[{id: "txt", type:"TEXT", editable:false },
									{ id: "val", type:"TEXT" },
									{ id: "icn", type:"BUTTON", buttonFormat:{icon:"far fa-question"}, onClick: function(){event.preventDefault(); <?= $lv_sec; ?>_showHelp("@@ROW"); }}
									]
		};
		var go_<?= $lv_sec; ?>_tblmap = new tmssTable($("#<?= $lv_sec; ?> #sysdocclsatrtbl"), go_<?= $lv_sec; ?>_tblcfgmap);
		
		// cargo datos a tabla
		var gv_<?= $lv_sec; ?>_tbldatmap = [<?php
			$lv_buffer='';
			foreach($vew_data->sysdocclsatrlst as $lv_row){
				$lv_buffer.=($lv_buffer!=''?',':'').'{'.
											'cod:"'.$lv_row['sysdocclsatrcodext'].'",'.
											'txt:"'.$lv_row['sysdocclsatrtxt'].'",'.
											'val:"'.$vew_doc->getTagValue($vew_data->sysdocclsatr,$lv_row['sysdocclsatrcodext']).'",'.
											'hlp:"'.$lv_row['sysdocclsatrhlp'].'"}';
										}
			echo $lv_buffer;
		?>];
		go_<?= $lv_sec; ?>_tblmap.loadData(gv_<?= $lv_sec; ?>_tbldatmap);
	</script>
	<script>
		// ATRIBUTOS
		
		// dialogo de ayuda general
		$("#<?= $lv_sec; ?> #btnAtrHlp").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title:"<?= $vew_lang->attributes; ?>",
				message:$("<h4>Atributos Personalizados</h4><br><p>Utilice esta tabla para agregar atributos CODIGO/VALOR a la clase de documento. Estos atributos estaran disponibles para realizar actividades personalizadas en sus programas mediante el uso de tags.</p><br>Cod.: <b>sysdocclsatrusr</b>"),
				draggable:true
			});
		});
		
		// configuro y creo tabla
		var go_<?= $lv_sec; ?>_tblusrcfgmap = {
			readOnly: <?= ($vew_readonly?'true':'false'); ?>,
			headerData: [{title:"<?= $vew_lang->code; ?>", width:"50%"}, {title:"<?= $vew_lang->value; ?>", width:"50%"}],
			columnsData:[ { id: "cod", type:"TEXT" }, { id: "val", type:"TEXT" }],
			showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
		};
		var go_<?= $lv_sec; ?>_tblusrmap = new tmssTable($("#<?= $lv_sec; ?> #sysdocclsatrusrtbl"), go_<?= $lv_sec; ?>_tblusrcfgmap);
		
		// cargo datos en tabla
		var gv_<?= $lv_sec; ?>_tblusrdatmap = [<?php
			if($vew_data->sysdocclsatrusr!=''){
        $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($vew_data->sysdocclsatrusr).
</document>
XML;
				$lv_dat = simplexml_load_string($lv_atrusr);
				$lv_buffer='';
				foreach($lv_dat as $lv_key=>$lv_val){
					$lv_buffer.=($lv_buffer!=''?',':'').'{cod:"'.$lv_key.'",val:"'.$lv_val.'"}';
				}
				echo $lv_buffer;
			}
		?>];
		go_<?= $lv_sec; ?>_tblusrmap.loadData(gv_<?= $lv_sec; ?>_tblusrdatmap);	
	</script>
	<script>
		// docrngcodint
		$("#<?= $lv_sec; ?> #docrngcodint").next("span").children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("Rango Interno","index.php?prg=grldatdocrng&prm_vewcod=VEW_GRL_DAT_DOC_RNG&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[objtypcod:"+$("#<?= $lv_sec; ?> #objtyp").prop("value")+"]&prm_fldasg=[docrngcodint:docrngcod]");
		});

		// docrngcodext
		$("#<?= $lv_sec; ?> #docrngcodext").next("span").children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("Rango Externo","index.php?prg=grldatdocrng&prm_vewcod=VEW_GRL_DAT_DOC_RNG&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[objtypcod:"+$("#<?= $lv_sec; ?> #objtyp").prop("value")+"]&prm_fldasg=[docrngcodext:docrngcod]");
		});
		
		
		//  CLASES DE MENSAJE
		$("#<?= $lv_sec; ?> #btnmsg").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [	{name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                      	{name:"objtypcod", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")}];
			tmssCallProcess("?prg=sysdocclsmsg&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->messageclasses; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});
		
    
		//  WORKFLOWS
		$("#<?= $lv_sec; ?> #btnwrk").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")}];
			tmssCallProcess("?prg=sysdocclswrk&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->workflows; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});
		
    
		//  ESTADOS
		$("#<?= $lv_sec; ?> #btnsts").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                        {name:"objtypcod", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")}];
			tmssCallProcess("?prg=sysdocclssts&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->status; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});


		//  MOTIVOS DE RECHAZO
		$("#<?= $lv_sec; ?> #btnrej").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")}, 
                        {name:"objtyp", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")} ];
			tmssCallProcess("?prg=sysdocclsrej&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->rejectionreasons; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});
		
		
		//  MOTIVOS DE PEDIDO
		$("#<?= $lv_sec; ?> #btnrsn").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                        {name:"objtyp", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")} ];
			tmssCallProcess("?prg=sysdocclsrsn&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->orderreasons; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});
      
		
		//  INTERLOCUTORES
		$("#<?= $lv_sec; ?> #btncnt").on("click", function(e) { e.preventDefault();
			var lv_pstdat=[ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")}, 
                      {name:"objtyp", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")} ];
			tmssCallProcess("?prg=sysdocclscnt&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->interlocutortypes; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});
		
		
		//  CAMPOS
		$("#<?= $lv_sec; ?> #btnreq").on("click", function(e) { e.preventDefault();

			var lv_pstdat=[ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                      {name:"actcod",value:"<?= ($lv_canedit?"02":"03"); ?>"},
                     	{name:"sysdocclsreqfld",value:$("#<?= $lv_sec; ?> #sysdocclsreqfld").text()} ];
			tmssCallProcess("?prg=sysdoccls&act=23", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->fields; ?>",
					message: $(data),
          size: BootstrapDialog.SIZE_WIDE, 
          <?php if($lv_canedit){  ?>
  			buttons: [{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
                  {	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												var lv_sec = dialogItself.getModalBody().find("section:first").prop("id");
												var lo_dat = eval(lv_sec+"_hotdoc.getSourceData()");
												for(var i=0; i<lo_dat.length; i++){
													if(lo_dat[i]["fldcod"]=="" || lo_dat[i]["fldcod"]==undefined){ lo_dat.splice(i,1); i--; }
												}
												$("#<?= $lv_sec; ?> #sysdocclsfld").text( JSON.stringify(lo_dat) );
												dialogItself.close();
										}}],
   					 <?php  } ?>
          onshown: function(dialogItself){
            var lv_json = $("#<?= $lv_sec; ?> #sysdocclsfld").text();
            dialogItself.getModalBody().find("#json_input").html(lv_json);
            dialogItself.getModalBody().find("#json_button").trigger("click");
          }
				});
			});
		});
    
    
    // TEXTOS
    $("#<?= $lv_sec; ?> #btntxt").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                        {name:"objtyp", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")} ];
			tmssCallProcess("?prg=sysdocclstxt&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "Textos",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});
    
		
    // FORMULARIOS
    $("#<?= $lv_sec; ?> #btnfrm").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                        {name:"objtyp", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")} ];
			tmssCallProcess("?prg=sysdocclsfrm&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->forms ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});	
    
    // ARCHIVOS
    $("#<?= $lv_sec; ?> #btnfle").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
                        {name:"objtyp", value: $("#<?= $lv_sec; ?> #objtyp").prop("value")} ];
			tmssCallProcess("?prg=sysdocclsfle&act=<?= ($lv_canedit?'02':'03'); ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->FILES ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
          <?php if($lv_canedit){ ?>
          ,buttons:[{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialogItself){dialogItself.close();}},
            				{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){
												dialogItself.$modalBody.find("#btnsubmit").trigger("click");
            						dialogItself.close();
										}}]
          <?php } ?>
				});
			});
		});	
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) { 
				var lv_dat = go_<?= $lv_sec; ?>_tblmap.getData();
        var lv_arr = [];
        for(let i = 0; i < lv_dat.length; i++){
          lv_arr.push({"cod":lv_dat[i]["cod"], "val":lv_dat[i]["val"]});
        }
        
				// agrego atributos de campos requeridos
				lv_arr.push({"cod":"sysdocclsfld","val":$("#<?= $lv_sec; ?> #sysdocclsfld").text()});
        $("#<?= $lv_sec; ?> #sysdocclsatr_dat").prop("value", JSON.stringify( lv_arr ));
                             
        // atributos de usuario
				$("#<?= $lv_sec; ?> #sysdocclsatrusr_dat").prop("value", JSON.stringify( go_<?= $lv_sec; ?>_tblusrmap.getData() ) );
			}
		}
    
    function <?= $lv_sec; ?>_formeditext( lp_prm ) { 
      tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>, $("#<?= $lv_sec; ?> #sysdocclsatrtbl input, #<?= $lv_sec; ?> #sysdocclsatrusrtbl input"));
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>