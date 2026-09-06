<?php		
	// url del formulario
	$lv_lnk = '?prg=hltpathst';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->pat->patcod; 

	// titulo
	$lv_title = $vew_lang->history;
	
	// módulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT_HST';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$vew_actcod = 'dsh';
	$vew_tbl_brand = $vew_data->pat->pattxt . ($vew_data->pat->patcodext!=''?' <small> - #'.$vew_data->pat->patcod.'</small>':'');
	$vew_tbl['rfrsh']['acc'] = $lv_sec.'_refresh();';

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<style> 
    #<?= $lv_sec; ?> .navbar-brand{ color: white; }
    .hltpathst-personal-data i{ width: 33px; text-align: center; }
		.dashboard-card{ border-radius: 10px; padding: 10px; margin-bottom: 10px; }
		.dashboard-card p:first-child { font-size:16px; }
		.dashboard-card p:last-child { font-size:32px; font-weight:bold; text-align: center;}
    #<?= $lv_sec; ?> .tmssCalendarSmall tbody tr td.otherMonth { background-color:#f1f1f1; }
    #<?= $lv_sec; ?> .tmssCalendarSmall tbody tr td.holiday {background-color:#bebebe; }
    #<?= $lv_sec; ?> .tmssCalendarSmall tbody table:first tbody tr td { text-align:center; }
	</style>
  
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('patcod','hidden',$vew_data->patcod); ?>
    <div class="container-fluid" role="tabpanel">
      <div class="row">
        <div class="col-sm-2 navbar-default" style="padding-top:15px; padding-bottom:15px;height: calc(100vH);">
					
          <div class="card">
            <div class="card-body hltpathst-personal-data">
              <i class="far fa-hashtag"></i> <b>HC <?= $vew_data->pat->patcodext; ?></b><br>
              <i class="far fa-birthday-cake"></i> <b><?= ($vew_data->pat->per->perbrndte!=''?date_format($vew_data->pat->per->perbrndte,'d.m.Y'):' - '); ?></b>
              <?php
								if($vew_data->pat->per->perbrndte!=''){
									$now = new DateTime();
									$interval = $now->diff($vew_data->pat->per->perbrndte);
									echo '<small>('.($interval->y>0 ? $interval->y.' a&ntilde;os ' : ($interval->m>0 ? $interval->m.' meses' : $interval->d.' d&iacute;as' )).')</small><br>';
								} else { echo '<br>'; }
              ?>
              <i class="far fa-female"></i> <b><?= (($vew_data->pat->per->persex??'')=='F'?$vew_lang->female: (($vew_data->pat->per->persex??'')=='M'?$vew_lang->male:' - ')) ; ?></b><br>
              <i class="far fa-weight-hanging"></i> <b><?= ($vew_data->pat->patwgt>0 ? doubleval($vew_data->pat->patwgt).' kg': ' - '); ?></b><br>
              <i class="far fa-ruler"></i> <b><?= ($vew_data->pat->pathgh>0 ? doubleval($vew_data->pat->pathgh).' cm':' - '); ?></b><br>
              <i class="far fa-calculator"></i> <b><?= ($vew_data->pat->pathgh>0 && $vew_data->pat->patwgt>0 ? ' IMC '. number_format( ($vew_data->pat->patwgt / pow( $vew_data->pat->pathgh / 100 , 2 )) , 1 ) : ' - '); ?></b><br>
              <hr>
              Cobertura <b><?= ($vew_data->pat->per->hhrmedcovtxt!=''?$vew_data->pat->per->hhrmedcovtxt:' - '); ?></b><br>
              Plan <b><?= ($vew_data->pat->per->hhrmedcovaflpln!=''?$vew_data->pat->per->hhrmedcovaflpln:' - '); ?></b><br>
              Nro. Afiliado <b><?= ($vew_data->pat->per->hhrmedcovaflnum!=''?$vew_data->pat->per->hhrmedcovaflnum:' - '); ?></b><br>
              <?php if($vew_sec->hasPermission('HLT','PAT','03')){ ?><hr><div class="text-center"><a href="#" class="btn btn-primary" onclick="tmssLink('?prg=hltpat&act=03',[{target: '_new_section', target_id: '#<?= $lv_sec; ?>', post_data: [{name:'patcod',value:'<?= $vew_data->pat->patcod; ?>'}] }])">Ficha Paciente</a></div><?php } ?>
            </div>
          </div>

        </div>
        <div class="col-sm-10">
          
          <div class="row" style="padding-top:15px; padding-bottom:15px;">
						<div class="col-sm-8">
	
              <div class="row">
              	<div class="col-sm-3 col-xs-6">
                  <div class="dashboard-card" style="background-color: var(--tmss-purple); text: var(--tmss-purple-text);" id="crdcrmcnt">
                    <p><b><?= $vew_lang->contacts; ?></b><br><small>(ultimos 30 d&iacute;as)</small></p><p id="qtycrmcnt"></p>
                  </div>
                </div>
                <div class="col-sm-3 col-xs-6">
                  <div class="dashboard-card" style="background-color: var(--tmss-blue); text: var(--tmss-blue-text);" id="crdslsord">
                    <p><b><?= $vew_lang->recipes; ?></b><br><small>(&uacute;ltimos 30 d&iacute;as)</small></p><p id="qtyslsord"></p>
                  </div>
                </div>
                <div class="col-sm-3 col-xs-6">
                  <div class="dashboard-card" style="background-color: var(--tmss-orange); text: var(--tmss-orange-text);" id="crdstksou">
                    <p><b><?= $vew_lang->consumptions; ?></b><br><small>(&uacute;ltimos 30 d&iacute;as)</small></p><p id="qtystksou"></p>
                  </div>
                </div>
                <div class="col-sm-3 col-xs-6">
                  <div class="dashboard-card" style="background-color: var(--tmss-green); text: var(--tmss-green-text);" id="crdcrepln">
                    <p><b><?= $vew_lang->careplans; ?></b> <small>(vigentes)</small> </p><p id="qtycrepln"></p>
                  </div>
                </div>
              </div>
              
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->evolutions; ?>
                  	<a href="#" class="card-icon" id="btnevlflt"><i class="far fa-filter"></i><span class="badge" id="fltcnt"></span></a>
                </div></div>
              </div>
              <div style="overflow-y:scroll; min-height: 300px; max-height:400px;">
                <table class="table table-hover table-sm" id="tblhltevl">
                  <tbody></tbody>
                </table>
              </div>
              
            </div>
          	<div class="col-sm-4">
              
              <!-- CALENDARIO -->
              <div class="card" id="dshcal">
                <div class="card-header">
                  <div class="card-title">
                    <i class="far fa-calendar"></i> <span></span>
                    <a href="#" class="card-icon" id="btncalnxt"><i class="far fa-chevron-right"></i></a>
                    <a href="#" class="card-icon" id="btncalprv"><i class="far fa-chevron-left"></i></a>
                  </div>
                </div>
                <div class="card-body">
                  <table class="table table-condensed tmss-table-noborder-first tmssCalendarSmall" style="margin-bottom:0px !important;">
                    <thead><tr><th class="text-center">Do</th><th class="text-center">Lu</th><th class="text-center">Ma</th><th class="text-center">Mi</th><th class="text-center">Ju</th><th class="text-center">Vi</th><th class="text-center">Sa</th></tr></thead>
                    <tbody></tbody>
                  </table>
                </div>
                <div class="card-footer calendar-holidays"></div>
                <div class="card-footer">
                  <div class="container-fluid">
                    <b><?= $vew_lang->turns; ?></b>
                    <table class="table table-hover table-sm" id="tblhltpln">
                      <tbody></tbody>
                    </table>
                  </div>
                </div>
              </div>
                            
            </div>
          </div>
          
        </div>
      </div>
    </div>
	</form>		
  
  
	<div class="hidden" id="hltpathstflt">
    
		<div class="row">
			<div class="col-sm-6">
				<div class="card">
					<div class="card-header"><div class="card-title"><?= $vew_lang->filters; ?></div></div>
					<div class="card-body">
            <textarea class="hidden" id="fltdat" name="fltdat"></textarea>
            <?= gethtml('prscod','hidden',''); ?>
						<?= vew_boot($lv_colsm210, array('label'=>$vew_lang->date,'input'=>gethtml('evldte','docdte','',$lv_always_enabled))); ?>
						<?= vew_boot($lv_colsm210, array('label'=>$vew_lang->provider,'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>false), 
                                                                        array('input'=>gethtml('prstxt', 'typeahead', $vew_data->prstxt,$lv_always_enabled) )) )); ?>
					</div>
				</div>
				<div class="card">
					<div class="card-header"><div class="card-title">Cronologico</div></div>
					<div class="card-body">
            <div id="fltythmth">
              <ul id="yth"></ul>
            </div>
          </div>
				</div>
			</div>
			<div class="col-sm-6">
				<div class="card">
					<div class="card-header"><div class="card-title"><?= $vew_lang->specialty; ?></div></div>
					<div class="card-body">
          	<div id="fltspc">
            	<ul></ul>
            </div>
          </div>
				</div>
			</div>
		</div>
	</div>
  
  <script>
    // -----------------------------------------------------    
    // INDICADORES
    // -----------------------------------------------------   
    // REFRESH
		function <?= $lv_sec; ?>_refresh(){
			var lv_spin = "<i class='far fa-gear fa-spin'></i>";
			$("#<?= $lv_sec; ?> #qtycrmcnt").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtyslsord").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtystksou").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtycrepln").html( lv_spin );
			
			// TURNOS 
			tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",[{name:"typ",value:"crmcnt"},{name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"}],function(data){
				$("#<?= $lv_sec; ?> #qtycrmcnt").html( (data.length>0?data[0].qty:0) );
			});

      // CONSUMOS
			tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",[{name:"typ",value:"stksou"},{name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"}],function(data){
				$("#<?= $lv_sec; ?> #qtystksou").html( (data.length>0?data[0].qty:0)  );
			});

      // RECETAS
			tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",[{name:"typ",value:"slsord"},{name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"}],function(data){
				$("#<?= $lv_sec; ?> #qtyslsord").html( (data.length>0?data[0].qty:0) );
			});

      // PLAN DE CUIDADOS
			tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",[{name:"typ",value:"crepln"},{name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"}],function(data){
				$("#<?= $lv_sec; ?> #qtycrepln").html( (data.length>0?data[0].qty:0) );
			});
      
      // GRILLA EVOLUCIONES
      <?= $lv_sec; ?>_refreshEvolutionGrid();
      
      // GRILLA TURNOS
      var lo_today = new Date();
			$("#<?= $lv_sec; ?> #dshcal").data("year", lo_today.getFullYear() );
			$("#<?= $lv_sec; ?> #dshcal").data("month", lo_today.getMonth()+1 );
			<?= $lv_sec; ?>_refreshTurnGrid();
      
      // FILTRO DE EVOLICIONES 
      <?= $lv_sec; ?>_refreshEvolutionFilter()
		}

    // EVENTOS. CONTACTOS
    <?php if( $vew_sec->hasPermission("CRM","CNT","**") ){ ?>
    	$("#<?= $lv_sec; ?> #crdcrmcnt").css("cursor","pointer");
    	$("#<?= $lv_sec; ?> #crdcrmcnt").on("click",function(e){ e.preventDefault();
        var ch9 = String.fromCharCode(9);
        var lv_pstdat = [{name:"vewfldflt",value:"[~fltrow~]c.crmcntsrctyp"+ch9+"="+ch9+ch9+"hlt_pat"+ch9+ch9
                                                +"[~fltrow~]c.crmcntsrccod"+ch9+"="+ch9+ch9+"<?= $vew_data->pat->patcod; ?>"+ch9+ch9
                          											+"[~fltrow~]c.docsts"+ch9+"="+ch9+ch9+"A"+ch9+ch9
                                               }];
        tmssLink("?prg=crmcnt&act=08&prm_mdlcod=crm&prm_prgcod=cnt&prm_objtyp=crm_cnt&prm_vewcod=VEW_CRM_CNT", [{target: "_new_section",target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat }]);
      });
    <?php } ?>

    // EVENTOS. PEDIDOS/RECETAS
    <?php if( $vew_sec->hasPermission("SLS","ORD","**") ){ ?>
    	$("#<?= $lv_sec; ?> #crdslsord").css("cursor","pointer");
    	$("#<?= $lv_sec; ?> #crdslsord").on("click",function(e){ e.preventDefault();
        var ch9 = String.fromCharCode(9);
        var lv_pstdat = [{name:"vewfldflt",value:"[~fltrow~]dc.objtyp"+ch9+"="+ch9+ch9+"sls_ord"+ch9+ch9
                                                +"[~fltrow~]o.dstobjtyp"+ch9+"="+ch9+ch9+"hlt_pat"+ch9+ch9
                                                +"[~fltrow~]o.dstobjcod"+ch9+"="+ch9+ch9+"<?= $vew_data->pat->patcod; ?>"+ch9+ch9
                                               }];
        tmssLink("?prg=slsord&act=08&prm_mdlcod=sls&prm_prgcod=ord&prm_objtyp=sls_ord&prm_vewcod=VEW_SLS_ORD_ORD", [{target: "_new_section",target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat }]);
      });
    <?php } ?>

    // EVENTOS. CONSUMOS
    <?php if( $vew_sec->hasPermission("STK","SOU","**") ){ ?>
    	$("#<?= $lv_sec; ?> #crdstksou").css("cursor","pointer");
    	$("#<?= $lv_sec; ?> #crdstksou").on("click",function(e){ e.preventDefault();
        var ch9 = String.fromCharCode(9);
        var lv_pstdat = [{name:"vewfldflt",value:"[~fltrow~]d.dstobjtyp"+ch9+"="+ch9+ch9+"hlt_pat"+ch9+ch9
                                                +"[~fltrow~]d.dstobjcod"+ch9+"="+ch9+ch9+"<?= $vew_data->pat->patcod; ?>"+ch9+ch9
                                                +"[~fltrow~]d.docsts"+ch9+"="+ch9+ch9+"C"+ch9+ch9
                                               }];
        tmssLink("?prg=stkmovdoc&act=08&prm_mdlcod=sls&prm_prgcod=sou&prm_objtyp=stk_sou&prm_vewcod=VEW_STK_MOV_OUT", [{target: "_new_section",target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat }]);
      });
    <?php } ?>

    // EVENTOS. PLANES DE CUIDADO
    <?php if( $vew_sec->hasPermission("HLT","PLA","**") ){ ?>
    	$("#<?= $lv_sec; ?> #crdcrepln").css("cursor","pointer");
    	$("#<?= $lv_sec; ?> #crdcrepln").on("click",function(e){ e.preventDefault();
        var ch9 = String.fromCharCode(9);
        var lv_pstdat = [{name:"vewfldflt",value:"[~fltrow~]c.patcod"+ch9+"="+ch9+ch9+"<?= $vew_data->pat->patcod; ?>"+ch9+ch9
                          											+"[~fltrow~]c.docsts"+ch9+"="+ch9+ch9+"A"+ch9+ch9
                                               }];
        tmssLink("?prg=hltpatcrepln&act=08&prm_mdlcod=hlt&prm_prgcod=pla&prm_objtyp=hlt_pla&prm_vewcod=VEW_HLT_PAT_CRE_PLN", [{target: "_new_section",target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat }]);
      });
    <?php } ?>

		$(function(){ <?= $lv_sec; ?>_refresh(); });    
  </script>
  <script>
    // -----------------------------------------------------
    // EVOLUCIONES
    // -----------------------------------------------------
    
    // BOTON FILTRO
		$("#<?= $lv_sec; ?> #btnevlflt").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->filter; ?>",
				message: $("#<?= $lv_sec; ?> #hltpathstflt").clone(false).attr("id","hltpathstflt2"),
				size: BootstrapDialog.SIZE_WIDE,
				buttons: [{label:"<?= $vew_lang->cancel; ?>", cssClass:"btn-default", action:function(dialogRef){dialogRef.close();}},
									{label:"<?= $vew_lang->apply; ?>", cssClass:"btn-primary", action:function(dialogRef){
                    lv_spccodtxt="";
                    lv_ythmthtxt="";
                    lv_ythtxt="";
                    $(dialogRef.$modalBody).find("li[aria-selected='true']").each(function() {
                      if($(this).data("spccod")!=undefined){
                        lv_spccodtxt+=(lv_spccodtxt!=""?",":"")+$(this).data("spccod");
                      }else if($(this).data("yth")!=undefined && $(this).data("mth")!=undefined ){
                        lv_ythmthtxt+=(lv_ythmthtxt!=""?",":"")+$(this).data("yth")+"-"+$(this).data("mth");
                      }else if($(this).data("yth")!=undefined){
                        lv_ythtxt+=(lv_ythtxt!=""?",":"")+$(this).data("yth");
                      }
                    });
                    
										lv_evlflt=[{name:"spccodtxt",value:lv_spccodtxt},
                               {name:"ythmthtxt",value:lv_ythmthtxt},
                               {name:"ythtxt",value:lv_ythtxt},
                               {name:"prscod",value:$(dialogRef.$modalBody).find("#prscod").val()},
                               {name:"prstxt",value:$(dialogRef.$modalBody).find("#prstxt").val()},
                               {name:"evldte",value:$(dialogRef.$modalBody).find("#evldte").val()}
                              ];
                    lv_fltdat = JSON.stringify(lv_evlflt);
    								$("#<?= $lv_sec; ?> #fltdat").val(lv_fltdat);
                    lv_cnt = lv_evlflt.reduce(function(lp_cnt, lp_itm) {return lp_itm.value != "" && lp_itm.name!="prstxt"  ? lp_cnt + 1 : lp_cnt;}, 0);
                  	if(lv_ythmthtxt!="" && lv_ythtxt!=""){lv_cnt--;}
                    $("#<?= $lv_sec; ?> #fltcnt").text(lv_cnt);
                    //tomo los datos del formulario 
                    <?= $lv_sec; ?>_refreshEvolutionGrid(lv_evlflt);
										dialogRef.close();
									}}],
        onshown:function(dialogRef){
          tmssLoadScript("jstree",function(){
            $(dialogRef.$modalBody).find("#fltspc, #fltythmth").jstree({
              "checkbox" : { "keep_selected_style" : false },
              "core": { "expand_selected_onload" : false, "themes": {	"responsive": true } },
              "plugins" : [ "checkbox" ],
              "multiple": true 
            });
          });
          
          //si se selecciona un año o mes se limpia el campo fecha
            $(dialogRef.$modalBody).find("#fltythmth").on("changed.jstree", function (e, data) {
              if(data.selected.length > 0) {
                // Borra el valor del campo de fecha
                 $(dialogRef.$modalBody).find("#evldte").val("");
              }
          });
          
          // Si se selecciona una fecha, deselecciona los nodos del jstree
          $(dialogRef.$modalBody).find("#evldte").on("change", function() {
            if($(this).val() !== "") {
              // Deselecciona todos los nodos del jstree
               $(dialogRef.$modalBody).find("#fltythmth").jstree(true).deselect_all();
            }
          });
          
          //TYPEAHEAD PRESTADORES 
          var lo_get = {"fldsec":"hltpathstflt2", "fldflt": {"p.docsts":"A"}, "fldasg": {"prscod":"prscod", "prstxt":"prstxt"}};
      		tmssTypeahead($(dialogRef.$modalBody).find("#prstxt"), "hltprs", lo_get);
      		lv_fltdat = $("#<?= $lv_sec; ?> #fltdat").val();
    			if (lv_fltdat) {
            lv_spccodtxt="";lv_ythmthtxt="";lv_ythtxt="";
            
        		lv_evlflt = JSON.parse(lv_fltdat);
            lv_evlflt.forEach(function(item) {
              switch (item.name) {
                case "spccodtxt": lv_spccodtxt = item.value; break;
                case "ythmthtxt": lv_ythmthtxt = item.value; break;
                case "ythtxt": lv_ythtxt = item.value; break;
                case "prscod": $(dialogRef.$modalBody).find("#prscod").val(item.value); break;
                case "prstxt": $(dialogRef.$modalBody).find("#prstxt").val(item.value); break;
                case "evldte": $(dialogRef.$modalBody).find("#evldte").val(item.value); break;
              }
            });
           	// Recargar los valores en el jstree
            if (lv_spccodtxt !== "")$(dialogRef.$modalBody).find("#fltspc").jstree(true).select_node( lv_spccodtxt.split(","));
            if (lv_ythmthtxt !== "")$(dialogRef.$modalBody).find("#fltythmth").jstree(true).select_node( lv_ythmthtxt.split(","));
            if (lv_ythtxt !== "")$(dialogRef.$modalBody).find("#fltythmth").jstree(true).select_node( lv_ythtxt.split(",")); 
          }   
          (dialogRef.$modalBody).find("#hltpathstflt2").removeClass("hidden"); 
        }
			});
		});    
    // FILTRO DE EVOLUCIONES 
    function <?= $lv_sec; ?>_refreshEvolutionFilter(){
      $("#<?= $lv_sec; ?> #fltspc ul").empty();
      $("#<?= $lv_sec; ?> #fltythmth ul").empty();
			tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",[{name:"typ",value:"hltevlflt"},{name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"}],function(data){
        // armo filtro de evoluciones
        for(var i=0; i<data.length; i++){
          lv_dte = moment(data[i].evldte.date);
          if( $("#<?= $lv_sec; ?> #fltspc").find("li[data-spccod="+data[i].spccod+"]").length==0 ){ $("#<?= $lv_sec; ?> #fltspc ul").append(`<li data-jstree='{"icon":"far fa-file", "selected": false}' id='${data[i].spccod}' data-spccod='${data[i].spccod}'>${data[i].spctxt}</li>`); }
          if( $("#<?= $lv_sec; ?> #fltythmth").find("li[data-yth="+lv_dte.format("YYYY")+"]").length==0 ){ $("#<?= $lv_sec; ?> #fltythmth #yth").append(`<li data-jstree='{"icon":"far fa-folder", "selected": false}' id='${lv_dte.format("YYYY")}' data-yth='${lv_dte.format("YYYY")}'>${lv_dte.format("YYYY")}<ul></ul></li>`); }
          if( $("#<?= $lv_sec; ?> #fltythmth").find("li[data-yth="+lv_dte.format("YYYY")+"] li[data-mth="+lv_dte.format("MM")+"]").length==0 ){
            $("#<?= $lv_sec; ?> #fltythmth li[data-yth="+lv_dte.format("YYYY")+"] ul").append(`<li data-jstree='{"icon":"far fa-file", "selected": false}' id='${lv_dte.format("YYYY")}-${lv_dte.format("MM")}' data-yth='${lv_dte.format("YYYY")}' data-mth='${lv_dte.format("MM")}'>${lv_dte.format("MM")}</li>`);
        	}
        }  
     	}); 
    }
    
    // GRILLA
    function <?= $lv_sec; ?>_refreshEvolutionGrid(lp_evlflt = []){
      var lv_spin = "<i class='far fa-gear fa-spin'></i>";
      $("#<?= $lv_sec; ?> #tblhltevl tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
      tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",[{name:"typ",value:"hltevl"},{name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"},...lp_evlflt],function(data){
        $("#<?= $lv_sec; ?> #tblhltevl tbody").empty();
        if( data.length==0 ){ $("#<?= $lv_sec; ?> #tblhltevl tbody").append("<tr><td>No se encontraron evoluciones.</td></tr>"); return; }
        
        // armo filtro y grilla de evoluciones
        for(var i=0; i<data.length; i++){
          lv_dte = moment(data[i].evldte.date);
          lv_buffer = "<tr data-evlcod='"+data[i].evlcod+"' data-plnid='"+data[i].plnid+"' data-plndteid='"+data[i].plndteid+"' data-spcfrm='"+data[i].spcfrm+"'>"
                        +"<td><b>"+lv_dte.format("DD/MM/YYYY")+" - "+data[i].prstxt+"<br>"+data[i].spctxt+"</b></td>"
                        +"<td>"+data[i].evlevl+"<br>"+data[i].evlobj+"</td>"
                        +"</tr>";

          $("#<?= $lv_sec; ?> #tblhltevl tbody").append( lv_buffer );
        }   
        // EVENTOS - GRILLA
        <?php if( $vew_sec->hasPermission("HLT","EVL","03") ){ ?>
        $("#<?= $lv_sec; ?> #tblhltevl tbody tr").on("click",function(e){e.preventDefault                                                                         
          var lv_pstdat =[{name:"evlcod",value:$(this).data("evlcod")},{name:"plnid",value:$(this).data("plnid")},{name:"plndteid",value:$(this).data("plndteid")},{name:"hhcc",value:"X"}];
          var lv_evlfrm = ($(this).data("spcfrm")!=""?$(this).data("spcfrm"):"?prg=hltpatevl&act=03");
          tmssLink( lv_evlfrm, [{target: "_new_section",target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat }]);
        });
        <?php } ?>
			});      
    }
  </script>
	<script>
    // -----------------------------------------------------
    // TURNOS
	  // -----------------------------------------------------

		// Calendario. Inicializacion
		$(function(){
      var lo_today = new Date();
			$("#<?= $lv_sec; ?> #dshcal").data("year", lo_today.getFullYear() );
			$("#<?= $lv_sec; ?> #dshcal").data("month", lo_today.getMonth()+1 );
			<?= $lv_sec; ?>_showCalendar( $("#<?= $lv_sec; ?> #dshcal") );
			<?= $lv_sec; ?>_showCalendarHolidays( $("#<?= $lv_sec; ?> #dshcal") );
		});
		
		// Calendario. MES Siguiente
		$("#<?= $lv_sec; ?> #btncalnxt").on("click",function(e){ e.preventDefault();
			var lv_yth = Number($("#<?= $lv_sec; ?> #dshcal").data("year"));
			var lv_mth = Number($("#<?= $lv_sec; ?> #dshcal").data("month"));
			lv_yth = (lv_mth === 12) ? lv_yth + 1 : lv_yth;
			lv_mth = (lv_mth === 12) ? 1 : lv_mth + 1;
			$("#<?= $lv_sec; ?> #dshcal").data("year",lv_yth);
			$("#<?= $lv_sec; ?> #dshcal").data("month",lv_mth);
			<?= $lv_sec; ?>_showCalendar( $("#<?= $lv_sec; ?> #dshcal") );
			<?= $lv_sec; ?>_showCalendarHolidays( $("#<?= $lv_sec; ?> #dshcal") );
			
			<?= $lv_sec; ?>_refreshTurnGrid();
		});

		// Calendario. MES Anterior
		$("#<?= $lv_sec; ?> #btncalprv").on("click",function(e){ e.preventDefault();
			var lv_yth = Number($("#<?= $lv_sec; ?> #dshcal").data("year"));
			var lv_mth = Number($("#<?= $lv_sec; ?> #dshcal").data("month"));
			lv_yth = (lv_mth === 1) ? lv_yth - 1 : lv_yth;
			lv_mth = (lv_mth === 1) ? 12 : lv_mth - 1;
			$("#<?= $lv_sec; ?> #dshcal").data("year",lv_yth);
			$("#<?= $lv_sec; ?> #dshcal").data("month",lv_mth);								
			<?= $lv_sec; ?>_showCalendar( $("#<?= $lv_sec; ?> #dshcal") );
			<?= $lv_sec; ?>_showCalendarHolidays( $("#<?= $lv_sec; ?> #dshcal") );
			
			<?= $lv_sec; ?>_refreshTurnGrid();
		});
		
		// Calendario. armado y visualizacion
		function <?= $lv_sec; ?>_showCalendar( lp_card, lp_year, lp_month ){
			var lo_months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
			var lv_table = $(lp_card).find(".card-body table:first");
			var lv_yth = Number( $(lp_card).data("year") );
			var lv_mth = Number( $(lp_card).data("month") );
			var lv_today = new Date();
			var lv_frsday = (new Date(lv_yth, lv_mth-1)).getDay();
			var lv_daysInPrvMonth = ( 32 - new Date(((lv_mth===0)?lv_yth-1:lv_yth), ((lv_mth-1===0)?11:lv_mth-1-1), 32).getDate() );								
			var lv_daysInMonth = ( 32 - new Date(lv_yth, lv_mth-1, 32).getDate() );
			$(lp_card).find(".card-header .card-title span:first").text( lo_months[lv_mth-1] + " " + lv_yth );
			$(lv_table).find("tbody tr").remove();
			var lv_day = 1;
			for (var i=0; i<6; i++) {
				$(lv_table).find("tbody").append("<tr class='text-center'><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");									
				for (var j=0; j<7; j++) {
					// dia actual
					if( lv_today.getDate()==lv_day && lv_today.getMonth()+1==lv_mth && lv_today.getFullYear()==lv_yth ){
						$(lv_table).find("tbody tr:nth-child("+(i+1)+") td:nth-child("+(j+1)+")").text( lv_day ).addClass("currentDay");
					}
					// dias mes anterior
					if (i === 0 && j < lv_frsday) {
						$(lv_table).find("tbody tr:nth-child("+(i+1)+") td:nth-child("+(j+1)+")").text( lv_daysInPrvMonth-(lv_frsday-j-1) ).addClass("otherMonth");
					// dias mes siguiente
					} else if (lv_day > lv_daysInMonth) {
						$(lv_table).find("tbody tr:nth-child("+(i+1)+") td:nth-child("+(j+1)+")").text( lv_day-lv_daysInMonth ).addClass("otherMonth");
						lv_day++;
					// dias mes actual
					} else {
						$(lv_table).find("tbody tr:nth-child("+(i+1)+") td:nth-child("+(j+1)+")").text( lv_day );
						$(lv_table).find("tbody tr:nth-child("+(i+1)+") td:nth-child("+(j+1)+")").data("day",lv_day).attr("data-day",lv_day);
						lv_day++;
					}
				}
			}
		}
		
		// Calendario. mostrar feriados
		function <?= $lv_sec; ?>_showCalendarHolidays( lp_card ){
			var lv_yth = Number( $(lp_card).data("year") );
			var lv_mth = Number( $(lp_card).data("month") );
			var lv_daysInMonth = ( 32 - new Date(lv_yth, lv_mth-1, 32).getDate() );
			var lv_pstdat =[{name:"strdte",value:lv_yth+"-"+(lv_mth<10?"0":"")+lv_mth+"-01"},
											{name:"enddte",value:lv_yth+"-"+(lv_mth<10?"0":"")+lv_mth+"-"+lv_daysInMonth}];
			$(lp_card).find(".calendar-holidays div").remove();
			tmssCallProcessNoBackdrop("?prg=admhld&act=23",lv_pstdat,function(data){
				if( data.length==0 ){
					$(lp_card).find(".calendar-holidays").addClass("hidden");
				} else {
					$(lp_card).find(".calendar-holidays").removeClass("hidden");
				}
				$(lp_card).find(".calendar-holidays").append("<div class='container-fluid'><i class='far fa-calendar-image'></i><b> Feriados</b></div>");
				for(var i=0; i<data.length; i++){
					var lv_day = new Date( data[i].hldmovday.date ).getDate();
					//FALTA. no funciona esto de JQUERY por lo que se reemplaza por una busqueda individual
					//$(lp_card).find(".card-body table:first tbody tr td[data-day="+lv_day+"]").addClass("holiday");
					$(lp_card).find(".card-body table:first tbody tr td").each(function(){
						if($(this).data("day")==lv_day){ $(this).addClass("holiday").addClass("bg-default"); }
					});
					
					$(lp_card).find(".calendar-holidays").append("<div class='container-fluid'><i class='far fa-dot'></i>"+lv_day+" - "+data[i].hldmovtxt+"</div>");
				}
			});
		}
    
    // GRILLA
		function <?= $lv_sec; ?>_refreshTurnGrid(){
      var lv_spin = "<i class='far fa-gear fa-spin'></i>";
			$("#<?= $lv_sec; ?> #tblhltpln tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			var lv_yth = Number( $("#<?= $lv_sec; ?> #dshcal").data("year") );
			var lv_mth = Number( $("#<?= $lv_sec; ?> #dshcal").data("month") );
			var lv_daysInMonth = ( 32 - new Date(lv_yth, lv_mth-1, 32).getDate() );
			var lv_pstdat =[{name:"typ",value:"hltpln"},
                      {name:"patcod",value:"<?= $vew_data->pat->patcod; ?>"},
                      {name:"strdte",value:lv_yth+"-"+(lv_mth<10?"0":"")+lv_mth+"-01"},
											{name:"enddte",value:lv_yth+"-"+(lv_mth<10?"0":"")+lv_mth+"-"+lv_daysInMonth}];
			tmssCallProcessNoBackdrop("?prg=hltpathst&act=dsh",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #tblhltpln tbody").empty();
        if( data.length==0 ){ $("#<?= $lv_sec; ?> #tblhltpln tbody").append("<tr><td>No hay turnos este mes.</td></tr>"); return; }
        
        for(var i=0; i<data.length && i<6; i++){
          lv_row = "<tr class='bg-success' data-plnid='"+data[i].plnid+"' data-plndteid='"+data[i].plndteid+"'>"
                  + "<td><b>"+data[i].spctxt+"</b>"
            			+($("<div>"+data[i].plndteatr+"<div>").find("plntrnatn").text()!="" && (data[i].evlcod??"")==""?"<a class='pull-right'><i class='fas fa-check'></i></a>":"")
            			+((data[i].evlcod??"")!=""?"<a class='pull-right'><i class='fas fa-file-medical'></i></a>":"")
            			+"<br>"
                  + data[i].prstxt+"<br>"
                  + moment(data[i].plndte.date).format("DD/MM/YYYY")+" "+moment(data[i].plninbdte.date).format("HH:mm")+" - "+moment(data[i].plnoutdte.date).format("HH:mm")+"<br>"
                  + "</td></tr>"
          $("#<?= $lv_sec; ?> #tblhltpln tbody").append( lv_row );
          $("#<?= $lv_sec; ?> .tmssCalendarSmall tbody tr td[data-day="+moment(data[i].plndte.date).format("D")+"]").addClass("bg-success");
        }

        <?php if( $vew_sec->hasPermission("HLT","PLN","03") ){ ?>
        $("#<?= $lv_sec; ?> #tblhltpln tbody tr").on("click",function(e){e.preventDefault;
          var lv_pstdat = [{name:"plnid",value:$(this).data("plnid")},
                           {name:"plndteid",value:$(this).data("plndteid")}];
          tmssCallProcess("?prg=hltpln&act=03&prm_popup=<?= $lv_sec; ?>", lv_pstdat, function(data){
            BootstrapDialog.show({
              title: "<?= $vew_lang->planning; ?>",
              message: $(data),
              draggable: true,
              size: BootstrapDialog.SIZE_WIDE
              //onhidden: function(dialog){ <?= $lv_sec; ?>_refresh(); }
            });
          });
        });
        <?php } ?>
      });
      
		}
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>