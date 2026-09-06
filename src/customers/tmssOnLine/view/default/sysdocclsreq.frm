<?php		
	// url del formulario
  $lv_lnk = '?prg=sysdoccls';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->requiredfields;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DOC';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">  	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('sysdocclscod','hidden',$vew_data->sysdocclscod); ?>
    <span class="hidden" id="json_input"></span>
    <a href="#" class="hidden" id="json_button"></a>
    
		<div class="containter-fluid">
      <textarea id="sysdocreqfld" name="sysdocreqfld" class="hidden"></textarea>
      <div id="sysdocreqfldhot"></div>
		</div>
		
	</form>
	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdocreqfldhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Campo", "Requerido", "Default", "Oculto", "Inhabilitado", "Obj.Auth","Ctrl.Cambio" ],
			columns: [
				{type: "text", data: "fldcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "dropdown", data: "fldreq", source: ['','X'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "flddefval", source: ['','X'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "dropdown", data: "fldhde", source: ['','X'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "dropdown", data: "flddis", source: ['','X'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "fldautobj", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
        {type: "dropdown", data: "fldchglog", source: ['','X'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }
			]
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script> 
  <script>
    // toma el string JSON, lo carga en la HOT y renderiza
    $("#json_button").on("click",function(e){ e.preventDefault();
      if($("#json_input").html()!=""){
				<?= $lv_sec; ?>_hotdoc.loadData( JSON.parse($("#json_input").html()) );
				<?= $lv_sec; ?>_hotdoc.render();
      }
    });
  </script>
	<script>
		$(function(e){ tmssHandsontableResize(); });
		
		// edit mode
    tmssFormEdit(<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>,"#buscod");
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>