<?php
	/* url del formulario */
  $lv_lnk = "?prg=zcusu1_sup";
 
	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = "";
 
	/* titulo */
	$lv_title = $vew_lang->dashboard;
	
	/* modulo y programa */
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU3';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');

	//Botones por vista
	$vew_dropdown = false;

	$lv_lvl = (isset($vew_data->level) ? $vew_data->level : 1);
	$lv_opt = (isset($vew_data->option) ? $vew_data->option : 'cnsste');
  
	$lv_entity_arr = array('&OACUTE;' => 'Ó', '&UACUTE;' => 'Ú', '&NTILDE;' => 'Ñ');
  foreach($lv_entity_arr as &$lv_row){
    $lv_row = htmlentities($lv_row, ENT_COMPAT | ENT_HTML401, "UTF-8");
  }
  unset($lv_row);

	$lv_mnudata = array();
	$lv_cat = array();
	switch($lv_opt){
    case 'jfo':
      $lv_mnudata = array(array('title' => strtoupper($vew_lang->consumptions), 'icon' => 'fas fa-traffic-cone', 'nextoption' => 'cns'),
                          array('title' => strtoupper($vew_lang->reports), 'icon' => 'fas fa-file-alt', 'nextoption' => 'rpt'));
      break;
    case 'rpt':
      $lv_mnudata = array(array('title' => strtoupper($vew_lang->StockConsumido), 'icon' => 'fa-solid fa-plus', 'nextoption' => 'stc'),
                          array('title' => strtoupper($vew_lang->MaterialDevuelto), 'icon' => 'fas fa-file-alt', 'nextoption' => 'mcs'));
      break;
      
      
      
  }
?>

<style>
  .tmss-mobile-button{
    color: #555555; 
    display: block;
    padding: 10px;
  }
  
  .tmss-mobile-button:hover{
    cursor: pointer;
  }
  
  .tmss-mobile-button .card-title {
    font-size: 35px;
    font-weight: bold;
    color: #0e0e0e;
    display: flex;
    align-items: center;
    justify-content: space-between;
	}
  
  .title{font-size: 50px; text-align: left; color: #0e0e0e; font-weight: bold;} /*color: #17202a; */
  /*i{float:right;}*/
  .box{height: 50px;}
  .centrar{ padding:20px; font-size:20px; border-radius:20px; font-family: 'Quicksand', sans-serif;}
  .tmss-ml-5{
    margin-left: 5px;
  }
  
</style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm" action="">
    <?=gethtml('tmss_actcod','hidden','')?>
		  
          
    <!-- Card Principal -->
    	
      <!-- NIVEL 1 / OBRAS -->
      <div class="col-md-6 col-md-offset-3 col-xs-12 hidden" data-level=1 data-option="cnsste">
        <div class="card">
          <div class="card-header">
            <div class="card-title">
              <?= $vew_lang->CONSTRUCTIONSITES; ?> 

              <a href="#" class="card-icon"><i class="fas fa-filter"></i></a> 
              <input id="cnsstetxt" type="text" placeholder="Buscar..." class="form-control tmssAlwaysEnabled pull-right tmss-mr-5" style="width:60%;">
            </div>
          </div>
          <div class="card-body">
            <div class="tmss-vertbl-scroll">
              <table id="cnsstetbl" class="table table-hover table-no-bordered table-condensed tmss-fixed-header" data-nextlevel=2 data-nextoption="jfo">
                <thead><tr><th width="15%"> <?= $vew_lang->id ?> </th><th> <?= $vew_lang->address ?> </th></tr></thead>
                <tbody class="cursor-pointer">
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->cnsste)){
                      foreach($vew_data->cnsste as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stecod'].'><td>'.$lv_row['stecod'].'</td><td>'.$lv_row['adrstr'].'</td></tr>';
                      }
                    }
                    echo $lv_rows;
                  ?>
                </tbody>
              </table>
            </div>
            <div>
              <span class="pagination-info">Registros encontrados <span class="badge"><?= (isset($vew_data->cnsste) ? count($vew_data->cnsste) : 0); ?></span></span>
            </div>
          </div>
        </div>
      </div>
		
    	<?php
        // armo menú
        if(count($lv_mnudata) > 0){
          $lv_menuoptions =  '<div class="col-md-offset-2 col-md-4 col-sm-6 col-xs-12 ">';
          foreach($lv_mnudata as $lv_key => $lv_row){
            if(count($lv_mnudata) / ($lv_key+1) < 2){
              $lv_menuoptions .= '</div><div class="col-md-4 col-sm-6 col-xs-12 ">';              
            }

            $lv_menuoptions .= 
              '<div class="card tmss-mobile-button tmss-mobile-button-big" name="menu-option" data-nextoption="'.$lv_row['nextoption'].'">'.
                '<div class="card-title">'.
                  $lv_row['title'].'<i class="'.$lv_row['icon'].'"></i>'.
                '</div>'.
              '</div>';
          }
          echo '<div class="row hidden" data-level='.$lv_lvl.' data-option="'.$lv_opt.'">'.$lv_menuoptions.'</div></div>';
        }
      ?>
    
    
			<!-- NIVEL 3 / CONSUMOS -->
      <div id="sup-card-consumos" class="col-md-offset-3 col-md-6 hidden" data-level=3 data-option="cns">
        <div class="card">
          <div class="card-header">
            <div class="card-title"><?= $vew_lang->date; ?>
              <a href="#" class="card-icon" data-nextoption="addDte" data-evttyp="<?= isset($vew_data->evttyp) ? $vew_data->evttyp : ''; ?>"><i class="fa-solid fa-plus"></i></a> 
            </div>
          </div>
          <div class="card-body">
            <div class="tmss-vertbl-scroll">
              <table id="ordtbl" class="table table-hover table-no-bordered table-condensed">
                <thead>
                  <tr>
                    <th> <?= $vew_lang->date ?> </th>
                  </tr>
                </thead>
                <tbody class="cursor-pointer">
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->stkmovdoc)){
                      foreach($vew_data->stkmovdoc as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stkmovdocdtecnv'].'>'.
                                      '<td>'.$lv_row['stkmovdocdtecnv'].'</td>'.
                                      '<td>'.$lv_row['srcobjcod'].'</td>'.
                                    '</tr>';
                      } 
                    }
                    echo $lv_rows;
                  ?>
                </tbody>
              </table>
            </div>
            <div>
              <span class="pagination-info">Registros encontrados <span class="badge"><?= (isset($vew_data->cnssteord) ? count($vew_data->cnssteord) : 0); ?></span></span>
            </div>
          </div>
        </div>
      </div>
    
    	<!-- Material Devuelto -->
      <div id="sup-card-consumos" class="col-md-offset-3 col-md-6 hidden" data-level=4 data-option="mcs">
        <div class="card">
          <div class="card-header">
            <div class="card-title"><?= $vew_lang->MaterialDevuelto; ?>
              <a href="#" class="card-icon" data-nextoption="showord"><i class="fa-solid fa-plus"></i></a> 
            </div>
          </div>
          <div class="card-body">
            <div class="tmss-vertbl-scroll">
              <table id="ordtbl" class="table table-hover table-no-bordered table-condensed">
                <thead>
                  <tr>
                    <th> <?= $vew_lang->date ?> </th>
                    <th> <?= $vew_lang->DESTINATION ?> </th>
                  </tr>
                </thead>
                <tbody class="cursor-pointer">
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->stkmovdoc)){
                      foreach($vew_data->stkmovdoc as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stkmovdocdtecnv'].'>'.
                                      '<td>'.$lv_row['stkmovdocdtecnv'].'</td>'.
                                      '<td>'.$lv_row['srcobjcod'].'</td>'.
                                    '</tr>';
                      } 
                    }
                    echo $lv_rows;
                  ?>
                </tbody>
              </table>
            </div>
            <div>
              <span class="pagination-info">Registros encontrados <span class="badge"><?= (isset($vew_data->cnssteord) ? count($vew_data->cnssteord) : 0); ?></span></span>
            </div>
          </div>
        </div>
      </div>

    	<!-- Stock y Consumido -->
      <div id="sup-card-consumos" class="col-md-offset-3 col-md-6 hidden" data-level=4 data-option="stc">
        <div class="card">
          <div class="card-header">
            <div class="card-title"><?= $vew_lang->StockConsumido; ?>
              <a href="#" class="card-icon" data-nextoption="showord"><i class="fa-solid fa-plus"></i></a> 
            </div>
          </div>
          <div class="card-body">
            <div class="tmss-vertbl-scroll">
              <table id="ordtbl" class="table table-hover table-no-bordered table-condensed">
                <thead>
                  <tr>
                    <th> <?= $vew_lang->name ?> </th>
                    <th> <?= $vew_lang->quantity ?> </th>
                    <th> <?= $vew_lang->consumido ?> </th>
                    <th> <?= $vew_lang->um ?> </th>
                  </tr>
                </thead>
                <tbody class="cursor-pointer">
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->stkmovdoc)){
                      foreach($vew_data->stkmovdoc as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stkmovdocdtecnv'].'>'.
                                      '<td>'.$lv_row['stkmovdocdtecnv'].'</td>'.
                                      '<td>'.$lv_row['srcobjcod'].'</td>'.
                                    '</tr>';
                      } 
                    }
                    echo $lv_rows;
                  ?>
                </tbody>
              </table>
            </div>
            <div>
              <span class="pagination-info">Registros encontrados <span class="badge"><?= (isset($vew_data->cnssteord) ? count($vew_data->cnssteord) : 0); ?></span></span>
            </div>
          </div>
        </div>
      </div>

	</form>
  <script>
  	$(function(){
      var lv_lvl = <?= $lv_lvl ?>;
      var lv_opt = "<?= $lv_opt ?>";
      
      if(tmssIsMobile()){
        // ajustar tamaño de pantalla
        $("#<?= $lv_sec; ?> [data-option='"+lv_opt+"']").height($(window).height() - $("#<?= $lv_sec;?>").height() - 80);
        $("#<?= $lv_sec; ?> [data-option='"+lv_opt+"'] div:has(.pagination-info)").addClass("tmss-pt-3");
        $("#<?= $lv_sec; ?> [data-option='"+lv_opt+"'] .tmss-vertbl-scroll").css("height", "100%");
      }else{
        $("#<?= $lv_sec; ?> [data-option='"+lv_opt+"']").height($(window).height() - $("#<?= $lv_sec;?>").height() - 200);
      }
      
      $("#<?= $lv_sec; ?> [data-option='"+lv_opt+"'] .card-body:has(.tmss-vertbl-scroll)").css("display", "flex").css("flex-direction", "column").css("justify-content", "space-between");
      $("#<?= $lv_sec; ?> [data-option='"+lv_opt+"'] .card").css("height", "100%");
      
      // mostrar pantalla correspondiente
      $("#<?= $lv_sec; ?> [data-level="+lv_lvl+"][data-option='"+lv_opt+"']").removeClass("hidden");
    });
  </script>
    <script>
    // búsqueda de obra por input
  	$("#<?= $lv_sec; ?> #cnsstetxt").on("keyup",function(e){
      var lv_found;
			var lv_count=0;
		  var lv_txt = $("#<?= $lv_sec; ?> #cnsstetxt").prop("value").toUpperCase();
			$("#<?= $lv_sec; ?> #cnsstetbl tbody tr td:nth-child(2)").each(function(){ 
				lv_found = false;  
        
        if($(this).text().toUpperCase().indexOf(lv_txt)>-1) {
        	lv_found=true;
       	}
        
				if(lv_found==false && lv_txt!=""){
					$(this).parents("tr").addClass("hidden");
				} else {
					$(this).parents("tr").removeClass("hidden");
					lv_count++;
				}
		  });
			$("#<?= $lv_sec; ?> .badge").text( lv_count );
		});	
  </script>
  <script>
    // Selección de una obra
    $("#<?= $lv_sec; ?> #cnsstetbl tbody tr, #<?= $lv_sec; ?> #atttbl tbody tr").on("click", function(e){
      e.preventDefault();
      
      var lv_cnsste = <?= json_encode(isset($vew_data->cnsste)?$vew_data->cnsste:array()); ?>;
      
      tmssLink("?prg=zcusu1_sup&act=dshjfo", 
               [{target: "_new_section", 
                 post_data: [{name: "stecod", value: $(this).data("stecod")}, 
                             {name: "level", value: $(this).parents("[data-nextlevel]").data("nextlevel")},
                             {name: "option", value: $(this).parents("[data-nextoption]").data("nextoption")},
                            	{name: "title", value: lv_cnsste[$(this).index()]["adrstr"] }] 
                }]);
    });
    
    
    // Selección de una opción de menú
    $("#<?= $lv_sec; ?> [data-nextoption]:not(table)").on("click", function(e){ 
      e.preventDefault();
      
      if($(this).data("nextoption") != 'showins'){
        tmssLink("?prg=zcusu1_sup&act=dshjfo", 
                 [{target: "_new_section", 
                   post_data: [{name: "level", value: $(this).parents("[data-level]").data("level") + 1},
                               {name: "stecod", value: "<?= $vew_data->stecod; ?>"},
                               {name: "option", value: $(this).data("nextoption")}] 
                  }]);
      }else{
        tmssCallProcess("?prg=cnssteevt&act=getForm&prm_frm=ins", [{name:"oldSec", value:""}, {name:"navbar", value:"X"}], function(data){
          var lv_tmptab = $("#pageTabContent > .tab-pane.active > .tab-frame:last");
          $(lv_tmptab).find("> section").each( function() {
              $(this).hide();
          });
          $(lv_tmptab).append(data);
        });
      }
    });
  </script>
  <script>
		// busqueda
		$("#<?= $lv_sec; ?> #dshjotxtfnd").on("keyup",function(e){
      var lv_found;
			var lv_count=0;
		  var lv_txt = $("#<?= $lv_sec; ?> #dshjotxtfnd").prop("value").toUpperCase();
			$("#<?= $lv_sec; ?> #tmss-table-cnsbudtbl tbody tr").each(function(){   
				lv_found = false;
				$(this).find("td input:first").each(function(){
					if($(this).text().toUpperCase().indexOf(lv_txt)>-1){ lv_found=true; }
				});
				if(lv_found==false && lv_txt!=""){
					$(this).parent().parent().addClass("hidden");
				} else {
					$(this).parent().parent().removeClass("hidden");
					lv_count++;
				}
		  });
			$("#<?= $lv_sec; ?> #count").text( lv_count );
		});	

    
    /*Nuevo consumo 
    $("#<?= $lv_sec; ?> [data-nextoption='addEvt']").on("click", function(e){
      e.preventDefault();
      
    tmssLink("?prg=zcusu1_sup&act=dshjfo", 
               [{target: "_new_section", 
                 post_data: [{name: "stecod", value: "<?= $vew_data->stecod; ?>"}, 
                             {name: "frm", value: $(this).data("evttyp").toLowerCase()},
                             {name: "sysdocclstxt", value: "<?= (isset($vew_data->evttxt) ? $vew_data->evttxt : ''); ?>"},
                             {name: "level", value: $(this).parents("[data-level]").data("level")+1},
                             {name: "option", value: $(this).data("nextoption")},
                             {name: "oldSec", value:""},
                             {name: "navbar", value:"X"},
                             {name: "title", value: "<?= $lv_title; ?>"},
                             {name: "subtitle", value: "<?= $vew_data->stecod; ?>"}] 
                }]);
    });
    */
    
  </script>
  <script>
  $("#<?= $lv_sec; ?> .tmss-navbar-title").html("General <span class='tmss-navbar-subtitle'>Obras</span>");
  $("#<?= $lv_sec; ?> #reportsinside").addClass("hidden");
    
  tmssCallProcess("?prg=zcusu1_sup&act=getSiteList&prm_mdlcod=zcu&prm_prgcod=su3&prm_vewcod=VEW_CNS_STE_DSH", [], function(data){
    var go_<?= $lv_sec; ?>_tblcfgste;
    var gv_<?= $lv_sec; ?>_tbldatste; 
    go_<?= $lv_sec; ?>_tblcfgste = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->ID; ?>", width:"40px"}, {title:"<?= $vew_lang->ADDRESS; ?>"}],
                columnsData: [
                              { id: "stecod", type:"TEXT" },
                              { id: "adrstr", type:"TEXT" },  
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}],
                onRowClick: function(index) { 
                  //Dentro de la tabla
                  $("#<?= $lv_sec; ?> #gral").addClass("hidden");
                  $("#<?= $lv_sec; ?> #jfocard").removeClass("hidden");
                  $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Jefe de Obra <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span>"); 
                  //Consumo
                  $("#<?= $lv_sec; ?> #reports:not(:hidden) .tmss-mobile-button[data-option='Consumo']").click(function(){
                  $("#<?= $lv_sec; ?> #reports:not(:hidden)").remove();
                    
                    var gv_<?= $lv_sec; ?>_tbldatctr = new Array();
                    
                    for(var i=0; i<gv_<?= $lv_sec ?>_ctrdte.length; i++){
                      if(gv_<?= $lv_sec ?>_ctrdte[i]["srcobjcod"]== go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod ){
                        gv_<?= $lv_sec; ?>_tbldatctr.push({"stkmovdocdte": gv_<?= $lv_sec ?>_ctrdte[i]["stkmovdocdte"]});
                      }
                    }
                    go_<?= $lv_sec; ?>_tblctr.loadData(gv_<?= $lv_sec; ?>_tbldatctr);
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Jefe de Obra <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Consumo</span>");
                    $("#<?= $lv_sec; ?> #jfocard").addClass("hidden");
                    $("#<?= $lv_sec; ?> #reportsinside").removeClass("hidden");
                  });
                  //Nuevo
                  $("#<?= $lv_sec; ?> #nuevoEx").attr("onclick", "");  
    							$("#<?= $lv_sec; ?> #nuevoEx").click(function(){
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Jefe de Obra <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Nuevo</span>");
                    $("#<?= $lv_sec; ?> #reportsinside").addClass("hidden");
                    $("#<?= $lv_sec; ?> #nuevoIn").removeClass("hidden");
                  });
                  //Reportes
                  $("#<?= $lv_sec; ?> #reportEx").attr("onclick", "");  
    							$("#<?= $lv_sec; ?> #reportEx").click(function(){
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Jefe de Obra <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Reportes</span>");
                    $("#<?= $lv_sec; ?> #jfocard").addClass("hidden");
                    $("#<?= $lv_sec; ?> #stock").removeClass("hidden");
                    $("#<?= $lv_sec; ?> #matdevmatdev").removeClass("hidden");
                  });
    							//Stock y Consumido
                  $("#<?= $lv_sec; ?> #stock").attr("onclick", "");  
    							$("#<?= $lv_sec; ?> #stock").click(function(){
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Jefe de Obra <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Stock y Consumido</span>");
                    $("#<?= $lv_sec; ?> #stock").addClass("hidden");
                    $("#<?= $lv_sec; ?> #matdevmatdev").addClass("hidden"); 
                    $("#<?= $lv_sec; ?> #tblcsm").removeClass("hidden");
                  });
    							//Material Devuelto
                  $("#<?= $lv_sec; ?> #matdevmatdev").attr("onclick", "");  
    							$("#<?= $lv_sec; ?> #matdevmatdev").click(function(){
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Jefe de Obra <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Material Devuelto</span>");
                    $("#<?= $lv_sec; ?> #stock").addClass("hidden");
                    $("#<?= $lv_sec; ?> #matdevmatdev").addClass("hidden"); 
                    $("#<?= $lv_sec; ?> #tblmat").removeClass("hidden");
                  });
                  //Btn volver atras
                  $("#<?= $lv_sec; ?> #btncls").attr("onclick", "");  
    							$("#<?= $lv_sec; ?> #btncls").click(function(){
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("General <span class='tmss-navbar-subtitle'>Obras</span>");
                    $("#<?= $lv_sec; ?> #reportsinside").addClass("hidden");
                  	$("#<?= $lv_sec; ?> #jfocard").addClass("hidden");
                    $("#<?= $lv_sec; ?> #nuevoIn").addClass("hidden");
										$("#<?= $lv_sec; ?> #stock").addClass("hidden");
                    $("#<?= $lv_sec; ?> #matdevmatdev").addClass("hidden");
                    $("#<?= $lv_sec; ?> #tblcsm").addClass("hidden");
                    $("#<?= $lv_sec; ?> #tblmat").addClass("hidden");
                    $("#<?= $lv_sec; ?> #gral").removeClass("hidden");
                    $("#<?= $lv_sec; ?> #reports:not(:hidden)").remove();
                  });
                  
                }

    };

    gv_<?= $lv_sec; ?>_tbldatste = data.data;

    go_<?= $lv_sec; ?>_tblste = new tmssTable($("#<?= $lv_sec; ?> #cnsbudtbl"), go_<?= $lv_sec; ?>_tblcfgste);

    go_<?= $lv_sec; ?>_tblste.loadData(gv_<?= $lv_sec; ?>_tbldatste);
    });

  </script>
  <script>
    var go_<?= $lv_sec; ?>_tblctr;
    var go_<?= $lv_sec; ?>_tblcfgctr;
    var gv_<?= $lv_sec ?>_ctrdte; 
    go_<?= $lv_sec; ?>_tblcfgctr = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->DATE; ?>", width:"100%"}],
                columnsData: [
                              { id: "stkmovdocdte", type:"TEXT" },  
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
    };

    gv_<?= $lv_sec ?>_ctrdte = [<?php
        $lv_buffer='';
				foreach($vew_data->stkmovdoc as $lv_row) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'stkmovdocdte:"'.$lv_row['stkmovdocdtecnv'].'",'.
            						'srcobjcod:"'.$lv_row['srcobjcod'].
            						'"}';
				}
				echo $lv_buffer;
			?>];		
    go_<?= $lv_sec; ?>_tblctr = new tmssTable($("#<?= $lv_sec; ?> #stkmovdoctbl"), go_<?= $lv_sec; ?>_tblcfgctr);
    
  </script>
  <script>
    <?php if(isset($vew_data->option) && strpos($vew_data->option, 'show')===0){ ?>
    
      function <?= $lv_sec; ?>_formeditext(){ 
       tmssFormEdit("<?= $lv_sec; ?>", <?= isset($vew_data->code)?'false':'true'?>); 
      }
    <?php } ?>
  </script>
  <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>  
</section>