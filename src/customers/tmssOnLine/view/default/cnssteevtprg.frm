<?php  
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = '';
	
	// modulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU1';

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
	$lv_steevtcod = $vew_data->evtdoc[0]['steevtcod']??'';
	$lv_steevtdoccod = $vew_data->evtdoc[0]['steevtdoccod']??'';
	
	$lv_budmatsts = array(''=>'','C'=>'EN CURSO','F'=>'FINALIZADO');
	$lv_stsdel = array();
?>
<section id="<?= $lv_sec; ?>">
	<?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
	<?= gethtml('steevtdoccod', 'hidden', $lv_steevtdoccod); ?>
	<textarea class="hidden" id="steevtdocdat" name="steevtdocdat">"<?= ($vew_data->evtdoc[0]['steevtdocatr']??''); ?>"</textarea>

  <table class="table table-stripped table-bordered table-hover">
		<thead><tr><th width="50">ID</th><th>Tarea</th><th class="hidden-xs" width="180">Estado</th></tr></thead>
		<tbody>
			<?php
				if($vew_readonly){
					
					foreach($vew_data->evtdoc as $lv_row){
						$lv_sts = $vew_doc->getTagValue($lv_row['steevtdocatr'],'tsksts');
						echo '<tr data-srcobjcod="'.$lv_row['srcobjcod'].'" data-steevtdoccod="'.$lv_row['steevtdoccod'].'">'.
										'<td>'.$lv_row['srcobjcod'].'</td>'.
										'<td>'.$lv_row['srcobjtxt'].'</td>'.
										'<td class="text-center"><i class="fas '.($lv_sts=='F'?'fa-check':($lv_sts=='C'?'fa-wrench fa-2x':'')).'"></i></td>'.
									'</tr>';
					}
				
				} else {

					$lv_tsk = array();
					foreach($vew_data->cnsbudmat as $lv_row){
						if( !isset($lv_tsk[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod001']]) ){
							$lv_tsk[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod001']] = 1;
						}
					}

					// armo lista de asistencias que no estan incluidas en ningun presupuesto.
					foreach($vew_data->evtdoc as $lv_row){
						if( !isset($lv_tsk[$lv_row['srcobjtyp'].'_'.$lv_row['srcobjcod']]) ){
							$lv_stsdel[] = $lv_row['steevtdoccod'];
						}
					}

					foreach($vew_data->cnsbudmat as $lv_row){
						$lv_steevtdoccod = '';
						$lv_steevtdocsts = '';
						// busco estados para el dia de la fecha
						foreach($vew_data->evtdoc as $lv_rowevt){
							if($lv_rowevt['srcobjtyp']==$lv_row['srcobjtyp'] && $lv_rowevt['srcobjcod']==$lv_row['srcobjcod001']){
								$lv_steevtdoccod = $lv_rowevt['steevtdoccod'];
								$lv_steevtdocsts = $vew_doc->getTagValue( $lv_rowevt['steevtdocatr'], 'tsksts' );
								break;
							}
						}
						// si es una avance nuevo, reviso el parte de avance del dia anterior
						if($lv_steevtdoccod==''){
							foreach($vew_data->evtdocprv as $lv_rowevt){
								if($lv_rowevt['srcobjtyp']==$lv_row['srcobjtyp'] && $lv_rowevt['srcobjcod']==$lv_row['srcobjcod001']){
									$lv_steevtdocsts = $vew_doc->getTagValue( $lv_rowevt['steevtdocatr'], 'tsksts' );
									break;
								}
							}
						}
						
						echo '<tr data-steevtdoccod="'.$lv_steevtdoccod.'" data-srcobjtyp="'.$lv_row['srcobjtyp'].'" data-srcobjcod="'.$lv_row['srcobjcod001'].'"><td>'.$lv_row['srcobjcod001'].'</td><td><span name="srcobjtxt">'.$lv_row['srcobjtxt'].'</span></td><td>'.gethtml('',$lv_budmatsts,$lv_steevtdocsts,$lv_default).'</td></tr>';
					}
				}
			?>
		</tbody>
	</table>
	<script>
    //añade stylos a los toggles
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
        //verifica si los toggle deberian estar desabilitados
        <?= ($vew_readonly?'$(this).prop("disabled","disable")':''); ?>
			});
		});
    
    // fija los datos del formulario en los campos como JSON
    function <?= $lv_sec; ?>_sve( lp_sec ){			
      //recorre las filas de la tabla de asistencia y guarda los datos
			var lv_stsdat = [];
      $("#<?= $lv_sec; ?> table tbody tr").each(function(){
        //arma el array post
        lv_stsdat.push({"steevtdoccod":$(this).data("steevtdoccod"),
												"srcobjtyp":$(this).data("srcobjtyp"),
												"srcobjcod":$(this).data("srcobjcod"),
												"srcobjtxt":$(this).find("span[name=srcobjtxt]").text(),												
												"steevtdocatr":"<tsksts>"+$(this).find("select:first").val()+"</tsksts>"
												});
			});
			// fija los valores en los campos
			$("#<?= $lv_sec; ?> #steevtdocdat").text( JSON.stringify(lv_stsdat) );
			$("#<?= $lv_sec; ?> #steevtdocdatdel").text( "<?= (count($lv_stsdel)==0?'[]':json_encode($lv_stsdel)); ?>" );			
    }
	</script>
</section>