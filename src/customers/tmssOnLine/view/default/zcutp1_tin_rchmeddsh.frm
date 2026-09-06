<?php
	// url del formulario 
  $lv_lnk = "?prg=zcutp1_tin";

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->doctor;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" onclick="tmssLink('?prg=zcutp1_tin&act=rchmedfrm01', [{target: '_new_section'}] );"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?php echo $vew_lang->load; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?php echo $vew_lang->load; ?></span></a><?php } ?>			
			</ul>
			<ul class="navbar-right btn-toolbar tmss-navbar-right">
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>

	<div class="container-fluid">
    <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?php echo $lv_sec; ?>_frm">
      <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
      
      <div class="row">		
				<div class="container-fluid">
					<table id="pattbl" class="table table-hover" style="width:100%">
						<thead>
							<tr valign="top" name="lnkstu">
								<th> <?= $vew_lang->id ?> </th>
								<th> <?= $vew_lang->name ?> </th>
								<th> <?= $vew_lang->status ?> </th>
							</tr>
						</thead>
						<tbody>
							<?php foreach ($vew_patlst as $value) { ?>
								<tr>
									<td><?= $value['patcod']; ?></td>
									<td><?= $value['pattxt']; ?></td>
									<td><?= $value['docsts']; ?></td>
								</tr>
							<?php } ?>
						</tbody>
					</table>
					<hr>
					<div id="datqty">
						<span class='pagination-info'>Registros encontrados <span class='badge'><?= count($vew_patlst); ?></span></span>
					</div>	
				</div>
      </div>
    </form>
	</div>
	<script>
		function <?= $lv_sec; ?>__GridRefresh(){
			<?= $lv_sec; ?>_fnc({action: '99'});
		}
	</script>
	<script>
		//Evento click, obtengo el id de paciente a visualizar
		$("#<?= $lv_sec; ?> #pattbl tbody tr").click(function(){
			var lv_patcod = $(this).find("td").eq(0).text();
			tmssLink("?prg=zcutp1_tin&act=rchmedfrm03&prm_patcod="+lv_patcod, [{target: '_new_section'}] );
		});
	</script>	
  <script>
    var gv_<?php echo $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?php echo $lv_sec; ?>_frm"), "<?php echo $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?php echo $lv_sec; ?>_last_action, "<?php echo $lv_title; ?>", "<b><?php echo $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			gv_<?php echo $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"rchmeddsh":gv_<?php echo $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "<?php echo ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}
		
		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>