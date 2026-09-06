<?php 
	/* url del formulario */
  $lv_lnk = '?prg=cnstsk&prm_cnstskcod='.$vew_data->cnstskcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('cnstsktxt', 'docsts','matqty', 'matuntcod') );

	/* clave del documento */
	$lv_dockey = $vew_data->cnstskcod;

	/* titulo */
	$lv_title = $vew_lang->task;

	/* m�dulo y programa */
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'TSK';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');

	$lv_rspobjtyp = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'RspObjTyp');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
  <!-- Navbar -->
	<?php include('grldocfrmtlb.frm'); ?> 
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    
    <textarea id="cnstskmat"  name="cnstskmat"  class="hidden"></textarea> 
    <textarea id="cnstskrskctr" name="cnstskrskctr" class="hidden"></textarea>
    
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->cnstskcod; ?><?= gethtml('cnstskcod','hidden',$vew_data->cnstskcod); ?></strong></h4></li>
        <li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?=$vew_lang->risksandcontrols;?></a></li>
			</ul>																	
      <div class="tab-content tmss-tab-content">
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-sm-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">  
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										</span>
                    <?php 
                      echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                      echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                    ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('cnstskcodext','matcod', $vew_data->cnstskcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('cnstsktxt', 'mattxt', $vew_data->cnstsktxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
					    </div>
						</div>
						<div class="col-sm-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->data; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->classification,
                                                    "input1"=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                        array('input'=>gethtml('cnstskclstxt', 'typeahead', $vew_data->cnstskclstxt, $lv_default ) )) )); 
                  	echo gethtml('cnstskclscod','hidden',$vew_data->cnstskclscod);
                    echo vew_boot($lv_col273, array('label'=>$vew_lang->quantity,
                                                    'input1'=>gethtml('matqty',	'docqty',	$vew_data->matqty,	$lv_default),
                                                    'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('matuntcod', 'typeahead', $vew_data->matuntcod, $lv_always_disabled) ))
                                                    ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->responsible,	
                                                    "input1"=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                        array('input'=>gethtml('cnstskrspobjtxt', 'typeahead', $vew_data->rspobjtxt, $lv_default ) )) )); 
                    echo gethtml('rspobjcod', 'hidden', $vew_data->rspobjcod); 
                    echo gethtml('rspobjtyp', 'hidden', $lv_rspobjtyp); 
                  
                  ?>  
                </div>
					    </div>
						</div>
					</div>
          <div class="col-md-12" id="prcschcnddiv">
            <div class="card tmss-hot-ttl">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->components ?>
                </div>
              </div>
            </div>
            <div id="cnstskhot" name="cnstskhot"></div> 
          </div>
				</div>
        <!-- RIESGOS Y CONTROLES -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
          <div class="row">

            <!-- CARD RIESGOS -->
            <div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title"><?=$vew_lang->risks;?></div>
                </div>
              </div>
              <div id="cnstsksrskhot" name="cnstsksrskhot"></div>              
            	<textarea id="cnstsksrsk" name="cnstsksrsk" class="hidden"></textarea>
            </div>

            <!-- CARD CONTROLES -->
            <div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title"><?=$vew_lang->controls;?></div>
                </div>
              </div>
							<textarea id="cnstsksctr" name="cnstsksctr" class="hidden"></textarea>             
              <div id="cnstsksctrhot" name="cnstsksctrhot"></div>
            </div>

          </div>
        </div>

      </div>
    </div>
    
  </form>

  <script> 
    //Typeahead Cantidad
    var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldasg":{"matuntcod":"matuntcod"}, "typeahead": false};
    tmssTypeahead($("#<?= $lv_sec; ?> #matuntcod"), "stkmatunt", lo_get)  
  
    //Typeahead Clasificacion
    var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"tc.docsts":"A"}, "fldasg" : {"cnstskclscod":"cnstskclscod", "cnstskclstxt" : "cnstskclstxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #cnstskclstxt"), "cnstskcls", lo_get)    
    
    
    
    var lv_rspobjtyp = "<?= $lv_rspobjtyp; ?>";
    
    switch(lv_rspobjtyp){ 
      case "HHR_EMP":
        //Typeahead Responsable
        var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"p.docsts":"A"}, "fldasg" : {"rspobjcod":"hhrempcod", "cnstskrspobjtxt":"hhremptxt"}};
        tmssTypeahead($("#<?= $lv_sec; ?> #cnstskrspobjtxt"), "hhremp", lo_get)    
        break;
        
    }
    
    
  </script>
	<script>
		function <?= $lv_sec; ?>_getObject( lp_txt, query ) {
			var lv_ret = {type:"",url:"",prm:{},id:"",txt:""};
			switch(lp_txt){
				case "<?= $vew_lang->employees; ?>": lv_ret = {type:"HHR_EMP", url:"hhremp", prm:{ prm_hhremptxt: query }, id:"hhrempcod", txt:"hhremptxt", cod:"hhrempcodext"}; break;
				case "Vehiculos":	lv_ret = {type:"LOG_VHC", url:"logvhc", prm:{ prm_vhctxt: query }, id:"vhccod", txt:"vhctxt", cod:"vhccodext"}; break;
				case "<?= $vew_lang->materials; ?>": lv_ret = {type:"STK_MAT", url:"stkmat", prm:{ prm_mattxt: query }, id:"matcod", txt:"mattxt", cod:"matcodext"}; break;
				case "<?= $vew_lang->supplier; ?>": lv_ret = {type:"BUY_SUP", url:"buysup", prm:{ prm_suptxt: query }, id:"supcod", txt:"suptxt", cod:"supcodext"}; break;
        case "<?= $vew_lang->tasks; ?>": lv_ret = {type:"CNS_TSK", url:"cnstsk", prm:{ prm_cnstsktxt: query }, id:"cnstskcod", txt:"cnstsktxt", cod:"cnstskcodext"}; break;
			}
			return lv_ret;
		} 
    
    function <?= $lv_sec; ?>_getObjectByCode( lp_txt, query ) {
			var lv_ret = {type:"",url:"",prm:{},id:"",txt:""};
			switch(lp_txt){
				case "<?= $vew_lang->employees; ?>": lv_ret = {type:"HHR_EMP", url:"hhremp", prm:{ prm_hhrempcodext: query }, id:"hhrempcod", txt:"hhremptxt", cod:"hhrempcodext"}; break;
				case "Vehiculos":	lv_ret = {type:"LOG_VHC", url:"logvhc", prm:{ prm_vhccodext: query }, id:"vhccod", txt:"vhctxt", cod:"vhccodext"}; break;
				case "<?= $vew_lang->materials; ?>": lv_ret = {type:"STK_MAT", url:"stkmat", prm:{ prm_matcodext: query }, id:"matcod", txt:"mattxt", cod:"matcodext"}; break;
				case "<?= $vew_lang->supplier; ?>": lv_ret = {type:"BUY_SUP", url:"buysup", prm:{ prm_supcodext: query }, id:"supcod", txt:"suptxt", cod:"supcodext"}; break;
        case "<?= $vew_lang->tasks; ?>": lv_ret = {type:"CNS_TSK", url:"cnstsk", prm:{ prm_cnstskcodext: query }, id:"cnstskcod", txt:"cnstsktxt", cod:"cnstskcodext"}; break;
			}
			return lv_ret;
		}
	</script>
  <script>
    /**
		 *
		 *	C O M P O N E N T E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				if( prop=="srcobjtyptxt"){
          Handsontable.renderers.DropdownRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        } else if ( prop=="matqty" ){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}else if ( prop == "matuntcod" || prop == "cnstskmatcod"){
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#F1F1F1";
				}else{
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #cnstskhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->id; ?>", "<?= $vew_lang->type; ?>", "<?= $vew_lang->code; ?>", "<?= $vew_lang->description; ?>", "<?= $vew_lang->Quantity; ?>", "UM" ],
			columns: [
        {type: "text", data: "cnstskmatcod", width: 5, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
        {type: "dropdown", data: "srcobjtyptxt", source: ["<?= $vew_lang->employees; ?>","<?= $vew_lang->Materials; ?>","Vehiculos", "<?= $vew_lang->supplier ?>","<?= $vew_lang->tasks; ?>"], width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?>},
        {type: "text", data: "srcobjcodext", width: 5, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?>},
        {type: "autocomplete", data: "srcobjtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
            var lv_srcobjtyptxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( this.row, "srcobjtyptxt" );						
						if(lv_srcobjtyptxt!=""){
							var lv_dat = <?= $lv_sec; ?>_getObject( lv_srcobjtyptxt, query );
							if(lv_dat.url!=""){
								tmssCallProcessNoBackdrop("?prg="+lv_dat.url+"&act=17&"+Object.keys(lv_dat.prm)[0]+"="+Object.values(lv_dat.prm)[0], [],function(data){
                  var lv_data;
									if(data.data==undefined){ lv_data=data; } else { lv_data=data.data; }
									var lv_ret = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < lv_data.length; i++) { 
										<?= $lv_sec; ?>_hotdocchg.push( {srcobjtxt:lv_data[i][lv_dat.txt],
																										 srcobjcod001:lv_data[i][lv_dat.id], 
                                                     srcobjcodext:lv_data[i][lv_dat.cod],
																										 matqty:(lv_data[i]["matqty"]!=undefined?lv_data[i]["matqty"]:"1"),
																										 matuntcod:(lv_data[i]["matuntcod"]!=undefined?lv_data[i]["matuntcod"]:"UN") }),
										lv_ret.push( lv_data[i][lv_dat.txt] );
									}
									process( lv_ret );							
								});
							}
						}
					},
          width: 20,
					strict: true
				},
        {type: "numeric", data: "matqty", width: 8, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 5, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],
			beforeChange : function(changes, source) {
        if(source=="edit"){
          for(var i=0 ; i<changes.length ; i++) {
            switch(changes[i][1]){
              case "srcobjtyptxt":
                //vacia la fila
                changes.push([ changes[i][0], "srcobjtxt", "", "" ]);
                changes.push([ changes[i][0], "srcobjcodext", "", "" ]);
                changes.push([ changes[i][0], "srcobjcod001", "", "" ]);
                changes.push([ changes[i][0], "matqty", "", "1" ]);
                changes.push([ changes[i][0], "matuntcod", "", "UN" ]);
                break;

              case "srcobjtxt":
                //cambia el codigo del objeto de origen, la cantidad y la unidad 
                for(var j=0 ; j < <?= $lv_sec; ?>_hotdocchg.length ; j++) {
                  if(<?= $lv_sec; ?>_hotdocchg[j].srcobjtxt == changes[i][3]) {
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjcodext", String(<?= $lv_sec; ?>_hotdocchg[j].srcobjcodext), "srcobjcodext" );
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjcod001", String(<?= $lv_sec; ?>_hotdocchg[j].srcobjcod001), "paste" );
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matqty", String(<?= $lv_sec; ?>_hotdocchg[j].matqty), "paste" );
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matuntcod", String(<?= $lv_sec; ?>_hotdocchg[j].matuntcod), "paste" );
                    break;
                  }
                }
                break;

              case "srcobjcodext":
                //cambia el texto del objeto de origen, la cantidad y la unidad 
                var lv_srcobjtyptxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( changes[i][0], "srcobjtyptxt" );
                if(lv_srcobjtyptxt!="" && changes[i][3]!="" && changes[i][3]!=undefined ){
                  var lv_dat = <?= $lv_sec; ?>_getObjectByCode( lv_srcobjtyptxt, changes[i][3] );
                  if(lv_dat.url!=""){
                    lv_dat.row = changes[i][0];
                    tmssCallProcessNoBackdrop("?prg="+lv_dat.url+"&act=17&"+Object.keys(lv_dat.prm)[0]+"="+Object.values(lv_dat.prm)[0], lv_dat ,function(data){
                        if(data.data.length==0){
                          toastr.warning("Codigo no encontrado.");
                          return false;
                        } else {
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "srcobjcod001", data.data[0][data.post.id], "paste" );
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "srcobjtxt", data.data[0][data.post.txt], "paste" );
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "matqty", (data.data[0]["matqty"]!=undefined?data.data[0]["matqty"]:"1"), "paste" );
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "matuntcod", (data.data[0]["matuntcod"]!=undefined?data.data[0]["matuntcod"]:"UN"), "paste" );
                        }
                    });
                  }
                }
                break;
            }  
          }
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["cnstskmatcod"]!="" && lv_dat[i]["cnstskmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
        if($vew_data->cnstskmat != ''){
          foreach($vew_data->cnstskmat as $lv_row){
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'cnstskmatcod:\''.$lv_row['cnstskmatcod'].'\','.
              						'srcobjcodext:\''.$lv_row['srcobjcodext'].'\','.
                          'srcobjcod001:\''.$lv_row['srcobjcod001'].'\','.
                          'srcobjtyptxt:\''.($lv_row['srcobjtyp']=='HHR_EMP'?$vew_lang->employees:
																					($lv_row['srcobjtyp']=='STK_MAT'?$vew_lang->materials:
																					($lv_row['srcobjtyp']=='LOG_VHC'?"Vehiculos":
                                          ($lv_row['srcobjtyp']=='BUY_SUP'?$vew_lang->supplier:
																					($lv_row['srcobjtyp']=='CNS_TSK'?$vew_lang->tasks:''))))).'\','.
                          'srcobjtxt:\''.$lv_row['srcobjtxt'].'\','.
                          'matqty: '.$lv_row['matqty'].' ,'.
                          'matuntcod:\''.$lv_row['matuntcod'].'\''.
                          '}';
          }
        }
				echo $lv_buffer;
			?>];
      //carga los datos
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});    
  </script>
  <script>
     /**
		 *
		 *	R I E S G O S   Y   C O N T R O L E S
		 *
		 */
    
  // RIESGOS
  // Renderer
  var <?= $lv_sec; ?>_rsk_renderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
    td.style.backgroundColor = "#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>";
  };

  // Variables 
  var <?= $lv_sec; ?>_rsk_err = [];
  var <?= $lv_sec; ?>_rsk_chg = [];
  var <?= $lv_sec; ?>_rsk_del = [];
  var <?= $lv_sec; ?>_rsk_cnt = $("#<?= $lv_sec; ?> #cnstsksrskhot")[0];

  // Configuración 
  var <?= $lv_sec; ?>_rsk_set = {
    height: 200,
    stretchH: "all",
    autoColumnSize: true,
    <?= ($vew_readonly ? '' : 'contextMenu: ["remove_row"],') ?>
    autoWrapRow: false,
    rowHeaders: true,
    minSpareRows: <?= ($vew_readonly ? '0' : '1') ?>,
    colHeaders: ["<?= $vew_lang->description; ?>"],
    columns: [
					{type: "autocomplete", data: "cnsrskctrtxt", renderer: <?= $lv_sec; ?>_rsk_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
            source: function (query, process) {
              $.ajax({
                url: "?prg=cnsrskctr&act=17", dataType: "json", data: {	prm_cnsrskctrtxt: query, prm_cnsrskctrtyp: "R"},
                complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
                success: function (response) {
                  // guardo todos los datos adicionales en una variable temporal
                  var lv_dat = [];
                  <?= $lv_sec; ?>_rsk_chg = [];
                  for (var i=0; i < response.length; i++) {
                    <?= $lv_sec; ?>_rsk_chg.push( {cnsrskctrtxt: response[i]["cnsrskctrtxt"], cnsrskctrcod: response[i]["cnsrskctrcod"]} );
                    lv_dat.push( response[i]["cnsrskctrtxt"] );
                  }
                  process( lv_dat );
                }
              });
					},
        strict: true,
        allowInvalid: false
      }
    ],
    beforeChange: function(changes, source) {
      if (source == "edit" && changes[0][1] == "cnsrskctrtxt") {
        var lv_value = changes[0][3];
        for (var i=0; i < <?= $lv_sec; ?>_rsk_chg.length; i++) {
          if (<?= $lv_sec; ?>_rsk_chg[i].cnsrskctrtxt == lv_value) {
            changes.push([
              changes[0][0],
              "cnsrskctrcod",
              "",
              String(<?= $lv_sec; ?>_rsk_chg[i].cnsrskctrcod)
            ]);
          }
        }
      }
    },
    beforeRemoveRow: function(index, amount) {
      var lv_dat = <?= $lv_sec; ?>_rsk_hot.getSourceData();
      for (var i=index; i<index+amount; i++) {
        if (lv_dat[i]["cnstsksrskcod"]!="" && lv_dat[i]["cnstsksrskcod"]!=undefined) {
          <?= $lv_sec; ?>_rsk_del.push(lv_dat[i]);
        }
      }
    }
  };

  var <?= $lv_sec; ?>_rsk_hot;

  // Inicialización 
  tmssLoadScript("handsontable", function() {
    <?= $lv_sec; ?>_rsk_hot = new Handsontable(<?= $lv_sec; ?>_rsk_cnt, <?= $lv_sec; ?>_rsk_set);
    var lv_dat = [<?php
      $lv_buffer = '';
      $vew_data->cnstskrsk = $vew_data->cnstskrsk ?? [];
      foreach ($vew_data->cnstskrsk as $lv_row) {
        $lv_buffer .= ($lv_buffer==''?'':', ')
                    . '{cnstskrskctrcod:"'.$lv_row['cnstskrskctrcod'].'",'
                    . 'cnsrskctrcod:"'.$lv_row['cnsrskctrcod'].'",'
                    . 'cnsrskctrtxt:"'.utf8_decode($lv_row['cnsrskctrtxt']).'"}';
      }
      echo $lv_buffer;
    ?>];

    <?= $lv_sec; ?>_rsk_hot.loadData(lv_dat);
    <?= $lv_sec; ?>_rsk_hot.render();
  });

  </script>
  <script>
  // CONTROLES
  // Renderer
  var <?= $lv_sec; ?>_ctr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
    td.style.backgroundColor = "#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>";
  };

  // Variables 
  var <?= $lv_sec; ?>_ctr_err = [];
  var <?= $lv_sec; ?>_ctr_chg = [];
  var <?= $lv_sec; ?>_ctr_del = [];
  var <?= $lv_sec; ?>_ctr_cnt = $("#<?= $lv_sec; ?> #cnstsksctrhot")[0];

  // Configuración 
  var <?= $lv_sec; ?>_ctr_set = {
    height: 200,
    stretchH: "all",
    autoColumnSize: true,
    <?= ($vew_readonly ? '' : 'contextMenu: ["remove_row"],') ?>
    autoWrapRow: false,
    rowHeaders: true,
    minSpareRows: <?= ($vew_readonly ? '0' : '1') ?>,
    colHeaders: ["<?= $vew_lang->description; ?>"],
    columns: [
      { 
        type: "autocomplete", 
        data: "cnsrskctrtxt", 
        renderer: <?= $lv_sec; ?>_ctr_renderer, 
        <?= ($vew_readonly ? 'readOnly: true, ' : ''); ?>				
        source: function (query, process) {
          $.ajax({
            url: "?prg=cnsrskctr&act=17", 
            dataType: "json", 
            data: { prm_cnsrskctrtxt: query, prm_cnsrskctrtyp: "C" },
            complete: function(jqXHR, textStatus) { 
              if (jqXHR.responseText.substr(0,10)=="/*script*/") { eval(jqXHR.responseText); exit(); }
            },
            success: function (response) {
              var lv_dat = [];
              <?= $lv_sec; ?>_ctr_chg = [];
              for (var i=0; i < response.length; i++) {
                <?= $lv_sec; ?>_ctr_chg.push({
                  cnsrskctrtxt: response[i]["cnsrskctrtxt"], 
                  cnsrskctrcod: response[i]["cnsrskctrcod"]
                });
                lv_dat.push(response[i]["cnsrskctrtxt"]);
              }
              process(lv_dat);
            }
          });
        },
        strict: true,
        allowInvalid: false
      }
    ],
    beforeChange: function(changes, source) {
      if (source == "edit" && changes[0][1] == "cnsrskctrtxt") {
        var lv_value = changes[0][3];
        for (var i=0; i < <?= $lv_sec; ?>_ctr_chg.length; i++) {
          if (<?= $lv_sec; ?>_ctr_chg[i].cnsrskctrtxt == lv_value) {
            changes.push([
              changes[0][0],
              "cnsrskctrcod",
              "",
              String(<?= $lv_sec; ?>_ctr_chg[i].cnsrskctrcod)
            ]);
          }
        }
      }
    },
    beforeRemoveRow: function(index, amount) {
      var lv_dat = <?= $lv_sec; ?>_ctr_hot.getSourceData();
      for (var i=index; i<index+amount; i++) {
        if (lv_dat[i]["cnstsksctrcod"]!="" && lv_dat[i]["cnstsksctrcod"]!=undefined) {
          <?= $lv_sec; ?>_ctr_del.push(lv_dat[i]);
        }
      }
    }
  };

  var <?= $lv_sec; ?>_ctr_hot;

  // Inicialización 
  tmssLoadScript("handsontable", function() {
    <?= $lv_sec; ?>_ctr_hot = new Handsontable(<?= $lv_sec; ?>_ctr_cnt, <?= $lv_sec; ?>_ctr_set);
    var lv_dat = [<?php
      $lv_buffer = '';
      $vew_data->cnstskctr = $vew_data->cnstskctr ?? [];
      foreach ($vew_data->cnstskctr as $lv_row) {
        $lv_buffer .= ($lv_buffer=='' ? '' : ', ')
                    . '{cnstskrskctrcod:"'.$lv_row['cnstskrskctrcod'].'",'
                    . 'cnsrskctrcod:"'.$lv_row['cnsrskctrcod'].'",'
                    . 'cnsrskctrtxt:"'.utf8_decode($lv_row['cnsrskctrtxt']).'"}';
      }
      echo $lv_buffer;
    ?>];

    <?= $lv_sec; ?>_ctr_hot.loadData(lv_dat);
    <?= $lv_sec; ?>_ctr_hot.render();
  });
</script>
  <script>
    $(function(e){
        // Cuando se muestra la solapa GENERAL
        $("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){
          tmssHandsontableResize();
        });

        // Cuando se muestra la solapa RIESGOS Y CONTROLES
       $("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab002']").on("shown.bs.tab", function() {
          tmssHandsontableResize();
          if (<?= $lv_sec; ?>_rsk_hot) {
              <?= $lv_sec; ?>_rsk_hot.render();
          }
          if (<?= $lv_sec; ?>_ctr_hot) {
              <?= $lv_sec; ?>_ctr_hot.render();
          }
      });
  	});
  </script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      
      // al grabar
			if(lp_prm["action"]=="00") {
        var lv_arr = new Array();
        
				// agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({"cnstskmatcod":<?= $lv_sec; ?>_hotdocdel[i]["cnstskmatcod"],"deleted":"X"});
				}
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();			
				for (var i=0; i<lo_dat.length; i++) {
          //obtien el codigo de objeto
          var lv_srcobjtyp = <?= $lv_sec; ?>_getObject( lo_dat[i]["srcobjtyptxt"], "" ).type;
          
          if(lo_dat[i]["srcobjtxt"]!=undefined && lv_srcobjtyp!="" && lo_dat[i]["srcobjcod001"]!=""){
            lv_arr.push({	"cnstskmatcod":lo_dat[i]["cnstskmatcod"],
                         	"srcobjcod001":lo_dat[i]["srcobjcod001"],
                          "srcobjtyp":lv_srcobjtyp,
                          "matqty":(lo_dat[i]["matqty"]==undefined || lo_dat[i]["matqty"]=="" ? "1": lo_dat[i]["matqty"]),
                          "matuntcod":lo_dat[i]["matuntcod"]
                        });
          }
				}
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #cnstskmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #cnstskmat").prop("value", JSON.stringify( lv_arr ) );
				}
        // RIESGOS
        var lo_rskdat = <?= $lv_sec; ?>_rsk_hot.getSourceData();
        var lv_rskarr = [];
        for (var i = 0; i < lo_rskdat.length; i++) {
          if (lo_rskdat[i]["cnsrskctrcod"]) {
            lv_rskarr.push({
              "cnstskrskctrcod": lo_rskdat[i]["cnstskrskctrcod"] || 0,
              "cnsrskctrcod": lo_rskdat[i]["cnsrskctrcod"],
              "docsts": "A"
            });
          }
        }
        $("#<?= $lv_sec; ?> #cnstsksrsk").val(JSON.stringify(lv_rskarr));

        // CONTROLES
        var lo_ctrdat = <?= $lv_sec; ?>_ctr_hot.getSourceData();
        var lv_ctrarr = [];
        for (var i = 0; i < lo_ctrdat.length; i++) {
          if (lo_ctrdat[i]["cnsrskctrcod"]) {
            lv_ctrarr.push({
              "cnstskrskctrcod": lo_ctrdat[i]["cnstskrskctrcod"] || 0,
              "cnsrskctrcod": lo_ctrdat[i]["cnsrskctrcod"],
              "docsts": "A"
            });
          }
        }
        $("#<?= $lv_sec; ?> #cnstsksctr").val(JSON.stringify(lv_ctrarr));
        // Combinar riesgos y controles en un solo JSON
        var lv_all = lv_rskarr.concat(lv_ctrarr);
        $("#<?= $lv_sec; ?> #cnstskrskctr").val(JSON.stringify(lv_all));
			}    
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>