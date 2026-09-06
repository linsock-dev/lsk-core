<?php
  // url del formulario
  $lv_lnk = '?prg=zcutjv';

  // campos requeridos
  $vew_input->RequiredFields( array() );
 
  // titulo 
	$lv_title = $vew_lang->Reports;

  // módulo y programa
  $lv_mdlcod = 'ZCU';
  $lv_prgcod = 'TJV';

  // clave del documento
	$lv_dockey = '';

	$vew_actcod = '03';
	
  // librería de estilos bootstrap
  include_once('_library.frm');
	
	$vew_tbl['rfrsh'] = array('per'=>true,'pos'=>'D','ttl'=>$vew_lang->refresh,'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_refresh();');
	$vew_tbl['fltR'] = array('pos'=>'R','per'=>true, 'ttl'=>'', 'id'=>'btnflt','icn'=>'fas fa-filter', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  <head>
  	<meta charset="UTF-8">
  </head>  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<div class="container-fluid">
    	<div class="row">
        <div class="col-md-6">
          <div class="card"> 
            <div class="card-header"><div class="card-title">Situaci&oacute;n Actual <small>(Agrupado)</small></div></div>
            <div class="card-body tmss-card-body-edit">
              <table class="table table-hover table-sm" id="tblstc">
								<thead><tr><th>Estados</th><th>Tickets</th><th>%</th></tr></thead>
								<tbody></tbody>
							</table>
            </div>
          </div>
				</div>
        <div class="col-md-6">
          <div class="card"> 
            <div class="card-header">
              <div class="card-title">Recientes <small>(Ultimos 3 meses)</small></div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <table class="table table-hover table-sm" id="tblmth">
								<thead><tr><th>MES</th></tr></thead>
								<tbody></tbody>
							</table>
            </div>
          </div>
				</div>
        <div class="col-md-6">
          <div class="card"> 
            <div class="card-header">
              <div class="card-title">Situaci&oacute;n Actual <small>(Contactados y No Contactados)</small></div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <table class="table table-hover table-sm" id="tblcnt">
                <thead><tr><th id='contacted'>Contactados</th><th id='not-contacted'>No Contactados</th><th id='lost'>Perdidos</th></tr></thead>
								<tbody></tbody>
							</table>
            </div>
          </div>
				</div>
				<div class="col-md-12">
          <div class="card"> 
            <div class="card-header"><div class="card-title">Situaci&oacute;n Actual <small>(por Usuarios)</small></div></div>
            <div class="card-body tmss-card-body-edit">
              <table class="table table-hover table-sm" id="tblprg">
								<thead><tr><th>Reuniones</th></tr></thead>
								<tbody></tbody>
							</table>
            </div>
          </div>
				</div>
        <div class="col-md-6">
          <div class="card"> 
            <div class="card-header">
              <div class="card-title">Situaci&oacute;n Actual <small>(por A&ntilde;o de Egreso)</small></div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <table class="table table-hover table-sm" id="tblendyer">
								<thead><tr><th>Estados</th></tr></thead>
								<tbody></tbody>
							</table>
            </div>
          </div>
				</div>
      </div>
    </div>
  </form>
  <script>
    var gv_<?= $lv_sec; ?>_flt = [
			{'fldttl': '<?= $vew_lang->ID; ?>', 'fldcod': 'c.crmcntcod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->date; ?>', 'fldcod': 'c.crmcntreqdte', 'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
      {'fldttl': '<?= $vew_lang->customer; ?>', 'fldcod': 'crmcntsrctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->type; ?>', 'fldcod': 't.crmcnttyptxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->motive; ?>', 'fldcod': 'm.crmcntmtvtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
      {'fldttl': '<?= $vew_lang->priority; ?>', 'fldcod': 'p.crmcntprttxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
      {'fldttl': '<?= $vew_lang->status; ?>', 'fldcod': 's.crmcntststxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->responsible; ?>', 'fldcod': 'c.usrcod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->duedate; ?>', 'fldcod': 'c.crmcntduedte', 'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
      {'fldttl': '<?= $vew_lang->town; ?>', 'fldcod': 'a.adrtwn', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
      {'fldttl': '<?= $vew_lang->area; ?>', 'fldcod': 'ltg.lndtwngrptxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}
			];
		
		
		// FILTRO
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_refresh);
		});
    		
		function <?= $lv_sec; ?>_refresh(lp_flt){
      var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}
			var lv_spin = "<i class='far fa-gear fa-spin'></i>";
      //   E S T A D O  D E  D O C U M E N T O
			$("#<?= $lv_sec; ?> #tblstc tbody tr").remove();
			$("#<?= $lv_sec; ?> #tblstc tfoot").remove();
			$("#<?= $lv_sec; ?> #tblstc tbody").append("<tr class='text-center'><td colspan='10'><i class='far fa-spin fa-cog'></i></td></tr>");
			tmssCallProcessNoBackdrop("?prg=zcutjv&act=dsh", [{name:"typ",value:"status"}, {name:"vewmaxrec", value:lv_fltint["maxrec"]}, {name:"vewfldflt", value:lv_fltint["fltstr"]}],function(data){
        $("#<?= $lv_sec; ?> #tblstc tbody tr").remove();
      	var lv_qty = data.length;
        let lv_totqty = 0;
        // Calcula el total de qty
        for (let i = 0; i < data.length; i++) { lv_totqty += data[i].qty; }        
        for(var i=0; i<data.length; i++){
          const lc_prc = (data[i].qty / lv_totqty) * 100;
					$("#<?= $lv_sec; ?> #tblstc tbody").append("<tr><td>"+data[i].crmcntststxt+"</td><td>"+data[i].qty+"</td><td>"+lc_prc.toFixed(2)+"</td></tr>");
				}
        $("#<?= $lv_sec; ?> #tblstc").append("<tfoot><tr><th>TOTAL</th><th>"+lv_totqty+"</th><th></th></tr></tfoot>");
      });
      
		
      // Ú L T I M O S  3  M E S E S  ( A Ñ O  A C T U A L / A Ñ O  P A S A D O )
      $("#<?= $lv_sec; ?> #tblmth tbody tr").remove();
			$("#<?= $lv_sec; ?> #tblmth tbody").append("<tr class='text-center'><td colspan='10'><i class='far fa-spin fa-cog'></i></td></tr>");
      tmssCallProcessNoBackdrop("?prg=zcutjv&act=dsh", [{ name: "typ", value: "recent" }], function (data) {
        $("#<?= $lv_sec; ?> #tblmth tbody tr").remove();
        $("#<?= $lv_sec; ?> #tblmth thead tr td").remove();
        //$("#<?= $lv_sec; ?> #tblmth thead tr").append('<th>MES</th>');
				if(data.length==0){ return; }
        var lv_auxsts = data[0].crmcntststxt;
        var lv_tot = 0;
        // obtengo la fecha actual.
        var lv_actdte = new Date();
        // creo un array para almacenar los nombres de los meses.
        var lv_mtharr = [];
        // obtengo los nombres de los últimos tres meses.
        for (var i = 0; i < 3; i++) {
            var lv_mth = lv_actdte.getMonth() - i; // Resto el índice actual para retroceder los meses.
            var lv_mthdte = new Date(lv_actdte.getFullYear(), lv_mth, 1); // Creo una fecha con el primer día del mes.
            var lv_mthnme = lv_mthdte.toLocaleString('default', { month: 'long' }); // Obtengo el nombre del mes.
            lv_mtharr.push(lv_mthnme.toUpperCase());
        }
        lv_mtharr.reverse();

        // modifico los meses ya creados agregándoles el año actual y hago lo mismo con los mismos meses
        var lv_mtharr_prvyer = [];
        for (var i = 0; i < 3; i++) {
          lv_mtharr_prvyer.push(lv_mtharr[i]+' '+(lv_actdte.getFullYear()-1));
          lv_mtharr[i] = lv_mtharr[i]+' '+lv_actdte.getFullYear();
        }
        // agrego los meses a la cabecera de la tabla de Recientes.
				for (var c = 0; c < 3; c++) {
					$("#<?= $lv_sec; ?> #tblmth thead tr").append("<td name='"+lv_mtharr[c]+"'>"+lv_mtharr[c]+"</td>");
          $("#<?= $lv_sec; ?> #tblmth thead tr").append("<td name='"+lv_mtharr_prvyer[c]+"'>"+lv_mtharr_prvyer[c]+"</td>");
        }
        $("#<?= $lv_sec; ?> #tblmth thead tr").append("<td name='TOTAL'>TOTAL</td>"); 

        
        // agrego las dos filas correspondientes a los estados (CERRADO y PERDIDO).
        $("#<?= $lv_sec; ?> #tblmth tbody").append("<tr id='FIRMADO'><td>FIRMADO</td><td id=0 data-sts='FIRMADO' data-col='"+lv_mtharr[0]+"' data-val=0></td><td id=1 data-sts='FIRMADO' data-col='"+lv_mtharr_prvyer[0]+"' data-val=0></td><td id=2 data-sts='FIRMADO' data-col='"+lv_mtharr[1]+"' data-val=0></td><td id=3 data-sts='FIRMADO' data-col='"+lv_mtharr_prvyer[1]+"' data-val=0></td><td id=4 data-sts='FIRMADO' data-col='"+lv_mtharr[2]+"' data-val=0></td><td id=5 data-sts='FIRMADO' data-col='"+lv_mtharr_prvyer[2]+"' data-val=0></td><td id='TOTAL'>0</td></tr>");
        $("#<?= $lv_sec; ?> #tblmth tbody").append("<tr id='PERDIDO'><td>PERDIDO</td><td id=0 data-sts='PERDIDO' data-col='"+lv_mtharr[0]+"' data-val=0></td><td id=1 data-sts='PERDIDO' data-col='"+lv_mtharr_prvyer[0]+"' data-val=0></td><td id=2 data-sts='PERDIDO' data-col='"+lv_mtharr[1]+"' data-val=0></td><td id=3 data-sts='PERDIDO' data-col='"+lv_mtharr_prvyer[1]+"' data-val=0></td><td id=4 data-sts='PERDIDO' data-col='"+lv_mtharr[2]+"' data-val=0></td><td id=5 data-sts='PERDIDO' data-col='"+lv_mtharr_prvyer[2]+"' data-val=0></td><td id='TOTAL'>0</td></tr>");
        
        var lv_status;
        var lv_period;
        for(var i=0; i<data.length; i++){
          lv_status = data[i].crmcntststxt.split('-')[1];
          var lv_auxdte = new Date(data[i].ctedte.date); // paso la string con la fecha del ticket a formato fecha.
          var lv_mth = lv_auxdte.getMonth(); // obtengo el número del mes del ticket.
          var lv_mthdte = new Date(lv_auxdte.getFullYear(), lv_mth, 1); // creo una fecha con el primer día del mes.
          var lv_mthnme = lv_mthdte.toLocaleString('default', { month: 'long' }).toUpperCase(); // obtengo el nombre del mes.
          lv_period = lv_mthnme+' '+lv_auxdte.getFullYear(); // creo una string con el mes + año con el mismo formato que las columnas.
          
          var lv_auxcnt = 0;
          lv_auxcnt += data[i].qty;
          $("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_status+" td[data-col='"+lv_period+"']").attr('data-val', parseInt($("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_status+" td[data-col='"+lv_period+"']").attr('data-val')) + lv_auxcnt);
          $("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_status+" td[data-col='"+lv_period+"']").html($("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_status+" td[data-col='"+lv_period+"']").attr('data-val'));
          $("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_status+" td#TOTAL").html(parseInt($("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_status+" td#TOTAL").html()) + lv_auxcnt);
        }
        
        $("#<?= $lv_sec; ?> #tblmth tbody tr#"+lv_auxsts+" #total").html(lv_tot);
    	});
      
      
      // C O N T A C T A D O S ,  N O  C O N T A C T A D O S  Y  P E R D I D O S
      $("#<?= $lv_sec; ?> #tblcnt tbody tr").remove();
      $("#<?= $lv_sec; ?> #tblcnt tbody").append("<tr class='text-center'><td colspan='10'><i class='far fa-spin fa-cog'></i></td></tr>");
      tmssCallProcessNoBackdrop("?prg=zcutjv&act=dsh", [{ name: "typ", value: "contacted" }, {name:"vewmaxrec", value:lv_fltint["maxrec"]}, {name:"vewfldflt", value:lv_fltint["fltstr"]}], function (data){
				$("#<?= $lv_sec; ?> #tblcnt tbody tr").remove();
        $("#<?= $lv_sec; ?> #tblcnt thead tr th").remove();
        $("#<?= $lv_sec; ?> #tblcnt thead tr").append("<th id='contacted'>Contactados</th><th id='not-contacted'>No Contactados</th><th id='lost'>Perdidos</th>");
        
        // agrego una fila para las dos columnas correspondientes a los tres estados posibles (Contactado, No Contactado y Perdido).
        $("#<?= $lv_sec; ?> #tblcnt tbody").append("<tr id='cntrow'></tr>");
        $("#<?= $lv_sec; ?> #tblcnt tbody tr#cntrow").append("<td id='contacted' data-val=0></td><td id='not-contacted' data-val=0></td><td id='lost' data-val=0></td><td id='TOTAL'>0</td>");
        
        // agrego una columna para el TOTAL.
        $("#<?= $lv_sec; ?> #tblcnt thead tr").append("<th id='TOTAL'>TOTAL</th>")
        
        var lv_tot = 0;
        for(var i=0; i<data.length; i++){
          if(data[i]["crmcntststxt"] == "SIN ASIGNAR" || data[i]["crmcntststxt"] == "00-LANDING"){
            // guardo el índice de la columna para los tickets de clientes no contactados.
            var lv_colind = $("#<?= $lv_sec; ?> #tblcnt thead tr th#not-contacted").index();
          } else if (data[i]["crmcntststxt"] == "04-PERDIDO"){
            // hago lo mismo para los clientes perdidos.
            var lv_colind = $("#<?= $lv_sec; ?> #tblcnt thead tr th#lost").index();
        	} else{ // hago lo mismo para los clientes ya contactados.
            var lv_colind = $("#<?= $lv_sec; ?> #tblcnt thead tr th#contacted").index();
          }
          // guardo el valor actual de la celda.
          var lv_celval = parseInt($("#<?= $lv_sec; ?> #tblcnt tbody tr#cntrow").children().eq(lv_colind).attr('data-val'));
          // sumo la cantidad del elemento actual del data a la variable auxiliar y al total con el valor de la celda.
          lv_celval += data[i]["qty"];
          lv_tot += data[i]["qty"];
          // actualizo el valor de la celda (el valor del texto y el valor interno) con el valor de la variable auxiliar.
          $("#<?= $lv_sec; ?> #tblcnt tbody tr#cntrow").children().eq(lv_colind).text(lv_celval);
          $("#<?= $lv_sec; ?> #tblcnt tbody tr#cntrow").children().eq(lv_colind).attr('data-val', lv_celval);
      	}
        $("#<?= $lv_sec; ?> #tblcnt tbody tr td#TOTAL").html(lv_tot);
      });
      
      
      //   E F I C I E N C I A  P O R  U S U A R I O S
			$("#<?= $lv_sec; ?> #tblprg tbody tr").remove();
			$("#<?= $lv_sec; ?> #tblprg thead").html("<tr><th>Reuniones</th></tr>");
			$("#<?= $lv_sec; ?> #tblprg tbody").append("<tr class='text-center'><td colspan='10'><i class='far fa-spin fa-cog'></i></td></tr>");
      tmssCallProcessNoBackdrop("?prg=zcutjv&act=dsh", [{ name: "typ", value: "active" }, {name:"vewmaxrec", value:lv_fltint["maxrec"]}, {name:"vewfldflt", value:lv_fltint["fltstr"]}], function (data){
				$("#<?= $lv_sec; ?> #tblprg tbody tr").remove();
        var lv_sts="";
        for(var i=0; i<data.length; i++){
          if(data[i]["crmcntststxt"] != 'SIN ASIGNAR'){
						if(lv_sts!=data[i]["crmcntststxt"]){
              $("#<?= $lv_sec; ?> #tblprg tbody").append("<tr data-status='"+data[i]["crmcntststxt"]+"'><td>"+data[i]["crmcntststxt"]+"</td></tr>");
              lv_sts=data[i]["crmcntststxt"];
            }
            if($("#<?= $lv_sec; ?> #tblprg thead tr td[data-user='"+data[i]["usrcod"]+"']").length==0){
              if (data[i].usrcod != ''){
                $("#<?= $lv_sec; ?> #tblprg thead tr").append("<td data-user='"+data[i]["usrcod"]+"'>"+data[i]["usrcod"]+"</td>");
              }
            }
          }
        }
        $("#<?= $lv_sec; ?> #tblprg thead tr").append("<td data-user='SIN_ASIGNAR'>SIN ASIGNAR</td>");	
        
        // reinicio el lv_sts
        lv_sts = "";
        for(var i=0; i<data.length; i++){
        	if(data[i]['crmcntststxt'] != lv_sts){
            // agregar todas las columnas que faltan
            var lv_mis = ("<td data-val=0></td>").repeat( $("#<?= $lv_sec; ?> #tblprg thead tr td").length );
            $("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").append(lv_mis);
            lv_sts=data[i]["crmcntststxt"];
        	}
        }
        
        var lv_mis = ("<td>0</td>").repeat( $("#<?= $lv_sec; ?> #tblprg thead tr td").length );
        $("#<?= $lv_sec; ?> #tblprg tbody").append("<tr data-status='TOTAL'><td>TOTAL</td>"+lv_mis+"</tr>");
        
        // asigno el usrcod de cada columna a cada celda de dicha columna.
        for(var i=1; i<($("#<?= $lv_sec; ?> #tblprg thead tr td").attr("data-user")).length; i++){
          $("#<?= $lv_sec; ?> #tblprg tbody tr").each(function() {
            $(this).find("td:eq("+i+")").attr('name', $("#<?= $lv_sec; ?> #tblprg thead tr td:eq("+(i-1)+")").attr("data-user"));
          });
        }
        
        for(var i=0; i<data.length; i++){
          if (data[i]['crmcntststxt'] != 'SIN ASIGNAR'){
           	var lv_colind = $("#<?= $lv_sec; ?> #tblprg thead tr td[data-user='"+data[i]["usrcod"]+"']").index();
            var lv_celval = parseInt($("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").children().eq(lv_colind).attr('data-val'));
            lv_celval += data[i]["qty"];
            $("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").children().eq(lv_colind).text(lv_celval);
            $("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").children().eq(lv_colind).attr('data-val', lv_celval);
            var lv_totval = parseInt($("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='TOTAL']").children().eq(lv_colind).text());
            lv_totval += data[i]["qty"];
            $("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='TOTAL']").children().eq(lv_colind).text(lv_totval); 
          } else{
            var lv_totval = parseInt($("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='TOTAL']").children().eq(-1).text());
            lv_totval += data[i]["qty"];
            $("#<?= $lv_sec; ?> #tblprg tbody tr[data-status='TOTAL']").children().eq(-1).text(lv_totval);
          }
        }
      });
      
      
      // S E P A R A D O S  P O R  A Ñ O  D E  E G R E S O ( I N C L U Í D O S  L O S  D E  L A N D I N G )
      $("#<?= $lv_sec; ?> #tblendyer tbody tr").remove();
			$("#<?= $lv_sec; ?> #tblendyer tbody").append("<tr class='text-center'><td colspan='10'><i class='far fa-spin fa-cog'></i></td></tr>");
      tmssCallProcessNoBackdrop("?prg=zcutjv&act=dsh", [{ name: "typ", value: "form" }, {name:"vewmaxrec", value:lv_fltint["maxrec"]}, {name:"vewfldflt", value:lv_fltint["fltstr"]}], function (data){
				$("#<?= $lv_sec; ?> #tblendyer tbody tr").remove();
        //reordeno el array data por estados.
        data.sort((a, b) => {
          if (a.crmcntststxt > b.crmcntststxt) return -1;
          if (a.crmcntststxt < b.crmcntststxt) return 1;
          return 0;
        });
        //agrego todos los estados a las filas de la tabla sin que se repitan.
        var lv_sts="";
        for(var i=0; i<data.length; i++){
          if(lv_sts!=data[i]["crmcntststxt"]){
            $("#<?= $lv_sec; ?> #tblendyer tbody").append("<tr data-status='"+data[i]["crmcntststxt"]+"'><td>"+data[i]["crmcntststxt"]+"</td></tr>");
            lv_sts=data[i]["crmcntststxt"];
          }
        }
          
        //tomo todas las fechas de egreso y me quedo únicamente con sus años.
        for(var i=0; i<data.length; i++){
          if (data[i].egreso != ''){
            data[i].egreso = data[i].egreso.slice(-4)
          }

        //agrego todos los posibles años de egreso a la cabecera de la tabla.
          if($("#<?= $lv_sec; ?> #tblendyer thead tr td[data-grad='"+data[i].egreso+"']").length==0){
            if (data[i].egreso != ''){
              $("#<?= $lv_sec; ?> #tblendyer thead tr").append("<td data-grad='"+data[i].egreso+"'>"+data[i].egreso+"</td>");
            }
          }
        }
        
        // reseteo el lv_sts.
        lv_sts="";
        for(var i=0; i<data.length; i++){
        	if(data[i]['crmcntststxt'] != lv_sts){
            // agregar todas las columnas que faltan
            var lv_mis = ("<td data-val=0></td>").repeat( $("#<?= $lv_sec; ?> #tblendyer thead tr td").length );
            $("#<?= $lv_sec; ?> #tblendyer tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").append(lv_mis);
            lv_sts=data[i]["crmcntststxt"];
        	}
        }
        
        var lv_mis = ("<td>0</td>").repeat( $("#<?= $lv_sec; ?> #tblendyer thead tr td").length );
        $("#<?= $lv_sec; ?> #tblendyer tbody").append("<tr data-status='TOTAL'><td>TOTAL</td>"+lv_mis+"</tr>");
        
        // asigno el egreso de cada columna a cada celda de dicha columna.
        for(var i=1; i<($("#<?= $lv_sec; ?> #tblendyer thead tr td").attr("data-grad")).length; i++){
          $("#<?= $lv_sec; ?> #tblendyer tbody tr").each(function() {
            $(this).find("td:eq("+i+")").attr('name', $("#<?= $lv_sec; ?> #tblendyer thead tr td:eq("+(i-1)+")").attr("data-grad"));
          });
        }
        
        // sumo las cantidades a cada celda correspondiente.
        for(var i=0; i<data.length; i++){
          if (data[i].egreso != ''){
            // guardo el índice de la columna y el valor actual de la celda
            var lv_colind = $("#<?= $lv_sec; ?> #tblendyer thead tr td[data-grad='"+data[i]["egreso"]+"']").index();
            var lv_celval = parseInt($("#<?= $lv_sec; ?> #tblendyer tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").children().eq(lv_colind).attr('data-val'));
            // sumo la cantidad del elemento actual del data a la variable auxiliar con el valor de la celda.
            lv_celval += data[i]["qty"];
            // actualizo el valor de la celda (el valor del texto y el valor interno) con el valor de la variable auxiliar.
            $("#<?= $lv_sec; ?> #tblendyer tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").children().eq(lv_colind).text(lv_celval);
            $("#<?= $lv_sec; ?> #tblendyer tbody tr[data-status='"+data[i]["crmcntststxt"]+"']").children().eq(lv_colind).attr('data-val', lv_celval);
            // guardo el valor total actual en una variable auxiliar, sumo la cantidad actual a esa variable y actualizo el valor total.
            var lv_totval = parseInt($("#<?= $lv_sec; ?> #tblendyer tbody tr[data-status='TOTAL']").children().eq(lv_colind).text());
            lv_totval += data[i]["qty"];
            $("#<?= $lv_sec; ?> #tblendyer tbody tr[data-status='TOTAL']").children().eq(lv_colind).text(lv_totval); 
          }
        }
      });
		}
    $(function(){ <?= $lv_sec; ?>_refresh(); });
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>