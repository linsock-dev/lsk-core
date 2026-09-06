<?php
	// url del formulario
  $lv_lnk = '?prg=hhrorgcht&prm_hhrorgchtcod='.$vew_data->hhrorgchtcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrorgchttxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrorgchtcod;
	
	// titulo
	$lv_title = $vew_lang->organizationchart;

	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'ORG';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$lv_vrtlvlqty = $vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'vrtlvlqty' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
	<style>
    .tmssCardBodyMaxHeight{
      min-height: calc(100vH - 290px);
      max-height: calc(100vH - 290px);
      overflow-y: scroll;
    }
 
    .orgchart{
      background-image: none !important;
    }
    
    .orgchart .node.completed .content {
      border: 1px solid #5fa75f;
 	 	}
    
    .orgchart .node.completed .title {
      background-color: #5fa75f;
		}
    
    .orgchart .node:not(:only-child)::after{
      background-color: var(--tmss-gray-500);
    }
    
    .orgchart>ul>li>ul li>.node::before{
      background-color: var(--tmss-gray-500);
    }
    
    .orgchart .hierarchy::before{
    	border-top: 2px solid var(--tmss-gray-500);
    }
    
    .orgchart .nodes.vertical .hierarchy::after, .orgchart .nodes.vertical .hierarchy::before{
      border-color: var(--tmss-gray-500);
    }
	</style>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('wrkplccodflt','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation" class="<?= $lv_dockey?'':'hidden' ?>"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->organizationchart; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->hhrorgchtcod; ?><?= gethtml('hhrorgchtcod', 'hidden', $vew_data->hhrorgchtcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
    
        <!-- GENERAL -->
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->data; ?>
                    <div class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </div>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col210, array('label' => $vew_lang->code,
                                                 'input' => gethtml('hhrorgchtcodext', 'doccmt1x20', $vew_data->hhrorgchtcodext, $lv_default))); ?>
                  <?= vew_boot($lv_col210, array('label' => $vew_lang->description,
                                                 'input' => gethtml('hhrorgchttxt', 'doccmt1x50', $vew_data->hhrorgchttxt, $lv_default))); ?>
                  <?= vew_boot($lv_col210, array('label' => $vew_lang->status,
                                                 'input' => gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default))); ?>
                </div>
              </div>
            </div>
					</div>
				</div> <!-- /_tab001 -->
        
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
          <div class="row">
            <div class="col-md-12">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_data->hhrorgchtcodext ? $vew_data->hhrorgchtcodext : $vew_lang->organizationchart; ?>
                    <a id="btnflt" class="card-icon tmssAlwaysEnabled" title="<?= $vew_lang->filter; ?>" ><i class="far fa-filter"></i><span id="fltcnt" class="badge"></span></a>
                    <?php if(!$vew_readonly){ ?>
                    <a id="addNodeBtn" href="#" class="card-icon"><i class="far fa-plus"></i></a> 
                    <a id="deleteNodeBtn" href="#" class="card-icon hidden"><i class="far fa-trash"></i></a>
                    <a id="editNodeBtn" href="#" class="card-icon hidden"><i class="far fa-pencil-alt"></i></a>
                    <?php } ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo gethtml('hhrorgchtwrk', 'hidden', '');
                  	echo gethtml('hhrorgwrkflt', 'hidden', '');
                  ?>
                  <div id="org" class="tmssCardBodyMaxHeight" style="display: flex; align-items: center; justify-content: center; text-align: center;">
                  </div>
                </div>
              </div> <!-- card -->
            </div> <!-- col -->
          </div> <!-- row -->
        </div> <!-- /_tab002 -->
      </div> <!-- /tab-conent -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    function <?= $lv_sec; ?>_updateWrkCpt(lp_node){ 
      var lv_data = JSON.parse(lp_node.find(".data").html())["data"];
      var lv_emptotpft = lv_data["emptotpft"];
      var lv_emptotpftsub = lv_data["emptotpftsub"];
      var lv_wekemppfttotcap = lv_data["wekemppfttotcap"];
      var lv_wekhrspfttotcap = parseFloat(lv_data["wekhrspfttotcap"]);
      var lv_wekhrspfttot = parseFloat(lv_data["wekhrspfttot"]);
      var lv_wekhrsnonpfttotcap = parseFloat(lv_data["wekhrsnonpfttotcap"]);
      var lv_wekhrsnonpfttot = parseFloat(lv_data["wekhrsnonpfttot"]);
      
      lp_node.find(".content").empty();
      
      //productivo
      if(lv_wekhrspfttot || lv_wekhrspfttotcap){
        lp_node.find(".content").append("<i class='fas fa-clock'></i><span class='cpttot'></span>");
        
      	lp_node.find(".cpttot").html(" "+ lv_wekhrspfttot + (lv_wekhrspfttotcap ? " / " + lv_wekhrspfttotcap : ""));
      }
      
      if(lv_emptotpft || lv_wekemppfttotcap){
        lp_node.find(".content").append("<i class='fas fa-user' style='margin-left: 5px;'></i><span class='emptotpft'></span>");
      	lp_node.find(".emptotpft").html(" "+ lv_emptotpft + (lv_wekemppfttotcap ? " / " + lv_wekemppfttotcap : ""));
      }
      
      if(lv_emptotpftsub){
        lp_node.find(".content").append("<i class='fas fa-sitemap' style='margin-left: 5px;'></i><span class='emptotpftsub'></span>");
      	lp_node.find(".emptotpftsub").html(" "+ lv_emptotpftsub);
      }
      
      // no productivo
      if(lv_wekhrsnonpfttot || lv_wekhrsnonpfttotcap){
        lp_node.find(".content").append("<i class='far fa-clock' style='margin-left: 5px;'></i><span class='nonpftcpttot'></span>");
        
      	lp_node.find(".nonpftcpttot").html(" "+ lv_wekhrsnonpfttot + (lv_wekhrsnonpfttotcap ? " / " + lv_wekhrsnonpfttotcap : ""));
      }
      
      if(lv_data["emptotnonpft"] || lv_data["wekempnonpfttotcap"]){
        lp_node.find(".content").append("<i class='far fa-user' style='margin-left: 5px;'></i><span class='emptotnonpft'></span>");
      	lp_node.find(".emptotnonpft").html(" "+ lv_data["emptotnonpft"] + (lv_data["wekempnonpfttotcap"] ? " / " + lv_data["wekempnonpfttotcap"] : ""));
      }
      
      if(lv_data["emptotnonpftsub"]){
        lp_node.find(".content").append("<i class='far fa-sitemap' style='margin-left: 5px;'></i><span class='emptotnonpftsub'></span>");
      	lp_node.find(".emptotnonpftsub").html(" "+ lv_data["emptotnonpftsub"]);
      }
      
      lp_node.toggleClass("completed", lv_wekhrspfttot >= lv_wekhrspfttotcap && lv_emptotpft >= lv_wekemppfttotcap);
    }
  </script>
  <script>
    var lv_<?= $lv_sec; ?>_delNodes = [];
    
    // elimina al nodo junto a todos sus descendientes
  	$("#<?= $lv_sec; ?> #deleteNodeBtn").on("click", function(e){
      // valido acción si el nodo tiene hijos
      var lv_tgt = $("#<?= $lv_sec; ?> #org .node.focused");
      if(lv_tgt.siblings().length){
        BootstrapDialog.confirm({
          title: "Borrar",
          message: "Borrar&aacute; al nodo y todos sus descendientes. Desea continuar?",
          type: BootstrapDialog.TYPE_WARNING,
          callback: (result) => {
            if(result) {
              <?= $lv_sec; ?>_deleteNode(lv_tgt);
            }
          }
        });
      }else{
        <?= $lv_sec; ?>_deleteNode(lv_tgt);
      }
    });
    
    function <?= $lv_sec; ?>_deleteNode(lp_target){
     	// guardo los ids de todos los nodos
      lp_target.parent().find(".node").each(function(i){
        lv_<?= $lv_sec; ?>_delNodes.push($(this).attr("id"));
      });
      
      // quito todos los nodos
      if(lp_target.parent().siblings().length){
        lp_target.parent().remove();
      }else{
      	lp_target.parent().parent().remove();
      }
    }
  </script>
  <script>
    function <?= $lv_sec; ?>_editNode(lp_node){
      var lv_data = JSON.parse(lp_node.find(".data").html());
      <?= $lv_sec; ?>_showJobPosition(lv_data["data"]);
    }
    
    $("#<?= $lv_sec; ?> #editNodeBtn").on("click", function(e){
      <?= $lv_sec; ?>_editNode($("#<?= $lv_sec; ?> #org .node.focused"));
    });
    
    $("#<?= $lv_sec; ?>").on("dblclick", ".node.focused", function(e){
      <?= $lv_sec; ?>_editNode($("#<?= $lv_sec; ?> #org .node.focused"));
    });
    
    $("#<?= $lv_sec; ?> #addNodeBtn").on("click", function(e){
      <?= $lv_sec; ?>_showJobPosition();
    });
    
    function <?= $lv_sec; ?>_formatDate(lp_dte){
      var lv_day = lp_dte.getDate();
      var lv_mth = lp_dte.getMonth()+1;
      lv_day = (lv_day < 10 ? '0' : '') + lv_day;
      lv_mth = (lv_mth < 10 ? '0' : '') + lv_mth;
      return  lv_day +  "/" + lv_mth + "/" + lp_dte.getFullYear();  
    }
    
    function <?= $lv_sec; ?>_showJobPosition(lp_data = []){
      var lv_pst = [{name: "hhrorgchtwrkcod", value: lp_data["hhrorgchtwrkcod"] },
                   {name: "hhrorgchtcod", value: $("#<?= $lv_sec; ?> #hhrorgchtcod").val() }]; 
      tmssCallProcess("?prg=hhrorgcht&act="+(lp_data["hhrorgchtwrkcod"]?"<?= $vew_readonly ? 13 : 12 ?>":"11"), lv_pst, function(view){
        BootstrapDialog.show({
          title: lp_data["wrkstetxt"] ?? "Nuevo puesto",
          message: $(view),
          size: BootstrapDialog.SIZE_WIDE,
          draggable: true,
          closable: false,
        	buttons: [ 
            { label: "<?= $vew_lang->close; ?>", cssClass: "btn-default", action: function(dialog){ dialog.close(); } }
            <?php if(!$vew_readonly){ ?>
            ,{ label: "<?= $vew_lang->save; ?>", cssClass: "btn-success", action: function(dialog){
           	 	var lv_frm = dialog.getModalBody().find("form");
              lv_frm.find("#svebtn").click();
              var lv_data = lv_frm.find("#svedata").val();
              if(lv_data){
              	var lv_pst = JSON.parse(lv_data);
                // grabo 
                tmssCallProcess("?prg=hhrorgcht&act=10", lv_pst, data => { 
                  dialog.close();

                  // recargo organigrama
                  <?= $lv_sec; ?>_refreshOrgchart();
                });
              }
            }}
            <?php } ?>
          ]
        });
      });
    }
    
    function <?= $lv_sec; ?>_refreshOrgchart(){
      var lv_flt = $("#<?= $lv_sec; ?> #hhrorgwrkflt").val()
      lv_flt = lv_flt ? JSON.parse(lv_flt) : gv_<?= $lv_sec; ?>_flt;
      <?= $lv_sec; ?>_fltOrg(lv_flt);
    }
    
    function <?= $lv_sec; ?>_addJobPosition(lp_target, lp_data){
      /*
        si se está seleccionando un nodo, se le añade un hijo
        si no, se añade un nuevo nodo a la altura de la raíz del organigrama
      */
      if(lp_target.length){
        // por cómo funciona el OrgChart, el addChildren funciona solo para los nodos que no tienen ningún hijo
        if(lp_target.siblings().length){  
          lv_<?= $lv_sec; ?>_org.addSiblings(lp_target.siblings(".nodes").children().children(".node:last"), [lp_data]);
        }else{
          lv_<?= $lv_sec; ?>_org.addChildren(lp_target, [lp_data]);
        }
      }else{ 
        lp_data["children"] = [];
        if($("#<?= $lv_sec; ?> #org .node").length){
          lv_<?= $lv_sec; ?>_org.addSiblings($("#<?= $lv_sec; ?> #org .node:first"), lp_data);
        }else{ 
          <?= $lv_sec; ?>_initOrgchart(lp_data);
        }
      }
      <?= $lv_sec; ?>_updateWrkCpt($("#<?= $lv_sec; ?> #"+lp_data["id"]));
    }
    
    
    function <?= $lv_sec; ?>_editJobPosition(lp_target, lp_data){ 
      lp_target.find(".title").html(lp_data["name"]);
      lp_target.find(".data").html(JSON.stringify(lp_data));
      <?= $lv_sec; ?>_updateWrkCpt(lp_target);
    }
  </script>
  <script>	
		var lv_<?= $lv_sec; ?>_org;
    
    $("#<?= $lv_sec; ?> #org").on("click", ".orgchart", function(e){ 
      $("#<?= $lv_sec; ?> #editNodeBtn, #<?= $lv_sec; ?> #deleteNodeBtn").toggleClass("hidden", !$(e.target).hasClass("node") && !$(e.target).parents(".node").length);
    });
    
    function <?= $lv_sec; ?>_initOrgchart(lp_data){
      $("#<?= $lv_sec; ?> #org").empty();
      
      lv_<?= $lv_sec; ?>_org = $("#<?= $lv_sec; ?> #org").orgchart({
				data: lp_data,
        nodeTitle: "name",
				nodeContent: "title",
        verticalLevel: <?= $lv_vrtlvlqty; ?>,
        nodeTemplate: function(data){ 
        	return "<div class='title'>"+data.name+"</div>"
            + "<div class='content'></div>"
          	+"<div class='hidden data'>"+JSON.stringify(data)+"</div>"
          	+"<input class='hidden wrkstecod' value='"+data.wrkstecod+"'>"
          	+"<i class='edge'></i>"; //lo exige el orgchart
        },
				draggable: "<?= !$vew_readonly; ?>",
				pan: true,
				zoom: true,
        zoominLimit: 7,
        zoomoutLimit: 0.5
			});	
      
      $("#<?= $lv_sec; ?> #org").children().addClass("noncollapsable");
      
      lv_<?= $lv_sec; ?>_org.setChartScale( $("#<?= $lv_sec; ?> #org").children().first(), 1.5);
    }
    
    function <?= $lv_sec; ?>_loadOrgchart(lp_data){
      $("#<?= $lv_sec; ?> #org").empty();
      
      for(node of lp_data){
        var lv_data = {};
        lv_data["wrkstehghcod"] = node["wrkstehghcod"];
        lv_data["wrkstetxt"] = node["wrkstetxt"];
        lv_data["wrkstecod"] = node["wrkstecod"];
        lv_data["wrkstedes"] = "";
        lv_data["cap"] = node["cap"];
        lv_data["emptotpft"] = node["emptotpft"] ?? 0;
        lv_data["emptotpftsub"] = node["emptotpftsub"] ?? 0;
        lv_data["emptotnonpft"] = node["emptotnonpft"] ?? 0;
        lv_data["emptotnonpftsub"] = node["emptotnonpftsub"] ?? 0;
        lv_data["wekemppfttotcap"] = node["wekemppfttotcap"]??0;
        lv_data["wekhrspfttotcap"] = parseFloat(node["wekhrspfttotcap"] ?? 0);
        lv_data["wekempnonpfttotcap"] = node["wekempnonpfttotcap"] ?? 0;
        lv_data["wekhrspfttot"] = parseFloat(node["wekhrspfttot"] ?? 0);
        lv_data["wekhrsnonpfttotcap"] = parseFloat(node["wekhrsnonpfttotcap"] ?? 0);
        lv_data["wekhrsnonpfttot"] = parseFloat(node["wekhrsnonpfttot"] ?? 0);
        lv_data["asg"] = node["asg"];
        lv_data["hhrorgchtwrkcod"] = node["hhrorgchtwrkcod"];
        
        let lv_nodeData = {id: node["hhrorgchtwrkcod"],
                          name: node["wrkstetxt"],
                          title: "",
                          relationship: "100",
                          data: lv_data,
                          wrkstecod: node["wrkstecod"]};
        
        let lv_tgt;
        if(lv_data["wrkstehghcod"]){
         lv_tgt = $("#<?= $lv_sec; ?> #org .node[id="+lv_data["wrkstehghcod"]+"]");
        }else{
          lv_tgt = $("#<?= $lv_sec; ?> #org .node.focused");
        }
        <?= $lv_sec; ?>_addJobPosition(lv_tgt, lv_nodeData);
      }
      
      $("#<?= $lv_sec; ?> #org .toggleBtn").remove();
    }
    
    tmssLoadScript("jsondigger", function(){});
		tmssLoadScript("orgchart", function(){});
    
    // drag&drop
    $("#<?= $lv_sec; ?> #org").on("nodedrop.orgchart", function(e, p){
      e.preventDefault();
      var lv_dragZoneNodes = p.dragZone.siblings();
      if(lv_dragZoneNodes.find(">.hierarchy").length > 1){
        lv_dragZoneNodes = p.draggedNode.parent();
      }else if(lv_dragZoneNodes.length == 0){
        lv_dragZoneNodes = p.draggedNode.parents(".hierarchy");
      }
      
      var lv_newParentId = JSON.parse(p.dropZone.find(".data").html())["id"];
      
      // muevo cada nodo a su nuevo lugar
      lv_dragZoneNodes.find(".node").each(function(){
        let lv_nodeData = JSON.parse($(this).find(".data").html());
        let lv_tgt;
        
        if($(this).is(p.draggedNode)){  
          lv_tgt = p.dropZone;
          lv_nodeData["data"]["wrkstehghcod"] = lv_newParentId;
        }else{
          lv_tgt = $("#<?= $lv_sec; ?> #org .node[id="+lv_nodeData["data"]["wrkstehghcod"]+"]");
        }
                                          
        <?= $lv_sec; ?>_addJobPosition(lv_tgt, lv_nodeData);
        $(this).remove();
      });
      
      lv_dragZoneNodes.remove();
      
      // quito el estilo de drag&drop
      $("#<?= $lv_sec; ?> #org .allowedDrop").removeClass("allowedDrop");
      $("#<?= $lv_sec; ?> #org .toggleBtn").remove();
    });
  </script>
  <script>
  	var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->workplace; ?>'     ,'fldcod': 'p.wrkplctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->workstation; ?>'   ,'fldcod': 's.wrkstetxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}];
    
    $("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_fltOrg);
		});
    
    function <?= $lv_sec; ?>_fltOrg(lp_flt) {
      $("#<?= $lv_sec; ?> #hhrorgwrkflt").val(JSON.stringify(lp_flt));
      var lv_wkrplctxt = lp_flt[0]["fldvalstr"];
      var lv_wkrstetxt = lp_flt[1]["fldvalstr"];
      
      var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
      
      var lv_pstdat = {vewfldflt: lv_fltint["fltstr"],
                      wrkplctxt: lp_flt[0]["fldvalstr"],
                      wkrstetxt: lp_flt[1]["fldvalstr"],
                      hhrorgchtcod: "<?= $vew_data->hhrorgchtcod; ?>"};
      
      tmssCallProcess("?prg=hhrorgcht&act=wrkflt", lv_pstdat, function(data){
        for(let i=0; i < data.length; i++){
          // corrige tipo de capacidad
          for(let j=0; j < data[i]["cap"].length; j++){ 
            data[i]["cap"][j]["captyp"] = data[i]["cap"][j]["hhrorgchtwrkcaptyp"] ? "<?= $vew_lang->staff; ?>" : "<?= $vew_lang->hours ?>";
          }
         
          // corrige 1/0 a true/false para el checkbox
          for(let j=0; j < data[i]["asg"].length; j++){ 
            data[i]["asg"][j]["hhremptmestr"] = <?= $lv_sec; ?>_formatDate(new Date(data[i]["asg"][j]["hhremptmestr"]["date"]));
            data[i]["asg"][j]["wrkstepft"] = data[i]["asg"][j]["wrkstepft"] == 1;
          }
        }
      	<?= $lv_sec; ?>_loadOrgchart(data);
        $("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").click();
      });
    }
    
    $(function(){ 
      <?php if($lv_dockey){ ?>
      	<?= $lv_sec; ?>_fltOrg(gv_<?= $lv_sec; ?>_flt);
      <?php } ?>
    });
  </script>
	<script>
    $("#<?= $lv_sec; ?> #org").on("nodedrop.orgchart", ".orgchart", function(e, p){
      var lv_hie = <?= $lv_sec; ?>_parseHierarchy($(p.draggedNode).attr("id"), $(p.dropZone).attr("id"));
      var lv_pst = {hhrorgchtwrk: lv_hie};
      tmssCallProcess("?prg=hhrorgcht&act=15", lv_pst, function(data){
				<?= $lv_sec; ?>_refreshOrgchart();
      });
    });
    
    function <?= $lv_sec; ?>_parseHierarchy(lp_child, lp_parent = ""){
      return "<row>"
          + "<hhrorgchtwrkcod>" + lp_child + "</hhrorgchtwrkcod>"
          + (lp_parent ? "<wrkstehghcod>" + lp_parent + "</wrkstehghcod>" : '')
        	+ "</row>";
    }
    
		// SUBMIT. prepara los datos antes de grabar
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// GRABAR
			if ( lp_prm["action"]=="00" ) { 
        // obtengo datos de nodos
        var lv_hhrorgchtwrk = "";

        $("#<?= $lv_sec; ?> .node").each(function(){ 
          let lv_node = $(this);
          let lv_data = JSON.parse(lv_node.find(".data").html())["data"];

          lv_hhrorgchtwrk += <?= $lv_sec; ?>_parseHierarchy(lv_node.attr("id"), lv_data["wrkstehghcod"]);
        });

        for(let i=0; i< lv_<?= $lv_sec; ?>_delNodes.length; i++){ 
          lv_hhrorgchtwrk += "<row><hhrorgchtwrkcod>"+lv_<?= $lv_sec; ?>_delNodes[i]+"</hhrorgchtwrkcod><deleted>X</deleted></row>";
        }
        
        $("#<?= $lv_sec; ?> #hhrorgchtwrk").val(lv_hhrorgchtwrk);
      }
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>