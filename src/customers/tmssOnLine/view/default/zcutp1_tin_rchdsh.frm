<?php
	// url del formulario 
  $lv_lnk = "?prg=zcutp1_tin";

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->patient;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="tmssLink('?prg=zcutp1_tin&act=rchfrm01', [{target: '_new_section'}] );"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->load; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?= $vew_lang->load; ?></span></a>			
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
    <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
      <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
      
			<div class="container-fluid">
				<div class="row">		
					<div class="col-sm-2"><img class="img-responsive" src="view\default\library\images\logos\roche.jpg"></div>
					<div class="col-sm-10">
						<table id="pattbl" class="table table-hover">
							<thead>
								<tr valign="top" name="lnkstu">
									<th> <?= $vew_lang->class ?> </th>
									<th> <?= $vew_lang->id ?> </th>
									<th> <?= $vew_lang->protocol ?> </th>
									<th> <?= $vew_lang->status ?> </th>
								</tr>
							</thead>
							<tbody>
								<?php foreach ($vew_patlst as $value) { ?>
									<tr>
										<td><?= $value['sysdocclstxt']; ?></td>
										<td><?= $value['patcod']; ?></td>
										<td><?= $value['patpro']; ?></td>
										<td><?= $value['docsts']; ?></td>
									</tr>
								<?php } ?>
							</tbody>
						</table>
					</div>
				</div>
				<hr>
				<div id="datqty">
					<span class='pagination-info'>Registros encontrados <span class='badge'><?= count($vew_patlst); ?></span></span>
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
			var lv_patcod = $(this).find("td").eq(1).text();
			tmssLink("?prg=zcutp1_tin&act=rchfrm03&prm_patcod="+lv_patcod, [{target: '_new_section'}] );
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"rchdsh":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>