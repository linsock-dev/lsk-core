<?php
	// url del formulario
  $lv_lnk = '?prg=grldocflw';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->status;
	
	// módulo y programa
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'DCS';

	$vew_actcod = '02';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>	

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<?= gethtml('srcobjtyp', 'hidden', ($vew_dathdr['srcobjtyp']??'') ); ?>
		<?= gethtml('srcobjcod', 'hidden', ($vew_dathdr['srcobjcod']??'') ); ?>

		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
					
					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->documentflow; ?></div></div>
						<div class="card-body tmss-card-body-edit">
							<div id="treeview">
								<?php
									$lv_trearr = $vew_dathdr['treflw'];
                	$lv_perarr = array();
                	if (isset($lv_trearr['errcod']) && $lv_trearr['errcod'] != 0){
                    echo "<script>toastr.warning('El documento seleccionado no existe o fue eliminado.', 'Error');</script>";
                  }else{
                    echo '<ul>'.treeLoop($lv_trearr, $vew_dathdr['objtyp'], '', $vew_sec, $lv_perarr).'</ul>';
                  }
                
                	// recursiva para el armado de arbol de documentos
                  function treeLoop(&$lp_object, &$lp_objtyp, $lp_key, $vew_sec, &$lp_perarr){
                    $lv_out = '';
                    // recorro todos los nodos
                    foreach ($lp_object as &$lv_row){
                      $lv_doctyp = ( $lv_row['nivel']>=0 ? $lv_row['refobjtyp'] : $lv_row['srcobjtyp'] );
                      $lv_doccod = ( $lv_row['nivel']>=0 ? $lv_row['refobjcod'] : $lv_row['srcobjcod'] );
                      if(empty($lp_perarr[$lv_doctyp])){
                        $lv_per = ( $vew_sec->hasPermission(explode('_',$lv_doctyp)[0],explode('_',$lv_doctyp)[1],'03') ? 'Y' : 'N' );
                        $lp_perarr[$lv_doctyp] = $lv_per;
                     }
                
                      foreach($lp_objtyp as $lv_rowobj){
                        if($lv_rowobj['objtypcod']==$lv_doctyp){
                          // si el nodo no esta procesado y coincide con la clave de parametros o no se informa clave de parametros, se agrega
                          if( $lv_row['verificado']!=2 && ($lp_key==$lv_row['srcobjtyp'].$lv_row['srcobjcod'] || $lp_key=='') ){
                            // marco el nodo para no volver a procesarlo
                            $lv_row['verificado'] = 2;
                            // agrego el item a la lista
                            $lv_out .= '<li><'.( $lp_perarr[$lv_doctyp]=='N' || $lv_row['nivel']==0 ? 'span '.($lv_row['nivel']==0 ? 'class="tmss-bold" data-act="X"' : '') : 'a href="#" name="document_link" data-srcobjtyp="'.$lv_doctyp.'" data-srcobjcod="'.$lv_doccod.'"').'>'
                              						.explode('(', $lv_rowobj['objtyptxt'])[0].' #'.$lv_doccod
                              					.'</'.( $lp_perarr[$lv_doctyp]=='N' || $lv_row['nivel']==0 ? 'span' : 'a' ).'>';
                            // busco si hay nodos dependientes
                            $lv_list = treeLoop($lp_object, $lp_objtyp, $lv_row['refobjtyp'].$lv_row['refobjcod'], $vew_sec, $lp_perarr);
                            // si hay nodos dependientes, los agrego como lista
                            if ($lv_list!=''){ $lv_out.='<ul>'.$lv_list.'</ul>'; }
                            $lv_out .= '</li>'; 
                          }
                        }
                      }
                    }
                    unset($lv_row);
                    return $lv_out;
                  } 
								?>
							</div>
						</div>
					</div> <!--/card-->
					
				</div><!-- /col -->
				<div class="col-sm-8">
				
					<div class="card">
						<div class="card-header"><div class="card-title">Materiales del Documento</div></div>
						<div class="card-body tmss-card-body-edit">
							<table class="table table-condensed">
								<thead>
									<tr>
										<th></th>
										<th><?= $vew_lang->material; ?></th>
										<th><?= $vew_lang->description; ?></th>
										<th><?= $vew_lang->quantity; ?></th>
										<th><?= $vew_lang->treatment; ?></th>
									</tr>
								</thead>
								<tbody>
									<?php foreach($vew_datpos as $lv_row) { ?>
										<tr class="matrow" onclick="<?= $lv_sec; ?>_openQtyFlow(<?= $lv_row['srcposcod']?>)">
											<td><i class="fas fa-caret-right"></i></td>
											<td><?= $lv_row['matcod']; ?><br><span class="visible-xs"><?= $lv_row['mattxt']; ?></span></td>
											<td><?= $lv_row['mattxt']; ?></td>
											<td align="right"><?= ( is_numeric($lv_row['matqty']) ? number_format( $lv_row['matqty'] ) : $lv_row['matqty'] ); ?></td>											
											<td class="<?= ($lv_row['sysdoctrecod']=='C'?'bg-success':($lv_row['sysdocrejcod']!=''?'bg-info':($lv_row['sysdoctrecod']=='P'?'bg-warning':''))); ?>"><?= $lv_row['sysdoctretxt'] . ($lv_row['sysdocrejcod']!='' && $lv_row['sysdocrejcod']!='0'?' / Rechazado':''); ?></td>
										</tr>
                    <?php
                    	$lv_objtyp = $vew_dathdr['objtyp'];
                      $lv_dstflw = $vew_dathdr['dstflw'];
                      foreach($lv_dstflw as $lv_rowsrc){
                        if($lv_rowsrc['srcposcod']==$lv_row['srcposcod']){
                         foreach($lv_objtyp as $lv_rowobj){
                          if($lv_rowobj['objtypcod']==$lv_rowsrc['refobjtyp']){
                    ?>
                      <tr class="hidden" data-srcposcod="<?= $lv_row['srcposcod']; ?>">
                        <td colspan="2"></td>
                        <td><?= '<'.( $lv_perarr[$lv_rowsrc['refobjtyp']]=='N' ? 'b' : 
                                     		'a href="#" name="document_link" data-srcobjtyp="'.$lv_rowsrc['refobjtyp'].'" data-srcobjcod="'.$lv_rowsrc['refobjcod'].'"'
                                    ).'>'.$lv_rowobj['objtyptxt'].' #'.$lv_rowsrc['refobjcod']
                      							.'</'.($lv_perarr[$lv_rowsrc['refobjtyp']]=='N' ? 'b' : 'a' ).'><br>'; ?></td>
                        <td class="text-right">
                          <?= '<div>'.number_format($lv_rowsrc['refposqty']).'</div>'; ?>
                          <?= ($lv_row['sysdocrejcod']!=''?'<br><b>Rechazo: <span class="text-danger">'.$lv_row['sysdocrejtxt'].'</span></b>':''); ?>
                        </td>
                      </tr>
                    <?php }}}}?>
                  	<?php if ($vew_dathdr['sysdoctrecod'] != 'N'){ 
                    	$lv_buffer =	'<tr class="hidden" data-srcposcod="'.$lv_row['srcposcod'].'">'.
                                  		'<td colspan="2"></td>'.
                                      '<td colspan="1"><div> Saldo </div></td>'.
                                      '<td colspan="1" class="text-right">';
                                      foreach($lv_dstflw as $lv_rowsrc){
                                        if($lv_rowsrc['srcposcod']==$lv_row['srcposcod']){
                                          foreach($lv_objtyp as $lv_rowobj){
                                            if($lv_rowobj['objtypcod']==$lv_rowsrc['srcobjtyp']){
                                              if (!(is_null($lv_rowsrc['srcposqty']))){
                                                $lv_buffer.= number_format($lv_rowsrc['refposqty']); 
                                              }
                                            }
                                          }
                                        }
                                      }
                    	$lv_buffer.=		'</td>'.
                    								'</tr>';
                      echo $lv_buffer;
                  }} ?>
								</tbody>
							</table>
						</div>
					</div> <!--/card-->
					
				</div> <!--/col-->
			</div> <!--/row-->
		</div> <!--/container-fluid-->
	</form>
	<script>
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_fnc({action: '99'}); }
    
    tmssLoadScript("jstree",function(){
			$("#<?= $lv_sec; ?> #treeview").jstree({
				"core": { "expand_selected_onload" : false, 
									"themes": {	"theme": "default", "responsive": false, "stripes" : false, "icons": "far fa-file"}, 
									"animation" : 0, 
									"check_callback" : function (operation) { return true; }
				},
				"types": {
					"default": {"icon" : "far fa-file icon-state-success"},
					"#": {"max_children" : 1, "max_depth" : 50, "valid_children" : ["root"] },
					"root": { "max_children" : 5, "icon": "far fa-file", "valid_children": ["folder"] },
					"folder": { "max_children" : 10000, "valid_children": ["folder","account"] },
					"account": { "max_children" : 0, "icon": "far fa-file", "valid_children": [] }
				},
				"plugins": [ "types", "unique" ]
			});
			$("#<?= $lv_sec; ?> #treeview").jstree();
			$("#<?= $lv_sec; ?> #treeview").jstree("open_all");
			$("#<?= $lv_sec; ?> #treeview").jstree("set_theme", "default");
      
			// attach eventos CLICK sobre documentos
			$("#<?= $lv_sec; ?> a[name='document_link']").on("click",function(e){ e.preventDefault();
				var lv_pstdat = [{name:"srcobjtyp",value:$(this).data("srcobjtyp")}, {name:"srcobjcod", value:$(this).data("srcobjcod")}];
				tmssLink("?prg=grldocflw&act=showdocument", [{target: "_new_section",post_data: lv_pstdat}]);
			});
      
    });
    
    function <?= $lv_sec; ?>_openQtyFlow(posID){
      $(".matrow").nextAll('tr[data-srcposcod="'+posID+'"]').toggleClass('hidden');
    }
  </script>
  <script>	
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {		
			if(lp_prm["action"]=="99"){lp_prm["action"]="statuslst";}
		}
  </script>	
	<?php include('grldocfrmscr.frm'); ?>
</section>