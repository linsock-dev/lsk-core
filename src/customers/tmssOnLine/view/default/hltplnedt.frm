<?php
	// url del formulario
  $lv_lnk = '?prg=hltpln&prm_patcod='.$vew_dtedat->patcod.'&prm_plnvew='.$vew_dtedat->plnvew.'&prm_popup='.$vew_dtedat->popup;

	// campos requeridos
	$vew_input->RequiredFields( array('plndte','plndteto',($vew_dtedat->patcodlst==''?'patcod':'patcodlst'),'pattxt','prscod','prstxt','spccod','spctxt','deltxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_dtedat->plnid."/".$vew_dtedat->plndteid;

	// titulo
	$lv_title = $vew_lang->planning;
	// módulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLN';
	$lv_ctrdte = (count($vew_dtedat->ctrdte)>0?$vew_dtedat->ctrdte[0]['hltplnctrdte']:'');
	$lv_ctrdel = (count($vew_dtedat->ctrdte)>0?($vew_dtedat->ctrdte[0]['deldte']?true:false):false);
	
	$lv_inbdte = ($lv_ctrdte!=''?$vew_dtedat->ctrinbdte:$vew_dtedat->plninbdte);
	$lv_outdte = ($lv_ctrdte!=''?$vew_dtedat->ctroutdte:$vew_dtedat->plnoutdte);
	$lv_qty    = ($lv_ctrdte!=''?$vew_dtedat->ctrqty:$vew_dtedat->plnqty);
	$lv_prscod = ($vew_dtedat->hltplnctrprscod!=''?$vew_dtedat->hltplnctrprscod:$vew_dtedat->prscod);
	$lv_prstxt = ($vew_dtedat->hltplnctrprscod!=''?$vew_dtedat->hltplnctrprstxt:$vew_dtedat->prstxt);
	$lv_strdte = ($vew_dtedat->plnid!=''?$vew_dtedat->grpstrdte: ($vew_dtedat->plnstrdte!=''?substr($vew_dtedat->plnstrdte,6,2).'/'.substr($vew_dtedat->plnstrdte,4,2).'/'.substr($vew_dtedat->plnstrdte,0,4):'') );
	$lv_enddte = ($vew_dtedat->plnid!=''?$vew_dtedat->grpenddte: ($vew_dtedat->plnenddte!=''?substr($vew_dtedat->plnenddte,6,2).'/'.substr($vew_dtedat->plnenddte,4,2).'/'.substr($vew_dtedat->plnenddte,0,4):'') );

	$vew_actcod = ($vew_actcod=='00' ? '02' : $vew_actcod);
	$vew_actcod = ($lv_ctrdte!='' || $vew_dtedat->evlcod!=''?'03': $vew_actcod);
	if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,$vew_actcod)==false ) { $vew_actcod = '03'; }

	// librería de estilos bootstrap
	include_once('_library.frm');

  $lv_plndte = $vew_dtedat->plndte ?? '';

	$lv_evlfrm = (($vew_dtedat->evlcod=='' && $vew_dtedat->plndteid!='' && $vew_sec->hasPermission('HLT','EVL','01')) || ($vew_dtedat->evlcod!='' && $vew_sec->hasPermission('HLT','EVL','02')) || ($vew_dtedat->evlcod!='' && $vew_sec->hasPermission('HLT','EVL','03')));
	
	/* Botones de vista */
	$vew_dropdown = true;
	$vew_tbl['new'] = array('per'=>false);
  $vew_tbl['modL'] = array('per'=>( $lv_ctrdte!='' || $vew_dtedat->evlcod!='' ? false : $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') ));
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['clsR'] = array('per'=>false);
	$vew_tbl['cpy']=array('per'=>false);
	$vew_tbl['sveL'] = array('pos'=>'L','per'=>true,'ttl'=>$vew_lang->save,'id'=>'','icn'=>'fas fa-save','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success','acc'=>$lv_sec.'_fnc({action: '.chr(39).'00'.chr(39).'})');
	$vew_tbl['del'] =  array('pos'=>'D','per'=>($vew_dtedat->plndteid!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04')), 'ttl'=>$vew_lang->delete, 'id'=>'', 'icn'=> 'fas fa-trash-alt', 'css'=>'tmss-Opt','acc'=>$lv_sec.'_fnc({action: '.chr(39).'04'.chr(39).'});');
	$vew_tbl['rfrsh'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'99'.chr(39).'});'); 	
	$vew_tbl['evlfrm'] = array('pos'=>'R','per'=>$lv_evlfrm,'ttl'=>$vew_lang->evolution,'id'=>'btnfrm','icn'=>'fas fa-table','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled '.($vew_dtedat->evlcod==''?'btn-danger':($vew_dtedat->evlsts=='A'?'btn-success':'btn-info')));
  if ($vew_dtedat->plndteid!='' && $vew_dtedat->spcplntyp=='2' && $vew_dtedat->plncnfdte=='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'07')) { 
		$vew_tbl['acpt'] = array('pos'=>'L','per'=>true,'ttl'=>$vew_lang->accept,'id'=>'btnacp','icn'=>'far fa-thumbs-up','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled btn-default');
		$vew_tbl['rej'] =  array('pos'=>'L','per'=>true,'ttl'=>$vew_lang->reject,'id'=>'btnrej','icn'=>'far fa-thumbs-down','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled btn-default');
  }
 $vew_tbl['rmvser'] =  array('pos'=>'L','per'=>($vew_dtedat->plndteid!='' && $lv_strdte!=$lv_enddte && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05')),'ttl'=>$vew_lang->removefromserie,'id'=>'','icn'=>'fas fa-braille','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-default','acc'=>$lv_sec.'_removeFromSerie();');
	// ESTADOS (y referencia de colores)
	$lv_color = (strtoupper($vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'REFERENCE_COLORS_IN_PLANNING'))=='X'?true:false);
	$lv_sysdocclscodexppln = $this->co_reg->document->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'sysdocclscodexppln');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?> 

  <form method="POST" class="form-horizontal pt-0" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('spcfrm', 'hidden',  $vew_dtedat->spcfrm); ?>
		<?= gethtml('spcplntyp', 'hidden',  $vew_dtedat->spcplntyp ); ?>
		<?= gethtml('spcctrtyp', 'hidden',  $vew_dtedat->spcctrtyp ); ?>
		<?= gethtml('docsts', 'hidden',  ($vew_dtedat->docsts==''?'A':$vew_dtedat->docsts)); ?>
    <?= gethtml('prsntfdte', 'hidden', is_object($vew_dtedat->prsntfdte) ? $vew_dtedat->prsntfdte->format('d/m/Y') : ''); ?>
    <?= gethtml('patntfdte', 'hidden', is_object($vew_dtedat->patntfdte) ? $vew_dtedat->patntfdte->format('d/m/Y') : ''); ?>
    <?= gethtml('evlcod', 'hidden', $vew_dtedat->evlcod); ?>
    <?= gethtml('plncnfdte', 'hidden', is_object($vew_dtedat->plncnfdte) ? $vew_dtedat->plncnfdte->format('d/m/Y') : ''); ?>
    <?= gethtml('noupdate','hidden',''); ?>
		<textarea id="patcodlst" name="patcodlst" class="hidden"><?= $vew_dtedat->patcodlst; ?></textarea>
		
    <div class="container-fluid" role="tabpanel" style="padding-top: 3px">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->studies; ?></a></li> 
				<?php if( $vew_sec->hasPermission('BUY','EXP','01') && $lv_sysdocclscodexppln!='' ){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab" name="buyexptab"><?= $vew_lang->expenses; ?></a></li><?php } ?>
				<li class="pull-right tmss-desk-btn"><h4># <strong><?= $vew_dtedat->plnid.'/'.$vew_dtedat->plndteid; ?><?= gethtml('plnid','hidden',$vew_dtedat->plnid); ?><?= gethtml('plndteid','hidden',$vew_dtedat->plndteid); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="<?= ($vew_dtedat->plndteid!='' && $vew_sec->hasPermission('HLT','PLN','02')?'col-md-9':'col-md-12'); ?>">
							<div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->planning; ?>
										<span class="tmss-card-icon">
											<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
											<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
										</span>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <!-- Período ------------------------- -->
                  <?= vew_boot(array($lv_colsm255, $lv_colxs1266), array('label'=>$vew_lang->period,
                                                        'input1'=>gethtml('plndte','docdte',$lv_strdte,($vew_dtedat->plndteid==''?$lv_default:$lv_always_disabled)),
                                                      	'input2'=>gethtml('plndteto','docdte',$lv_enddte,($vew_dtedat->plndteid==''?$lv_default:$lv_always_disabled))));?>
									
                  <div id="plndtefrq_div">
                  	<div class="form-group tmss-form-group">
                      <label class="col-sm-2 control-label"><?= $vew_lang->frequency; ?></label>
                      <a href="#" id="frqmod" class="col-sm-10 control-label"><span id="frqtxt">?</span></a>
                      <?= gethtml('serid', 'hidden',$vew_dtedat->serid); ?>
                    </div>
                  </div>
									<?php
										if ($vew_dtedat->patcodlst=='') {
											echo vew_boot($lv_colsm210, array('label'=>$vew_lang->patient, 
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_dtedat->plnvew=='plnpat' || $vew_dtedat->plnvew=='plnwek'&&$vew_dtedat->pattxt!='' ?true:$vew_readonly)), 
                                                                          array('input'=>gethtml('pattxt', 'pattxt', $vew_dtedat->pattxt,($vew_dtedat->plnvew=='plnpat' || $vew_dtedat->plnvew=='plnwek'&&$vew_dtedat->pattxt!=''?$lv_always_disabled:$lv_default)) )) ));
                      echo gethtml('patcod', 'hidden', $vew_dtedat->patcod);                  
										} else {
                      echo gethtml('patcod', 'hidden', '');                
										}
                  	// Financiador ------------------------
										echo vew_boot($lv_colsm210, array('label'=>$vew_lang->FINANCIAL, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_dtedat->plnvew=='plnpat' || $vew_dtedat->plnvew=='plnwek'?true:$vew_readonly)), 
                                                                        array('input'=>gethtml('custxt', 'custxt', $vew_dtedat->custxt, $lv_always_disabled) )) ));
                  	echo gethtml('cuscod', 'hidden', $vew_dtedat->cuscod); 
                  	// Lugar -------------------------------------
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->place, 		
                                                    'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                        array('input'=>gethtml('deltxt', 'typeahead', $vew_dtedat->deltxt, $lv_default) )) ));                 										
                    echo gethtml('delcod', 'hidden', $vew_dtedat->delcod);
                  	// Prestador --------------------------------
                  	echo vew_boot($lv_colsm210, array('label'=>$vew_lang->provider, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_dtedat->plnvew=='plnprs'?true:$vew_readonly)), 
                                                                        array('input'=>gethtml('prstxt', 'typeahead', $vew_dtedat->prstxt,($vew_dtedat->plnvew=='plnprs'?$lv_always_disabled:$lv_default)) )) ));
										echo gethtml('prscod', 'hidden', $vew_dtedat->prscod);
                  	// Especialidad ------------------------------
                  	echo vew_boot($lv_colsm210, array('label'=>$vew_lang->specialty, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_dtedat->plndteid==''?$vew_readonly:true)), 
                                                                        array('input'=>gethtml('spctxt', 'typeahead', $vew_dtedat->spctxt,($vew_dtedat->plndteid==''?$lv_default:$lv_always_disabled)) )) ));
										echo gethtml('spccod', 'hidden', $vew_dtedat->spccod);
									?>
									<div class="form-group tmss-form-group"> 
										<label class="col-sm-2 col-xs-12 control-label"><?=$vew_lang->SCHEDULE; ?></label>
										<div class="col-sm-3 col-xs-6"><?= gethtml('plninbdte', 'doctme', $vew_dtedat->plninbdte, $lv_default); ?></div>
										<div class="col-sm-3 col-xs-6"><?= gethtml('plnoutdte', 'doctme', $vew_dtedat->plnoutdte, $lv_default); ?></div>
										<label class="col-sm-2 control-label"><?= utf8_decode('Duración'); ?></label>
										<div class="col-sm-2"><?= gethtml('plntme', 'doccmt1x20', '', $lv_always_disabled); ?></div>
									</div>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label"><?= $vew_lang->sessions; ?></label>
										<div class="col-sm-10"><?= gethtml('plnqty', 'docnum0300', $vew_dtedat->plnqty, $lv_default); ?></div>
									</div>
								</div> <!-- /card-body -->
							</div> <!-- /card -->
							
						</div> <!-- /col-md-9 -->
						<div class="<?= ($vew_dtedat->plndteid!='' && $vew_sec->hasPermission('HLT','PLN','02')?'col-md-3':'hidden'); ?>">
							
							<div class="card tmss-hot-ttl">
								<div class="card-header"><div class="card-title"><?= $vew_lang->status; ?></div></div>
							</div> <!-- /card -->
							<div class="list-group small">
							<?php
                $lv_plnsts = array();
                $lv_plnsts[] = array('ststxt'=>'Planificado', 'stsclr'=>($lv_color?'#e57373':''), 'stschk'=>true, 'doccod'=>'' );
                $lv_plnsts[] = array('ststxt'=>'Notificado '.($vew_dtedat->prsntfdte!=''?'PR':'').'-'.($vew_dtedat->patntfdte!=''?'PA':''), 'stsclr'=>'', 'stschk'=>($vew_dtedat->prsntfdte!='' || $vew_dtedat->patntfdte!=''?true:false), 'doccod'=>'' );
                $lv_plnsts[] = array('ststxt'=>'Confirmado', 'stsclr'=>'', 'stschk'=>($vew_dtedat->plncnfdte!=''?true:false), 'doccod'=>'' );
                $lv_plnsts[] = array('ststxt'=>'Evolucionado'.($vew_dtedat->evlsts=='P'?' <span title="Prestación no realizada">[Sin Srv]</span>':''), 'stsclr'=>($lv_color?($vew_dtedat->evlsts=='P'?'#21a2f2':'#bdbdbd'):''), 'stschk'=>($vew_dtedat->evlcod!=''?true:false), 'doccod'=>$vew_dtedat->evlcod );
                $lv_plnsts[] = array('ststxt'=>($lv_ctrdel?'Control anulado':'Controlado'), 'stsclr'=>($lv_color?'#ffffff':''), 'stschk'=>($lv_ctrdte!=''?true:false), 'stsctropt'=>($vew_dtedat->spcctrtyp!=-1 && !$lv_ctrdel && $lv_ctrdte==''), 'doccod'=>'' );            
                foreach($lv_plnsts as $lv_row){
                  echo '<li class="list-group-item '.($lv_row['stschk']?'list-group-item-success':'').'" title="'.$lv_row['doccod'].'">'.
                    '<i class="'.($lv_row['stschk']?'far fa-check-square':'far fa-square').'"></i> '.
                    $lv_row['ststxt'].
                    ($vew_sec->hasPermission('HLT','PCR','02') ? (isset($lv_row['stsctropt']) && $lv_row['stsctropt'] ?'<span class="pull-right"><a href="#" id="btnctrcte" class="btn btn-default tmssAlwaysEnabled btn-default" style="padding:0px;width:30px;" title="Realizar control"><i class="fas fa-check"></i></a><a href="#" id="btnctrdel" class="btn btn-default tmssAlwaysEnabled btn-default" style="padding:0px;width:30px;" title="No controlar"><i class="fas fa-times"></i></a></span>':'') : '').
                    ($lv_color?'<i class="pull-right '.($lv_row['stsclr']!=''?'fas fa-square':'far fa-square').'" style="color: '.($lv_row['stsclr']!=''?$lv_row['stsclr']:'#FFFFFF').';"></i>&nbsp;':'').
                    '</li>';
								}
              ?>
							</div>
							
						</div> <!-- /col-md-3 -->
					</div> <!-- /row -->
				</div> <!-- /tabpanel -->

				<!-- ESTUDIOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">					
					<div id="spcstdhot"></div>
					<?= gethtml('plnstd', 'hidden', ''); ?>
				</div>
        
				<!-- GASTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<?= gethtml('buyexpcod','hidden',$vew_data->buyexp['buyexpcod']??''); ?>
					<?= gethtml('buyexpdoc','hidden',''); ?>
        	<div id="buyexpdochot"></div>
        </div>
		
			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->
  </form>
  <script>
		// E S T U D I O S
		var <?= $lv_sec; ?>_spcstdhot_renderer = function (instance, td, row, col, prop, value, cellProperties) {
    	if ( prop=="spcstdcmt" ) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
      	td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
      }else{
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
      }
    };
		var <?= $lv_sec; ?>_spcstdhoterr = [];
		var <?= $lv_sec; ?>_spcstdhotchg = [];
		var <?= $lv_sec; ?>_spcstdhotcnt = $("#<?= $lv_sec; ?> #spcstdhot")[0];
		var <?= $lv_sec; ?>_spcstdhotset = {
			height: 320,
			stretchH: "all",
			autoColumnSize: false,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "Estudio", "Comentarios"],
			columns: [
				{type: "autocomplete", data: "spcstdtxt", renderer: <?= $lv_sec; ?>_spcstdhot_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
            if(query.length>1){
	            tmssCallProcessNoBackdrop("?prg=hltspcstd&act=18&prm_spccod="+$("#<?= $lv_sec; ?> #spccod").prop("value")+"&prm_spcstdtxt="+query,[],function(data){
                <?= $lv_sec; ?>_spcstdhotchg = data;
                process( $.map(data, function(value, index){ return value.spcstdtxt; }) );          
  	          });
						} else { process( [query] ); }
					},
					strict: true
				},
        {type: "text", width:100, data: "spcstdcmt", renderer: <?= $lv_sec; ?>_spcstdhot_renderer, readOnly: true}
			],
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="spcstdtxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_spcstdhotchg.length ; i++) {
						if(<?= $lv_sec; ?>_spcstdhotchg[i].spcstdtxt == lv_value) {
							changes.push([ changes[0][0], "spcstdcod", "", String(<?= $lv_sec; ?>_spcstdhotchg[i].spcstdcod) ]);
              changes.push([ changes[0][0], "spcstdcmt", "", <?= $lv_sec; ?>_spcstdhotchg[i].spcstdcmt ]);
						}
					}
				}
			}
		};
		var <?= $lv_sec; ?>_spcstdhot;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_spcstdhot = new Handsontable(<?= $lv_sec; ?>_spcstdhotcnt, <?= $lv_sec; ?>_spcstdhotset);
			var lv_dat = [<?php
				$lv_buffer='';
        if (is_array($vew_data->plnstd)){
          foreach($vew_data->plnstd as $lv_row){
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'spcstdtcod: '.$lv_row['spcstdcod'].','.
                          'spcstdtxt:"'.mb_convert_encoding($lv_row['spcstdtxt'], 'ISO-8859-1', 'UTF-8').'",'.
                          'spcstdcmt: "'.(''??'').'"}';
          }
        }
        
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_spcstdhot.loadData( lv_dat );
			<?= $lv_sec; ?>_spcstdhot.render();
		});
	</script>
	<script>
		//  G A S T O S
		var <?= $lv_sec; ?>_buyexphot_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_buyexphot != undefined ) {
				if ( prop=="buyexpdoctot" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_sec; ?>_buyexphoterr = [];
		var <?= $lv_sec; ?>_buyexphotchg = [];
		var <?= $lv_sec; ?>_buyexphotdel = [];
		var <?= $lv_sec; ?>_buyexphotcnt = $("#<?= $lv_sec; ?> #buyexpdochot")[0];
		var <?= $lv_sec; ?>_buyexphotset = {
			height: 320,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "Tipo", "Importe", "Comentarios", ""],
			columns: [
				{type: "autocomplete", data: "buyexptyptxt", renderer: <?= $lv_sec; ?>_buyexphot_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
            
						$.ajax({
							url: "index.php?prg=buyexptyp&act=17", dataType: "json", data: {	prm_buyexptyptxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_buyexphotchg = [];
								for (var i=0; i < response.data.length; i++) {
									<?= $lv_sec; ?>_buyexphotchg.push( {buyexptyptxt: response.data[i]["buyexptyptxt"], buyexptypcod: response.data[i]["buyexptypcod"]} );
									lv_dat.push( response.data[i]["buyexptyptxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "numeric", data: "buyexpdoctot", width: 50, renderer: <?= $lv_sec; ?>_buyexphot_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "text", data: "buyexpdoccmt", width: 100, renderer: <?= $lv_sec; ?>_buyexphot_renderer <?= ($vew_readonly?', readOnly: true':'');	?>}
			],
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="buyexptyptxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_buyexphotchg.length ; i++) {
						if(<?= $lv_sec; ?>_buyexphotchg[i].buyexptyptxt == lv_value) {
							changes.push([ changes[0][0], "buyexptypcod", "", String(<?= $lv_sec; ?>_buyexphotchg[i].buyexptypcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_buyexphot.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["buyexpdoccod"]!="" && lv_dat[i]["buyexpdoccod"]!=undefined ) {
						<?= $lv_sec; ?>_buyexphotdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_buyexphot;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_buyexphot = new Handsontable(<?= $lv_sec; ?>_buyexphotcnt, <?= $lv_sec; ?>_buyexphotset);
			var lv_dat = [<?php
				$lv_buffer='';
        if (is_array($vew_data->buyexp)){
          foreach($vew_data->buyexp as $lv_row){
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'buyexpdoccod: '.$lv_row['buyexpdoccod'].','.
                          'buyexptypcod: '.$lv_row['buyexptypcod'].','.
                          'buyexptyptxt:"'.$lv_row['buyexptyptxt'].'",'.
                          'buyexpdoctot: '.$lv_row['buyexpdoctot'].','.
                          'buyexpdoccmt: '.(($lv_row['buyexpdoccmt']??'') !== "" ? '"'.$lv_row['buyexpdoccmt'].'"': '""').'}';
        	}
        }
      
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_buyexphot.loadData( lv_dat );
			<?= $lv_sec; ?>_buyexphot.render();			
		});
	</script>
	<script>
    // CALCULO DIF HORAS
		function calc_time(){
			var lv_tme="";
      var lv_plninbdte = $("#<?= $lv_sec; ?> #plninbdte").prop("value");
      var lv_plnoutdte = $("#<?= $lv_sec; ?> #plnoutdte").prop("value");
			if ($("#<?= $lv_sec; ?> #plninbdte").prop("value")!="" && $("#<?= $lv_sec; ?> #plnoutdte").prop("value")!="") {
        var lv_str = $("#<?= $lv_sec; ?> #plninbdte").prop("value");
				var lv_minstr = parseInt(lv_str.substr(0,2))*60 + parseInt(lv_str.substr(3,2))
				var lv_end = $("#<?= $lv_sec; ?> #plnoutdte").prop("value");
				var lv_minend = parseInt(lv_end.substr(0,2))*60 + parseInt(lv_end.substr(3,2))
				var lv_mindif = ( lv_minstr<lv_minend ? lv_minend-lv_minstr : 1440-(lv_minstr-lv_minend) );
				lv_tme = (Math.floor(lv_mindif/60)<10?"0":"") + String(Math.floor(lv_mindif/60)) + ":" + (lv_mindif-(Math.floor(lv_mindif/60)*60)<10?"0":"") + String(lv_mindif-(Math.floor(lv_mindif/60)*60));
			}
			$("#<?= $lv_sec; ?> #plntme").prop("value",lv_tme);
		}
		$("#<?= $lv_sec; ?> #plninbdte").on("blur",function(e){calc_time();});
		$("#<?= $lv_sec; ?> #plnoutdte").on("blur",function(e){calc_time();});
		
		
		// ESPECIALIDAD - TIPO DE CONTROL
		function <?= $lv_sec; ?>_spcctrdiv() {
			var lv_ctrtyp = $("#<?= $lv_sec; ?> #spcctrtyp").prop("value");
			// control de horas
			if (lv_ctrtyp=="1") {
				$("#<?= $lv_sec; ?> #plninbdte").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?= $lv_sec; ?> #plnoutdte").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?= $lv_sec; ?> #plnqty").removeClass("tmssInputRequired").prop("placeholder","");
			// control de sesiones
			} else if (lv_ctrtyp=="2") {
				$("#<?= $lv_sec; ?> #plnqty").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?= $lv_sec; ?> #plninbdte").removeClass("tmssInputRequired").prop("placeholder","");
				$("#<?= $lv_sec; ?> #plnoutdte").removeClass("tmssInputRequired").prop("placeholder","");
			} else {
				$("#<?= $lv_sec; ?> #plninbdte").removeClass("tmssInputRequired");
				$("#<?= $lv_sec; ?> #plnoutdte").removeClass("tmssInputRequired");
				$("#<?= $lv_sec; ?> #plnqty").removeClass("tmssInputRequired");
			}
		}
  </script>
	<script>
    // PACIENTE
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg": {"pattxt":"pattxt", "patcod":"patcod", "custxt":"custxt", "cuscod":"cuscod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #pattxt"), "hltpat", lo_get);
    
    // FINANCIADOR
    $("#<?= $lv_sec; ?> #custxt").next("span").children("a:first").on("click", function(e){ e.preventDefault;                                                                              
      tmssPopup("<?= $vew_lang->financial; ?>","?prg=grldatcnt&prm_vewcod=VEW_GRL_DAT_CNT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[c.cntsrctyp:HLT_PAT , c.cntsrccod:"+$("#<?=$lv_sec;?> #patcod").val()+" , sysdocclsinvadratr:X]&prm_fldasg=[custxt:c.cnttxt],[cuscod:c.cntdstcod]");                                                           
    });
    
    // LUGAR DE ATENCION
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"d.docsts":"A"}, "fldasg":{"delcod":"delcod", "deltxt":"deltxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #deltxt"), "hltdel", lo_get);
    
    // PRESTADOR Migrado
    <?php if (intval($vew_dtedat->spccod??0)!=0) { ?>
      var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A", "ps.spccod" : "<?= $vew_dtedat->spccod; ?>"}, "fldasg": {"prscod":"p.prscod", "prstxt":"p.prstxt"}};
    	tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltspcprs", lo_get);
    <?php } else { ?>
    	var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A"}, "fldasg": {"prscod":"prscod", "prstxt":"prstxt"}};
    	tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get);
    <?php } ?>
     
    // ESPECIALIDAD
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.prscod": $("#<?= $lv_sec; ?> #prscod"), "s.docsts": "A"}, "fldasg": {"spccod":"spccod", "spctxt":"spctxt", "spcctrtyp":"spcctrtyp"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #spctxt"), "hltprsspc", lo_get,{"afterAssign": function(){ <?= $lv_sec; ?>_spcctrdiv(); }});
  </script>
  <script>
		// FORMULARIO EVOLUCION
		$("#<?= $lv_sec; ?> #btnfrm").on("click",function(e){ e.preventDefault(); 
			var lv_frm = $("#<?= $lv_sec; ?> #spcfrm").prop("value");
    	var lv_evlcod = $("#<?= $lv_sec; ?> #evlcod").prop("value");
      
    	// Si el formulario esta vacio, entonces  voy a recuperar el formulario de evolucion estandar (hltpatevl)
    	if(lv_frm != ""){
      	lv_frm = lv_frm.replace("&AMP;","&");
				lv_frm = lv_frm.toLowerCase();  
      }else if(lv_evlcod == ""){
        lv_frm = "?prg=hltpatevl&act=01";
      }else {
        lv_frm = "?prg=hltpatevl&act=03";
      }
			
			var lv_pstdat={ evlcod: lv_evlcod,
                     	spccod: $("#<?= $lv_sec; ?> #spccod").prop("value"),
											patcod: $("#<?= $lv_sec; ?> #patcod").prop("value"),
											plnid: $("#<?= $lv_sec; ?> #plnid").prop("value"),
											plndteid: $("#<?= $lv_sec; ?> #plndteid").prop("value"),
											popup: "X"};
			tmssCallProcess(lv_frm,lv_pstdat,function(data){
				BootstrapDialog.show({
					title: $("#<?= $lv_sec; ?> #pattxt").prop("value") + " ("+$("#<?= $lv_sec; ?> #patcod").prop("value")+")",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE,
					draggable: true,
          onhide: function(){
            <?= $lv_sec; ?>_fnc({action: '99'});
          }
				});
			});
		});
		
		// CAMBIO FECHA INICIO / FIN
		$("#<?= $lv_sec; ?> #plndte").on("change",function(e){ <?= $lv_sec; ?>_showFreq(); });
		$("#<?= $lv_sec; ?> #plndteto").on("change",function(e){ <?= $lv_sec; ?>_showFreq(); });
    
		function <?= $lv_sec; ?>_showFreq(){
      if ( <?= $vew_actcod; ?>!='01' ) {
        // si no es una creación de planificación, no muestro los calendarios
      	$("#<?= $lv_sec; ?> #plndte").closest(".input-group").find(".input-group-addon").addClass("hidden");
        $("#<?= $lv_sec; ?> #plndteto").closest(".input-group").find(".input-group-addon").addClass("hidden");
      }
			if ( $("#<?= $lv_sec; ?> #plndte").prop("value")!=$("#<?= $lv_sec; ?> #plndteto").prop("value") ) {
				$("#<?= $lv_sec; ?> #plndtefrq_div").removeClass("hidden");
				if(($("#<?= $lv_sec; ?> #serid").val() || "").toLowerCase().includes("<frqtyp>u</frqtyp>")){
          <?= $lv_sec; ?>_updateFrequency("<frqtyp>D</frqtyp><frqqty>1</frqqty>");
        }
			} else {
				$("#<?= $lv_sec; ?> #plndtefrq_div").addClass("hidden");
        $("#<?= $lv_sec; ?> #serid").val("<frqtyp>U</frqtyp><frqqty>1</frqqty>");
			}
		}
		
		$(function() {
			// checkbox
			tmssLoadScript("toggle",function(){
				$("#<?= $lv_sec; ?> :checkbox").each( function() {	$(this).bootstrapToggle({ size: "small" }); });
			});
			// obligatoriedad de campos
			<?= $lv_sec; ?>_spcctrdiv();
			// mostrar div frecuencia
			<?= $lv_sec; ?>_showFreq();
			// calcular diferencia de horario
			calc_time();
		});
	</script>
	<script>		
		// ACEPTAR PLANIFICACION
		$("#<?= $lv_sec; ?> #btnacp").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Aceptar planificaci&oacute;n", 
				message:"El paciente confirm&oacute; el turno ?", 
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						$("#<?= $lv_sec; ?> #plncnfdte").prop("value", moment().format('DD/MM/YYYY') );
						<?= $lv_sec; ?>_fnc({action: "07"});
					}
				}
			});
		});
		
		// RECHAZAR PLANIFICACION
		$("#<?= $lv_sec; ?> #btnrej").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "Rechazar planificaci&oacute;n", 
				message:"Por favor, indique un motivo o fecha probable de replanificaci&oacute;n.<br><input class='form-control' id='rejtxt' name='rejtxt'>", 
				type: BootstrapDialog.TYPE_WARNING,
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-warning",	action: function(dialogItself){
											var lv_pstdat = { plnid: $("#<?= $lv_sec; ?> #plnid").prop("value"), plndteid: $("#<?= $lv_sec; ?> #plndteid").prop("value"), rejtxt: dialogItself.getModalBody().find("#rejtxt").val() };
											tmssCallProcess("?prg=hltpln&act=09", lv_pstdat, function(data){
												var lv_errcod = data.errcod;	
												var lv_errtxt = data.errtxt;		
												if (lv_errcod=="0") {
													toastr.success("Notificaci&oacute;n enviada.");
													$("#<?= $lv_sec; ?> #btnacp").fadeOut();
													$("#<?= $lv_sec; ?> #btnrej").fadeOut();
												} else {
													toastr.warning("Se produjo un error al enviar notificaci&oacute;n.<br>" + lv_errcod + ": " + lv_errtxt);
												}
											});
											dialogItself.close();
									}
								}]
			});
		});
		
    // REALIZAR CONTROL
		$("#<?= $lv_sec; ?> #btnctrcte").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "Realizar control", 
				message:"&iquest;Desea realizar el control?", 
				type: BootstrapDialog.TYPE_PRIMARY,
				buttons: [{ label: "Cancelar", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-success",	action: function(dialogItself){
                    	var lv_pstdat = $("#<?= $lv_sec;?>_frm").serializeArray();
                    	let lv_plndte = "<?= $lv_plndte!='' ? $lv_plndte->format('d/m/Y') : ''; ?>";
                      // Agregar el nuevo objeto al array
                      lv_pstdat.push({ name: 'hltplndte', value: lv_plndte });										
                    	tmssCallProcess("?prg=hltplnctr&act=ctrcal", lv_pstdat, function(data){
                        data = "<div><errtyp>"+data.errtyp+"</errtyp>"+"<errcod>"+data.errcod+"</errcod>"+"<errtxt>"+data.errtxt+"</errtxt></div>";
												if($(data).find("errtyp").text() == "S"){
                          toastr.success("Se realiz&oacute; el control.");
                          <?= $lv_sec; ?>_fnc({action: '99'});
                        }else{
                          toastr.warning("Error" + $(data).find("errcod").text() + ": " + $(data).find("errtxt").text());
                        }
											});
											dialogItself.close();
									}
								}]
			});
		});
    
    // NO SE REALIZA CONTROL
		$("#<?= $lv_sec; ?> #btnctrdel").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "No se realiza control", 
				message:"&iquest;Desea indicar que no se realizar&aacute; el control?", 
				type: BootstrapDialog.TYPE_PRIMARY,
				buttons: [{ label: "Cancelar", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-success",	action: function(dialogItself){
                    	var lv_pstdat = $("#<?= $lv_sec;?>_frm").serializeArray();
                    	lv_pstdat.push({"name":"cancel", "value":"X"});
                      var plndteValue = lv_pstdat.find(item => item.name === 'plndte')?.value;
                      // Agregar el nuevo objeto al array
                      lv_pstdat.push({ name: 'hltplndte', value: plndteValue || '' });			
											tmssCallProcess("?prg=hltplnctr&act=ctrcal", lv_pstdat, function(data){
                        data = "<div><errtyp>"+data.errtyp+"</errtyp>"+"<errcod>"+data.errcod+"</errcod>"+"<errtxt>"+data.errtxt+"</errtxt></div>";
												if($(data).find("errtyp").text() == "S"){
                          toastr.success("Esta planificaci&oacute;n no se controlar&aacute;.");
                          <?= $lv_sec; ?>_fnc({action: '99'});
                        }else{
                          toastr.warning("Error" + $(data).find("errcod").text() + ": " + $(data).find("errtxt").text());
                        }
											});
											dialogItself.close();
									}
								}]
			});
		});
		
		// QUITAR DE LA SERIE
		function <?= $lv_sec; ?>_removeFromSerie() {
			BootstrapDialog.confirm({
        title: "<?= $vew_lang->removefromserie; ?>",
        message: "¿Desea quitar esta planificación de la serie?",
        type: BootstrapDialog.TYPE_WARNING,
        callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "05"}); } }
			});
		}
	</script>
  <script>
    $(function(){
      <?= $lv_sec; ?>_updateFrequency($("#<?= $lv_sec; ?> #serid").val());
    });
    
    // MODIFICAR HORARIO
    $("#<?= $lv_sec; ?> #frqmod").on("click",function(e){ e.preventDefault();
      
      var lv_cfg = {};
    	var lv_frqatr = {};
      lv_cfg["frq"] = ["D", "W", "M"];
      lv_cfg["dtetyp"] = "DR";
      lv_cfg["readonly"] = !"<?= $vew_dtedat->plndteid=='' ?>"; //Si no tiene dteid es modificable, si tiene dteid no es modificable.
      

			//Transformar STRING a JSON.                                                   
      lv_frqatr["strdte"] = $("#<?= $lv_sec; ?> #plndte").val();
      lv_frqatr["enddte"] = $("#<?= $lv_sec; ?> #plndteto").val();
                                                         
      var lv_pstdat = [{name:"cfg", value: JSON.stringify(lv_cfg)},{name:"prvdat",value:JSON.stringify(lv_frqatr) }, {name:"tskfrqatr",value:JSON.stringify(lv_frqatr) } ,{name:"actcod",value:(lv_cfg['readonly'])?'03':'02'}];
			tmssCallProcess("?prg=grldattsk&act=sch",lv_pstdat,function(data){ 
				BootstrapDialog.show({ 
					title: "<?= $vew_lang->frequency; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
          closable: false,
          draggable: true,
         	buttons: [{ label: "<?= $vew_lang->close ?>", cssClass: "btn-default <?= ($vew_dtedat->plndteid==''?'hidden':''); ?>", action: function(dialog){ dialog.close(); } },
                    { label: "<?= $vew_lang->cancel ?>", cssClass: "btn-default <?= ($vew_dtedat->plndteid==''?'':'hidden'); ?>", action: function(dialog){ dialog.close(); } },
                    {	label: "<?= $vew_lang->select ?>", cssClass: "btn-info <?= ($vew_dtedat->plndteid==''?'':'hidden'); ?>",	action: function(dialog){
                      // recuperar selección
                      var lv_body = dialog.$modalBody;
                      var lv_keys = ['frqtyp', 'frqqty', 'weknum', 'wekday', 'daynum'];
                      dialog.$modalBody.find("#grldattsksve").trigger("click");
                      lv_atr=dialog.$modalBody.find("#grldattsk").val(); 
                      lv_atr= JSON.parse(lv_atr);
                      let xmlString = "";
                      for (const [key, value] of Object.entries(lv_atr)) {
                          var lv_lowerKey = key.toLowerCase();
    											if (lv_keys.includes(lv_lowerKey)) {
                          	xmlString += `<${lv_lowerKey}>${value}</${lv_lowerKey}>`;
                          }
                      }
                      if(dialog.$modalBody.find("#grltskstrdte").val() != ''){
                         $("#<?= $lv_sec; ?> #plndte").val( dialog.$modalBody.find("#grltskstrdte").val() ).change();
                      }
                      if(dialog.$modalBody.find("#grltskenddte").val() != ''){
                      	$("#<?= $lv_sec; ?> #plndteto").val( dialog.$modalBody.find("#grltskenddte").val() ).change();   
                      }
                      <?= $lv_sec; ?>_updateFrequency(xmlString);
                      dialog.close();
                    } }]
				});
			});
    });
    
    // traduce la frecuencia planificada y la muestra
    function <?= $lv_sec; ?>_updateFrequency(lp_frqatr){ 
      if(lp_frqatr!=""){
        $("#<?= $lv_sec; ?> #serid").val(lp_frqatr);
        var lv_pstdat = [{name:"frq", value:lp_frqatr}];
        tmssCallProcess("?prg=grldattsk&act=getfrqtxt", lv_pstdat, function(data){ 
          $("#<?= $lv_sec; ?> #frqtxt").text(data.frqtxt);
        });
      }
    }
  </script>
  <script>
		// server response ext
    function <?= $lv_sec; ?>_fncbckext( data ) {
      //  si viene erralt no vacío pido confirmación 
      if (typeof data === "object" ) {
        var lv_erralt = (data.erralt || "").toString().trim();
        var lv_errcod = (data.errcod != null ? String(data.errcod) : "");
        var lv_errtxt = (data.errtxt != null ? String(data.errtxt) : "");

        if (lv_erralt !== "") {
          BootstrapDialog.show({
            title: "Confirmar acción",
            message: lv_erralt,                          
            type: BootstrapDialog.TYPE_WARNING,
            closable: false,
            buttons: [
              { label: "Cancelar", cssClass: "btn btn-default", action: function (dlg) { dlg.close(); } },
              { label: "OK",       cssClass: "btn btn-success", action: function (dlg) { dlg.close();} }
            ]
          });
          return; 
        }

        if (gv_<?= $lv_sec; ?>_last_action=="04") {
        	$.each(BootstrapDialog.dialogs, function(id, dialog){
            if( dialog.getModalBody().find("#<?= $lv_sec; ?>").length>0 ){ 
              dialog.getModalBody().find("#noupdate").val("");
              dialog.close();
            }
          });
        } else {
          if( typeof data=="object" ){
            toastr.warning("Se produjo un error al grabar la planificacion.<br>"+data.errcod+": "+data.errtxt);
          } else {
            $("#<?= $lv_sec; ?>").replaceWith(data);
          }
        }
      }
    }
    
    function <?= $lv_sec; ?>_fncbckext( data ) {
			if (gv_<?= $lv_sec; ?>_last_action=="04") {
				$.each(BootstrapDialog.dialogs, function(id, dialog){
					if( dialog.getModalBody().find("#<?= $lv_sec; ?>").length>0 ){ 
            dialog.getModalBody().find("#noupdate").val("");
            dialog.close();
          }
				});
			} else {
				if( typeof data=="object" ){
					toastr.warning("Se produjo un error al grabar la planificacion.<br>"+data.errcod+": "+data.errtxt);
				} else {
          $("#<?= $lv_sec; ?>").replaceWith(data);
        }
			}
    }
    
		function <?= $lv_sec; ?>_deleteFeedback(lp_data, lp_event){
      if(lp_data['errcod'] == 0){
        toastr.success( (lp_event ? "Evento borrado." : "Serie borrada.") );
        $.each(BootstrapDialog.dialogs, function(id, dialog){
	  			if( dialog.getModalBody().find("#<?= $lv_sec; ?>").length>0 ){ dialog.close(); }
        });
      } else {
        toastr.warning("Error al borrar. <br>"+lp_data['errcod']+": "+lp_data['errtxt']);
      } 
    }
    
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // variable flag
      var error = false;
      
      //revisa si esta en una serie para preguntar si borrar toda la serie
			if(lp_prm["action"]=="04" && 1 == <?= ($lv_strdte!=$lv_enddte && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05')?1:0); ?>){
        //inputs ocultos
        var lv_inputs = "<input type='hidden' id='plnid' value='<?= $vew_dtedat->plnid;?>'><input type='hidden' id='plndteid' value='<?= $vew_dtedat->plndteid;?>'>";
        //dialogo para borrar serie
        BootstrapDialog.show({
         	title:"<?= $vew_lang->delete; ?>"
         ,message:"<?= utf8_decode('¿Desea borrar <b>toda la serie</b> o <b>este evento</b>?'); ?>"+lv_inputs
         ,type:BootstrapDialog.TYPE_WARNING
         ,size:BootstrapDialog.SIZE_MEDIUM
         ,buttons:[{ label: "<?= $vew_lang->cancel ?>", cssClass: "btn btn-danger", action: function(dialog){ dialog.close(); } }
        					,{ label: "<?= $vew_lang->deleteEvent ?>", cssClass: "btn btn-success", action: function(dialog){
                    var lv_post = [{name:"plnid",value:dialog.$modalBody.find("#plnid").val()},
                                  {name:"plndteid",value:dialog.$modalBody.find("#plndteid").val()}];
                    tmssCallProcess("?prg=hltpln&act=24",lv_post,function(data){
                      <?= $lv_sec; ?>_deleteFeedback(data,true);
                    });
                    dialog.close();  
                  } }
    							,{ label: "<?= $vew_lang->deleteSerie ?>", cssClass: "btn pull-left", action: function(dialog){
                    var lv_post = [{name:"plnid",value:dialog.$modalBody.find("#plnid").val()}
                                  ,{name:"plndteid",value:dialog.$modalBody.find("#plndteid").val()}];
                    tmssCallProcess("?prg=hltpln&act=04",lv_post,function(data){
                      <?= $lv_sec; ?>_deleteFeedback(data,false);
                    });
                    dialog.close(); 
                  } }]
         })
         return false;
      	
      }else{//flujo normal
				// validaciones simples de grabado
				// gastos. obtengo datos de handsontable
        if (lp_prm["action"]=="00" && typeof <?= $lv_sec; ?>_buyexphot != "undefined" ) {
					var lo_dat = <?= $lv_sec; ?>_buyexphot.getSourceData();
					var lv_arr = new Array();
          var lv_index = 0;
					for (var i=0; i<lo_dat.length; i++) {
						if ( lo_dat[i]["buyexpdoctot"]!="" && lo_dat[i]["buyexpdoctot"]!=undefined ) {
							lv_arr.push({	"buyexpdoccod":lo_dat[i]["buyexpdoccod"],
														"buyexptypcod":lo_dat[i]["buyexptypcod"],
														"buyexpdoctot":lo_dat[i]["buyexpdoctot"],
                           	"buyexpdoccmt":lo_dat[i]["buyexpdoccmt"],
                           	"supcod": $("#<?= $lv_sec; ?> #prscod").prop("value"),
                           	"index":lv_index
													});
						lv_index++;
            }
					}
          
					// agrego las filas eliminadas
					for (var i=0; i<<?= $lv_sec; ?>_buyexphotdel.length; i++) {
						lv_arr.push({ "buyexpcod": $("#<?= $lv_sec; ?> #buyexpcod").prop("value"),
													"buyexpdoccod": <?= $lv_sec; ?>_buyexphotdel[i]["buyexpdoccod"],
													"delete":"X"
												});
					}
					if (lv_arr.length==0) {
						$("#<?= $lv_sec; ?> #buyexpdoc").prop("value", "");
					} else {
						$("#<?= $lv_sec; ?> #buyexpdoc").prop("value", JSON.stringify( lv_arr ) );
					}
          
          // obtengo datos de handsontable de estudios
          var lv_datstd = <?= $lv_sec; ?>_spcstdhot.getSourceData();
          var lv_arrstd = new Array();
          for (var i=0; i<lv_datstd.length; i++) {if( lv_datstd[i]["spcstdcod"]!="" && lv_datstd[i]["spcstdcod"]!=undefined ) { lv_arrstd.push({"spcstdcod":lv_datstd[i]["spcstdcod"] }); }}
          
          if (lv_arrstd.length==0) {
            $("#<?= $lv_sec; ?> #plnstd").prop("value","");
          } else {
            $("#<?= $lv_sec; ?> #plnstd").prop("value", JSON.stringify( lv_arrstd ));
          }
				}
        error = ( lp_prm["action"]=="04" && "<?= $vew_dtedat->evlcod ?>"!="" ? true : false );
        if(error){
        	toastr.warning("No se pueden borrar planificaciones evolucionadas"); 
          return false;
        }
      }
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>