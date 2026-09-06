<?php 
	// url del formulario
  $lv_lnk = '?prg=logvhc&prm_vhccod='.$vew_data->vhccod;

	// campos requeridos
	$vew_input->RequiredFields( array('vhccodext','vhcclscod','vhcclstxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->vhccod; 

	// titulo
	$lv_title = $vew_lang->vehicle;
	
	// módulo y programa
	$lv_mdlcod = 'LOG';
	$lv_prgcod = 'VHC';

	$lv_atr = array();
	$lv_atr[] = array('atrcod'=>'vhcbrd', 'atrtxt'=>'Marca');
	$lv_atr[] = array('atrcod'=>'vhcmod', 'atrtxt'=>'Modelo');
	$lv_atr[] = array('atrcod'=>'vhcyth', 'atrtxt'=>'Fecha');
	$lv_atr[] = array('atrcod'=>'vhctag', 'atrtxt'=>'Nro. de Chasis');
	$lv_atr[] = array('atrcod'=>'vhckms', 'atrtxt'=>'Kilometraje');

	$lv_atrcod = array_column($lv_atr, 'atrcod');

  // librería de estilos bootstrap
  include_once('_library.frm');
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->vehicle; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->vhccod; ?><?= gethtml('vhccod','hidden',$vew_data->vhccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 	'input'=>gethtml('vhccodext',		'doccmt1x20',		$vew_data->vhccodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,	'input'=>gethtml('vhctxt',		'doccmt1x50',$vew_data->vhctxt, $lv_default) )); 
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->class,
                                                    'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                        array('input'=>gethtml('vhcclstxt', 'typeahead', $vew_data->vhcclstxt, $lv_default ) )) )); 
                  	echo gethtml('vhcclscod', 'hidden', $vew_data->vhcclscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts' , 'docsts'   , 	$vew_data->docsts, 		$lv_default) )); 
                  ?>
                </div>
              </div>           
						</div>
            <div class="col-md-6">
							<textarea class = "hidden" id = "logvhcatr" name = "logvhcatr"></textarea>
							<div id = "logvhchot"></div>
						</div>
					</div>
				</div>
			</div> <!-- tabcontent -->    
		</div> <!-- /container-fluid -->
  </form>
 	<script>
    // Clase de vehiculo
    var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldflt" : { "docsts": "A" }, "fldasg": { "vhcclscod" : "vhcclscod", "vhcclstxt" : "vhcclstxt"} };
    tmssTypeahead($("#<?= $lv_sec; ?> #vhcclstxt"), "logvhccls", lo_get);
  </script>
  <script>
  	// ATRIBUTOS
    var <?= $lv_sec; ?>_hotlogvhc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if(prop == "logvhcatrtxt"){
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = "#F1F1F1";
      }else{
        if(col == 1){
          if(row == <?= array_search('vhcyth', $lv_atrcod) ?>){
          	Handsontable.renderers.DateRenderer.apply(this, arguments);
          }else if(row == <?= array_search('vhckms', $lv_atrcod) ?>){
            Handsontable.renderers.NumericRenderer.apply(this, arguments);
          }else{
            Handsontable.renderers.TextRenderer.apply(this, arguments);
          }
        }
      	td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";   
      }
    };
    
    var <?= $lv_sec; ?>_hotlogvhcerr = [];
    var <?= $lv_sec; ?>_hotlogvhccnt = $("#<?= $lv_sec; ?> #logvhchot")[0];
    var <?= $lv_sec; ?>_hotlogvhcset = {
      height: 396,
      stretchH: "all",
      minSpareRows: 0,
    	colHeaders: ["<?= $vew_lang->Attribute; ?>", "<?= $vew_lang->Value	; ?>"],
      columns: [
        {type: "text", data: "logvhcatrtxt", renderer: <?= $lv_sec; ?>_hotlogvhc_renderer, readOnly: true},
        {type: "text", data: "logvhcatrval", renderer: <?= $lv_sec; ?>_hotlogvhc_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>}
      ],
    	cells: function (row, col, prop) {
        var cellProperties = {}; 
        if(col == 1){
            switch(row){
              case <?= array_search('vhcyth', $lv_atrcod) ?>:
                cellProperties.type = "date";
                cellProperties.dateFormat = 'YYYY';
                cellProperties.correctFormat = true;
                cellProperties.renderer = <?= $lv_sec; ?>_hotlogvhc_renderer;
                break;
              case <?= array_search('vhckms', $lv_atrcod) ?>:
                cellProperties.type = "numeric";
                cellProperties.numericFormat = {pattern: "0,0.00", culture: "es-AR"};
                cellProperties.renderer = <?= $lv_sec; ?>_hotlogvhc_renderer;
                break;
          	}
        }
        
        return cellProperties;
			},
      afterValidate: function( isValid, value, row, prop, source) {
        var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotlogvhcerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotlogvhcerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotlogvhcerr.splice(lv_inx,1); }	
				}
      },
      licenseKey: gv_handsontable_lc
    };
    var <?= $lv_sec; ?>_hotlogvhc;
    
    tmssLoadScript("handsontable16", function(){
      <?= $lv_sec; ?>_hotlogvhc = new Handsontable(<?= $lv_sec; ?>_hotlogvhccnt, <?= $lv_sec; ?>_hotlogvhcset);
      var lv_dat = [<?php
				$lv_buffer='';
        foreach($lv_atr as $lv_row){
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
            					'logvhcatrcod:"'.$lv_row['atrcod'].'",'.
            					'logvhcatrtxt:"'.$lv_row['atrtxt'].'",'.
            					'logvhcatrval:"'.$vew_doc->getTagValue($vew_data->vhcatr, $lv_row['atrcod']).
            			'"}'; 
        }
        echo $lv_buffer;
			?>];
      <?= $lv_sec; ?>_hotlogvhc.loadData(lv_dat);
      <?= $lv_sec; ?>_hotlogvhc.render();
    });
  </script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
			if ( lp_prm["action"]=="00" ) {
      	// Obtiene datos de HOT de atributos de vehículo  
        var lo_dat = <?= $lv_sec; ?>_hotlogvhc.getSourceData();
        var lv_dat = "";
        for (var i=0; i<lo_dat.length ; i++) {
          lv_dat += "<" + lo_dat[i]["logvhcatrcod"] + ">" + lo_dat[i]["logvhcatrval"] + "</" + lo_dat[i]["logvhcatrcod"] + ">";
        }
        $("#<?= $lv_sec; ?> #logvhcatr").prop("value", lv_dat );
      }    
    }
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>