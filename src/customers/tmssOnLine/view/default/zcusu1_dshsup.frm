<?php
	/* url del formulario */
  $lv_lnk = "?prg=zcusu1_sup";

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = ($vew_subtitle !== '' ? $vew_subtitle : ''); 

	/* titulo */
	$lv_title = ($vew_title !== '' ? $vew_title : $vew_lang->dashboard);
	
	/* modulo y programa */
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU2';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');

	// Botones por vista
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
    case 'sup':
      $lv_mnudata = array(array('title' => strtoupper($vew_lang->orders), 'icon' => 'fas fa-dolly-flatbed', 'data' => array('nextoption' =>'ord'), 'class' => 'disabled'),
                          array('title' => strtoupper($vew_lang->forms), 'icon' => 'fas fa-edit', 'data' => array('nextoption' =>'frm', 'enabled' => 'true')),
                          array('title' => strtoupper($vew_lang->consumptions), 'icon' => 'fas fa-traffic-cone', 'data' => array('nextoption' =>'cns'), 'class' => 'disabled'),
                          array('title' => strtoupper($vew_lang->reports), 'icon' => 'fas fa-file-alt', 'data' => array('nextoption' =>'rpt'), 'class' => 'disabled'),
                          array('title' => strtoupper($vew_lang->returns), 'icon' => 'fas fa-reply', 'data' => array('nextoption' =>'rtn'), 'class' => 'disabled'));
      break;
                  
    case 'frm':
      $lv_mnudata = array(array('title' => strtoupper($vew_lang->attendance), 'icon' => 'fas fa-edit', 'data' => array('nextoption' => 'evtlist', 'evttyp' => 'ATT', 'evttxt' => 'ASISTENCIA', 'enabled' => 'true')),
                          array('title' => str_replace(array_keys($lv_entity_arr), array_values($lv_entity_arr), strtoupper($vew_lang->inspection)), 'icon' => 'fas fa-edit', 'data' => array('nextoption' =>'evtlist', 'evttyp' => 'INS', 'evttxt' => 'INSPECCION', 'enabled' => 'true')),
                          array('title' => strtoupper($vew_lang->securitycontrol), 'icon' => 'fas fa-edit', 'data' => array('nextoption' =>'evtlist', 'evttyp' => 'CTRSEG', 'evttxt' => 'CONTROL DE SEGURIDAD', 'enabled' => 'true')),
                          array('title' => 'A.T.S', 'icon' => 'fas fa-edit', 'data' => array('nextoption' =>'evtlist', 'evttyp' => 'ATS', 'evttxt' => 'A.T.S.', 'enabled' => 'true')));
      break;
   
  }
?>

<style>
  .card.tmss-dropdown-card.tmss-closed-card > .card-header{
      border-bottom: none !important;
  }
  .tmss-dropdown-card > div:first-child:hover{
    cursor: pointer;
  }
  .tmss-dropdown-card .big-card-title {
    font-size: 25px;
    font-weight: bold;
    color: #0e0e0e;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  
  .tmss-dropdown-card.disabled {
    pointer-events: none;
    background-color: #ccc;
	}
  
  .title{font-size: 50px; text-align: left; color: #0e0e0e; font-weight: bold;} /*color: #17202a; */
  /*i{float:right;}*/
  .box{height: 50px;}
  .centrar{ padding:20px; font-size:20px; border-radius:20px; font-family: 'Quicksand', sans-serif;}
  .tmss-mr-5{
    margin-right: 5px;
  }
  
  .tmss-fixed-header th{
    background: white;
    position: sticky;
    top: 0;
  }
</style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm" action="">
    <?=gethtml('tmss_actcod','hidden','')?>
		<div class="container-fluid">
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
              <table id="cnsstetbl" class="table table-hover table-no-bordered table-condensed tmss-fixed-header" data-nextlevel=2 data-nextoption="sup">
                <thead><tr><th width="15%"> <?= $vew_lang->id ?> </th><th> <?= $vew_lang->address ?> </th></tr></thead>
                <tbody>
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->cnsste)){
                      foreach($vew_data->cnsste as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stecod'].'><td>'.$lv_row['stecod'].'</td><td>'.$lv_row['adrstr'].' '.$lv_row['adrstrnum'].'</td></tr>';
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

      <!-- NIVEL 3 / PEDIDOS -->
      <div id="sup-card-pedido" class="col-md-offset-3 col-md-6 hidden" data-level=3 data-option="ord">
        <!--<div class="col-md-12">
          <div id="nuevoPedido" class="col-md-6 col-xs-12 tmss-mobile-button -thin" data-option="nuevo" data-title="nuevo">
            <div class="card">
              <div class="card-title">
                <div class="title"><span>Nuevo</span></div>
              </div>
            </div>
          </div>
        </div>-->
        <div class="card">
          <div class="card-header">
            <div class="card-title"><?= $vew_lang->ORDERS; ?>
              <a href="#" class="card-icon" data-nextoption="showord"><i class="fa-solid fa-plus"></i></a> 
            </div>
          </div>
          <div class="card-body">
            <div class="tmss-vertbl-scroll">
              <table id="ordtbl" class="table table-hover table-no-bordered table-condensed">
                <thead>
                  <tr>
                    <th> <?= $vew_lang->description ?> </th>
                    <th> <?= $vew_lang->date ?> </th>
                  </tr>
                </thead>
                <tbody class="cursor-pointer">
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->cnssteord)){
                      foreach($vew_data->cnssteord as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stecod'].'>'.
                                      '<td>'.$lv_row['stecod'].'</td>'.
                                      '<td>'.$lv_row['adrstr'].'</td>'.
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

      <!-- NIVEL 4 / NUEVO PEDIDO -->
      <div class="hidden" data-level=4 data-option="showord">
        <div class="col-md-6 col-xs-12" >
          <div class="card">
            <div class="card-header">
              <div class="card-title"><?= $vew_lang->order; ?></div>
            </div> 
            <div class="card-body tmss-card-body-edit">
              <?php
                echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('ordtxt', 'doccmt1x50', '', $lv_default) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('orddte', 'docdte', (isset($vew_data->orddte) ? $vew_data->orddte : date('d/m/Y')),	$lv_default) ));
              ?>
            </div>
          </div>
        </div>
        <div class="col-md-6 col-xs-12">
          <div class="card">
            <div class="card-header">
              <div class="card-title"><?= $vew_lang->materials; ?></div>
            </div>
            <div class="card-body">
              <div name="stkmattbl" id="stkmattbl"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- NIVEL 4 / EVENTOS LISTADO  -->
      <div id="sup-card-pedido" class="col-md-offset-3 col-md-6 hidden" data-level=4 data-option="evtlist">
        <div class="card">
          <div class="card-header">
            <div class="card-title"> 
              <?php 
                if(isset($vew_data->evttyp)){
                  switch($vew_data->evttyp){
                    case 'ATT': $lv_ttl = $vew_lang->attendance; break;
                    case 'CTRSEG': $lv_ttl = $vew_lang->SECURITYCONTROL; break;
                    case 'INS': $lv_ttl = $vew_lang->inspection; break;
                    case 'ATS': $lv_ttl = 'A.T.S'; break;
                  } 
                  echo $lv_ttl;
                } 
              ?>
              <a href="#" class="card-icon" data-nextoption="addEvt" data-evttyp="<?= isset($vew_data->evttyp) ? $vew_data->evttyp : ''; ?>"><i class="fa-solid fa-plus"></i></a> 
            </div>
          </div>
          <div class="card-body">
            <?php
            	echo (isset($vew_data->evttxt) ? gethtml('evttxt', 'hidden', $vew_data->evttxt): '');
            	echo (isset($vew_data->evttyp) ? gethtml('evttyp', 'hidden', $vew_data->evttyp): '');
            ?>
            <div class="tmss-vertbl-scroll">
              <table id="evttbl" class="table table-hover table-no-bordered table-condensed tmss-fixed-header" data-nextlevel=5 data-nextoption="showFrm">
                <thead>
                  <tr>
                    <th width="15%"> <?= $vew_lang->id ?> </th>
                    <th> <?= $vew_lang->date ?> </th>
                  </tr>
                </thead>
                <tbody class="cursor-pointer">
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->cnssteevt)){
                      foreach($vew_data->cnssteevt as $lv_row){
                        $lv_rows .= '<tr data-steevtcod='.$lv_row['steevtcod'].'>'.
                                      '<td>'.$lv_row['steevtcod'].'</td>'.
                                      '<td>'.$lv_row['steevtdte']->format('d/m/Y').'</td>'.
                                    '</tr>';
                      } 
                    }
                    echo $lv_rows;
                  ?>
                </tbody>
              </table>
            </div>
            <div>
              <span class="pagination-info">Registros encontrados <span class="badge"><?= (isset($vew_data->cnssteevt) ? count($vew_data->cnssteevt) : 0); ?></span></span>
            </div>
          </div>
        </div>
      </div>

      <!-- NIVEL 5 / NUEVA ASISTENCIA -->
      <div class="col-md-offset-3 col-md-6 col-xs-12 hidden" data-level=5 data-option="showatt">
        <div class="card">
          <div class="card-header">
            <div class="card-title"><?= $vew_lang->order; ?></div>
          </div> 
          <div class="card-body tmss-card-body-edit">
            <?php
              echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('orddte', 'docdte', (isset($vew_data->orddte) ? $vew_data->orddte: date('d/m/Y')),	$lv_default) ));
            ?>
            <hr>
            <div class="tmss-vertbl-scroll">
              <table id="atttbl" class="table table-hover table-no-bordered table-condensed">
                <thead>
                  <tr>
                    <th width="90%"> <?= $vew_lang->wizard ?> </th>
                    <th width="10%"> <?= $vew_lang->attended ?> </th>
                  </tr>
                </thead>
                <tbody>
                  <?php
                    $lv_rows = '';
                    if(isset($vew_data->cnssteatt)){
                      foreach($vew_data->cnssteatt as $lv_row){
                        $lv_rows .= '<tr data-stecod='.$lv_row['stecod'].'>'.
                                      '<td>'.$lv_row['adrstr'].'</td>'.
                                      '<td>'.
                                        '<input class="cursor-pointer" type="checkbox" '.($lv_row['adrstr'] ? 'checked' : '').'>'.
                                      '</td>'.
                                    '</tr>';
                      } 
                    }
                    echo $lv_rows;
                  ?>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <?php
        // armo menú
        if(count($lv_mnudata) > 0){
          $lv_menuoptions = '<div class="col-md-offset-2 col-md-4 col-sm-6 col-xs-12 ">';
        	$lv_nextcol = false;
          foreach($lv_mnudata as $lv_key => $lv_row){
            if(count($lv_mnudata) / ($lv_key+1) < 2 && !$lv_nextcol){
            	$lv_nextcol = true;
              $lv_menuoptions .= '</div><div class="col-md-4 col-sm-6 col-xs-12 ">';              
            }

            $lv_menuoptions .= '<div class="card tmss-dropdown-card tmss-closed-card '.(isset($lv_row['class']) ? $lv_row['class']:'').'" name="menu-option"';
            // añado data a la opción
            
            foreach($lv_row['data'] as $lv_key2 => $lv_row2){
              $lv_menuoptions .= ' data-'.$lv_key2.'="'.$lv_row2.'" ';
            }
            $lv_menuoptions .= '>'.
                '<div class="card-header">'.
                  '<div class="card-title big-card-title">'.
                    $lv_row['title'].'<i class="'.$lv_row['icon'].'"></i>'.
                  '</div>'.
                '</div>'.
              '</div>';
          }
          echo '<div class="row hidden" data-level='.$lv_lvl.' data-option="'.$lv_opt.'">'.$lv_menuoptions.'</div></div>';
        }
      ?>

      <!-- NIVEL 3 / CONSUMOS -->
      <div id="sup-card-consumos" class="hidden" data-level=3 data-option="cns">
        <div class="col-md-12">
          <div id="control" class="col-md-6 col-xs-12 tmss-mobile-button -thin">
            <div class="card">
              <div class="card-title">
                <div class="title"><span>Controlar</span></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- NIVEL 3 / REPORTES -->
      <div id="sup-card-reportes" class="hidden" data-level=3 data-option="rpt">
        <div class="col-md-12">
          <div id="stockConsumo" class="col-md-6 col-xs-12 tmss-mobile-button -thin">
            <div class="card">
              <div class="card-title">
                <div class="title"><span>Stock y consumido</span></div>
              </div>
            </div>
          </div>
          <div id="materialDevuelto" class="col-md-6 col-xs-12 tmss-mobile-button -thin">
            <div class="card">
              <div class="card-title">
                <div class="title"><span>Material Devuelto</span></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- NIVEL 3 / DEVOLCUIONES -->
      <div id="sup-card-devolucion" class="hidden" data-level=3 data-option="rtn">
        <div class="col-md-12">
          <div id="devoluciones" class="col-md-6 col-xs-12 tmss-mobile-button -thin">
            <div class="card">
              <div class="card-title">
                <div class="title"><span>Devoluciones</span></div>
              </div>
            </div>
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
  
  <?php if($lv_opt == 'cnsste'){ ?>
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
  <?php } ?>
  
  <?php if($lv_opt == 'evtlist'){ ?>
  <script>
    // actualiza vista de eventos
    function <?= $lv_sec; ?>_GridRefresh(){
      var lv_pstdat = [{name: "stecod", value: "<?= $vew_data->stecod; ?>"},
                       {name: "level", value: "<?= $lv_lvl; ?>"},
                       {name: "option", value: "<?= $lv_opt; ?>"},
                      {name: "evttxt", value: $("#<?= $lv_sec; ?> #evttxt").val()},
                      {name: "evttyp", value: $("#<?= $lv_sec; ?> #evttyp").val()},
                      {name: "title", value: $("#<?= $lv_sec; ?> .tmss-navbar-title").last().clone().children().remove().end().text().trim()},
                      {name: "subtitle", value: $("#<?= $lv_sec; ?> .tmss-navbar-subtitle").text().replace(" # ", "")}];
  
      tmssLink("?prg=zcusu1_sup&act=dshsup", 
                 [{target: "_replace_with", 
                   post_data: lv_pstdat,
                   target_id: <?=$lv_sec;?>
                  }]);
    }
  </script>
  <?php } ?>
  
  <script>
    // Selección de una opción de menú
    $("#<?= $lv_sec; ?> [data-nextoption]:not(table, a)").on("click", function(e){ 
      e.preventDefault();
      var lv_pstdat = [{name: "stecod", value: "<?= $vew_data->stecod; ?>"},
                       {name: "level", value: $(this).parents("[data-level]").data("level") + 1},
                       {name: "option", value: $(this).data("nextoption")},
                      {name: "title", value: "<?= $lv_title; ?>"},
                      {name: "subtitle", value: "<?= $lv_dockey; ?>" + " / " + $(this).find(".card-title").text()}];
      
      // añado la data
      var lv_dat = $(this).data(); 
      delete lv_dat['nextoption'];
      for (const [key,value] of Object.entries(lv_dat)) {
        lv_pstdat.push({name: key , value: value});
      }
      
      if($(this).data("nextoption") != 'frmins'){
        tmssLink("?prg=zcusu1_sup&act=dshsup", 
                 [{target: "_new_section", 
                   post_data: lv_pstdat 
                  }]);
      }else{
        lv_pstdat.push({name:"oldSec", value:""}, {name:"navbar", value:"X"}, {name:"sysdocclstxt", value:"INSPECCION"}, {name:"frm", value:"ins"});
        tmssLink("?prg=zcusu1_sup&act=dshsup", 
                 [{target: "_new_section", 
                   post_data: lv_pstdat 
                  }]);
      }
    });
    
  </script>
  <script>
     // Selección de una obra
    $("#<?= $lv_sec; ?> #cnsstetbl tbody tr").on("click", function(e){ e.preventDefault();
      
      var lv_cnssteadr = $(this).find("td:last").text();
      
      tmssLink("?prg=zcusu1_sup&act=dshsup", 
               [{target: "_new_section", 
                 post_data:[{name: "stecod", value: $(this).data("stecod")}, 
                            {name: "level", value: $(this).parents("[data-nextlevel]").data("nextlevel")},
                            {name: "option", value: $(this).parents("[data-nextoption]").data("nextoption")},
                            {name: "title", value: lv_cnssteadr},
                            {name: "subtitle", value: $(this).data("stecod")}] 
                }]);
    });
  </script>
  <script>
    // Selección de un evento
    $("#<?= $lv_sec; ?> #evttbl tbody tr").on("click", function(e){
      e.preventDefault();
      
      tmssLink("?prg=zcusu1_sup&act=dshsup", 
               [{target: "_new_section", 
                 post_data: [{name: "stecod", value: "<?= $vew_data->stecod; ?>"}, 
                             {name: "steevtcod", value: $(this).data("steevtcod")},
                             {name: "frm", value: "<?= strtolower(isset($vew_data->evttyp) ? $vew_data->evttyp : ''); ?>"},
                             {name: "level", value: $(this).parents("[data-nextlevel]").data("nextlevel")},
                             {name: "option", value: $(this).parents("[data-nextoption]").data("nextoption")},
                             {name: "oldSec", value:""},
                             {name: "navbar", value:"X"},
                             {name: "title", value: "<?= $lv_title; ?>"},
                             {name: "subtitle", value: "<?= $vew_data->stecod; ?>"}] 
                }]);
    });
    
    // Nuevo evento
    $("#<?= $lv_sec; ?> [data-nextoption='addEvt']").on("click", function(e){
      e.preventDefault();
      
      tmssLink("?prg=zcusu1_sup&act=dshsup", 
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
  </script>
  <script>
    // Selección de un solo checkbox en las tablas de cumple/no cumple/no aplica (por ahora queda en prueba con la tabla de señalizaciones)
    $("#<?= $lv_sec; ?> #inssngtbl input[type=checkbox]").on("click", function(e){ 
      $(this).parents("tr").find("input[type=checkbox]").not($(this)).prop("checked", false );
    });
  </script>
  
  <script>
  /*  
  var go_<?= $lv_sec; ?>_tblste;
  var go_<?= $lv_sec; ?>_tblstkmov;
  var go_<?= $lv_sec; ?>_tblcfgstkmov;
  var gv_<?= $lv_sec; ?>_tbldatstkmov; 
  go_<?= $lv_sec; ?>_tblcfgstkmov = {
    readOnly: <?= ($vew_readonly?'true':'false'); ?>,
    allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
    headerData: [{title:"<?= $vew_lang->COMMENTS; ?>"}, {title:"<?= $vew_lang->DATE; ?>", width:"120px"}],
    columnsData: [
        { id: "stkmovdoccmt", type:"TEXT" },
        { id: "stkmovdocdte", type:"TEXT" },  
      ],
    showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}],
    onRowClick: function(indece){ fnc_popup(indece)}
  };
  go_<?= $lv_sec; ?>_tblstkmov=new tmssTable($("#<?=$lv_sec?> #buyordtbl"), go_<?= $lv_sec; ?>_tblcfgstkmov); 
    
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
                  $("#<?= $lv_sec; ?> #sup-card:hidden").after( $("#<?= $lv_sec; ?> #sup-card:hidden").clone().removeClass("hidden"));
                  $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor SS <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span>");
                	// P E D I D O
                  $("#<?= $lv_sec; ?> #sup-card:not(:hidden) .tmss-mobile-button [data-option='Pedido']").click(function(){
                  	$("#<?= $lv_sec; ?> #sup-card:not(:hidden)").remove();
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor SS <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Pedidos</span>");
                    tmssCallProcess("?prg=zcusu1_sup&act=pedList&prm_stecod="+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod, [], function(data){
                    	// agrego las filas
                      var lv_arr = new Array();
                      for (var i=0; i<data.length; i++) {
                        lv_arr.push({	"stkmovdoccmt":data[i]["stkmovdoccmt"],
                                      "stkmovdocdte":data[i]["stkmovdocdtecnv"],
                                    });
                      }
                      go_<?= $lv_sec; ?>_tblstkmov.loadData(lv_arr);
                    });
                  	$("#<?= $lv_sec; ?> #sup-card-pedido").removeClass("hidden");
                  	$("#<?= $lv_sec; ?> .tmss-mobile-button -thin[data-option='nuevo']").click(function(){
                    	$("#<?= $lv_sec; ?> #sup-card-pedido").addClass("hidden");
                    	$("#<?= $lv_sec; ?> #cardNewPed").removeClass("hidden");
                      // T M S S T A B L E - T Y P E A H E A D  D E.  M A T E R I A L E S
                      /*typeahead: function(values){
                        return {definition: "stkmat",
                            data: {
                                fldsec: "<?= $lv_sec ;?>",
                                fldasg: {"matcodext": "matcodext", 
                                         "mattxt": "mattxt",
                                         "matunttxt": "matunttxt"},
                                fldflt: {"docts":"A"}
                            };
                        }
                    	};*/
											/*var go_<?= $lv_sec; ?>_tblmat;
                      var go_<?= $lv_sec; ?>_tblcfgmat;
                      var gv_<?= $lv_sec; ?>_tbldatmat;
                      go_<?= $lv_sec; ?>_tblcfgmat = {
                              readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                							allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                              headerData: [{title:"<?= $vew_lang->MATERIALS; ?>", width:"50%"}, {title:"<?= $vew_lang->QUANTITY; ?>", width:"25%"}, {title:"<?= $vew_lang->UM; ?>", width:"25%"}],
                              columnsData:[
                              						{id: "mattxt", type: "typeahead", 
                               							typeahead: function(values){ 
                                          		return{definition: "stkmat", //modelo que queremos acceder los datos
                                              	    data: {
                                                	  fldsec: "<?= $lv_sec ;?>", // token de seguridad
                                                  	fldasg: {"matcodext": "matcodext", 
                                                    	       "mattxt": "mattxt",
                                                             "matunttxt": "matunttxt"}
                                                	}
                                          		};
                               							}
                              						}
                              ],
                    	showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                      };
                    	gv_<?= $lv_sec; ?>_tbldatmat = [<?php
        								$lv_buffer='';
												$vew_data->stkmat=array();
                        foreach($vew_data->stkmat as $lv_row) {
                        	$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          	            'matcod:"'.$lv_row['matcod'].'",'.
                                        'matcodext:"'.$lv_row['matcodext'].'",'.
                                        'mattxt:"'.$lv_row['mattxt'].'",'.
                                        'matunttxt:"'.$lv_row['matuntcod'].'"}';
                        }
                        echo $lv_buffer;
                      ?>];
    
    									go_<?= $lv_sec; ?>_tblmat = new tmssTable($("#<?= $lv_sec; ?> #stkmattbl"), go_<?= $lv_sec; ?>_tblcfgmat);
    
                      $(function(){
                        go_<?= $lv_sec; ?>_tblmat.loadData(gv_<?= $lv_sec; ?>_tbldatmat);
                      });*/

                    	/*
                    
                  	});// CIERRRE DE CARD NUEVO
                    
                  });// CIERRE DE CARD PEDO
                  // F O R M U L A R I O S
                  $("#<?= $lv_sec; ?> #sup-card:not(:hidden) .tmss-mobile-button [data-option='Formularios']").click(function(){
                  	$("#<?= $lv_sec; ?> #sup-card:not(:hidden)").remove();
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor SS <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Formularios</span>");
                    $("#<?= $lv_sec; ?> #sup-card-formularios").removeClass("hidden");
                  });
                  // C O N S U M O S
                  $("#<?= $lv_sec; ?> #sup-card:not(:hidden) .tmss-mobile-button [data-option='Consumos']").click(function(){
                  	$("#<?= $lv_sec; ?> #sup-card:not(:hidden)").remove();
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor SS <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Consumos</span>");
                    $("#<?= $lv_sec; ?> #sup-card-consumos").removeClass("hidden");
                  });
                  
                  // R E P O R T E S
                  $("#<?= $lv_sec; ?> #sup-card:not(:hidden) .tmss-mobile-button [data-option='Reportes']").click(function(){
                  	$("#<?= $lv_sec; ?> #sup-card:not(:hidden)").remove();
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor SS <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Reportes</span>");
                    $("#<?= $lv_sec; ?> #sup-card-reportes").removeClass("hidden");
                  });
                  
                  // D E V O L U C I O N E S
                  $("#<?= $lv_sec; ?> #sup-card:not(:hidden) .tmss-mobile-button [data-option='Devoluciones']").click(function(){
                  	$("#<?= $lv_sec; ?> #sup-card:not(:hidden)").remove();
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Devoluciones</span>");
                    $("#<?= $lv_sec; ?> #sup-card-devolucion").removeClass("hidden");
                  });
                  
    							/*$("#<?= $lv_sec; ?> .").click(function(){ 
                  	$("#<?= $lv_sec; ?> #sup-card").addClass("hidden");
                    if($(this).data("option") === "Pedido"){
                    	$("#<?= $lv_sec; ?> #sup-card-pedido").removeClass("hidden");
                    	var go_<?= $lv_sec; ?>_tblstkmov;
                      tmssCallProcess("?prg=zcusu1_sup&act=pedList&prm_stecod="+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod, [], function(data){
                      	/*var go_<?= $lv_sec; ?>_tblcfgstkmov;
                        var gv_<?= $lv_sec; ?>_tbldatstkmov; 
                        go_<?= $lv_sec; ?>_tblcfgstkmov = {
                        	readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                          allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                          headerData: [{title:"<?= $vew_lang->commentary; ?>", width:"20%"}, {title:"<?= $vew_lang->DATE; ?>", width:"80%"}],
                          columnsData: [
                              { id: "stkmovdoccmt", type:"TEXT" },
                              { id: "stkmovdocdte", type:"TEXT" },  
                            ],
                          showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                        }
                      
                      	// agrego las filas
                      	var lv_arr = new Array();
                      	for (var i=0; i<data.length; i++) {
                      		lv_arr.push({	"stkmovdoccmt":data[i]["stkmovdoccmt"],
                        	           		"stkmovdocdte":data[i]["stkmovdocdtecnv"],
                                    	});
                      	}
                      	go_<?= $lv_sec; ?>_tblstkmov=new tmssTable($("#<?=$lv_sec?> #buyordtbl"), go_<?= $lv_sec; ?>_tblcfgstkmov);
                      	go_<?= $lv_sec; ?>_tblstkmov.loadData(lv_arr);
                      
                    	});
                    	// tmss-mobile-bottun-thin
                      $("#<?= $lv_sec; ?> .tmss-mobile-button -thin").click(function(){
												if($(this).data("option") === "nuevo"){
                          $("#<?= $lv_sec; ?> #sup-card-pedido").addClass("hidden");
                          $("#<?= $lv_sec; ?> #stkmov").addClass("hidden");
                          $("#<?= $lv_sec; ?> #cardNewPed").removeClass("hidden");
                          tmssCallProcess("?prg=zcusu1_sup&act=materialList&prm_stecod="+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod, [], function(data){
                          	var go_<?= $lv_sec; ?>_tblcfgstkmov;
                        		var gv_<?= $lv_sec; ?>_tbldatstkmov; 
                        		go_<?= $lv_sec; ?>_tblcfgstkmov = {
                                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                                headerData: [{title:"<?= $vew_lang->NAME; ?>", width:"50%"}, {title:"<?= $vew_lang->QUANTITY; ?>", width:"30%"}, {title:"<?= $vew_lang->UNIT; ?>", width:"20%"}],
                                columnsData: [
                                            { id: "", type:"TEXT" },
                                            { id: "", type:"TEXT" },  
                              	],
                            		showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                        		}
                          });
                        }
                      });
                  	}
                                                                  
                    else if($(this).data("option") === "Formularios"){
                    	$("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Formularios</span>");
                    	$("#<?= $lv_sec; ?> #sup-card-formularios").removeClass("hidden");
                    }
                    /*else if($(this).data("option") === "Consumos"){
                    	$("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Consumos</span>");
                    	$("#<?= $lv_sec; ?> #sup-card-consumos").removeClass("hidden");
                    }
                    else if($(this).data("option") === "Reportes"){
                    	$("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Reportes</span>");
                    	$("#<?= $lv_sec; ?> #sup-card-reportes").removeClass("hidden");
                    }
                    else if($(this).data("option") === "Devoluciones"){
                    	$("#<?= $lv_sec; ?> .tmss-navbar-title").html("Supervisor <span class='tmss-navbar-subtitle'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).adrstr+"</span><span class='hidden'>"+go_<?= $lv_sec;?>_tblste.getValuesAtRow(index).stecod+"</span><span class='tmss-navbar-subtitle'>Devoluciones</span>");
                    	$("#<?= $lv_sec; ?> #sup-card-devolucion").removeClass("hidden");
                    }
                  });
*/
     /*             
                  //Btn volver atras
                  $("#<?= $lv_sec; ?> #btncls").attr("onclick", "");  
    							$("#<?= $lv_sec; ?> #btncls").click(function(){
                    $("#<?= $lv_sec; ?> .tmss-navbar-title").html("General <span class='tmss-navbar-subtitle'>Obras</span>");
                  	//$("#<?= $lv_sec; ?> #sup-card").addClass("hidden");
                  	$("#<?= $lv_sec; ?> #sup-card-pedido").addClass("hidden");
                    $("#<?= $lv_sec; ?> #sup-card-formularios").addClass("hidden");
                    $("#<?= $lv_sec; ?> #sup-card-consumos").addClass("hidden");
                    $("#<?= $lv_sec; ?> #sup-card-reportes").addClass("hidden");
                    $("#<?= $lv_sec; ?> #sup-card-devolucion").addClass("hidden");
                    $("#<?= $lv_sec; ?> #cardNewPed").addClass("hidden");
                    $("#<?= $lv_sec; ?> #gral").removeClass("hidden");
                    $("#<?= $lv_sec; ?> #sup-card:not(:hidden)").remove();
                  	//$("#<?= $lv_sec; ?> #srch").removeClass("hidden");
                    
                  });
                  
                }

    };

    gv_<?= $lv_sec; ?>_tbldatste = data.data;

    go_<?= $lv_sec; ?>_tblste = new tmssTable($("#<?= $lv_sec; ?> #cnsbudtbl"), go_<?= $lv_sec; ?>_tblcfgste);

    go_<?= $lv_sec; ?>_tblste.loadData(gv_<?= $lv_sec; ?>_tbldatste);
    });
*/
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