<?php
	// url del formulario 
  $lv_lnk = '?prg=cnssteevt&prm_steevtcod='.$vew_data->steevtcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('steevtdte','stecod','stetxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->steevtcod; 

	// titulo  
	$lv_title = $vew_lang->events;
    
	// módulo y programa 
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'EVT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
		
  // valores x default
	if($vew_data->steevtcod==''){
		$vew_data->steevtdte = new DateTime();
		$vew_data->docsts = 'A';
	}
	
	$lv_steevtdoccod = ($vew_data->evtdoc[0]['steevtdoccod']??'');
	$vew_dateOnly= $vew_dateOnly??'';	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('dateOnly', 'hidden', $vew_dateOnly); ?>
		
    <div class="container-fluid">

			<div class="card">
				<div class="card-header">
					<div class="card-title"><?= $vew_lang->event; ?> #<?= $vew_data->steevtcod; ?><?= gethtml('steevtcod','hidden',$vew_data->steevtcod); ?>
						<span class="tmss-card-icon">
							<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
							<?= gethtml('sysdocclscod','hidden', $vew_data->sysdoccls->sysdocclscod); ?>
						</span>
					</div>
				</div> 
				<div class="card-body tmss-card-body-edit">
					<div class="row">
					<?php
						if($vew_dateOnly == ''){
							echo '<div class="col-sm-6">';
							echo vew_boot($lv_col210, array('label'=>$vew_lang->constructionsite,
																						'input1'=>vew_boot( array('style'=>'search', 'readonly'=> $vew_data->steevtcod == '' ? $vew_readonly : $lv_always_disabled ),
																																array('input'=>gethtml('stetxt', 'typeahead', $vew_data->stetxt, $vew_data->steevtcod == '' ? $lv_default : $lv_always_disabled ) )) ));
							echo '</div>';
						}
						echo gethtml('stecod', 'hidden', $vew_data->stecod);
						
						echo '<div class="col-sm-3">';
						echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('steevtdte', 'docdte', $vew_data->steevtdte, $vew_data->steevtcod == '' ? $lv_default : $lv_always_disabled ) ));
						echo '</div>';
						
						if($vew_dateOnly == ''){
							echo '<div class="col-sm-3">';
							echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
							echo '</div>';
						}else{
							echo gethtml('docsts', 'hidden', $vew_data->docsts);
						}
					?>
					</div>					
				</div>
			</div>
			
			<div id="cnsstefrm"></div>
			
		</div>
	</form>
	<script>
    // obras - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"stecod" : "stecod", "stetxt" : "stetxt"}, "fldflt": {"s.docsts": "A"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #stetxt"), "cnsste", lo_get, {"afterAssign": function(lp_data){ if(typeof lo_<?= $lv_sec; ?>_after === 'function'){lo_<?= $lv_sec; ?>_after(lp_data)} }});
		
		// carga inicial del formulario de evento
		$(function(){
			<?= $lv_sec; ?>_getForm();
		});
		
		// formulario del evento (al cambiar obra o fecha)
		$("#<?= $lv_sec; ?> #stecod, #<?= $lv_sec; ?> #steevtdte").on("change",function(e){ e.preventDefault(); 
    	<?= $lv_sec; ?>_getForm();
		});
		
		// carga el formulario del evento
    function <?= $lv_sec; ?>_getForm(){
      var lv_dat = $("#<?= $lv_sec; ?>_frm").serializeArray();
			lv_dat.push({name:"actcod",value:"<?= $vew_actcod; ?>"});      
      lv_dat.push({name:"oldSec",value:"<?= $lv_sec; ?>"});
  		lv_dat.push({name:"steevtdoccod",value:"<?= $lv_steevtdoccod; ?>"});
			var lv_url = $("<div><?= $vew_data->sysdoccls->sysdocclsatr; ?></div>").find("frm:first").text();
			if(lv_url!=""){
				tmssCallProcess(lv_url,lv_dat,function(data){
					$("#<?= $lv_sec; ?> #cnsstefrm").html( data );
				});
			}
    }
	</script>
	<script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {				
      // grabar
			if ( lp_prm["action"]=="00" ) {
        // busca si la funcion de grabado del formulario existe
				if( typeof window[$("#<?= $lv_sec; ?> #cnsstefrm").find("section:first").prop("id")+"_sve"] === "function" ){
          // graba los datos del formulario
          var lv_frmdat = window[$("#<?= $lv_sec; ?> #cnsstefrm").find("section:first").prop("id")+"_sve"]("<?= $lv_sec; ?>");
          if(lv_frmdat === false){
            return false;
          }
        }
			}
    }
  </script>	
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>