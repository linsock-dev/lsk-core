<?php
	/* url del formulario */
  $lv_lnk = '?prg=stkmatlst&prm_matlstcod='.$vew_data->matlstcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('mattxt','matcod','matlsttxt','matqty','matuntcod','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->matlstcod;

	/* titulo */
	$lv_title = $vew_lang->materialslist;

	/* m?dulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MTL';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!--Navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
   

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('stkmatlstmat','hidden',''); ?>
        

    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->matlstcod; ?><?= gethtml('matlstcod','hidden', $vew_data->matlstcod);?></strong></h4></li>
			</ul>
      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $lv_title; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('matlstcodext','matcod', $vew_data->matlstcodext,$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('matlsttxt', 	'mattxt', $vew_data->matlsttxt, 	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 			'docsts', $vew_data->docsts, 			$lv_default) ));
                  ?>
                </div>
              </div>
           </div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->material; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->material,
                                                  'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                      array('input'=>gethtml('mattxt', 'typeahead', $vew_data->mattxt, $lv_default) ))
                                                  ));
                  ?>
                  <?= gethtml('matcod','hidden', $vew_data->matcod);?>
                  <?php
                  echo vew_boot($lv_col273, array('label'=>$vew_lang->quantity,
                                                  'input1'=>gethtml('matqty',	'docqty',	$vew_data->matqty,	$lv_default),
                                                  'input2'=>gethtml('matuntcod', 'matuntcod', $vew_data->matuntcod, $lv_always_disabled)
                                                  ));
                  ?>
                </div>
              </div>
                
            </div>
          </div>
          <div class="card tmss-hot-ttl ">
                <div class="card-header">
                  <div class="card-title"><?=$vew_lang->composition;?></div>
                </div>                            
          </div> 
          <div id="stkmatlsthot" name="stkmatlsthot"></div>
        </div>
      </div>
    </div>
  </form>
	<script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = <?php echo($vew_readonly?'true':'false'); ?>;

				if ( prop=="matcod" || prop=="matuntcod" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else if ( prop=="matqty" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro?true:false);
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro?true:false);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #stkmatlsthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?=$vew_lang->material;?>", "<?=$vew_lang->description;?>", "<?=$vew_lang->quantity;?>", "<?=$vew_lang->um;?>" ],
			columns: [
				{type: "text", data: "matcod", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
							$.ajax({
								url: "?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < response.data.length; i++) {
                    <?= $lv_sec; ?>_hotdocchg.push( {mattxt: response.data[i]["mattxt"], matcod: response.data[i]["matcod"], matuntcod: response.data[i]["matuntcod"]} );
                    lv_dat.push(response.data[i]["mattxt"]);
									}
									process( lv_dat );
								}
							});
					},
					strict: true
				},
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="mattxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].mattxt == lv_value) {
							changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcod) ]);
							changes.push([ changes[0][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matuntcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["matlstmatcod"]!="" && lv_dat[i]["matlstmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
        //arma array de datos
				foreach($vew_data->stkmatlstmat as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'matlstmatcod:\''.$lv_row['matlstmatcod'].'\','.
												'matcod:\''.$lv_row['srcobjcod'].'\','.
												'mattxt:\''.utf8_decode($lv_row['srcobjtxt']).'\','.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:\''.$lv_row['matuntcod'].'\''.
												'}';
												}
				echo $lv_buffer;
			?>];
      //carga los datos en la handsome table
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>	
    //typeahead de material
			var lo_get = {"fldsec":"<?= $lv_sec; ?>","fldflt":{"m.docsts":"A"}, "fldasg":{"matcod" : "matcod", "mattxt":"mattxt","matuntcod":"matuntcod"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #mattxt"), "stkmat", lo_get);
    
	</script>
  <script>
    
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if(lp_prm["action"]=="00") {

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matcod"]!="" && lo_dat[i]["matcod"]!=undefined ) {
						lv_arr.push({	"matlstmatcod":lo_dat[i]["matlstmatcod"],
													"matcod":lo_dat[i]["matcod"],
													"mattxt":lo_dat[i]["mattxt"],
													"matqty":lo_dat[i]["matqty"],
													"matuntcod":lo_dat[i]["matuntcod"]
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #stkmatlstmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmatlstmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}			
		}
		
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>