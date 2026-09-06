<?php
	// url del formulario 
  $lv_lnk = '?prg=hltpln&prm_plnvew='.$vew_data->plnvew;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->planning;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLP';

	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	$vew_actcod = '02';

/*
Descripción: Cálculo de la distancia entre 2 puntos en función de su latitud/longitud
Autor: Rajesh Singh (2014)
Sito web: AssemblySys.com
*/
function distanceCalculation($point1_lat, $point1_long, $point2_lat, $point2_long, $unit = 'km', $decimals = 2) {
	// Cálculo de la distancia en grados
	$degrees = rad2deg(acos((sin(deg2rad($point1_lat))*sin(deg2rad($point2_lat))) + (cos(deg2rad($point1_lat))*cos(deg2rad($point2_lat))*cos(deg2rad($point1_long-$point2_long)))));
 
	// Conversión de la distancia en grados a la unidad escogida (kilometros, millas o millas naúticas)
	switch($unit) {
		case 'km':
			$distance = $degrees * 111.13384; // 1 grado = 111.13384 km, basándose en el diametro promedio de la Tierra (12.735 km) ==> 12742 => 12756
			break;
		case 'mi':
			$distance = $degrees * 69.05482; // 1 grado = 69.05482 millas, basándose en el diametro promedio de la Tierra (7.913,1 millas)
			break;
		case 'nmi':
			$distance =  $degrees * 59.97662; // 1 grado = 59.97662 millas naúticas, basándose en el diametro promedio de la Tierra (6,876.3 millas naúticas)
	}
	return round($distance, $decimals);
}	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<nav class="navbar navbar-default tmss-navbar">
		<div class="container-fluid">
			<ul class="navbar-right btn-toolbar tmss-navbar-right">
				<?php if ($vew_actcod!='01') { ?>
					<!-- Filtro -->
					<a role="button" data-toggle="collapse" href="#<?= $lv_sec; ?>_pnlflt" class="btn tmss-navbar-btn navbar-btn" id="pnltxtlbl" title="<?= $vew_lang->filter; ?>"><span class="fas fa-filter"></span></a>	
					<!--Dropdown-->
					<div class="btn-group dropdown">
						<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
						<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
							<!--Actualizar-->
							<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
							<!-- Imprimir -->
							<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
							<!--Ayuda-->
							<?php include('sysappprghlpbtn.frm'); ?> 							
						</form>
					</div>
				<?php } ?>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn tmss-navbar-btn navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<div class="container-fluid">
			<br>
			<div id="<?= $lv_sec; ?>_pnlflt" class="panel-collapse collapse in" role="tabpanel">
				<input type="hidden" id="spccod" name="spccod" value="<?= $vew_data->spccod; ?>">
				<input type="hidden" id="patcod" name="patcod" value="<?= $vew_data->patcod; ?>">
				<input type="hidden" id="prscod" name="prscod" value="<?= $vew_data->prscod; ?>">
				<input type="hidden" id="hltdisclscod" name="hltdisclscod" value="<?= $vew_data->hltdisclscod; ?>">
				<?php
					echo vew_boot($lv_col210, array("label"=>$vew_lang->specialty,
																	"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly),
																											array("input"=>gethtml("spctxt", "doccmt1x50", $vew_data->spctxt,$lv_default) )) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->patient,
																	"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly),
																											array("input"=>gethtml("pattxt", "doccmt1x50", $vew_data->pattxt,$lv_default) )) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->provider,
																	"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly),
																											array("input"=>gethtml("prstxt", "doccmt1x50", $vew_data->prstxt,$lv_default) )) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->diseaseclassification,
																	"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly),
																											array("input"=>gethtml("hltdisclstxt", "doccmt1x50", $vew_data->hltdisclstxt,$lv_default) )) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->medic, "input1"=>gethtml("medtxt", "doccmt1x50", $vew_data->medtxt, $lv_default) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->address, "input1"=>gethtml("adrtxt", "doccmt1x50", $vew_data->adrtxt, $lv_default) ));
				?>
				</div>
					
			<div class="row">	
				<div class="container-fluid" role="tabpanel">
					<ul class="nav nav-pills" role="tablist">
						<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><span class="far fa-map"></span> <?= $vew_lang->map; ?></a></li>
					<!-- 	<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><span class="fas fa-address-book"></span> <?= $vew_lang->providers; ?></a></li>
						<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><span class="fas fa-address-book-o"></span> <?= $vew_lang->patients; ?></a></li>  -->
					</ul>
					<div class="tab-content tmss-tab-content">

						<!-- MAPA -->
						<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
							<div id="<?= $lv_sec; ?>_mapCanvas" style="width: 100%; height: 400px;"></div>
						</div>

						<!-- PRESTADORES -->
						<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
							<?php
								$lo_vew = $vew_load->controller('grlvew');
								$lv_prm = array();
								$lv_prm['plnvew'] = 'plnmap';
								$lv_prm['controller'] = 'hltpln';
								
								$lv_prm['vewcod'] = 'VEW_HLT_PRS_MAP';
								$lv_prm['vewfldflt'] = '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
								$lv_prm['model'] = 'hltpln';
								$lv_prm['srcmtd'] = 'getProvidersSpecialtyList';
								
								$lv_prm['view']  = 'hltprs';
								$lv_prm['mdlcod'] = 'hlt';
								$lv_prm['prgcod'] = 'prs';
								$lv_prm['actcod'] = '08';
								$lv_prm['toolbar.close'] = false;
								$lv_prm['toolbar.options.print'] = false;
								echo $lo_vew->index( '00', $lv_prm ); 
							?> 
						</div> 

						<!-- PACIENTES -->
						<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
							<?php
								$lo_vew = $vew_load->controller('grlvew');
								$lv_prm = array();
								$lv_prm['plnvew'] = 'plnmap';
								$lv_prm['vewcod'] = 'VEW_HLT_PAT_MAP';
								$lv_prm['vewfldflt'] = '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
								$lv_prm['model'] = 'hltpln';
								$lv_prm['srcmtd'] = 'getPatientsList';
								$lv_prm['view']  = 'hltpat';
								$lv_prm['mdlcod'] = 'hlt';
								$lv_prm['prgcod'] = 'pat';
								$lv_prm['actcod'] = '03';
								$lv_prm['toolbar.close'] = false;
								$lv_prm['toolbar.options.print'] = false;
								echo $lo_vew->index( '00', $lv_prm );
							?>
						</div>

					</div>
				</div>	
			</div>
		</div> <!-- /container-fluid -->

	</form>
	<script type="text/javascript">
		var lo_map;
		var lo_geocoder;
		var prev_infowindow;
		function <?= $lv_sec; ?>_mapInit() {
			var lo_mapOptions = {
				center: new google.maps.LatLng(-34.6117093, -58.3787434),
				zoom: 10,
				mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			lo_map = new google.maps.Map( document.getElementById("<?= $lv_sec; ?>_mapCanvas"), lo_mapOptions );
			lo_geocoder = new google.maps.Geocoder();
			<?php
				foreach( $vew_hltpat as $lv_row ) {
					$lv_lat = explode(',' , $lv_row['adrmapgeo'])[0];
					$lv_lng = explode(',' , $lv_row['adrmapgeo'])[1];
					$lv_info = '<div style='.chr(39).'width: 200px;'.chr(39).'><strong>'.$lv_row['pattxt'].'</strong><br>'.$lv_row['adrstr'].', '.$lv_row['adrcty'].'<br>'.$lv_row['lndregtxt'].', '.$lv_row['lndtxt'].'<br>'.($lv_row['adrphn001']!=''?'<br>Tel: '.$lv_row['adrphn001']:'').($lv_row['adrphn002']!=''?'<br>Tel: '.$lv_row['adrphn002']:'').($lv_row['adrmblphn']!=''?'<br>Cel: '.$lv_row['adrmblphn']:'').'</div>';
					echo 'mapGeoToMaker( lo_map, lo_geocoder, '.$lv_lat.','.$lv_lng.',"","'.$lv_info.'","");';
				}				
				foreach( $vew_hltprs as $lv_row ) {
					$lv_lat = explode(',' , $lv_row['adrmapgeo'])[0];
					$lv_lng = explode(',' , $lv_row['adrmapgeo'])[1];
					$lv_info = '<div style='.chr(39).'width: 200px;'.chr(39).'><strong>'.$lv_row['prstxt'].'</strong><br>'.$lv_row['adrstr'].', '.$lv_row['adrcty'].'<br>'.$lv_row['lndregtxt'].', '.$lv_row['lndtxt'].'<br>'.($lv_row['adrphn001']!=''?'<br>Tel: '.$lv_row['adrphn001']:'').($lv_row['adrphn002']!=''?'<br>Tel: '.$lv_row['adrphn002']:'').($lv_row['adrmblphn']!=''?'<br>Cel: '.$lv_row['adrmblphn']:'').'</div>';
					$lv_icon = '{path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW, scale: 6, fillColor: "'.(isset($lv_row['spcclr'])?$lv_row['spcclr']:'#FFFFFF').'", fillOpacity: 1, strokeColor: "'.(isset($lv_row['spcclr'])?$lv_row['spcclr']:'#FFFFFF').'", strokeWeight: 1}';
					echo 'mapGeoToMaker( lo_map, lo_geocoder, '.$lv_lat.','.$lv_lng.','.$lv_icon.',"'.$lv_info.'","");';
				}
				if ( $vew_data->adrtxt!='' ) { 
					echo 'mapAddressToMaker(lo_map, lo_geocoder, "' . str_ireplace(chr(39),' ',$vew_data->adrtxt) . '");';
				} 
			?>
		}
		initGoogleMaps( "<?= $lv_sec; ?>_mapInit" );
		if ($(window).width() <= 991){ $("#<?= $lv_sec; ?>_pnlflt").removeClass("in"); }
		
		// mapGeoToMaker
		// convierte una direcci�n (lat,lng) en un marcador en el mapa
		function mapGeoToMaker( lp_map, lp_geocoder, lp_lat, lp_lng, lp_icon, lp_info, lp_color) {
			var lv_infoWindow;
			var lo_maker;
			var lv_pos = new google.maps.LatLng( lp_lat, lp_lng );
			if ( lp_info!="" ) {
				lv_infoWindow = new google.maps.InfoWindow({ content: lp_info });
				if ( lp_icon=="" ) {
					lo_marker = new google.maps.Marker({ position: lv_pos, map: lp_map, infowindow: lv_infoWindow });
				} else {
					//lo_marker = new google.maps.Marker({ position: lv_pos, map: lp_map, infowindow: lv_infoWindow, icon: {path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW, scale: 6, fillColor: lp_color, fillOpacity: 1, strokeColor: "#000000", strokeWeight: 1} });
			  //--lo_marker = new google.maps.Marker({ position: lv_pos, map: lp_map, infowindow: lv_infoWindow, icon: {path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW, scale: 6, fillOpacity: 1, strokeColor: "#000000", strokeWeight: 1} });
					  lo_marker = new google.maps.Marker({ position: lv_pos, map: lp_map, infowindow: lv_infoWindow, icon: lp_icon });
				}        
				lo_marker.setMap(lp_map);
			} else {
				lo_marker = new google.maps.Marker({ position: lv_pos, map: lp_map });
			}
			google.maps.event.addListener(lo_marker, "click", function() {
				if( prev_infowindow ) {
					prev_infowindow.close();
				}
				prev_infowindow = this.infowindow;
				this.infowindow.open(lp_map, this);
			});
		}
	</script>
	<script type="text/javascript">				
		// pattxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #pattxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #patcod").prop("value", data.data.patcod); },
				ajax: {
					url: "index.php?prg=hltpat&act=18",
					displayField: "pattxt",
					valueField: "pattxt",
					timeout: 500, triggerLength: 1, method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_pattxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Pacientes","?prg=hltpat&prm_vewcod=VEW_HLT_PAT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[p.docsts:A]&prm_fldasg=[patcod:patcod],[pattxt:pattxt]");
				evt.preventDefault();
			});
		});
		
		// prstxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #prstxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #prscod").prop("value", data.data.prscod); },
				ajax: {
					url: "?prg=hltprs&act=18",
					displayField: "prstxt",
					valueField: "prstxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_prstxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Prestadores","?prg=hltprs&prm_vewcod=VEW_HLT_PRS_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[p.docsts:A]&prm_fldasg=[prscod:prscod],[prstxt:prstxt]");
				evt.preventDefault();
			});
		});
		
		// spctxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #spctxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #spccod").prop("value", data.data.spccod); },
				ajax: {
					url: "?prg=hltspc&act=18",
					displayField: "spctxt",
					valueField: "spctxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_spctxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Especialidades","?prg=hltspc&prm_vewcod=VEW_HLT_SPC_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[docsts:A]&prm_fldasg=[spccod:spccod],[spctxt:spctxt]");
				evt.preventDefault();
			});
		});
		
    // hltdisclstxt
    tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #hltdisclstxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #hltdisclscod").prop("value", data.data.hltdisclscod); },
				ajax: {
					url: "?prg=hltdiscls&act=18",
					displayField: "hltdisclstxt",
					valueField: "hltdisclstxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_hltdisclstxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Clasif. Enfermedades","?prg=hltdiscls&act=08&prm_vewcod=VEW_HLT_DIS_CLS_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[docsts:A]&prm_fldasg=[hltdisclscod:hltdisclscod],[hltdisclstxt:hltdisclstxt]");
				evt.preventDefault();
			});
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':($vew_actcod=='01'?'01':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>