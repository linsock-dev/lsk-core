<?php		
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_data->rpttxt;
	
	// módulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';
	
	$vew_actcod = '02';
	
	// librería de estilos bootstrap
	include_once('_library.frm');	
	
	$lv_rptmsgcls = $vew_data->rptmsgcls;

	if($vew_data->rptatr!=''){
    $lv_rptatr = $vew_doc->getArrayFromJson( $vew_data->rptatr );
  }
	$lv_rptttl = utf8_decode($lv_rptatr['rptttl']??'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php
		// se agrega toolbar si NO es POPUP y NO está incluido en otro REPORTE
		if($vew_data->popup=='' && $vew_data->included==''){
			$vew_tbl = array();
			$vew_tbl['sveR'] = array('per'=>false);
			$vew_tbl['sveL'] = array('per'=>false);
			$vew_tbl['canc'] = array('per'=>false);
      $vew_tbl['dwn']=array('id'=>'dwntbl','per'=>true,'pos'=>'R',
                            'htm'=>"<a href='#' id='dwntbl' class='btn navbar-btn tmss-navbar-btn col-auto pl-15 pr-15'><i class='far fa-download' title='".$vew_lang->download."'></i></a>");  
      if($vew_data->rptsrccod!=''){ 
        $vew_tbl['fltR'] = array('id'=>'fltR','per'=>true,'pos'=>'R',
                                 'htm' => '<a href="#" id="fltR" onclick="'.$lv_sec.'_showFilter();" class="btn navbar-btn tmss-navbar-btn" title="'.$vew_lang->filter.'"><i class="fas fa-filter"></i><span id="fltcnt" class="badge"></span></a>'
                                 );
      }
			$vew_tbl['rfrsh']=array('id'=>'upd','per'=>true,'pos'=>'','ttl'=>$vew_lang->refresh,'icn'=>'fas fa-sync-alt','css'=>'tmss-Opt','acc'=>$lv_sec.'_refreshData();');  
			include('grldocfrmtlb.frm'); 
		}
	?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <style>
      /*** T A B L A S ***/
    	#<?= $lv_sec; ?>_frm #divlay {
        display: flex;
        flex-direction: column;
        min-height: calc(100vh - 27.5vh);
      }

      #<?= $lv_sec; ?>_frm #divlay > .row {
        display: flex;
        flex: 1;
      }

      #<?= $lv_sec; ?>_frm #divlay [data-crdtyp="tbl"] {
        flex: 1;
        display: flex;
        flex-direction: column;
        min-height: 0;
        max-height: calc(100vh - 30vh);
      }

      /* La tabla se expande dinámicamente entre el header y el footer */
      #<?= $lv_sec; ?>_frm #divlay [data-crdtyp="tbl"] .bootstrap-table,
      #<?= $lv_sec; ?>_frm #divlay [data-crdtyp="tbl"] .bootstrap-table .fixed-table-container{
        flex: 1; /* ocupa todo el espacio sobrante */
        display: flex;
        flex-direction: column;
        min-height: 0;
      }

      /* Estilo del pie de cada tabla */
      #<?= $lv_sec; ?>_frm .pagination-info {
        display: block;
        text-align: left !important;
        margin-left: 8px;
      }
      
      /* Elimino el padding debajo del form para no forzar el scroll */
      #<?= $lv_sec; ?>_frm .tmss-form-horizontal {
        padding-bottom: none;
      }
      
      /*** G R Á F I C O S ***/
      /* Contenedor de cada gráfico dentro de la card */
      #<?= $lv_sec; ?> #divlay div[data-crdtyp=grp] {
        display: flex;
        flex-direction: column;
        flex: 1;               /* que ocupe todo el espacio disponible */
        min-height: 0;         /* crucial en flexbox */
        max-height: 100%;      /* no exceda la card */
      }

      /* Título externo */
      #<?= $lv_sec; ?> #divlay div[data-crdtyp=grp] .tbl-title {
        flex-shrink: 0;       /* no se encoge */
        margin-bottom: 8px;
      }

      /* Contenedor del canvas */
      #<?= $lv_sec; ?> #divlay div[data-crdtyp=grp] .chart-container {
        flex: 1;              /* ocupa todo el espacio sobrante */
        display: flex;
        min-height: 0;
      }

      /* Canvas para que tome todo el contenedor */
      #<?= $lv_sec; ?> #divlay div[data-crdtyp=grp] .chart-container canvas {
        width: 100% !important;
        height: 100% !important;
      }
      
      
      /* Título de la Navbar */
      /* fuerzo que el container de la navbar sea flexible */
      #<?= $lv_sec; ?> .container-fluid.d-flex {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: nowrap;   /* impide salto de línea */
        gap: 8px;            /* espaciado adaptable */
        /*overflow: hidden;*/
        min-width: 0;        /* para permitir encogimiento */
      }
      /* permito que el espacio entre elementos sea achicable para que entren en una sola línea*/
      #<?= $lv_sec; ?> .container-fluid.d-flex > * {
        display: flex;
        flex-shrink: 1;      /* permite que todos se achiquen */
        min-width: 0;        /* esencial para truncar texto */
      }
      #<?= $lv_sec; ?> .tmss-navbar-subtitle { display: block !important; }
      #<?= $lv_sec; ?> .tmss-navbar-title {
      	display: block !important;
      	overflow: hidden;
        text-overflow: ellipsis;
        font-weight: bold;
        font-size: 16px;
        white-space: nowrap;
        font-weight: bold;
        font-size: 16px;
        pointer-events: none;
        min-width: 0 !important;
      }
    </style>
		<div class="container-fluid">
			<div class="card">
				<?= (($lv_rptttl??'')=='' ? '' : '<div class="card-header"><div class="card-title">'.$lv_rptttl.'</div></div>'); ?>
				<div class="card-body tmss-card-body-edit" id="divlay">
					<?php
						echo gethtml('vewfldflt', 'hidden', htmlentities($vew_data->vewfldflt));
          	echo gethtml('vewfltcod', 'hidden', $vew_data->vewfltcod);
						echo gethtml('vewfldord', 'hidden', $vew_data->vewfldord);
						echo gethtml('vewmaxrec', 'hidden', $vew_data->vewmaxrec);
						echo gethtml('src', 'hidden', '');
						echo gethtml('stm', 'hidden', '');
					?>
					<?php
						$lv_buffer='';
						if(isset($lv_rptatr['rows'])){
							foreach($lv_rptatr['rows'] as $lv_row){
								$lv_buffer.='<div class="row">';
								foreach($lv_row as $lv_col){
									if($lv_col['crdtyp']=='tbl'){
										$lv_buffer.='<div class="col-sm-'.(12/count($lv_row)).' text-center" style="padding:10px;" data-crdtyp="'.$lv_col['crdtyp'].'" name="rptdat" '
                      					.' data-tblttl="'.($lv_col['tblttl']??'').'" '
                      					.' data-tblttlshw="'.($lv_col['tblttlshw']??'').'" '
																.' data-tblrowfld="'.htmlentities(isset($lv_col['tblrowfld'])?(is_array($lv_col['tblrowfld'])?json_encode($lv_col['tblrowfld']):$lv_col['tblrowfld']):'').'" '
																.' data-tblcolfld="'.htmlentities(isset($lv_col['tblcolfld'])?(is_array($lv_col['tblcolfld'])?json_encode($lv_col['tblcolfld']):$lv_col['tblcolfld']):'').'" '
																.' data-tbldatfld="'.htmlentities(isset($lv_col['tbldatfld'])?(is_array($lv_col['tbldatfld'])?json_encode($lv_col['tbldatfld']):$lv_col['tbldatfld']):'').'"><i class="far fa-code" style="margin-top:100px;" ></i></div>';
									} else if($lv_col['crdtyp']=='zcu'){
										$lv_buffer.='<div class="col-sm-'.(12/count($lv_row)).' text-center" style="padding:10px;" data-crdtyp="'.$lv_col['crdtyp'].'" data-zcuurl="'.htmlentities(isset($lv_col['zcuurl'])?$lv_col['zcuurl']:'').'"><i class="far fa-code" style="margin-top:100px;" ></i></div>';
									} else if($lv_col['crdtyp']=='grp'){
										$lv_buffer.='<div style="height:300px;" class="col-sm-'.(12/count($lv_row)).' text-center" style="padding:10px;" data-crdtyp="'.$lv_col['crdtyp'].'" data-grptyp="'.(isset($lv_col['grptyp'])?$lv_col['grptyp']:'chart-pie').'" data-grpttl="'.(isset($lv_col['grpttl'])?utf8_decode($lv_col['grpttl']):'').'" data-grplgnpos="'.(isset($lv_col['grplgnpos'])?$lv_col['grplgnpos']:'').'" data-grpdatrowfld="'.(isset($lv_col['grpdatrowfld'])?$lv_col['grpdatrowfld']:'').'" data-grpdatcolfld="'.(isset($lv_col['grpdatcolfld'])?$lv_col['grpdatcolfld']:'').'" data-grpdatfld="'.(isset($lv_col['grpdatfld'])?$lv_col['grpdatfld']:'').'" data-grpcal="'.(isset($lv_col['grpcal'])?$lv_col['grpcal']:'').'"><i class="far fa-'.(isset($lv_col['grptyp'])?$lv_col['grptyp']:'chart-pie').'" style="margin-top:100px;" ></i><canvas class="hidden"></canvas></div>';
									}
								}
								$lv_buffer.='</div>';
							}
						}
						echo $lv_buffer;
					?>
				</div>
			</div><!-- /card -->
		</div><!-- /container-fluid -->
  </form>
	<script>
		var gv_<?= $lv_sec; ?>_flt = [];
    var lv_<?= $lv_sec; ?>_grdfltcod = '';
    
    // INICIALIZACION. cargo definicion de reportes y proceso cada uno
		$(function(){ 
      // muestro título y subtítulo
      $("#<?= $lv_sec ?> .tmss-navbar-subtitle").html("<?= addslashes($vew_data->rpthietxt); ?>");
      $("#<?= $lv_sec ?> .tmss-navbar-title").show();

			<?php
	    // armo estructura de filtros
      // obentengo los campos por los que se puede filtrar
      $lv_fltarr = json_decode(utf8_encode($vew_data->rptatr),true);
      if(isset($lv_fltarr['rptflt'])){
				$lv_fltarr['rptflt'] = (gettype($lv_fltarr['rptflt'])=='string'?json_decode($lv_fltarr['rptflt'],true):$lv_fltarr['rptflt']);
				if($lv_fltarr['rptflt']!=null){
					for($i=0; $i<count($lv_fltarr['rptflt']);$i++){
						$lv_fldflt = $lv_fltarr['rptflt'][$i]['rptsrccolcod'];
						// busco la definicion del campo a filtrar
						foreach($vew_data->rptsrc->col as $lv_col){
              //$lv_colfldnme = ($lv_col["rptsrccolcodext"]??"")!="" ? $lv_col["rptsrccolcodext"] : $lv_col["rptsrccolcodint"];
              $lv_colfldcod = $lv_col["rptsrccolcod"];
							if($lv_fldflt==$lv_colfldcod){
								$lv_flddef = $vew_doc->getTagValue($lv_col['rptsrccolatr'],'def');
								$lv_fld = $vew_input->getField( $lv_flddef );
								echo 'gv_'.$lv_sec.'_flt.push({fldttl:"'.$lv_col['rptsrccoltxt'].'", fldcod:"'.$lv_col['rptsrccolcodext'].'", fldtyp:"'.$lv_col['sysfldinptyp'].'", flttyp: "", fldvalstr: "", fldvalend: ""});';
								break;
							}
						}
					}
				}
      }
      ?>
      gv_<?= $lv_sec; ?>_flt.push( {fldttl: "", fldcod: "vewmaxrec", fldtyp: "", flttyp: "", fldvalstr: "<?= ($vew_data->vewmaxrec==''?'100':$vew_data->vewmaxrec); ?>", fldvalend: ""} );
      tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt, $("#<?= $lv_sec ?> #vewfldflt").val() );
			
      <?= $lv_sec; ?>_refreshData();
      
      tmssLoadScript("table2excel",function(){});
    });
		
    // SHOW FILTER. muestra el formulario de filtro
		function <?=$lv_sec;?>_showFilter(){
      var lv_grdfltcod = (lv_<?= $lv_sec; ?>_grdfltcod === '') ? "<?= $vew_data->vewfltcod ?>" : lv_<?= $lv_sec; ?>_grdfltcod;
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_filterRefresh, "<?= $vew_data->vewcod ?>", lv_grdfltcod, "<?= $lv_sec; ?>");
    }
    function <?= $lv_sec; ?>_filterRefresh(lp_flt) {
			if(lp_flt!=null){
				gv_<?= $lv_sec; ?>_flt = lp_flt;
			}
      $("#<?= $lv_sec; ?> #vewmaxrec").val( $(".modal-dialog .form-group #vewmaxrec").val() );
     	<?= $lv_sec; ?>_refreshData();
		}
    
     
		// REFRESH DATA. actualiza los datos de todo el reporte
    function <?= $lv_sec; ?>_refreshData(){
			// GRAFICOS/TABLAS. establece iconos de espera
      $("#<?= $lv_sec; ?> #divlay div[data-crdtyp=grp], #<?= $lv_sec; ?> #divlay div[data-crdtyp=tbl]").each(function(){
        $(this).html("<i class='fas fa-spinner fa-spin fa-4x'></i><canvas></canvas>"); 
      });
      
      // PERSONALIZADO. ejecuta secciones de reporte personalizado
      $("#<?= $lv_sec; ?> #divlay div[data-crdtyp=zcu]").each(function(){
        <?php if($vew_data->depth<5){ /* para prevenir recursividad*/ ?>
          $(this).html("<i class='fas fa-spinner fa-spin fa-4x'></i>"); 
          var lv_url = $(this).data("zcuurl");
          var lv_pstdat = [{name:"included",value:"X"},{name:"depth",value:"<?= ($vew_data->depth==''?0:$vew_data->depth)+1; ?>"}]; // armar post para filtros
          var lv_div = $(this);
          tmssCallProcessNoBackdropErr(lv_url,lv_pstdat,function(data){
            $(lv_div).html( data );
          },function(err){
            $(this).html("<span class='text-danger'><i class='far fa-exclamation-triangle fa-3x'></i> "+err.errcod+": "+err.errtxt+"</span>");
          });
      	<?php } ?>
      }); 
      
      // DATOS. obtiene datos del reporte
      var lv_flt = tmssFilterParseToInternal( gv_<?= $lv_sec; ?>_flt );
			var lv_pstdat =[{name:"rptsrccod",value:"<?= $vew_data->rptsrccod; ?>"},
                      {name:"rptsrcsys",value: "<?= isset($lv_fltarr['rptsrcsystyp']) ? $lv_fltarr['rptsrcsystyp'] : $vew_data->rptsrcsys; ?>"},
                      {name:"vewfldflt",value: lv_flt["fltstr"]},
                      {name:"vewfldord",value:"<?= $vew_data->vewfldord; ?>"},
                      {name:"vewmaxrec",value: lv_flt["maxrec"]},
                     ];
										 
			$("#<?= $lv_sec; ?> #fltcnt").text( (lv_flt["fltqty"]==0?"":lv_flt["fltqty"]) );
			tmssCallProcessNoBackdropErr("?prg=grlrptdsg&act=getReportData",lv_pstdat,function(data){ 
				var lv_<?= $lv_sec; ?>_dat = data.data;
				var lv_<?= $lv_sec; ?>_def = data.def;
        
      	$("#<?= $lv_sec; ?>_frm #stm").val(data.stm);
      	$("#<?= $lv_sec; ?>_frm #src").val(data.src);
        
        try{ lv_<?= $lv_sec; ?>_dat = JSON.parse(lv_<?= $lv_sec; ?>_dat); } catch (error) { }
        if(lv_<?= $lv_sec; ?>_dat?.errtyp==undefined?"":lv_<?= $lv_sec; ?>_dat.errtyp=="E"){
					toastr.warning(lv_<?= $lv_sec; ?>_dat.errcod+": "+lv_<?= $lv_sec; ?>_dat.errtxt);
        }
        
				if($("#<?= $lv_sec; ?> #divlay div[data-crdtyp=grp]").length>0){
					tmssLoadScript("chart",function(){
						<?= $lv_sec; ?>_showData( lv_<?= $lv_sec; ?>_dat, "grp", lv_<?= $lv_sec; ?>_def );
					});
				}
				if($("#<?= $lv_sec; ?> #divlay div[data-crdtyp=tbl]").length>0){
					tmssLoadScript("table",function(){
						<?= $lv_sec; ?>_showData( lv_<?= $lv_sec; ?>_dat, "tbl", lv_<?= $lv_sec; ?>_def );
					});
				}
			},function(err){
				toastr.warning("Error al procesar la solicitud.<br>"+err);				
			});    
    }
    
    
		// SHOWDATA. procesa cada uno de los graficos/tablas del reporte
		function <?= $lv_sec; ?>_showData( lp_dat, lp_typ, lp_def ){
			// grafico
			if( lp_typ=="grp" ){
				$("#<?= $lv_sec; ?> #divlay div[data-crdtyp=grp]").each(function(){
					const lv_colors =["rgba(255, 99, 132, 0.6)", "rgba(255, 159, 64, 0.6)", "rgba(255, 205, 86, 0.6)", "rgba(75, 192, 192, 0.6)", "rgba(54, 162, 235, 0.6)", "rgba(153, 102, 255, 0.6)", "rgba(201, 203, 207, 0.6)" ];
					const lv_borders=["rgba(255, 99, 132)", "rgba(255, 159, 64)", "rgba(255, 205, 86)", "rgba(75, 192, 192)", "rgba(54, 162, 235)", "rgba(153, 102, 255)", "rgba(201, 203, 207)" ];
					var lv_datcal = $(this).data("grpcal");
					var lv_datfld = $(this).data("grpdatfld");
					var lv_colfld = $(this).data("grpdatcolfld");	
					var lv_rowfld = $(this).data("grpdatrowfld");
					var lv_datasets = [];
					var lv_labels = [];
					var lv_series = [];

					var lv_grptyp;
					switch( $(this).data("grptyp") ){
						case "chart-area": lv_grptyp="line"; break;
						case "chart-bar": lv_grptyp="bar"; break;
						case "chart-column": lv_grptyp="bar"; break;
						case "chart-pie": lv_grptyp="pie"; break;
						case "chart-line": lv_grptyp="line"; break;
					}
					
					// para graficos de torta se prepara una sola serie
					if(lv_grptyp=="pie" ){
						
						// recorro los datos
						for(var i=0;i<lp_dat.length;i++){
							// busco si la leyenda existe
							var z = $.inArray(lp_dat[i][lv_rowfld],lv_labels);
							if(z>=0){
								// sumo 1 unidad por cada elemento
								lv_datasets[0].data[z]+=(lv_datcal=="sum"?Number(lp_dat[i][lv_datfld]):(lv_datcal=="count"?1:1));
							// no existe la serie, la agrego
							} else if(lv_datasets.length==0){
								lv_series.push( "SerieUnica" );
								lv_datasets.push( {labels: lp_dat[i][lv_rowfld], data: [ (lv_datcal=="sum"?Number(lp_dat[i][lv_datfld]):(lv_datcal=="count"?1:1)) ], backgroundColor: [], borderColor: [] } );
								lv_labels.push( lp_dat[i][lv_rowfld] );
							// es un nuevo indice, lo agrego
							} else {
								lv_datasets[0].data.push( (lv_datcal=="sum"?Number(lp_dat[i][lv_datfld]):(lv_datcal=="count"?1:1)) );
								lv_labels.push( lp_dat[i][lv_rowfld] );
							}
						}
						// asigno colores a los elementos de la torta
						for(var i=0; i<lv_datasets.length; i++){
							for(var z=0; z<lv_datasets[i].data.length; z++){
								var lv_color = tmssColorGetRandomMaterialDesign();
								lv_datasets[i].borderColor.push( lv_color );
								lv_datasets[i].backgroundColor.push( tmssHex2Rgba( lv_color , 0.6 ) );
							}
						}
						
					} else {
						
						// recorro los datos
						for(var i=0;i<lp_dat.length;i++){
							// determino/agrego serie si falta
							var z = $.inArray(lp_dat[i][lv_rowfld],lv_series);
							if(z<0){
								//si fila y columna coinciden, solo tengo que usar un dataset
								if(lv_colfld!=lv_rowfld || lv_datasets.length==0){
									lv_datasets.push( {label: (lv_colfld==lv_rowfld?"Serie1":lp_dat[i][lv_rowfld]), data: [], backgroundColor: lv_colors[0]} );
									lv_series.push( lp_dat[i][lv_rowfld] );
									z = $.inArray(lp_dat[i][lv_rowfld],lv_series);
									lv_datasets[z].borderColor = tmssColorGetRandomMaterialDesign();
									lv_datasets[z].backgroundColor = tmssHex2Rgba( lv_datasets[z].borderColor , 0.6 );
									lv_datasets[z].tension = 0.4;
									lv_datasets[z].borderRadius = 5;
									lv_datasets[z].borderWidth = 2;
									// igualo el campo data todo en cero para que todas las series tengan la misma cantidad de elementos
									for(var zy=0;zy<lv_labels.length;zy++){lv_datasets[z].data.push(0);}
								} else {
									z = 0;
								}
							}
							// asigno indice de serie
							if(z>=0){
								// busco a que serie leyenda el dato. si serie y leyenda son iguales siempre se registra en el indice cero
								var y = $.inArray(lp_dat[i][lv_colfld],lv_labels);
								if(y>=0){
									// sumo 1 unidad por cada elemento
									lv_datasets[z].data[y]+= (lv_datcal=="sum"?Number(lp_dat[i][lv_colfld]):(lv_datcal=="count"?1:1));
								} else {
									lv_labels.push( lp_dat[i][lv_colfld] );
									for(var zy=0; zy<lv_datasets.length;zy++){
										var lv_qty = ( zy==z ? (lv_datcal=="sum"?Number(lp_dat[i][lv_colfld]):(lv_datcal=="count"?1:1)) : 0 );
										lv_datasets[zy].data.push( lv_qty );
									}
								}
								
							}
						}
					}
					
					// ajusto parametros para grafico de area
					if($(this).data("grptyp")=="chart-area"){ for(var x=0; x<lv_datasets.length;x++){ lv_datasets[x].fill=true; } }

					const config ={ type: lv_grptyp,
													data: {	labels: lv_labels, datasets: lv_datasets },
													options:{ responsive: true,	maintainAspectRatio: false,
																		plugins:{	legend: { display: false, position: "", },	
																							title: { display: false } }	}	};
					if($(this).data("grplngpos")!=""){ config.options.plugins.legend.display=true; config.options.plugins.legend.position=$(this).data("grplgnpos"); }
					if($(this).data("grptyp")=="chart-bar"){ config.options.indexAxis = "y"; }
          
          // armo estructura con título externo
          var lv_ttl = $(this).data("grpttl") || ""; var lv_ttlshw = $(this).data("grpttlshw"); var lv_buf = "";

          lv_buf += `<div class='tbl-title fw-bold h4 mb-2 text-primary'>${lv_ttl}</div>
										 <div class='chart-container'>
                       <canvas></canvas>
                     </div>`;
          
          // reemplazo contenido
          $(this).html(lv_buf);          
          
					$(this).find("canvas:first").removeClass("hidden");
					var lo_chart = new Chart( $(this).find("canvas:first") , config );
					$(this).find("i:first").addClass("hidden");
				});

			// tabla
			} else if ( lp_typ=="tbl" ){
				var lv_tblcod = 0;
				$("#<?= $lv_sec; ?> #divlay div[data-crdtyp=tbl]").each(function(){
          lv_tblcod++;
					var lv_cols = [];
					var lv_group = [];
					var lv_data = [];
					var lv_datfld = $(this).data("tbldatfld");
					var lv_colfld = $(this).data("tblcolfld");	
					var lv_rowfld = $(this).data("tblrowfld");
          var lv_ttl = decodeURIComponent(escape($(this).data("tblttl")));
          var lv_ttlshw = $(this).data("tblttlshw");
          var lv_buf="";
          // creo un array para guardar los códigos internos y hacer los mapeos más adelante
          var lv_fldcodarr = [];
          
          lv_buf+="<table class='table table-hover table-condensed' data-toggle='table' id='<?= $lv_sec;?>_tbl"+lv_tblcod+"'><thead><tr>";
					for(var i=0; i<lv_rowfld.length;i++){	var lv_fld = lv_rowfld[i].rptsrccolcod; lv_cols.push( lv_fld );	lv_group.push( lv_fld );	}
					for(var i=0; i<lv_colfld.length;i++){	var lv_fld = lv_colfld[i].rptsrccolcod;	lv_cols.push( lv_fld );	}
					for(var i=0; i<lv_datfld.length;i++){	var lv_fld = lv_datfld[i].rptsrccolcod; lv_cols.push( lv_fld );	lv_data.push( lv_fld );	}
        	for(var i=0; i<lv_cols.length;i++){
            var lv_fldtxt = ""; var lv_flddef = ""; var lv_fldcod = "";
            for(var x=0; x<lp_def.length;x++){
							if(lp_def[x]["rptsrccolcod"]==lv_cols[i]){
                lv_fldcod=(lp_def[x]["rptsrccolcodint"]??"")!="" ? lp_def[x]["rptsrccolcodint"] : lp_def[x]["rptsrccolcodext"];
								lv_fldtxt=lp_def[x]["rptsrccoltxt"];
								lv_flddef=lp_def[x]["sysfldinptyp"];
                lv_fldcodarr.push({ rptsrccolcod: lp_def[x]["rptsrccolcod"], fldcod: lv_fldcod });
								break;
							}
						}
						lv_buf+="<th data-field='"+lv_cols[i]+"' data-align='"+(lv_flddef=="NUMBER"?"right":"left")+"' data-sortable='true' "+(lv_flddef=="DATE"?"data-sorter='<?= $lv_sec; ?>_tableSortDate'":(lv_flddef=="NUMBER"?"data-sorter='<?= $lv_sec; ?>_tableSortNumber'":""))+">"+lv_fldtxt+"</th>";
          }
					lv_buf+="</tr></thead><tbody>";

					// asigno datos a tabla
					if(lp_dat!=null && typeof lp_dat=="object"){
            var lp_dat2 = [];
						// tabla con campos calculados, se debe procesar primero antes de mostrarla
						// mapeo el ID de la columna con su respectivo código interno/externo
            const lv_fldmap = {};
            for (let i = 0; i < lv_fldcodarr.length; i++) { lv_fldmap[lv_fldcodarr[i].rptsrccolcod] = lv_fldcodarr[i].fldcod; }
            if (lv_datfld.length > 0 && lv_rowfld.length > 0 && lv_colfld.length === 0) {
              const lv_dat2 = []; const lv_groups = {}; // hashmap para agrupar

              for (let i = 0; i < lp_dat.length; i++) {
                const lo_row = lp_dat[i];

                // Construir clave de agrupación
                
                const lv_key = lv_rowfld.map(f => { 
                	const fldcod = lv_fldmap[f.rptsrccolcod]; return fldcod !== undefined && lo_row[fldcod] !== undefined ? String(lo_row[fldcod]) : '';
                }).join('\u0009');

                // Crear grupo si no existe
                if (!lv_groups[lv_key]) {
                  // Clonar registro base (NO mutar original)
                  const lo_new = Object.assign({}, lo_row);

                  // Copiar SOLO campos de agrupamiento
                  for (let r = 0; r < lv_rowfld.length; r++) {
                    const lv_fldcod = lv_fldmap[lv_rowfld[r].rptsrccolcod];
                    if (lv_fldcod) lo_new[lv_fldcod] = lo_row[lv_fldcod];
                  }

                  // Inicializar campos agregados
                  for (let x = 0; x < lv_datfld.length; x++) {
                    const lv_fld = lv_datfld[x];
                    const lv_fldcod = lv_fldmap[lv_fld.rptsrccolcod];
                    if (!lv_fldcod) continue;
                    const lv_cur = Number(lo_row[lv_fldcod]) || 0;

                    switch (lv_fld.fldcal) {
                      case 'cnt':
                        lo_new[lv_fldcod] = 1;
                        break;

                      case 'sum':
                      case 'min':
                      case 'max':
                        lo_new[lv_fldcod] = lv_cur;
                        break;

                      case 'avg':
                        lo_new[lv_fldcod] = lv_cur;
                        lo_new[`__sum_${lv_fldcod}`] = lv_cur;
                        lo_new[`__cnt_${lv_fldcod}`] = 1;
                        break;
                    }
                  }
                  
                  lv_groups[lv_key] = lo_new;
                  lv_dat2.push(lo_new);
                  continue;
                }

                // Actualizar grupo existente
                const lo_grp = lv_groups[lv_key];

                for (let x = 0; x < lv_datfld.length; x++) {
                  const lv_fld = lv_datfld[x];
                  const lv_fldcod = lv_fldmap[lv_fld.rptsrccolcod];
                  if (!lv_fldcod) continue;
                  const lv_cur = Number(lo_row[lv_fldcod]) || 0;
                  switch (lv_fld.fldcal) {
                    case 'cnt':
                      lo_grp[lv_fldcod]++;
                      break;

                    case 'sum':
                      lo_grp[lv_fldcod] += lv_cur;
                      break;

                    case 'min':
                      lo_grp[lv_fldcod] = Math.min(lo_grp[lv_fldcod], lv_cur);
                      break;

                    case 'max':
                      lo_grp[lv_fldcod] = Math.max(lo_grp[lv_fldcod], lv_cur);
                      break;

                    case 'avg':
                      lo_grp[`__sum_${lv_fldcod}`] += lv_cur;
                      lo_grp[`__cnt_${lv_fldcod}`]++;
                      lo_grp[lv_fldcod] =
                        lo_grp[`__sum_${lv_fldcod}`] / lo_grp[`__cnt_${lv_fldcod}`];
                      break;
                  }
                }
              }

              // Limpieza de auxiliares AVG
              for (let i = 0; i < lv_dat2.length; i++) {
                for (let x = 0; x < lv_datfld.length; x++) {
                  if (lv_datfld[x].fldcal === 'avg') {
                    const lv_fldcod = lv_fldmap[lv_datfld[x].rptsrccolcod];
                    if (!lv_fldcod) continue;
                    delete lv_dat2[i][`__sum_${lv_fldcod}`];
                    delete lv_dat2[i][`__cnt_${lv_fldcod}`];
                  }
                }
              }
              
              lp_dat2 = lv_dat2;

            } else {
              lp_dat2 = lp_dat;
            }
						
						// completo la tabla con los datos
						var lv_val;
						for(var i=0; i<lp_dat2.length; i++){
							lv_buf+="<tr>";
							for(var z=0; z<lv_fldcodarr.length; z++){
								lv_val = lp_dat2[i][ lv_fldcodarr[z]["fldcod"] ];
								if(lv_val!=null && typeof lv_val=="object"){
									lv_buf+="<td>"+moment(lv_val.date).format("DD/MM/YYYY")+"</td>";
								} else {
									lv_buf+="<td>"+(lv_val==null?"":lv_val)+"</td>";
								}
							}
							lv_buf+="</tr>";
						}
					}
					lv_buf+="</tbody></table>";
          // agrego el título si corresponde
          if (lv_ttlshw === true || lv_ttlshw === "true" || lv_ttlshw === 1) { lv_buf = "<div class='tbl-title fw-bold h4 mb-2 text-primary'>"+lv_ttl+"</div>"+lv_buf; }
          
          // agrego footer con la cantidad de registros
          var lv_tblcnt = Object.keys(lp_dat).length;
          // obtengo el valor de VewMaxRec desde el PopUp de filtros
          var lv_maxrec = parseInt($("#<?= $lv_sec; ?> #vewmaxrec").val());
          if (lv_tblcnt > lv_maxrec && lv_maxrec > 0) {
            var lv_fndreg = `
              <span class='pagination-info'>
                Se encontraron m&aacute;s de <span class='badge'>${lv_maxrec}</span> registros.
                Utilice el filtro para reducir el listado.
              </span>
            `;
          } else {
            var lv_fndreg = `
              <span class='pagination-info'>
                Registros encontrados <span class='badge'>${lv_tblcnt}</span>
              </span>
            `;
          }
          // agrego el contador de registros a la estructura de la tabla
          lv_buf += lv_fndreg;
					
					$(this).html( lv_buf );
					var lv_tbl = $(this).find("table:first");
					$(lv_tbl).bootstrapTable({});
					
					// si solo hay una tabla en la vista, actualizo el alto
					if( $("#<?= $lv_sec; ?> #divlay div.row").length==1 && $("#<?= $lv_sec; ?> #divlay div[name='rptdat']").length==1){
						lv_tbl.bootstrapTable("resetView", {height: 400});
					} else {
						lv_tbl.bootstrapTable("resetView", {height: 250});
					}
					
				});
				
			}
		}
    
    // DOWNLOAD MENU. abre un PopUp con todas las tablas para descargar
    $("#<?= $lv_sec; ?> #dwntbl").on("click",function(e){
      var lv_dwnmsg = "<?php
												$lv_buffer = '';
												// descarga de tablas
												$lv_buffer_itm = '';
          							if (isset($lv_rptatr['rows'])){
                          $lv_idx = 1;
  												foreach($lv_rptatr['rows'] as $lv_row){
                          	foreach($lv_row as $lv_col){
                              if($lv_col['crdtyp']=='tbl'){
                                $lv_tblttl = $lv_col['tblttl'] ? $lv_col['tblttl'] : 'Reporte ' . $lv_idx;
                                if (empty($lv_tblttl)) { $lv_tblttl = 'Reporte ' . $lv_idx; }
                                $lv_buffer_itm .= "<a href='#' class='list-group-item' data-tableindex='".$lv_idx."'><h4 class='list-group-item-heading'>".$lv_tblttl."</h4><p class='list-group-item-text'>Descargar el reporte '".$lv_tblttl."'</p></a>";
                                $lv_idx++;
                              }
                            }
                          }
												}
												if( $lv_buffer_itm!='' ){ $lv_buffer = "<h4>".$vew_lang->tables."</h4><div class='list-group' id='dwnelm_tbl'>".$lv_buffer_itm."</div>"; }
												
												// mensajes del reporte
												if(count($vew_data->rptmsgcls)>0){
													$lv_buffer .= "<h4>".$vew_lang->messages."</h4><div class='list-group' id='dwnelm_msg'>";
                          // recorremos todas las clases de mensaje
                          foreach( $vew_data->rptmsgcls as $lo_msg ) {
                            $lo_msglog = [];
                            // buscamos si existen mensajes emitidos para la clase de mensaje
                            $lv_msglog = '';             
                            $lo_msg['msgnum'] = '';
                            $lv_c = 0;
                            
                            // POR AHORA NO HAY DOCMSG CONFIGURADO INTERNAMENTE. SE DEBERIA AGREGAR AL CALL_SP
                            /*foreach( $vew_data->docmsg as $lo_docmsg ) {
                              if ( $lo_docmsg['sysdocmsgcod']==$lo_msg['sysdocmsgcod'] ) {
                                if (isset($lo_docmsg['msglog'])) {
                                  $lv_msglog = '';
                                  $lv_msglog = $lo_docmsg['msglog'];
                                } else {
                                  $lv_msglog = '';
                                }
                                $lo_msg['msgnum'] = isset($lo_docmsg['msgnum']) ? $lo_docmsg['msgnum'] : '';
                                break;
                              }
                            }
                            // si hay log de ejecución, se arma tabla de logs
                            if( $lv_msglog!='' ){
                              $lo_msglog = json_decode( $lv_msglog, true );
                              $lv_tbllog = '<div><b>Copias: '.count($lo_msglog).'</b></div><table class="table table-bordered table-condensed"><thead><tr><td>'.$vew_lang->created.'</td><td>'.$vew_lang->createdby.'</td></tr></thead><tbody>';
                              foreach($lo_msglog as $lv_rowlog){ $lv_tbllog .= '<tr><td>'.$lv_rowlog['logctedte'].'</td><td>'.$lv_rowlog['logcteusr'].'</td></tr>'; }
                              $lv_tbllog .= '</tbody></table>';
                            }*/

                            // se arma la fila con la clase de mensaje
                            $lv_msgtyp = $vew_doc->getTagValue($lo_msg['sysdocmsgatr'],'msgtyp');
                            $lv_msgfrm = $vew_doc->getTagValue($lo_msg['sysdocmsgatr'],'msgfrm');
                            $lv_msgfrm = str_ireplace('[srcobjtyp]',$vew_data->srcobjtyp,$lv_msgfrm);
                            $lv_msgfrm = str_ireplace('[srcobjcod]',$vew_data->srcobjcod,$lv_msgfrm);
                            $lv_msgfrm = str_ireplace('[srcobjcod002]',$vew_data->srcobjcod002,$lv_msgfrm);
                            $lv_buffer.= 	"<a href='#' class='list-group-item' value=1 data-msgnum='".$lo_msg['msgnum']."' data-sysdocmsgcod='".$lo_msg['sysdocmsgcod']."' data-msgfrm='".$lv_msgfrm."' data-msgtyp='".$lv_msgtyp."' style='cursor:pointer;' data-sysdocmsgcodext='".($lo_msg['sysdocmsgcodext']??'')."'>".
                            								"<h4 class='list-group-item-heading'>".$lo_msg['sysdocmsgtxt']."</h4>".
                              						"</a>";
                                          //'<td class="text-center">'.($lv_msgtyp=='pdf'?'<input type="checkbox" data-filename="'.$lo_msg['sysdocmsgtxt'].'_'.$vew_data->srcobjcod.'.pdf" class="hidden">':'').'</td>'.
                                          //'<td name="message"><i class="'.($lv_msgtyp=='pdf'?'far fa-file-pdf':($lv_msgtyp=='scr'?'far fa-code':($lv_msgtyp=='ajx'?'far fa-sync':'far fa-triangle-exclamation text-danger'))).'" style="padding-right:5px;"></i> <a href="#">''</a></td>'.
                                          //'<td><a href="#" class="'.(count($lo_msglog)>0?'':($lv_msglog!=''?'':'invisible')).' card-icon" data-sysdocmsgcod="'.$lo_msg['sysdocmsgcod'].'" name="lnklog"><i class="far fa-circle-info"></i></a><a href="#" class="'.($lv_msgtyp=='pdf'?'':'invisible').' card-icon btndwn"><i class="far fa-download"></i></a></td>'.
                                          
                            // si hay tabla de logs se agrega como una fila a la tabla
                            /*if($lv_msglog!=''){
                              echo '<tr data-sysdocmsgcod_log="'.$lo_msg['sysdocmsgcod'].'" class="hidden"><td colspan=10>'.$lv_tbllog.'</td></tr>';
                            }*/
                          }
													/*foreach($vew_data->rptmsgcls as $lv_row){
														$lv_buffer .= "<a href='#' class='list-group-item' value=1><h4 class='list-group-item-heading'>".$lv_row['sysdocmsgtxt']."</h4></a>";
														//["sysdocmsgatr"]=>"<msgtyp>pdf</msgtyp>
														//											<msgfrmcnd></msgfrmcnd>
														//											<msgfrm>?prg=zcutp1&act=lqdbbvatxt</msgfrm>
														//											<icn>?prg=zcutp1&act=lqdbbvatxt</icn>"
													}*/
													$lv_buffer .= "</div>";
												}
												echo $lv_buffer;
												?>";
      
			
			
      BootstrapDialog.show({
        title: "<?= $vew_lang->download; ?>",
        message: $(lv_dwnmsg),
        type: BootstrapDialog.TYPE_PRIMARY,
        onshown: function(dialog){
          dialog.$modalBody.find("#dwnelm_tbl .list-group-item").click(function(){
            let lv_tblnme = $(this).children('h4').html();
						let lv_val = $(this).data("tableindex");
						if(lv_val>=1 && lv_val<=3 ){ <?= $lv_sec; ?>_exportTable(lv_val, lv_tblnme); }
            dialog.close();
          });
          dialog.$modalBody.find("#dwnelm_msg .list-group-item").click(function(){
            var lv_flt = tmssFilterParseToInternal( gv_<?= $lv_sec; ?>_flt );
            // prepara datos post
            var lv_pstdat =[{name:"msgnum", value: $(this).data("msgnum")},
                            {name:"sysdocmsgcod", value: $(this).data("sysdocmsgcod")},
                            {name:"msgfrm", value: $(this).data("msgfrm")},
                            {name:"msgtyp", value: $(this).data("msgtyp")},
                            {name:"msgqty", value: 1},
                            {name:"docsts", value: "A"},
                          	{name:"vewfldflt",value:  (lv_flt["fltstr"])},
                   	 				{name:"vewfldord",value: "<?= $vew_data->vewfldord; ?>"},
                    				{name:"vewmaxrec",value: lv_flt["maxrec"]}];
            <?= $lv_sec; ?>_downloadMessage( lv_pstdat );
            //$("#<?= $lv_sec; ?> #btnmsg").click();
						//lv_val = $(this).prop("value");
						//if(lv_val>=1 && lv_val<=3 ){ <?= $lv_sec; ?>_exportTable(lv_val); }
            dialog.close();
          });
        }
      });
    });
    
    
    // EXPORT TABLE. dado un ID, exporta en excel la tabla asociada
    function <?= $lv_sec; ?>_exportTable( lp_id, lp_tblnme ){
      var lv_table = $("#<?= $lv_sec; ?>_tbl"+lp_id);
			$(lv_table).table2excel({
					exclude: ".noExl",
					name: "<?=$lv_rptttl;?>",
					filename: lp_tblnme,//'<?=$lv_rptttl;?>_' + new Date().toISOString().replace(/[\-\:\.]/g, ""),
					fileext: ".xls",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
		}
		
		function <?= $lv_sec; ?>_tableSortNumber(fieldA, fieldB, rowA, rowB){
			return (parseFloat(fieldA.replace(",","")) < parseFloat(fieldB.replace(",","")) ? -1 : 1);
		}
		function <?= $lv_sec; ?>_tableSortDate(fieldA, fieldB, rowA, rowB){
			var fieldAParts = fieldA.split("/");
			var dateA = new Date(+fieldAParts[2], fieldAParts[1] - 1, +fieldAParts[0]);
			var fieldBParts = fieldB.split("/");
			var dateB = new Date(+fieldBParts[2], fieldBParts[1] - 1, +fieldBParts[0]);
			return (dateA < dateB ? -1 : 1);
		}
	</script>
  <script>
    function <?= $lv_sec; ?>_downloadMessage( lp_pstdat ){  
      tmssCallProcessBlob("?prg=grldatmsg&act=07",lp_pstdat, function(data, lp_responseHeaders){
   				if(data.type=="application/json" || data.type=="text/html"){
					data.text().then(function(result) {
						var lv_err = JSON.parse(result);
						toastr.warning("No se puede descargar el archivo.<br>"+lv_err.errcod+": "+lv_err.errtxt);
					});
          return false;
				}
        var lv_msgtyp = "";
        for(var i=0; i<lp_pstdat.length; i++){ if(lp_pstdat[i].name=="msgtyp"){ lv_msgtyp=lp_pstdat[i].value; } }
        if( lv_msgtyp=="pdf" ){
          var url = window.URL.createObjectURL(data);
          const link = document.createElement("a");
          link.href = url;
          link.download = "<?= $lv_rptttl != "" ? $lv_rptttl : $vew_data->rpttxt; ?>"
          if (lp_responseHeaders && lp_responseHeaders['content-disposition']) {
            const lv_contentDisposition = lp_responseHeaders['content-disposition'];
            const lv_filenameMatch = lv_contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/);
            if (lv_filenameMatch && lv_filenameMatch[1]) {
              let lv_encodedFilename = lv_filenameMatch[1].replace(/['"]/g, '');
              try{
                link.download = decodeURIComponent(lv_encodedFilename);
              } catch (e) {
                link.download = lv_encodedFilename;
              }
            }
          }
          // this is necessary as link.click() does not work on the latest firefox
          link.dispatchEvent( new MouseEvent("click", { bubbles: true, cancelable: true, view: window }) );
          // For Firefox it is necessary to delay revoking the ObjectURL
          setTimeout(() => { window.URL.revokeObjectURL(url); link.remove(); }, 100);
          return true;
        } else if( lv_msgtyp=="scr" ){
          eval( data.msg );
          return true;
        } else if( lv_msgtyp=="ajx" ){
          $.ajax({ type: "POST", url: data.msg });
          return true;
        } else {
          toastr.warning("No se reconoce el tipo de mensaje ["+lv_msgtyp+"].");
          return false;
        }
      });
    }
    
    // ENVIAR MENSAJE
    function <?= $lv_sec; ?>_sendMessage( lp_pstdat, lp_download ){      
      // datos adicionales
      var lv_msgdat = ''; 
      if(typeof <?= $lv_sec; ?>_getMessageData === "function"){
        lv_msgdat = <?= $lv_sec; ?>_getMessageData(lp_pstdat);
      }
      lp_pstdat.push({name:"msgdat",value:lv_msgdat});
			// imprimir/ejecutar. ejecuta el mensaje
      tmssCallProcessBlob("?prg=grldatmsg&act=07", lp_pstdat, function(data, lp_responseHeaders){
				if(data.type=="application/json" || data.type=="text/html"){
					data.text().then(function(result) {
						var lv_err = JSON.parse(result);
						toastr.warning("No se puede descargar el archivo.<br>"+lv_err.errcod+": "+lv_err.errtxt);
					});
          return false;
				}
        var lv_msgtyp = "";
        for(var i=0; i<lp_pstdat.length; i++){ if(lp_pstdat[i].name=="msgtyp"){ lv_msgtyp=lp_pstdat[i].value; } }
        if( lv_msgtyp=="pdf" ){
          // Crear una URL para el Blob y lo abre en una nueva pestaña
          var url = window.URL.createObjectURL(data);
          if( !lp_download ){
            window.open(url, "_blank");
            return true;
          } else {
            const link = document.createElement("a");
            link.href = url;
            if (lp_responseHeaders && lp_responseHeaders['content-disposition']) {
              const lv_contentDisposition = lp_responseHeaders['content-disposition'];
              const lv_filenameMatch = lv_contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/);
              if (lv_filenameMatch && lv_filenameMatch[1]) {
                let lv_encodedFilename = lv_filenameMatch[1].replace(/['"]/g, '');
                try{
                  link.download = decodeURIComponent(lv_encodedFilename);
                } catch (e) {
                  link.download = lv_encodedFilename;
                }
              }
            }
            // this is necessary as link.click() does not work on the latest firefox
            link.dispatchEvent( new MouseEvent("click", { bubbles: true, cancelable: true, view: window }) );
            // For Firefox it is necessary to delay revoking the ObjectURL
            setTimeout(() => { window.URL.revokeObjectURL(url); link.remove(); }, 100);
            return true;
          }
        } else if( lv_msgtyp=="scr" ){
          eval( data.msg );
          return true;
        } else if( lv_msgtyp=="ajx" ){
          $.ajax({ type: "POST", url: data.msg });
          return true;
        } else {
          toastr.warning("No se reconoce el tipo de mensaje ["+lv_msgtyp+"].");
          return false;
        }
      }, {desiredHeaders: ["content-disposition"] });
    }

    // MENSAJE. ejecuta mensaje
    $("#<?= $lv_sec; ?> table tbody tr td[name=message]").on("click",function(e){ e.preventDefault();
			var lv_tr = $(this).parent(); // esto se hace para que el callback pueda acceder a la fila actual
			// prepara datos post
      var lv_pstdat =[{name:"sysdocclscod", value: "<?= $vew_data->sysdocclscod; ?>"},
                      {name:"srcobjtyp", value: "<?= $vew_data->srcobjtyp; ?>"},
                      {name:"srcobjcod", value: "<?= $vew_data->srcobjcod; ?>"},
                      {name:"srcobjcod002", value: "<?= $vew_data->srcobjcod002; ?>"},
                      {name:"msgnum", value: $(lv_tr).data("msgnum")},
                      {name:"sysdocmsgcod", value: $(lv_tr).data("sysdocmsgcod")},
                      {name:"msgfrm", value: $(lv_tr).data("msgfrm")},
                      {name:"msgtyp", value: $(lv_tr).data("msgtyp")},
                      {name:"msgqty", value: 1},
                      {name:"docsts", value: "A"}];
      <?= $lv_sec; ?>_sendMessage( lv_pstdat );
      $('.close').click();
    	$("#<?= $lv_sec; ?> #btnmsg").click();
		});
  </script>
</section>