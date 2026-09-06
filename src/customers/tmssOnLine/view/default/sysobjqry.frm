<?php
	// url del formulario
  $lv_lnk = "?prg=sysobj&act=dbquery";

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->queries;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'EDQ';

	$vew_actcod = '01';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');

	$vew_tbl['btnexe'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->execute, 'id'=>'btnexe','icn'=>'fas fa-bolt', 'css'=>'btn navbar-btn btn-success tmssAlwaysEnabled ', 'acc'=>'' );
  $vew_tbl['sveL'] = array('per'=>false);
  $vew_tbl['sveR'] = array('per'=>false);
  $vew_tbl['canc'] = array('per'=>false);
  $vew_tbl['accL'] = array('per'=>false);
	$vew_tbl['accR'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['delsep'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
	
	$vew_tbl_int['rfrsh'] = array('id'=>'btnrfh', 'acc'=>$lv_sec.'_fnc({action: "dbquery"})', 'css'=>'tmssOpt', 'icn'=>'fas fa-sync-alt', 'ttl'=>$vew_lang->refresh);
	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <?php include('grldocfrmtlb.frm'); ?>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<div class="card">
			<div class="card-header"><div class="card-title"><?= $vew_lang->query; ?></div></div>
			<div class="card-body tmss-card-body-edit">
				<?= vew_boot($lv_col210, array("label"=>$vew_lang->query, 'input'=>gethtml('qrystr', 'doccmt4x50', '', $lv_default) )); ?>
				<hr><p><?= $vew_lang->result; ?></p><div id="qryret"></div>
			</div>
		</div><!-- /card -->
	</form>
	<script>
		// EJECUTAR. ejecuta la sentencia SQL
		$("#<?= $lv_sec; ?> #btnexe").on("click",function(e){ e.preventDefault();
			// prepara llamada
			var lv_pstdat = [{name:"qrystr",value:$("#<?= $lv_sec; ?> #qrystr").prop("value")}];
			// ejecuta sentencia
			tmssCallProcess("?prg=sysobj&act=dbquery_execute",lv_pstdat,function(data){
				// muestra tabla con datos
				var lv_tmp = "<table class='table table-condensed table-hover table-bordered'>";
				if(typeof data=="object"){
					// armo cabecera
					lv_tmp += "<thead><tr>";
					$.each(data[0], function(index, value){
						lv_tmp += "<th>"+index+"</th>";
					});
					lv_tmp += "</tr></thead>";
					// armo cuerpo
					lv_tmp += "<tbody>";
					$.each(data, function(index, value){
						lv_tmp += "<tr>";
						$.each(value, function(index2, value2){
							if(typeof value2=="object"){
								if(value2!=null){
									if(typeof value2.date=="string"){ value2 = moment( value2.date ).format('Y-MM-DD HH:mm'); }
								}
								lv_tmp += "<td>"+value2+"</td>";
							} else {
								lv_tmp += "<td>"+value2+"</td>";
							}
						});
						lv_tmp += "<tr>";
					});
					lv_tmp += "</tbody>"
				}
				lv_tmp += "</table>";
				$("#<?= $lv_sec; ?> #qryret").html( lv_tmp );
			});
		});
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>