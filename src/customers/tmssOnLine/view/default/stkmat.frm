<?php
	// url del formulario 
  $lv_lnk = '?prg=stkmat&prm_matcod='.$vew_data->matcod;

	// campos requeridos 
	$lv_reqflddef = array('mattxt','matuntcod','docsts','matunttxt');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento 
	$lv_dockey = $vew_data->matcod;

	// titulo 
	$lv_title = $vew_lang->material;

	// m?dulo y programa 
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MAT';

	// librer?a de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('lngcod',	'hidden', 'ES'); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<?php if ($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matstkrel')!='') { ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->stock; ?></a></li><?php } ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" onclick="" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->matcod; ?><?=gethtml('matcod',	'hidden', $vew_data->matcod);?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-5">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('matcodext',	'matcod', $vew_data->matcodext,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,  'input'=>gethtml('mattxt', 		'mattxt', $vew_data->mattxt, 		$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->unit,
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('matunttxt', 'typeahead', $vew_data->matunttxt, $lv_default) )) ));
                    echo gethtml('matuntcod', 'hidden', $vew_data->matuntcod, $lv_default);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			  'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                    echo '<hr>';  
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->classification,
                                                    'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                       array('input'=>gethtml('matclstxt', 'typeahead', $vew_data->matclstxt, $lv_default) )) ));
                    echo gethtml('matclscod', 'hidden', $vew_data->matclscod );
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->hierarchy
                                                    ,'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('mathietxt',	'doccmt1x50',	$vew_data->mathietxt, $lv_always_disabled) )
                                                                        )));
                  	echo gethtml('mathiecod', 'hidden', $vew_data->mathiecod );              
                    echo vew_boot($lv_col210, array('label'=>'','input1'=>'<span id="mathiepth"></span>'));								
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->generic
                                                    , 'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly)
                                                                         , array('input'=>gethtml('matgentxt', 'typeahead', $vew_data->matgentxt, $lv_default) )) ));							
                    echo gethtml('matgencod', 'hidden', $vew_data->matgencod );
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-5">
               <?php if ($vew_actcod != '001'){ ?>
              <div class="card ">
                <div class="card-body">
									<div class="form-group tmss-form-group">
                		<div class="col-xs-12"><?php include('grldatuplshwpth.frm'); ?></div>	
            			</div>
                </div><!--body-->
              </div> <!-- /card -->
              <br>
      			<?php } ?>
              <div class="card ">
              	<div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->attributes ?>
                    <a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
                  </div>
                </div>
                <div class="card-body">
                  <textarea class="hidden" id="matatr" name="matatr"></textarea>
                  <div id="matatrsht" name="matatrsht"></div>
                </div><!--body-->
              </div> <!-- /card -->
            </div>
						<div class="col-md-2 text-center">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->options; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && $vew_data->matcod!='' ) { ?><a href="#" id="btnidt" class="card-opt-body text-left" title="<?= $vew_lang->identification; ?>"><i class="fas fa-barcode"></i><span> <?= $vew_lang->identification; ?></span></a><?php } ?>
									<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && $vew_data->matcod!='' ) { ?><a href="#" id="btnstklvl" class="card-opt-body text-left" title="<?= $vew_lang->stock; ?>"><i class="fas fa-cubes"></i><span> <?= $vew_lang->stock; ?></span></a><?php } ?>
                </div>
							</div>
						</div> <!-- col-md-2 -->
					</div>
				</div> <!-- fin _tab001 -->
				<!-- STOCK -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
          <div class="row">
            <div class="col-sm-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->configuration; ?></div></div>
                <div class="card-body tmss-card-body-edit">
              		<?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->usebatch, 				'input'=>gethtml('matusebch', 	'yesno', 	$vew_data->matusebch, 	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->profile, 					
                                                    'input1'=> vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
                                                    array( 'input'=>gethtml('matbchdocclstxt', 'typeahead', 	($vew_data->matbchdocclstxt != ''?$vew_data->matbchdocclstxt:''), ($vew_data->matusebch == '1')?$lv_default:$lv_always_disabled) ))));
              		 echo gethtml('matbchdocclscod', 'hidden',($vew_data->matbchdocclscod != ''?$vew_data->matbchdocclscod:'')); 
									 echo '<hr>';
	                  echo vew_boot($lv_col210, array('label'=>$vew_lang->useserialnumbers, 'input'=>gethtml('matuseser', 	'yesno', 	($vew_data->matuseser != '')?$vew_data->matuseser:'0', 	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->profile, 					
                                                    'input1'=> vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
                                                    array( 'input'=>gethtml('matserdocclstxt', 'typeahead', 	($vew_data->matserdocclstxt != ''?$vew_data->matserdocclstxt:''), ($vew_data->matuseser == '1')?$lv_default:$lv_always_disabled) ))));
              		 echo gethtml('matserdocclscod', 'hidden',($vew_data->matserdocclscod != ''?$vew_data->matserdocclscod:'')); 
                  ?>           
                </div>
              </div> 
            </div>
            <div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->delivery; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->mindelivery, 			'input'=>gethtml('matminqtydel','docqty', $vew_data->matminqtydel,$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->packqtydelivery, 	'input'=>gethtml('matpckdel', 	'docqty', $vew_data->matpckdel, 	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->stockdays, 				'input'=>gethtml('matstkday', 	'docnum0600', $vew_data->matstkday, 	$lv_default) ));
                  ?>
                </div>
              </div>
            </div>
          </div>
				</div> <!-- fin _tab002 -->
				<!-- FINANZAS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->costs; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php    
                    echo vew_boot($lv_col2424, array('label1'=>$vew_lang->cost, 
                                                       'input1'=>gethtml('matcst', 'docqty', $vew_data->matcst, $lv_default), 
                                                       'label2'=>$vew_lang->currency, 'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                                                         array('input'=>gethtml('matcstcurcod', 'curcod', $vew_data->matcstcurcod, $lv_always_disabled) )) ));
                    echo vew_boot($lv_col2424, array('label'=>$vew_lang->quantity, 
                                                       'input'=>gethtml('matcstqty', 'docqty', $vew_data->matcstqty,	$lv_default),
                                                       'label1'=>$vew_lang->unit,			'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                                                         array('input'=>gethtml('matcstuntcod', 'matuntcod', $vew_data->matcstuntcod, $lv_always_disabled) )) ));
                    echo vew_boot($lv_col210, array('label'=>'&Uacute;ltima Actualizaci&oacute;n')); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 		'input'=>gethtml('matcstlstupd', 'doccmt1x50', $vew_data->matcstlstupd, $lv_always_disabled) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier, 'input'=>gethtml('suptxt', 'doccmt1x50', $vew_data->suptxt, $lv_always_disabled) ));
                  ?>
                </div>
              </div>
						</div>
          	<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= 'Contabilidad Existencias'; ?></div></div>
              	<?php include('grldatacc.frm'); ?>
              </div> <!-- card --> 
              <br>
              <div class="card ">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->taxes ?>
                    <a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
                  </div>
                </div>
                <div class="card-body">
                  <textarea class="hidden" id="mattax" name="mattax"></textarea>
                  <div id="mattaxsht" name="mattaxsht"></div>
                </div><!--body-->
              </div> <!-- /card --> 
            </div> <!-- col -->
					</div> <!-- row --> 
				</div> <!-- fin _tab003 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <script>
    //tabla atributos
    var go_<?= $lv_sec; ?>_tblatr;
    var go_<?= $lv_sec; ?>_tblcfgatr;
    var gv_<?= $lv_sec; ?>_tbldatatr; 
    go_<?= $lv_sec; ?>_tblcfgatr = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->Key; ?>", width:"70%"}, {title:"<?= $vew_lang->Value; ?>", width:"30%"}],
                columnsData: [
                              { id: "matatrnme", type:"TEXT" },
                              { id: "matatrval", type:"TEXT" }
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                };
                    
    gv_<?= $lv_sec; ?>_tbldatatr = [<?php
        $lv_buffer='';
				$x=0;
				while( $vew_doc->getTagValue($vew_data->matatr,'atr'.$x)!='' ) {
					$lv_data = $vew_doc->getTagValue($vew_data->matatr, 'atr'.$x);
					$lv_atrnme = $vew_doc->getTagValue($lv_data,'matatrnme');
					$lv_atrval = $vew_doc->getTagValue($lv_data,'matatrval');
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'matatrnme:"'.$lv_atrnme.'",'.
												'matatrval:"'.$lv_atrval.'"}';
					$x++;
				}
				echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tblatr = new tmssTable($("#<?= $lv_sec; ?> #matatrsht"), go_<?= $lv_sec; ?>_tblcfgatr);
    
    $(function(){
    	go_<?= $lv_sec; ?>_tblatr.loadData(gv_<?= $lv_sec; ?>_tbldatatr);
    });
  </script>
   <script>
     //tabla impuestos
    var go_<?= $lv_sec; ?>_tbltax;
    var go_<?= $lv_sec; ?>_tblcfgtax;
    var gv_<?= $lv_sec; ?>_tbldattax; 
    go_<?= $lv_sec; ?>_tblcfgtax = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->type; ?>", width:"50%"}, {title:"<?= $vew_lang->indicator; ?>", width:"50%"}],
                columnsData: [
                              { id: "fintaxtyptxt", type:"typeahead",
                               typeahead: function(values){ 
                                 return {definition: "fintaxtyp",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"fintaxtyptxt": "fintaxtyptxt", 
                                                    "fintaxtypcod": "fintaxtypcod"}
                                           }
                                         };
                               }
                              },
                              { id: "fintaxindtxt", type:"typeahead",
                               typeahead: function(values){ 
                                 return {definition: "fintaxind",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"fintaxindtxt": "fintaxindtxt", 
                                                    "fintaxindcod": "fintaxindcod"}
                                           }
                                         };
                               }
                              }
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                };
                    
    gv_<?= $lv_sec; ?>_tbldattax = [<?php
        $lv_buffer='';
				foreach($vew_data->mattax as $lv_row) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
            						'stkmattaxcod:"'.$lv_row['stkmattaxcod'].'",'.
												'fintaxtypcod:"'.$lv_row['fintaxtypcod'].'",'.
												'fintaxtyptxt:"'.$lv_row['fintaxtyptxt'].'",'.
												'fintaxindcod:"'.$lv_row['fintaxindcod'].'",'.
												'fintaxindtxt:"'.$lv_row['fintaxindtxt'].'"}';
				}
				echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tbltax = new tmssTable($("#<?= $lv_sec; ?> #mattaxsht"), go_<?= $lv_sec; ?>_tblcfgtax);
    
    $(function(){
    	go_<?= $lv_sec; ?>_tbltax.loadData(gv_<?= $lv_sec; ?>_tbldattax);
    });
  </script>
  <script>
  	$("#<?= $lv_sec; ?> #matuseser").on("change",function(e){
    	if($("#<?= $lv_sec; ?> #matuseser").val() == '1'){
        $("#<?= $lv_sec; ?> #matserdocclstxt").prop("readonly", false);
        $("#<?= $lv_sec; ?> #matserdocclstxt").next().next("span").children("a:first").removeClass("disabled");
      }else{
        $("#<?= $lv_sec; ?> #matserdocclstxt").prop("readonly", true);
        $("#<?= $lv_sec; ?> #matserdocclstxt").next().next("span").children("a:first").addClass("disabled");
        $("#<?= $lv_sec; ?> #matserdocclstxt").prop("value", "");
        $("#<?= $lv_sec; ?> #matserdocclscod").prop("value", "");
      }
    });

    //matbchdocclstxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>","fldflt":{"d.objtyp": "STK_BCH"}, "fldasg" : {"matbchdocclscod" : "sysdocclscod", "matbchdocclstxt" : "sysdocclstxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #matbchdocclstxt"), "sysdoccls", lo_get);
    
    //matserdocclstxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>","fldflt":{"d.objtyp": "STK_SER"}, "fldasg" : {"matserdocclscod" : "sysdocclscod", "matserdocclstxt" : "sysdocclstxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #matserdocclstxt"), "sysdoccls", lo_get);

		// matuntcod
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"matuntcod" : "matuntcod", "matunttxt" : "matunttxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #matunttxt"), "stkmatunt", lo_get);

		// matcstuntcod
		$("#<?= $lv_sec; ?> #matcstuntcod")
			.next("span").children("a:first").on("click", function(e) { e.preventDefault(); 
				tmssPopup("Unidades","index.php?prg=stkmatunt&prm_vewcod=VEW_STK_MAT_UNT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[matcstuntcod:matuntcod]");
			});

		// matcstcurcod
		$("#<?= $lv_sec; ?> #matcstcurcod")
			.next("span").children("a:first").on("click", function(e) { e.preventDefault();
				tmssPopup("Monedas","index.php?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[matcstcurcod:curcod]");
			});
    
		//matclstxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"matclscod" : "matclscod", "matclstxt" : "matclstxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #matclstxt"), "stkmatcls", lo_get);
		
		// mathiecod-mathietxt
		$("#<?= $lv_sec; ?> #mathietxt")
			.on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #mathietxt").prop("value","").trigger("change");} })
			.next("span").children("a:first").on("click", function(e) { e.preventDefault();
				tmssPopup("Jerarqu&iacute;as","index.php?prg=stkmathie&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[mathiecod:mathiecod],[mathietxt:mathietxt]");
			});

		// mathietxt
		$("#<?= $lv_sec; ?> #mathietxt").on("change",function(){
			var lv_mathiecod = $("#<?= $lv_sec; ?> #mathiecod").prop("value");
      $(".bootstrap-dialog").modal("hide");
			if ( lv_mathiecod!="" ) {
				tmssCallProcess("?prg=stkmathie&act=23&prm_mathiecod="+lv_mathiecod, [], function(data) {
					<?= $lv_sec; ?>_showHie( data.data.mathiepth );
				});
			} else {
				$("#<?= $lv_sec; ?> #mathiepth").html( "" );
			}
		});
		
		//matgentxt
  	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt":{"m.docsts":"A"}, "fldasg":{"matgencod":"matcod", "matgentxt":"mattxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #matgentxt"), "stkmat", lo_get);

    
		//  IDENTIFICACION
		$("#<?= $lv_sec; ?> #btnidt").on("click", function(e) { e.preventDefault();
			tmssCallProcess("?prg=stkmatidt&act=<?= ($vew_readonly?'03':'02'); ?>", {matcod:$("#<?= $lv_sec; ?> #matcod").prop("value"), oldSec: "<?= $lv_sec; ?>"}, function(data) {
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "Conversi&oacute;n e Identificaci&oacute;n",
          draggable: true,
					message: $(data),
          buttons:[
                  	{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger <?= ($vew_readonly?'hidden':''); ?>", action: function(dialogItself){ dialogItself.close(); } },
            				{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success <?= ($vew_readonly?'hidden':''); ?>", action: function(dialogItself){
                      var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
                      var lv_arr = [];

                      // Procesar los datos de la tabla
                      for (var i = 0; i < lo_dat.length; i++) {
                          if (lo_dat[i]["matidtqty"] != "" && lo_dat[i]["matidtqty"] != undefined) {
                              lv_arr.push({
                                  "matidtcod": lo_dat[i]["matidtcod"],
                                  "matidtqty": lo_dat[i]["matidtqty"],
                                  "matidtuntcod": lo_dat[i]["matidtuntcod"],
                                  "matbseqty": lo_dat[i]["matbseqty"],
                                  "matidtcodext": lo_dat[i]["matidtcodext"],
                                  "docsts": "A"
                              });
                          }
                      }
                      // agrego las filas eliminadas
                      for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length; i++) {
                        lv_arr.push({	"matidtcod": <?= $lv_sec; ?>_hotdocdel[i]["matidtcod"],
                                      "deleted":"X"
                                    });
                      }

                      // Llamar a tmssCallProcess para grabar los datos
                      tmssCallProcess("?prg=stkmatidt&act=00", {matcod: $("#<?= $lv_sec; ?> #matcod").prop("value"), matidt: JSON.stringify(lv_arr)}, function(response) {
                        toastr.success("Documento grabado.", "<?= $vew_lang->conversion ?>");
                        dialogItself.close();
                        <?= $lv_sec; ?>_fnc({action: "99"});
                      });
                    }}
            			]
				});
			});
		});

		//  NIVELES DE STOCK
		$("#<?= $lv_sec; ?> #btnstklvl").on("click", function(e) { e.preventDefault();
			tmssCallProcess("?prg=stkmatstklvl&act=<?= $vew_actcod; ?>", {matcod:$("#<?= $lv_sec; ?> #matcod").prop("value")}, function(data) {
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "Niveles de Stock",
					message: $(data)
				});
			});
		});
    
		function <?= $lv_sec; ?>_showHie( lp_mathiepth ) {
			if ( lp_mathiepth=="" ) {
				$("#<?= $lv_sec; ?> #mathiepth").html( "" );
			} else {
				var lv_htmpth = lp_mathiepth.replace(/\t/g,"</li><li>");
				lv_htmpth = "<ol class='breadcrumb'><li>"+lv_htmpth+"</li></ol>";
				$("#<?= $lv_sec; ?> #mathiepth").html( lv_htmpth );
			}
		}
		
		$(function(){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab003']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
      $("#<?= $lv_sec; ?> #matserdocclstxt").next().next("span").children("a:first").addClass(($("#<?= $lv_sec; ?> #matuseser").val() == '0')?"disabled":"");
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00"  ) {
				//Pasar a un text area el contenido del HandsOnTable de atributos
        var lo_dat = go_<?= $lv_sec; ?>_tblatr.getData();
        $("#<?= $lv_sec; ?> #matatr").text(JSON.stringify( lo_dat ));
				// obtengo datos de tmsstable de Impuestos
				var lv_dattax = go_<?= $lv_sec; ?>_tbltax.getData();
        var lv_deltax = go_<?= $lv_sec; ?>_tbltax.getDeleted();
				var lv_arrtax = new Array();
        for (var i=0; i<lv_deltax.length; i++) {
        	lv_arrtax.push({	"stkmattaxcod":lv_deltax[i]["stkmattaxcod"],
														"deleted":"X"
											});
				}
				for (var i=0; i<lv_dattax.length; i++) {
					if (lv_dattax[i]["fintaxtypcod"]!="" && lv_dattax[i]["fintaxtypcod"]!=undefined ){
						lv_arrtax.push({"stkmattaxcod":lv_dattax[i]["stkmattaxcod"],
                            "fintaxtypcod":lv_dattax[i]["fintaxtypcod"],
														"fintaxindcod":lv_dattax[i]["fintaxindcod"]
												});
					}
				}
				if (lv_arrtax.length==0) {
					$("#<?= $lv_sec; ?> #mattax").text("");
				} else {
					$("#<?= $lv_sec; ?> #mattax").text( JSON.stringify( lv_arrtax ) );
				}
			}
		}
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>