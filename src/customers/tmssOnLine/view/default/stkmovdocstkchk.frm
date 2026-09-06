<?php	
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = ''; 

	// titulo
	$lv_title = $vew_lang->STOCKBELOWRESERVATION;
	
	/* módulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';
	
	// librería de estilos
  include_once('_library.frm');
	
?>
<section id="<?= $lv_sec; ?>">
  
  <div class="card">
    <div class="card-body tmss-card-body-edt">
      <table class="table table-condensed" id="stktbl">
        <thead>
          <tr>
            <th width="50"></th>
            <th><?= $vew_lang->material ?></th>
            <th width="100"><?= $vew_lang->required ?></th>
            <th width="50"></th>
            <th width="100"><?= $vew_lang->available ?></th>
            <th width="50"></th>
            <th width="100"><?= $vew_lang->batch ?></th>
            <th width="100"><?= $vew_lang->serialnumber ?></th>
          </tr>
        </thead>
        <tbody>
          <?php
						$lv_buffer = '';
						$lv_key = '';
            $lv_matcod='';
  					foreach($vew_matlst as $lv_row){
							if ($lv_key!=$lv_row['matcod'].'_'.$lv_row['matbchcod'].'_'.$lv_row['matsercod'] and !isset($lv_row['stkmovdoccod'])){
								$lv_key = $lv_row['matcod'].'_'.$lv_row['matbchcod'].'_'.$lv_row['matsercod'];
                
								$lv_qty = $lv_row['matstkqty'];
								
								// recupero datos de la grilla
                $lv_reqqty = 0;
                $lv_requntcod = '';
                $lv_mat = json_decode(html_entity_decode($vew_data['stkmovdocmat']),true);
                $lv_found = false;
                $lv_rowbchcodext = isset($lv_row['matbchcodext']) ? $lv_row['matbchcodext'] : '';
                $lv_rowsercodext = isset($lv_row['matsercodext']) ? $lv_row['matsercodext'] : '';

                foreach($lv_mat as $lv_rowdat){
                    $lv_datbchcodext = isset($lv_rowdat['matbchcodext']) ? $lv_rowdat['matbchcodext'] : '';
                    $lv_datsercodext = isset($lv_rowdat['matsercodext']) ? $lv_rowdat['matsercodext'] : '';

                    if( $lv_row['matcod'] == $lv_rowdat['matcod'] 
                        && $lv_rowbchcodext == $lv_datbchcodext 
                        && $lv_rowsercodext == $lv_datsercodext ){
                        $lv_found = true;
                        $lv_reqqty = $lv_rowdat['matqty'];
                        $lv_requntcod = $lv_rowdat['matuntcod'];
                        break;
                    }
                }

                if(!$lv_found){
                    $lv_reqqty = $lv_row['matqty'];
                    $lv_requntcod = $lv_row['matuntcod'];
                }
                
                
                //cabecera
								$lv_buffer .= '<tr name="stkhdr">'.
															'<td><a class="card-icon" data-key="'.$lv_key.'"><i class="fas fa-chevron-right"></i></a></td>'.
															'<td><small>'.$lv_row['mattxt'].'<br>#'.$lv_row['matcod'].($lv_row['matcodext']?'&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;'.$lv_row['matcodext']:'').'</small></td>'.
															'<td class="text-right">'.number_format($lv_reqqty).'</td>'.
															'<td>'.$lv_requntcod.'</td>'.
															//'<td name="td_qty" class="text-right"></td>'.
                  						'<td class="text-right">'.number_format(floatval($lv_row['matresqty'])).'</td>'.
															'<td>'.$lv_row['matuntcod'].'</td>'.
															'<td>'.$lv_rowbchcodext.($lv_row['matbchcod']!=0?'<br><small>#'.$lv_row['matbchcod'].'</small>':'').'</td>'.
															'<td>'.$lv_rowsercodext.($lv_row['matsercod']!=0?'<br><small>#'.$lv_row['matsercod'].'</small>':'').'</td>'. 
															'</tr>';
							}
              //registro de stock
							if( !isset($lv_row['stkmovdoccod']) ){
								$lv_buffer .= '<tr data-key="'.$lv_key.'" class="bg-info hidden">'.
															'<td></td><td>STOCK</td><td></td><td></td>'.
															'<td class="text-right">'.number_format(floatval($lv_row['matstkqty'])).'</td>'.
															'<td>'.$lv_row['matuntcod'].'</td>'.
                              '<td></td>'.
                  						'<td></td>'.
															'</tr>';
							} 
              //registro de reserva
              else {
								$lv_qty -= $lv_row['matbseqty'];
								$lv_buffer .= '<tr data-key="'.$lv_key.'" class="bg-info hidden">'.
															'<td></td>'.
															'<td>#'.$lv_row['stkmovdoccod'].' - '.date_format($lv_row['stkmovdocdte'],'d/m/Y').'</td>'.
															'<td class="text-right">'.number_format($lv_row['matqty']*-1).'</td>'.
															'<td>'.$lv_row['matuntcod'].'</td>'.
															'<td  class="text-right"></td>'.
                  						'<td></td>'.
                              '<td></td>'.
                  						'<td></td>'. 
															'</tr>';
							}
            }
            echo $lv_buffer;
  				?>
        </tbody>
      </table>
			
    </div> <!-- /card-body -->
  </div> <!-- /card --> 
	<script>
		$("#<?= $lv_sec; ?> #stktbl tbody tr td a").on("click",function(e){ e.preventDefault();
			var lv_hde = $(this).find("i:first").hasClass("fa-chevron-right");
			$(this).find("i:first").removeClass( (lv_hde?"fa-chevron-right":"fa-chevron-down") ).addClass( (!lv_hde?"fa-chevron-right":"fa-chevron-down") )
			$("#<?= $lv_sec; ?> #stktbl tbody tr[data-key='"+$(this).data("key")+"']").toggleClass("hidden");
		});
		
		// actualizo totales por cabecera
		$(function(){
			$("#<?= $lv_sec; ?> #stktbl tbody tr[name='stkhdr']").each(function(){
				var lv_key = $(this).find("td a:first").data("key");
				var lv_qty = $("#<?= $lv_sec; ?> #stktbl tbody tr[data-key='"+lv_key+"']:last").find("td[name='td_qty']").html();
				$(this).find("td[name='td_qty']").html( lv_qty );
			});
		});
	</script>
<section>