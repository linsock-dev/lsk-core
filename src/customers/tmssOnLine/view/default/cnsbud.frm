<?php	
	// url del formulario
  $lv_lnk = '?prg=cnsbud&prm_budcod='.$vew_data->budcod; 

	// campos requeridos
	$vew_input->RequiredFields( array('budtxt','buddte','stecod','stetxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->budcod; 

	// titulo
	$lv_title = $vew_lang->planning;
	
	// módulo y programa
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'BUD';
	
	$lo_budcst = (isset($vew_data->budcst)?(is_array($vew_data->budcst)?$vew_data->budcst:array()):array());
	foreach($lo_budcst as &$lv_row){
		unset($lv_row['ctedte']);
		unset($lv_row['upddte']);
	}
	unset($lv_row);
	
	// valores x default
	if($vew_data->budcod==''){
		$vew_data->buddte = new DateTime();
		$vew_data->docsts='A';
	}

	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea id="budtskdat" name="budtskdat" class="hidden"></textarea>

    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4>#<strong><?= $vew_data->budcod; ?><?= gethtml('budcod','hidden',$vew_data->budcod); ?></strong></h4></li>
      </ul>
      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                  <div class="card-title"><?= $lv_title; ?>
                  	<span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?> 
                    	<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
								</div>
                <div class="card-body tmss-card-body-edit">
             	  	<?php
              			echo vew_boot($lv_col210, array('label'=>$vew_lang->date,	'input'=>gethtml('buddte', 'docdte', $vew_data->buddte, $lv_default) )); 
              			echo vew_boot($lv_col210, array('label'=>$vew_lang->constructionsite,
                                              			'input1'=>vew_boot( array('style'=>'search', 'readonly'=>($vew_data->budcod==''?$vew_readonly:true) ),
                                                                  			array('input'=>gethtml('stetxt', 'typeahead', $vew_data->stetxt, ($vew_data->budcod==''?$lv_default:$lv_always_disabled) ) )) ));
                		echo gethtml('stecod', 'hidden', $vew_data->stecod);
                		echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('budtxt', 'doccmt1x50', $vew_data->budtxt, $lv_default) ));
                		echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
              		?>
              </div>
            </div>
          </div>
        </div>
      </div>
     	<div id="cnsbudtsk"></div> 
    	</div> <!-- /tab-content -->
  	</div> <!-- /container-fluid -->
	</form>
	<script>
		$(function(){
			
			var lv_budtsk = [<?php
				$lv_buffer='';
				foreach($vew_data->budtsk as $lv_row){ 
					if( (isset($lv_row['srcobjtyp'])?$lv_row['srcobjtyp']:'')!='' && (isset($lv_row['srcobjcod001'])?$lv_row['srcobjcod001']:'')!='' ){
						$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'budmatcod:"'.(isset($lv_row['budmatcod'])?$lv_row['budmatcod']:'').'",'.
												'srcobjtyp:"'.$lv_row['srcobjtyp'].'",'.
												'srcobjtyptxt:"'.($lv_row['srcobjtyp']=='HHR_EMP'?$vew_lang->employees:
																				($lv_row['srcobjtyp']=='STK_MAT'?$vew_lang->materials:
																				($lv_row['srcobjtyp']=='LOG_VHC'?"Vehiculos":
																				($lv_row['srcobjtyp']=='BUY_SUP'?$vew_lang->supplier:
																				($lv_row['srcobjtyp']=='CNS_TSK'?$vew_lang->tasks:''))))).'",'.
												'srcobjcod001:"'.$lv_row['srcobjcod001'].'",'.
												'srcobjcod002:"'.(isset($lv_row['srcobjcod002'])?$lv_row['srcobjcod002']:'').'",'.
												'srcobjcodext:"'.(isset($lv_row['srcobjcodext'])?$lv_row['srcobjcodext']:'').'",'.
												'srcobjtxt:`'.(isset($lv_row['srcobjtxt'])?$lv_row['srcobjtxt']:'').'`,'.
												'matqty: '.(isset($lv_row['matqty'])?$lv_row['matqty']:'1').' ,'.
												'matuntcod:"'.(isset($lv_row['matuntcod'])?$lv_row['matuntcod']:'').'",'.
												'budmatatrtmestr:"'.$vew_doc->getTagValue( $lv_row['budmatatr'], 'tmestr' ).'",'.
												'budmatatrtmeend:"'.$vew_doc->getTagValue( $lv_row['budmatatr'], 'tmeend' ).'",'.
												'budmatrow:"'.(isset($lv_row['budmatrow'])?$lv_row['budmatrow']:'').'"'.
												'}'; 
					}
				}
				echo $lv_buffer; ?>];
			var lv_budtskhot = <?= $lv_sec; ?>_parseCnsTskMatHot( lv_budtsk, [0], "" );
			
			// TAREAS
			var lv_pstdat=[ {name:"budcod",value:$("#<?= $lv_sec; ?> #budcod").prop("value")},
											{name:"srcobjtxt",value:$("#<?= $lv_sec; ?> #stetxt").prop("value")},
											{name:"budtsk",value: JSON.stringify(lv_budtskhot) },
                     	{name:"stetxt",value:"<?= $vew_data->stetxt; ?>"},
											{name:"actcod",value:"<?= $vew_actcod; ?>"}
										];
			tmssCallProcess("?prg=cnsbud&act=showTasks",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #cnsbudtsk").html( data );
			});
		});
  </script>  	
	<script>
		// obra - typeahead
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"s.docsts":"A"},  "fldasg":{"stecod":"stecod","stetxt":"stetxt"}};
 		tmssTypeahead($("#<?= $lv_sec; ?> #stetxt"), "cnsste", lo_get); 
	</script>
	<script>
		// parsea una estructura plana en una jerarquia de arrays basado en el indice (budmatrow)
		function <?= $lv_sec; ?>_parseCnsTskMatHot( lp_dat, lp_inx, lp_keyprv ){
      var lv_arr = new Array();
			for(var i=lp_inx[0]; i<lp_dat.length; i++, lp_inx[0]++){
				// comparo elemento actual y elemento siguiente
				if(i+1<lp_dat.length){
					// si el elemento siguiente pertenece al elemento actual (comparte mismo inicio de clave) entonces se ejecuta la recursiva
					if( lp_dat[i]["budmatrow"]+"."==lp_dat[i+1]["budmatrow"].substring(0,(lp_dat[i]["budmatrow"]+".").length) &&
							(lp_keyprv=="" || lp_keyprv+"."==lp_dat[i]["budmatrow"].substring(0, (lp_keyprv+".").length)) ){
						lp_inx[0]++;
						lp_dat[i]["cnstskmat"] = <?= $lv_sec; ?>_parseCnsTskMatHot(lp_dat, lp_inx, lp_dat[i]["budmatrow"]);
						lv_arr.push( lp_dat[i] );
						i = lp_inx[0];
					// el elemento siguiente no pertenece al array actual
					// el elemento actual pertenece a la raiz, se agrega
					} else if(lp_keyprv==""){
						lv_arr.push( lp_dat[i] ); 
					// verifico si el elemento actual sigue perteneciendo al array
					} else if(lp_keyprv+"."==lp_dat[i]["budmatrow"].substring(0,(lp_keyprv+".").length)) {
						lv_arr.push( lp_dat[i] ); 
					// estamos dentro de una recursiva y el elemento actual no es parte del array tratado
					} else {
						lp_inx[0]--;
						return lv_arr;
					}
					
				// ultimo elemento del array
				// el elemento siguiente no pertenece al array actual
				// el elemento actual pertenece a la raiz, se agrega
				} else if(lp_keyprv==""){
					lv_arr.push( lp_dat[i] ); 
				// verifico si el elemento actual sigue perteneciendo al array
				} else if(lp_keyprv+"."==lp_dat[i]["budmatrow"].substring(0,(lp_keyprv+".").length)) {
					lv_arr.push( lp_dat[i] ); 
				// estamos dentro de una recursiva y el elemento actual no es parte del array tratado
				} else {
					lp_inx[0]--;
					return lv_arr;
				}
			 
			}
			return lv_arr;
		}
		
		// parsea los registros recursivos en una tabla con un campo Indice para marcar la dependencia (budmatrow)
		function <?= $lv_sec; ?>_parseCnsTskMat( lp_key, lp_dat, lp_datdel ){
			var lv_key;
			var lv_arr = new Array();
			var lo_dat = [];
			// agrego las filas eliminadas
			var lo_datdel = JSON.parse( lp_datdel );
			for (var i=0; i<lo_datdel.length; i++) {
				lv_arr.push({	"budmatcod":lo_datdel[i]["budmatcod"], "deleted":"X" });
			}
			// agrego filas grabadas
			var lo_dat = ( Array.isArray(lp_dat) ? lp_dat : JSON.parse(lp_dat) );
			for (var i=0; i<lo_dat.length; i++) {
				lv_key = lp_key+(lp_key==""?"":".")+(1000+i).toString();
				if ( lo_dat[i]["srcobjtxt"]!="" && lo_dat[i]["srcobjtxt"]!=undefined ) {
					lv_arr.push({	"budmatcod":lo_dat[i]["budmatcod"],
												"srcobjtyp":lo_dat[i]["srcobjtyp"],
												"srcobjcod001":lo_dat[i]["srcobjcod001"],
												"srcobjcodext":lo_dat[i]["srcobjcodext"],
												"srcobjtxt":lo_dat[i]["srcobjtxt"],
												"matqty":lo_dat[i]["matqty"],
												"matuntcod":lo_dat[i]["matuntcod"],
												"budmatatrtmestr":lo_dat[i]["budmatatrtmestr"],
												"budmatatrtmeend":lo_dat[i]["budmatatrtmeend"],
												"budmatrow":lv_key
											});
					
					var lo_cnstskmat = (lo_dat[i]["cnstskmat"]!="" && lo_dat[i]["cnstskmat"]!=undefined ? lo_dat[i]["cnstskmat"] : "[]" );
					var lo_cnstskmatdel = (lo_dat[i]["cnstskmatdel"]!="" && lo_dat[i]["cnstskmatdel"]!=undefined ? lo_dat[i]["cnstskmatdel"] : "[]" );
					var lv_arr2 = <?= $lv_sec; ?>_parseCnsTskMat( lv_key, lo_cnstskmat, lo_cnstskmatdel );
					if(lv_arr2.length>0){ lv_arr = lv_arr.concat( lv_arr2 ); }
				}
			}
			return lv_arr;
		}
	</script>
	<script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				// descargo tareas de la grilla a textarea
				$("#<?= $lv_sec; ?> #budtskdwn").trigger("click");
				var lv_arr = <?= $lv_sec; ?>_parseCnsTskMat( "", $("#<?= $lv_sec; ?> #budtsk").text(), $("#<?= $lv_sec; ?> #budtskdel").text() );
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #budtskdat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #budtskdat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>