<?php
		/* url del formulario */
  $lv_lnk = "?prg=admsgn&prm_sgncod=".$vew_data->sgncod;

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = $vew_data->sgncod;

	/* titulo */
	$lv_title = $vew_lang->signature;

	/* módulo y programa */
	$lv_mdlcod = 'ADM';
	$lv_prgcod = 'SGN';

	/* librería de estilos bootstrap */
	include_once('_library.frm');
	$vew_tbl['sveL']['acc']=$lv_sec.'_btnsve();';
	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		<div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sgncod; ?><input type="hidden" id="sgncod" name="sgncod" value="<?= $vew_data->sgncod; ?>"></strong></h4></li>
			</ul>
      
			<div class="tab-content tmss-tab-content">
				<!--GENERAL-->
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">	
          
					<div class="row" id="<?= $lv_sec; ?>_general">
            
						<div class='col-md-6'>
              <div class="card">
                <div class="card-header">
                	<div class="card-title"><?= $lv_title; ?></div>
              	</div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->name, 'input'=>gethtml('usrtxt', 'doccmt1x50', (($vew_data->sgncod!='' || $vew_actcod=='01') ? $vew_sec->usrtxt : ''), $lv_always_disabled) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->validity, 'input'=>gethtml('sgndte', 'doccmt1x20', $vew_data->ctedte->format('d/m/Y H:i'), $lv_always_disabled),
                                                    'input2'=>gethtml('sgndte', 'doccmt1x20', $vew_data->sgnduedte->format('d/m/Y H:i'), $lv_always_disabled)
                      ));
                  ?>
                	<a href="#" class="hidden" onclick="tmssCallProcess('?prg=admsgn&act=export',[{name:'sgncod',value:'<?= $vew_data->sgncod; ?>'}],function(data){});">test</a>
                </div>
							</div>
            </div>
            
						<div class='col-md-6'>
              <div class="card">
                <div class="card-header">
                	<div class="card-title">
                    <?= $vew_lang->DATA; ?>
                  </div>
              	</div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                  	echo gethtml('docsts', 'hidden', 'A');
                  	echo gethtml('camera_base64', 'hidden', '');
                  	echo gethtml('sgnpwd', 'hidden', '');
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->initials,	'input'=>gethtml('sgnini', 'doccmt1x50', (($vew_data->sgncod == '') ? '' : $vew_data->sgnini), $lv_default) ));
                  ?>
              
                  <div id="sgnpadfrm" class="hidden">
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-2 control-label"><?= $vew_lang->signature; ?></label>
                      <div id="sgnpad" class="col-sm-10">
                        <canvas id="signature" style="border: #a6a6a6 1px solid;"></canvas>
                      </div>
                    </div>
                  </div>
              
                  <!-- Imagen firma -->
                  <div id="sgnpadimgfrm">
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-2 control-label"><?= $vew_lang->file; ?></label>
                      <div class="col-xs-10" id="sgnpadimg"><?php include('grldatuplshwpth.frm'); ?></div>
                    </div>
                  </div>
                </div>
              </div>
						</div>
            
					</div> <!-- ROW -->

					<!-- mensaje sin firma -->
					<div class="row hidden" id="<?php $lv_sec; ?>_msgFirma">
						<div class="col-xs-1 col-md-3"></div>
							<div class="col-xs-10 col-md-6">
								<h3>Sin firma</h3>
								<blockquote>
									<p>No tiene firma cargada o vigente.</p>
								</blockquote>
							</div>
						<div class="col-xs-1 col-md-3"></div>
					</div>
          
					<!-- fin mensaje sin firma -->
        </div> <!-- fin _tab001 -->
			</div><!-- tabcontent -->
    </div> <!-- container-fluid -->

  </form>
	<script>
		//Dialogo de solicitud de clave
		function <?= $lv_sec; ?>_btnsve(){

			// valido que la firma no esté vacia (comparado con un canvas vacio)
			var lv_imgctx = <?= $lv_sec; ?>_canvas.getContext("2d");
			var lv_imgdat = lv_imgctx.getImageData(0,0,<?= $lv_sec; ?>_canvas.width,<?= $lv_sec; ?>_canvas.height).data;
			var lv_imgbuf = new Uint32Array( lv_imgdat.buffer );
			if( !lv_imgbuf.some(color => color!=4294967295) ){
				toastr.warning("La firma no puede quedar vac&iacute;a. Debe indicar iniciales o un grafico de firma.");
				return false;
			}

			var lv_dia = "<div class='container-fluid'><p>A continuacion ingrese su clave de firma que sera requerida cada vez que firme electronicamente un documento.</p><br>"
			lv_dia += "<div class='row'><label class='col-xs-2 control-label'>Clave</label><div class='col-xs-10'><input type='password' class='form-control' id='sgnpwd' name='sgnpwd' maxlength=''></div></div><br><br>";
			lv_dia += "<p>Conserve esta clave y no la divulgue a terceros.</p></div>";
			BootstrapDialog.show({
				title: "<?= $vew_lang->signature; ?>",
				message: $(lv_dia),
				closable: false,
				type: BootstrapDialog.TYPE_PRIMARY,
				size: BootstrapDialog.SIZE_MEDIUM,
				buttons:[	{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(e){e.close();} },
									{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
										if( $.trim( dialog.getModalBody().find("#sgnpwd").prop("value") ) == "" ){
											toastr.warning("La clave es obligatoria");
										} else {

											var hash = sha256.create();
											hash.update( dialog.getModalBody().find("#sgnpwd").prop("value") );
											$("#<?= $lv_sec; ?> #sgnpwd").prop("value", hash.hex());

											<?= $lv_sec; ?>_fnc({action: "00"});
											dialog.close();
										}
									}}],
				onshown: function(dialog){
						dialog.getModalBody().find("#sgnpwd").focus();
					}
			});
    }
    
		<?php if(strlen($vew_data->sgncod)==0 && $vew_actcod!='01'){ ?>
			$("#<?php $lv_sec; ?>_msgFirma").removeClass("hidden");
			$("#<?= $lv_sec; ?>_general").addClass("hidden");
		<?php }else{ ?>
			$("#<?= $lv_sec; ?>_general").removeClass("hidden");
			$("#<?php $lv_sec; ?>_msgFirma").addClass("hidden");
		<?php } ?>

		//Si esta en modo lectura solo se puede ver la firma
		<?php if($vew_actcod == '01') {?>
			$("#<?= $lv_sec; ?> #sgnpadfrm").removeClass("hidden");
			$("#<?= $lv_sec; ?> #sgnpadimgfrm").addClass("hidden");
		<?php } ?>

		// plugin Hash de contraseña
		tmssLoadScript("sha256", function(){});
	</script>
  <script>
		var <?= $lv_sec; ?>_signaturePad;
		var <?= $lv_sec; ?>_canvas = $("#<?= $lv_sec; ?> canvas#signature").get()[0];
		var <?= $lv_sec; ?>_canvas_blank = <?= $lv_sec; ?>_canvas.cloneNode(true);

		$("#<?= $lv_sec; ?> #sgnini").on("keyup",function(){
			var lv_txt = $(this).prop("value").toUpperCase().trim();
			<?= $lv_sec; ?>_signaturePad.clear();
			var lo_cnv = $("#<?= $lv_sec; ?> canvas:first").get()[0].getContext("2d");
			lo_cnv.font = "48px Lucida Calligraphy";
			lo_cnv.fillText( lv_txt, 90, 95);
		});

		// Adjust canvas coordinate space taking into account pixel ratio,
		// to make it look crisp on mobile devices.
		// This also causes canvas to be cleared.
		function <?= $lv_sec; ?>_resizeCanvas() {
			if( <?= $lv_sec; ?>_signaturePad==undefined ){ return false; }
			// When zoomed out to less than 100%, for some very strange reason,
			// some browsers report devicePixelRatio as less than 1
			// and only part of the canvas is cleared then.
			var ratio =  Math.max(window.devicePixelRatio || 1, 1);

			// This part causes the canvas to be cleared
			<?= $lv_sec; ?>_canvas.width = <?= $lv_sec; ?>_canvas.offsetWidth * ratio;
			<?= $lv_sec; ?>_canvas.height = <?= $lv_sec; ?>_canvas.offsetHeight * ratio;
			<?= $lv_sec; ?>_canvas.getContext("2d").scale(ratio, ratio);

			<?= $lv_sec; ?>_canvas_blank.width = <?= $lv_sec; ?>_canvas.width;
			<?= $lv_sec; ?>_canvas_blank.height = <?= $lv_sec; ?>_canvas.height;
			<?= $lv_sec; ?>_canvas_blank.getContext("2d").scale(ratio, ratio);

			// This library does not listen for canvas changes, so after the canvas is automatically
			// cleared by the browser, SignaturePad#isEmpty might still return false, even though the
			// canvas looks empty, because the internal data of this library wasn't cleared. To make sure
			// that the state of this library is consistent with visual state of the canvas, you
			// have to clear it manually.
			<?= $lv_sec; ?>_signaturePad.clear();
		}

		tmssLoadScript("signature_pad",function(){
			<?= $lv_sec; ?>_signaturePad = new SignaturePad( <?= $lv_sec; ?>_canvas, {
				// It's Necessary to use an opaque color when saving image as JPEG;
				// this option can be omitted if only saving as PNG or SVG
				backgroundColor: 'rgb(255, 255, 255)'
			});
		});

		// On mobile devices it might make more sense to listen to orientation change,
		// rather than window resize events.
		window.onresize = <?= $lv_sec; ?>_resizeCanvas;
		<?= $lv_sec; ?>_resizeCanvas();
	</script>
	<script>
		// server response
		// tmssLink("?PRG=ADMSGN&prm_mdlcod=ADM&prm_prgcod=SGN", [{target:"_replace_with",target_id:"<?= $lv_sec; ?>"}] );

		// form submit externo
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
			if(lp_prm["action"]=="00"){
				$("#<?= $lv_sec; ?> #camera_base64").prop("value", <?= $lv_sec; ?>_canvas.toDataURL() );
			} else if(lp_prm["action"]=="98"){
				tmssLink("?PRG=ADMSGN&prm_mdlcod=ADM&prm_prgcod=SGN", [{target:"_replace_with",target_id:"<?= $lv_sec; ?>"}] );
				return;
			}
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>