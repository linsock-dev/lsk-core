<?php
	// campos requeridos
	$vew_input->RequiredFields( array() );

	// modulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');	
	
	// valores x default
	$vew_data->crmcntcmtdte = date('d/m/Y');	

	//array de cambio de responsable
	$lv_stsres = '';
	// flag de estado default
	$lv_dftsts = true;
	// arma array de estados 
	$lv_stsarr = array();
	$lv_stsarr[$vew_data->crmcntstscod] = $vew_data->crmcntststxt;
	foreach($vew_data->crmcntmtvsts as $lv_row) {
		//agrega un cambio de estado posible
		if($lv_row['crmcntstscodend']=='0'){
			$lv_stsarr[$lv_row['crmcntstscodstr']] = $lv_row['crmcntststxtstr'];
		} else {
			$lv_stsarr[$lv_row['crmcntstscodend']] = $lv_row['crmcntststxtend'];
		}
    $lv_stscod = ($lv_row['crmcntstscodend']=='0'
                  ? $lv_row['crmcntstscodstr']
                  : $lv_row['crmcntstscodend']);
    //agrega el usuario por defecto de ese cambio y agrega el estado del atributo cerrado
    $lv_stsres .= ($lv_stsres==''?'':',').
									'{stscod:'.$lv_stscod.','.
									'usrcod:"'.$vew_doc->getTagValue( $lv_row['crmcntmtvstsatr'], 'usrasg' ).'",'.
      						'stscls:'.($lv_row['crmcntstscodend']=='0'?$lv_row['crmcntstsclsstr']:$lv_row['crmcntstsclsend']).'}';
		//si existe el estado en la lista, no es default
    if ($lv_stscod == $vew_data->crmcntstscod) {
        $lv_dftsts = false;
    }
  }
  //si es estado por defecto, agrego la fila del estado default
	$lv_stsres .= $lv_dftsts ? ($lv_stsres==''?'':',').
    					 '{stscod:'.$vew_data->crmcntstscod.','.
    					 'usrcod:"",'.
    					 'stscls:'.$vew_data->crmcntstscls.'}'
    					 : '';
	//cierrra array de cambio de responsable
	$lv_stsres = 'var lv_stsres = ['.$lv_stsres.'];';	
?>
<section id="<?= $lv_sec; ?>">
	<style>
		.percent::after { content: '%'; }
		.percent::after {
		position: absolute; top: 7px; right: 3.5em; transition: all .05s ease-in-out; }
	</style>
	<div class="form-horizontal">
		<div class="container-fluid">
			<div class="row">
				<?php
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->date, 'input'=>gethtml('crmcntcmtdte', 'docdte', $vew_data->crmcntcmtdte, $lv_always_disabled) ));
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->Status, 'input'=>gethtml('crmcntstscod', $lv_stsarr, $vew_data->crmcntstscod, $lv_default, true) ));
        	echo gethtml('crmcntstscodsrc','hidden',$vew_data->crmcntstscod);
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->responsible,'input'=>gethtml('usrcod', 'doccmt1x50', $vew_data->usrcod, $lv_default) ));
        	echo gethtml('usrcodsrc','hidden',$vew_data->usrcod);
        	echo gethtml('crmcntstscls', 'hidden', $vew_data->crmcntstscls);
        	echo '<div class="row">';
            echo '<div class="col-md-6">';
        			echo '<div class="form-group tmss-form-group"><label class="col-xs-4 control-label text-nowrap">'.$vew_lang->progress.'</label><div class="col-xs-8"><div class="percent"><input type="NUMBER" id="crmcntprg" name="crmcntprg" value="'.$vew_doc->getTagValue( $vew_data->crmcntatr, 'prg' ).'" maxlength="6" min="0" max="100" step="1" class="form-control"></div></div></div>';
            echo '</div>';
            echo '<div class="col-md-6">';
              echo vew_boot($lv_col48, array('label'=>$vew_lang->hours, 'input'=>gethtml('crmcnthrs', 'docnum0601', $vew_data->crmcnthrs, $lv_default) ));
            echo '</div>';
          echo '</div>';
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->comments,'input'=>gethtml('crmcntcmt', 'doccmt10x50', $vew_data->crmcntcmt, $lv_always_disabled) ));
				?>
			</div>
		</div>
	</div>
  <script>
    //evento change del desplegable de estado
    $("#<?= $lv_sec; ?> #crmcntstscod").change(function(e){
      //reinicia el readonly
      $("#<?= $lv_sec; ?> #usrcod").prop("readonly",false);
      //asigna el responsable actual
      $("#<?= $lv_sec; ?> #usrcod").val( $("#<?= $lv_sec; ?> #usrcodsrc").val() );
      <?= $lv_stsres; ?>
      //recorre la lista de usuario por defecto del cambio de estado
      for(var i = 0; i<lv_stsres.length; i++){
        //encuentra el cambio realizado y revisa que alla un usuario por defecto asignado
        if( lv_stsres[i].stscod == $(this).val()){
          $("#<?= $lv_sec; ?> #crmcntstscls").val(lv_stsres[i].stscls);
          if(lv_stsres[i].usrcod){
            //asigna el responsable
            $("#<?= $lv_sec; ?> #usrcod").prop("readonly",true);
            $("#<?= $lv_sec; ?> #usrcod").val(lv_stsres[i].usrcod);
          }
          break;
        }
      }
    })
  </script>
</section>