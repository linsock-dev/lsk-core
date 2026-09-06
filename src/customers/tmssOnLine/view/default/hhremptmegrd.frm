<?php
	// url del formulario
  $lv_lnk = '?prg=hhremptme&act=timegrid';

	// campos requeridos
	$vew_input->RequiredFields( array('') );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->timegrid;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'TGR';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['flt'] = array('pos'=>'R', 'per'=>true, 'ttl'=>'', 'id'=>'btnflt', 'icn'=>'fas fa-filter', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn '.($vew_actcod != '02' ? ' tmssHiddeOnEdit':''), 'acc'=>'');	
	$vew_tbl['rfrsh'] = array('per'=>true, 'pos'=>'D', 'ttl'=>$vew_lang->refresh, 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_refresh();');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
	<style>
	.tmss-calgrid-holiday{
		background-color: #00bcd4 !important;
	}
	.tmss-calgrid-noworkingday{
		background-color: #f1f1f1;
	}
	</style>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('vewflt','hidden',''); ?>
		
		<div class="container-fluid">
			<?= vew_boot($lv_col39,array('label'=>$vew_lang->period,'input'=>gethtml('curdte','doccmt1x20',$vew_data->plnmthyth,$lv_default))); ?>

			<table class="table table-condensed table-bordered table-hover" id="tmegrd">
				<thead></thead>
				<tbody></tbody>
			</table>		
		</div> <!-- /container-fluid -->
  </form>
	
	<script>
    $(function(){
			//agrega un badge al filtro
			$("#<?= $lv_sec; ?> #btnflt").append("<span id='fltcnt' class='badge'></span>");
			$("#<?= $lv_sec; ?> #curdte").prop("value","<?= date_format($vew_data->curdte, 'm/Y'); ?>").trigger("change");
    });
    
    // añade el datepicer a la barra de desplazamiento
    $("#<?= $lv_sec; ?> #curdte").datepicker({
        format: "mm/yyyy",
        startView: "months", 
        minViewMode: "months"
    }).on("change",function(e){
      //cierra el datepicker cuando se selecciona un mes
      $('.datepicker').hide();      
      //cambia el valor del campo fecha
			$(this).data("mth", $(this).val().split("/")[0] );
      $(this).data("yth", $(this).val().split("/")[1] );
      //recarga la vista
      <?= $lv_sec; ?>_refresh();
    });
	</script>
	<script>
    //FILTRO PERSONALIZADO
		var gv_<?= $lv_sec; ?>_flt=[{"fldttl": "<?= $vew_lang->id; ?>"   ,"fldcod": "p.hhrempcod", "fldtyp": "TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->name; ?>" ,"fldcod": "p.hhremptxt", "fldtyp": "TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldcod": "vewmaxrec","fldvalstr": "<?= ($vew_data->vewmaxrec!=''?$vew_data->vewmaxrec:'1000') ?>"}];

		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_filter);
		});

		//Filtros
		function <?= $lv_sec; ?>_filter(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="1000";}

			if(lv_fltint!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
				$("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_fltint));
				<?= $lv_sec; ?>_refresh();
			}
		}

		$(function(){
			gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , "<?= $vew_data->vewflt; ?>" );
			var lv_tmp = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			$("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_tmp));
			$("#<?= $lv_sec; ?> #fltcnt").text( (lv_tmp["fltqty"]==0?"":lv_tmp["fltqty"]) );
		});
	</script>
	<script>
		function <?= $lv_sec; ?>_refresh(){
      var lv_yth = Number($("#<?= $lv_sec; ?> #curdte").data("yth"));
			var lv_mth = Number($("#<?= $lv_sec; ?> #curdte").data("mth"));
      var lv_daysInMonth = ( 32 - new Date(lv_yth, lv_mth-1, 32).getDate() );
      var lv_enddteref = new Date(lv_yth, lv_mth-1, lv_daysInMonth);
      lv_enddteref.setDate( lv_enddteref.getDate()+6 );
			var lv_pstdat =[{name:"vewfld",value:$("#<?= $lv_sec; ?> #vewflt").val()},
											{name:"maxrec",value:$("#<?= $lv_sec; ?> #maxrec").val()},
											{name:"plnyth",value:lv_yth},
											{name:"plnmth",value:lv_mth},
                      {name:"strdte",value:lv_yth+"-"+(lv_mth<10?"0":"")+lv_mth+"-01"},
											{name:"enddte",value:lv_enddteref.toISOString().split("T")[0]}
                     ];
			tmssCallProcess("?prg=hhremptme&act=timegrid_data",lv_pstdat,function(data){
				
				// CABECERA. armo la cabecera del mes
				$("#<?= $lv_sec; ?> #tmegrd thead tr").remove();
				var lv_hdr = "<tr><td><?= $vew_lang->employee; ?></td>";
				var lv_dawt = {1:"Lun",2:"Mar",3:"Mie",4:"Jue",5:"Vie",6:"Sab",7:"Dom"};
				var lv_caldaystr = "";
        if (data.cal && data.cal.grlcalatr) {
          var lv_calarr = JSON.parse(data.cal.grlcalatr,true);
          // armo string de dias laborables
          for(var i=0; i<lv_calarr.calrng.length; i++){lv_caldaystr+=lv_calarr.calrng[i].tmeday;} 
        }
        lv_caldaystr = "LMXJV";
        var lv_daw = moment(data.strdte.date).isoWeekday(); // dia de la semana 1-lunes / 7-domingo
				var lv_str = Number( moment(data.strdte.date).format("D") );
				var lv_end = Number( moment(data.enddte.date).format("D") );
				// recorro dias del mes
				for(var i=lv_str;i<lv_end;i++){
					// determino si el dia es laboral (extraigo la letra del dia actual y la busco en la cadena de dias laborables)
					var lv_workday = (lv_caldaystr.indexOf( ("LMXJVSD").substr(lv_daw-1,1) )<0?false:true);
					// busco si para la fecha hay un feriado
					var lv_hldtxt = "";
					for(var x=0; x<data.hld.length; x++){
						if(i==Number(moment(data.hld[x].hldmovday.date).format("D"))){ lv_hldtxt=data.hld[x].hldtxt; }
					}
					// escritura de la columna
					lv_hdr += "<td class='"+(lv_hldtxt!=""?"tmss-calgrid-holiday ":"")+(lv_workday==false?"tmss-calgrid-noworkingday ":"")+"text-center' "+(lv_hldtxt!=""?" title='"+lv_hldtxt+"'":"")+">"+lv_dawt[lv_daw]+"<br>"+i+"</td>";
					lv_daw = (lv_daw+1>7?1:lv_daw+1);
				}
				lv_hdr += "</tr>";
				$("#<?= $lv_sec; ?> #tmegrd thead").append( lv_hdr );
				
				// POSICIONES. completo posiciones con empleados
				var lv_row;
				$("#<?= $lv_sec; ?> #tmegrd tbody tr").remove();
				for(const key in data.emparr){					
					//var lv_cols = $("#<?= $lv_sec; ?> #tmegrd thead tr:first td").length;
					var lv_row = "<tr><td>"+data.emparr[key].emp.hhremptxt+"</td>";
					var lv_weekday = Number( moment(data.strdte.date).format("d") );
					for(var x=1; x<lv_end; x++){
						// determino si es dia laboral o feriado
						var lv_nowork = $("#<?= $lv_sec; ?> #tmegrd thead tr:first td:nth-child("+(x+1)+")").hasClass("tmss-calgrid-noworkingday");
						var lv_holiday= $("#<?= $lv_sec; ?> #tmegrd thead tr:first td:nth-child("+(x+1)+")").hasClass("tmss-calgrid-holiday");
						var lv_daycur = Number( moment(data.strdte.date).format("YYYYMM") ) * 100 + x;
						var lv_weekdaystr = ("LMXJVSD").substr(lv_weekday-1,1);
						
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
										lv_trnflg += "<i class='far fa-square' title='"+lv_dayarr.tmerng[xtrn2].tmestr+"-"+lv_dayarr.tmerng[xtrn2].tmeend+"'></i>";
									}
								}
								//lv_trnflg = "<i class='far fa-square' title='"+data.emparr[key].trn[xtrn].hhrtmerngtxt+"'></i>";
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
						lv_row += "<td class=' text-center "+(lv_nowork?"tmss-calgrid-noworkingday ":"")+(lv_holiday?"tmss-calgrid-holiday ":"")+"'>"+
											(lv_assflg!=""?lv_assflg:
											(lv_licflg!=""?lv_licflg:
											(lv_nowork || lv_holiday ? "": 
											(lv_trnflg!=""?lv_trnflg:""))))+"</td>";
						lv_weekday = (lv_weekday+1>7?1:lv_weekday+1);
					}
					
					lv_row += "</tr>";
					$("#<?= $lv_sec; ?> #tmegrd tbody").append(lv_row);
				}
				
			});
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>