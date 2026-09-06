<?php		
	// url del formulario
  $lv_lnk = '?prg=hhrlic&prm_hhrliccod='.$vew_data->hhrliccod;

	// campos requeridos
	$vew_input->RequiredFields( array('srcobjtxt','srcobjcod','hhrlictypcod','hhrlictyptxt','hhrlicdtestr','hhrlicdteend','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrliccod;

	// titulo
	$lv_title = $vew_lang->licences;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LIC';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));	

	// blqueos de períodos
	$vew_lck_total=false;
	$vew_lck_parcial=false;
	$lv_minstrdte = date_create_from_format('d/m/Y',$vew_data->minstrdte);
	$lv_maxenddte = date_create_from_format('d/m/Y',$vew_data->maxenddte);
	
	if($vew_data->hhrliccod!=''){
		if($vew_data->hhrlicdteend < $lv_minstrdte){
			$vew_lck_total=true;
		} else if($vew_data->hhrlicdtestr < $lv_minstrdte) {
			$vew_lck_parcial=true;
		}
	}
	$lv_default_dte = $lv_default;
	if($vew_data->minstrdte!=''){ $lv_default_dte['data-date-start-date'] = $lv_minstrdte->format('d/m/Y'); }
	if($vew_data->maxenddte!=''){ $lv_default_dte['data-date-end-date'] = $lv_maxenddte->format('d/m/Y'); }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('hhrchrtypcodlst','hidden',''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->licence; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrliccod; ?><?= gethtml('hhrliccod','hidden',$vew_data->hhrliccod); ?></strong></h4></li>				
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->licence; ?>
										<span class="tmss-card-icon">
											<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
											<?= gethtml( 'sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
										</span>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  
									<?php 
                  	// Codigo (de momento no lo vamos a usar)
										//echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('hhrliccodext', 'doccodext', $vew_data->hhrliccodext, ($vew_lck_total?$lv_always_disabled:$lv_default)) ));
										
										// Personal
										echo gethtml('srcobjtyp','hidden',$lv_srcobjtyp);
                  	echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->staff, 'input'=>vew_boot(array('style'=>'search', 'readonly'=>($vew_data->srcobjtxt??''!=''?true:$vew_readonly) ),
                                              array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt, (($vew_data->srcobjtxt??''!='')?$lv_always_disabled:$lv_default)) ) ) ));
                  
                  	// Licencia
                  	echo gethtml('hhrlictypcod','hidden',$vew_data->hhrlictypcod);
                  	echo gethtml('hhrlictypatrprv','hidden','');
										echo vew_boot($lv_col210, array('label'=>$vew_lang->licence, 
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>($vew_data->hhrliccod!=''?true:$vew_readonly) ),
                                                    array('input'=>gethtml('hhrlictyptxt', 'typeahead', $vew_data->hhrlictyptxt, ($vew_data->hhrliccod!=''?$lv_always_disabled:$lv_default))))));
										
										echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
																										'input1'=>gethtml('hhrlicdtestr', 'docdte', $vew_data->hhrlicdtestr, ($vew_lck_total || $vew_lck_parcial?$lv_always_disabled:$lv_default_dte)),
																										'input2'=>gethtml('hhrlicdteend', 'docdte', $vew_data->hhrlicdteend, ($vew_lck_total ? $lv_always_disabled:$lv_default_dte)) ));
										
                  	// Estado
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default)) );
									?>
								</div>
							</div>
						</div>
            <!-- CARGOS -->
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->charges; ?></div></div>
								<div class="card-body tmss-card-body-edit">						
									<table class="table table-sm" id="hhrchrasgtbl">
										<tbody>
											<?php
												foreach($vew_data->chrtypasg as $lv_row){
													$lv_hrs = $vew_doc->getTagValue($lv_row['hhrchrasgatr'],'hrs');
													$lv_hrstyp = $vew_doc->getTagValue($lv_row['hhrchrasgatr'],'hrstyp');
													$lv_hrstyptxt = ($lv_hrstyp=='D'?'D&iacute;a':($lv_hrstyp=='W'?'Semana':($lv_hrstyp=='Y'?'A&ntilde;o':'')));
													$lv_tmeasg = $vew_doc->getTagValue($lv_row['hhrchrclsatr'],'tmeasg');
													$lv_lug = $vew_doc->getTagValue($lv_row['hhrchrasgatr'],'stdloctxt');
													$lv_seq = $vew_doc->getTagValue($lv_row['hhrchrasgatr'],'seq');
													$lv_sub = $vew_doc->getTagValue($lv_row['hhrchrasgatr'],'persub');
													$lv_con = $lv_row['hhragrtxt'];
													echo '<tr>'.
																'<td width="50"><input type="checkbox" checked data-hhrchrasgcod="'.$lv_row['hhrchrasgcod'].'" data-hhrchrtypcod="'.$lv_row['hhrchrtypcod'].'" data-tmeasg="'.$lv_tmeasg.'" data-refhrs="'.$lv_hrs.'" data-refhrstyp="'.$lv_hrstyp.'" '.($vew_data->hhrliccod!=''?'disabled="disabled"':'').'></td>'.
																'<td style="text-transform:capitalize;"><a href="#" name="chrasglnk" data-hhrchrasgcod="'.$lv_row['hhrchrasgcod'].'">'.strtolower($lv_row['hhrchrtyptxt']).'</a> <small id="refhrs" class="'.($lv_tmeasg=='M'?'':'hidden').'">('.$lv_hrs.' '.$lv_hrstyptxt.')</small> <div><small>'.($lv_lug!=''?$lv_lug:'').($lv_con!=''?' - '.$lv_con:'').($lv_sub!=''?' - '.($lv_sub=='1'?'SUBVENCIONADO':''):'').($lv_seq!=''?' - SEC.'.$lv_seq:'').'</small></div></td>'.
																'<td><div class="'.($lv_tmeasg=='M'?'':'hidden').'">'.gethtml('asghrs', 'docnum0601', $vew_doc->getTagValue($lv_row['hhrlicchratr']??'','hrs'), ($vew_lck_total || $vew_lck_parcial?$lv_always_disabled:$lv_default) ).'</div></td>'.
																'</tr>';
												}
											?>
										</tbody>
									</table>
								</div>
							</div>		
						</div>
					</div>
				
				</div> <!-- /_tab001 -->		
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    <?php if($lv_srcobjtyp == 'EDU_TCH'){              ?>
            var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A"}, "fldasg":{"srcobjtxt":"tchtxt", "srcobjcod":"tchcod"}};
            tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"),'edutch',lo_get,{"afterAssign":function () {$("#<?= $lv_sec; ?> #srcobjcod").trigger("change")}});
    
    <?php } ?>
    <?php if($lv_srcobjtyp == 'HHR_EMP'){              ?>
            var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A"}, "fldasg":{"srcobjtxt":"hhremptxt", "srcobjcod":"hhrempcod"}}; 
            tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"),'hhremp',lo_get,{"afterAssign":function () {$("#<?= $lv_sec; ?> #srcobjcod").trigger("change")}});
    <?php } ?>
    //Esto se puede hacer con un ternario probablemente
    <?php if($vew_sec->hasPermission('HHR','LIC','02')){ ?>
      var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"c.docsts":"A"}, "fldasg":{"hhrlictypatrprv":"hhrlictypatrprv","hhrlictyptxt":"hhrlictyptxt", "hhrlictypcod":"hhrlictypcod"}};
    <?php }else{ ?>
    	 var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"c.docsts":"A","hhrlictypatrautges":"1"}, "fldasg":{"hhrlictypatrprv":"hhrlictypatrprv","hhrlictyptxt":"hhrlictyptxt", "hhrlictypcod":"hhrlictypcod"}};
    <?php }?> 
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrlictyptxt"),"hhrlictyp",lo_get);
	</script>
  <script>
    $("#<?= $lv_sec; ?> #hhrlicdtestr").on("change",function(e){ 
        e.preventDefault();
        if( $(this).val() && <?=!($vew_sec->hasPermission('HHR', 'LIC', '02')) ? 'true' : 'false';?>){
            var lv_prv = $("#<?= $lv_sec; ?> #hhrlictypatrprv").val();
            var lo_mindte = moment();
            lo_mindte.add(lv_prv,"days");
            var lo_slcdte = moment($(this).val(), "DD/MM/YYYY");
            //Esto seria tomando en cuenta dias de fin de semana lo cual no es lo mas preciso.
            if(lo_mindte > lo_slcdte){
                $(this).val("");
                toastr.warning("Debe seleccionar una fecha mayor al "+lo_mindte.format("DD/MM/YYYY"));
            }
        }
    });
  </script>
	<script>
    function <?= $lv_sec; ?>_updateCharge(){
      if(	$("#<?= $lv_sec; ?> #srcobjcod").val() != '' && 	$("#<?= $lv_sec; ?> #hhrliccod").val()==''){
     	 $("#<?= $lv_sec; ?> #srcobjcod").trigger('change');
      }
    }
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> #srcobjcod").on("change",function(e){ e.preventDefault();
				if( $(this).prop("value")!="" ) {
					var lv_pstdat = [	{name:"srcobjtyp",value:$("#<?= $lv_sec; ?> #srcobjtyp").prop("value")},
														{name:"srcobjcod",value:$("#<?= $lv_sec; ?> #srcobjcod").prop("value")}];
					tmssCallProcess("?prg=hhrchrasg&act=18", lv_pstdat, function(data){ 
						data = data.data;
						var lv_hrs="";
						var lv_hrstyp="";
						var lv_hrstyptxt="";
						var lv_tmeasg;
						var lv_buf="";
						for(i=0; i<data.length; i++){
							lv_hrs = $("<div>"+data[i]["hhrchrasgatr"]+"</div>").find("hrs").text();
							lv_hrstyp = $("<div>"+data[i]["hhrchrasgatr"]+"</div>").find("hrstyp").text();
							lv_hrstyptxt = (lv_hrstyp=="D"?"D&iacute;a":(lv_hrstyp=="W"?"Semana":(lv_hrstyp=="Y"?"A&ntilde;o":"")));
							lv_tmeasg = $("<div>"+data[i]["hhrchrclsatr"]+"</div>").find("tmeasg").text();

							var lv_lug = $("<div>"+data[i]["hhrchrasgatr"]+"</div>").find("stdloctxt").text();
							var lv_seq = $("<div>"+data[i]["hhrchrasgatr"]+"</div>").find("seq").text();
							var lv_sub = $("<div>"+data[i]["hhrchrasgatr"]+"</div>").find("persub").text();
							var lv_con = data[i]["hhragrtxt"];

							lv_buf += "<tr>";
							lv_buf += "<td><input type='checkbox' data-hhrchrasgcod='"+	
                					data[i]["hhrchrasgcod"]+"' data-hhrchrtypcod='"+
                					data[i]["hhrchrtypcod"]+"' data-tmeasg='"+
                					lv_tmeasg+
                					"'></td>";
							lv_buf += "<td style='text-transform:capitalize;'><a href='#' name='chrasglnk' data-hhrchrasgcod='"+
                        	data[i]["hhrchrasgcod"]+"'>"
                          +data[i]["hhrchrtyptxt"].toLowerCase()+
                					"</a> <small id='refhrs' class='"+
            							(lv_tmeasg==""?"hidden":"")+"'>("+lv_hrs+" "+lv_hrstyptxt+")</small><div><small>"
                					+(lv_lug!=""?lv_lug:"")+(lv_con!=null?" - "+lv_con:"")+(lv_sub!=""?"-"+(lv_sub=="1"?"SUBVENCIONADO":""):"")+(lv_seq!=""?" - SEC."+lv_seq:"")+	
                          "</small></div></td>";
							lv_buf += "<td><input type='number' step = 0.1 id='asghrs' name='asghrs' value='' class='form-control hidden'></td>";
							lv_buf += "</tr>";
						}
						$("#<?= $lv_sec; ?> #hhrchrasgtbl tbody").html(lv_buf);
						<?= $lv_sec; ?>_updateCheckbox();
					});
				} else {
					$("#<?= $lv_sec; ?> #hhrchrasgtbl tbody").html("");
				}
      	
			});
		<?= $lv_sec; ?>_updateCharge();
		});

		function <?= $lv_sec; ?>_updateCheckbox() {
			tmssLoadScript("toggle",function(){
				$("#<?= $lv_sec; ?> :checkbox").each( function() {
					$(this).bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
					<?= ($vew_readonly || $vew_lck_parcial || $vew_lck_total?'$(this).prop("disabled","disabled");':''); ?>
				});
			});
			
			$("#<?= $lv_sec; ?> :checkbox").on("change",function(e){
				if($(this).is(":checked") && $(this).data("tmeasg")=="M"){
					$(this).parentsUntil("tr").parent().find("#refhrs").removeClass("hidden")
					$(this).parentsUntil("tr").parent().find("#asghrs").removeClass("hidden")
				} else {
					$(this).parentsUntil("tr").parent().find("#refhrs").addClass("hidden")
					$(this).parentsUntil("tr").parent().find("#asghrs").addClass("hidden")
				}
			});
			
			$("#<?= $lv_sec; ?> a[name=chrasglnk]").on("click",function(e){ e.preventDefault();
				tmssLink("?prg=hhrchrasg&act=03&prm_hhrchrasgcod="+$(this).data("hhrchrasgcod"), [{target: "_new_section"}] );
			});
		}
		
		$(function(){
			<?= $lv_sec; ?>_updateCheckbox();
		});		
	</script>
  <script>		
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				var lv_sel = "";
				var lv_itm = $("#<?= $lv_sec; ?> :checkbox:checked");
				var lv_asghrs;
				var lv_tmeasg;
        var lv_refhrs;
				var lv_continue=true;
				if(lv_itm.length==0){ toastr.warning("Debe seleccionar al menos un cargo."); return false; }
				lv_itm.each(function(){
					lv_tmeasg = $(this).data("tmeasg");
					lv_asghrs = $(this).parentsUntil("tr").parent().find("#asghrs").prop("value");
          lv_refhrs = $(this).parentsUntil("tr").parent().find("#refhrs").text().trim().replace(/[()]/g, "");
					lv_asghrs = (lv_tmeasg=="M"?lv_asghrs:"");
					if(lv_tmeasg=="M" && Number(lv_asghrs)<=0){ 
						toastr.warning("Debe indicar la cantidad de horas."); 
						lv_continue=false; 
					} else {
            if(lv_asghrs>lv_refhrs){
                toastr.warning("Las horas pedidas superan el total de horas asignadas del cargo"); 
              	lv_continue=false; 
            }
						lv_sel += (lv_sel==""?"":String.fromCharCode(9)) + "<hhrchrasgcod>"+$(this).data("hhrchrasgcod")+"</hhrchrasgcod><hrs>"+lv_asghrs+"</hrs>";
					}
				});
				if(lv_continue==false){ return false; }
				$("#<?= $lv_sec; ?> #hhrchrtypcodlst").prop("value",lv_sel);
        
			}			
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>