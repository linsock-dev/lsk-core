<?php 
	// url del formulario 
  $lv_lnk = '?prg=zcumsm';

	// campos requeridos
	$vew_input->RequiredFields( array('hhrorgchtcod', 'hhrorgchttxt') );

	// clave del documento
	$lv_dockey = ''; 

	// titulo
	$lv_title = $vew_lang->general;

	// modulo y programa
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'MSM';

	$vew_actcod='01';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	// Botones por vista
 	$vew_tbl['sveL'] = array('ttl'=>$vew_lang->process, 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'itzpersonal00'.chr(39).'});' );

	// preparo arrays de búsqueda
	$lv_plc = array();
	foreach($vew_data->plclst as $lv_row){
		$lv_plc[] = array('wrkplccod'=>$lv_row['wrkplccod'], 'wrkplctxt'=>utf8_encode($lv_row['wrkplctxt']));
	}
	
	// preparo array de horarios
	$lv_tme = array();
	foreach($vew_data->tmelst as $lv_row){
		$lv_tmearr = json_decode($lv_row['hhrtmerngatr'],true);
		$lv_tmestr = '';
    if($lv_tmearr['tmerng']){
      foreach($lv_tmearr['tmerng'] as $lv_rowtme){
        $lv_tmestr .= $lv_rowtme['tmeday'].$lv_rowtme['tmestr'].'-'.$lv_rowtme['tmeend'];			
      }
    }
		$lv_tme[] = array('hhrtmerngcod'=>$lv_row['hhrtmerngcod'], 'tmerngseq'=>$lv_tmestr, 'hhrtmerngatr'=>json_decode($lv_row['hhrtmerngatr'], true), 'hhrtmerngwekhrs' => $lv_row['hhrtmerngwekhrs'], 'hhrtmerngfrq' => $lv_row['hhrtmerngfrq']);
	}

	// preparo array de empleados
	$lv_emp = array();
	foreach($vew_data->emplst as $lv_row){
		$lv_emp[] = array('hhrempcod'=>$lv_row['hhrempcod'], 'hhrempcodext'=>utf8_encode($lv_row['hhrempcodext']));	
	}

	// preparo array de horarios de  empleados
	$lv_emptme = array();
	foreach($vew_data->emptme as $lv_row){
		$lv_emptme[] = array('hhremptmecod' => $lv_row['hhremptmecod'],
                         'hhrempcod'=>$lv_row['hhrempcod'], 
                         'wrkplccod' => $lv_row['wrkplccod'], 
                         'hhrtmerngcod' => $lv_row['hhrtmerngcod'], 
                         'wrkstecod' => $lv_row['wrkstecod']);	
	}

	// preparo funciones
	$lv_dpto = array();
	$lv_srv = array();
	$lv_fnc = array();
	foreach($vew_data->wrkste as $lv_row){
    if($lv_row['wrkstetyp']=='D'){
    	$lv_wrkstetyp = &$lv_dpto;  
    }else if($lv_row['wrkstetyp']=='S'){
      $lv_wrkstetyp = &$lv_srv;  
    }else{
      $lv_wrkstetyp = &$lv_fnc;  
    }
    
		$lv_wrkstetyp[] = array('wrkstecod'=>$lv_row['wrkstecod'], 'wrkstetxt'=>utf8_encode($lv_row['wrkstetxt']));  
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
    <input type="file" id="uplfle" class="hidden">
    <textarea class="hidden" id="hhrmsm" name="hhrmsm"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrempcod; ?><?= gethtml( 'hhrempcod' , 'hidden', $vew_data->hhrempcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card tmss-hot-ttl">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->general; ?>
									<?php if(!$vew_readonly) { ?><a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnupl" title="<?= $vew_lang->upload; ?>"><i class="fas fa-upload"></i></a><?php } ?>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->organizationchart,
																										'input'=>vew_boot(
																											array('style'=>'search', 'readonly'=>$vew_readonly ),
																											array('input'=>gethtml('hhrorgchttxt', 'typeahead',$vew_data->hhrorgchttxt,$lv_default))
																										))
																	);
                    echo gethtml('hhrorgchtcod','hidden',$vew_data->hhrorgchtcod);
									?>
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->parameters; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col4242, array('label1'=>'Alta Empleados',
                                                     'input1'=>gethtml('updemp', 'checkbox', true, $lv_default),
                                                     'label2'=>'Alta Areas',
                                                     'input2'=>gethtml('updplc', 'checkbox', true, $lv_default)));
                  	echo vew_boot($lv_col4242, array('label1'=>'Alta Horarios',
                                                     'input1'=>gethtml('updtme', 'checkbox', true, $lv_default),
                                                     'label2'=>'Alta Departamentos',
                                                     'input2'=>gethtml('upddto', 'checkbox', true, $lv_default)));
                  	echo vew_boot($lv_col4242, array('label1'=>'Alta Servicios',
                                                     'input1'=>gethtml('updsrv', 'checkbox', true, $lv_default),
                                                     'label2'=>'Alta Funciones',
                                                     'input2'=>gethtml('updfnc', 'checkbox', true, $lv_default)));
                  ?>
								</div>
							</div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12">
              <div class="progress hidden">
                <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;"></div>
              </div>
              <div id="hhremphot" name="hhremphot"></div>				
            </div>
          </div>
				</div> <!-- /tab001 -->
				
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
		// typeahead organigrama
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"hhrorgchtcod" : "hhrorgchtcod", "hhrorgchttxt" : "hhrorgchttxt"}}; 
		tmssTypeahead($("#<?= $lv_sec; ?> #hhrorgchttxt"), "hhrorgcht", lo_get);
	</script>
	<script>
		var <?= $lv_sec; ?>_tmr;
		var <?= $lv_sec; ?>_plc = <?= json_encode($lv_plc); ?>;
		var <?= $lv_sec; ?>_tme = <?= json_encode($lv_tme); ?>;
		var <?= $lv_sec; ?>_emp = <?= json_encode($lv_emp); ?>;
		var <?= $lv_sec; ?>_dpto = <?= json_encode($lv_dpto); ?>;
		var <?= $lv_sec; ?>_srv = <?= json_encode($lv_srv); ?>;
		var <?= $lv_sec; ?>_fncarr = <?= json_encode($lv_fnc); ?>;
		var <?= $lv_sec; ?>_emptme = <?= json_encode($lv_emptme); ?>;
    
    function <?= $lv_sec; ?>_getTmeAtr(lp_days, lp_wrklod, lp_hhrempcod, lp_wrkstefnccod, lp_wrkplccod){
      // preparo horarios (convertir string como HH:nn-HH:nn)
      var lv_tmeseq = "", lv_str;
      var lv_hhrtmerngatr = {"tmerng":[]};
      var lv_validtme = true;
      var lv_days = ["L","M","X","J","V","S","D"];
      var lv_deleteFromTime = ["sala","consul","rotativo","comision", "horariodiscontinuol/v", "horariodiscontinuo", "discontinuas", "discontinuo", "comision"];
      var lv_deleteFromWorkload = ["hs", ".", "semanales"];
      var lv_hhrtmerngcod = 0;
      const lv_tmeformat = new RegExp(/^\d{1,2}(:\d{1,2})?(a|-)\d{1,2}(:\d{1,2})?$/);
      
      for(let i = 0; i < lp_days.length; i++){ 
        lv_str = "";
        if (lp_days[i] != undefined){
          lv_str = String( lp_days[i] ).toLowerCase().replace(/\s/g,"");
        }
        
        // quito palabras
        for(let j = 0; j<lv_deleteFromTime.length; j++){
          lv_str = lv_str.replace(lv_deleteFromTime[j],"");
        }

        lv_str = lv_str == "24" || lv_str == "guardiapasiva" || lv_str == "guardiaspasivas" || lv_str == $("<div>quir&oacute;fano</div>").html() ? "00:00-23:59" : lv_str;
        lv_str = lv_str.replace("a","-").replace("hs","").replace("s","-").replaceAll(".",":");
        lv_str = lv_str === "0" || lv_str === "-" ? "" : lv_str;

        if(lv_tmeformat.test(lv_str) || !lv_str){

          // relleno con :00 a la hora
          let lv_hrs = lv_str.split("-");
          for(let k = 0; k < lv_hrs.length; k++){
            if(lv_hrs[k].length<5 && lv_hrs[k].length){
              lv_hrs[k]+=":00";
            }
          }

          lv_str = lv_hrs.join("-");
          if(lv_str){
            lv_tmeseq += lv_days[i] + lv_str;
            lv_hhrtmerngatr["tmerng"].push( {"tmeday":lv_days[i],"tmestr":lv_hrs[0],"tmeend":lv_hrs[1]} );
          }

          lp_days[i] = lv_str;
        }else{
          lv_validtme = false;
        }
      }				

      // obtengo carga horaria semanal 
      let lv_wekhrs = (lp_wrklod ? lp_wrklod : 0 ).toString().trim().toLowerCase(); 
      let lv_hhrtmerngfrq = 0;
      const wekhrsformat = new RegExp(/^(n|[2-6])xm( (a|b))?$/);
      if(isNaN(lv_wekhrs) && wekhrsformat.test(lv_wekhrs)){ 
        lv_hhrtmerngfrq = lv_wekhrs[0] == "n" ? 1 : Number(lv_wekhrs[0]);
        lv_wekhrs = 0;
      }else if(lv_wekhrs=="sadofe"){
        let lv_hld;
        
        if(lv_hhrtmerngatr["tmerng"][0]){
          lv_hld = Object.assign({}, lv_hhrtmerngatr["tmerng"][0]);
          lv_hld["tmeday"] = "F";
        }else{
          lv_hld = {"tmeday":"F", "tmestr":"00:00", "tmeend":"23:59"};
        }
        
        lv_tmeseq += "F"+lv_hld["tmestr"]+"-"+lv_hld["tmeend"];
        lv_hhrtmerngatr["tmerng"].push( lv_hld );
        lv_wekhrs = 0;
      }else { 
        lv_wekhrs = Number(lv_wekhrs);
      }

      if((lp_wrklod==="" || Number.isNaN(lv_wekhrs)) && !lv_tmeseq && !lv_hhrtmerngfrq){
        lv_validtme = false;
      }

      lv_hhrtmerngfrq++;
      
      // tiene horario definido, así que lo busco
      if((lv_tmeseq || lv_wekhrs || lv_wekhrs == 0) && lv_validtme){
        let lv_tme = <?= $lv_sec; ?>_tme.find(elem => {  
          return elem["tmerngseq"] == lv_tmeseq && Number(elem["hhrtmerngwekhrs"]) == lv_wekhrs && elem["hhrtmerngfrq"] == lv_hhrtmerngfrq;
        });

        lv_hhrtmerngcod = lv_tme ? lv_tme["hhrtmerngcod"] : 0;
        lv_hhrtmerngatr = lv_tme ? lv_tme["hhrtmerngatr"] : lv_hhrtmerngatr;
      }
      
      // determino si hay que eliminar el horario del empleado o no registrar su horario
      let lv_hhremptmecod = 0
      if(lp_hhrempcod && lp_wrkstefnccod && lp_wrkplccod && lv_hhrtmerngcod){
        // busco si está el horario registrado
        let lv_emptme = <?= $lv_sec; ?>_emptme.find(
            elem => { return elem["hhrempcod"] == lp_hhrempcod && elem["wrkstecod"] == lp_wrkstefnccod 
                        && elem["wrkplccod"] == lp_wrkplccod && elem["hhrtmerngcod"] == lv_hhrtmerngcod; 
                    }
        );
        lv_hhremptmecod = lv_emptme ? lv_emptme["hhremptmecod"] : 0; 
      }
      
      return {hhrtmerngfrq: lv_hhrtmerngfrq,
              wekhrs: lv_wekhrs,
              tmeseq: lv_tmeseq,
              hhrtmerngatr: lv_hhrtmerngatr,
              hhrtmerngcod: lv_hhrtmerngcod,
              validtme: lv_validtme,
              days: lp_days,
              hhremptmecod: lv_hhremptmecod
             };
    }
    
    // ARCHIVO. boton cargar archivo
    $("#<?= $lv_sec; ?> #btnupl").on("click",function(e){e.preventDefault();
      $("#<?= $lv_sec; ?> #uplfle").trigger("click");
    });	
    
		tmssLoadScript("sheetjs",function(){
			// PROCESO. se procesa el archivo cargado
			$("#<?= $lv_sec; ?> #uplfle").on("change",function(e){
				var lv_flenme = $(this).prop("files")[0].name;
				var lv_fletyp = $(this).prop("files")[0].type;

				// barra de progreso
				$("#<?= $lv_sec; ?> .progress").data("progress","0");
				<?= $lv_sec; ?>_tmr = setInterval(function () {
						var lv_width = $("#<?= $lv_sec; ?> .progress").data("progress");
            if ( Number(lv_width)>=100 ) {
							$("#<?= $lv_sec; ?> .progress").addClass("hidden");
              clearInterval(<?= $lv_sec; ?>_tmr);
            } else {
							$("#<?= $lv_sec; ?> .progress").removeClass("hidden").data("progress",lv_width);
							$("#<?= $lv_sec; ?> .progress > div:first").css("width",lv_width+"%");
            }
        }, 15);
				
				<?= $lv_sec; ?>_hotdoc.loadData([]);
				var lo_reader = new FileReader();
				lo_reader.readAsArrayBuffer( e.target.files[0] );
				lo_reader.onload = function (e) {
					var lv_res = lo_reader.result;
					// carga XLSX
					var lo_dat = new Uint8Array( lv_res );
					var lo_wb = XLSX.read( lo_dat, {type:"array", cellText: false, cellDates: true, dateNF:"dd/mm/yyyy"} ); 
					var lo_ws = lo_wb.Sheets[lo_wb.SheetNames[0]];
          
					var lo_arr = XLSX.utils.sheet_to_json(lo_ws, {header:1, raw: true, dateNF: "dd/MM/yyyy"});
					var lv_hotarr = [];
					$("#<?= $lv_sec; ?> .progress").data("progress","10");
          
          var lv_days = ["L","M","X","J","V","S","D"];
          var lv_deleteFromTime = ["sala","consul","rotativo","comision", "horariodiscontinuol/v", "horariodiscontinuo", "discontinuas", "discontinuo", "comision"];
          var lv_deleteFromWorkload = ["hs", ".", "semanales"];
					for(var i=1; i<lo_arr.length; i++){ 
            // acomodo fecha de inicio de cargo
           	const lv_validstrdte = !lo_arr[i][10] || !Number.isInteger(lo_arr[i][10])
            if(lv_validstrdte){
              if(lv_fletyp=="text/csv" && lo_arr[i][10]/* && lo_arr[i][10].trim()*/){ 
                let lv_dte = new Date(lo_arr[i][10]);
                let lv_day = lv_dte.getDate();
                let lv_mth = lv_dte.getMonth()+1;
                lv_day = (lv_day < 10 ? "0" : "") + lv_day;
                lv_mth = (lv_mth < 10 ? "0" : "") + lv_mth;
                lo_arr[i][10] = lv_day +  "/" + lv_mth + "/" + lv_dte.getFullYear()
              }else{
                lo_arr[i][10] = "";
              }
            }
            
						$("#<?= $lv_sec; ?> .progress").data("progress", Number( 10 + (i * 50 / lo_arr.length) ).toFixed(0) );
						
            // busco lugar de tabajo
            let lv_wrkplc = <?= $lv_sec; ?>_plc.find(elem => { return elem["wrkplctxt"] == lo_arr[i][3]; });
            let lv_wrkplccod = lv_wrkplc ? lv_wrkplc["wrkplccod"] : 0;
            
            // busco empleado
            let lv_hhremp = <?= $lv_sec; ?>_emp.find(elem => { return elem["hhrempcodext"] == lo_arr[i][0]; });
            let lv_hhrempcod = lv_hhremp ? lv_hhremp["hhrempcod"] : 0;

            // busco dpto
            let lv_dpto = <?= $lv_sec; ?>_dpto.find(elem => { return elem["wrkstetxt"] == lo_arr[i][4]; });
            let lv_wrkstedptocod = lv_dpto ? lv_dpto["wrkstecod"] : (lo_arr[i][4] ? 0 : -1); 
            // 0: debería crearse el dpto / -1: no tiene nombre el dpto
            
            // busco servicio
            let lv_srv = <?= $lv_sec; ?>_srv.find(elem => { return elem["wrkstetxt"] == lo_arr[i][5]; });
            let lv_wrkstesrvcod = lv_srv ? lv_srv["wrkstecod"] : (lo_arr[i][5] ? 0 : -1); 
            
            // busco función
            let lv_fnc = <?= $lv_sec; ?>_fncarr.find(elem => { return elem["wrkstetxt"] == lo_arr[i][6]; });
            let lv_wrkstefnccod = lv_fnc ? lv_fnc["wrkstecod"] : (lo_arr[i][6] ? 0 : -1); 
            
            var lv_tmeatr = <?= $lv_sec; ?>_getTmeAtr(lo_arr[i].slice(12, 19), lo_arr[i][11], lv_hhrempcod, lv_wrkstefnccod, lv_wrkplccod);
            
            // añade fila a la tabla
            lv_hotarr.push({hhrempcod:lv_hhrempcod,
                            hhrempcodext:lo_arr[i][0] ?? "",
                            hhremptxt:lo_arr[i][1],
                            escalafon:lo_arr[i][2],
                            areafisica:lo_arr[i][3] ?? "",
                            wrkplccod:lv_wrkplccod,
                            wrkstedptocod: lv_wrkstedptocod,
                            departamento:lo_arr[i][4] ?? "",
                            wrkstesrvcod: lv_wrkstesrvcod,
                            servicio:lo_arr[i][5] ?? "",
                            wrkstefnccod: lv_wrkstefnccod,
                            funcion:lo_arr[i][6] ?? "",
                            profesion:lo_arr[i][7],
                            especialidad:lo_arr[i][8],
                            nrocargo:lo_arr[i][9],
                            hhremptmestr:lo_arr[i][10],
                            cargahoraria:lo_arr[i][11],
                            diaL: lv_tmeatr["days"][0],
                            diaM: lv_tmeatr["days"][1],
                            diaX: lv_tmeatr["days"][2],
                            diaJ: lv_tmeatr["days"][3],
                            diaV: lv_tmeatr["days"][4],
                            diaS: lv_tmeatr["days"][5],
                            diaD: lv_tmeatr["days"][6],
                            hhrtmerngcod: lv_tmeatr["hhrtmerngcod"],
                            estado:lo_arr[i][19],
                            tmeseq: lv_tmeatr["tmeseq"],
                            hhrtmerngatr: lv_tmeatr["hhrtmerngatr"],
                            hhremptmecod: lv_tmeatr["hhremptmecod"],
                            hhrtmerngfrq: lv_tmeatr["hhrtmerngfrq"],
                            hhrtmerngwekhrs: lv_tmeatr["wekhrs"],
                            validtme: lv_tmeatr["validtme"],
                            validstrdte: lv_validstrdte
                          });
            
            // actualiza contador de errores
            if(!lv_hhrempcod){ <?= $lv_sec; ?>_hotdocnew["emp"]++; }
            if(!lv_wrkplccod){ <?= $lv_sec; ?>_hotdocnew["plc"]++; }
            if(!lv_tmeatr["hhrtmerngcod"]){ <?= $lv_sec; ?>_hotdocnew["tme"]++; }
            if(!lv_wrkstedptocod){ <?= $lv_sec; ?>_hotdocnew["dto"]++; }
            if(!lv_wrkstesrvcod){ <?= $lv_sec; ?>_hotdocnew["srv"]++; }
            if(!lv_wrkstefnccod){ <?= $lv_sec; ?>_hotdocnew["fnc"]++; }
          }
          $("#<?= $lv_sec; ?> .progress").data("progress","75");
					
          <?= $lv_sec; ?>_hotdoc.loadData( lv_hotarr );
          $("#<?= $lv_sec; ?> .progress").data("progress","90");

          <?= $lv_sec; ?>_hotdoc.render();						
          $("#<?= $lv_sec; ?> .progress").data("progress","100");
        }
      });
		});
	</script>
	<script>
  	//  E M P L E A D O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_hotdoc != undefined ) {
				var lv_notRegistered = "<div style='color:#FFC107;'></div>";
        
        switch(prop){
          case "hhrempcodext": case "hhremptxt": 
            let lv_hhrempcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"hhrempcod");
            if(!lv_hhrempcod){ td.style.backgroundColor = $(lv_notRegistered).css("color"); }
            break;
            
          case "areafisica":
            let lv_wrkplccod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"wrkplccod");
            if(!lv_wrkplccod){ td.style.backgroundColor = $(lv_notRegistered).css("color"); }
            break;
            
          case "diaL": case "diaM": case "diaX": case "diaJ": case "diaV": case "diaS": case "diaD":
            let lv_hhrtmerngcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"hhrtmerngcod");
            if(!lv_hhrtmerngcod){ td.style.backgroundColor = $(lv_notRegistered).css("color"); }
            break;
            
          case "departamento": 
            let lv_wrkstedptocod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"wrkstedptocod");
            if(lv_wrkstedptocod<=0){ td.style.backgroundColor = $(lv_notRegistered).css("color"); }
            break;
            
          case "servicio":
            let lv_wrkstesrvcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"wrkstesrvcod");
            if(lv_wrkstesrvcod<=0){ td.style.backgroundColor = $(lv_notRegistered).css("color"); }
            break;
            
          case "funcion":
            let lv_wrkstefnccod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"wrkstefnccod");
            if(lv_wrkstefnccod<=0){ td.style.backgroundColor = $(lv_notRegistered).css("color"); }
            break;
        }
        
				if ( prop=="nrocargo") {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
				}
        
        
        var lv_validtme = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"validtme");
      	var lv_validstrdte = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"validstrdte"); 
        if(!lv_validtme || !lv_validstrdte){ 
          td.style.backgroundColor = "#FFAAAA";
          if((prop == "hhremptmestr" && !lv_validstrdte) || ((/dia[LMXJVSD]/.test(prop) || prop == "cargahoraria") && !lv_validtme)){
            td.style.backgroundColor = "#f2483f";
          }
        }else if($(td).css("backgroundColor") != $(lv_notRegistered).css("color")){
           td.style.backgroundColor = "";
        }
			}
		};
    
    var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocnew = {emp: 0, plc: 0, tme: 0, dto: 0, srv: 0, fnc: 0};
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hhremphot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
      <?= ($vew_readonly? '':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'0') ?>,
			colHeaders: [ "Legajo", "ApellidoNombre", 
										"Escalafon","AreaFisica", "Departamento","Servicio","Funcion","Profesion","Especialidad",
										"Cargo", "Fecha de inicio", "CargaHoraria",
										"Lunes","Martes","Miercoles","Jueves","Viernes","Sabado","Domingo","Estado" ],
			columns: [
        {type: "text", data: "hhrempcodext", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly ?'readOnly: true, ':''); ?> allowEmpty: false},
				{type: "text", data: "hhremptxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?> },
				{type: "text", data: "escalafon", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?> },
        {type: "text", data: "areafisica", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "departamento", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "servicio", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "funcion", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "profesion", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "especialidad", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
				{type: "numeric", data: "nrocargo", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer , <?= ($vew_readonly?'readOnly: true, ':''); ?> numericFormat: {pattern: "0", culture: "es-AR"} },
				{type: "date", data: "hhremptmestr", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?'readOnly: true, ':''); ?>,
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: true,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
        {type: "text", data: "cargahoraria", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer , <?= ($vew_readonly?'readOnly: true, ':''); ?> numericFormat: {pattern: "0.0", culture: "es-AR"} },
        {type: "text", data: "diaL", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "diaM", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "diaX", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "diaJ", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "diaV", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "diaS", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "diaD", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "estado", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> }
			],
      beforeChange: function(changes, source){ 
        if(changes && changes[0][2]!=changes[0][3]){
          var lv_propToChange="", lv_valueToChange = 0;
          
          // busca ids de empleado / área física / horario
          switch(changes[0][1]){
            case "hhrempcodext":
              let lv_hhremp = <?= $lv_sec; ?>_emp.find(elem => { return elem["hhrempcodext"] == changes[0][3]; });
              lv_valueToChange = lv_hhremp ? lv_hhremp["hhrempcod"] : 0;
              lv_propToChange = "hhrempcod";
              
              break;
              
            case "areafisica":
              let lv_wrkplc = <?= $lv_sec; ?>_plc.find(elem => { return (elem["wrkplctxt"]).toUpperCase() == (changes[0][3]).toUpperCase(); });
              lv_valueToChange = lv_wrkplc ? lv_wrkplc["wrkplccod"] : 0;
              lv_propToChange = "wrkplccod";
              
              break;
              
            case "departamento":
              let lv_dpto = <?= $lv_sec; ?>_dpto.find(elem => { return (elem["wrkstetxt"]).toUpperCase() == (changes[0][3]).toUpperCase(); });
              lv_valueToChange = lv_dpto ? lv_dpto["wrkstecod"] : (changes[0][3] ? 0 : -1); 
              lv_propToChange = "wrkstedptocod";
              break;
              
            case "servicio":
              let lv_srv = <?= $lv_sec; ?>_srv.find(elem => { return (elem["wrkstetxt"]).toUpperCase() == (changes[0][3]).toUpperCase(); });
              lv_valueToChange = lv_srv ? lv_srv["wrkstecod"] : (changes[0][3] ? 0 : -1);
              lv_propToChange = "wrkstesrvcod";
              break;
              
            case "funcion":
              let lv_fnc = <?= $lv_sec; ?>_fncarr.find(elem => { return (elem["wrkstetxt"]).toUpperCase() == (changes[0][3]).toUpperCase(); });
              lv_valueToChange = lv_fnc ? lv_fnc["wrkstecod"] : (changes[0][3] ? 0 : -1);
              lv_propToChange = "wrkstefnccod";
              break;
              
            case "diaL": case "diaM": case "diaX": case "diaJ": case "diaV": case "diaS": case"diaD": case "cargahoraria":
              let lv_rowData = <?= $lv_sec; ?>_hotdoc.getDataAtRow(changes[0][0]);
              for(let i=0; i < changes.length; i++){
              	lv_rowData[<?= $lv_sec; ?>_hotdoc.propToCol(changes[i][1])] = changes[i][3];
              }
              
              let lv_hhrempcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "hhrempcod");
              let lv_wrkstefnccod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "wrkstefnccod");
              let lv_wrkplccod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "hhrtmerngatr"); 
              let lv_tmeatr = <?= $lv_sec; ?>_getTmeAtr(lv_rowData.slice(12, 19), lv_rowData[11], lv_hhrempcod, lv_wrkstefnccod, lv_wrkplccod);
              
          		changes.push([changes[0][0], "tmeseq", "", lv_tmeatr["tmeseq"]]);
              changes.push([changes[0][0], "hhrtmerngatr", "", lv_tmeatr["hhrtmerngatr"]]);
              changes.push([changes[0][0], "validtme", "", lv_tmeatr["validtme"]]);
              changes.push([changes[0][0], "hhremptmecod", "", lv_tmeatr["hhremptmecod"]]);
              lv_valueToChange = lv_tmeatr["hhrtmerngcod"];
              lv_propToChange = "hhrtmerngcod";
              
              break;
              
            case "hhremptmestr":
              changes.push([changes[0][0], "validstrdte", "", true]);
              break;
          }
          
          if(lv_propToChange){
            // actualiza id
          	changes.push([changes[0][0], lv_propToChange, "", lv_valueToChange]);
            
            // llama a validar para que actualice los contadores de errores
            <?= $lv_sec; ?>_hotdoc.runHooks("afterValidate", lv_valueToChange!=0, "", changes[0][0], lv_propToChange); 
          }
        }
      },
			afterValidate: function( isValid, value, row, prop, source) {
        // aumenta/decrementa el nro de empleados/áreas/horarios no registrados
        var lv_errCounterKey = "";
        switch(prop){
          case "hhrempcod": lv_errCounterKey = "emp"; break;
          case "wrkplccod": lv_errCounterKey = "plc"; break;
          case "hhrtmerngcod": lv_errCounterKey = "tme"; break;
          case "wrkstedptocod": lv_errCounterKey = "dto"; break;
          case "wrkstesrvcod": lv_errCounterKey = "srv"; break;
          case "wrkstefnccod": lv_errCounterKey = "fnc"; break;
        }
        var <?= $lv_sec; ?>_hotdocnew = {emp: 0, plc: 0, tme: 0, dto: 0, srv: 0, fnc: 0};
        
        if(lv_errCounterKey){
        	<?= $lv_sec; ?>_hotdocnew[lv_errCounterKey] += isValid ? -1 : 1;
        }else{
          var lv_key = prop + "_" + row.toString();
          var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
          if ( isValid==false ) {
            <?= $lv_sec; ?>_hotdocerr.push( lv_key );
          } else {
            if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }
          }
        }
			}
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			<?= $lv_sec; ?>_hotdoc.loadData( [] );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
    // server response ext 
    function <?= $lv_sec; ?>_fncbckext(data) { 
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="itzpersonal00") { 
          toastr.success( "Documento procesado.", "<?= $lv_title; ?>" );
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        }
      }
    }
    
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="itzpersonal00" ) {
        if ( !tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") ) ) { return false; }
        
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
        
        if(<?= $lv_sec; ?>_hotdocnew["emp"] && $("#<?= $lv_sec; ?> #updemp").is(":not(:checked)")){
          toastr.warning("Hay empleados sin registrar.");
          return false;
        }
        
        if(<?= $lv_sec; ?>_hotdocnew["plc"] && $("#<?= $lv_sec; ?> #updplc").is(":not(:checked)")){
          toastr.warning("Hay &aacute;reas f&iacute;sicas sin registrar.");
          return false;
        }
        
        if(<?= $lv_sec; ?>_hotdocnew["tme"] && $("#<?= $lv_sec; ?> #updtme").is(":not(:checked)")){
          toastr.warning("Hay horarios sin registrar.");
          return false;
        }
        
        if(<?= $lv_sec; ?>_hotdocnew["dto"] && $("#<?= $lv_sec; ?> #upddto").is(":not(:checked)")){
          toastr.warning("Hay departamentos sin registrar.");
          return false;
        }
        
        if(<?= $lv_sec; ?>_hotdocnew["srv"] && $("#<?= $lv_sec; ?> #updsrv").is(":not(:checked)")){
          toastr.warning("Hay servicios sin registrar.");
          return false;
        }
        
        if(<?= $lv_sec; ?>_hotdocnew["fnc"] && $("#<?= $lv_sec; ?> #updfnc").is(":not(:checked)")){
          toastr.warning("Hay funciones sin registrar.");
          return false;
        }

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
        for(let i=0; i<lo_dat.length; i++){
          if(lo_dat[i]["validtme"] && lo_dat[i]["validstrdte"]){
            lv_arr.push({hhrempcod: lo_dat[i]["hhrempcod"],
                        hhrempcodext: lo_dat[i]["hhrempcodext"],
                        hhremptxt: lo_dat[i]["hhremptxt"],
                        wrkplccod: lo_dat[i]["wrkplccod"],
                        wrkplctxt: lo_dat[i]["areafisica"], 
                        wrkstedptocod: lo_dat[i]["wrkstedptocod"],
                        departamento: lo_dat[i]["departamento"],
                        wrkstesrvcod: lo_dat[i]["wrkstesrvcod"],
                        servicio: lo_dat[i]["servicio"],
                        wrkstefnccod: lo_dat[i]["wrkstefnccod"],
                        funcion: lo_dat[i]["funcion"],
                        hhrtmerngcod: lo_dat[i]["hhrtmerngcod"],
                        hhremptmestr: lo_dat[i]["hhremptmestr"],
                        tmeseq: lo_dat[i]["tmeseq"],
                        hhrtmerngatr: lo_dat[i]["hhrtmerngatr"],
                        hhrtmerngwekhrs: lo_dat[i]["hhrtmerngwekhrs"],
                        hhremptmecod: lo_dat[i]["hhremptmecod"],
                        hhrtmerngfrq: lo_dat[i]["hhrtmerngfrq"],
                        estado: lo_dat[i]["estado"] 
                      });
          }else{
            if(!lo_dat[i]["validtme"]){
              toastr.warning("Hay horarios no v&aacute;lidos.");
            }
            
            if(!lo_dat[i]["validstrdte"]){
              toastr.warning("Hay fechas de inicio no v&aacute;lidas.");
            }
            
            return false;
          }
        }
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #hhrmsm").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #hhrmsm").prop("value", JSON.stringify( lv_arr ) );
				}
      }
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>