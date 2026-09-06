<?php		
	// url del formulario
  $lv_lnk = '?prg=hhrchrasg&prm_hhrchrasgcod='.$vew_data->hhrchrasgcod;

	// campos requeridos
	$vew_input->RequiredFields( array('srcobjtxt','srcobjcod','hhrchrtypcod','hhrchrtyptxt','hhrchrasgdtestr','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrchrasgcod;

	// titulo
	$lv_title = $vew_lang->charge;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'CHA';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));
	$lv_mdl = explode('_',$lv_srcobjtyp)[0];

	$lv_tmeasg_tmp = strtoupper($vew_doc->getTagValue( $vew_data->hhrchrclsatr, 'tmeasg' ));
	$lv_tmeasg = ($lv_tmeasg_tmp=='' || $lv_tmeasg_tmp=='S' ? false : true );

	$lv_oldasg_tmp = strtoupper($vew_doc->getTagValue( $vew_data->hhrchrclsatr, 'oldasg' ));
	$lv_oldasg = ($lv_oldasg_tmp=='' || $lv_oldasg_tmp=='S' ? false : true );

	$lv_slrasg_tmp = strtoupper($vew_doc->getTagValue( $vew_data->hhrchrtypatr, 'slrasg' ));
	$lv_slrasg = ($lv_slrasg_tmp=='M' ? true : false );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('hhrchrasgatr','hidden',htmlentities($vew_data->hhrchrasgatr)); ?>
    <?= gethtml('atrold','hidden',htmlentities($vew_data->atrold)); ?>
		<input type="hidden" id="hstatr" name="hstatr" value='<?= json_encode($vew_data->hstatr); ?>'>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->charges; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrchrasgcod; ?><?= gethtml('hhrchrasgcod','hidden',$vew_data->hhrchrasgcod,$lv_default); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-4">
              
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->charge; ?>
                    <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
      							<?= gethtml( 'sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod, $lv_default); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
									<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('hhrchrasgcodext', 'doccodext', $vew_data->hhrchrasgcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->staff, 
																								'input'=>vew_boot(	
																										array('style'=>'search', 'readonly'=>($vew_data->hhrchrasgcod!=''?true:$vew_readonly) ),
																										array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt, ($vew_data->hhrchrasgcod!=''?$lv_always_disabled:$lv_default)))
																									))
															);
										echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod,$lv_default);
										echo gethtml('srcobjtyp','hidden',$lv_srcobjtyp,$lv_default);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 
																								'input'=>vew_boot(	
																										array('style'=>'search', 'readonly'=>($vew_data->hhrchrasgcod!=''?true:$vew_readonly) ),
																										array('input'=>gethtml('hhrchrtyptxt', 'typeahead', $vew_data->hhrchrtyptxt, ($vew_data->hhrchrasgcod!=''?$lv_always_disabled:$lv_default)))
																									))
																);
										echo gethtml('hhrchrtypcod','hidden',$vew_data->hhrchrtypcod,$lv_default);	
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
              </div>
              
						</div>
						<div class="col-md-4">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->entrance, 'input'=>gethtml('hhrchrasgdtestr', 'docdte', $vew_data->hhrchrasgdtestr, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->debit,'input'=>gethtml('hhrchrasgdteend', 'docdte', $vew_data->hhrchrasgdteend, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->outreason, 
                                                    'input'=>vew_boot(	
                                                        array('style'=>'search', 'readonly'=>$vew_readonly),
                                                        array('input'=>gethtml('hhroutrsntxt', 'typeahead', $vew_data->hhroutrsntxt, $lv_default ))
                                                      ))
																);
                  	echo gethtml('hhroutrsncod', 'hidden', $vew_data->hhroutrsncod, $lv_default);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->workerunion, 
																								'input'=>vew_boot(	
																										array('style'=>'search', 'readonly'=>$vew_readonly),
																										array('input'=>gethtml('hhrlabunitxt', 'typeahead', $vew_data->hhrlabunitxt, $lv_default ))
																									))
																);
										echo gethtml('hhrlabunicod','hidden',$vew_data->hhrlabunicod,$lv_default);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->agreement, 
																								'input'=>vew_boot(	
																										array('style'=>'search', 'readonly'=>$vew_readonly),
																										array('input'=>gethtml('hhragrtxt', 'typeahead', $vew_data->hhragrtxt, $lv_default ))
																									))
																);
										echo gethtml('hhragrcod','hidden',$vew_data->hhragrcod,$lv_default);
								
										echo '<div id="hhrchrasgatrolddiv" class="'.($lv_oldasg?'':'hidden').'">';
										echo vew_boot(array($lv_colxs12552, $lv_colsm4332), array('label'=>'Antig&uuml;edad (aa.mm)',
																									'input1'=>gethtml('hhrchrasgatroldyth', 'docnum0300', $vew_doc->getTagValue($vew_data->hhrchrasgatr,'oldyth'), $lv_default),
																									'input2'=>gethtml('hhrchrasgatroldmth', 'docnum0300', $vew_doc->getTagValue($vew_data->hhrchrasgatr,'oldmth'), $lv_default),         
                                                  'input3'=>vew_boot(
                                                    		array('style'=>'custom', 'custom'=>'<a id="hhrchrasghstbtn" class="card-icon"><i class="fas fa-history"></i></a>'),
                                                    		array('custom'=>'<a id="hhrchrasghstbtn" class="card-icon"><i class="fas fa-history"></i></a>'))
																								));
										echo '</div>';
										
                  	echo '<div id="hhrchrasgatrtmediv" class="'.($lv_tmeasg?'':'hidden').'">';
										echo vew_boot(array($lv_colxs1257, $lv_colsm435), array('label'=>$vew_lang->hours,
																								'input1'=>gethtml('hhrchrasgatrhrs', 'docnum0602', $vew_doc->getTagValue($vew_data->hhrchrasgatr,'hrs'), $lv_default),
																								'input2'=>gethtml('hhrchrasgatrhrstyp', array(''=>'','D'=>'DIA','W'=>'SEMANA','M'=>'MES'), $vew_doc->getTagValue($vew_data->hhrchrasgatr,'hrstyp'), $lv_default)
																								));
										echo '</div>';
									?>
                </div>
              </div>
              
						</div>
						<div class="col-md-4">
              
              <!-- EDUCACION -->
							<?php	if($lv_mdl=='EDU'){ ?>
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->education; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
										echo vew_boot($lv_col39, array('label'=>'Sit.Revista', 	'input'=>gethtml('hhrchrasgatrsitrev', array(''=>'','T'=>'TITULAR','S'=>'SUPLENTE','P'=>'PROVISIONAL'),$vew_doc->getTagValue($vew_data->hhrchrasgatr,'sitrev'), $lv_default) ));
										echo vew_boot($lv_col39, array('label'=>'Ext.Horaria', 	'input'=>gethtml('hhrchrasgatrexttme', array(''=>'','1'=>'SI','0'=>'NO'),$vew_doc->getTagValue($vew_data->hhrchrasgatr,'exttme'), $lv_default) ));
										echo vew_boot($lv_col39, array('label'=>'Subvencionado','input'=>gethtml('hhrchrasgatrpersub', array(''=>'','1'=>'SI','0'=>'NO'),$vew_doc->getTagValue($vew_data->hhrchrasgatr,'persub'), $lv_default) ));
										echo vew_boot($lv_col39, array('label'=>'Secuencia', 		'input'=>gethtml('hhrchrasgatrseq', 'doccmt1x20', $vew_doc->getTagValue($vew_data->hhrchrasgatr,'seq'), $lv_default) ));
										echo vew_boot($lv_col39, array('label'=>$vew_lang->place, 
																									'input'=>vew_boot(	
																											array('style'=>'search', 'readonly'=>$vew_readonly),
																											array('input'=>gethtml('hhrchrasgatrstdloctxt', 'typeahead', $vew_doc->getTagValue($vew_data->hhrchrasgatr,'stdloctxt'), $lv_default))
																										))
																	);
										echo gethtml('hhrchrasgatrstdloccod','hidden',$vew_doc->getTagValue($vew_data->hhrchrasgatr,'stdloccod'),$lv_default);
									?>
                </div>
              </div>
              <script>
                // esustdloc - typeahead
                var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "hhrchrasgatrstdloctxt":"stdloctxt", "hhrchrasgatrstdloccod":"stdloccod"}};
                tmssTypeahead($("#<?= $lv_sec; ?> #hhrchrasgatrstdloctxt"), "edustdloc", lo_get);
              </script>
							<?php } ?>
              
						</div> <!-- /col-4 -->
					</div> <!-- /row -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// srcobjtxt
    <?php if($lv_srcobjtyp=='EDU_TCH'){ ?>

      // edutch - typeahead
      var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "srcobjtxt":"tchtxt", "srcobjcod":"tchcod"}, "fldflt":{"p.docsts":"A"}};
      tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "edutch", lo_get);

    <?php } ?>
    <?php if($lv_srcobjtyp=='HHR_EMP'){ ?>

      // hhremp - typeahead
      var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "srcobjtxt":"hhremptxt", "srcobjcod":"hhrempcod"}};
      tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hhremp", lo_get);

    <?php } ?>

    // hhrchrtyptxt - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "hhrchrtyptxt":"hhrchrtyptxt", "hhrchrtypcod":"hhrchrtypcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrchrtyptxt"), "hhrchrtyp", lo_get, {'afterAssign': function(){$("#<?= $lv_sec; ?> #hhrchrtypcod").change();}});
    
    // hhroutrsn - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "hhroutrsncod":"hhroutrsncod", "hhroutrsntxt":"hhroutrsntxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhroutrsntxt"), "hhroutrsn", lo_get);
    
    $("#<?= $lv_sec; ?> #hhrchrasgdteend").on("input change select blur", function(){
      if($(this).val() != ""){
        $("#<?= $lv_sec; ?> #hhroutrsntxt").closest(".form-group").removeClass("hidden");
      }else{
        $("#<?= $lv_sec; ?> #hhroutrsntxt").prop("value","");
        $("#<?= $lv_sec; ?> #hhroutrsncod").prop("value","");
        $("#<?= $lv_sec; ?> #hhroutrsntxt").closest(".form-group").addClass("hidden");
      }
    });


    // obtengo clase de cargo
    $("#<?= $lv_sec; ?> #hhrchrtypcod").on("change",function(){
      var lv_pstdat = [{name:"hhrchrtypcod",value:$(this).prop("value")}]
      tmssCallProcessNoBackdrop("?prg=hhrchrtyp&act=18",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #hhrchrasgatrtmediv").addClass("hidden")
        $("#<?= $lv_sec; ?> #hhrchrasgslrdiv").addClass("hidden")
        $("#<?= $lv_sec; ?> #hhrchrasgatrolddiv").addClass("hidden").removeClass("tmssInputRequired");
        $("#<?= $lv_sec; ?> #hhrchrasgatrhrs").removeClass("tmssInputRequired");
        $("#<?= $lv_sec; ?> #hhrchrasgatrhrstyp").removeClass("tmssInputRequired");
        $("#<?= $lv_sec; ?> #hhrchrasgslr").removeClass("tmssInputRequired");
        if(data.data.length>0){
          // activo asignación de horas segun clase de cargo
          var lv_tmeasg = $("<div>"+data.data[0].hhrchrclsatr+"</div>").find("tmeasg").text();
          if(lv_tmeasg!="" && lv_tmeasg!="S") {	
            $("#<?= $lv_sec; ?> #hhrchrasgatrtmediv").removeClass("hidden"); 
            $("#<?= $lv_sec; ?> #hhrchrasgatrhrs").addClass("tmssInputRequired");
            $("#<?= $lv_sec; ?> #hhrchrasgatrhrstyp").addClass("tmssInputRequired");
          }

          // activo asignación de antiguedad según clase de cargo
          var lv_oldasg = $("<div>"+data.data[0].hhrchrclsatr+"</div>").find("oldasg").text();
          if(lv_oldasg!="" && lv_oldasg!="S") { $("#<?= $lv_sec; ?> #hhrchrasgatrolddiv").removeClass("hidden"); }

          // activo asignación de salario segun tipo de cargo
          var lv_slrasg = $("<div>"+data.data[0].hhrchrtypatr+"</div>").find("slrasg").text();
          if(lv_slrasg=="M") {	
            $("#<?= $lv_sec; ?> #hhrchrasgslrdiv").removeClass("hidden"); 
            $("#<?= $lv_sec; ?> #hhrchrasgslr").addClass("tmssInputRequired");
          }
        }
      });
    });


    // hhragr - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "hhragrtxt":"hhragrtxt", "hhragrcod":"hhragrcod"}, "fldflt":{"docsts":"A"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhragrtxt"), "hhragr", lo_get);

    // hhrlabunitxt - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "hhrlabunitxt":"hhrlabunitxt", "hhrlabunicod":"hhrlabunicod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrlabunitxt"), "hhrlabuni", lo_get);
    
    
    $("#<?= $lv_sec; ?> #hhrchrtypcod, #<?= $lv_sec; ?> #srcobjcod").change(function(){
      // verificar si hay que setear la antigüedad según la clase de cargo elegida y los demás cargos del empleado
      if( $("#<?= $lv_sec; ?> #hhrchrtypcod").val() != "" &&  $("#<?= $lv_sec; ?> #srcobjcod").val() != "" ){
        var lv_pstdat = [{name:"hhrchrtypcod",value:$("#<?= $lv_sec; ?> #hhrchrtypcod").val()}, {name:"hhrchrasgcod",value:$("#<?= $lv_sec; ?> #hhrchrasgcod").val()}, {name:"srcobjtyp",value:$("#<?= $lv_sec; ?> #srcobjtyp").val()}, {name:"srcobjcod",value:$("#<?= $lv_sec; ?> #srcobjcod").val()}]
        tmssCallProcessNoBackdrop("?prg=hhrchrasg&act=17",lv_pstdat,function(data){
          if(data.data.length > 0){
            $("#<?= $lv_sec; ?> #hhrchrasgatroldyth").val($("<div>"+data.data[0].hhrchrasgatr+"<div>").find("oldyth").text());
            $("#<?= $lv_sec; ?> #hhrchrasgatroldmth").val($("<div>"+data.data[0].hhrchrasgatr+"<div>").find("oldmth").text());
          }else{
            $("#<?= $lv_sec; ?> #hhrchrasgatroldyth").val("");
            $("#<?= $lv_sec; ?> #hhrchrasgatroldmth").val("");
          }
        }); 
      }
    });
    
    
    $("#<?= $lv_sec; ?> #hhrchrasghstbtn").click(function(){
      tmssCallProcess("?prg=hhrchrasg&act=atrold", [{name: "readonly", value: "<?= ($vew_readonly ? 'true' : 'false') ?>"}, {name: "hstatr", value: $("#<?= $lv_sec; ?> #hstatr").val()}], function(data){
        BootstrapDialog.show({
          title: "Antig&uuml;edad",
          message: $(data),
          draggable: true,
          closable: <?= ($vew_readonly ? 'true' : 'false') ?>,
          size: BootstrapDialog.SIZE_WIDE,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } }
                    <?php if(!$vew_readonly){ ?>  
                      ,
                      {	id:"btn-accept", label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                        let lv_ret = eval( dialog.$modalBody.find("section").attr("id") + "_getData()" );

                        //si hay errores se le avisa al usuario que los corrija
                        if( lv_ret.err ){ toastr.warning("Corrija los errores en la tabla"); return false; }

                        var lv_dat = lv_ret.data;
                      	var lv_hstatr = JSON.parse($("#<?= $lv_sec; ?> #hstatr").val());
                        
                        for (var i=0; i<lv_hstatr.length; i++){                          
                          // setea valor de año y mes
                          lv_hstatr[i].hhrlqdchrasgatr = lv_hstatr[i].hhrlqdchrasgatr.replace(/<OLDYTH>.*<\/OLDYTH>/, "<OLDYTH>"+lv_dat[i].oldyth+"</OLDYTH>");
                          lv_hstatr[i].hhrlqdchrasgatr = lv_hstatr[i].hhrlqdchrasgatr.replace(/<OLDMTH>.*<\/OLDMTH>/, "<OLDMTH>"+lv_dat[i].oldmth+"</OLDMTH>");
                        }
                        $("#<?= $lv_sec; ?> #hstatr").val(JSON.stringify(lv_hstatr));
                        dialog.close();
                      }
                    } 
                  <?php } ?>
          ],
          onshown: function(dialog){
            let secID = dialog.$modalBody.find("section").attr("id"); 
            eval( "if( typeof " + secID + "_hotdoc  != 'undefined' ){ " + secID + "_hotdoc.render();" + secID + "_hotdoc.render(); }" )
          }
        });
      });
    })
		
		$(function(){
			$("#<?= $lv_sec; ?> #hhrchrasgatroldyth").prop("max","99").prop("maxlength","2").prop("step","1");
			$("#<?= $lv_sec; ?> #hhrchrasgatroldmth").prop("max","12").prop("maxlength","2").prop("step","1");
      
      $("#<?= $lv_sec; ?> #hhrchrasgdteend").change();  
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) {
        $("#<?= $lv_sec; ?> #hhrchrasgatr").prop("value", "<hrs>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrhrs").val() ?? "") + "</hrs>"
                                                + "<hrstyp>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrhrstyp").val() ?? "") + "</hrstyp>"
                                                + "<oldyth>" + ($("#<?= $lv_sec; ?> #hhrchrasgatroldyth").val() ?? "") + "</oldyth>"
                                                + "<oldmth>" + ($("#<?= $lv_sec; ?> #hhrchrasgatroldmth").val() ?? "") + "</oldmth>"
                                                 // atributos especificos de educacion
                                                + "<sitrev>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrsitrev").val() ?? "") + "</sitrev>"
                                                + "<persub>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrpersub").val() ?? "") + "</persub>"
                                                + "<exttme>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrexttme").val() ?? "") + "</exttme>"
                                                + "<seq>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrexttme").val() ?? "") + "</seq>"
                                                + "<stdloccod>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrstdloccod").val() ?? "") + "</stdloccod>"
                                                + "<stdloctxt>" + ($("#<?= $lv_sec; ?> #hhrchrasgatrstdloctxt").val() ?? "") + "</stdloctxt>");
              }
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
  
</section>