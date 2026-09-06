<?php
	// url del formulario
  $lv_lnk = '?prg=crmcntsts&prm_crmcntstscod='.$vew_data->crmcntstscod;

	// campos requeridos
	$vew_input->RequiredFields( array('crmcntststxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->crmcntstscod; 

	// titulo
	$lv_title = $vew_lang->contactstatus;
	
	// modulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'STS';
		
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    
		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->crmcntstscod; ?><?= gethtml('crmcntstscod', 'hidden', $vew_data->crmcntstscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
            <!-- Estados de contacto-->
						<div class="col-sm-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('crmcntstscodext', 'doccodext', $vew_data->crmcntstscodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('crmcntststxt', 'crmcntststxt', $vew_data->crmcntststxt, $lv_default) ));
										echo gethtml('crmcntstsatr','hidden',$vew_data->crmcntstsatr);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->color,    'input'=>gethtml('crmcntstsatrclr','bg-color', $vew_doc->getTagValue($vew_data->crmcntstsatr,'clr'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
            </div>
            <div class="col-sm-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->closingconfiguration; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                      echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->closescontact,	'input'=>gethtml('crmcntstscls', 'onoff', $vew_data->crmcntstscls, $lv_default) ));
                      echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->blockcontact,	'input'=>gethtml('crmcntstsblc', 'onoff', $vew_data->crmcntstsblc, $lv_default) ));
                  		echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->blockingexceptions));
                  ?>
                </div>
              </div>
              <?= gethtml('crmcntstsblcexc','hidden',$vew_data->crmcntstsblcexc); ?>
              <div id="stsblcexchot" name="stsblcexchot"></div>
            </div>
					</div>
				</div>
			</div> <!-- /tab-content -->
		</div> <!-- /tabpanel -->
  </form>
  <script>
    const gv_<?= $lv_sec; ?>_exctyp ={"USR": "<?= $vew_lang->user; ?>", "ROL": "<?= $vew_lang->rol; ?>"};
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
    }
    
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #stsblcexchot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= (!$vew_readonly ? 1 : 0) ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>", "<?= $vew_lang->value ?>" ],
			columns: [
        {type:"dropdown", data: "typ", renderer: <?= $lv_sec; ?>_hotdoc_renderer,  <?= ($vew_readonly?'readOnly: true, ':''); ?> source: Object.values(gv_<?= $lv_sec; ?>_exctyp)},
      	{type: "text", data: "val", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
        ],
      afterChange: function(changes, source) {
        if (!<?= $lv_sec; ?>_hotdoc) return;

        if (source == "loadData") {
          return;
        }
        const rows = <?= $lv_sec; ?>_hotdoc.countSourceRows();

        <?= $lv_sec; ?>_hotdoc.updateSettings({
            minSpareRows: rows >= 5 ? 0 : 1
        });
      },
      licenseKey: gv_handsontable_lc
		};
    var <?= $lv_sec; ?>_hotdoc;
    tmssLoadScript("handsontable16",function(){
      <?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt,<?= $lv_sec; ?>_hotdocset);
			var lv_dat = <?= ($vew_data->crmcntstsblcexc ?: '[]') ?>;
      lv_dat.forEach(function(row){
        row.typ = gv_<?= $lv_sec; ?>_exctyp[row.typ] || row.typ;
      });
      <?= $lv_sec; ?>_hotdoc.loadData(lv_dat);
      <?= $lv_sec; ?>_hotdoc.render();
    });

  </script>
	<script>
		$(function(){ $("#<?= $lv_sec; ?> #crmcntstsatrclr").trigger("change"); });
		$("#<?= $lv_sec; ?> #crmcntstsatrclr").on("change",function(){
			if($(this).val()==""){
				$(this).css("background-color","");
				$(this).css("color","");
			} else {
				$(this).css("background-color","var("+$(this).val()+")");
				$(this).css("color","var("+$(this).val()+"-text)");
			}
		});
	</script>
  <script>
    $("#<?= $lv_sec; ?> #crmcntstscls").change(function() {
      const enabled = $(this).is(":checked");
      
    	$("#<?= $lv_sec; ?> #crmcntstsblc").prop("disabled", !enabled);
      
      if(!enabled && !"<?= $vew_readonly; ?>")
      {
    		$("#<?= $lv_sec; ?> #crmcntstsblc").prop("checked", false).trigger("change");
      }
    }).trigger("change");

    $("#<?= $lv_sec; ?> #crmcntstsblc").change(function() {

      const enabled = $(this).is(":checked");
      $("#<?= $lv_sec; ?> #stsblcexchot").toggle(enabled);
    }).trigger("change");
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) {
        $("#<?= $lv_sec; ?> #crmcntstsatr").prop("value", '<clr>' + $("#<?= $lv_sec; ?> #crmcntstsatrclr").val() + '</clr>');
        
        var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData().filter(r => r.typ && r.val && r.val.trim() !== "");
        if(lv_dat.length == 0 && $("#<?= $lv_sec; ?> #crmcntstsblc").val() == 1)
        {
					toastr.warning( "Debe tener por lo menos un Excepcion de Bloqueo." );
					return false;	
        }
        var map_dat = lv_dat.map(d => ({ typ: (d.typ == "<?= $vew_lang->user; ?>" || d.typ == "USR" ? "USR" : "ROL"), val: d.val.toUpperCase() }));
        $("#<?= $lv_sec; ?> #crmcntstsblcexc").prop("value", $("#<?= $lv_sec; ?> #crmcntstsblc").val() == 1 ? JSON.stringify(map_dat) : '');
      }
		}
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>