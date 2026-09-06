<?php
	// url del formulario
  $lv_lnk = '?prg=grlprccndacc';

	// campos requeridos
	$vew_input->RequiredFields( array('prccndacctxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prccndacccod; 

	// titulo
	$lv_title = $vew_lang->access;
	
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PCA';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('prccndaccfld', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prccndacccod; ?><?= gethtml('prccndacccod', 'hidden', $vew_data->prccndacccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
              	<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,  			'input'=>gethtml('prccndacccodext', 'doccmt1x20', $vew_data->prccndacccodext, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('prccndacctxt', 'doccmt1x50', $vew_data->prccndacctxt, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->sequence; ?><a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a></div></div>
                <div class="card-body">
                  <div id="accdattbl"></div>
                </div>
              </div>
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
    
  </form>
	<script>
		//C A M P O S
    var gv_<?= $lv_sec; ?>_fldcfg = {
      readOnly: "<?= $vew_readonly?>",
      headerData: [{title: "<?= $vew_lang->code; ?>", width:"50%"}, {title: "<?= $vew_lang->name; ?>", width:"50%"}],
      columnsData: [{id: "prccndaccfldcod"},
                   {id: "prccndaccfldtxt"}],
      showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
    };
    
    var gv_<?= $lv_sec; ?>_flddat = [<?php
				$lv_buffer='';
      	$lv_fld = $vew_doc->getTagValue($vew_data->prccndaccatr,'fld');
				$lv_fldarr = json_decode( html_entity_decode($lv_fld) ,true);
				if($lv_fldarr!=NULL){
          foreach($lv_fldarr as $lv_row){ 
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
              'prccndaccfldcod:"'.$lv_row['prccndaccfldcod'].'",'.
              'prccndaccfldtxt:"'.$lv_row['prccndaccfldtxt'].'"'.
              '}'; 
          }
        }
				echo $lv_buffer;
    ?>];
    
    var go_<?= $lv_sec; ?>_fldtbl = new tmssTable($("#<?= $lv_sec; ?> #accdattbl"), gv_<?= $lv_sec; ?>_fldcfg);
    go_<?= $lv_sec; ?>_fldtbl.loadData(gv_<?= $lv_sec; ?>_flddat);
	</script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			
      // al grabar
			if(lp_prm["action"]=="00"){
				
        var lv_dat = go_<?= $lv_sec; ?>_fldtbl.getData();
				var lv_arr = new Array();
        
        for(let i=0; i < lv_dat.length; i++){
        	if(lv_dat[i]["prccndaccfldcod"] != "" && lv_dat[i]["prccndaccfldtxt"]!=""){
            lv_arr.push(lv_dat[i]);
          }
        }
        
        if(!lv_arr.length){ 
          toastr.warning("La secuencia de acceso debe tener definida una o mas secuencias.");
					return false;
        }				
				
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prccndaccfld").val("");						
				} else {
					$("#<?= $lv_sec; ?> #prccndaccfld").val( JSON.stringify( lv_arr ) );
				}

			}
		}
    
    function <?= $lv_sec; ?>_formeditext( lp_prm ) { 
      tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>, $("#<?= $lv_sec; ?> #accdattbl input"));
    }
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>