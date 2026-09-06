<?php 
	// url del formulario
  $lv_lnk = "?prg=sysobj&prm_sysobjcod=".$vew_data->sysobjcod;

	// campos requeridos
	$vew_input->RequiredFields( array('docsts', 'sysobjcls', 'sysobjtxt') );

	// clave del documento
	$lv_dockey = $vew_data->sysobjcod;

	// titulo
	$lv_title = $vew_lang->objects;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'OBJ';

	// libreria de estilos bootstrap
	include_once('_library.frm');

	if($vew_actcod == '01'){$vew_data->sysobjver = 1;}

	$lv_sysobjclsarr=array();
	if($vew_data->sysobjcls!=''){
		foreach ($vew_data->sysobjcls as $lv_row) {
			$lv_sysobjclsarr[strval($lv_row['sysobjclscod'])] = $lv_row['sysobjclstxt'];
		}
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">	
  <?php include('grldocfrmtlb.frm'); ?>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('sysdevgrp','hidden',$vew_data->sysdevgrp); ?>

		<div class="container-fluid">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysobjcod; ?><input type="hidden" id="sysobjcod" name="sysobjcod" value="<?= $vew_data->sysobjcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="col-md-6">
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->object; ?></div></div>
              <div class="card-body tmss-card-body-edit">
                <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('sysobjcodext', 'doccmt1x50', $vew_data->sysobjcodext, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->name, 'input'=>gethtml('sysobjtxt', 'doccmt1x50', $vew_data->sysobjtxt, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->class, 'input'=>gethtml('sysobjclscod', $lv_sysobjclsarr, $vew_data->sysobjclscod, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->system, 'input'=>gethtml('sysobjsys', 'checkbox', $vew_data->sysobjsys, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                ?>
              </div>
            </div><!-- /card -->
					</div><!-- /col -->
					<div class="col-md-6">
					
            <div class="card tmss-hot-ttl">
              <div class="card-header"><div class="card-title"><?= $vew_lang->developersgroup; ?></div></div>
            </div>
            <div id="sysdevgrphot"></div>

            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->versions; ?></div></div>
              <div class="card-body tmss-card-body-edit">
								<table id="sysobjvertbl" class="table table-condensed">
									<thead><tr><th><?= $vew_lang->version; ?></th><th><?= $vew_lang->createddate; ?></th><th><?= $vew_lang->createdby; ?></th></tr></thead>
									<tbody></tbody>
								</table>
              </div>
            </div>
            
					</div><!-- /col -->
				</div><!-- /tab001 -->
			</div><!-- /tab-content -->
		</div><!-- /container-fluid -->
	</form>
	<script>
		$(function(){
			<?php if($vew_data->sysobjcod!=''){ ?>
			var lv_spin = "<i class='far fa-gear fa-spin'></i>";
			$("#<?= $lv_sec; ?> #sysobjvertbl tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			var lv_pstdat = [{name:"sysobjcod",value:"<?= $vew_data->sysobjcod; ?>"}];
			tmssCallProcessNoBackdrop("?prg=sysobj&act=getversions",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #sysobjvertbl tbody").empty();
				for(var i=0; i < data.data.length; i++){
					$("#<?= $lv_sec; ?> #sysobjvertbl tbody").append("<tr data-sysobjvercod='"+data.data[i].sysobjvercod+"'><td>"+Number(data.data[i].sysobjver+1)+"</td><td>"+moment(data.data[i].ctedte.date).format("DD/MM/YYYY HH:mm")+"</td><td>"+data.data[i].cteusr+"</td></tr>");
				}
				$("#<?= $lv_sec; ?> #sysobjvertbl tbody").append("<tr><td>1</td><td></td><td>INICIAL</td></tr>");
			});
			<?php } ?>
		});
	</script>
	<script>
		// GRUPOS DE DESARROLLO
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
		};
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdevgrphot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 150,
			stretchH: "all",
			//autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			//autoWrapRow: false,
			//rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->developergroup; ?>" ],
			columns: [
				{type: "autocomplete", data: "sysdevgrptxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
          source (query, process) {
            $.ajax({
              url: "?prg=sysdevgrp&act=17", dataType: "json", data: {	prm_sysdevgrptxt: query },
                success: function(response) {
                  // Almacenar los objetos completos en el caché
                  <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                  // Extraer solo los textos para el dropdown
                  const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.sysdevgrptxt);
                  process(items); // Pasar las sugerencias al dropdown
                },
                error: function() {
                  <?= $lv_sec; ?>_autocompleteCache = []; // Limpiar caché en caso de error
                  process([]); // No hay sugerencias
                }
            });
          },
         strict: true
				}
			],
	    // Hook para asignar el código desde el caché
      afterChange: function(changes, source) {
        if (changes && changes.length > 0) {
          const row = changes[0][0]; // Fila seleccionada
          const valueSelected = changes[0][3]; // Valor seleccionado
          if( changes[0][1]=="sysdevgrptxt"){
            // Buscar el objeto en el caché por sysdevgrptxt
            const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.sysdevgrptxt === valueSelected);
            if (selectedItem) { <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "sysdevgrpcod", selectedItem.sysdevgrpcod);
            } else { toastr.warning("No se encontro [sysdevgrpcod] para el texto seleccionado ["+valueSelected+"]"); }
          }
        }
      },
			licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
        $lv_sysdevgrp = ($vew_data->sysdevgrp==''?array():json_decode($vew_data->sysdevgrp,true));
				$lv_buffer='';
				foreach($lv_sysdevgrp as $lv_key=>$lv_val){
          if( $vew_devgrp[$lv_val]??''!='' ){
						$lv_buffer .= ($lv_buffer!=''?',':'').'{sysdevgrpcod:"'.$lv_key.'", sysdevgrptxt:"'.$vew_devgrp[$lv_val].'"}';
          }
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
			if ( lp_prm["action"]=="00" ) {
      	// crea string de grupos de desarrollo
        var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        var lv_sysdevgrp = Array();
        for (var i=0; i<lo_dat.length-1 ; i++) {
          if (lo_dat[i]["sysdevgrpcod"]!="" && lo_dat[i]["sysdevgrpcod"]!=undefined){
            lv_sysdevgrp.push( lo_dat[i]["sysdevgrpcod"] );
         }
        }        
        $("#<?= $lv_sec; ?> #sysdevgrp").prop("value", (lv_sysdevgrp.length==0?"[]":JSON.stringify(lv_sysdevgrp)) );
      }    
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>