<?php
	// url del formulario
  $lv_lnk = '?prg=sysappmdlprm&prm_id='.$vew_data->mdlcod;

	// campos requeridos
	$vew_input->RequiredFields( array('mdlcodext','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->mdlcod;

	// titulo
	$lv_title = $vew_lang->parameters;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'MDP';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->mdlcod; ?><?= ($vew_data->mdlcod==''?'':gethtml('mdlcod','hidden',$vew_data->mdlcod)); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-4">
            	<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->module; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?= ($vew_data->mdlcod==''? vew_boot($lv_col210, array('label'=>$vew_lang->code, 	'input'=>gethtml('mdlcodext', 'mdlcod', $vew_data->mdlcod, ($vew_data->mdlcod==''?$lv_default:$lv_always_disabled)) )):''); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); ?>
                </div>
              </div>    
						</div>
						<div class="col-md-8">
							<textarea id="mdlatrval001" name="mdlatrval001" class="hidden"></textarea>
							<div id="mdlatrval001div" name="mdlatrval001div"></div>
						</div>
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tabcontent -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_hotprm_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotprmcnt = $("#<?= $lv_sec; ?> #mdlatrval001div")[0];
		var <?= $lv_sec; ?>_hotprmset = {
			height: 200,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Parametro", "Valor" ],
			columns: [
				{type: "text", data: "mdlatrprm", width: 100, renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly?', readOnly: true':''); ?>},
				{type: "text", data: "mdlatrval", width: 100, renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly?', readOnly: true':''); ?>}
			],
		};
		var <?= $lv_sec; ?>_hotprm;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotprm = new Handsontable(<?= $lv_sec; ?>_hotprmcnt, <?= $lv_sec; ?>_hotprmset);
			var lv_dat = [<?php
				$lv_buffer='';
				$lv_buf_arr = null;
				$returnValue = preg_match_all('/<([^>]+)>(.*?)<\\/([^>]+)>/i', $vew_data->mdlatrval001, $lv_buf_arr, PREG_SET_ORDER);
				foreach ($lv_buf_arr as $lv_row) { $lv_buffer .= ($lv_buffer!=''?',':'').'{mdlatrprm:"'.$lv_row[1].'", mdlatrval:"'.$lv_row[2].'"}'; }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotprm.loadData( lv_dat );
			<?= $lv_sec; ?>_hotprm.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) {
				// parámetros
				var lo_dat = <?= $lv_sec; ?>_hotprm.getSourceData();
				var lv_str = "";
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["mdlatrprm"]!="" && lo_dat[i]["mdlatrprm"]!=undefined ){
						lv_str += "<"+lo_dat[i]["mdlatrprm"].toUpperCase()+">"+(lo_dat[i]["mdlatrval"]!=undefined?lo_dat[i]["mdlatrval"]:"")+"</"+lo_dat[i]["mdlatrprm"].toUpperCase()+">";
					}
				}
				$("#<?= $lv_sec; ?> #mdlatrval001").text( lv_str );
			}
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>