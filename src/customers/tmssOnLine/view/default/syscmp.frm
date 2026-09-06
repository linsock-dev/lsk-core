<?php		
	// url del formulario 
  $lv_lnk = '?prg=syscmp';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->comparission;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'CMP';
	$vew_actcod = '02';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
      <ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '28'});" class="btn btn-success navbar-btn tmssAlwaysEnabled" title="Comparar"><span class="fas fa-sync"></span><span class="hidden-xs"> Comparar</span></a>
      </ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '38'});" class="btn btn-default navbar-btn tmssAlwaysEnabled" title="Comparar Archivos"><span class="far fa-file-code"></span><span class="hidden-xs"> Comparar Archivos</span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
    </div>
  </nav>
	
	<?php
	$lv_buffer='';
	$x=0;
	$y=0;
	$row=0;
	$rowdif=0;
	$lv_showcmpmsg=0;
	if ( $vew_srccnx!='' && $vew_dstcnx!='' ) {
		$lv_showcmpmsg=1;
		$exit=0;
		while( $exit==0 ) {
			if ( $x>=count($vew_obj_src) && $y>=count($vew_obj_dst) ) { 
				$exit=1;
			} else if ( $x>=count($vew_obj_src) ) {
				$lv_buffer .= '<tr><td></td><td><a href="#" class="btn btn-warning syscmpset" data-objid="'.$vew_obj_dst[$y]['id'].'" data-objtyp="'.trim($vew_obj_dst[$y]['xtype']).'" data-way="tosrc" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_dst[$y]['name'].'"><span class="fas fa-arrow-left"></span></a></td><td>'.$vew_obj_dst[$y]['name'].'</td></tr>';
				$rowdif++;
				$y++;
			} else if ( $y>=count($vew_obj_dst) ) {
				$lv_buffer .= '<tr><td>'.$vew_obj_src[$x]['name'].'</td><td><a href="#" class="btn btn-warning syscmpset" data-objid="'.$vew_obj_src[$x]['id'].'" data-objtyp="'.trim($vew_obj_src[$x]['xtype']).'" data-way="todst" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_src[$x]['name'].'"><span class="fas fa-arrow-right"></span></a></td><td></td></tr>';
				$rowdif++;
				$x++;
			} else if ( strtolower($vew_obj_src[$x]['name'])>strtolower($vew_obj_dst[$y]['name']) ) {
				$lv_buffer .= '<tr><td></td><td><a href="#" class="btn btn-warning syscmpset" data-objid="'.$vew_obj_dst[$y]['id'].'" data-objtyp="'.trim($vew_obj_dst[$y]['xtype']).'" data-way="tosrc" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_dst[$y]['name'].'"><span class="fas fa-arrow-left"></span></a></td><td>'.$vew_obj_dst[$y]['name'].'</td></tr>';
				$rowdif++;
				$y++;
			} else if ( strtolower($vew_obj_src[$x]['name'])<strtolower($vew_obj_dst[$y]['name']) ) {
				$lv_buffer .= '<tr><td>'.$vew_obj_src[$x]['name'].'</td><td><a href="#" class="btn btn-warning syscmpset" data-objid="'.$vew_obj_src[$x]['id'].'" data-objtyp="'.trim($vew_obj_src[$x]['xtype']).'" data-way="todst" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_src[$x]['name'].'"><span class="fas fa-arrow-right"></span></a></td><td></td></tr>';
				$rowdif++;
				$x++;
			} else {
				$lv_buffer2='';
				$lv_buffer3='';
				$x_col=0;
				$y_col=0;
				$exit_col=0;
				$lo_src=array();
				$lo_dst=array();
				$lv_dif=0;
				// ************************************************************************************ 
				// TABLA - comparo CAMPOS, CLAVES PRIMARIAS e INDICES																		
				// ************************************************************************************ 
				if ( trim($vew_obj_src[$x]['xtype'])=='U' ) {
					
					// ************************************************************************************ 
					// CAMPOS
					// ************************************************************************************ 
					for( $i=0; $i<count($vew_col_src); $i++) { if( $vew_obj_src[$x]['id']==$vew_col_src[$i]['id'] ) {$lo_src[] = $vew_col_src[$i];} }
					for( $i=0; $i<count($vew_col_dst); $i++) { if( $vew_obj_dst[$y]['id']==$vew_col_dst[$i]['id'] ) {$lo_dst[] = $vew_col_dst[$i];} }
					while ( $exit_col==0 ) {
						if ( $x_col>=count($lo_src) && $y_col>=count($lo_dst) ) {
							$exit_col=1;
						} else if( $x_col>=count($lo_src) ) {
							$lv_buffer3 .= '<tr><td></td><td><span class="fas fa-arrow-left"></span></td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';
							$lv_dif=1;
							$y_col++;
						} else if( $y_col>=count($lo_dst) ) {
							$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td><span class="fas fa-arrow-right"></span></td><td></td></tr>';
							$lv_dif=1;
							$x_col++;
						} else if( strtolower($lo_src[$x_col]['name'])>strtolower($lo_dst[$y_col]['name']) ) {
							$lv_buffer3 .= '<tr><td></td><td><span class="fas fa-arrow-left"></span></td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';			
							$lv_dif=1;
							$y_col++;
						} else if( strtolower($lo_src[$x_col]['name'])<strtolower($lo_dst[$y_col]['name']) ) {
							$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td><span class="fas fa-arrow-right"></span></td><td></td></tr>';
							$lv_dif=1;
							$x_col++;
						} else if($lo_src[$x_col]['xtype']!=$lo_dst[$y_col]['xtype']
											|| $lo_src[$x_col]['typestat']!=$lo_dst[$y_col]['typestat']
											|| $lo_src[$x_col]['prec']!=$lo_dst[$y_col]['prec']
											|| $lo_src[$x_col]['scale']!=$lo_dst[$y_col]['scale']
											|| $lo_src[$x_col]['isnullable']!=$lo_dst[$y_col]['isnullable']
											// || $lo_src[$x_col]['colorder']!=$lo_dst[$y_col]['colorder'] 
											) {
							
							$lv_buffer4=($lo_src[$x_col]['xtype']!=$lo_dst[$y_col]['xtype']?$lo_src[$x_col]['xtype'].'< xtype >'.$lo_dst[$y_col]['xtype'].'<br>':'')
													. ($lo_src[$x_col]['xtypename']!=$lo_dst[$y_col]['xtypename']?$lo_src[$x_col]['xtypename'].'< xtypename >'.$lo_dst[$y_col]['xtypename'].'<br>':'')
													// . ($lo_src[$x_col]['typestat']!=$lo_dst[$y_col]['typestat']?$lo_src[$x_col]['typestat'].'< typestat >'.$lo_dst[$y_col]['typestat'].'<br>':'') 
													. ($lo_src[$x_col]['isnullable']!=$lo_dst[$y_col]['isnullable']?$lo_src[$x_col]['isnullable'].'< <span alt="1-identity">isnullable</span> >'.$lo_dst[$y_col]['isnullable'].'<br>':'')
													. ($lo_src[$x_col]['prec']!=$lo_dst[$y_col]['prec']?$lo_src[$x_col]['prec'].'< prec >'.$lo_dst[$y_col]['prec'].'<br>':'')
													. ($lo_src[$x_col]['scale']!=$lo_dst[$y_col]['scale']?$lo_src[$x_col]['scale'].'< <span alt="decimales">scale</span> >'.$lo_dst[$y_col]['scale'].'<br>':'')
													// . ($lo_src[$x_col]['colorder']!=$lo_dst[$y_col]['colorder']?$lo_src[$x_col]['colorder'].'< colorder >'.$lo_dst[$y_col]['colorder'].'<br>':'') 
													;
							
							$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td>'.$lv_buffer4.'</td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';
							$lv_dif=1;
							$x_col++;
							$y_col++;
						} else {
							//$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td></td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';
							$x_col++;
							$y_col++;
						}
					}
					$lv_buffer2 .= '<h3>'.$vew_obj_src[$x]['name'].'</h3><table class="table table-condensed table-striped table-bordered"><theader><tr><th colspan="10">Campos</th></tr></theader><tbody>'.$lv_buffer3.'</tbody></table>';
					
		
					// ************************************************************************************ 
					// CLAVE PRIMARIA - INDICES
					// ************************************************************************************ 
					$lv_buffer3='';
					$lo_src = array();
					$lo_dst = array();
					$x_col=0;
					$y_col=0;
					$exit_col=0;
					for( $i=0; $i<count($vew_inx_src); $i++) { if( $vew_obj_src[$x]['id']==$vew_inx_src[$i]['id'] ) {$lo_src[] = $vew_inx_src[$i];} }
					for( $i=0; $i<count($vew_inx_dst); $i++) { if( $vew_obj_dst[$y]['id']==$vew_inx_dst[$i]['id'] ) {$lo_dst[] = $vew_inx_dst[$i];} }
					while ( $exit_col==0 ) {
						if ( $x_col>=count($lo_src) && $y_col>=count($lo_dst) ) {
							$exit_col=1;
						} else if ( $x_col>=count($lo_src) ) {
							$lv_buffer3 .= '<tr><td></td><td><a href="#" class="btn btn-warning syscmpupd" data-objid="'.$lo_dst[$y_col]['id'].'" data-objtyp="'.($lo_dst[$y_col]['is_primary_key']==1?'PK':'IX').'" data-way="tosrc" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_src[$x]['name'].'" data-objnme2="'.$lo_dst[$y_col]['name'].'"><span class="fas fa-arrow-left"></span></a></td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';
							$lv_dif=1;
							$y_col++;
						} else if ( $y_col>=count($lo_dst) ) {
							$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td><a href="#" class="btn btn-warning syscmpupd" data-objid="'.$lo_src[$x_col]['id'].'" data-objtyp="'.($lo_src[$x_col]['is_primary_key']==1?'PK':'IX').'" data-way="todst" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_src[$x]['name'].'" data-objnme2="'.$lo_src[$x_col]['name'].'"><span class="fas fa-arrow-right"></span></a></td><td></td></tr>';
							$lv_dif=1;
							$x_col++;
						} else if ( strtolower($lo_src[$x_col]['name'])>strtolower($lo_dst[$y_col]['name']) ) {
							$lv_buffer3 .= '<tr><td></td><td><a href="#" class="btn btn-warning syscmpupd" data-objid="'.$lo_dst[$y_col]['id'].'" data-objtyp="'.($lo_dst[$y_col]['is_primary_key']==1?'PK':'IX').'" data-way="tosrc" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_src[$x]['name'].'" data-objnme2="'.$lo_dst[$y_col]['name'].'"><span class="fas fa-arrow-left"></span></a></td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';			
							$lv_dif=1;
							$y_col++;
						} else if ( strtolower($lo_src[$x_col]['name'])<strtolower($lo_dst[$y_col]['name']) ) {
							$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td><a href="#" class="btn btn-warning syscmpupd" data-objid="'.$lo_src[$x_col]['id'].'" data-objtyp="'.($lo_src[$x_col]['is_primary_key']==1?'PK':'IX').'" data-way="todst" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_src[$x]['name'].'" data-objnme2="'.$lo_src[$x_col]['name'].'"><span class="fas fa-arrow-right"></span></a></td><td></td></tr>';
							$lv_dif=1;
							$x_col++;
						} else {
							$lv_buffer3 .= '<tr><td>'.$lo_src[$x_col]['name'].'</td><td>(falta comparar)</td><td>'.$lo_dst[$y_col]['name'].'</td></tr>';
							$x_col++;
							$y_col++;
						}
					}
					$lv_buffer2 .= '<br><table class="table table-condensed table-striped table-bordered"><theader><tr><th colspan="10">Clave Primaria & Indices</th></tr></theader><tbody>'.$lv_buffer3.'</tbody></table>';
							
		
				// ************************************************************************************ 
				// STOREDPROCEDURES / FUNCIONES																													
				// ************************************************************************************ 
				// comparar texto de SP
				} else if ( trim($vew_obj_src[$x]['xtype'])=='P' || trim($vew_obj_src[$x]['xtype'])=='FN' || trim($vew_obj_src[$x]['xtype'])=='TF' ) {
					$lv_dif=0;
					$lv_src='';
					$lv_dst='';
					$lv_buffer2 = '';
					for( $i=0; $i<count($vew_cmt_src); $i++) { if( $vew_obj_src[$x]['id']==$vew_cmt_src[$i]['id'] ) {$lv_src .= $vew_cmt_src[$i]['text'];} }
					for( $i=0; $i<count($vew_cmt_dst); $i++) { if( $vew_obj_dst[$y]['id']==$vew_cmt_dst[$i]['id'] ) {$lv_dst .= $vew_cmt_dst[$i]['text'];} }
					if ( $lv_src!=$lv_dst ) {
						$lv_buffer2 .= '<div class="row"><div class="col-xs-3">';
						$lv_buffer2 .= '<a href="#" class="btn btn-info syscmpupd" data-objid="'.$vew_obj_dst[$y]['id'].'" data-objtyp="'.trim($vew_obj_dst[$y]['xtype']).'" data-way="tosrc" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_dst[$y]['name'].'"><span class="fas fa-arrow-left"></span> Traer</a>';
						$lv_buffer2 .= '</div><div class="col-xs-6">';
						$lv_buffer2 .= '[<span>Iguales en ambos sistemas</span>]<br>[<ins style="background:#e6ffe6;">Existe en Origen y no en Destino</ins>]<br>[<del style="background:#ffe6e6;">Existe Destino y no en Origen</del>]';
						$lv_buffer2 .= '</div><div class="col-xs-3">';
						$lv_buffer2 .= '<a href="#" class="btn btn-success syscmpupd" data-objid="'.$vew_obj_dst[$y]['id'].'" data-objtyp="'.trim($vew_obj_dst[$y]['xtype']).'" data-way="todst" data-cnxsrc="'.$vew_srccnx.'" data-cnxdst="'.$vew_dstcnx.'" data-objnme="'.$vew_obj_dst[$y]['name'].'">Enviar <span class="fas fa-arrow-right"></span></a>';
						$lv_buffer2 .= '</div></div>';
						$lv_buffer2 .= '<textarea class="srccmt" style="display: none;">'.$lv_src.'</textarea><textarea class="dstcmt" style="display: none;">'.$lv_dst.'</textarea>';
						$lv_buffer2 .= '<div class="cmtdif"></div>';
						$lv_dif=1;
					}
					
				} else {
					$lv_buffer2 = '<h3>OBJETO DESCONOCIDO: ['.trim($vew_obj_src[$x]['xtype']).'] </H3>';
					$lv_dif=1;
				}
				if ( $lv_dif!=0 || ($lv_dif==0 && $vew_shwdif=='') ) {
				$lv_buffer .= '<tr><td>'.$vew_obj_src[$x]['name'].'</td><td>'.($lv_dif==0?'<span class="far fa-thumbs-up"></span>':'<div id="'.$vew_obj_src[$x]['id'].'" style="display: none;">'.$lv_buffer2.'</div><a href="#" name="btncompare" class="btn btn-primary" data-objid="'.$vew_obj_src[$x]['id'].'" data-objtyp="'.trim($vew_obj_src[$x]['type']).'"><span class="fas fa-exchange-alt"></span></a>').'</td><td>'.$vew_obj_dst[$y]['name'].'</td></tr>';
				}
				if ($lv_dif!=0) { $rowdif++; }
				$x++;
				$y++;
			}
			$row++;
		}
		$row--;
	}
	?>

	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
	<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
	<div class="container-fluid">
		<div class="panel panel-default">
			<div class="panel-body">
				<div class="row">
					<div class="col-md-8">
						<div class="radio">
							<label>
								<input type="radio" name="cmptyp" id="cor" value="cor" <?= ($vew_cmptyp=='cor'?'checked':''); ?>>
								<strong>CORE</strong>: central de desarrollo (<strong>tmssSysDev <span class="fas fa-exchange-alt"></span> tmssSysPrd</strong>)central de producción
							</label>
						</div>
						<div class="radio">
							<label>
								<input type="radio" name="cmptyp" id="dev" value="dev" <?= ($vew_cmptyp=='dev'?'checked':''); ?>>
								<strong>DEVELOPER</strong>: modelo de producción (<strong>tmssCusPrd <span class="fas fa-exchange-alt"></span> tmssTemasisDev</strong>) desarrollo
							</label>
						</div>
						<div class="radio">
							<label>
								<input type="radio" name="cmptyp" id="cus" value="cus" <?= ($vew_cmptyp=='cus'?'checked':''); ?>>
								<strong>CUSTOMER</strong>: modelo de producción (<strong>tmssCusPrd <span class="fas fa-exchange-alt"></span> tmss< Customer ></strong>) cliente productivo
								<select class="form-control" name="devcuscnx">
									<option value="X000021470" <?= ($vew_devcuscnx=='X000021470'?'selected':''); ?> >Temasis</option>
									<option value="">-------</option>
									<option value="X000050647" <?= ($vew_devcuscnx=='X000050647'?'selected':''); ?> >Team</option>
									<!--<option value="X000051319" <?= ($vew_devcuscnx=='X000051319'?'selected':''); ?> >Austral</option>-->
									<option value="X000017277" <?= ($vew_devcuscnx=='X000017277'?'selected':''); ?> >Supply</option>
									<option value="X000033429" <?= ($vew_devcuscnx=='X000033429'?'selected':''); ?> >Coordline</option>
									<!--<option value="X000033772" <?= ($vew_devcuscnx=='X000033772'?'selected':''); ?> >San Miguel</option>-->
									<option value="">-------</option>									
									<option value="X000020706" <?= ($vew_devcuscnx=='X000020706'?'selected':''); ?> >General-Deportes</option>
									<option value="X000016151" <?= ($vew_devcuscnx=='X000016151'?'selected':''); ?> >General-Logistica</option>
									<option value="X000059069" <?= ($vew_devcuscnx=='X000059069'?'selected':''); ?> >General-Salud</option>
									<option value="X000099641" <?= ($vew_devcuscnx=='X000099641'?'selected':''); ?> >General-Gastronomia</option>
								</select>
							</label>
						</div>
					</div> <!-- /col-md-10 -->
					<div class="col-md-4">
						<select id="shwdif" name="shwdif" class="form-control"><option value="" <?= ($vew_shwdif==''?'SELECTED':''); ?>>Mostrar todo</option><option value="dif" <?= ($vew_shwdif==''?'':'SELECTED'); ?>>Mostrar diferencias</option></select><br>
					</div>
				</div> <!-- /row -->
			</div> <!-- /panel-body -->
		</div> <!-- /panel -->
	</div> <!-- /container-fluid -->
	</form>
		
	<div class="container-fluid">
		<table class="table table-striped table-bordered table-condensed">
			<thead><tr><th>Obj Origen <?= $x; ?><br>(<?= round($x*100/($row<=0?1:$row),2); ?>%)</th><th>Obj Totales <?= ($row<=0?0:$row); ?><br>dif <?= $rowdif; ?> (<?= round($rowdif*100/($row<=0?1:$row),2); ?> %)</th><th>Obj Destino <?= $y; ?><br>(<?= round($y*100/($row<=0?1:$row),2); ?>%)</th></tr></thead>
			<tbody><?= $lv_buffer; ?></tbody>
		</table>
	</div>

	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title" id="myModalLabel">Comparación de Objetos</h4>
				</div>
				<div class="modal-body">
					...
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<form id="cmpfrmset" method="POST">
		<input type="hidden" id="objid" name="objid" value="">
		<input type="hidden" id="objnme" name="objnme" value="">
		<input type="hidden" id="objnme2" name="objnme2" value="">
		<input type="hidden" id="objtyp" name="objtyp" value="">
		<input type="hidden" id="way" name="way" value="">
		<input type="hidden" id="cnxsrc" name="cnxsrc" value="">
		<input type="hidden" id="cnxdst" name="cnxdst" value="">
	</form>
	<script>		
	
		tmssLoadScript("picadiff",function(){});
	
		$("a[name='btncompare']").on("click",function(e){
			if ( $(this).data("objtyp")=='P' || $(this).data("objtyp")=='FN' || $(this).data("objtyp")=='TF' ) {
				var dmp = new diff_match_patch();
				var text2 = $("#"+$(this).data("objid") + " .srccmt").val();
				var text1 = $("#"+$(this).data("objid") + " .dstcmt").val();
				dmp.Diff_Timeout = parseFloat(0);
				var d = dmp.diff_main(text1, text2);
				var ds = dmp.diff_prettyHtml(d);
				ds = ds.replace(/#e6ffe6/g,"#66ff66");
				ds = ds.replace(/#ffe6e6/g,"#ff6666");
				$("#"+$(this).data("objid")+" .cmtdif").html( ds );
			}
			$(".modal-body").html( $("#"+$(this).data("objid")).html() );
			$("#myModal").modal("show");
			e.preventDefault();
			
			// agrego eventos a botones
			$(".syscmpupd").on("click",function(e) {
				$("#cmpfrmset #objid").prop("value", $(this).data("objid"));
				$("#cmpfrmset #objnme").prop("value", $(this).data("objnme"));
				$("#cmpfrmset #objnme2").prop("value", $(this).data("objnme2"));
				$("#cmpfrmset #objtyp").prop("value", $(this).data("objtyp"));
				$("#cmpfrmset #way").prop("value", $(this).data("way"));
				$("#cmpfrmset #cnxsrc").prop("value", $(this).data("cnxsrc"));
				$("#cmpfrmset #cnxdst").prop("value", $(this).data("cnxdst"));
				$("#myModal").modal("hide");
				$.ajax({
					type: "POST",
					url: "index.php?prg=syscmp&act=72",
					data: $("#cmpfrmset").serialize()
				}).always( function(data, textStatus, errorThrown) {
						toastr.options.closeButton = true;
						toastr.options.progressBar=true;
						if (data=="") {
							toastr.options.timeOut= 2000;
							toastr.info( "Objeto enviado<br>"+data, "Sincronización" );
						} else {
							toastr.options.timeOut= 4000;
							toastr.warning( "Objeto enviado con mensajes:<br>"+data, "Sincronización" );
						}
				});
				e.preventDefault(); 
			});			
		});
		
		<?php	if ($lv_showcmpmsg==1) { ?>
		toastr.options.closeButton = true;
		toastr.options.timeOut= 2000;
		toastr.options.progressBar=true;
		toastr.info( "Comparación realizada", "Sincronización" );
		<?php } ?>
		
		$(".syscmpset").on("click",function(e) {
			$("#cmpfrmset #objid").prop("value", $(this).data("objid"));
			$("#cmpfrmset #objnme").prop("value", $(this).data("objnme"));
			$("#cmpfrmset #objtyp").prop("value", $(this).data("objtyp"));
			$("#cmpfrmset #way").prop("value", $(this).data("way"));
			$("#cmpfrmset #cnxsrc").prop("value", $(this).data("cnxsrc"));
			$("#cmpfrmset #cnxdst").prop("value", $(this).data("cnxdst"));
			$(this).parent().parent().addClass("info")
			$.ajax({
				type: "POST",
				url: "index.php?prg=syscmp&act=71",
				data: $("#cmpfrmset").serialize()
			}).always( function(data, textStatus, errorThrown) {
					toastr.options.closeButton = true;
					toastr.options.timeOut= 2000;
					toastr.options.progressBar=true;
					toastr.info( "Objeto enviado<br>"+data, "Sincronización" );
			});
			e.preventDefault(); 
		});	
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $('#<?= $lv_sec; ?>_frm'), '<?= $lv_lnk; ?>', function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, '<?= $lv_title; ?>', '<b><?= $lv_dockey; ?></b>' ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=='04') {
					tmssTabSecCls( $('#<?= $lv_sec; ?>') );
				} else {
					$('#<?= $lv_sec; ?>').replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				gv_<?= $lv_sec; ?>_last_action = lp_prm['action'];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=='99'?'<?= ($vew_actcod=='02'?'02':'03'); ?>':gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( '<?= $lv_sec; ?>', lv_action, '<?= $lv_title; ?>', '<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>' );
			}
		}
		
		// edit mode
    tmssFormEdit('<?= $lv_sec; ?>',<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>		
</section>