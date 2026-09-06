<?php
	// url del formulario
  $lv_lnk = '?prg=hhremp&act=dshemp';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = ''; 

	// titulo
	$lv_title = $vew_lang->employee;
	
	// modulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'DSE';

	// libreria de estilos bootstrap
	include_once('_library.frm');	

	$vew_tbl['rfrsh'] = array('per'=>true,'pos'=>'D','ttl'=>$vew_lang->refresh,'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_refresh();');
	
	$vew_tbl_brand = ($vew_data->hhremptxt??'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
		<style>
      /* hago que la columna de la derecha se extienda según el alto total del contenido */
      #<?= $lv_sec; ?> .container-fluid > .row {
        display: flex;
        align-items: stretch; /* hace que las columnas tengan la misma altura */
      }

      #<?= $lv_sec; ?> .col-md-3.navbar-default {
        min-height: 100vh;        /* ocupa toda la pantalla inicialmente */
        height: auto;             /* pero crece si el contenido lo supera */
        display: flex;
        flex-direction: column;
      }
      
      /* ajusto las cards de la columna izquierda para que no se vea el overflow */
      #<?= $lv_sec; ?> .card {
        overflow: hidden;
      }
      
			a.navbar-brand { color: white !important; }
			.tmss-table-noborder-first tbody tr:first-child td{border-top:0px;}
			.tmss-table-noborder tbody tr td{border-top:0px;}
			.tmss-calgrid-holiday { background-color: #f1f1f1;	}
			.tmss-calgrid-noworkingday { background-color: #f1f1f1; }
			.tmss-calgrid-currentday { background-color: #d9edf7; }			
			.tmssCalendarSmall thead tr th { text-align: center; border: 0px; }
			.tmssCalendarSmall tbody tr td {
				border-radius: 15px;
				text-align: center;
				margin-left: 15px !important;
				margin-right: 15px !important;
				vertical-align: middle;
				border: 0px;
			}
			.tmssCalendarSmall tbody tr td.otherMonth{ color: #f1f1f1; }
			.tmssCalendarSmall tbody tr td.currentDay{background-color: #d9edf7; }
			.tmssCalendarSmall .holiday { background-color:#f1f1f1; }
			
			#<?= $lv_sec; ?> .dashboard-card{ border-radius: 10px; padding: 10px; margin-bottom: 10px; }
			#<?= $lv_sec; ?> .dashboard-card p:first-child { font-size:16px; }
			#<?= $lv_sec; ?> .dashboard-card p:last-child { font-size:32px; font-weight:bold; text-align: center;}
      
      /* columna de empleados */
      #<?= $lv_sec; ?> #tmegrd th[data-field="hhremptxt"],
      #<?= $lv_sec; ?> #tmegrd td[data-field="hhremptxt"] {
        width: 200px;
        max-width: 200px;
        white-space: nowrap;
      }

      /* columnas de días */
      #<?= $lv_sec; ?> #tmegrd th[data-field^="day"],
      #<?= $lv_sec; ?> #tmegrd td[data-field^="day"] {
        width: 60px;
        max-width: 60px;
        text-align: center;
        white-space: nowrap;
      }
      
      /* columnas de cumpleaños y aniversarios*/
      #<?= $lv_sec; ?> .row > span[class*="col-"] {
        display: flex;
        align-items: center;     /* Centra verticalmente */
        justify-content: center; /* Centra horizontalmente */
        text-align: center;      /* Asegura centrado del texto */
      }
		</style>
		<div class="container-fluid">
			<div class="row">
				
				<?php if($vew_data->hhrempcod!=''){ ?>
				<div class="col-md-3 navbar-default" style="padding-top:15px; padding-bottom:15px;">

					<!-- IMAGEN -->
					<div style="padding-bottom:15px;">
					<?php $lv_mdlcod='HHR'; $lv_prgcod='EMP'; $lv_dockey=$vew_data->hhrempcod; include('grldatuplshwpth.frm'); ?>
					</div>
				
					<!-- LICENCIAS -->
					<div class="card">
						<div class="card-header cursor-pointer" data-toggle="collapse" data-target="#liccrdtog" aria-expanded="false"><div class="card-title">
							<i class="far fa-umbrella-beach"></i> <?= $vew_lang->licences; ?>
							<?= ($vew_sec->hasPermission('HHR','LIC','01') ? '<a href="#" class="card-icon" id="btnaddlic"><i class="far fa-plus"></i></a>' : '' ); ?>
							</div>
						</div>
						<div id="liccrdtog" class="collapse"><div class="card-body tmss-card-body-edit" id="divlic"></div></div>
					</div>

					<!-- RECIBOS -->
					<div class="card">
						<div class="card-header cursor-pointer" data-toggle="collapse" data-target="#reccrdtog" aria-expanded="false"><div class="card-title"><i class="far fa-files"></i> <?= $vew_lang->receipts; ?></div></div>
						<div id="reccrdtog" class="collapse"><div class="card-body tmss-card-body-edit" id="divlqd"></div></div>
					</div>

					<!-- MIS HORARIOS -->
					<div class="card">
						<div class="card-header cursor-pointer" data-toggle="collapse" data-target="#schcrdtog" aria-expanded="false"><div class="card-title"><i class="far fa-clock"></i> <?= $vew_lang->schedule; ?></div></div>
						<div id="schcrdtog" class="collapse"><div class="card-body tmss-card-body-edit" id="divtme"></div></div>
					</div>
					
					<!-- DOCUMENTOS -->
					<div class="card">
						<div class="card-header cursor-pointer" data-toggle="collapse" data-target="#doccrdtog" aria-expanded="false"><div class="card-title"><i class="far fa-files"></i> <?= $vew_lang->documents; ?></div></div>
						<div id="doccrdtog" class="collapse"><div class="card-body tmss-card-body-edit"><li> <a href="#" name="lnkdoc">Certificado de Trabajo</a></li></div></div>
					</div>

					<!-- DATOS PERSONALES -->
					<div class="card">
						<div class="card-header cursor-pointer" data-toggle="collapse" data-target="#datcrdtog" aria-expanded="false"><div class="card-title"><i class="far fa-address-card"></i> <?= $vew_lang->personaldata; ?></div></div>
						<div id="datcrdtog" class="collapse"><div class="card-body tmss-card-body-edit" id="divemp"></div></div>
					</div>
					
				</div>
				<?php } ?>
				
				<div class="<?=($vew_data->hhrempcod!=''?'col-md-9':'col-md-12'); ?>">
					
					<div class="row" style="padding-top:15px; padding-bottom:15px;">
						
						<div class="col-md-7">
						
							<!-- NAVIDAD -->
							<?php	if(date('m')==12 && date('d')>=21 && date('d')<=26) { ?>
								<div class="card" style="font-size:18px; color: white; background:url('/library/images/linear/shooting-star.png') top right no-repeat #4caf50; background-size:contain;">
									<div class="card-body">
									<p style="margin-right:100px;"><b>&iexcl;FELIZ NAVIDAD!</b><br>Que Dios ilumine tu hogar y lo llene de amor y bienestar!</p>
									</div>
								</div>
							<?php } ?>

							<!-- AÑO NUEVO -->
							<?php	if( (date('m')==12 && date('d')>=27) || (date('m')==1 && date('d')<=2) )  { ?>
								<div class="card" style="font-size:18px; color: white; background:url('/library/images/linear/new-year.png') top right no-repeat #ff9800; background-size:contain;">
									<div class="card-body">
									<p style="margin-right:100px;"><b>&iexcl;FELIZ A&Ntilde;O NUEVO!</b><br>y sigamos aprendiendo juntos.</p>
									</div>
								</div>
							<?php } ?>

							<?php if($vew_data->hhrempcod!=''){ ?>
								<!-- MI ANIVERSARIO -->
								<?php	if($lv_aniversary??false ){ ?>
									<div class="card" style="background-color: #178acc; color: white; font-size:18px;">
										<div class="card-body">
											<div class="row">
												<div class="col-sm-10"><b>&iexcl;GRACIAS!</b><br>
													De coraz&oacute;n te queremos agradecer por todo este tiempo compartido y nos alegramos de poder crecer juntos ! 
												</div>
												<div class="col-sm-2 text-center">
													<i class="fas fa-3x fa-heart fa-beat" style="--fa-beat-scale: 2.0; color: red !important;"></i>
												</div>
											</div>
										</div>
									</div>
								<?php } ?>
								
								<!-- MI CUMPLEAÑOS -->
								<?php	if($lv_birthday??false ){ ?>
									<div class="card" style="background-color: #468847; color: white; font-size:18px;">
										<div class="card-body">
											<div class="row">
												<div class="col-sm-10"><b>&iexcl;FELIZ CUMPLE!</b><br>
													Te deseamos lo mejor en este d&iacute;a y que se cumplan tus deseos! 
												</div>
												<div class="col-sm-2 text-center">
													<i class="fas fa-3x fa-cake-candles fa-beat" style="--fa-beat-fade-scale: 2.0; color:#ffeb3b;"></i>
												</div>
											</div>
										</div>
									</div>
								<?php } ?>
								
								<!-- EVALUACIONES -->
							<!--	<div class="row">
									<div class="col-sm-6">
										<div class="dashboard-card" style="background-color: var(--tmss-purple); text: var(--tmss-purple-text);">
											<p><?= $vew_lang->evaluations; ?></p><p id="qtyevl"></p>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="dashboard-card" style="background-color: var(--tmss-green); text: var(--tmss-purple-text);">
											<p><?= $vew_lang->evaluations; ?></p><p id="qtyevl"></p>
										</div>
									</div>
								</div>

								<!-- HABILIDADES / OBJETIVOS 
								<div class="row">
									<div class="col-sm-6">
										<div class="card">
											<div class="card-header"><div class="card-title">Habilidades</div></div>
											<div class="card-body">
												<canvas id="grphab"><i class="far fa-gear fa-spin"></i></canvas>
											</div>
										</div>
									</div>
									<div div class="col-md-6">
										<div class="card">
											<div class="card-header"><div class="card-title">Objetivos</div></div>
											<div class="card-body">
												<canvas id="grpobj"><i class="far fa-gear fa-spin"></i></canvas>
											</div>
										</div>
									</div>
								</div>
							<?php } ?>
							
							<!-- NOVEDADES -->
							<div class="card">
								<div class="card-header cursor-pointer" data-toggle="collapse" data-target="#nwscrdtog" aria-expanded="false"><div class="card-title"><i class="far fa-newspaper"></i> <?= $vew_lang->news; ?></div></div>
								<div id="nwscrdtog" class=".collapse.show"><div class="card-body tmss-card-body-edit" style="max-height:335px; overflow-y:scroll;" id="divnws"></div></div>
							</div>

						</div>
						
						<div class="col-md-5">
						
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
										<thead><tr><th>Do</th><th>Lu</th><th>Ma</th><th>Mi</th><th>Ju</th><th>Vi</th><th>Sa</th></tr></thead>
										<tbody></tbody>
									</table>
								</div>
								<div class="card-footer" style="padding: 15px; flex: 1 1 auto; min-height: 1px; border-top: 1px solid #ebedf2!important;"></div>
							</div>

							<!-- CUMPLES Y ANIVERSARIOS -->
							<div class="card">
								<div class="card-header"><div class="card-title">Cumples y Aniversarios</div></div>
								<div class="card-body tmss-card-body-edit" id="divcum"></div>
							</div>
							
						</div>
					</div>
					
					<!-- COLEGAS -->
					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->timetable; ?> 
              <a href="#" class="card-icon" id="btnweknxt"><i class="far fa-chevron-right"></i></a>
              <a href="#" class="card-icon" id="btnwekprv"><i class="far fa-chevron-left"></i></a>
            </div></div>
						<div class="card-body tmss-card-body-edit"><table id="tmegrd"></table></div>
					</div>
					
				</div>
				</div>
			</div><!-- /row -->
			
		<!--</div> /container-fluid -->
  </form>
	<?= gethtml('plnyth','hidden',date_format(new DateTime(),'Y')); ?>
	<?= gethtml('plnmth','hidden',date_format(new DateTime(),'m')); ?>
	<?= gethtml('plnday','hidden',date_format(new DateTime(),'d')); ?>
	<?= gethtml('vewflt','hidden',''); ?>
	<?= gethtml('maxrec','hidden',''); ?>
	<script>
    //LICENCIAS
		// nueva licencia
		$("#<?= $lv_sec; ?> #btnaddlic").on("click",function(e){e.preventDefault();
			tmssLink("?prg=hhrlic&act=01&prm_mdlcod=HHR&prm_prgcod=LIC&prm_srcobjcod=<?=$vew_data->hhrempcod?>",[{target:"_new_section"}]);
		});
    
    // al volver de una licencia, recargo la página
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_refresh(); <?= $lv_sec; ?>_refreshTimeGrid(); }

		// documentos
		$("#<?= $lv_sec; ?> a[name=lnkdoc]").on("click",function(e){ e.preventDefault();
			window.open("?prg=zcutms&act=hhrempcrt&prm_hhrempcod=<?= $vew_data->hhrempcod; ?>&prm_msgqty=1");
		});
		
		function <?= $lv_sec; ?>_refresh(){
			var lv_spin = "<i class='far fa-gear fa-spin'></i> Buscando...";
			$("#<?= $lv_sec; ?> #divemp").empty().append( lv_spin );
			$("#<?= $lv_sec; ?> #divlic").empty().append( lv_spin );
			$("#<?= $lv_sec; ?> #divtme").empty().append( lv_spin );
			$("#<?= $lv_sec; ?> #divlqd").empty().append( lv_spin );
			$("#<?= $lv_sec; ?> #divnws").empty().append( lv_spin );
			$("#<?= $lv_sec; ?> #divcum").empty().append( lv_spin );
      
      // creo una variable JS con el valor de HhrEmpCod para reutilizarla en todos los llamados
      <?php $lv_hhrempcod = ($vew_data->hhrempcod??"") !== "" ? $vew_data->hhrempcod : ""; ?>
      var lv_hhrempcod = <?= json_encode($lv_hhrempcod); ?>;

			// DATOS PERSONALES
			var lv_pstdat = [ {name:"typ",value:"emp"},{name:"hhrempcod",value:lv_hhrempcod} ];
			tmssCallProcessNoBackdrop("?prg=hhremp&act=dshemp",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #divemp").empty();
        if (typeof data === "string") { return; }
				$("#<?= $lv_sec; ?> #divemp").append("<i class='far fa-map-location' title='<?= $vew_lang->address; ?>'></i> "+data.adr.adrstr+" "+data.adr.adrstrnum+" "+data.adr.adrstrflr+data.adr.adrstrunt+"<br>" );
				$("#<?= $lv_sec; ?> #divemp").append("<i class='far fa-phone' title='<?= $vew_lang->phone; ?>'></i> "+data.adr.adrphn001+" "+data.adr.adrphn002+" "+data.adr.adrmblphn+"<br>" );
				if( data.adr["adreml"]!="" ){ $("#<?= $lv_sec; ?> #divemp").append( "<i class='far fa-envelope' title='<?= $vew_lang->email; ?>'></i> "+data.adr.adreml+"<br>"); }
				//onclick='tmssCopyToClipboard( $(this).html().replaceAll("+String.fromCharCode(39)+"<br>"+String.fromCharCode(39)+","+String.fromCharCode(39)+"\n"+String.fromCharCode(39)+") );'
				$("#<?= $lv_sec; ?> #divemp").append("<i class='far fa-hand-holding-dollar' title='<?= $vew_lang->bank; ?>'></i> <span style='cursor:pointer;' >"+(data?.bnk?.bnktxt ?? "")+" "+(data?.bnk?.bnkacctyp ?? "")+" "+(data?.bnk?.bnkbch ?? "")+"-"+(data?.bnk?.bnkaccnum ?? "")+(data.bnk.bnkacccbu!=""?"<br>CBU: "+data.bnk.bnkacccbu:"")+(data.bnk.bnkacccbuals!=""?"<br>Alias:"+data.bnk.bnkacccbuals:"")+(data.tax.taxcod==""?"":"<br>"+(data.tax.taxdoctyp=="86"?"CUIL ":"")+data.tax.taxcod)+"<br>" );
				$("#<?= $lv_sec; ?> #divemp").append("<i class='far fa-handshake' title='<?= $vew_lang->entrance; ?>'></i> "+moment(data.hhrempinbdte.date).format("DD/MM/YYYY")+"<br>" );
			});

			// LICENCIAS
			var lv_pstdat = [ {name:"typ",value:"lic"},{name:"hhrempcod",value:lv_hhrempcod} ];

			tmssCallProcessNoBackdrop("?prg=hhremp&act=dshemp",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #divlic").empty();
        if (typeof data === "string") { return; }
				if( data.length==0 ){ $("#<?= $lv_sec; ?> #divlic").append("<div>No hay licencias.</div>"); return; }
        //Comentado porque tardaba mucho en responder la pagina, revisar porque.
				for(var i=0; i<data.length; i++){
					//Ingresar el color si es rojo o verde dependiendo del estado si es inactivo o activo la licencia para identificar si esta liberada o no.
					var lv_relsts = (data[i]["docsts"]=="A" && (data[i]["relsts"]=="A")? "<i class='fa fa-check text-success'></i>" :(( data[i]["relsts"]=="R")? "<i class='fa fa-times text-danger'></i>" :"<i class='fa-light fa-clock'"));
          //  <i class='"+ $("<div>"+data[i]["hhrlictypatr"]+"</div>").find("icn")+"'></i>
					$("#<?= $lv_sec; ?> #divlic").append( "<div name='hhrlic' data-hhrliccod= '"+data[i]["hhrliccod"]+"'style='border-bottom: 1px solid #e0e0e0; padding: 5px 0;'><a href='#' class='vewlic'<b>"+data[i]["hhrlictyptxt"]+"</b></a><br>"+moment(data[i]["hhrlicdtestr"].date).format("DD.MM.YYYY")+" - "+moment(data[i]["hhrlicdteend"].date).format("DD.MM.YYYY")+"<span class='pull-right'>"+lv_relsts+"</span></div>");
				}
        //Abrir licencia
    		$("#<?= $lv_sec; ?> div[name=hhrlic]").on("click",function(e){ e.preventDefault();	
      			tmssLink("?prg=hhrlic&act=03&prm_hhrliccod="+$(this).data("hhrliccod")+"&prm_mdlcod=HHR&prm_prgcod=LIC", [{target: "_new_section"}] );});
			});

      
			// HORARIOS
			var lv_pstdat = [{name:"typ",value:"tme"},{name:"hhrempcod",value:lv_hhrempcod}];
			tmssCallProcessNoBackdrop("?prg=hhremp&act=dshemp",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #divtme").empty();
        if (typeof data === "string") { return; }
				if( data.length==0 ){ $("#<?= $lv_sec; ?> #divtme").append("<div>No hay horarios / turnos.</div>"); return; }
        $("#<?= $lv_sec; ?> #divtme").append("<table class='table tmss-table-noborder-first' name='mis_horarios'><tbody>");
        lv_dat = data;
        var lv_dayname = {L:"Lunes",M:"Martes",X:"Miercoles",J:"Jueves",V:"Viernes",S:"Sabado",D:"Domingo"};
        var lv_dayord = {L:0,M:1,X:2,J:3,V:4,S:5,D:6};
        var lv_tmedat = "";
        for (let i = 0; i < lv_dat.length; i++) {
        	$("#<?= $lv_sec; ?> #divtme table tbody").append("<tr><td colspan=3><b>"+lv_dat[i]["hhremptxt"]+"</b></td></tr>");
          lv_tmeatr = JSON.parse(lv_dat[i]["hhrtmerngatr"]).tmerng;
          lv_dayarr = [];
          for (let k = 0; k<lv_tmeatr.length; k++){
          	lv_dayarr[lv_dayord[lv_tmeatr[k]["tmeday"]]] =  "<tr><td>"+lv_dayname[ lv_tmeatr[k]["tmeday"] ]+"</td><td>"+lv_tmeatr[k]["tmestr"]+"</td><td>"+lv_tmeatr[k]["tmeend"]+"</td></tr>";
          }
          for (let k = 0; k < lv_dayarr.length; k++) {
            if (lv_dayarr[k]) {
              $("#<?= $lv_sec; ?> #divtme table tbody").append(lv_dayarr[k]);
            }
          }
        }
        
			});

			// RECIBOS
			var lv_pstdat = [{name:"typ",value:"lqd"},{name:"hhrempcod",value:lv_hhrempcod}];
			tmssCallProcessNoBackdrop("?prg=hhremp&act=dshemp",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #divlqd").empty();
        if (typeof data === "string") { return; }
				if(data.length==0){ $("#<?= $lv_sec; ?> #divlqd").empty().append("No se encontraron recibos."); return; }
        data.forEach(function(row){
          $("#<?= $lv_sec; ?> #divlqd").append("<a href='#' name='lnkrec' class='list-group-item' "+"data-hhrlqdcod='"+row.hhrlqdcod+"'>"+row.hhrlqdtxt+"</a>");
        });
				$("#<?= $lv_sec; ?> a[name=lnkrec]").on("click",function(e){ e.preventDefault();
					var lv_pstdat =[{name:"hhrlqdcod", value: $(this).data("hhrlqdcod")}];
					tmssCallProcessBlob("?prg=zcutms&act=hhrlqdrecpnt", lv_pstdat, function(data){
						if(data.type=="application/json"){
							data.text().then(function(result) {
								var lv_err = JSON.parse(result);
								toastr.warning("No se puede descargar el archivo.<br>"+lv_err.errcod+": "+lv_err.errtxt);
							});
						} else {
							// Crear una URL para el Blob y lo abre en una nueva pestaña
							var url = window.URL.createObjectURL(data);
							window.open(url, "_blank");
						}
					});
				});
			});

			// NOVEDADES
			var lv_pstdat = [{name:"typ",value:"nws"},{name:"hhrempcod",value:lv_hhrempcod}];
			tmssCallProcessNoBackdrop("?prg=hhremp&act=dshemp",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #divnws").empty();
        if (typeof data === "string") { return; }
				if( data.length==0 ){ $("#<?= $lv_sec; ?> #divnws").append("<div>No hay novedades.</div>"); return; }
				for(var i=0; i<data.length; i++){
					$("#<?= $lv_sec; ?> #divnws").append( (i>0?"<hr>":"")+"<div><b>"+(data[i]["nwstxt"]).toUpperCase()+"<span class='pull-right'>"+moment(data[i]["nwsdte"].date).format("DD.MM.YYYY")+"</span></b><br>"+data[i]["nwsmsg"]+"</div>" );
				}
			});
			
			// CUMPLES Y ANIVERSARIOS
			var lv_pstdat = [ {name: "typ", value: "cum"},{name: "hhrempcod", value: lv_hhrempcod} ];
      tmssCallProcessNoBackdrop("?prg=hhremp&act=dshemp", lv_pstdat, function (data) {
        $("#<?= $lv_sec; ?> #divcum").empty();
        if (typeof data === "string" || !data) return;

        const lv_actdte = new Date();
        const lv_shwdiff = 30;
        let lo_events = [];

        function <?= $lv_sec; ?>_diferenciaDeDias(lp_actdte, lp_evtdte) {
          const lv_day = 1000 * 60 * 60 * 24;
          return Math.ceil((lp_evtdte - lp_actdte) / lv_day);
        }

        for (let i = 0; i < data.length; i++) {
          const lv_emp = data[i];
          const lv_nme = lv_emp.hhremptxt;

          // Cumpleaños
          if (lv_emp.perbrndte?.date) {
            const lv_bdayOrig = new Date(lv_emp.perbrndte.date);
            const lv_bday = new Date(lv_bdayOrig);
            lv_bday.setFullYear(lv_actdte.getFullYear());

            let lv_dif = <?= $lv_sec; ?>_diferenciaDeDias(lv_actdte, lv_bday);
            if (lv_dif < 0) {
              lv_bday.setFullYear(lv_actdte.getFullYear() + 1);
              lv_dif = <?= $lv_sec; ?>_diferenciaDeDias(lv_actdte, lv_bday);
            }

            if (lv_dif <= lv_shwdiff) {
              const lv_age = lv_actdte.getFullYear() - lv_bdayOrig.getFullYear();
              const lv_dtetxt = `${String(lv_bday.getDate()).padStart(2,'0')}.${String(lv_bday.getMonth()+1).padStart(2,'0')}`;
              lo_events.push({
                dif: lv_dif,
                html: `<div class="row"><span class="col-sm-2">${lv_dtetxt}</span><span class="col-sm-5">${lv_nme}</span><span class="col-sm-5" style="display: block;"><i class="fa fa-birthday-cake"></i> ${lv_age} A&ntilde;os</span></div><br>`
              });
            }
          }

          // Aniversarios
          if (lv_emp.hhrempinbdte?.date) {
            const lv_strdteOrig = new Date(lv_emp.hhrempinbdte.date);
            const lv_strdte = new Date(lv_strdteOrig);
            lv_strdte.setFullYear(lv_actdte.getFullYear());

            let lv_dif = <?= $lv_sec; ?>_diferenciaDeDias(lv_actdte, lv_strdte);
            if (lv_dif < 0) {
              lv_strdte.setFullYear(lv_actdte.getFullYear() + 1);
              lv_dif = <?= $lv_sec; ?>_diferenciaDeDias(lv_actdte, lv_strdte);
            }

            if (lv_dif <= lv_shwdiff) {
              const lv_yrs = lv_actdte.getFullYear() - lv_strdteOrig.getFullYear();
              const lv_dtetxt = `${String(lv_strdte.getDate()).padStart(2,'0')}.${String(lv_strdte.getMonth()+1).padStart(2,'0')}`;
              lo_events.push({
                dif: lv_dif,
                html: `<div class="row"><span class="col-sm-2">${lv_dtetxt}</span><span class="col-sm-5">${lv_nme}</span><span class="col-sm-5" style="display: block;"><i class="fa fa-briefcase"></i>&nbsp;${lv_yrs} ${lv_yrs===1 ? 'A&ntilde;o' : 'A&ntilde;os'}</span></div><br>`
              });
            }
          }
        }

        // Ordenar por proximidad
        lo_events.sort((a, b) => a.dif - b.dif);
        
        const lv_hasevt = lo_events.length > 0;
        if (!lv_hasevt) { $("#<?= $lv_sec; ?> #divcum").closest(".card").addClass("d-none"); return; }
        else{ $("#<?= $lv_sec; ?> #divcum").closest(".card").removeClass("d-none"); }

        lo_events.forEach(ev => { $("#<?= $lv_sec; ?> #divcum").append(ev.html); });
      });

			
			// GRAFICOS - HABILIDADES y OBJETIVOS
			/*tmssLoadScript("chart",function(){ 		
				// HABILIDADES
        // obtener las habilidades del empleado las cuales se le son pedidas
				tmssCallProcessNoBackdrop("?prg=hhrevlski&act=18","",function(data){
					var lv_lbl = [];
					var lv_qty = [];
          var lv_qty2 = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].hhrevlskitxt );
            lv_qty.push(Math.floor(Math.random() * 101));
            lv_qty2.push(Math.floor(Math.random() * 101));
					//	lv_qty.push( data[i].qty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grphab");
					var data={
						  labels: lv_lbl,
						datasets:[{ label: "<?= $vew_lang->SKILLS?>",
              				  data:lv_qty,
                        fill: true,
                        backgroundColor: "rgba(199, 233, 192, 0.6)"},
                     { label: "Habilidades esperadas",
                          data: lv_qty2,
                          fill: true,
                          backgroundColor: "rgba(128, 128, 128, 0.1)"}]
					}
         var options= { responsive: true,
                        plugins: {  legend: {    labels: {      font: {      size: 12   }  } } },
                        scales: {  r: { pointLabels: { font: { size: 10 } }, ticks: { display: false},suggestedMin: 0, suggestedMax: 100 } }
                     };
					<?= $lv_sec; ?>_grptyp = new Chart(ctx, { type: "radar", data: data, options: options });
				});
				//Objetivos
        tmssCallProcessNoBackdrop("?prg=hhrevlobj&act=18","",function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].crmcnttyptxt );
						lv_qty.push( data[i].qty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grpobj");
					var data={
						  labels: ['Eating',
                    'Drinking',
                    'Sleeping',
                    'Designing',
                    'Coding',
                    'Cycling',
                    'Running'
                  ],
						datasets:[{data: [65, 59, 90, 81, 56, 55, 40],
                      	fill: true,
                       backgroundColor: "rgba(255, 99, 132, 0.2)"}]
					}
					var options = { elements:{line:{borderWidth: 3}} };
					<?= $lv_sec; ?>_grptyp = new Chart(ctx, { type: "radar", data: data, options: options });
				});
			});*/

		}
		
		$(function(){<?= $lv_sec; ?>_refresh();});
	</script>
	<script>
		// Calendario. Inicializacion
		$(function(){
			var lo_today = new Date();
			$("#<?= $lv_sec; ?> #dshcal").data("year", lo_today.getFullYear() );
			$("#<?= $lv_sec; ?> #dshcal").data("month", lo_today.getMonth()+1 );
			<?= $lv_sec; ?>_showCalendar( $("#<?= $lv_sec; ?> #dshcal") );
			<?= $lv_sec; ?>_showCalendarHolidays( $("#<?= $lv_sec; ?> #dshcal") );
      <?= $lv_sec; ?>_setWeek(moment({year:lo_today.getFullYear(), month:lo_today.getMonth(),day:lo_today.getDate()}));
			<?= $lv_sec; ?>_refreshTimeGrid();
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
      <?= $lv_sec; ?>_setWeek(moment({year:lv_yth, month: lv_mth-1}));
			<?= $lv_sec; ?>_refreshTimeGrid();
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
      <?= $lv_sec; ?>_setWeek(moment({year:lv_yth, month: lv_mth-1}));
			<?= $lv_sec; ?>_refreshTimeGrid();
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
				$(lv_table).find("tbody").append("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");									
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
						$(lv_table).find("tbody tr:nth-child("+(i+1)+") td:nth-child("+(j+1)+")").data("day",lv_day);
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
			$(lp_card).find(".card-footer div").remove();
			tmssCallProcessNoBackdrop("?prg=admhld&act=23",lv_pstdat,function(data){
				if( data.length==0 ){
					$(lp_card).find(".card-footer").addClass("hidden");
				} else {
					$(lp_card).find(".card-footer").removeClass("hidden");
				}
				$(lp_card).find(".card-footer").append("<div><i class='far fa-calendar-image'></i><b> Feriados</b></div>");
				for(var i=0; i<data.length; i++){
					var lv_day = new Date( data[i].hldmovday.date ).getDate();

					//FALTA. no funciona esto de JQUERY por lo que se reemplaza por una busqueda individual
					//$(lp_card).find(".card-body table:first tbody tr td[data-day="+lv_day+"]").addClass("holiday");
					$(lp_card).find(".card-body table:first tbody tr td").each(function(){
						if($(this).data("day")==lv_day){ $(this).addClass("holiday"); }
					});
					
					$(lp_card).find(".card-footer").append("<div><i class='far fa-dot'></i>"+lv_day+" - "+data[i].hldmovtxt+"</div>");
				}
			});
		}
    //HORARIOS / TURNOS. Semana
    function <?= $lv_sec; ?>_setWeek(lp_date){
    	var lv_wekday = moment(lp_date);
    	var lv_startwek = lv_wekday.clone().startOf('isoWeek');
    	var lv_endwek = lv_startwek.clone().add(6,'days');
    	if(lv_startwek.month() == ($("#<?= $lv_sec; ?> #dshcal").data("month")-1) || lv_endwek.month() == ($("#<?= $lv_sec; ?> #dshcal").data("month")-1) ){
        $("#<?= $lv_sec; ?> #tmegrd")
          .data("startwek", lv_startwek.format("YYYY-MM-DD"))
          .data("endwek",   lv_endwek.format("YYYY-MM-DD"));
    	}
  	}
    //HORARIOS / TURNOS. Semana Siguiente
    $("#<?= $lv_sec; ?> #btnweknxt").on("click",function(e){ 
      e.preventDefault();
      let lv_startwek = moment($("#<?= $lv_sec; ?> #tmegrd").data("startwek")).add(7,'days');
      
      // verifico si cambió el mes
      let lv_newyer  = lv_startwek.year();
      let lv_newmth = lv_startwek.month() + 1; // moment() devuelve 0-11

      let lv_curyer  = Number($("#<?= $lv_sec; ?> #dshcal").data("year"));
      let lv_curmth = Number($("#<?= $lv_sec; ?> #dshcal").data("month"));

      if (lv_newyer !== lv_curyer || lv_newmth !== lv_curmth) {
        $("#<?= $lv_sec; ?> #dshcal").data("year", lv_newyer);
        $("#<?= $lv_sec; ?> #dshcal").data("month", lv_newmth);
        <?= $lv_sec; ?>_showCalendar($("#<?= $lv_sec; ?> #dshcal"));
        <?= $lv_sec; ?>_showCalendarHolidays($("#<?= $lv_sec; ?> #dshcal"));
      }

      // actualizo semana
      <?= $lv_sec; ?>_setWeek(lv_startwek);
      <?= $lv_sec; ?>_refreshTimeGrid();
    });
    
    //HORARIOS / TURNOS. Semana anterior.
    $("#<?= $lv_sec; ?> #btnwekprv").on("click",function(e){ 
      e.preventDefault(); 
      let lv_startwek = moment($("#<?= $lv_sec; ?> #tmegrd").data("startwek")).add(-7,'days');
			
      // verifico si cambió el mes
      let lv_newyer  = lv_startwek.year();
      let lv_newmth = lv_startwek.month() + 1; // moment() devuelve 0-11

      let lv_curyer = Number($("#<?= $lv_sec; ?> #dshcal").data("year"));
      let lv_curmth = Number($("#<?= $lv_sec; ?> #dshcal").data("month"));

      if (lv_newyer !== lv_curyer || lv_newmth !== lv_curmth) {
        $("#<?= $lv_sec; ?> #dshcal").data("year", lv_newyer);
        $("#<?= $lv_sec; ?> #dshcal").data("month", lv_newmth);
        <?= $lv_sec; ?>_showCalendar($("#<?= $lv_sec; ?> #dshcal"));
        <?= $lv_sec; ?>_showCalendarHolidays($("#<?= $lv_sec; ?> #dshcal"));
      }
      
      // actualizo semana
      <?= $lv_sec; ?>_setWeek(lv_startwek);
      <?= $lv_sec; ?>_refreshTimeGrid();
    });
		
    // simplifico el string de los horarios
    function <?= $lv_sec; ?>_simplifyTime(lp_tmeStr){
      // lp_tmeStr = "0X:00" o "0X:XX"
      let [lv_hrs, lv_min] = lp_tmeStr.split(":");
      lv_hrs = String(Number(lv_hrs)); // elimina ceros a la izquierda
      if(lv_min === "00"){ return lv_hrs; } else { return lv_hrs+":"+lv_min; } // si los minutos son 00, muestro solo la hora; si tiene minutos, lo dejo
    }    
    
		function <?= $lv_sec; ?>_refreshTimeGrid(){
			tmssLoadScript("table", function(){
				var lv_yth = Number($("#<?= $lv_sec; ?> #dshcal").data("year"));
				var lv_mth = Number($("#<?= $lv_sec; ?> #dshcal").data("month"));
				var lv_daysInMonth = ( 32 - new Date(lv_yth, lv_mth-1, 32).getDate() );		
        var lv_enddteref = new Date(lv_yth, lv_mth-1, lv_daysInMonth);
        lv_enddteref.setDate( lv_enddteref.getDate()+6 );
				var lv_pstdat =[{name:"vewfld",value:$("#<?= $lv_sec; ?> #vewflt").val()},
												{name:"maxrec",value:$("#<?= $lv_sec; ?> #maxrec").val()},
												{name:"strdte",value:lv_yth+"-"+(lv_mth<10?"0":"")+lv_mth+"-01"},
												{name:"enddte",value:lv_enddteref.toISOString().split('T')[0]},
												{name:"plnyth",value:lv_yth},
												{name:"plnmth",value:lv_mth}];
				tmssCallProcessNoBackdrop("?prg=hhremptme&act=timegrid_data",lv_pstdat,function(data){
					var lv_dat = [];
					var lv_col = [];					
          lv_col.push({
              field: "hhremptxt",
              title: "<?= $vew_lang->employee; ?>",
              sortable: true,
              width: 200 // ancho fijo para la columna de empleados
          });

					// CABECERA. armo la cabecera del mes
					var lv_dawt = {1:"Lun",2:"Mar",3:"Mie",4:"Jue",5:"Vie",6:"Sab",7:"Dom"};
          var lv_caldaystr = "";
          if (data.cal && data.cal.grlcalatr) {
						var lv_calarr = JSON.parse(data.cal.grlcalatr,true);
            // armo string de dias laborables
        		for(var i=0; i<lv_calarr.calrng.length; i++){lv_caldaystr+=lv_calarr.calrng[i].tmeday;} 
          }
          lv_caldaystr = "LMXJV";
          var lv_startwek = moment($("#<?= $lv_sec; ?> #tmegrd").data("startwek")); 
          var lv_endwek = moment($("#<?= $lv_sec; ?> #tmegrd").data("endwek"));

					// recorro dias del mes
					for(var i=1;i<=7;i++){
						// determino si el dia es laboral (extraigo la letra del dia actual y la busco en la cadena de dias laborables)
						var lv_workday = (lv_caldaystr.indexOf( ("LMXJVSD").substr(i-1,1) )<0?false:true);
            
            var lv_tdynum = moment(lv_startwek).isoWeekday(i).date();
            var lv_today = ( Number($("#<?= $lv_sec; ?> #dshcal").data("year"))*10000+Number($("#<?= $lv_sec; ?> #dshcal").data("month"))*100+lv_tdynum == Number(moment().format("YYYYMMDD")) ? true : false );
            
						// busco si para la fecha hay un feriado
						var lv_hldtxt = "";
						for(var x=0; x<data.hld.length; x++){
							if(lv_tdynum==Number(moment(data.hld[x].hldmovday.date).format("D"))){ lv_hldtxt=data.hld[x].hldtxt; }
						} 
           	
						// escritura de la columna
						lv_col.push({
							field: "day"+i,
							title: lv_dawt[i]+"<br>"+lv_tdynum,
							titleTooltip: lv_hldtxt,
              width: 60,
							class: (lv_today==true ?"tmss-calgrid-currentday": (lv_hldtxt!=""?"tmss-calgrid-holiday ":"")+(lv_workday==false?"tmss-calgrid-noworkingday ":"")),
							sortable: false
						});
						
					}

					$("#<?= $lv_sec; ?> #tmegrd").bootstrapTable("destroy").bootstrapTable({
						height: 400,
						columns: lv_col,
						search: false,
						showColumns: false,
						showToggle: false,
						clickToSelect: false,
						fixedColumns: true,
						fixedNumber: 1,
						stickyHeader: true
					});

					// POSICIONES. completo posiciones con empleados
					for(const key in data.emparr){				
						var lv_tmp = {};
						lv_tmp["hhremptxt"] = "<span style='white-space:nowrap;'>"+data.emparr[key].emp.hhremptxt+"</span>";

						for(var x=1; x<=7; x++){
							// determino si es dia laboral o feriado
							var lv_nowork = $("#<?= $lv_sec; ?> #tmegrd thead tr th[data-field='day"+x+"']").hasClass("tmss-calgrid-noworkingday");
							var lv_holiday = $("#<?= $lv_sec; ?> #tmegrd thead tr th[data-field='day"+x+"']").hasClass("tmss-calgrid-holiday");
							var lv_daycur = Number( moment(lv_startwek).isoWeekday(x).format("YYYYMMDD") );
							var lv_weekdaystr = ("LMXJVSD").substr(x-1,1);
							
							// turno. reviso si tiene asignado turno para el dia
							var lv_trnflg = "";
							for(var xtrn=0; xtrn<data.emparr[key].trn.length; xtrn++){
								// armo string de dias
								var lv_dayarr=JSON.parse(data.emparr[key].trn[xtrn].hhrtmerngatr);
								var lv_daystr = "";
								for(var xtrn2=0; xtrn2<lv_dayarr.tmerng.length; xtrn2++){ lv_daystr += lv_dayarr.tmerng[xtrn2].tmeday; }
								// determino inicio-fin del turno
								var lv_trnstr = Number( moment(data.emparr[key].trn[xtrn].hhremptmestr.date).format("YYYYMMDD") );
								var lv_trnend = Number( moment(data.emparr[key].trn[xtrn].hhremptmeend.date).format("YYYYMMDD") );
								// determino si para el dia actual hay un turno vigente
								if( lv_daycur>=lv_trnstr && lv_daycur<=lv_trnend && lv_daystr.indexOf(lv_weekdaystr)>=0 ){
									// armo la etiqueta con la hora de inicio-fin del turno
									for(var xtrn2=0; xtrn2<lv_dayarr.tmerng.length; xtrn2++){ 
										if( lv_weekdaystr==lv_dayarr.tmerng[xtrn2].tmeday ){
											lv_trnflg += (lv_trnflg==""?"":"<br>")+"<span style='white-space:nowrap;'>"+<?= $lv_sec; ?>_simplifyTime(lv_dayarr.tmerng[xtrn2].tmestr)+"&nbsp;&nbsp;-&nbsp;&nbsp;"+<?= $lv_sec; ?>_simplifyTime(lv_dayarr.tmerng[xtrn2].tmeend)+"</span>";
										}
									}
								}
							}
							
							// licencia. reviso si corresponde licencia
							var lv_licflg = "";
							for(var xlic=0; xlic<data.emparr[key].lic.length; xlic++){
								var lv_licstr = Number( moment( data.emparr[key].lic[xlic].hhrlicdtestr.date ).format("YYYYMMDD") );
								var lv_licend = Number( moment( data.emparr[key].lic[xlic].hhrlicdteend.date ).format("YYYYMMDD") );
								// si tiene licencia, marco la posicion
								if( lv_daycur>=lv_licstr && lv_daycur<=lv_licend){
									var lv_licicn = $("<div>"+data.emparr[key].lic[xlic].hhrlictypatr+"</div>").find("icn").text();
									lv_licflg = "<i class='"+(lv_licicn==""?"far fa-umbrella-beach":lv_licicn)+"'></i>";
								}
							}
							
							// suplencia. tbd
							
							// fichada. reviso si tiene fichadas para el turno
							var lv_assflg="";
							for(var xass=0; xass<data.emparr[key].ass.length; xass++){
								var lv_regdte = moment( data.emparr[key].ass[xass].hhrassdte.date ).format("D");
								if( x==lv_regdte ){
									if(data.emparr[key].ass[xass].hhrassflg=="1"){
										lv_assflg = "<i class='far fa-check text-success'></i>";
									} else {
										lv_assflg = "<i class='fas fa-square-minus text-danger'></i>";
									}
								}
							}
							
							// determino status de celda
							lv_tmp["day"+x] = (lv_assflg!=""?lv_assflg:
																(lv_licflg!=""?lv_licflg:
																(lv_nowork || lv_holiday ? "": 
																(lv_trnflg!=""?lv_trnflg:""))));
												
						}
						
						lv_dat.push( lv_tmp );
					}
					
					$("#<?= $lv_sec; ?> #tmegrd").bootstrapTable("load", lv_dat);
				});
			});
		}	
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>