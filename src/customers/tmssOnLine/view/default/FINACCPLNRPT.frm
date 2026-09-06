<?php	
  $lv_lnk = '?prg=finaccpln';
	$vew_input->RequiredFields( array() );
	$lv_dockey = isset($vew_data->finaccplncod) ? $vew_data->finaccplncod : '';
	$lv_title = 'Resumen de Cuentas';
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'PRT';
  $vew_actcod = '02';

	include_once('_library.frm');
  // Botones por vista
  $vew_tbl['btnexe'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->execute, 'id'=>'btnexe','icn'=>'fas fa-bolt', 'css'=>'btn navbar-btn btn-success tmssAlwaysEnabled ', 'acc'=>'' );
  $vew_tbl['sveL'] = array('per'=>false);
  $vew_tbl['sveR'] = array('per'=>false);
  $vew_tbl['canc'] = array('per'=>false);
  $vew_tbl['accL'] = array('per'=>false);
	$vew_tbl['accR'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['delsep'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
  $vew_tbl['rfrsh']=array('per'=>true,'pos'=>'','ttl'=>$vew_lang->refresh,'icn'=>'fas fa-sync-alt','css'=>'tmss-Opt','acc'=>$lv_sec.'_fnc({action: '.chr(39).'finaccplnrpt'.chr(39).'});');

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">  
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">    
    <?= gethtml('tmss_actcod','hidden',$vew_actcod); ?>
    <?= gethtml('finaccplncod','hidden',''); ?>

		<div class="container-fluid">
			<!-- CARD: Filtros -->
			<div class="card" id="rptflt">
				<div class="card-header"><div class="card-title"><i class="fas fa-chart-bar"></i> <?= $lv_title; ?></div></div>
				<div class="card-body tmss-card-body-edit">
					<div class="row">
						<!-- Plan de Cuentas -->
						<div class="col-md-6">
							<div class="form-group tmss-form-group">
								<label class="col-md-12 control-label"><?= $vew_lang->ChartOfAccounts; ?></label>
								<div class="col-md-12">
									<?php echo vew_boot(array('style'=>'search'), 
										array('input'=>gethtml('finaccplntxt','typeahead','',$lv_default))); ?>
								</div>
							</div>
						</div>
						<!-- Período -->
						<div class="col-md-4 hidden" id="divfintaxexeper">
							<div class="form-group tmss-form-group">
								<label class="col-md-12 control-label"><?= $vew_lang->period; ?></label>
								<div class="col-md-12">
									<select id="fintaxexepercod" class="form-control input-sm">
										<option value="">-- Cargando... --</option>
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<!-- Estado Actual -->
						<div class="col-md-4">
							<div class="form-group tmss-form-group">
								<label class="col-md-12 control-label">&nbsp;</label>
								<div class="col-md-12">
									<div class="checkbox">
										<label>
											<input type="checkbox" id="chkcur" checked>Estado Actual
										</label>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- CARD: Resultados -->
			<div class="card hidden" id="rptcrd">
				<div class="card-header">
					<div class="card-title"><i class="fas fa-sitemap"></i> <span id="rptplntxt"></span>
						<a class="card-icon text-center tmssAlwaysEnabled hidden" id="btndwnrpt" title="Descargar"><i class="fas fa-download"></i></a>
						<span class="text-muted small" id="rptcurtxt"></span>
					</div>
				</div>
				<div class="card-body">
					<div class="tmss-vertbl-scroll">
						<table id="rpttbl" class="table table-condensed table-hover">
							<thead>
								<tr>
									<th class="text-center"></th>
									<th>C&oacute;digo</th>
									<th>Rubro / Cuenta</th>
									<th class="text-right">Debe</th>
									<th class="text-right">Haber</th>
									<th class="text-right">Saldo Cta.</th>
									<th class="text-right">Saldo Plan</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="card-footer" id="rptsum"></div>
			</div>
    </div>
  </form>
  <script>
    // TYPEAHEADS
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"finaccplntxt":"finaccplntxt","finaccplncod":"finaccplncod"},"typeahead":true};
    tmssTypeahead($("#<?= $lv_sec; ?> #finaccplntxt"), "finaccpln", lo_get);
    
    $(function(){
      // CARGAR ÚLTIMOS 20 PERÍODOS AL INICIAR
      tmssCallProcess("?prg=finaccpln&act=finaccplnperlist", [], function(lo_res){
        let lo_perdat = lo_res.data || [];
        let lo_persel = $("#<?= $lv_sec; ?> #fintaxexepercod");
        lo_persel.html("");
        if(!lo_perdat || lo_perdat.length === 0){
          lo_persel.append("<option value=''>-- Sin períodos --</option>");
          return;
        }
        lo_persel.append("<option value=''></option>");
        for(let i = 0; i < lo_perdat.length; i++){
          let lo_per = lo_perdat[i];
          let lv_strdteraw = lo_per.fintaxexeperstrdte;
          let lv_enddteraw = lo_per.fintaxexeperenddte;
          let lv_strdte = lv_strdteraw ? moment(typeof lv_strdteraw === 'object' ? lv_strdteraw.date : lv_strdteraw).format("DD/MM/YYYY") : "";
          let lv_enddte = lv_enddteraw ? moment(typeof lv_enddteraw === 'object' ? lv_enddteraw.date : lv_enddteraw).format("DD/MM/YYYY") : "";
          let lv_perlbl = lv_strdte + " - " + lv_enddte + (lo_per.fintaxexetxt ? " (" + lo_per.fintaxexetxt + ")" : "");
          lo_persel.append("<option value='" + lo_per.fintaxexepercod + "'>" + lv_perlbl + "</option>");
        }
      });
    });
    
    // TOGGLE ESTADO ACTUAL
    $("#<?= $lv_sec; ?> #chkcur").on("change", function(){
      if($(this).is(":checked")) {
        $("#<?= $lv_sec; ?> #divfintaxexeper").addClass("hidden");
        $("#<?= $lv_sec; ?> #fintaxexepercod").val("");
      } else {
        $("#<?= $lv_sec; ?> #divfintaxexeper").removeClass("hidden");
      }
    });
    
    // GENERAR REPORTE
    $("#<?= $lv_sec; ?> #btnexe").on("click", function(e){ e.preventDefault();
      let lv_plncod = $("#<?= $lv_sec; ?> #finaccplncod").val();
      if(!lv_plncod || lv_plncod=='' || lv_plncod=='0') { toastr.warning("Seleccione un Plan de Cuentas."); return; }

      let lv_iscur = $("#<?= $lv_sec; ?> #chkcur").is(":checked");
      let lv_percod = lv_iscur ? '' : ($("#<?= $lv_sec; ?> #fintaxexepercod").val() || '');

      let lo_pst = [
        {name:"finaccplncod", value:lv_plncod},
        {name:"fintaxexecod", value:""},
        {name:"fintaxexepercod", value:lv_percod}
      ];
      
      tmssCallProcess("?prg=finaccpln&act=finaccplnrptdat", lo_pst, function(lo_res){
        let lo_dat = lo_res.data || [];
        if(!lo_dat || lo_dat.length==0) { toastr.warning("No se encontraron cuentas."); return; }
        <?= $lv_sec; ?>_buildTreeGrid(lo_dat);
        $("#<?= $lv_sec; ?> #rptcrd").removeClass("hidden");
        let lv_plntxt = $("#<?= $lv_sec; ?> #finaccplncod").closest('.input-group').find('input').first().val() || lv_plncod;
        let lv_plncurcod = lo_dat[0].plncurcod || "";
        $("#<?= $lv_sec; ?> #rptplntxt").html('<a href="#" id="plnlnk" data-cod="'+lv_plncod+'">#'+lv_plntxt+'</a>');
        $("#<?= $lv_sec; ?> #plnlnk").off("click").on("click", function(e){
          e.preventDefault();
          tmssLink('?prg=finaccpln&act=03&prm_finaccplncod=' + $(this).data("cod"), [{target: "_new_section"}]);
        });
        $("#<?= $lv_sec; ?> #rptcurtxt").text("Moneda del plan: " + lv_plncurcod);
        $("#<?= $lv_sec; ?> #btndwnrpt").removeClass("hidden");
      });
    });

    // BUILD TREEGRID
    function <?= $lv_sec; ?>_buildTreeGrid(lo_dat) {
      let lv_buf = "";
      let lo_sub = {};
      let lv_plncurcod = lo_dat.length > 0 ? (lo_dat[0].plncurcod||"") : "";

      // Calcular subtotales (bottom-up)
      for(let i = lo_dat.length-1; i >= 0; i--) {
        let lo_row = lo_dat[i];
        let lv_lvl = lo_row.finaccplnlvl||"";
        if(lo_row.nodtyp==="account") {
          let lv_totbse = parseFloat(lo_row.finacctotbse)||0;
          lo_sub[lv_lvl] = lv_totbse;
          let lo_parts = lv_lvl.split(".");
          while(lo_parts.length>1) { lo_parts.pop(); let lv_pk=lo_parts.join("."); lo_sub[lv_pk]=(lo_sub[lv_pk]||0)+lv_totbse; }
        }
      }

      let lo_tots = {'A':0,'P':0,'PN':0,'R+':0,'R-':0};

      for(let i=0; i<lo_dat.length; i++) {
        let lo_row = lo_dat[i];
        let lv_lvl = lo_row.finaccplnlvl||"";
        let lv_txt = lo_row.finaccplnlvltxt||"";
        let lv_nodtyp = lo_row.nodtyp||"folder";
        let lv_clscod = (lo_row.finaccclscod||"").toUpperCase();
        let lv_curcod = (lo_row.curcod||"").toUpperCase();
        let lv_dep = lv_lvl.split(".").length;
        let lv_saldo=0, lv_salbse=0, lv_debe=0, lv_haber=0;
        
        if(lv_nodtyp==="account") {
          lv_saldo  = parseFloat(lo_row.finacctot)||0;
          lv_salbse = parseFloat(lo_row.finacctotbse)||0;
          lv_debe   = parseFloat(lo_row.finaccperdeb)||0;
          lv_haber  = parseFloat(lo_row.finaccperhab)||0;
          // Si estado actual, calcular debe/haber desde saldo
          if(lv_debe===0 && lv_haber===0) {
            if(lv_saldo>=0){lv_debe=Math.abs(lv_saldo);lv_haber=0;}else{lv_debe=0;lv_haber=Math.abs(lv_saldo);}
          }
          if(lv_clscod && lo_tots.hasOwnProperty(lv_clscod)) lo_tots[lv_clscod]+=lv_salbse;
        } else {
          lv_salbse = lo_sub[lv_lvl]||0;
        }

        // Tiene hijos?
        let lv_haskids = false;
        if(lv_nodtyp==="folder") {
          for(let j=i+1;j<lo_dat.length;j++){
            let lv_chlvl=lo_dat[j].finaccplnlvl||"";
            if(lv_chlvl.startsWith(lv_lvl+".")) {lv_haskids=true;break;}
            if(!lv_chlvl.startsWith(lv_lvl)) break;
          }
        }

        let lv_csscta = lv_nodtyp==="account" ? (lv_saldo>0?"text-success":(lv_saldo<0?"text-danger":"text-muted")) : "";
        let lv_csspln = lv_salbse>0?"text-success":(lv_salbse<0?"text-danger":"text-muted");
        let lv_tgl = (lv_nodtyp==="folder"&&lv_haskids) ? "<span class='treegrid-toggle cursor-pointer text-muted fas fa-chevron-down' data-lvl='"+lv_lvl+"'></span>" : "";
        let lv_ico = lv_nodtyp==='folder' ? '<i class="fas fa-folder-open text-warning"></i> ' : '<i class="fas fa-file text-muted"></i> ';
        
        let lv_rowcss = (lv_nodtyp==="folder") ? "active" : "";
        let lv_lbllvl = (lv_nodtyp==="folder") ? "<strong>"+lv_lvl+"</strong>" : lv_lvl;
        let lv_lbltxt = (lv_nodtyp==="folder") ? "<strong>"+lv_ico+lv_txt+"</strong>" : (lo_row.finacccod ? "<a href='#' class='acclnk' data-cod='"+lo_row.finacccod+"'>"+lv_ico+lv_txt+"</a>" : lv_ico+lv_txt);

        lv_buf += "<tr class='"+lv_rowcss+"' data-lvl='"+lv_lvl+"' data-nodtyp='"+lv_nodtyp+"' data-depth='"+lv_dep+"'>";
        lv_buf += "<td class='text-center'>"+lv_tgl+"</td>";
        lv_buf += "<td><span>"+lv_lbllvl+"</span></td>";
        lv_buf += "<td><span>"+lv_lbltxt+"</span></td>";
        lv_buf += "<td class='text-right'>"+(lv_nodtyp==="account"?<?= $lv_sec; ?>_fmt(lv_debe):"")+"</td>";
        lv_buf += "<td class='text-right'>"+(lv_nodtyp==="account"?<?= $lv_sec; ?>_fmt(lv_haber):"")+"</td>";
        lv_buf += "<td class='text-right "+lv_csscta+"'><strong>"+(lv_nodtyp==="account"?(<?= $lv_sec; ?>_fmt(lv_saldo)+" "+lv_curcod):"")+"</strong></td>";
        lv_buf += "<td class='text-right "+lv_csspln+"'><strong>"+<?= $lv_sec; ?>_fmt(lv_salbse)+" "+lv_plncurcod+"</strong></td>";
        lv_buf += "</tr>";
      }

      // Resumen
      let lv_sum = "<div class='row text-center'>";
      let lo_sumkeys = [['A','Activo'],['P','Pasivo'],['PN','Patrimonio Neto'],['R+','Resultado (+)'],['R-','Resultado (-)']];
      for(let lo_k of lo_sumkeys){
        let lv_totval = lo_tots[lo_k[0]];
        let lv_totcss = lv_totval>=0?"text-success":"text-danger";
        lv_sum += "<div class='col-xs-2'><span class='text-muted small text-uppercase'>"+lo_k[1]+"</span><br/><strong class='"+lv_totcss+"'>"+<?= $lv_sec; ?>_fmt(lv_totval)+" "+lv_plncurcod+"</strong></div>";
      }
      let lv_reseje = lo_tots['R+']+lo_tots['R-'];
      lv_sum += "<div class='col-xs-2'><span class='text-muted small text-uppercase'>Resultado Ejercicio</span><br/><strong class='"+(lv_reseje>=0?"text-success":"text-danger")+"'>"+<?= $lv_sec; ?>_fmt(lv_reseje)+" "+lv_plncurcod+"</strong></div>";
      lv_sum += "</div>";
      $("#<?= $lv_sec; ?> #rptsum").html(lv_sum);

      tmssLoadScript("table", function(){
        // Destruir y reinicializar bootstrap-table
        try {
          $("#<?= $lv_sec; ?> #rpttbl").bootstrapTable('destroy');
        } catch(e){}

        $("#<?= $lv_sec; ?> #rpttbl tbody").empty();
        $("#<?= $lv_sec; ?> #rpttbl tbody").html(lv_buf);

        $("#<?= $lv_sec; ?> #rpttbl").bootstrapTable({
          classes: 'table table-condensed table-hover table-striped',
          search: true,
          formatSearch:function(){return 'Buscar...';},
          showColumns: true,
          showToggle: false,
          locale: 'es-AR'
        });

        // Bind link clicks on account rows
        $("#<?= $lv_sec; ?> #rpttbl").off("click", ".acclnk").on("click", ".acclnk", function(e){
          e.preventDefault();
          tmssLink('?prg=finacc&act=03&prm_finacccod=' + $(this).data("cod"), [{target: "_new_section"}]);
        });

        // Bind toggles
        $("#<?= $lv_sec; ?> #rpttbl").off("click",".treegrid-toggle").on("click",".treegrid-toggle",function(e){
          e.preventDefault(); e.stopPropagation();
          let lv_tgllvl = String($(this).data("lvl"));
          if($(this).hasClass("fa-chevron-down")){
            $(this).removeClass("fa-chevron-down").addClass("fa-chevron-right");
            $("#<?= $lv_sec; ?> #rpttbl tbody tr").each(function(){
              if(String($(this).data("lvl")).startsWith(lv_tgllvl+".")) $(this).addClass("hidden");
            });
          } else {
            $(this).removeClass("fa-chevron-right").addClass("fa-chevron-down");
            $("#<?= $lv_sec; ?> #rpttbl tbody tr").each(function(){
              let lv_rowlvl = String($(this).data("lvl"));
              if(lv_rowlvl.startsWith(lv_tgllvl+".") && lv_rowlvl.substring(lv_tgllvl.length+1).indexOf(".")===-1){
                $(this).removeClass("hidden");
                $(this).find(".treegrid-toggle").removeClass("fa-chevron-down").addClass("fa-chevron-right");
              }
            });
          }
        });
      });
    }

    function <?= $lv_sec; ?>_fmt(v) {
      if(v===0||v===null||v===undefined) return "0.00";
      return parseFloat(v).toLocaleString('en-US',{minimumFractionDigits:2,maximumFractionDigits:2});
    }
  </script>

  <script>
    // DESCARGAR XLS
    tmssLoadScript("sheetjs", function(){
      $("#<?= $lv_sec; ?> #btndwnrpt").on("click", function(e){ e.preventDefault();
        try {
          let lo_rows = [["CODIGO","RUBRO / CUENTA","TIPO","DEBE","HABER","SALDO CTA","SALDO PLAN"]];
          $("#<?= $lv_sec; ?> #rpttbl tbody tr").each(function(){
            let lo_tds = $(this).find("td");
            lo_rows.push([
              $(this).data("lvl"),
              lo_tds.eq(2).text().trim(),
              ($(this).data("nodtyp")==='folder'?'RUBRO':'CUENTA'),
              lo_tds.eq(3).text().trim(),
              lo_tds.eq(4).text().trim(),
              lo_tds.eq(5).text().trim(),
              lo_tds.eq(6).text().trim(),
              lo_tds.eq(7).text().trim()
            ]);
          });
          let lo_ws = XLSX.utils.aoa_to_sheet(lo_rows);
          lo_ws["!cols"] = [{wch:15},{wch:45},{wch:10},{wch:8},{wch:18},{wch:18},{wch:18},{wch:18}];
          let lo_wb = XLSX.utils.book_new();
          XLSX.utils.book_append_sheet(lo_wb, lo_ws, "Balance General");
          let lv_bin = XLSX.write(lo_wb, {bookType:'biff8', type:'binary'});
          let lo_buf = new ArrayBuffer(lv_bin.length);
          let lo_view = new Uint8Array(lo_buf);
          for(let i=0; i!=lv_bin.length; ++i) lo_view[i] = lv_bin.charCodeAt(i)&0xFF;
          let lo_blob = new Blob([lo_buf], {type:'application/vnd.ms-excel'});
          let lo_lnk = document.createElement('a');
          lo_lnk.href = window.URL.createObjectURL(lo_blob);
          lo_lnk.download = "Balance_General.xls";
          lo_lnk.click();
        } catch(e) { console.error(e); toastr.warning("Error: "+e.message); }
      });
    });
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>