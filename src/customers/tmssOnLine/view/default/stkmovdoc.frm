<?php	
	// url del formulario 
  $lv_lnk = '?prg=stkmovdoc&prm_stkmovdoccod='.$vew_data->stkmovdoccod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos
	$lv_reqfld = array('stkmovdocdte', 'docsts');
	if($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')!='') { array_push( $lv_reqfld, 'srcobjtyp','srcobjcod','srcobjtxt'); }
	if($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')!='') { array_push( $lv_reqfld, 'dstobjtyp','dstobjcod','dstobjtxt'); }
	$vew_input->RequiredFields( $lv_reqfld );

	// clave del documento
	$lv_dockey = $vew_data->stkmovdoccod; 

	// titulo
	$lv_title = $vew_lang->document;
	
	// modulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;
	$lv_objtyp = strtoupper($lv_mdlcod.'_'.$lv_prgcod);

	// libreria de estilos bootstrap
	include_once('_library.frm');

	// valores x default
	if( $vew_data->stkmovdoccod=='' ){
		$vew_data->stkmovdocdte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}

	if( $vew_data->docsts=='C' ) {
		$lv_default2 = $lv_always_disabled;
		$vew_readonly2 = true;
	} else {
		$lv_default2 = $lv_default;
		$vew_readonly2 = $vew_readonly;
	}

	$lv_matbchdet = ($vew_readonly2?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matbchdet')); //Determ. lote
	$lv_matbchdetspl = ($vew_readonly2?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matbchdetspl')); //Split Lote
	$lv_stkctr = ($vew_readonly2?'':$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matstkctr')); //Control stock origen
	$lv_matbchcre = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matbchcre'); //Crea lote
	$lv_matsercre = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matsercre'); //Crea serie
	$lv_stkmatbchman = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stkmatbchman'); //Lote manual
	$lv_stkmatserman = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stkmatserman'); //Serie manual
	$lv_stkmovrelcnf = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stkmovrelcnf'); //Relevante confirmacion
	$lv_logtrarel = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'logtrarel'); //Relevante transporte
	$lv_matpckrel = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matpckrel'); //Relevante picking
	$lv_docrev = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'docrev'); //Documento anulacion
	$lv_refdoccls = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdoccls'); //Docs de referencia
	$lv_refdocmdt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdocmdt'); //Referencia obligatoria
	$lv_matcodfndseq =  $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matcodfndseq'); //Sec.Busqueda Codigo
	$lv_objcod = $vew_data->stkmovdoccod;
	$lv_docref = false;	// documento referencia a otro documento
	$lv_docrefsrc = false; // documento es referenciado por otro documento
	foreach($vew_data->stkmovdocmat as $lv_row){ 
		if( ($lv_row['docreftyp']??'')!='' ){ $lv_docref=true; }
		if( ($lv_row['refposqty']??'')!='' ){ $lv_docrefsrc=true; }
	}
	
	// armo array de motivos de rechazo
	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}
	
	// armo array de motivos de pedido
	$lv_rsnarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrsn as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrsnatr'],'rsnman'))=='X'){
			$lv_rsnarr[ $lv_row['sysdocrsncod'] ] = $lv_row['sysdocrsntxt'];
		}
	}

	// Botones por vista
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['del'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea class="hidden" id="stkmovdocmat" name="stkmovdocmat"></textarea>
    <input type="hidden" id="tmpmatbchcod" 		name="tmpmatbchcod" 		data-fldnme="matbchcod" 		value="">
    <input type="hidden" id="tmpmatbchcodext" name="tmpmatbchcodext" 	data-fldnme="matbchcodext" 	value="">
		<input type="hidden" id="tmpmatbchduedte" name="tmpmatbchduedte" 	data-fldnme="matbchduedte" 	value="">
    <input type="hidden" id="tmpmatsercod" 		name="tmpmatsercod" 		data-fldnme="matsercod" 		value="">
    <input type="hidden" id="tmpmatsercodext" name="tmpmatsercodext" 	data-fldnme="matsercodext" 	value="">
		<input type="hidden" id="tmpmatserduedte" name="tmpmatserduedte" 	data-fldnme="matserduedte" 	value="">
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmovdoccod; ?><?= gethtml('stkmovdoccod','hidden',$vew_data->stkmovdoccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= ($lv_prgcod=='sin'?$vew_lang->inbound:($lv_prgcod=='sou'?$vew_lang->outbound:($lv_prgcod=='siv'?$vew_lang->inventory:$lv_prgcod))); ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
              	</div>
                <div class="card-body tmss-card-body-edit">
                  <div class="form-group tmss-form-group">
                  	<label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->source; ?></label>
                    <div class="col-sm-10">
                      <?php
                        // -- ORIGEN --
                        $lv_ttl='';
                        switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) ) {
                          case 'HHR_EMP': $lv_ttl = $vew_lang->employee; break;
                          case 'SLS_CUS': $lv_ttl = $vew_lang->customer; break;
                          case 'BUY_SUP': $lv_ttl = $vew_lang->supplier; break; 
                          case 'HLT_PAT': $lv_ttl = $vew_lang->patient; break;
                          case 'STK_STL': $lv_ttl = $vew_lang->storelocation; break;
                          case 'CNS_STE': $lv_ttl = $vew_lang->constructionsites; break;
                        }
                        if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')!='' ) {
                          echo vew_boot($lv_col210,	array('label'=>$lv_ttl, 
                                                          'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($lv_docref  && $vew_data->srcobjcod!=''?true:$vew_readonly2)), 
                                                                              array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt, ($vew_data->docsts!='C'?($lv_docref && $vew_data->srcobjcod!=''?$lv_always_disabled:$lv_default):$lv_always_disabled) ) ))
                                                           ));
                          echo gethtml('srcobjtyp','hidden',strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) );
                        }
                        echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod);
                        switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) ) {
                          case 'SLS_CUS': case 'BUY_SUP': case 'HLT_PAT': case 'CNS_STE':
                            echo vew_boot($lv_col210, array('label'=>$vew_lang->contact,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($lv_docref  && $vew_data->srcobjcod!=''?true:$vew_readonly2) ),
                                                                        array('input'=>gethtml('srccnttxt', 'typeahead', $vew_data->srccnttxt,($vew_data->docsts!='C'?($lv_docref && $vew_data->srcobjcod!=''?$lv_always_disabled:$lv_default):$lv_always_disabled) ) ))
                                                  ));
                            break;
                        }
                        echo gethtml('srccntcod','hidden',$vew_data->srccntcod);
                      ?>
                    </div>
                  </div>                    
                	<div class="form-group tmss-form-group">
                    <label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->destination; ?></label>
                    <div class="col-sm-10">
                      <?php
                        // -- DESTINO --
                        $lv_ttl='';
                        switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')) ) {
                          case 'HHR_EMP': $lv_ttl = $vew_lang->employee; break;
                          case 'SLS_CUS': $lv_ttl = $vew_lang->customer; break;
                          case 'BUY_SUP': $lv_ttl = $vew_lang->supplier; break; 
                          case 'HLT_PAT': $lv_ttl = $vew_lang->patient; break;
                          case 'STK_STL': $lv_ttl = $vew_lang->storelocation; break;
                          case 'CNS_STE': $lv_ttl = $vew_lang->constructionsites; break;
                        }
                        if ( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')!='' ) {
                          $lv_btngrp ='<span class="input-group-btn">'.
                                        ($vew_readonly2?'':'<a href="#" class="btn btn-default tmssInputBtn">&nbsp;<span class="fas fa-search"></span></a>').
                                        '<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">&nbsp;<span class="caret"></span> <span class="sr-only">Toggle Dropdown</span> </button> '.
                                        '<ul class="dropdown-menu dropdown-menu-right"> '.
                                          '<li><a href="#" id="dstinflnk">'.$vew_lang->address.'</a></li>'.
                                          '<li><a href="#" id="dstroulnk">'.$vew_lang->route.'</a></li>'.
                                        '</ul>'.
                                      '</span>';
                          echo vew_boot($lv_col210,	array('label'=>$lv_ttl,
                                                          'input'=>vew_boot(	array('style'=>'custom', 'readonly'=>$vew_readonly2),
                                                                              array('custom'=>$lv_btngrp, 'input'=>gethtml('dstobjtxt', 'typeahead', $vew_data->dstobjtxt, $lv_default2) )),
                                                        ));
                          echo gethtml('dstobjtyp','hidden',strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')) );
                          echo gethtml('dstobjcod','hidden',$vew_data->dstobjcod);
                          echo gethtml('dstcntcod','hidden',$vew_data->dstcntcod);
                        }
                        switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')) ) {
                          case 'SLS_CUS': case 'BUY_SUP': case 'HLT_PAT': case 'CNS_STE':
                            $lv_btngrp ='<span class="input-group-btn">'.
                                          ($vew_readonly2?'':'<a href="#" class="btn btn-default tmssInputBtn">&nbsp;<span class="fas fa-search"></span></a>').
                                          '<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">&nbsp;<span class="caret"></span> <span class="sr-only">Toggle Dropdown</span> </button> '.
                                          '<ul class="dropdown-menu dropdown-menu-right"> '.
                                            '<li><a href="#" id="dstcntinflnk">'.$vew_lang->address.'</a></li>'.
                                            '<li><a href="#" id="dstcntroulnk">'.$vew_lang->route.'</a></li>'.
                                          '</ul>'.
                                        '</span>';
                            echo vew_boot($lv_col210, array('label'=>$vew_lang->contact,
                                                    'input1'=>vew_boot(	array('style'=>'custom', 'readonly'=>$vew_readonly2),
                                                                        array('custom'=>$lv_btngrp, 'input'=>gethtml('dstcnttxt', 'typeahead', $vew_data->dstcnttxt, $lv_default2) ))
                                                  ));
                            break;
                        }
                      ?>
                    </div>
                  </div>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->comments, 'input'=>gethtml('stkmovdoccmt', 'doccmt1x50',$vew_data->stkmovdoccmt, $lv_default) )); ?>
                </div>
              </div>
              
						</div>
            <div class="col-md-6">
              
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= ($vew_data->sysdoctrecod=='N'?'<span><i class="far fa-circle"></i> '.ucfirst($vew_data->sysdoctretxt).'</span>':''); ?>
                    <?= ($vew_data->sysdoctrecod=='P'?'<span class="text-warning"><i class="far fa-circle-half-stroke"></i> '.ucfirst($vew_data->sysdoctretxt).'</span>':''); ?>
                    <?= ($vew_data->sysdoctrecod=='C'?'<span class="text-success"><i class="fas fa-circle"></i> '.ucfirst($vew_data->sysdoctretxt).'</span>':''); ?>
                    <?= ($vew_data->sysdoctrecod==''?'&nbsp;':''); ?>
                	</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('stkmovdocdte', 'docdte', $vew_data->stkmovdocdte, $lv_default2) )); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->number, 'input'=>gethtml('stkmovdoccodext', ($vew_data->sysdoccls->docrngcodint!=0 || $vew_data->sysdoccls->docrngcodext!=0?'docrngnum':'doccmt1x20'),$vew_data->stkmovdoccodext,($vew_data->docsts!='C'?($vew_data->sysdoccls->docrngcodint!=0?$lv_always_disabled:$lv_default):$lv_always_disabled) ) )); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->withdraw, 'input'=>gethtml('stkmovdocatrpic', 'doccmt1x20',$vew_doc->getTagValue($vew_data->stkmovdocatr,'pic'),$lv_default2) )); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_readonly?'docstsacc':'docsts'), $vew_data->docsts, $lv_default2) )); ?>
                </div>
              </div>
              
						</div>
					</div>
          
          <div class="card tmss-hot-ttl">
            <div class="card-header">
            	<div class="card-title">
                <span> <?= $vew_lang->Materials; ?> </span>
              	<?php if(!$vew_readonly2 ) { ?>
                  <a href="#" id="<?= $lv_sec; ?>_btnDeleteSelected" class="card-icon text-center tmssHiddeOnRead d-none" title="Eliminar seleccionados"  onmousedown="<?= $lv_sec; ?>_deleteSelectedRows(); return false;">
                    <i class="fas fa-trash"></i>
                  </a>
               	<?php } ?>
                <?php if ($lv_stkctr!='') { ?><a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnstkchk" title="<?= $vew_lang->availabilitycheck; ?>"><i class="fas fa-sliders-h"></i></a><?php } ?>
                <?php if ($lv_matbchdet!='') { ?><a href="#" id="btnmatbchdet" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->batchdetermination; ?>"><i class="fas fa-ball-pile"></i></a><?php } ?>
                <?php if ($vew_data->docsts!='C' && $lv_refdoccls!='') { ?><a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a><?php } ?>
              </div>
            </div>
          </div>
					<div id="stkmovdocmathot" name="stkmovdocmathot"></div>
          
				</div> <!-- /_tab001 -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->locked, 'input'=>gethtml('stkmovdoclck', 'checkbox', $vew_data->stkmovdoclck, $lv_default2) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection,	'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default2) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->orderreason,'input'=>gethtml('stkmovrsncod', $lv_rsnarr, $vew_data->stkmovrsncod, $lv_default2) ));
                  ?>
                </div>
              </div>
              
						</div>
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->transport; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									<?php echo vew_boot($lv_col210, array('label'=>$vew_lang->deliverypriority, 'input'=>gethtml('stkmovprtcod', 'stkmovprt', $vew_data->stkmovprtcod, $lv_default)) ); ?>
                  <?php 
                    if ( $lv_logtrarel!='' ){
                      if ( $vew_readonly ) {
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->route, 'input'=>gethtml('traroutxt', 'doccmt1x50', $vew_data->traroutxt, $lv_always_disabled)) ); 
                      } else {
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->route, 
                                                        'input'=>vew_boot(array('style'=>'custom'),
                                                                          array('custom'=>'<span class="input-group-btn">'.
                                                                                            '<a href="#" class="btn btn-default tmssInputBtn" id="btntraroupop">&nbsp;<span class="fas fa-search"></span></a>'.
                                                                                            '<a href="#" class="btn btn-default" onclick="'.$lv_sec.'_routeRefresh();">&nbsp;<span class="fas fa-sync"></span></a>'.
                                                                                          '</span>',
                                                                                 'input'=>gethtml('traroutxt', 'doccmt1x50', $vew_data->traroutxt, $lv_default)) ) )); 
                      }
                      echo gethtml('traroucod','hidden',$vew_data->traroucod);
                    }
                  ?>
                </div>
              </div>
              
							<!-- CONFIRMACION -->
							<?php if($vew_data->docsts=='C' && $lv_stkmovrelcnf!=''){ ?>
                <div class="card">
                  <div class="card-header"><div class="card-title"><?= $vew_lang->confirmation; ?></div></div>
                  <div class="card-body tmss-card-body-edit">
                    <?= vew_boot($lv_col210, array('label'=>$vew_lang->confirmation, 'input'=>gethtml('stkmovdoccnftyp',array(''=>'','SI'=>'ENTREGADO','NO'=>'NO ENTREGADO'), $vew_doc->getTagValue($vew_data->stkmovdoccnf,'cnftyp'), $lv_default) )); ?>
                    <?= vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('stkmovdoccnfdte', 'docdte', $vew_doc->getTagValue($vew_data->stkmovdoccnf,'cnfdte'),	$lv_default) )); ?>
                    <?= vew_boot($lv_col210, array('label'=>$vew_lang->comments,	'input'=>gethtml('stkmovdoccnfcmt',	'doccmt1x50',$vew_doc->getTagValue($vew_data->stkmovdoccnf,'cnfcmt'),$lv_default) )); ?>
                  </div>
                </div>
              <?php } ?>
						</div>
					</div>
				</div> <!-- /_tab003 -->

			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->
  </form>
  <script>
    function <?= $lv_sec; ?>_deleteSelectedRows() {
      var hot = <?= $lv_sec; ?>_hotmat;
      var data = hot.getSourceData();
      var lv_tmpdel = [];
      var lv_hotsel = hot.getSelected();
      lv_hotsel.forEach(([startRow, startCol, endRow, endCol]) => {
          for (var i = endRow; i >= startRow; i--) {
            if ("matcod" in data[i]) {
              if("__children" in data[i]){
                <?= $lv_sec; ?>_hotmat.alter("remove_row", i);
              }else{
                var lv_prop =((<?=$lv_matpckrel!=''?'true':'false'?>)?"matqtypck":"matqty")
                var lv_propunt = ((<?=$lv_matpckrel!=''?'true':'false'?>)?"matuntcodpck":"matuntcod")

                var lv_matqty = <?=$lv_sec?>_hotmat.getDataAtRowProp(i,lv_prop);
                var lv_untcod = <?=$lv_sec?>_hotmat.getDataAtRowProp(i,lv_propunt);
                var lv_matcod = <?=$lv_sec?>_hotmat.getDataAtRowProp(i,"matcod");

                var lv_prnt = <?=$lv_sec;?>_getParentRow(i);
                var lv_prntqty = <?=$lv_sec;?>_hotmat.getDataAtRowProp(lv_prnt,lv_prop);
                var lv_prntuntcod = <?=$lv_sec;?>_hotmat.getDataAtRowProp(lv_prnt,lv_propunt);

                var lv_idtval = lv_matqty;
                if(lv_untcod != lv_prntuntcod){
                  var lv_pstdat = [{name: "matcod", value: lv_matcod}];
                  tmssCallProcessNoBackdrop("?prg=stkmatidt&act=19", lv_pstdat, function(data) {
                      for (var i = 0; i < data.length; i++) {
                          var lv_row = data[i];
                          if(lv_untcod == lv_row["matidtuntcod"]) {
                              var lv_conval = lv_matqty / lv_row["matidtqty"];
                              lv_idtval = lv_conval * lv_row["matbseqty"];                          
                              <?=$lv_sec?>_hotmat.setDataAtRowProp(lv_prnt,lv_prop,lv_prntqty-lv_idtval,"remove");
                          }
                      }
                      <?= $lv_sec; ?>_hotmat.alter("remove_row", i);
                  });
                }else{
                    <?=$lv_sec?>_hotmat.setDataAtRowProp(lv_prnt,lv_prop,lv_prntqty-lv_idtval,"remove");
                    <?= $lv_sec; ?>_hotmat.alter("remove_row", i);
                }
              }
            }
          }
      });
      <?= $lv_sec; ?>_hotmat.render();
    }
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_fnc({action: '99'}); }
  </script>
	<script>
    // AUDITORIA. datos adicionales para pantalla de auditoria
    <?php if( $vew_data->accusr!='' ){
			echo 'var lv_'.$lv_sec.'_infusrdat=[{"infttl":"'.$vew_lang->accountedby.'","infdat":"'.$vew_data->accusr.'"},{"infttl":"'.$vew_lang->accounteddate.'","infdat":"'.(gettype($vew_data->accdte) == 'object' ? ($vew_data->accdte)->format('d-m-Y h:i:s') : $vew_data->accdte).'"}];';
    } ?>    
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
				BootstrapDialog.confirm({
				title: "Contabilizar", 
				message:"Desea contabilizar el documento ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){	if(result){	 <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		});
		
		// BUSCAR LOTE
		function <?= $lv_sec; ?>_findBatch( lv_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"matcod");
			if ( lv_matcod=="" || lv_matcod==undefined ) {
				toastr.warning("Debe seleccionar un material.");
			} else if ( $("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjcod':'srcobjcod'); ?>").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
				$("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjtxt':'srcobjtxt'); ?>").focus();
			} else {
				$("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext, #<?= $lv_sec; ?> #tmpmatbchduedte").data("row",lv_row);
        tmssPopup("Buscar Lote","?prg=stkmatbch&prm_vewcod=VEW_STK_MAT_BCH&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatbchcod:matbchcod],[tmpmatbchcodext:matbchcodext],[tmpmatbchduedte:matbchduedtecnv]&prm_fldflt=[b.matcod:"+lv_matcod+"]");
      }
		}
		$("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext, #<?= $lv_sec; ?> #tmpmatbchduedte").on("change",function(e) { 
			<?= $lv_sec; ?>_hotmat.setDataAtRowProp( $(this).data("row"), $(this).data("fldnme"), $(this).prop("value") );
		});
    
    // BUSCAR NRO DE SERIE
		function <?= $lv_sec; ?>_findSerial( lv_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"matcod");
			if ( lv_matcod=="" || lv_matcod==undefined ) {
				toastr.warning("Debe seleccionar un material.");
			} else if ( $("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjcod':'srcobjcod'); ?>").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
				$("#<?= $lv_sec; ?> #<?= ($vew_data->sysdoccls->objtyp=='STK_SIV'?'dstobjtxt':'srcobjtxt'); ?>").focus();
			} else {
				$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext, #<?= $lv_sec; ?> #tmpmatserduedte").data("row",lv_row);
				var lv_srcobjtyp =  $("#<?= $lv_sec; ?> #srcobjtyp").val();
        var lv_srcobjcod = ($("#<?= $lv_sec; ?> #srcobjcod").val()=="" || $("#<?= $lv_sec; ?> #srcobjcod").val() == "0" ? "" : $("#<?= $lv_sec; ?> #srcobjcod").val());
        var lv_srccntcod = ($("#<?= $lv_sec; ?> #srccntcod").val()=="" || $("#<?= $lv_sec; ?> #srccntcod").val() == "0" ? "" : $("#<?= $lv_sec; ?> #srccntcod").val());
				tmssPopup("Buscar n&uacute;mero de serie","?prg=stkmatser&prm_vewcod=VEW_STK_MAT_SER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatsercod:matsercod],[tmpmatsercodext:matsercodext]&prm_fldflt=[s.matcod:"+lv_matcod+"],[s.docsts:A],[stkobjtyp:"+lv_srcobjtyp+"],[stkobjcod:"+lv_srcobjcod+"],[stkcntcod:"+lv_srccntcod+"]");
			}
		}
		$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext, #<?= $lv_sec; ?> #tmpmatserduedte").on("change",function(e) { 
			<?= $lv_sec; ?>_hotmat.setDataAtRowProp( $(this).data("row"), $(this).data("fldnme"), $(this).prop("value") );
		});
    
		//VALIDAR CAMPO CANTIDAD DE MATERIALES
    function <?= $lv_sec; ?>_validateMatqty( lo_dat ){
    	var lv_errmatqty=false;
      for(var i=0; i<lo_dat.length;i++){
        if(lo_dat[i].matqty==""){
          lv_errmatqty=true;
        }
      }
      return lv_errmatqty
    }
    
		// DETERMINAR LOTE
		$("#<?= $lv_sec; ?> #btnmatbchdet").on("click",function(e){ e.preventDefault();
			var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
			if ( $("#<?= $lv_sec; ?> #srcobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
			} else if ( lo_dat.length<=0 ) {
				toastr.warning("Debe ingrear al menos un material a determinar.");
			} else if(<?= $lv_sec; ?>_validateMatqty(lo_dat)){
        toastr.warning("Debe ingrear cantidad de material.");  
      } else{
    	// Recupero la cabecera de la handson
        for(var i = lo_dat.length-1; i >=0; i--){ 
          if ( !("matcod" in lo_dat[i]) || !("__children" in lo_dat[i])) {
             if (lo_dat[i]["stkmovdocmatcod"] && lo_dat[i]["stkmovdocmatcod"] !== undefined) {
                lo_dat[i]["deleted"] = "X";
                <?= $lv_sec; ?>_hotmatdel.push(lo_dat[i]);
              }
             lo_dat.splice(i, 1);
          }
        } 
        BootstrapDialog.confirm({
          title: "Determinar Lote", 
          message:"Desea realizar la determinaci&oacute;n de lotes?",
          type: BootstrapDialog.TYPE_PRIMARY,
          callback: function(result){
            if(result){
              var lo_datpst = [];
              lo_datpst.push( {name:"stkmovdocmat", value: JSON.stringify( lo_dat )} );
              lo_datpst.push( {name:"srcobjtyp", value: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value")} );
              lo_datpst.push( {name:"srcobjcod", value: $("#<?= $lv_sec; ?> #srcobjcod").prop("value")} );
              lo_datpst.push( {name:"srccntcod", value: $("#<?= $lv_sec; ?> #srccntcod").prop("value")} );
              lo_datpst.push( {name:"matbchdet", value: "<?= $lv_matbchdet; ?>"} );
              lo_datpst.push( {name:"matbchdetspl", value: "<?= $lv_matbchdetspl; ?>"} );
              tmssCallProcess("?prg=stkmatstk&act=25", lo_datpst, function(data){
                var lv_matbchdetspl = ("<?= $lv_matbchdetspl; ?>" !== "");
                var lv_matcod = 0;
                var lv_dat = [];
                // Primer paso: agrupar resultados por matcod
                var lv_groups = {};
                for(var i = 0; i < data.length; i++){
                  var lv_row = data[i];
                  if(!lv_groups[lv_row.matcod]){
                    lv_groups[lv_row.matcod] = [];
                  }
                  lv_groups[lv_row.matcod].push(lv_row);
                }
                // Segundo paso: armar estructura según cantidad de lotes y flag matbchdetspl
                for(var i = 0; i < lo_dat.length; i++){
                  var lv_orig_row = lo_dat[i];
                  var lv_key = lv_orig_row.matcod;
                  var lv_rows = lv_groups[lv_key];
                  if(!lv_rows || lv_rows.length === 0) {
                    lv_dat.push(lv_orig_row);
                    continue;
                  }
                  var lv_needsSplit = lv_matbchdetspl && lv_rows.length > 1;
                  
                  if(lv_needsSplit){
                    if(<?=$lv_matpckrel!=''?'true':'false'?>){
                        // CON PICKING: estructura padre + hijos
                        var lv_parent_qty  = parseFloat(lv_orig_row.matqty || 0);
                        var lv_parent_qtypck = 0;
                        for(var j = 0; j < lv_rows.length; j++){
                            lv_parent_qtypck += parseFloat(lv_rows[j].matqty || 0);
                        }

                        var lv_parent = {
                            ...lv_orig_row,
                            uidxt: "uid_" + Math.random().toString(36).substr(2, 9),
                            matqty: lv_parent_qty,
                            matqtypck: lv_parent_qtypck,
                            matbchcodext: "",
                            matbchcod: "",
                            matbchduedte: "",
                            matsercodext: "",
                            matsercod: "",
                            is_header_node: true,
                            __children: []
                        };

                        for(var j = 0; j < lv_rows.length; j++){
                            var lv_child     = lv_rows[j];
                            var lv_child_qty = parseFloat(lv_child.matqty || 0);

                            var lv_child_obj = {
                                ...lv_orig_row,
                                uidxt: "uid_" + Math.random().toString(36).substr(2, 9),
                                matqty:       lv_child_qty,
                                matqtypck:    lv_child_qty,
                                matqtyhide:   parseFloat(lv_orig_row.matqty || 0),
                                matbchcodext: lv_child.matbchcodext,
                                matbchcod:    lv_child.matbchcod,
                                matbchduedte: lv_child.matbchduedte,
                                matsercodext: lv_child.matsercodext,
                                matsercod:    lv_child.matsercod,
                                matusebch:    lv_child.matusebch,
                                matuseser:    lv_child.matuseser,
                                matqtydif:    lv_child.matqtydif,
                                matqtystk:    lv_child.matqtystk,
                                matbchdeterrcod: lv_child.matbchdeterrcod,
                                matbchdeterrtxt: lv_child.matbchdeterrtxt,
                                is_header_node: false
                            };
                            delete lv_child_obj.__children;
                            lv_parent["__children"].push(lv_child_obj);
                        }
                        lv_dat.push(lv_parent);

                    } else {
                        // SIN PICKING: cada lote es una fila raíz independiente, sin cabecera
                        for(var j = 0; j < lv_rows.length; j++){
                            var lv_row_j     = lv_rows[j];
                            var lv_row_qty   = parseFloat(lv_row_j.matqty || 0);

                            lv_dat.push({
                                ...lv_orig_row,
                                uidxt: "uid_" + Math.random().toString(36).substr(2, 9),
                                is_header_node: false,
                                matqty:       lv_row_qty,
                                matqtypck:    0,
                                matqtyhide:   "",
                                matbchcodext: lv_row_j.matbchcodext,
                                matbchcod:    lv_row_j.matbchcod,
                                matbchduedte: lv_row_j.matbchduedte,
                                matsercodext: lv_row_j.matsercodext,
                                matsercod:    lv_row_j.matsercod,
                                matusebch:    lv_row_j.matusebch,
                                matuseser:    lv_row_j.matuseser,
                                matqtydif:    lv_row_j.matqtydif,
                                matqtystk:    lv_row_j.matqtystk,
                                matbchdeterrcod: lv_row_j.matbchdeterrcod,
                                matbchdeterrtxt: lv_row_j.matbchdeterrtxt,
                                __children: []
                            });
                        }
                    }
                  } else {
                    // Sin split: fila plana única (como si fuera hecho a mano)
                    var lv_single = lv_rows[0];
                    var lv_single_qty = parseFloat(lv_single.matqty || 0);
                    
                    var lv_single_obj = {
                      ...lv_orig_row,
                      uidxt: "uid_" + Math.random().toString(36).substr(2, 9),
                      matqty: lv_single_qty,
                      matqtypck: (<?=$lv_matpckrel!=''?'true':'false'?>) ? lv_single_qty : 0,
                      matbchcodext: lv_single.matbchcodext,
                      matbchcod: lv_single.matbchcod,
                      matbchduedte: lv_single.matbchduedte,
                      matsercodext: lv_single.matsercodext,
                      matsercod: lv_single.matsercod,
                      matusebch: lv_single.matusebch,
                      matuseser: lv_single.matuseser,
                      matqtydif: lv_single.matqtydif,
                      matqtystk: lv_single.matqtystk,
                      matbchdeterrcod: lv_single.matbchdeterrcod,
                      matbchdeterrtxt: lv_single.matbchdeterrtxt,
                      __children: []
                    };
                    
                    lv_dat.push(lv_single_obj);
                  }
                }
                <?= $lv_sec; ?>_hotmat.loadData( lv_dat );
                if(<?=$lv_refdocmdt != '' ?'false':'true'?>){<?=$lv_sec;?>_addBlankRow();  }
                <?= $lv_sec; ?>_hotmat.render();
                toastr.info("Se realiz&oacute; la determinaci&oacute;n de lotes.");
              });
            }
          }
        });
			}
		});
		
    
    // VERIFICACION DISPONIBILIDAD
    $("#<?= $lv_sec; ?> #btnstkchk").on("click",function(e){ e.preventDefault();
			var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
    	  if(<?=$vew_readonly || $lv_refdocmdt != '' ?'false':'true'?>){lo_dat.splice(lo_dat.length-1,1)}
			if ( $("#<?= $lv_sec; ?> #srcobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
			} else if ( lo_dat.length<=0 ) {
				toastr.warning("Debe ingrear al menos un material a determinar.");
			}else if(<?= $lv_sec; ?>_validateMatqty(lo_dat)){
        toastr.warning("Debe ingrear cantidad de material.");  
      } else {
        BootstrapDialog.confirm({
            title: "<?= $vew_lang->availabilitycheck; ?>", 
            message:"Desea realizar la verificaci&oacute;n de disponiblidad ?",
            type: BootstrapDialog.TYPE_PRIMARY,
            callback: function(result){
              if(result){	
                  var lo_datpst = [];

                  // getSourceData() con nestedRows devuelve TODAS las filas aplanadas.
                  // Necesitamos solo las filas raíz (las que tienen __children definido)
                  var lo_src = <?= $lv_sec; ?>_hotmat.getSourceData();
                  var lv_rootNodes = lo_src.filter(function(row){ return row.__children !== undefined; });
                  var lv_flat = [];

                  for(var i = 0; i < lv_rootNodes.length; i++){
                      var node = lv_rootNodes[i];
                      if(!node.matcod) continue; // saltar fila en blanco
                      if(node.__children && node.__children.length > 0){
                          // padre con hijos: enviar solo los hijos
                          for(var j = 0; j < node.__children.length; j++){
                              if(node.__children[j].matcod){
                                  lv_flat.push(node.__children[j]);
                              }
                          }
                      } else {
                          // fila simple sin hijos: enviar el nodo directamente
                          lv_flat.push(node);
                      }
                  }

                  lo_datpst.push( {name:"srcobjtyp", value: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value")} );
                  lo_datpst.push( {name:"srcobjcod", value: $("#<?= $lv_sec; ?> #srcobjcod").prop("value")} );
                  lo_datpst.push( {name:"srccntcod", value: $("#<?= $lv_sec; ?> #srccntcod").prop("value")} );
                  lo_datpst.push( {name:"stkmovdocmat", value: JSON.stringify( lv_flat )} );
                  lo_datpst.push( {name:"stkmovdoccod", value: $("#<?= $lv_sec; ?> #stkmovdoccod").prop("value")} );   
                  lo_datpst.push( {name:"sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")} );

                  tmssCallProcess("?prg=stkmovdoc&act=availabilityCheck", lo_datpst, function(data){
                      var lv_tbl_chk = $("<div>"+data+"</div>").find("#stktbl tbody tr").length > 0;
                      if(lv_tbl_chk){
                          BootstrapDialog.show({
                              title: "<?= $vew_lang->availabilitycheck; ?>", 
                              message: $( data ),
                              size: BootstrapDialog.SIZE_WIDE,
                              type: BootstrapDialog.TYPE_PRIMARY,
                              draggable: true,
                              closable: true
                          });
                      } else {
                          toastr.success("Todas las posiciones con stock verificado.");   
                      }
                  });
              }
          }
          });
				}      
    });
    
    
		// AGREGAR REFERENCIA
		$("#<?= $lv_sec; ?> #btndocref").on("click",function(e){ e.preventDefault();
			var lv_fndobjtyp="";
			var lv_fndobjcod="";
			var lv_fndobjtxt="";
			var lv_fndcntcod="";
			var lv_fndcnttxt="";
			<?php if (($vew_data->sysdoccls->objtyp=='STK_SIN' && $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'fnddstref')!='X')|| ($vew_data->sysdoccls->objtyp=='STK_SOU' && $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'fndsrcref')=='X')) { ?>
      if ( $("#<?= $lv_sec; ?> #srcobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
				$("#<?= $lv_sec; ?> #srcobjtxt").focus();
				return;
			} else {
				lv_fndobjtyp = $("#<?= $lv_sec; ?> #srcobjtyp").prop("value");
				lv_fndobjcod = $("#<?= $lv_sec; ?> #srcobjcod").prop("value");
				lv_fndobjtxt = $("#<?= $lv_sec; ?> #srcobjtxt").prop("value");
				lv_fndcntcod = $("#<?= $lv_sec; ?> #srccntcod").prop("value");
				lv_fndcnttxt = $("#<?= $lv_sec; ?> #srccnttxt").prop("value");
			}
			<?php } else if(($vew_data->sysdoccls->objtyp=='STK_SIN' && $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'fnddstref')=='X') || ($vew_data->sysdoccls->objtyp=='STK_SOU' && $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'fndsrcref')!='X')) { ?>
			if ( $("#<?= $lv_sec; ?> #dstobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el destino.");
				$("#<?= $lv_sec; ?> #dstobjtxt").focus();
				return;
			} else {
				lv_fndobjtyp = $("#<?= $lv_sec; ?> #dstobjtyp").prop("value");
				lv_fndobjcod = $("#<?= $lv_sec; ?> #dstobjcod").prop("value");
				lv_fndobjtxt = $("#<?= $lv_sec; ?> #dstobjtxt").prop("value");
				lv_fndcntcod = $("#<?= $lv_sec; ?> #dstcntcod").prop("value");
				lv_fndcnttxt = $("#<?= $lv_sec; ?> #dstcnttxt").prop("value");
			}
			<?php } ?>
			
			// obtengo los IDs de los documentos referenciados previamente y que no hayan sido grabados
			var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
			var lv_refarr = new Array();
			for (var i=0; i<lo_dat.length; i++) {
				if ( (lo_dat[i]["stkmovdocmatcod"]==undefined?"":lo_dat[i]["stkmovdocmatcod"])=="" && (lo_dat[i]["docreftyp"]==undefined?"":lo_dat[i]["docreftyp"])!="" ) {
					lv_refarr.push({"srcobjtyp":lo_dat[i]["docreftyp"], "srcobjcod":lo_dat[i]["docrefcod"], "srcposcod":lo_dat[i]["docrefposcod"], "refposqty":lo_dat[i]["matqty"]} );
				}
			}
			
			// cargo la pantalla de referencia
			tmssCallProcess("?prg=grldocflw&act=01",{sysdocclscod: "<?= $vew_data->sysdoccls->sysdocclscod; ?>",
																							refobjtyp: "<?= $vew_data->sysdoccls->objtyp; ?>",	refobjcod: "<?= $vew_data->stkmovdoccod; ?>",
																							fndobjtyp: lv_fndobjtyp, fndobjcod: lv_fndobjcod, fndobjtxt: lv_fndobjtxt, fndcntcod: lv_fndcntcod, fndcnttxt: lv_fndcnttxt,
																							refarr: JSON.stringify(lv_refarr)
																						}, function(data){
					BootstrapDialog.show({
						size: BootstrapDialog.SIZE_WIDE,
						title: "Agregar Referencia - <?= $vew_data->sysdoccls->sysdocclstxt; ?> ("+lv_fndobjtxt+(lv_fndcnttxt=="" || lv_fndcnttxt==undefined ?"":" / "+lv_fndcnttxt)+") ",
						message: $(data),
						buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "Agregar", cssClass: "btn-success",	action: function(dialogItself){
                        if ( dialogItself.getModalBody().find("#rowchk:checked").length==0 ) {
                          toastr.warning("Debe indicar al menos una posción de referencia.");
												} else if ( dialogItself.getModalBody().find("form")[0].checkValidity()==false ) {
													toastr.warning("Las cantidades a referenciar no pueden ser cero ni exceder el saldo a referenciar.");
													dialogItself.getModalBody().find("input").each( function(e) {
														if ( !$(this)[0].validity.valid ) { $(this).parent().addClass("has-error"); }
													});
												} else {    
                          var lv_row;
                          var lo_hotdata = <?= $lv_sec; ?>_hotmat.getSourceData().filter(function(row) { return row.blank !== "X"; });
                          dialogItself.getModalBody().find("#rowchk:checked").each(function(e){
														lv_row = <?= $lv_sec; ?>_hotmat.countRows();
														var lv_doccod = $(this).data("doccod");
														var lv_poscod = $(this).data("docposcod");
														var lv_qty = dialogItself.getModalBody().find("#"+lv_doccod+ "_"+lv_poscod+"_qty").prop("value");
														var lv_data = dialogItself.getModalBody().find("#"+lv_doccod+ "_"+lv_poscod+"_data").text();
														var lo_dat = JSON.parse( lv_data );
														<?= $lv_sec; ?>_hot_paste = true;
                            
                            var lv_is_picking = ("<?=$lv_matpckrel;?>" !== "");
                            if (lv_is_picking && !lo_dat.doccod) {
                              var lv_index = lo_hotdata.findIndex(x => x.matcod === lo_dat.matcod && (x.docrefcod || 0) === (lo_dat.doccod || 0));
                              if(lv_index==-1){
                                // HADNSONTABLE PADRE. Si no existe creo fila padre del Material (Unificada)
                                lo_hotdata.push({...lo_dat, uidxt: "uid_" + Math.random().toString(36).substr(2, 9), docreftyp:lo_dat.doctyp, docrefcod:lo_dat.doccod, docrefposcod:lo_dat.docposcod, 
                                                 matqty: parseFloat(lv_qty), matqtyhide: parseFloat(lv_qty), matqtypck: lo_dat.matqtypck ?? 0, matuntcodpck:lo_dat.matuntcod, matusebch:lo_dat.matusebch, 
                                                 matuseser:lo_dat.matuseser, matbchcodext:lo_dat.matbchcodext, matbchcod:lo_dat.matbchcod, 
                                                 matbchduedte: (lo_dat.matbchduedte?.date)?moment(lo_dat.matbchduedte.date).format("DD/MM/YYYY"): null, 
                                                 matsercodext:lo_dat.matsercodext, matsercod:lo_dat.matsercod, stkmovdocmatcod:lo_dat.stkmovdocmatcod ?? 0, 
                                                 sysdocrejcod: lo_dat.sysdocrejcod ?? 0,sysdocrsncod: lo_dat.sysdocrsncod ?? 0, 
                                                 docrefsrcqty: (lo_dat.refposqty != null && lo_dat.refposqty !== "") ? Math.abs(lo_dat.refposqty - parseFloat(lv_qty)):null, 
                                                 docrefminqty: (lo_dat.refposqty != null && lo_dat.refposqty !== "")? lo_dat.refposqty: null, 
                                                 docrefminqtysrc: (lo_dat.refposqty != null && lo_dat.refposqty !== "") ? parseFloat(lv_qty):null, __children:[]});
                              } else {
                                var lv_parent = lo_hotdata[lv_index];
                                if (lv_parent.__children.length === 0) {
                                  // Dividir la fila unificada: El primer hijo conserva los datos logísticos actuales del padre.
                                  lv_parent.__children.push({ uidxt: "uid_" + Math.random().toString(36).substr(2, 9), matcod: lv_parent.matcod, matcodext: lv_parent.matcodext, mattxt: lv_parent.mattxt, matuntcod: lv_parent.matuntcod, 
                                                              matuntcodpck: lv_parent.matuntcodpck, matqty: lv_parent.matqtypck, matqtyhide: lv_parent.matqty, matqtypck: lv_parent.matqtypck, 
                                                              matbchcodext: lv_parent.matbchcodext, matbchcod: lv_parent.matbchcod, matbchduedte: lv_parent.matbchduedte, 
                                                              matsercodext: lv_parent.matsercodext, matsercod: lv_parent.matsercod, matusebch: lv_parent.matusebch, matuseser: lv_parent.matuseser, 
                                                              docreftyp: lv_parent.docreftyp, docrefcod: lv_parent.docrefcod, docrefposcod: lv_parent.docrefposcod, stkmovdocmatcod: lv_parent.stkmovdocmatcod, 
                                                              sysdocrejcod: lv_parent.sysdocrejcod, sysdocrsncod: lv_parent.sysdocrsncod, docrefsrcqty: lv_parent.docrefsrcqty, 
                                                              docrefminqty: lv_parent.docrefminqty, docrefminqtysrc: lv_parent.docrefminqtysrc});
                                  // Blanquear los datos logísticos en la cabecera
                                  lv_parent.is_header_node = true;
                                  lv_parent.matbchcod = ""; lv_parent.matbchcodext = ""; lv_parent.matbchduedte = ""; lv_parent.matsercod = ""; lv_parent.matsercodext = ""; lv_parent.stkmovdocmatcod = "";
                                }
                                // HANDSONTABLE HIJO. Añado el nuevo hijo al padre
                                lv_parent.__children.push({ uidxt: "uid_" + Math.random().toString(36).substr(2, 9), matcod: lo_dat.matcod, matcodext: lo_dat.matcodext, mattxt: lo_dat.mattxt, matuntcod: lo_dat.matuntcod, 
                                                            matuntcodpck: lo_dat.matuntcod, matqty: "", matqtyhide: parseFloat(lv_qty), matqtypck: lo_dat.matqtypck ?? 0, 
                                                            matbchcodext: lo_dat.matbchcodext, matbchcod: lo_dat.matbchcod, matbchduedte: (lo_dat.matbchduedte?.date)?moment(lo_dat.matbchduedte.date).format("DD/MM/YYYY"): null, 
                                                            matsercodext: lo_dat.matsercodext, matsercod: lo_dat.matsercod, matusebch: lo_dat.matusebch ?? 0, matuseser: lo_dat.matuseser ?? 0, 
                                                            docreftyp: lo_dat.doctyp, docrefcod: lo_dat.doccod, docrefposcod: lo_dat.docposcod, stkmovdocmatcod: lo_dat.stkmovdocmatcod ?? 0, 
                                                            sysdocrejcod: lo_dat.sysdocrejcod ?? 0, sysdocrsncod: lo_dat.sysdocrsncod ?? 0, 
                                                            docrefsrcqty: (lo_dat.refposqty != null && lo_dat.refposqty !== "") ? Math.abs(lo_dat.refposqty - parseFloat(lv_qty)):null, 
                                                            docrefminqty: (lo_dat.refposqty != null && lo_dat.refposqty !== "")? lo_dat.refposqty: null, 
                                                            docrefminqtysrc: (lo_dat.refposqty != null && lo_dat.refposqty !== "") ? parseFloat(lv_qty):null});
                                lv_parent.matqty += parseFloat(lv_qty);
                                lv_parent.matqtypck += (lo_dat.matqtypck ?? 0);
                              }
                            } else {
                              lo_hotdata.push({...lo_dat, uidxt: "uid_" + Math.random().toString(36).substr(2, 9), matcod: lo_dat.matcod, matcodext: lo_dat.matcodext, mattxt: lo_dat.mattxt, matuntcod: lo_dat.matuntcod,
                                               matuntcodpck: lo_dat.matuntcod, matqty: parseFloat(lv_qty),
                                               matqtyhide: "", matqtypck: lo_dat.matqtypck ?? 0,
                                               matbchcodext: lo_dat.matbchcodext, matbchcod: lo_dat.matbchcod,
                                               matbchduedte: (lo_dat.matbchduedte?.date)?moment(lo_dat.matbchduedte.date).format("DD/MM/YYYY"): null,
                                               matsercodext: lo_dat.matsercodext, matsercod: lo_dat.matsercod,
                                               matusebch: lo_dat.matusebch ?? 0, matuseser: lo_dat.matuseser ?? 0,
                                               docreftyp: lo_dat.doctyp, docrefcod: lo_dat.doccod, docrefposcod: lo_dat.docposcod,
                                               stkmovdocmatcod: lo_dat.stkmovdocmatcod ?? 0,
                                               sysdocrejcod: lo_dat.sysdocrejcod ?? 0, sysdocrsncod: lo_dat.sysdocrsncod ?? 0,
                                               docrefsrcqty: (lo_dat.refposqty != null && lo_dat.refposqty !== "") ? Math.abs(lo_dat.refposqty - parseFloat(lv_qty)):null,
                                               docrefminqty: (lo_dat.refposqty != null && lo_dat.refposqty !== "")? lo_dat.refposqty: null,
                                               docrefminqtysrc: (lo_dat.refposqty != null && lo_dat.refposqty !== "") ? parseFloat(lv_qty):null,
                                               __children: [] 
                              });
                            }
                            var lv_objtyp = "<?= $vew_data->sysdoccls->objtyp; ?>";
                            var lv_docrev = "<?= $lv_docrev; ?>";
														$("#<?= $lv_sec; ?> #"+(lv_objtyp == "STK_SIN" || (lv_objtyp == "STK_SOU" && lv_docrev == "X") || lo_dat.doctyp == "STK_SIN" ? "srcobjtxt" : "dstobjtxt")).prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
														$("#<?= $lv_sec; ?> #"+(lv_objtyp == "STK_SOU" || (lv_objtyp == "STK_SIN" && lv_docrev == "X") ? "srccnttxt" : "dstcnttxt")).prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
													});
                          <?= $lv_sec; ?>_hotmat.loadData( lo_hotdata );
                          if (<?=$lv_refdocmdt != '' ?'false':'true'?>) {	<?= $lv_sec; ?>_addBlankRow();}
                        	//pequeño delay para evitar errores visuales 
                        	setTimeout(() => {<?=$lv_sec;?>_hotmat.render();}, 50); 
                        <?= $lv_sec; ?>_hot_paste = false;
                          dialogItself.close();
												}
											}
                      }
										]
					});
			});
		});
	</script>
	<script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
      //Funcion colapsar para la handsontable
      function <?=$lv_sec;?>_collapseAll(){
          plugin = <?=$lv_sec;?>_hotmat.getPlugin("nestedRows");
          plugin.collapsingUI.collapseAll();
      }
      function <?=$lv_sec;?>_addBlankRow(){
          var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
          var lv_newDat = lv_dat.filter(row => row.__children);
          lv_newDat.push({"__children":[],"blank":"X", uidxt: "uid_" + Math.random().toString(36).substr(2, 9)});
          <?= $lv_sec; ?>_hotmat.loadData(lv_newDat);
          <?= $lv_sec; ?>_hotmat.render();
      }
      //Funcion de borrado de hijos de una fila. Modificar esta funcion para que no use el plugin
      function <?= $lv_sec; ?>_removeChildren(row) {
        var plugin = <?= $lv_sec; ?>_hotmat.getPlugin('nestedRows');
        var parent = plugin.dataManager.getDataObject(row);
        if (!parent?.__children?.length) return;
        var visualIndexes = parent.__children.map(c => plugin.dataManager.getRowIndex(c)).filter(i => i != null);
       <?= $lv_sec; ?>_hotmat.alter('remove_row', visualIndexes[0],visualIndexes.length);
      }
       function <?=$lv_sec;?>_getParentRow(row){
          var lv_prntrow = 0;
          var lv_matcod = <?=$lv_sec?>_hotmat.getDataAtRowProp(row,"matcod");
          for (var i = row - 1; i >= 0; i--) {
            lv_data = <?=$lv_sec?>_hotmat.getSourceDataAtRow(i);
            if (lv_data.matcod ==  lv_matcod && lv_data.__children) {lv_prntrow = i; break; }
          }
        return lv_prntrow;
      }
      //Agregar una fila hijo al padre.
      function <?= $lv_sec; ?>_addChildRow(row){
            var sourceRowData = <?= $lv_sec; ?>_hotmat.getSourceDataAtRow(row);
            var lv_uidxt = sourceRowData.uidxt;
            var lv_matcod = sourceRowData.matcod;
            var lv_docrefcod = sourceRowData.docrefcod || 0;
            var lv_stkmovdocmatcod = sourceRowData.stkmovdocmatcod || 0;
            
            // IMPORTANTE: getSourceData() con nestedRows devuelve TODAS las filas (padres + hijos) aplanadas.
            // Solo debemos trabajar con las filas raíz (las que tienen __children), igual que _addBlankRow.
            var lv_rawdat = <?= $lv_sec; ?>_hotmat.getSourceData();
            var lv_dat = JSON.parse(JSON.stringify(lv_rawdat.filter(function(r) { return r.__children !== undefined; })));
            
            var lv_row = lv_dat.find(x => x.uidxt === lv_uidxt);
            if (!lv_row) {
                lv_row = lv_dat.find(x => x.matcod === lv_matcod && (x.docrefcod || 0) === lv_docrefcod && (x.stkmovdocmatcod || 0) === lv_stkmovdocmatcod);
            }
            if (!lv_row) return;
            
            var lv_is_picking = ("<?=$lv_matpckrel;?>" !== "");
            var lv_is_unified = (!lv_row.__children || lv_row.__children.length === 0);
            
            if (!lv_row.__children) { lv_row.__children = []; }
            
            if (lv_is_picking && lv_is_unified) {
                // Dividir la fila unificada: El hijo 1 conserva los datos logísticos actuales del padre.
                lv_row.__children.push({
                    uidxt: "uid_" + Math.random().toString(36).substr(2, 9),
                    stkmovdocmatcod: lv_row.stkmovdocmatcod,
                    matcod: lv_row.matcod,
                    matcodext: lv_row.matcodext,
                    mattxt: lv_row.mattxt,
                    matqty: (lv_is_picking ? lv_row.matqtypck : ""),
                    matqtyhide: lv_row.matqty,
                    matuntcod: lv_row.matuntcod,
                    matqtypck: lv_row.matqtypck,
                    matuntcodpck: lv_row.matuntcodpck,
                    matusebch: lv_row.matusebch,
                    matuseser: lv_row.matuseser,
                    matbchcod: lv_row.matbchcod,
                    matbchcodext: lv_row.matbchcodext,
                    matbchduedte: lv_row.matbchduedte,
                    matsercod: lv_row.matsercod,
                    matsercodext: lv_row.matsercodext,
                    docreftyp: lv_row.docreftyp,
                    docrefcod: lv_row.docrefcod,
                    docrefposcod: lv_row.docrefposcod,
                    docrefsrcqty: lv_row.docrefsrcqty,
                    sysdocrejcod: lv_row.sysdocrejcod,
                    sysdocrsncod: lv_row.sysdocrsncod
                });
                
                // Blanquear los datos logísticos en la cabecera (se mantendrá puramente como agrupación de cantidades)
                lv_row.is_header_node = true;
                lv_row.matbchcod = "";
                lv_row.matbchcodext = "";
                lv_row.matbchduedte = "";
                lv_row.matsercod = "";
                lv_row.matsercodext = "";
                lv_row.stkmovdocmatcod = "";
            }
            
            // Añadir el nuevo hijo vacío para que el usuario escriba
            lv_row.__children.push({
                uidxt: "uid_" + Math.random().toString(36).substr(2, 9),
                matcod: lv_row.matcod,
                matcodext: lv_row.matcodext,
                matbchcodext: "",
                mattxt: lv_row.mattxt,
                matqty: (lv_is_picking ? 0 : lv_row.matqty),
                matqtyhide: (lv_is_picking ? lv_row.matqty : ""),
                matqtydif: lv_row.matqtydif,
                matqtystk: lv_row.matqtystk,
                matuntcod: lv_row.matuntcod,
                matuntcodpck: lv_row.matuntcodpck,
                matqtypck: 0,
                matqtytot: lv_row.matqty,
                matqtybsehid: lv_row.matqtybse,
                matqtybse: "",
                matusebch: lv_row.matusebch,
                matuseser: lv_row.matuseser,
                docreftyp: lv_row.docreftyp,
                docrefcod: lv_row.docrefcod,
                docrefposcod: lv_row.docrefposcod
            });
            // Actualizar la tabla
            <?= $lv_sec; ?>_hotmat.loadData(lv_dat);
            <?= $lv_sec; ?>_hotmat.render();
        }
		var <?= $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if (<?= $lv_sec; ?>_hotmat!=undefined) {
        if(<?= $lv_sec; ?>_hot_paste_array.length == 0 && <?= $lv_sec; ?>_hot_paste != true){
          var lv_ro_color = "#F1F1F1";
          var lv_color = "#FFFFFF";
					var lv_phsrow = instance.toPhysicalRow(row);

          // esta linea referencia a otro documento
          var lv_docref = false;
          var lv_docreftyp = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"docreftyp");
          if ( (lv_docreftyp==null?"":lv_docreftyp)!="" ) { lv_docref = true; }

          // esta linea es referenciada por otro documento
          var lv_docrefqty = false;
          var lv_docrefminqty = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"docrefminqty");
          if ( (lv_docrefminqty==null?"":lv_docrefminqty.toString())!="" ) { lv_docrefqty = true; }

          // sujeto a lote-serie
          var lv_matusebch = (<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matusebch")=="1"?true:false);
          var lv_matuseser = (<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matuseser")=="1"?true:false);
          var lv_docrefcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"docrefcod");
          var lv_is_refcod = (lv_docrefcod != null && lv_docrefcod != 0 && lv_docrefcod !== "");

          var lv_matusepck = ((<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matusepck")??"1")=="1"?true:false);
          var lv_matpckrel  = <?=$lv_matpckrel!=''?'true':'false';?>;
      		var lv_prntrow =  (<?= $lv_sec; ?>_hotmat.getSourceDataAtRow(lv_phsrow)?.__children!==undefined);
      		var lv_has_children = lv_prntrow && (<?= $lv_sec; ?>_hotmat.getSourceDataAtRow(lv_phsrow).__children.length > 0);
      		var lv_prnt_header = lv_prntrow && lv_has_children && lv_matpckrel;

          // documento controla stock o crea lote/serie
          var lv_stkctr = <?= ($lv_stkctr=='X'?'true':'false'); ?>;
          //var lv_matbchcre = <?= ($lv_matbchcre=='X'?'true':'false'); ?>;
          //var lv_matsercre = <?= ($lv_matsercre=='X'?'true':'false'); ?>;
          var lv_matbchman = <?= (strtoupper($lv_stkmatbchman)=='X'?'true':'false'); ?>;
          var lv_matserman = <?= (strtoupper($lv_stkmatserman)=='X'?'true':'false'); ?>;
          var lv_ro = <?php echo($vew_readonly2?'true':'false'); ?>;

          var lv_sysdocrejcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"sysdocrejcod");
          lv_sysdocrejcod = (lv_sysdocrejcod==null || lv_sysdocrejcod==""?"0":lv_sysdocrejcod);

          if ( prop=="matcod") {
            Handsontable.renderers.TextRenderer.apply(this, arguments);			
            td.style.backgroundColor = (lv_ro || lv_docref || lv_docrefqty || !lv_prntrow ?lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro || lv_docref || lv_docrefqty || !lv_prntrow ?true:false);
          } else if ( prop=="matcodext") {
            Handsontable.renderers.TextRenderer.apply(this, arguments);			
            td.style.backgroundColor = lv_ro_color;
            cellProperties.readOnly = true;
          } else if ( prop=="mattxt" ) {
            Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
            td.style.backgroundColor = (lv_ro || !lv_prntrow ||lv_docref || lv_docrefqty?lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro || !lv_prntrow || lv_docref || lv_docrefqty?true:false);
          } else if ( prop=="matqty" ) {
            Handsontable.renderers.NumericRenderer.apply(this, arguments);			
            var lv_is_ro = lv_ro || lv_docref;
            if (lv_matpckrel) {
                if (!lv_prnt_header && !lv_prntrow) { lv_is_ro = true; } 
                else if (lv_prnt_header) { lv_is_ro = lv_ro || lv_docref; }
            } else {
                lv_is_ro = lv_ro || lv_prnt_header || lv_docref;
            }
            td.style.backgroundColor = (lv_is_ro ? lv_ro_color : lv_color);
            cellProperties.readOnly = lv_is_ro;	
            // En picking, los hijos muestran matqty vacío (la cantidad real va en matqtypck)
            var lv_is_child = lv_matpckrel && !lv_prntrow;
            if (lv_is_child) { td.innerHTML = ""; }
          } else if ( prop=="matqtypck" ) {
            Handsontable.renderers.NumericRenderer.apply(this, arguments);			
            var lv_row_qty = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row, "matqty");
            var lv_row_matqtypck = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row, "matqtypck");
            td.style.backgroundColor = (lv_ro || lv_prnt_header ?lv_ro_color:((lv_row_qty > lv_row_matqtypck)?"#FFB8B8":((lv_row_qty != lv_row_matqtypck)?"#FFE0B2":((lv_row_qty = lv_row_matqtypck)?"#C8E6C9":lv_color))));
            cellProperties.readOnly = (lv_ro	|| lv_prnt_header?true:false);
          } else if ( prop=="matuntcod" ) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);			
            var lv_is_ro = lv_ro || lv_docref;
            if (lv_matpckrel) {
                if (!lv_prnt_header && !lv_prntrow) { lv_is_ro = true; } 
                else if (lv_prnt_header) { lv_is_ro = lv_ro || lv_docref; }
            } else {
                lv_is_ro = lv_ro || lv_prnt_header || lv_docref;
            }
            td.style.backgroundColor = (lv_is_ro ? lv_ro_color : lv_color);
            cellProperties.readOnly = lv_is_ro;					
          } else if ( prop=="matuntcodpck" ) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);			
            td.style.backgroundColor = (lv_ro || lv_prnt_header ?lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro || lv_prnt_header ?true:false);	
          } else if ( prop=="matbchcodext" ) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            var lv_errcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matbchdeterrcod");
            var lv_errtxt = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"matbchdeterrtxt");
            if ( lv_errtxt!="" ) { cellProperties.comment = lv_errtxt; }
            var lv_col = (lv_errcod=="E"?"#FFAAAA":(lv_errcod=="W"?"#FFFFAA":""));
            td.style.backgroundColor = (lv_col!="" && !lv_prnt_header?lv_col:(lv_ro || !lv_matusebch || !lv_matbchman || lv_prnt_header  ?lv_ro_color:lv_color));
            cellProperties.readOnly = (lv_ro || !lv_matusebch || !lv_matbchman || lv_prnt_header ?true:false);
          } else if ( prop=="icn" ) {
            var lv_btn = "<div class='text-center'><a href='#' onclick='<?= $lv_sec; ?>_findBatch("+row+");' ><span class='fas fa-search'></span></a></div>";
          	$(td).empty();
           	if(!lv_prnt_header && lv_matusebch){ $(td).empty().append(lv_btn); }
            td.style.backgroundColor = lv_ro_color;
          } else if ( prop=="icn3" ) {
            $(td).empty();
            var lv_btn = "<div class='text-center'><a href='#' onclick='<?= $lv_sec; ?>_findSerial("+row+");'><span class='fas fa-search'></span></a></div>";
            if (lv_matuseser && !lv_prnt_header){ $(td).empty().append(lv_btn); }
            td.style.backgroundColor = lv_ro_color;
          } else if ( prop=="icn2" ) {
            $(td).empty();
            if(<?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"mattxt")){
              var lv_btn = "";
              if(lv_prntrow && !lv_ro && !lv_is_refcod){
                lv_btn += "<div onclick='<?= $lv_sec; ?>_addChildRow("+lv_phsrow+");' class='text-center cursor-pointer' style='display:inline-block; margin-right:8px;'><a href='#'><i class='fas fa-plus'></i></a></div>";
              }
              if(!lv_prnt_header){
                lv_btn += "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn "+(lv_sysdocrejcod!="0"?"btn-danger":"btn-default")+" btn-sm' style='display:inline-block;'><span class='fas fa-ellipsis-h'></span></a>";
              }
              $(td).empty().append("<div style='white-space:nowrap; text-align:center;'>" + lv_btn + "</div>");
            }
            td.style.backgroundColor = lv_ro_color;
          } else if ( prop=="matbchduedte") {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            td.style.backgroundColor = (lv_ro || !lv_matusebch || !lv_matbchman || lv_prnt_header ?lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro || !lv_matusebch || !lv_matbchman || lv_prnt_header ?true:false);
          } else if ( prop=="matsercodext") {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            td.style.backgroundColor = (lv_ro || !lv_matuseser || !lv_matserman || lv_prnt_header  ?lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro  || !lv_matuseser || !lv_matserman || lv_prnt_header ?true:false);
          } else{
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
          }
     
				}
      }
		};
		var <?= $lv_sec; ?>_hot_paste = false;
    var <?= $lv_sec; ?>_hot_paste_array = [];
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotmatdel = [];
		var <?= $lv_sec; ?>_hotmatcnt = $("#<?= $lv_sec; ?> #stkmovdocmathot")[0];
		var <?= $lv_sec; ?>_hotmatset = {
			height: 396,
			stretchH: "all",
			rowHeaders: true,
			<?= ($vew_readonly ?'':'contextMenu: ["remove_row"],') ?>
      bindRowsWithHeaders: true,
      nestedRows: true,
      outsideClickDeselects: false, 
      licenseKey: gv_handsontable_lc,
			colHeaders: ["ID", "<?= $vew_lang->code; ?>", "Denominacion", "Cantidad", "UM", <?= ($lv_matpckrel!=''?'"Leido","UM",':''); ?> "Lote", <?php echo(($lv_stkctr=='X' || $vew_data->sysdoccls->objtyp=='STK_SIV') && strtoupper($lv_stkmatbchman)=='X' ?'"",':''); ?>"Vto", "Nro Serie",<?php echo(($lv_stkctr=='X' || $vew_data->sysdoccls->objtyp=='STK_SIV') && strtoupper($lv_stkmatserman)=='X' ?'"",':''); ?>""],
			columns: [
				{type: "text", data: "matcod", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly2?'readOnly: true, ':''); ?> },
				{type: "text", data: "matcodext", renderer: <?= $lv_sec; ?>_hotmat_renderer, readOnly: true},
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly2?'readOnly: true, ':''); ?>
					source(query, process) {
            if (query.length > 1 && <?= $lv_sec; ?>_hot_paste != true) { 
                $.ajax({
                    url: "?prg=stkmat&act=17",dataType: "json",data: { prm_mattxt: query },
                    complete: function(jqXHR, textStatus) {
                        if (jqXHR.responseText.substr(0, 10) == "/*script*/") { 
                            eval(jqXHR.responseText); 
                        }
                    },
                    success: function (response) {
                        <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                        const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.mattxt);
                        process(items);
                    },
                    error: function () {
                        <?= $lv_sec; ?>_autocompleteCache = [];
                        process([]);
                    }
                });
            } else {
                // Lógica de limpieza cuando se procesa pegado masivo
                for (var i = 0; i < <?= $lv_sec; ?>_hot_paste_array.length; i++) {
                    if (query == <?= $lv_sec; ?>_hot_paste_array[i]) { 
                        <?= $lv_sec; ?>_hot_paste_array.splice(i, 1);
                        break;
                    }
                }
                if (<?= $lv_sec; ?>_hot_paste_array.length == 0) { 
                    <?= $lv_sec; ?>_hot_paste = false; 
                }
                process([query]);
           }
        },
					strict: true
				},
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 30, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2?', readOnly: true':'');	?> },
				<?php if($lv_matpckrel!=''){ ?>
				{type: "numeric", data: "matqtypck", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcodpck", width: 30, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2?', readOnly: true':'');	?> },
				<?php } ?>
				{type: "text", data: "matbchcodext", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2?', readOnly: true':'');	?> },
				<?php if((strtoupper($lv_stkctr)=='X' || $vew_data->sysdoccls->objtyp=='STK_SIV') && strtoupper($lv_stkmatbchman)=='X'){ ?>
				{type: "text", data: "icn", width: 18, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true },
				<?php } ?>
				{type: "date", data: "matbchduedte", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2 || $lv_stkctr=='X' || $lv_matbchcre==''?', readOnly: true':'');	?>,
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: true,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{type: "text", data: "matsercodext",width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly2?', readOnly: true':'');	?> },
        <?php if(($lv_stkctr=='X' || $vew_data->sysdoccls->objtyp=='STK_SIV') && strtoupper($lv_stkmatserman)=='X'){ ?>
        	{type: "text", data: "icn3", width: 13, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true },
        <?php } ?>
				{type: "text", data: "icn2", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true }
			],
      enterMoves: function(event) {
        // Enter sigue el mismo sentido que Tab
        var lv_editCols = [0,2,3,4,5, 6, 7];
        var lv_sel = <?= $lv_sec; ?>_hotmat.getSelectedLast();
        if (!lv_sel) return {row: 1, col: 0};
        var lv_row = lv_sel[0], lv_col = lv_sel[1];
        var lv_nextColIdx = lv_editCols.indexOf(lv_col);
        if (lv_nextColIdx >= 0 && lv_nextColIdx < lv_editCols.length - 1) {
          var lv_delta = lv_editCols[lv_nextColIdx + 1] - lv_col;
          return {row: 0, col: lv_delta};
        }
        var lv_rowDelta = 1;
        var lv_colDelta = lv_editCols[0] - lv_col;
        return {row: lv_rowDelta, col: lv_colDelta};
      },
			afterChange: function(changes, source) {
        	if (source === "loadData" || source === "autoclear" || !changes || source === "parent" || source==="barcode" || source==="remove") return;
        	if (source === "edit"){
            // borro posible \r que se pegue al intentar pegar varios códigos
            if(changes && changes.length && source=="CopyPaste.paste"){ 
              var lv_paste_changes = [];
              for(var i=0 ; i < changes.length ; i++) {
                if (changes[i][3] && typeof changes[i][3] === 'string' && changes[i][3].indexOf('\r') !== -1) {
                  var cleanValue = changes[i][3].replace(/\r/g, "");
                  lv_paste_changes.push([changes[i][0], changes[i][1], cleanValue]);
                }
              }
              if (lv_paste_changes.length > 0) {
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_paste_changes, "paste.cleaned");
              }
            }
            // AUTOCOMPLETE: asigno los datos adicionales a la fila
            if (changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hot_paste!=true) {
              if (changes[0][1]=="mattxt") {
                var lv_value = changes[0][3];
                for(var i=0 ; i < <?= $lv_sec; ?>_autocompleteCache.length ; i++) {
                  if (<?= $lv_sec; ?>_autocompleteCache[i].mattxt == lv_value) {
                    var lv_changes = [];
                    lv_changes.push([changes[0][0], "matcod", String(<?= $lv_sec; ?>_autocompleteCache[i].matcod)]);
                    lv_changes.push([changes[0][0], "matcodext", String(<?= $lv_sec; ?>_autocompleteCache[i].matcodext)]);
                    lv_changes.push([changes[0][0], "matusebch", String(<?= $lv_sec; ?>_autocompleteCache[i].matusebch)]);
                    lv_changes.push([changes[0][0], "matuseser", String(<?= $lv_sec; ?>_autocompleteCache[i].matuseser)]);
                    lv_changes.push([changes[0][0], "matbchduedte", ""]);
                    lv_changes.push([changes[0][0], "matbchcodext", ""]);
                    lv_changes.push([changes[0][0], "matsercodext", ""]);
                    if (<?= $lv_sec; ?>_hotmat.getDataAtRowProp(changes[0][0],"matuntcod")!=String(<?= $lv_sec; ?>_autocompleteCache[i].matuntcod) ) {
                        lv_changes.push([changes[0][0], "matqty", "0"]);
                        lv_changes.push([changes[0][0], "matuntcod", String(<?= $lv_sec; ?>_autocompleteCache[i].matuntcod)]);
                        lv_changes.push([changes[0][0], "matuntcodpck", String(<?= $lv_sec; ?>_autocompleteCache[i].matuntcod)]);
                    }
                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_changes, "edit.autocomplete");
                    <?= $lv_sec; ?>_hot_autocomplete = true;
                  }
                }
              }
            }else if(changes && changes.length && source=="paste" && (changes[0][1]=="matuseser" || changes[0][1]=="matusebch")){ <?= $lv_sec; ?>_hotmat.render(); }
          }
        
        	changes.forEach(([row, prop, oldValue, newValue]) => { 
          	if ( prop=="matcod" && <?= $lv_sec; ?>_hot_autocomplete!=true && (source=="edit" || source=="CopyPaste.paste")  ){
							var lv_value = newValue;
              var lv_pstdat =[{name:"matcodfndseq",value:"<?= $lv_matcodfndseq; ?>"}, {name:"row",value:row}];
              lv_pstdat.push( {name:"matcodext",value:lv_value} );
							tmssCallProcessNoBackdrop("?prg=stkmat&act=19", lv_pstdat, function(data){
								if (data.row!=undefined & !data.data.length) {
									var lv_row = data.row;
                                    var lv_changes_matcod = [];
                                    lv_changes_matcod.push([lv_row,"matcod", data.data["matcod"]]);
                                    lv_changes_matcod.push([lv_row,"matcodext", (data.data["matcodext"]!=undefined?data.data["matcodext"]:"")]);
                                    lv_changes_matcod.push([lv_row,"mattxt", data.data["mattxt"]]);
                                    lv_changes_matcod.push([lv_row,"matuntcod", (data.data["matuntcod"]!=undefined?data.data["matuntcod"]:"")]);
                                    lv_changes_matcod.push([lv_row,"matqty", (data.data["matqty"]!=undefined?data.data["matqty"]:"0")]);
                                    lv_changes_matcod.push([lv_row,"matusebch", data.data["matusebch"]]);
                                    lv_changes_matcod.push([lv_row,"matuseser", data.data["matuseser"]]);
                  
									if ( data.data["matbchcodext"]!=undefined ) {
										lv_changes_matcod.push([lv_row,"matbchcod", data.data["matbchcod"]]);
										lv_changes_matcod.push([lv_row,"matbchcodext", data.data["matbchcodext"]]);
										lv_changes_matcod.push([lv_row,"matbchduedte", (data.data["matbchduedtecnv"]!=undefined?data.data["matbchduedtecnv"]:"")]);
									} else {
										lv_changes_matcod.push([lv_row,"matbchcod", ""]);
										lv_changes_matcod.push([lv_row,"matbchcodext", ""]);
										lv_changes_matcod.push([lv_row,"matbchduedte", ""]);                  
                                    }
                  
									if ( data.data["matsercodext"]!=undefined ) {
										lv_changes_matcod.push([lv_row,"matsercod", data.data["matsercod"]]);
										lv_changes_matcod.push([lv_row,"matsercodext", data.data["matsercodext"]]);
									} else {
										lv_changes_matcod.push([lv_row,"matsercod", ""]);
										lv_changes_matcod.push([lv_row,"matsercodext", ""]);                    
                                    }
                                    
                                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_changes_matcod, "edit.matcod");
								}
							});
						}
           if(prop ==="mattxt" && newValue !== oldValue){
             //Si se cambia el texto de un material elimino sus hijos.
             var lv_child = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row, "__children");
             if(Array.isArray(lv_child) && lv_child.length>0){<?= $lv_sec; ?>_removeChildren(row);}
             if(row ==(<?= $lv_sec; ?>_hotmat.countSourceRows()-1) && "<?=$lv_refdocmdt;?>" == "" && newValue!="" && <?=(!$vew_readonly?'true':'false');?>){<?=$lv_sec;?>_addBlankRow();}
           }
          //Logica de control de unidades de medida.
           var lv_phsrow_chg = <?= $lv_sec; ?>_hotmat.toPhysicalRow(row);
           var lv_node = <?= $lv_sec; ?>_hotmat.getSourceDataAtRow(lv_phsrow_chg);
           var lv_is_parent_node = (lv_node?.__children !== undefined);
           if (lv_is_parent_node) {
               if (prop == "matqty" && "<?=$lv_matpckrel;?>" != "") {
                   lv_node["matqtyhide"] = newValue;
                   if (lv_node.__children && lv_node.__children.length > 0) {
                       for(var k=0; k<lv_node.__children.length; k++) {
                           lv_node.__children[k]["matqtyhide"] = newValue;
                       }
                   }
               }
               return;
           }

           var lv_matuntcodpck = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row, "matuntcodpck");
           var lv_matuntcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row, "matuntcod");
           var lv_prnt = <?=$lv_sec;?>_getParentRow(row);
           var lv_matuntcodpckprnt = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_prnt, "matuntcodpck");
           var lv_matuntcodprnt = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_prnt, "matuntcod");
           var lv_matcod = <?=$lv_sec;?>_hotmat.getDataAtRowProp(row, "matcod");
           var lv_idtval = 0;
           var lv_idtvalold = 0;
           if((prop == "matuntcod" || prop == "matuntcodpck") && (oldValue !== newValue) && (source != "edit.matcod")) {
              // Verificar que las unidades son diferentes al padre y que no están vacías
              if ((lv_matuntcod != lv_matuntcodprnt || lv_matuntcodpck != lv_matuntcodpckprnt) && !(lv_matuntcod == '' && lv_matuntcodpck == '')) {
                  var lv_ispck = (prop == "matuntcodpck");
                  var lv_prop = (lv_ispck) ? "matqtypck" : "matqty";
                  var lv_crrntqty = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row, lv_prop);
                  var lv_pstdat = [{name: "matcod", value: lv_matcod}];
                  tmssCallProcessNoBackdrop("?prg=stkmatidt&act=19", lv_pstdat, function(data) {
                      var lv_found = false;
                      var lv_matuntcodfnd = [lv_matuntcodprnt];
                      for (var i = 0; i < data.length; i++) {
                          var lv_row = data[i];
                          lv_matuntcodfnd.push(lv_row["matidtuntcod"]);
                        
                          if(newValue == lv_row["matidtuntcod"]) {
                            	lv_found=true;
                              var lv_conval = lv_crrntqty / lv_row["matidtqty"];
                              lv_idtval = lv_conval * lv_row["matbseqty"];
                          }
                        	if(oldValue == lv_row["matidtuntcod"]) {
                              var lv_oldconval = lv_crrntqty / lv_row["matidtqty"];
                              lv_idtvalold = lv_oldconval * lv_row["matbseqty"];
                          }
                      }
                    	if(lv_found){<?=$lv_sec;?>_updateParent(row,lv_prop, lv_idtval, lv_idtvalold,lv_crrntqty);}else{
                        toastr.warning('La unidad de medida no es valida para este material ['+lv_matcod+']. Unidades disponibles: ' + lv_matuntcodfnd.join(', '));
                      	<?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, prop, oldValue, "edit.matcod");
                      }
                  });
              }
          }
          // Cambio en cantidad (matqty o matqtypck)
          if ((prop == "matqty" || prop == "matqtypck") && (oldValue !== newValue) && (source != "edit.matcod") && (source != "edit.mirror")) {
              if (prop == "matqtypck" && "<?=$lv_matpckrel;?>" != "" && !lv_is_parent_node) {
                  <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matqty", newValue, "edit.mirror");
              }
              var lv_ispck = (prop == "matqtypck");
              var lv_prop = (lv_ispck) ? "matqtypck" : "matqty";
              // Verificar que las unidades son diferentes al padre y que no están vacías
              if ((lv_matuntcod != lv_matuntcodprnt || lv_matuntcodpck != lv_matuntcodpckprnt) && !(lv_matuntcod == '' && lv_matuntcodpck == '')) {
                  var lv_crrntuntcod = (lv_ispck) ? lv_matuntcodpck:lv_matuntcod;
                  var lv_pstdat = [{name: "matcod", value: lv_matcod}];
                  tmssCallProcessNoBackdrop("?prg=stkmatidt&act=19", lv_pstdat, function(data) {
                      for (var i = 0; i < data.length; i++) {
                          var lv_row = data[i];
                          if (lv_crrntuntcod == lv_row["matidtuntcod"]) {
                              var lv_conval = newValue / lv_row["matidtqty"];
                              var lv_oldconval = (oldValue??0) / lv_row["matidtqty"];
                              lv_idtval = lv_conval * lv_row["matbseqty"];
                              lv_idtvalold = lv_oldconval * lv_row["matbseqty"];
                              break;
                          }
                      }
                       <?=$lv_sec;?>_updateParent(row,lv_prop, lv_idtval, lv_idtvalold);
                  });
              }else if(lv_matuntcod == lv_matuntcodprnt || lv_matuntcodpck == lv_matuntcodpckprnt){
              	lv_idtval = newValue;
                lv_idtvalold = oldValue??0;
                <?=$lv_sec;?>_updateParent(row,lv_prop, lv_idtval, lv_idtvalold);
              }
          }
        } )
        <?= $lv_sec; ?>_hot_autocomplete = false;
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			},
      afterOnCellMouseDown: function(event, coords, TD) {
        let lv_btn = $("#<?= $lv_sec; ?>_btnDeleteSelected");
        if (!lv_btn) return;
        if (coords.col === -1 && coords.row >= 0){
            lv_btn.show();
            $("#<?= $lv_sec; ?> #btnstkchk").hide();
            $("#<?= $lv_sec; ?> #btnmatbchdet").hide();
            $("#<?= $lv_sec; ?> #btndocref").hide();
        }else{
            lv_btn.hide();
            $("#<?= $lv_sec; ?> #btnstkchk").show();
            $("#<?= $lv_sec; ?> #btnmatbchdet").show();
            $("#<?= $lv_sec; ?> #btndocref").show();
        }
      },
      afterDeselect: function() {
        let lv_btn = $("#<?= $lv_sec; ?>_btnDeleteSelected");
        if (!lv_btn) return;
        lv_btn.hide();
        $("#<?= $lv_sec; ?> #btnstkchk").show();
        $("#<?= $lv_sec; ?> #btnmatbchdet").show();
        $("#<?= $lv_sec; ?> #btndocref").show();
      },
      beforeRemoveRow: function(index, amount, logicalRows) {
        var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
        for( var j=0; j<logicalRows.length; j++){
            var i = logicalRows[j];
            if ( lv_dat[i]["docrefsrcqty"]!="" && lv_dat[i]["docrefsrcqty"]!=undefined ) {
                toastr.warning("No se pueden borrar posiciones que estan referenciadas por otros documentos.");
                return false;
            } else if ( lv_dat[i]["stkmovdocmatcod"]!="" && lv_dat[i]["stkmovdocmatcod"]!=undefined ) {
                <?= $lv_sec; ?>_hotmatdel.push( lv_dat[i] );
            }

            // Si es un hijo (no tiene __children), descontar del padre antes de borrar
            var lv_phsrow = <?= $lv_sec; ?>_hotmat.toPhysicalRow(i);
            var lv_node = <?= $lv_sec; ?>_hotmat.getSourceDataAtRow(lv_phsrow);
            if (lv_node && lv_node.__children === undefined && "<?=$lv_matpckrel;?>" != "") {
                var lv_prntrow = <?=$lv_sec;?>_getParentRow(i);
                var lv_phsprntrow = <?= $lv_sec; ?>_hotmat.toPhysicalRow(lv_prntrow);
                var lv_prntnode = <?= $lv_sec; ?>_hotmat.getSourceDataAtRow(lv_phsprntrow);
                if (lv_prntnode && lv_prntnode.__children) {
                    // Recalcular total del padre excluyendo el hijo que se va a borrar
                    var lv_total = 0;
                    for (var k = 0; k < lv_prntnode.__children.length; k++) {
                        var lv_child = lv_prntnode.__children[k];
                        // Excluir el hijo que se está borrando usando uidxt
                        if (lv_child.uidxt !== lv_node.uidxt) {
                            lv_total += parseFloat(lv_child["matqtypck"] ?? 0) || 0;
                        }
                    }
                    <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_prntrow, "matqtypck", lv_total, "parent");
                }
            }

            var lv_found=0;
            var lv_newinx;
            for( var x=<?= $lv_sec; ?>_hotdocerr.length-1; x>=0; x-- ) {
                if( <?= $lv_sec; ?>_hotdocerr[x].endsWith("_"+i.toString()) ){
                    <?= $lv_sec; ?>_hotdocerr.splice(x,1);
                    lv_found=1;
                } else if(lv_found==0) { 
                    lv_newinx = <?= $lv_sec; ?>_hotdocerr[x].split("_");
                    lv_newinx[1] = Number(lv_newinx[1])-1;
                    <?= $lv_sec; ?>_hotdocerr[x] = lv_newinx[0]+"_"+lv_newinx[1].toString();
                }
            }
        }
    	}
		};
    function <?=$lv_sec;?>_updateParent(row, prop, idtval, idtvalold, oldValue=0) {
      if ("<?=$lv_matpckrel;?>" == "") return;
      if (prop == "matqty") return;

      var lv_phsrow = <?= $lv_sec; ?>_hotmat.toPhysicalRow(row);
      var lv_prntrow = <?=$lv_sec;?>_getParentRow(row);
      var lv_phsprntrow = <?= $lv_sec; ?>_hotmat.toPhysicalRow(lv_prntrow);
      var lv_prntnode = <?= $lv_sec; ?>_hotmat.getSourceDataAtRow(lv_phsprntrow);

      if (!lv_prntnode || !lv_prntnode.__children) return;

      // Recalcular sumando todos los hijos actuales en lugar de suma incremental
      var lv_total = 0;
      for (var k = 0; k < lv_prntnode.__children.length; k++) {
          var lv_child = lv_prntnode.__children[k];
          var lv_childval = parseFloat(lv_child[prop] ?? 0) || 0;
          lv_total += lv_childval;
      }

      <?=$lv_sec?>_hotmat.setDataAtRowProp(lv_prntrow, prop, lv_total, "parent");
    }
		var <?= $lv_sec; ?>_hotmat;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			var lv_dat = <?php
				$lv_buffer='';
        $lv_hotmat = [];
        $lv_matcounts = [];
        // First pass: count occurrences of each material + docrefcod
        foreach($vew_data->stkmovdocmat as $lv_row){
            $lv_key = $lv_row['matcod'] . '_' . ($lv_row['docrefcod'] ?? 0);
            if(!isset($lv_matcounts[$lv_key])) { $lv_matcounts[$lv_key] = 0; }
            $lv_matcounts[$lv_key]++;
        }
        
        $lv_grouped_indices = []; // map matcod+docrefcod to index in $lv_hotmat
        
        foreach($vew_data->stkmovdocmat as $lv_row){ 
            $lv_matcod = $lv_row['matcod'];
            $lv_group_key = $lv_row['matcod'] . '_' . ($lv_row['docrefcod'] ?? 0);
            
            if ($lv_matpckrel != '') {
                // MODO PICKING: Agrupar por matcod + docrefcod
                if (!isset($lv_grouped_indices[$lv_group_key])) {
                    // Create new parent node
                    $lv_idx = count($lv_hotmat);
                    $lv_grouped_indices[$lv_group_key] = $lv_idx;
                    
                    $lv_hotmat[] = [
                        'uidxt'       => uniqid('p_'),
                        'is_header_node' => ($lv_matcounts[$lv_group_key] > 1 ? true : false),
                        'matcodext'   => ($lv_row['matcodext'] ?? ''),
                        'matcod'      => ($lv_row['matcod'] ?? ''),
                        'mattxt'      => mb_convert_encoding($lv_row['mattxt'] ?? '', 'UTF-8', 'ISO-8859-1'),
                        'matuntcod'   => (!empty($lv_row['matuntcodbse']) ? $lv_row['matuntcodbse'] : $lv_row['matuntcod']),
                        'docreftyp'   => ($lv_row['docreftyp'] ?? ''),
                        'docrefcod'   => ($lv_row['docrefcod'] ?? 0),
                        'docrefposcod'=> ($lv_row['docrefposcod'] ?? 0),
                        'matqty'      => 0,
                        'matqtypck'   => 0,
                        'matuntcodpck'=> $lv_row['matuntcod'],
                        'matusebch'   => $lv_row['matusebch'],
                        'matuseser'   => $lv_row['matuseser'],
                        '__children'  => []
                    ];
                    
                    if ($lv_matcounts[$lv_group_key] == 1) {
                        // Single record hybrid row
                        $lv_hotmat[$lv_idx]['stkmovdocmatcod'] = $lv_row['stkmovdocmatcod'];
                        $lv_hotmat[$lv_idx]['matqty']          = (float)$lv_row['matqty'];
                        $lv_hotmat[$lv_idx]['matqtyhide']      = (float)$lv_row['matqty'];
                        $lv_hotmat[$lv_idx]['matqtypck']       = (float)$lv_row['matqtypck'];
                        $lv_hotmat[$lv_idx]['matuntcodpck']    = (!empty($lv_row['matuntcodpck']) ? $lv_row['matuntcodpck'] : $lv_row['matuntcod']);
                        $lv_hotmat[$lv_idx]['matbchcod']       = $lv_row['matbchcod'];
                        $lv_hotmat[$lv_idx]['matbchcodext']    = $lv_row['matbchcodext'];
                        $lv_hotmat[$lv_idx]['matbchduedte']    = ($lv_row['matbchduedte'] != null ? (is_array($lv_row['matbchduedte']) ? date('d/m/Y', strtotime($lv_row['matbchduedte']['date'])) : $lv_row['matbchduedte']->format('d/m/Y')) : '');
                        $lv_hotmat[$lv_idx]['matsercod']       = $lv_row['matsercod'];
                        $lv_hotmat[$lv_idx]['matsercodext']    = $lv_row['matsercodext'];
                        $lv_hotmat[$lv_idx]['sysdocrejcod']    = ($lv_row['sysdocrejcod'] ?? 0);
                        $lv_hotmat[$lv_idx]['sysdocrsncod']    = ($lv_row['sysdocrsncod'] ?? 0);
                        $lv_hotmat[$lv_idx]['docrefsrcqty']    = ($lv_row['refposqty'] ?? '') !== '' ? abs($lv_row['refposqty'] - ($lv_row['matqty'] ?? 0)) : null;
                        $lv_hotmat[$lv_idx]['docrefminqty']    = ($lv_row['refposqty'] ?? '') !== '' ? $lv_row['refposqty'] : null;
                        $lv_hotmat[$lv_idx]['docrefminqtysrc'] = ($lv_row['refposqty'] ?? '') !== '' ? ($lv_row['matqty'] ?? null) : null;
                        continue;
                    }
                }
                
                $lv_idx = $lv_grouped_indices[$lv_group_key];
                
                // Acumular totales en el padre
                $lv_matqty = (float)$lv_row['matqty'];
                if(isset($lv_row['matuntcodbse']) && $lv_row['matuntcod'] != $lv_row['matuntcodbse']){
                    $lv_convbseqty = isset($lv_row['matbseqty']) ? (float)$lv_row['matbseqty'] : 1;
                    $lv_matidtbse  = $lv_matqty / ($lv_row['matidtqty'] ?? 1);
                    $lv_matqtyconv = $lv_matidtbse * $lv_convbseqty;
                } else {
                    $lv_matqtyconv = $lv_matqty;
                }
                if ($lv_hotmat[$lv_idx]['matqty'] == 0) { $lv_hotmat[$lv_idx]['matqty'] = $lv_matqtyconv; }
                $lv_hotmat[$lv_idx]['matqtypck'] += (float)$lv_row['matqtypck'];
                
                // Agregar el hijo
                $lv_hotmat[$lv_idx]['__children'][] = [
                    'uidxt'            => uniqid('c_'),
                    'stkmovdocmatcod' => $lv_row['stkmovdocmatcod'],
                    'matcod'          => $lv_row['matcod'],
                    'matcodext'       => $lv_row['matcodext'],
                    'mattxt'          => mb_convert_encoding($lv_row['mattxt'] ?? '', 'UTF-8', 'ISO-8859-1'),
                    'matqty'          => (float)$lv_row['matqtypck'],
                    'matqtyhide'      => (float)$lv_row['matqty'],
                    'matuntcod'       => (isset($lv_row['matuntcod']) ? $lv_row['matuntcod'] : $lv_row['matuntcodbse']),
                    'matqtypck'       => ($lv_row['matqtypck'] == null ? 0 : (float)$lv_row['matqtypck']),
                    'matuntcodpck'    => (!empty($lv_row['matuntcodpck']) ? $lv_row['matuntcodpck'] : $lv_row['matuntcod']),
                    'matusebch'       => ($lv_row['matusebch'] ?? 0),
                    'matbchcod'       => $lv_row['matbchcod'],
                    'matbchcodext'    => $lv_row['matbchcodext'],
                    'matbchduedte'    => ($lv_row['matbchduedte'] != null ? (is_array($lv_row['matbchduedte']) ? date('d/m/Y', strtotime($lv_row['matbchduedte']['date'])) : $lv_row['matbchduedte']->format('d/m/Y')) : ''),
                    'matuseser'       => ($lv_row['matuseser'] ?? 0),
                    'matsercod'       => $lv_row['matsercod'],
                    'matsercodext'    => $lv_row['matsercodext'],
                    'docreftyp'       => ($lv_row['docreftyp'] ?? ''),
                    'docrefcod'       => ($lv_row['docrefcod'] ?? 0),
                    'docrefposcod'    => ($lv_row['docrefposcod'] ?? 0),
                    'sysdocrejcod'    => ($lv_row['sysdocrejcod'] ?? 0),
                    'sysdocrsncod'    => ($lv_row['sysdocrsncod'] ?? 0),
                    'docrefsrcqty'    => ($lv_row['refposqty'] ?? '') !== '' ? abs($lv_row['refposqty'] - ($lv_row['matqty'] ?? 0)) : null,
                    'docrefminqty'    => ($lv_row['refposqty'] ?? '') !== '' ? $lv_row['refposqty'] : null,
                    'docrefminqtysrc' => ($lv_row['refposqty'] ?? '') !== '' ? ($lv_row['matqty'] ?? null) : null,
                ];
                
            } else {
                // MODO NO-PICKING: Cada registro es una fila raiz independiente
                $lv_hotmat[] = [
                    'uidxt'       => uniqid('p_'),
                    'is_header_node' => false,
                    'stkmovdocmatcod' => $lv_row['stkmovdocmatcod'],
                    'matcodext'   => ($lv_row['matcodext'] ?? ''),
                    'matcod'      => ($lv_row['matcod'] ?? ''),
                    'mattxt'      => mb_convert_encoding(html_entity_decode($lv_row['mattxt'] ?? ''),'UTF-8' ,'ISO-8859-1'),
                    'matuntcod'   => (!empty($lv_row['matuntcodbse']) ? $lv_row['matuntcodbse'] : $lv_row['matuntcod']),
                    'docreftyp'   => ($lv_row['docreftyp'] ?? ''),
                    'docrefcod'   => ($lv_row['docrefcod'] ?? 0),
                    'docrefposcod'=> ($lv_row['docrefposcod'] ?? 0),
                    'matqty'      => (float)$lv_row['matqty'],
                    'matqtyhide'  => '',
                    'matqtypck'   => (float)($lv_row['matqtypck'] ?? 0),
                    'matuntcodpck'=> (!empty($lv_row['matuntcodpck']) ? $lv_row['matuntcodpck'] : $lv_row['matuntcod']),
                    'matusebch'   => $lv_row['matusebch'],
                    'matuseser'   => $lv_row['matuseser'],
                    'matbchcod'       => $lv_row['matbchcod'],
                    'matbchcodext'    => $lv_row['matbchcodext'],
                    'matbchduedte'    => ($lv_row['matbchduedte'] != null ? (is_array($lv_row['matbchduedte']) ? date('d/m/Y', strtotime($lv_row['matbchduedte']['date'])) : $lv_row['matbchduedte']->format('d/m/Y')) : ''),
                    'matsercod'       => $lv_row['matsercod'],
                    'matsercodext'    => $lv_row['matsercodext'],
                    'sysdocrejcod'    => ($lv_row['sysdocrejcod'] ?? 0),
                    'sysdocrsncod'    => ($lv_row['sysdocrsncod'] ?? 0),
                    'docrefsrcqty'    => ($lv_row['refposqty'] ?? '') !== '' ? abs($lv_row['refposqty'] - ($lv_row['matqty'] ?? 0)) : null,
                    'docrefminqty'    => ($lv_row['refposqty'] ?? '') !== '' ? $lv_row['refposqty'] : null,
                    'docrefminqtysrc' => ($lv_row['refposqty'] ?? '') !== '' ? ($lv_row['matqty'] ?? null) : null,
                    '__children'  => []
                ];
            }
        }
        $lv_buffer = utf8_decode(json_encode($lv_hotmat, JSON_UNESCAPED_UNICODE));
		echo $lv_buffer;
		?>;
      <?=$lv_sec; ?>_hotmatset["data"]=(lv_dat.length != 0)?lv_dat:[{"__children":[], uidxt: "uid_" + Math.random().toString(36).substr(2, 9)}];
      <?= $lv_sec; ?>_hotmat = new Handsontable(<?= $lv_sec; ?>_hotmatcnt, <?= $lv_sec; ?>_hotmatset);	
      if(<?=$vew_readonly || $lv_refdocmdt != '' ?'false':'true'?>){<?=$lv_sec;?>_addBlankRow();  }
      if(lv_dat.length == 0) <?=$lv_sec;?>_hotmat.alter("remove_row",0);			//Borrar fila temporal para no romper nestedRows
			<?= $lv_sec; ?>_hotmat.render();
		});

	</script>
	<script>
		// *********************
		// O R I G E N
		// *********************
		<?php
		switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) ) {
			case 'HHR_EMP': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"hhrempcod", "srcobjtxt":"hhremptxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hhremp", lo_get);
				<?php break;
			case 'STK_STL': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"strloccod", "srcobjtxt":"strloctxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "stkstrloc", lo_get);
				<?php break;
			case 'SLS_CUS': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"cuscod", "srcobjtxt":"custxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "slscus", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #srcobjcod").change(); }});
				<?php break;
			case 'BUY_SUP': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"supcod", "srcobjtxt":"suptxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "buysup", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #srcobjcod").change(); }});
				<?php break;
			case 'CNS_STE': ?>
    		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"stecod", "srcobjtxt":"stetxt"}};
    		tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "cnsste", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #srcobjcod").change(); }});
				<?php break;
			case 'HLT_PAT': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"patcod", "srcobjtxt":"pattxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hltpat", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #srcobjcod").change(); }});
				<?php break;
		}
		?>
	
		<?php
		switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) ) {
			case 'SLS_CUS': case 'BUY_SUP': case 'HLT_PAT':
     		echo 'var lo_get = {"fldsec":"'.$lv_sec.'", "fldasg":{"srccntcod":"cntcod", "srccnttxt":"cnttxt"}, "fldflt":{ "dbo.getTagValue(^dlvadr^_ct.sysdocclsatr)":"X", "c.cntsrctyp": $("#'.$lv_sec.' #srcobjtyp"), "c.cntsrccod" : $("#'.$lv_sec.' #srcobjcod")} };';
 				echo 'tmssTypeahead($("#'.$lv_sec.' #srccnttxt"), "grldatcnt", lo_get);';
				break;
    	case 'CNS_STE':
     		echo 'var lo_get = {"fldsec":"'.$lv_sec.'", "fldasg":{"srccntcod":"cntcod", "srccnttxt":"cnttxt"}, "fldflt":{ "dbo.getTagValue(^dlvadr^_ct.sysdocclsatr)":"X", "c.cntsrctyp": $("#'.$lv_sec.' #srcobjtyp"), "c.cntsrccod" : $("#'.$lv_sec.' #srcobjcod")} };';
 				echo 'tmssTypeahead($("#'.$lv_sec.' #srccnttxt"), "grldatcnt", lo_get);';
    		break;
    }
    ?>
		
		$("#<?= $lv_sec; ?> #srcobjcod").on("change",function(){
			$("#<?= $lv_sec; ?> #srccntcod").prop("value","");
			$("#<?= $lv_sec; ?> #srccnttxt").prop("value","");
		});
		$("#<?= $lv_sec; ?> #dstobjcod").on("change",function(){
			$("#<?= $lv_sec; ?> #dstcntcod").prop("value","");
			$("#<?= $lv_sec; ?> #dstcnttxt").prop("value","");
		});
		
	
		// *********************
		// D E S T I N O
		// *********************
		<?php
		switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')) ) {
			case 'HHR_EMP': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstobjcod":"hhrempcod", "dstobjtxt":"hhremptxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "hhremp", lo_get);
				<?php break;
			case 'STK_STL': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstobjcod":"strloccod", "dstobjtxt":"strloctxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "stkstrloc", lo_get);
				<?php break;
			case 'SLS_CUS': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstobjcod":"cuscod", "dstobjtxt":"custxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "slscus", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #dstobjcod").change(); }});
				<?php break;
			case 'BUY_SUP': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstobjcod":"supcod", "dstobjtxt":"suptxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "buysup", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #dstobjcod").change(); }});
				<?php break;
			case 'CNS_STE': ?>
        var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstobjcod":"stecod", "dstobjtxt":"stetxt"}};
    		tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "cnsste", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #dstobjcod").change(); }});
				<?php break;
				case 'HLT_PAT': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstobjcod":"patcod", "dstobjtxt":"pattxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "hltpat", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #dstobjcod").change(); }});
				<?php break;
			}
		?>		
		
		// destination - info link
		$("#<?= $lv_sec; ?> #dstinflnk").on("click",function(e){ e.preventDefault();
			if ( $("#<?= $lv_sec; ?> #dstobjcod").prop("value")!="" ) {
				tmssCallProcess("?prg=grldatadr&act=03&prm_popup=sysdochdr_popup", {adrsrctyp: $("#<?= $lv_sec; ?> #dstobjtyp").prop("value"), adrsrccod: $("#<?= $lv_sec; ?> #dstobjcod").prop("value")}, function(data) {
					if ( data!="" ) {
						BootstrapDialog.show({
							size: BootstrapDialog.SIZE_WIDE,
							title: "<?= $vew_lang->address; ?>",
							message: $(data)
						});
					}
				});
			}
		});
		
		// destination - info route
		$("#<?= $lv_sec; ?> #dstroulnk").on("click",function(e){ e.preventDefault();
			if ( $("#<?= $lv_sec; ?> #dstobjcod").prop("value")!="" ) {
				tmssCallProcess("?prg=stkmovdoc&act=33", {srcadrsrctyp: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value"), srcadrsrccod: $("#<?= $lv_sec; ?> #srcobjcod").prop("value"), dstadrsrctyp: $("#<?= $lv_sec; ?> #dstobjtyp").prop("value"), dstadrsrccod: $("#<?= $lv_sec; ?> #dstobjcod").prop("value")}, function(data) {
					var lv_mapurl = $("<div>"+data+"</div>").find("mapurl:first").text();
					window.open( lv_mapurl, "_blank" );
				});
			}
		});
		
		<?php
			switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')) ) {
        case 'SLS_CUS': case 'BUY_SUP': case 'HLT_PAT': case 'CNS_STE': ?>
          var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"dstcntcod":"cntcod", "dstcnttxt":"cnttxt"}, "fldflt":{ "dbo.getTagValue(^dlvadr^_ct.sysdocclsatr)":"X", "c.cntsrctyp":$("#<?= $lv_sec; ?> #dstobjtyp"), "c.cntsrccod":$("#<?= $lv_sec; ?> #dstobjcod")} };
          tmssTypeahead($("#<?= $lv_sec; ?> #dstcnttxt"), "grldatcnt", lo_get);
    
					// destination contact - info link
					$("#<?= $lv_sec; ?> #dstcntinflnk").on("click",function(e){ e.preventDefault();
						if ( $("#<?= $lv_sec; ?> #dstcntcod").prop("value")!="" ) {
							tmssCallProcess("?prg=grldatadr&act=03&prm_popup=sysdochdr_popup", {adrsrctyp: "GRL_CCT", adrsrccod: $("#<?= $lv_sec; ?> #dstcntcod").prop("value")}, function(data) {
								if ( data!="" ) {
									BootstrapDialog.show({
										size: BootstrapDialog.SIZE_WIDE,
										title: "<?= $vew_lang->address; ?>",
										message: $(data)
									});
								}
							});
						}
					});
					
					// destination contact - info route
					$("#<?= $lv_sec; ?> #dstcntroulnk").on("click",function(e){ e.preventDefault();
						if ( $("#<?= $lv_sec; ?> #dstcntcod").prop("value")!="" ) {
							tmssCallProcess("?prg=stkmovdoc&act=33", {srcadrsrctyp: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value"), srcadrsrccod: $("#<?= $lv_sec; ?> #srcobjcod").prop("value"), dstadrsrctyp: "GRL_CCT", dstadrsrccod: $("#<?= $lv_sec; ?> #dstcntcod").prop("value")}, function(data) {
								var lv_mapurl = $("<div>"+data+"</div>").find("mapurl:first").text();
								window.open( lv_mapurl, "_blank" );
							});
						}
					});			
			<?php	break; } ?>
	</script>
	<?php
		//
		//
		//   R U T A S
		//
		//
		if($lv_logtrarel!=''){ ?>
		<script>
      var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"traroucod":"traroucod", "traroutxt":"traroutxt"}};
      tmssTypeahead($("#<?= $lv_sec; ?> #traroutxt"), "logtrarou", lo_get);
      
			// ACTUALIZACION AUTOMATICA DE RUTA
			$("#<?= $lv_sec; ?> #srcobjcod, #<?= $lv_sec; ?> #srccntcod, #<?= $lv_sec; ?> #dstobjcod, #<?= $lv_sec; ?> #dstcntcod").on("change",function(e){
				if( ("<?= $lv_objtyp; ?>"=="STK_SOU" && ($(this).prop("id")=="dstobjcod" || $(this).prop("id")=="dstcntcod")) ||
						("<?= $lv_objtyp; ?>"=="STK_SIN" && ($(this).prop("id")=="srcobjcod" || $(this).prop("id")=="srccntcod")) ) {
						<?= $lv_sec; ?>_routeRefresh();
				}
			});
			
			// DETERMINACION DE RUTA
			function <?= $lv_sec; ?>_routeRefresh() {
				var lv_srcobjtyp = "<?= strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, ($lv_objtyp=='STK_SOU'?'dstobjtyp':'srcobjtyp') )); ?>";
				var lv_srcobjcod = $("#<?= $lv_sec; ?> <?= ($lv_objtyp=='STK_SOU'?'#dstobjcod':'#srcobjcod'); ?>").prop("value");
				var lv_srccntcod = $("#<?= $lv_sec; ?> <?= ($lv_objtyp=='STK_SOU'?'#dstcntcod':'#srccntcod'); ?>").prop("value");
				var lv_pstdat = [{name:"srcobjtyp", value:lv_srcobjtyp},{name:"srcobjcod",value:lv_srcobjcod},{name:"srccntcod",value:lv_srccntcod}];
				tmssCallProcess("?prg=logtrarou&act=33",lv_pstdat,function(data){
					var lv_traroucod = "";
					var lv_traroutxt = ""
					if(Array.isArray(data)){
						if(data.length>0){
							lv_traroucod = data[0].traroucod;
							lv_traroutxt = data[0].traroutxt;
						}
					}
					$("#<?= $lv_sec; ?> #traroucod").prop("value",lv_traroucod);
					$("#<?= $lv_sec; ?> #traroutxt").prop("value",lv_traroutxt);
				});
			}		
		</script>
	<?php } ?>
	<div id="rowfrm" class="hidden">
		<form class="form-horizontal tmss-form-horizontal" style="padding-top: 0px; padding-bottom: 0px;">
    <?= vew_boot($lv_col210,array('label'=>$vew_lang->orderreason,'input'=>gethtml('rowstkmovdocmatrsncod', $lv_rsnarr, '', $lv_default2) )); ?>     
		<?= vew_boot($lv_col210, array('label'=>$vew_lang->rejection,	'input'=>gethtml('rowstkmovdocmatrejcod', $lv_rejarr, '', $lv_default2) )); ?>
		</form>
	</div>
	<script>		
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
			var lv_id = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"stkmovdocmatcod");
			BootstrapDialog.show({
				title: "Datos Adicionales <small>#"+lv_id+"</small>", 
				message: $("#<?= $lv_sec; ?> #rowfrm > form").clone(), 
				type: BootstrapDialog.TYPE_INFO,
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-primary",	action: function(dialogItself){
										<?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"sysdocrsncod",dialogItself.getModalBody().find("#rowstkmovdocmatrsncod").val());
										<?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"sysdocrejcod",dialogItself.getModalBody().find("#rowstkmovdocmatrejcod").val());
										dialogItself.close();
									}
								}],
				onshow: function(dialog) {
					// asigno valores de la grilla
					var lv_frm = $(dialog.$modalContent);
					$(lv_frm).find("#rowstkmovdocmatrsncod").prop("value", <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"sysdocrsncod") );
					$(lv_frm).find("#rowstkmovdocmatrejcod").prop("value", <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"sysdocrejcod") );
				}
			});
		}
	</script>
  <script>			
		// server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {
			var lv_error = (data.hasOwnProperty("errcod")?(data.errcod==0?false:true):false);
			
			// BORRAR. documento borrado se cierra la seccion
			if(lv_error==false && gv_<?= $lv_sec; ?>_last_action=="04") {
				tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				return;
			
			// CONTABILIZAR. documento contabilizado, se actualiza seccion
			} else if(lv_error==false && gv_<?= $lv_sec; ?>_last_action=="09") {
				toastr.info("Documento <b>"+$("#<?= $lv_sec; ?> #stkmovdoccod").prop("value")+"</b> contabilizado.", "<?= $lv_title; ?>");
				<?= $lv_sec; ?>_fnc({action: "99"});
				return;
			
			// GRABADO/OTRO. documento grabado, se muestra pantalla actualizada
			} else if(lv_error==false) {
				$("#<?= $lv_sec; ?>").replaceWith( data );
				return;
				
			// ERROR MATERIAL. si el error esta relacionado a un material
			} else if( data.hasOwnProperty("errmat") && data.errmat != ""){
				var lv_mat = <?= $lv_sec; ?>_hotmat.getSourceData();
				var lv_errmat = JSON.parse( data.errmat );
				for(var x=0; x<lv_mat.length; x++){
					var lv_found=false;
					for(var i=0; i<lv_errmat.length; i++){
						if( lv_mat[x].matcod==lv_errmat[i].matcod && 
								(lv_errmat[i].hasOwnProperty("matbchcodext") ? lv_mat[x].matbchcodext==lv_errmat[i].matbchcodext : true ) && 
								(lv_errmat[i].hasOwnProperty("matsercodext") ? lv_mat[x].matsercodext==lv_errmat[i].matsercodext : true ) ){
							lv_found=true;
							<?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matqty"), "valid", false);
							if(lv_errmat[i].hasOwnProperty("matbchcodext")){ <?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matbchcodext"), "valid", false); }
							if(lv_errmat[i].hasOwnProperty("matbchcodext")){ <?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matbchduedte"), "valid", false); }
							if(lv_errmat[i].hasOwnProperty("matsercodext")){ <?= $lv_sec; ?>_hotmat.setCellMeta(x, <?= $lv_sec; ?>_hotmat.propToCol("matsercodext"), "valid", false); }
						}
					}
					// fila valida, actualizo status
					if(lv_found==false){
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 2, "valid", true);
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 4, "valid", true);
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 6, "valid", true);
						<?= $lv_sec; ?>_hotmat.setCellMeta(x, 7, "valid", true);
					}
				}
				// render de tabla
				<?= $lv_sec; ?>_hotmat.render();

			// ERORR GENERAL. es un error general, se informa mensaje unicamente
			} else {
				toastr.warning(data.errcod+": "+data.errtxt);
				return;
			}
			
      // control de materiales al grabar
      if ( gv_<?= $lv_sec; ?>_last_action=="00" ) {
        if(data.hasOwnProperty("errmat")){
          var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
          var a = String.fromCharCode(9);
          var lv_err = data.errmat.split('\n');
          var lv_found;
          for(var i=0; i<lv_dat.length; i++){
            lv_found==false;
            for(var x=0; x<lv_err.length; x++){
              // errores de stock
              if( (data.errcod==-1 || data.errcod==-701 || data.errcod==-601) && lv_err[x].trim()==lv_dat[i].matcod ) {
                lv_found==true;
                <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matqty"), "valid", false);
              // errores de lote
              } else if ( (data.errcod==-302 || data.errcod==-402 || data.errcod==-502 || data.errcod==-602) && lv_err[x].trim()==lv_dat[i].matcod) {
                  lv_found==true;
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matbchcodext"), "valid", true);
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matbchduedte"), "valid", true);
                // errores de nros de serie
                } else if ( (data.errcod==-403 || data.errcod==-503 || data.errcod==-603) && lv_err[x].trim()==lv_dat[i].matcod) {
                  lv_found==true;
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matsercodext"), "valid", false);
                //Error de unidades de conversion
                }else if(data.errcod == -4 && lv_err[x].trim()==lv_dat[i].matcod){
                   lv_found==true;
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matuntcod"), "valid", false);
                }
            }
            if(lv_found==false){
              <?= $lv_sec; ?>_hotmat.setCellMeta(i, 2, "valid", true);
              <?= $lv_sec; ?>_hotmat.setCellMeta(i, 4, "valid", true);
              <?= $lv_sec; ?>_hotmat.setCellMeta(i, 6, "valid", true);
              <?= $lv_sec; ?>_hotmat.setCellMeta(i, 7, "valid", true);
            }
          }
          <?= $lv_sec; ?>_hotmat.render();
        }      
      }
      
			// accounting
			if ( gv_<?= $lv_sec; ?>_last_action=="09" ) {
				if(data.errtyp=="S" || data.errtyp=="W"){
					toastr.info("Documento <b>"+$("#<?= $lv_sec; ?> #stkmovdoccod").prop("value")+"</b> contabilizado.", "<?= $lv_title; ?>");
					<?= $lv_sec; ?>_fnc({action: "99"});
					return;
				} else {
          toastr.warning(data.errcod+": "+data.errtxt);
          if(data.hasOwnProperty("errmat")){
            var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData(); //Datos handsontable
            var a = String.fromCharCode(9);
            var lv_err = data.errmat.split( String.fromCharCode(9) );
            var lv_found;
            for(var i=0; i<lv_dat.length; i++){
              lv_found==false;
              for(var x=0; x<lv_err.length; x++){
                // errores de stock
                if ( data.errcod==-601 && lv_err[x]==lv_dat[i].matcod+String.fromCharCode(10)+String.fromCharCode(10) ) {
                  lv_found==true;
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, 2, "valid", false);
                // errores de lote
                } else if ( (data.errcod==-302 || data.errcod==-402 || data.errcod==-502 || data.errcod==-602) && lv_err[x]==lv_dat[i].matcod+String.fromCharCode(10)+lv_dat[i].matbchcodext+String.fromCharCode(10) ) {
                  lv_found==true;
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matbchcodext"), "valid", false);
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matbchduedte"), "valid", false);
                // errores de nros de serie
                } else if ( (data.errcod==-403 || data.errcod==-503 || data.errcod==-603) && lv_err[x]==lv_dat[i].matcod+String.fromCharCode(10)+String.fromCharCode(10)+lv_dat[i].matsercodext ) {
                  lv_found==true;
                  <?= $lv_sec; ?>_hotmat.setCellMeta(i, <?= $lv_sec; ?>_hotmat.propToCol("matsercodext"), "valid", false);
                } 
              }
              if(lv_found==false){
                <?= $lv_sec; ?>_hotmat.setCellMeta(i, 2, "valid", true);
                <?= $lv_sec; ?>_hotmat.setCellMeta(i, 4, "valid", true);
                <?= $lv_sec; ?>_hotmat.setCellMeta(i, 6, "valid", true);
                <?= $lv_sec; ?>_hotmat.setCellMeta(i, 7, "valid", true);
              }
            }
            <?= $lv_sec; ?>_hotmat.render();
          }
				}
			// others
			} else if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}			
			}
    }
		
		// SUBMIT. prepara los datos antes de grabar
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			
			// NUEVO
			if ( lp_prm["action"]=="01" ) {
				var lv_pstdat = [{name: "mdlcod", value:"<?= $lv_mdlcod; ?>"},{name:"prgcod",value:"<?= $lv_prgcod; ?>"},{name:"sysdocclscod",value:"<?= $vew_data->sysdocclscod; ?>"}];
				tmssLink("?prg=stkmovdoc&act=01", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat}]);
				return false;

			// BORRAR
			} else if ( lp_prm["action"]=="04" && "<?= ($lv_docrefsrc?'1':''); ?>"=="1") {
				toastr.warning("No se puede borrar el documento. Una o mas posiciones han sido referenciadas por otros documentos.");
				return false;

			// GRABAR / CONTABILIZAR
			} else if ( lp_prm["action"]=="00" || lp_prm["action"]=="09" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
			
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
				var lv_arr = new Array();
				
				var processedNodes = [];
				function _flattenData(nodes) {
					for (var i=0; i<nodes.length; i++) {
						var node = nodes[i];
						var node_uid = node["uidxt"] || "unknown";
						if (node_uid !== "unknown" && processedNodes.indexOf(node_uid) !== -1) continue;
						
						if ( node["mattxt"]!="" && node["mattxt"]!=undefined ) {
							if (node_uid !== "unknown") processedNodes.push(node_uid);
							var is_parent_header = (node["is_header_node"] === true);
							var is_parent_with_children = (node["__children"] && node["__children"].length > 0);
							
							if ( !is_parent_header || "<?=$lv_matpckrel;?>" == "" ) {
								lv_arr.push({	"stkmovdocmatcod":node["stkmovdocmatcod"],
															"matcod":node["matcod"],
															"matcodext":node["matcodext"],
															"mattxt":node["mattxt"],
															"matqty":((<?=$lv_matpckrel!=''?'true':'false'?>)?(node["matqtyhide"] !== undefined && node["matqtyhide"] !== "" ? node["matqtyhide"] : node["matqty"]):node["matqty"]),
															"matuntcod":node["matuntcod"],
															"matqtypck":node["matqtypck"],
															"matuntcodpck":node["matuntcodpck"],
															"matbchcod":node["matbchcod"],
															"matbchcodext":node["matbchcodext"],
															"matbchduedte":node["matbchduedte"],
															"matsercod":node["matsercod"],
															"matsercodext":node["matsercodext"],
															"docreftyp":node["docreftyp"],
															"docrefcod":node["docrefcod"],
															"docrefposcod":node["docrefposcod"],
															"sysdocrejcod":node["sysdocrejcod"],
															"sysdocrsncod":node["sysdocrsncod"]
														});
							}
							
							if ( is_parent_with_children ) {
								_flattenData(node["__children"]);
							}
						}
					}
				}
				_flattenData(lo_dat);
				
				// validacion de tabla vacia al contabilizar
				if ( lp_prm["action"]=="09" && lv_arr.length==0 ) {
					toastr.warning("La tabla de materiales no puede estar vac&iacute;a.");
					return false;
				}
				
				if ( lp_prm["action"]=="09" && "<?=$lv_matpckrel;?>" != "" ) {
					for (var i=0; i<lv_arr.length; i++) {
						if (parseFloat(lv_arr[i].matqty) === 0 || parseFloat(lv_arr[i].matqtypck) === 0) {
							toastr.warning("Las cantidades no pueden estar en 0.");
							return false;
						}
					}
				}

				// agrego las filas eliminadas
				for (var i=0; i < <?= $lv_sec; ?>_hotmatdel.length; i++) {
					lv_arr.push({	"stkmovdocmatcod":<?= $lv_sec; ?>_hotmatdel[i]["stkmovdocmatcod"],
                       	"matcod":<?= $lv_sec; ?>_hotmatdel[i]["matcod"],
												"docreftyp":<?= $lv_sec; ?>_hotmatdel[i]["docreftyp"],
												"docrefcod":<?= $lv_sec; ?>_hotmatdel[i]["docrefcod"],
												"docrefposcod":<?= $lv_sec; ?>_hotmatdel[i]["docrefposcod"],
												"matqty":<?= $lv_sec; ?>_hotmatdel[i]["matqty"],
												"matuntcod":<?= $lv_sec; ?>_hotmatdel[i]["matuntcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #stkmovdocmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmovdocmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>