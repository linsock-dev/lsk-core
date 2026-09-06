<?php
	// url del formulario
  $lv_lnk = '?prg=hhrtmerng&prm_hhrtmerngcod='.$vew_data->hhrtmerngcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrtmerngtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrtmerngcod;

	// titulo
	$lv_title = $vew_lang->timetable;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'TRN';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$lv_daytxt = array('L'=>'Lunes','M'=>'Martes','X'=>'Miercoles','J'=>'Jueves','V'=>'Viernes','S'=>'Sabado','D'=>'Domingo', 'F'=>'Feriado');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('hhrtmerngwekhrs', 'hidden', $vew_data->hhrtmerngwekhrs); ?>
		<textarea id="hhrtmerngatr" name="hhrtmerngatr" class="hidden"></textarea>
		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrtmerngcod; ?><?= gethtml('hhrtmerngcod', 'hidden', $vew_data->hhrtmerngcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('hhrtmerngcodext', 'doccodext', $vew_data->hhrtmerngcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrtmerngtxt', 'doccmt1x50', $vew_data->hhrtmerngtxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div><!-- /card -->
						</div><!-- /col-md-6 -->
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title">
                  <p class="col-md-9"> <?= $vew_lang->days; ?> </p> 
									<p class="col-md-3" style="display: flex; justify-content: flex-end;" id="hhrtmerngwekhrstxt">
                    <?= $vew_data->hhrtmerngwekhrs; ?> hrs
                  </p>
                </div></div>
								<div class="card-body tmss-card-body-edit">
                  <textarea id="hhrtmerng001" name="hhrtmerng001" class="hidden"></textarea>
									<div id="hhrtmerng001div" name="hhrtmerng001div"></div>
                  <?php
                  	//echo vew_boot($lv_colxs246, array('label'=>$vew_lang->WORKSEVERY.'...',
                  	echo vew_boot($lv_colxs246, array('label'=>'Tabaja cada...',
                                                     'input1'=>gethtml('hhrtmerngfrq', [1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6],  ($vew_data->hhrtmerngfrq ? $vew_data->hhrtmerngfrq : 1), $lv_default),
                                                     'label2'=>$vew_lang->days));
                  ?>
								</div>
							</div> <!-- /card -->
						</div> <!-- /col-md-6 -->
					</div> <!-- /row -->
          <div class="row">
            <div class="col-md-6">
							<textarea id="hhrtmerng001" name="hhrtmerng001" class="hidden"></textarea>
							<div id="hhrtmerng001div" name="hhrtmerng001div"></div>
						</div>
          </div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
		$("#<?= $lv_sec; ?> #btnadd").on("click",function(e){ e.preventDefault();
			var lv_day = $("#<?= $lv_sec; ?> #tmerngday").prop("value");
			var lv_daytxt = $("#<?= $lv_sec; ?> #tmerngday option:selected").text();
			var lv_str = $("#<?= $lv_sec; ?> #tmerngstr").prop("value");
			var lv_end = $("#<?= $lv_sec; ?> #tmerngend").prop("value");
			$("#<?= $lv_sec; ?> #tbltme tbody").append("<tr data-tmeday='"+lv_day+"' data-tmestr='"+lv_str+"' data-tmeend='"+lv_end+"'><td>"+lv_daytxt+"</td><td>"+lv_str+"</td><td>"+lv_end+"</td><td><a href='#' class='card-icon text-danger' onclick='<?= $lv_sec; ?>_removeTme($(this).parent().parent());'><i class='far fa-minus'></i></a></td></tr>");
			$("#<?= $lv_sec; ?> #tmerngstr").prop("value","");
			$("#<?= $lv_sec; ?> #tmerngend").prop("value","");			
			$("#<?= $lv_sec; ?> #tmerngday").prop("value","").focus();
		});
		function <?= $lv_sec; ?>_removeTme( lp_row ){
			$(lp_row).remove();
		}
	</script>
<script>
function <?= $lv_sec; ?>_totalHoursCount(lp_dat){
  var lv_tot = 0;
  for (var i = 0; i < lp_dat.length; i++) {
    var lv_tmestr = lp_dat[i]["tmestr"];
    var lv_tmeend = lp_dat[i]["tmeend"];
    if ((lv_tmestr ?? "") != "" && (lv_tmeend ?? "") != "") {
      if (lv_tmestr.indexOf(":") !== -1) {
        var lv_minstr = parseInt(lv_tmestr.substr(0, 2)) * 60 + parseInt(lv_tmestr.substr(3, 2))
      } else {
        var lv_minstr = Number(lv_tmestr) * 60;
      }

      if (lv_tmeend.indexOf(":") !== -1) {
        var lv_minend = parseInt(lv_tmeend.substr(0, 2)) * 60 + parseInt(lv_tmeend.substr(3, 2))
      } else {
        var lv_minend = Number(lv_tmeend) * 60;
      }
      var lv_mindif = (lv_minstr < lv_minend ? lv_minend - lv_minstr : 1440 - (lv_minstr - lv_minend));
      lv_tot += lv_mindif;
    }
  }
  lv_tot /= 60;
  $("#<?= $lv_sec; ?> #hhrtmerngwekhrstxt").text(Number(lv_tot).toFixed(1) + "hrs");
  
  $("#<?= $lv_sec; ?> #hhrtmerngwekhrs").val(Number(lv_tot));
}
    var gv_validTable = 0;
		var <?= $lv_sec; ?>_hotprm_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotprmcnt = $("#<?= $lv_sec; ?> #hhrtmerng001div")[0];
		var <?= $lv_sec; ?>_hotprmset = {
			height: 200,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
      rowHeaders: true,
      minSpareRows: <?= ($vew_readonly?"0":"1") ?>,
      multiColumnSorting: {
        initialConfig:{
          column: 0,
          sortOrder: "desc",
         }
      },
      colHeaders: [ "Dia", "Inicio", "Fin" ],
      columns: [
        {type: "dropdown", data: "tmeday", width: 100, renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly?', readOnly: true':''); ?>,  source: ["", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo", "Feriado"],},
        {type: "time", data: "tmestr", width: 100, renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly?', readOnly: true':''); ?>, timeFormat: "HH:mm", correctFormat: true},
        {type: "time", data: "tmeend", width: 100, renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly?', readOnly: true':''); ?>, timeFormat: "HH:mm", correctFormat: true},
      ],
      afterChange: function(changes, source) {
				gv_validTable = 0;
        if (source == "edit"){
          if (<?= $lv_sec; ?>_hotprm!=undefined) {
            if(changes && changes.length && source=="edit") {
              for(var i=0; i<changes.length; i++) {
                if( changes[i][1]=="tmestr" || changes[i][1]=="tmeend" ) {
									var lo_dat = <?= $lv_sec; ?>_hotprm.getSourceData();
                  <?= $lv_sec; ?>_totalHoursCount(lo_dat);
                }
              }
            }
          }
        }
      },
      afterRemoveRow: function(index, amount, physicalRows, source){
        var lo_dat = <?= $lv_sec; ?>_hotprm.getSourceData();
        <?= $lv_sec; ?>_totalHoursCount(lo_dat);
				gv_validTable = 0;
      },
      afterValidate: function(isValid, value, row, prop, source) {
        if (!isValid) {
          gv_validTable = 1;
        }
      },
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotprm;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotprm = new Handsontable(<?= $lv_sec; ?>_hotprmcnt, <?= $lv_sec; ?>_hotprmset);
			var lv_dat = [<?php
				$lv_buffer='';
        $lv_arr = json_decode($vew_data->hhrtmerngatr,true);
          if(is_array($lv_arr)){
            foreach($lv_arr['tmerng'] as $lv_row){
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
              							'tmeday:"'.($lv_daytxt[($lv_row['tmeday']??'')]??'').'",'.
                            'tmestr:"'.($lv_row['tmestr']??'').'",'.
                            'tmeend:`'.($lv_row['tmeend']??'').'`,'.
                          '}';
						}
          }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotprm.loadData( lv_dat );
			<?= $lv_sec; ?>_hotprm.render();
		});
	</script>
  <script>
		// form submit
function <?= $lv_sec; ?>_fncext( lp_prm ) {
  if ( lp_prm["action"]=="00" ) {
    var lo_dat = <?= $lv_sec; ?>_hotprm.getSourceData();
    var lo_arr = new Array();
    for (var i=0; i<lo_dat.length; i++) {
      lo_arr.push({	
        "tmeday": lo_dat[i]["tmeday"],
        "tmestr": lo_dat[i]["tmestr"],
        "tmeend": lo_dat[i]["tmeend"],
        "row": i,
      });
    }
    var lv_str = "";
    for (var i=0; i<lo_arr.length; i++) {
      <?= $lv_sec; ?>_hotprm.setCellMeta(lo_arr[i]["row"], <?= $lv_sec; ?>_hotprm.propToCol("tmeday"), "valid", true);
      <?= $lv_sec; ?>_hotprm.setCellMeta(lo_arr[i]["row"], <?= $lv_sec; ?>_hotprm.propToCol("tmestr"), "valid", true);
      <?= $lv_sec; ?>_hotprm.setCellMeta(lo_arr[i]["row"], <?= $lv_sec; ?>_hotprm.propToCol("tmeend"), "valid", true);
    }
    lo_arr = lo_arr.filter(element => Object.keys(element).length !== 0 && ( (element["tmeday"]??"")!="" || (element["tmestr"]??"")!="" || (element["tmeend"]??"")!="" ));
    lo_arr = lo_arr.filter(element => !( (element["tmeday"]??"")=="" && (element["tmestr"]??"")=="" && (element["tmeend"]??"")=="" ) );
    lo_arr.sort((lp_row1, lp_row2) => {
      var lo_ord = { "Lunes": "0", "Martes": "1", "Miercoles": "2", "Jueves": "3", "Viernes": "4", "Sabado": "5", "Domingo": "6", "Feriado": "7" };
      var lv_day1=lp_row1["tmeday"], lv_day2=lp_row2["tmeday"];
      if (lo_ord[lv_day1] < lo_ord[lv_day2]) {
        return -1;
      }
      if (lo_ord[lv_day1] > [lv_day2]) {
        return 1;
      }
      return 0;
    });
    var lo_undaytxt = { "Lunes": "L", "Martes": "M", "Miercoles": "X", "Jueves": "J", "Viernes": "V", "Sabado": "S", "Domingo": "D", "Feriado": "F" };
    const lo_dayopt = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo', 'Feriado'];
    for (var i=0; i<lo_arr.length; i++) {
      <?= $lv_sec; ?>_hotprm.render();
      if ( (lo_arr[i]["tmeday"]??"")=="" || !lo_dayopt.includes(lo_arr[i]["tmeday"]) ){ <?= $lv_sec; ?>_hotprm.setCellMeta(lo_arr[i]["row"], <?= $lv_sec; ?>_hotprm.propToCol("tmeday"), "valid", false); gv_validTable=1; }
      if ( (lo_arr[i]["tmestr"]??"")=="" ){ <?= $lv_sec; ?>_hotprm.setCellMeta(lo_arr[i]["row"], <?= $lv_sec; ?>_hotprm.propToCol("tmestr"), "valid", false); gv_validTable=1; }
      if ( (lo_arr[i]["tmeend"]??"")=="" ){ <?= $lv_sec; ?>_hotprm.setCellMeta(lo_arr[i]["row"], <?= $lv_sec; ?>_hotprm.propToCol("tmeend"), "valid", false); gv_validTable=1; }
      if (lo_undaytxt.hasOwnProperty(lo_arr[i]["tmeday"])) {
        lo_arr[i]["tmeday"] = lo_undaytxt[lo_arr[i]["tmeday"]];
      }
    }
    <?= $lv_sec; ?>_hotprm.render();
    if( gv_validTable ){
      toastr.warning("Asegurese de que todos los valores sean correctos");
      return 0;
    }
    var lv_hhrtmerngatr = {"tmerng": lo_arr};
    $("#<?= $lv_sec; ?> #hhrtmerngatr").text( JSON.stringify(lv_hhrtmerngatr) );
  }
}
  </script>
  
	<?php include('grldocfrmscr.frm'); ?>
</section>