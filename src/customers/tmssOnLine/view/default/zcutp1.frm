<?php
	// url del formulario 
  $lv_lnk = 'index.php?prg=zcutp1';

	// campos requeridos 
	$vew_input->RequiredFields( array('dshstrdte','dshenddte') );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->dashboard;

	// módulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'TP1';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	$vew_actcod = '02';

	$lv_colarr = array(
	'"rgba(255, 99, 132, 1)"', '"rgba(54, 162, 235, 1)"', '"rgba(255, 206, 86, 1)"', '"rgba(75, 192, 192, 1)"', '"rgba(153, 102, 255, 1)"', '"rgba(255, 159, 64, 1)"',
	'"rgba(99, 255, 132, 1)"', '"rgba(162, 54, 235, 1)"', '"rgba(206, 255, 86, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(102, 153, 255, 1)"', '"rgba(159, 255, 64, 1)"',
	'"rgba(132, 99, 255, 1)"', '"rgba(235, 162, 54, 1)"', '"rgba(86, 206, 255, 1)"', '"rgba(192, 192, 75, 1)"', '"rgba(255, 102, 153, 1)"', '"rgba(64, 159, 255, 1)"',
	'"rgba(132, 255, 99, 1)"', '"rgba(235, 54, 162, 1)"', '"rgba(86, 255, 206, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(255, 153, 102, 1)"', '"rgba(64, 255, 159, 1)"'
	);
?>
<section id="<?= $lv_sec; ?>"  data-title="<?= $lv_title; ?>" style="background-color: #f6f6f6 !important;">
	<link href="view\default\library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><?= $vew_lang->reports; ?> <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<?php if ( 1==1) { ?><li><a href="#" id="btnrpt001">Rep. Evoluciones</a></li><?php } ?>
						<?php if ( 1==1) { ?><li><a href="#" id="btnrpt002">Rep. Gastos desg.</a></li><?php } ?>
            <?php if ( 1==1) { ?><li><a href="#" id="btnrpt003">Rep. Liquidaciones</a></li><?php } ?>
						<?php if ( strtolower($vew_sec->usrcod)=='cdominguez' || strtolower($vew_sec->usrcod)=='chisas' || strtolower($vew_sec->usrcod)=='mdominguez' || strtolower($vew_sec->usrcod)=='achaves' ) { ?>
							<li><a href="#" onclick="tmssLink('?prg=zcutp1_tin&act=rchdsh', [{target: '_new_section'}] );">Roche</a></li>
						<?php } ?>
						<?php if ( strtolower($vew_sec->usrcod)=='cdominguez' || strtolower($vew_sec->usrcod)=='mdominguez' || strtolower($vew_sec->usrcod)=='chisas' || strtolower($vew_sec->usrcod)=='achaves' ) { ?>
							<li><a href="#" onclick="tmssLink('?prg=zcutp1_tin&act=rchmeddsh', [{target: '_new_section'}] );">Roche Medicos</a></li>
						<?php } ?>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'flt'});" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->filter; ?>"><span class="fas fa-filter"></span></a>
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Imprimir-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px;" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><i class="fas fa-times"></i></a>
			</ul>
		</div>
	</nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
	</form>
	<script>
		$("#<?= $lv_sec; ?> #btnrpt001").on("click",function(e){
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1_tin&act=tinrptevl', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
		});
		$("#<?= $lv_sec; ?> #btnrpt002").on("click",function(e){
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1&act=tmgrpt01', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
		});
    $("#<?= $lv_sec; ?> #btnrpt003").on("click",function(e){
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1_tin&act=tinrptlqd', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
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
    	debugger;
			if (lp_prm["action"]=="prn") {
				window.print();
			} else if(lp_prm["action"]=="flt"){
				var lv_pstdat = [];
				tmssCallProcess("?prg=zcutp1&act=filterdsh1",lv_pstdat,function(data){
					BootstrapDialog.show({
						type: BootstrapDialog.TYPE_PRIMARY,
						size: BootstrapDialog.SIZE_WIDE,
						title: "Filtros",
						message: $("<div>"+data+"</div>"),
						buttons:[	{label: "Cancelar", cssClass: "btn-danger", action: function(dialogItself){
												dialogItself.close();
											}},
											{label: "Aceptar", cssClass: "btn-success", action: function(dialogItself){
												debugger;
												//var lv_tmp = $(dialogItself.getModalBody).find("form:first").serializeArray();
												 var lv_datep = dialogItself.getModalBody().find('#datep').val();
												 var lv_hltdisclscod = dialogItself.getModalBody().find('#hltdisclscod').val();
												 var lv_cushspcod = dialogItself.getModalBody().find('#cushsp').val();
												 var lv_spccod = dialogItself.getModalBody().find('#spccod').val();
												 var lv_tmp= {'datep':lv_datep,'hltdisclscod':lv_hltdisclscod,'cushsp':lv_cushspcod,'spccod':lv_spccod};
												 tmssFilterRefresh( lv_tmp );
												dialogItself.close();
											}}
										],
						onshown: function(dialog){
							// for(var i=0; i<lv_tmss_flt.length; i++){
							// 	if(lv_tmss_flt[i].value!=""){
							// 		$(dialog.getModalBody).find("#"+lv_tmss_flt[i].name).prop("value",lv_tmss_flt[i].value);
							// 	}
							// }
						}
					});
				});

			}else{
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);

    function tmssFilterRefresh( lp_flt ){
    	debugger;
			$.ajax({
				url: "?prg=zcutp1&act=02",
				type: "POST",
				data: lp_flt
			}).done(function(data){
				$("#<?= $lv_sec; ?>").replaceWith( data );

			});
		}
  </script>
</section>