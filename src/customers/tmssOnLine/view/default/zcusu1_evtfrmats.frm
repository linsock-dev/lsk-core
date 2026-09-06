<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo  
	$lv_title = '';
	
	// modulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU1';

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
	$lv_steevtcod = $vew_data->evtdoc[0]['steevtcod']??'';
	$lv_steevtdoccod = $vew_data->evtdoc[0]['steevtdoccod']??'';
	$lv_steevtdocatr = json_decode(mb_convert_encoding($vew_data->evtdoc[0]['steevtdocatr']??'','UTF-8','iso-8859-1'),true);

  $lv_eppcat = array('rop_cal' =>'Ropa de trabajo y Calzado de Seguridad',
                    'cas_seg' => 'Casco de Seguridad', 
                    'prt_ocu' => 'Gafas de protecci&oacute;n ocular',
                    'prt_mcn' => 'Guantes de Protecci&oacute;n mec&aacute;nica',
                    'gnt_dbt' => 'Guantes Diel&eacute;ctricos BT',
                    'gnt_dmt' => 'Guantes Diel&eacute;ctricos MT',
                    'msk_adf' => 'M&aacute;scara antideflagratoria',
                    'arn_seg' => 'Arn&eacute;s de Seguridad');
?> 
<section id="<?= $lv_sec; ?>">
  <style>
    .card.tmss-dropdown-card.tmss-closed-card > .card-header { border-bottom: none !important; }
    .tmss-dropdown-card > div:first-child:hover{ cursor: pointer; }
    .tmss-dropdown-card .big-card-title { font-size: 25px; font-weight: bold; color: #0e0e0e; display: flex; align-items: center;  justify-content: space-between; }
    .tmss-mr-5{ margin-right: 5px; }
    .tmss-mr-15{ margin-right: 15px; }
  </style>      
  <?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
  <?= gethtml('steevtdoccod', 'hidden', $lv_steevtdoccod); ?>
  <textarea class="hidden" id="steevtdocdat" name="steevtdocdat">"<?= (count($vew_data->evtdoc)>0 ? $vew_data->evtdoc[0]['steevtdocatr'] : '');?>"</textarea>

  <div class="row">	
    <div class="col-sm-6 col-xs-12">
		
      <!-- TAREAS -->
      <div class="card tmss-dropdown-card tmss-closed-card" data-frm="ATS_TSK">
        <div class="card-header">
          <div class="card-title big-card-title">
            <?= strtoupper($vew_lang->task); ?>
						<i class="fas fa-clipboard-check"></i>
          </div>
        </div>
        <div class="card-body">
          <?php 
          	if(!$vew_readonly){
              echo vew_boot($lv_col39, array('label'=>$vew_lang->task,
                                              'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                  array('input'=>gethtml('cnstsktxt', 'typeahead', '', $lv_default ) )) )); 
              echo gethtml('cnstskcod', 'hidden', '');
            }
          ?>
          <div id="tsklst">
						<?php 
              $lv_tsk = '';
              foreach($vew_data->tsklst as $lv_key => $lv_row){
                // botones para eliminar/desplegar tarea
                $lv_btn = '<div style="display: inherit;"><a href="#/" class="deltsk tmss-mr-15"><i class="fas fa-times text-danger"></i></a>';
                
                // div por tarea
                $lv_tsk .= '<div data-tskcod='.$lv_row['cnstskcod'].'>'.
                              ($vew_readonly && $lv_key==0 ? '' : '<br>').
                              '<div style="display:flex; justify-content: space-between;">'.
                                '<label class="tmss-mr-5">'.utf8_decode($lv_row['cnstsktxt']).'</label>';
                $lv_tbl = '';              
                $lv_btn .= '<a href="#/" class="showtskdat '.($lv_tbl!= ''?'':'invisible').'"><i class="fas fa-chevron-down"></i></a></div>';
                $lv_tsk .= $lv_btn.'</div>'.$lv_tbl.'</div>';
              }
              
              echo $lv_tsk;
						?>
          </div>
          <hr>
          <div id="newrskctrtbl"></div>
        </div>
      </div> <!-- / TAREAS -->
			
    </div> <!-- / col -->
    <div class="col-sm-6 col-xs-12">
			
      <!-- TRABAJADORES -->
      <div class="card tmss-dropdown-card tmss-closed-card" data-frm="ATS_WRK">
        <div class="card-header">
          <div class="card-title big-card-title">
            TRABAJADORES
						<i class="fas fa-user-helmet-safety"></i>
          </div>
        </div>
        <div class="card-body">
          <table class="table table-hover table-no-bordered table-condensed">
            <thead><tr><th>ID</th><th>Nombre y apellido</th></tr></thead>
            <tbody>
              <?php
                $lv_rows = '';
                foreach($vew_data->steemp as $lv_row){
                  $lv_rows .= '<tr>	<td>'.$lv_row['srcobjcod'].'</td>	<td>'.$lv_row['srcobjtxt'].'</td>	</tr>';
                }
                echo $lv_rows;
              ?>
            </tbody>
          </table>
        </div>
      </div> <!-- / TRABAJADORES -->

      <!-- E.P.P. -->
    	<div class="card tmss-dropdown-card tmss-closed-card" data-frm="ATS_EPP">
      	<div class="card-header">
          <div class="card-title big-card-title">
            E.P.P.
						<i class="fas fa-mask-face"></i>
          </div>
      	</div>
        <div class="card-body"> 
          <table id="cnsepp" class="table table-hover table-no-bordered table-condensed">
            <thead>
              <tr>
                <th>Utilizar durante toda la tarea</th>
                <th><input class="cursor-pointer" type="checkbox"></th>
              </tr>	
            </thead>
            <tbody>
              <?php 
              $lv_rows = '';
              foreach($lv_eppcat as $lv_key => $lv_row){
                $lv_rows .= '<tr>'.
                              '<td>'.$lv_row.'</td>'.
                              '<td><input value="'.$lv_key.'" class="cursor-pointer" type="checkbox" '.(isset($lv_steevtdocatr['ATS_EPP']) ? ($vew_doc->getTagValue($lv_steevtdocatr['ATS_EPP'], $lv_key) ==='1'? 'checked' : '') :'').'></td>'.
                            '</tr>';
              }
              echo $lv_rows;
              ?>
            </tbody>
          </table>
        </div>
    	</div><!-- / E.P.P. -->
			
  	</div><!-- / col -->
  </div><!-- / row -->
  <script>
    var go_<?= $lv_sec; ?>_newrskctr_tbl;
    var gv_<?= $lv_sec; ?>_newrskctr_tbldat = [<?php 
			$lv_buffer = '';  
      if($vew_data->newrskctr != ''){
      	foreach($vew_data->newrskctr as $lv_row){
        	$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'rskctrtxt: "'.(isset($lv_row['rskctrtxt']) ? mb_convert_encoding($lv_row['rskctrtxt'], 'iso-8859-1', 'UTF-8') : '').'"'.
                      '}'; 
      	}
      }
    	echo $lv_buffer;
		?>];
    
    var go_<?= $lv_sec; ?>_newrskctr_tblcfg = {
      readOnly: <?= ($vew_readonly?'true':'false'); ?>,
      allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
      headerData: [{title:"Otros riesgos/controles", width: "100%"}],
      columnsData: [{id: "rskctrtxt", type: "text"}]
    };
    
    $(function(){
      // añade botón para agregar tareas
      var lv_addtskbtn = $("#<?= $lv_sec; ?> #cnstsktxt").siblings("span").children("a:first").clone();
      lv_addtskbtn.find("i").removeClass().addClass("far fa-plus"); 
      lv_addtskbtn.attr("id", "addtsk");
      $("#<?= $lv_sec; ?> #cnstsktxt").siblings("span").children("a:first").after(lv_addtskbtn);
      
      // instancia tabla de otros riesgos/controles
    	go_<?= $lv_sec; ?>_newrskctr_tbl = new tmssTable($("#<?= $lv_sec; ?> #newrskctrtbl"), go_<?= $lv_sec; ?>_newrskctr_tblcfg); 
      // añado botón para eliminar filas
      if(!<?= $vew_readonly? 'true': 'false'?>){
        $("#<?= $lv_sec; ?> #newrskctrtbl table thead tr:eq(0) th").last().append("<a class='card-icon' id='btnDelRow'><i class='fas fa-trash'></i></a>");
        go_<?= $lv_sec; ?>_newrskctr_tbl.setDeleteAction($("#<?= $lv_sec; ?> #btnDelRow"));
    	}
      
      go_<?= $lv_sec; ?>_newrskctr_tbl.loadData(gv_<?= $lv_sec; ?>_newrskctr_tbldat);
    
    	$("#<?= $lv_sec; ?> [data-frm=ATS_EPP] thead :checkbox").prop("checked", $("#<?= $lv_sec; ?> [data-frm=ATS_EPP] tbody :checkbox:checked").length == $("#<?= $lv_sec; ?> [data-frm=ATS_EPP] tbody :checkbox").length);
    
      // Si ya existen tareas guardadas, reconstruir riesgos y controles
      var lv_docatr = <?= json_encode($lv_steevtdocatr); ?>;


     if (lv_docatr && lv_docatr.ATS_TSK && lv_docatr.ATS_TSK.tsklst) {

      lv_docatr.ATS_TSK.tsklst.forEach(function(tsk) {

        var lv_cod = tsk.cnstskcod;

        // Limpia riesgos/controles previos
        $("#<?= $lv_sec; ?> #tsklst [data-tskcod=" + lv_cod + "] div:has(table)").remove();

        // consulta los textos desde el backend
        tmssCallProcess("?prg=cnstsk&act=getRskCtr", [{ name: "cnstskcod", value: lv_cod }], function (lp_rsp) {

        if (!lp_rsp.data) return;

        var lv_rsk = lp_rsp.data.cnstskrsk || [];
        var lv_ctr = lp_rsp.data.cnstskctr || [];
        var lv_html = "";

        // --- RIESGOS ---
        if (lv_rsk.length > 0) {

          lv_html += "<table class='table table-hover table-no-bordered table-condensed'>";
          lv_html += "<thead><tr><th>Riesgos</th>";

          <?php if(!$vew_readonly){ ?>
          lv_html += "<th><input type='checkbox' class='cursor-pointer ats-rsk-all'></th>";
          <?php } ?>

          lv_html += "</tr></thead><tbody>";

          lv_rsk.forEach(function(r){
            var showRow = true;
            var checked = "";

            <?php if($vew_readonly){ ?>
              // En VER: solo mostrar seleccionados
              if (!tsk.rsklst || !tsk.rsklst.includes(String(r.cnsrskctrcod))) showRow = false;
            <?php } else { ?>
              // En CREAR: todo seleccionado
              checked = "checked";

              // En MODIFICAR: si viene en JSON, seleccionado
              if (tsk.rsklst && tsk.rsklst.includes(String(r.cnsrskctrcod))) {
                  checked = "checked";
              } else {
                  checked = ""; 
              }
            <?php } ?>

            if (showRow) {
              lv_html += "<tr><td>" + r.cnsrskctrtxt + "</td>";

              <?php if(!$vew_readonly){ ?>
                lv_html += "<td class='text-center'><input type='checkbox' class='cursor-pointer ats-rsk' value='"+r.cnsrskctrcod+"' "+checked+"></td>";
              <?php } ?>

              lv_html += "</tr>";
            }

          });

          lv_html += "</tbody></table>";
        }

        // --- CONTROLES ---
        if (lv_ctr.length > 0) {

          lv_html += "<table class='table table-hover table-no-bordered table-condensed'>";
          lv_html += "<thead><tr><th>Controles</th>";

          <?php if(!$vew_readonly){ ?>
          lv_html += "<th><input type='checkbox' class='cursor-pointer ats-ctr-all'></th>";
          <?php } ?>

          lv_html += "</tr></thead><tbody>";

          lv_ctr.forEach(function(c){
            var showRow = true;
            var checked = "";

            <?php if($vew_readonly){ ?>
              if (!tsk.ctrlst || !tsk.ctrlst.includes(String(c.cnsrskctrcod))) showRow = false;
            <?php } else { ?>
              checked = "checked";
              if (tsk.ctrlst && tsk.ctrlst.includes(String(c.cnsrskctrcod))) {
                  checked = "checked";
              } else {
                  checked = "";
              }
            <?php } ?>

            if (showRow) {
              lv_html += "<tr><td>" + c.cnsrskctrtxt + "</td>";

              <?php if(!$vew_readonly){ ?>
              lv_html += "<td class='text-center'><input type='checkbox' class='cursor-pointer ats-ctr' value='"+c.cnsrskctrcod+"' "+checked+"></td>";
              <?php } ?>

              lv_html += "</tr>";
            }

          });

          lv_html += "</tbody></table>";
        }

        // Insertar en DOM
        $("#<?= $lv_sec; ?> #tsklst [data-tskcod=" + lv_cod + "]").append("<div class='mt-2'>" + lv_html + "</div>");

      });
      });
    }    	
    });
  </script>
  <script>
    // deshabilitar checkbox
    <?php if($vew_readonly){ ?>
			$("#<?= $lv_sec; ?> :checkbox").click(function(){ return false; });
    <?php }else{ ?>
			// EPP: checkbox header
			$("#<?= $lv_sec; ?> [data-frm=ATS_EPP] thead :checkbox").on("click", function(e){
				$(this).parents("table").find("tbody :checkbox").prop("checked", $(this).prop("checked"));
			});    
			// EPP: checkbox body
			$("#<?= $lv_sec; ?> [data-frm=ATS_EPP] tbody :checkbox").on("click", function(e){
				var lv_check = $("#<?= $lv_sec; ?> [data-frm=ATS_EPP] tbody :checkbox:checked").length == $("#<?= $lv_sec; ?> [data-frm=ATS_EPP] tbody :checkbox").length;
				$("#<?= $lv_sec; ?> thead :checkbox").prop("checked", lv_check);
			});
    <?php } ?>
  </script>
  <script> 
    // cnstsktxt typeahead
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", 
                  "fldflt": {"tc.cnstskclscodext": "TAREA", "t.docsts": "A"}, 
                  "fldasg" : {"cnstsktxt" : "cnstsktxt", "cnstskcod" : "cnstskcod"} }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #cnstsktxt"), "cnstsk", lo_get);
    
    // agregar tarea
    $("#<?= $lv_sec; ?>").on("click", "#addtsk", function(e){ e.preventDefault();
      var lv_cod = $("#<?= $lv_sec; ?> #cnstskcod").val();
      
      // verifica que se haya ingresado una nueva tarea
      if(lv_cod != "" && $("#<?= $lv_sec; ?> #tsklst [data-tskcod="+lv_cod+"]").length == 0){
         // añade tarea (con botón para eliminarla)
         $("#<?= $lv_sec; ?> #tsklst").append("<div data-tskcod="+lv_cod+"><br><div style='display:flex; justify-content: space-between;'><label class='tmss-mr-5'>"+$("#<?= $lv_sec; ?> #cnstsktxt").val()+"</label><div style='display: inherit;'><a href='#/' class='deltsk tmss-mr-15'><i class='fas fa-times text-danger'></a></div></div></div>");

         // buscar riesgos y sus controles, registrados en la tarea
         tmssCallProcess("?prg=cnstsk&act=getRskCtr", [{ name: "cnstskcod", value: lv_cod }], function (lp_rsp) {
            if (!lp_rsp.data) return;

            var lv_rsk = lp_rsp.data.cnstskrsk || [];
            var lv_ctr = lp_rsp.data.cnstskctr || [];
            var lv_html = "";

            // --- RIESGOS ---
            if (lv_rsk.length > 0) {
              lv_html += "<table class='table table-hover table-no-bordered table-condensed'>";
              lv_html += "<thead><tr><th>Riesgos</th><th><input type='checkbox' class='cursor-pointer ats-rsk-all'></th></tr></thead><tbody>";

              lv_rsk.forEach(function (r) {
                lv_html += "<tr>" +"<td>" + r.cnsrskctrtxt + "</td>" +
                             "<td class='text-center'><input type='checkbox' class='cursor-pointer ats-rsk' value='" + r.cnsrskctrcod + "' checked></td>" +
                           "</tr>";
              });
              lv_html += "</tbody></table>";
            }

            // --- CONTROLES ---
            if (lv_ctr.length > 0) {
              lv_html += "<table class='table table-hover table-no-bordered table-condensed'>";
              lv_html += "<thead><tr><th>Controles</th><th><input type='checkbox' class='cursor-pointer ats-ctr-all'></th></tr></thead><tbody>";

              lv_ctr.forEach(function (c) {
                lv_html += "<tr>" + "<td>" + c.cnsrskctrtxt + "</td>" +
                             "<td class='text-center'><input type='checkbox' class='cursor-pointer ats-ctr' value='" + c.cnsrskctrcod + "' checked></td>" +
                           "</tr>";
              });

              lv_html += "</tbody></table>";
            }

            $("#<?= $lv_sec; ?> #tsklst [data-tskcod=" + lv_cod + "]")
            .append("<div class='mt-2'>" + lv_html + "</div>")
            .find(".showtskdat").removeClass("invisible");
        });
      }
      
      $("#<?= $lv_sec; ?> #cnstskcod, #<?= $lv_sec; ?> #cnstsktxt").val("");
    });
    
    // Toggle general de riesgos / controles
    $("#<?= $lv_sec; ?>").on("click", ".ats-rsk-all", function() {
      $(this).closest("table").find(".ats-rsk").prop("checked", $(this).is(":checked"));
    });
    
    $("#<?= $lv_sec; ?>").on("click", ".ats-ctr-all", function() {
      $(this).closest("table").find(".ats-ctr").prop("checked", $(this).is(":checked"));
    });
    
    // desplegar tarea
    $("#<?= $lv_sec; ?> #tsklst").on("click", "a.showtskdat", function(e){e.preventDefault; 
      $(this).parents("[data-tskcod]").children("div:has(table)").toggleClass("hidden");
      $(this).find("i").toggleClass("fa-chevron-down fa-chevron-up");
    });
    
    // quitar tarea
    $("#<?= $lv_sec; ?> #tsklst").on("click", "a.deltsk", function(e){e.preventDefault; 
      $(this).parents("[data-tskcod]").remove();
    });
  </script>
  <script>
    // abre/cierra una sección del formulario cuando se clickea sobre su cabecera
    $("#<?= $lv_sec; ?> .tmss-dropdown-card > div:not(.card-body)").on("click", function(e){ e.preventDefault;
      $(this).parent().toggleClass("tmss-closed-card");
      $(this).siblings(".card-body").toggleClass("hidden");
    });
  </script>
  <script>
    // parsea los datos del formulario
    function <?= $lv_sec; ?>_sve( lp_sec ){ 
      // validación de 3 ítems mínimo en epp
      var lv_valid = ($("#<?= $lv_sec; ?> [data-frm='ATS_EPP'] :checkbox:checked").length >= 3);
            
      if(!lv_valid){
        toastr.options.timeOut= 2000;
        toastr.warning( "EPP incompleto. Debe haber al menos 3." );
      }else{
        var lv_insdat = {"steevtdoccod": "<?= $lv_steevtdoccod; ?>",
												"srcobjtyp": "CNS_EVT_FRM",
												"srcobjcod": "1",
                        "srcobjtxt": "ATS",
                      	"steevtdocatr": ""};
        var lv_frmatr = {"ATS_TSK": {"tsklst": []}, "ATS_EPP": {}}; 
				var lv_epptags = "";
        
        // sección tarea: ids-texto de tareas y otros riesgos/controles
      	$("#<?= $lv_sec; ?> [data-tskcod]").each(function(){ 
            var lv_tskcod = $(this).data("tskcod");
            var lv_tsktxt = $(this).find("label").text();

            // Obtener IDs seleccionados de riesgos y controles
            var lv_rsk = [];
            var lv_ctr = [];

            $(this).find(".ats-rsk:checked").each(function(){lv_rsk.push($(this).val());});
            $(this).find(".ats-ctr:checked").each(function(){lv_ctr.push($(this).val());});

            lv_frmatr["ATS_TSK"]["tsklst"].push({
              "cnstskcod": lv_tskcod,
              "cnstsktxt": lv_tsktxt,
              "rsklst": lv_rsk,
              "ctrlst": lv_ctr
            });
        });
        lv_frmatr["ATS_TSK"]["newrskctr"] = go_<?= $lv_sec; ?>_newrskctr_tbl.getData();
        
        // sección epp
        $("#<?= $lv_sec; ?> [data-frm=ATS_EPP] tbody tr").each(function(){ 
          var lv_tag = $(this).find(":checkbox").val();
          lv_epptags += "<"+lv_tag+">" + ($(this).find(":checkbox").is(":checked") ? 1 : 0) + "</"+lv_tag+">";
        });
        lv_frmatr["ATS_EPP"] = lv_epptags;
        lv_insdat["steevtdocatr"] = JSON.stringify(lv_frmatr);

        // fija los valores en los campos
        $("#<?= $lv_sec; ?> #steevtdocdat").text( JSON.stringify([lv_insdat]) );
      }
      
      return lv_valid;
    }
  </script>
</section>