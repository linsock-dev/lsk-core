<?php
	// url del formulario 
  $lv_lnk = '?prg=slsprc&prm_slsprclstcod='.$vew_data->slsprclstcod;
	
	// campos requeridos 
	$vew_input->RequiredFields( array('slsprclsttxt','curcod','slsprclsttyp','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->slsprclstcod;

	// titulo 
	$lv_title = $vew_lang->pricelist;
	
	// módulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'PRC';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?> 
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->slsprclstcod; ?><?= gethtml('slsprclstcod','hidden',$vew_data->slsprclstcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">	
          <div class="row">
            <div class="col-md-6">
							
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->PriceList; ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    	<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('slsprclstcodext', 'doccmt1x20', $vew_data->slsprclstcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('slsprclsttxt', 'doccmt1x50', $vew_data->slsprclsttxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->currency,   'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->slsprclstcod==''?$vew_readonly:true) ), array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled ) )) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
							
            </div>
            <div class="col-md-6">

							<?php if($vew_data->slsprclstcod!=''){ ?>
              <div class="card">
                <div class="card-header">
									<div class="card-title"><?= $vew_lang->validity2; ?>
										<?php if($vew_sec->hasPermission('SLS','PRC','02')){ ?><a id="btnaddver" class="card-icon tmssAlwaysEnabled" title="<?= $vew_lang->add; ?>" ><i class="far fa-plus"></i></a><?php } ?>
									</div>
								</div>
                <div class="card-body tmss-card-body-edit">
									<table id="tblver" class="table">
										<thead><tr><th><?= $vew_lang->validity; ?></th><th><?= $vew_lang->base; ?></th><th width="50"></th></tr></thead>
										<tbody></tbody>
									</table>
								</div>
							</div>
							<?php } ?>
							
            </div>
          </div>
					
        </div><!-- /tab001 -->
      </div><!-- /tab-content -->
    </div> <!-- /container-fluid -->    
	</form>
	<script> 
    	// curcod
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"curcod":"curcod"}, "typeahead": false};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
		
		// VERSIONES
		// actualiza la lista de versiones
		function <?= $lv_sec; ?>_refreshVersionList(){
			$("#<?= $lv_sec; ?> #tblver tbody").empty();
			$("#<?= $lv_sec; ?> #tblver tbody").append("<tr><td colspan=10 class='text-center'><i class='far fa-gear fa-spin'></i></td></tr>");
			var lv_pstdat = [{name:"slsprclstcod",value:"<?= $vew_data->slsprclstcod; ?>"}];
			tmssCallProcessNoBackdrop("?prg=slsprcver&act=18",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #tblver tbody").empty();
				if(data.length==0){
					$("#<?= $lv_sec; ?> #tblver tbody").append("<tr><td colspan=10 class='text-danger'>No hay precios cargados. Cree una nueva lista usando el boton +.</td></tr>");					
				} else {
					for(var i=0; i<data.length; i++){ $("#<?= $lv_sec; ?> #tblver tbody").append("<tr><td><a href'#' name='slsprclstvercod' data-slsprclstvercod='"+data[i].slsprclstvercod+"' style='cursor:pointer;'>"+moment(data[i].slsprclststrdte.date).format("DD.MM.YYYY")+"</a></td><td>"+(data[i].slsprclstancsrc==1?"<?= $vew_lang->cost; ?>":(data[i].slsprclstancsrc==2?"<?= $vew_lang->price; ?>":"<?= $vew_lang->manual; ?>"))+"</td><td><a href='#' data-slsprclstvercod='"+data[i].slsprclstvercod+"' class='card-icon'><i class='far <?= ($vew_sec->hasPermission('SLS','PRC','02')?'fa-pencil':'fa-eye'); ?>'></i></a></td></tr>"); }
					$("#<?= $lv_sec; ?> #tblver tbody a[name='slsprclstvercod']").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_showPriceList($(this).data("slsprclstvercod")); });
					$("#<?= $lv_sec; ?> #tblver tbody tr td a.card-icon").on("click",function(e){ e.preventDefault(); e.stopPropagation(); <?= $lv_sec; ?>_showPriceVersion($("#<?= $lv_sec; ?> #slsprclstcod").prop("value"), $(this).data("slsprclstvercod")); });
				}
			});
		}

		// muestra el dialogo de version
		function <?= $lv_sec; ?>_showPriceVersion(lp_slsprclstcod, lp_slsprclstvercod){
			var lv_pstdat =[{name:"slsprclstvercod",value:lp_slsprclstvercod},
											{name:"slsprclstcod",value:lp_slsprclstcod}];
			tmssCallProcess("?prg=slsprcver&act="+(lp_slsprclstvercod==""?"01":"03"), lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->version; ?>",
					message: $(data),
					closable: true,
          draggable: true,
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE
					<?php if($vew_sec->hasPermission('SLS','PRC','02')){ ?>
					,buttons:[{label: "<?= $vew_lang->delete; ?>", cssClass: "btn-danger pull-left"+(lp_slsprclstvercod==""?" hidden":""), action: function(dialogItself){ $(dialogItself.$modalBody).find("#btndelete").trigger("click");} },
										{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
										{label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
					<?php } ?>
          ,onhide:function(dialogRef){
            <?= $lv_sec; ?>_refreshVersionList();
          }
				});
			});	
		}

		// agregar nueva version
		$("#<?= $lv_sec; ?> #btnaddver").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_showPriceVersion($("#<?= $lv_sec; ?> #slsprclstcod").prop("value"), "");
		});

		// muestra los precios de una version
		function <?= $lv_sec; ?>_showPriceList( lp_vercod ){
			tmssLink("?prg=slsprclst&act=03&prm_mdlcod=sls&prm_prgcod=prl",[{target:"_new_section",
																			 post_data:[{name:"slsprclstcod",value:$("#<?= $lv_sec; ?> #slsprclstcod").val()},
																									{name:"slsprclstvercod",value:lp_vercod}]
																			}]);
		}
		
		<?php if($vew_data->slsprclstcod!=''){ ?>$(function(){ <?= $lv_sec; ?>_refreshVersionList(); });<?php } ?>
	</script>	
	<?php include('grldocfrmscr.frm'); ?>
</section>