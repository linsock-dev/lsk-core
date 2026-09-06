<?php
	// url del formulario
  $lv_lnk = '?prg=crmcnt&act=ctr';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = ''; //$vew_data->crmcntcod;

	// titulo
	$lv_title = $vew_lang->contactcenter;

	// m dulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';

	$vew_actcod = '01';

	// librer a de estilos bootstrap
	include_once('_library.frm');

	// config botones navbar
	$vew_tbl = array();
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['new'] = array('css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn','acc'=>$lv_sec.'_createContact();');
	$vew_dropdown = false;

	$lv_srcobjtyp = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,"srcobjtyp");
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">	
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
  	<?php 
    	echo gethtml('tmss_actcod', 'hidden', ''); 
    	echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); 
    	echo gethtml('crmcntsrctyp', 'hidden', $lv_srcobjtyp);  
    ?>
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-4">
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <?php 
                $lv_lbl = $vew_lang->contact;
                switch( $lv_srcobjtyp ) {
                  case 'SLS_CUS': $lv_lbl = $vew_lang->customer; break;
                  case 'HLT_PAT': $lv_lbl = $vew_lang->patient; break;
                  case 'HLT_PRS': $lv_lbl = $vew_lang->lender; break;
                  case 'EDU_STU': $lv_lbl = $vew_lang->student; break;
                  case 'EDU_TCH': $lv_lbl = $vew_lang->teachers; break;
                }
                echo vew_boot($lv_col39, array('label'=>$lv_lbl,
                                              'input'=>vew_boot(	array('style'=>'search', 'readonly'=>false ),
                                                                  array('input'=>gethtml('fndstr', 'typeahead', '', $lv_default ) ))
                                            ));
              ?>
              </div>
            </div>
            <div class="card-body tmss-bold">
              <?php
							echo vew_boot($lv_col39, array('label'=>$vew_lang->id, 'input'=>gethtml('crmcntsrccod','doccmt1x50',$vew_data->crmcntsrccod,$lv_always_disabled) ));
							echo vew_boot($lv_col39, array('label'=>$vew_lang->name, 'input'=>gethtml('crmcntsrctxt','doccmt1x50',$vew_data->crmcntsrctxt,$lv_always_disabled) ));
							echo vew_boot($lv_col39, array('label'=>$vew_lang->identification, 'input'=>gethtml('cntidt','doccmt1x50',$vew_data->cntidt,$lv_always_disabled) ));
							echo vew_boot($lv_col39, array('label'=>$vew_lang->email, 'input'=>gethtml('cnteml','doccmt1x50',$vew_data->cnteml,$lv_always_disabled) ));
							echo vew_boot($lv_col39, array('label'=>$vew_lang->phone, 'input'=>gethtml('cntphn002','doccmt1x50',$vew_data->cntphn001,$lv_always_disabled) ));
							echo vew_boot($lv_col39, array('label'=>$vew_lang->phone, 'input'=>gethtml('cntphn002','doccmt1x50',$vew_data->cntphn002,$lv_always_disabled) ));
							echo vew_boot($lv_col39, array('label'=>$vew_lang->mobilephone, 'input'=>gethtml('cntmbl','doccmt1x50',$vew_data->cntmbl,$lv_always_disabled) ));
							?>
            </div>
						<div class="" id="zcuinfbox"></div>
          </div>
        </div>
        
        <div class="col-md-8">
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                Ultimos contactos
                <a class="pull-right" id="btnHstRfh"><i class="fas fa-sync-alt"></i></a>
              </div>
            </div>
            <div class="card-body">
              <div id="cnthst"></div>
            </div>
          </div>
        </div>
      </div> <!-- /row -->	
    </div> <!-- /container-fluid -->
  </form>
	<script>
		$(function(){
			<?php 
				switch ($lv_srcobjtyp) { 
					case 'SLS_CUS':
						echo 'var lo_get = {"fldsec" : "'.$lv_sec.'", "fldasg" : {"crmcntsrccod":"cuscod", "crmcntsrctxt" : "custxt", "cntphn001":"adrphn001", "cntphn002":"adrphn002", "cntmbl":"adrmblphn", "cnteml":"adreml","cntidt":"taxcod"}};';
						echo 'tmssTypeahead($("#'.$lv_sec.' #fndstr"), "slscus", lo_get, {"afterAssign":lv_crmfnc });';
						break;
					case 'HLT_PAT':
						echo 'var lo_get = {"fldsec" : "'.$lv_sec.'", "fldasg" : {"crmcntsrccod":"patcod", "crmcntsrctxt":"pattxt", "cntphn001":"adrphn001", "cntphn002":"adrphn002", "cntmbl":"adrmblphn", "cnteml":"adreml","cntidt":"taxcod"}};';
						echo 'tmssTypeahead($("#'.$lv_sec.' #fndstr"), "hltpattxtfnd", lo_get, {"afterAssign":lv_crmfnc });';
						break;
					case 'HLT_PRS':
						echo 'var lo_get = {"fldsec" : "'.$lv_sec.'", "fldasg" : {"crmcntsrccod":"prscod", "crmcntsrctxt":"prstxt", "cntphn001":"adrphn001", "cntphn002":"adrphn002", "cntmbl":"adrmblphn", "cnteml":"adreml","cntidt":"taxcod"}};';
						echo 'tmssTypeahead($("#'.$lv_sec.' #fndstr"), "hltprs", lo_get, {"afterAssign":lv_crmfnc });';
						break;					
					case 'EDU_STU':
						echo 'var lo_get = {"fldsec" : "'.$lv_sec.'", "fldasg" : {"crmcntsrccod":"stucod", "crmcntsrctxt" : "stutxt", "cntphn001":"adrphn001", "cntphn002":"adrphn002", "cntmbl":"adrmblphn", "cnteml":"adreml","cntidt":"taxcod"}};';
						echo 'tmssTypeahead($("#'.$lv_sec.' #fndstr"), "edustu", lo_get, {"afterAssign":lv_crmfnc });';
						break;
					case 'EDU_TCH':
						echo 'var lo_get = {"fldsec" : "'.$lv_sec.'", "fldasg" : {"crmcntsrccod":"tchcod", "crmcntsrctxt" : "tchtxt", "cntphn001":"adrphn001", "cntphn002":"adrphn002", "cntmbl":"adrmblphn", "cnteml":"adreml","cntidt":"taxcod"}};';
						echo 'tmssTypeahead($("#'.$lv_sec.' #fndstr"), "edutch", lo_get, {"afterAssign":lv_crmfnc });';
						break;
				}
				if($vew_data->crmcntsrccod!=''){ echo $lv_sec.'_showHistory();'; }
			?>
		});
    
		
		// nuevo contacto
		function <?= $lv_sec; ?>_createContact() {
			if ( $("#<?= $lv_sec; ?> #crmcntsrccod").val()=="" ) { 
				toastr.warning("Por favor, seleccione un contacto.");
				$("#<?= $lv_sec; ?> #fndstr").focus();
				return false;
			}
			tmssLink("?prg=crmcnt&act=01&prm_crmcntsrctyp="+$("#<?= $lv_sec; ?> #crmcntsrctyp").prop("value")+"&prm_crmcntsrccod="+$("#<?= $lv_sec; ?> #crmcntsrccod").prop("value"),
								[{target: "_new_section", post_data: [{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")}, {name:"crmcntsrctxt",value:$("#<?= $lv_sec; ?> #crmcntsrctxt").prop("value")}]  }]);
		}
    
		
    // mostrar contacto
    $("#<?= $lv_sec; ?> #cnthst").on("click", "tr[name='cnthstlst']", function(e){ 
			if ( $("#<?= $lv_sec; ?> #crmcntsrccod").val()=="" ) { return false; }
			tmssLink("?prg=crmcnt&act=03&prm_popup=1&prm_crmcntcod="+$(this).data("crmcntcod"), [{target: "_new_section"}]);
    });

    
    // mostrar historial
		function <?= $lv_sec; ?>_showHistory() { 
			if ( $("#<?= $lv_sec; ?> #crmcntsrccod").val()=="" ) { return false; }
			var lv_pstdat = [{name:"crmcntsrctyp", value:$("#<?= $lv_sec; ?> #crmcntsrctyp").val()}, {name:"crmcntsrccod", value:$("#<?= $lv_sec; ?> #crmcntsrccod").val()}];
			tmssCallProcess("?prg=crmcnt&act=19",lv_pstdat,function( data ){
        var lv_buffer = "";
        if(data.length>0){ 
          lv_buffer = "<div class='tmss-vertbl-scroll'><table class='table table-condensed table-hover'>"
          	+ "<thead><tr><th><?= $vew_lang->date; ?></th><th><?= $vew_lang->type; ?></th><th><?= $vew_lang->motive; ?></th><th><?= $vew_lang->title; ?></th><th><?= $vew_lang->expiration; ?></th><th><?= $vew_lang->status; ?></th></tr></thead>"
            + "<tbody>";
          
          for(let i=0; i < data.length; i++){
            lv_buffer+=
              "<tr class='cursor-pointer' name='cnthstlst' data-crmcntcod='"+data[i]["crmcntcod"]+"'>"
              	+ "<td>"+ moment( data[i]["crmcntreqdte"]['date'] ).format("DD/MM/Y") +"</td>"
            		+ "<td>"+ data[i]["crmcnttyptxt"] +"</td>"
            		+ "<td>"+ data[i]["crmcntmtvtxt"] +"</td>"
            		+ "<td>"+ data[i]["crmcnttxt"] +"</td>"
              	+ "<td>"+ (data[i]["crmcntduedte"]==null ? "" : moment(data[i]["crmcntduedte"]["date"],"YYYY-MM-DD HH:mm:ss").format("DD/MM/Y") )+"</td>"
            		+ "<td>"+ data[i]["crmcntststxt"] +"</td>"
              + "</tr>";
          }
          lv_buffer += "</tbody></table></div>";
        }else{
          lv_buffer = "<p>No se encontraron entradas.</p>";
        }
        
				$("#<?= $lv_sec; ?> #cnthst").html( lv_buffer );
			});
		}
    
		
		// refresh historial
    $("#<?= $lv_sec; ?> #btnHstRfh").on("click",function(e){ 
			if($("#<?= $lv_sec; ?> #crmcntsrccod").val()==""){ return false; }
      <?= $lv_sec; ?>_showHistory(); 
    });
		
		
    // refresh general
		function <?= $lv_sec; ?>_GridRefresh() {
			<?= $lv_sec; ?>_showHistory();
		}
    
    
    // mostrar datos de contacto
		var lv_crmfnc = function <?= $lv_sec; ?>_showData( lp_obj ) {
      // obtiene info del contacto que varía según el cliente (zcu)
			<?php
				$lv_infbox = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'CtroConInfBox');
				if ( $lv_infbox!='' ) {
					?>
					tmssCallProcess("<?= $lv_infbox; ?>",[{name:"crmcntsrctyp", value: $("#<?= $lv_sec; ?> #crmcntsrctyp").val()}, {name: "crmcntsrccod", value: $("#<?= $lv_sec; ?> #crmcntsrccod").val()}],function( data ) {
						$("#<?= $lv_sec; ?> #zcuinfbox").html( data ); 
					});
			<?php } ?>
      
      // actualiza historial
			<?= $lv_sec; ?>_showHistory();
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section> 