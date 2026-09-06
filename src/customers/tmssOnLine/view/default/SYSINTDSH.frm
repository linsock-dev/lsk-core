<?php
  // url del formulario
  $lv_lnk = '?prg=sysint&act=dsh';

  // campos requeridos
  $vew_input->RequiredFields( array() );

  // clave del documento
	$lv_dockey = '';

// titulo
	$lv_title = $vew_lang->Interfaces;

  // módulo y programa
  $lv_mdlcod = 'SYS';
  $lv_prgcod = 'ITZ';

  // librería de estilos bootstrap
  include_once('_library.frm');

	$vew_data = array();
	//$vew_tbl['new'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'acc'=>'tmssLink('.chr(39).'?prg=sysint&act=01'.chr(39).', [{target: '.chr(39).'_new_section'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
	$vew_tbl['new'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'acc'=>'tmssLink('.chr(39).'?prg=sysint&act=01'.chr(39).', [{target: '.chr(39).'_new_section'.chr(39).'}]);');
  $vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['rfrsh'] = array('per'=>true,'pos'=>'D','ttl'=>$vew_lang->refresh,'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_GridRefresh();');

	$vew_tbl_brand = '<span style="color:white;">'.$vew_lang->interfaces.'</span>';
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<style> 
		.dashboard-card{ border: transparent 2px solid; border-radius: 10px; padding: 10px; margin-bottom: 10px; }
		.dashboard-card p:first-child { font-size:16px; }
		.dashboard-card p:last-child { font-size:32px; font-weight:bold; text-align: center;}
	</style>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('vewflt','hidden',''); ?>

    <div class="container-fluid">
			<div class="row">
				<div class="col-sm-4">
        
          <div class="row">
            <div class="col-xs-6">
              <div class="dashboard-card" name="filterStatus" data-status="" style="background-color: var(--tmss-blue); text: var(--tmss-blue-text); cursor:pointer;">
                <p><?= $vew_lang->active; ?></p><p id="qtyact"></p>
              </div>
            </div>
            <div class="col-xs-6">
              <div class="dashboard-card" name="filterStatus" data-status="S" style="background-color: var(--tmss-green); text: var(--tmss-green-text); cursor:pointer;">
                <p><?= $vew_lang->success; ?></p><p id="qtyS"></p>
              </div>
            </div>
            <div class="col-xs-6">
              <div class="dashboard-card" name="filterStatus" data-status="E" style="background-color: var(--tmss-red); text: var(--tmss-red-text); cursor:pointer;">
                <p><?= $vew_lang->errors; ?></p><p id="qtyE"></p>
              </div>
            </div>
            <div class="col-xs-6">
              <div class="dashboard-card" name="filterStatus" data-status="W" style="background-color: var(--tmss-orange); text: var(--tmss-orange-text); cursor:pointer;">
                <p><?= $vew_lang->warnings; ?></p><p id="qtyW"></p>
              </div>
            </div>
          </div>
        
        </div>
				<div class="col-sm-8">
				
					<div class="card">
            <div class="card-body">
              <table class="table table-condensed" id="tblint" data-search="true">
                <thead>
                  <th data-sortable="true" data-field="sysintcodext"><?= $vew_lang->code; ?></th>
                  <th data-sortable="true" data-field="sysinttxt"><?= $vew_lang->title; ?></th>
                  <th data-sortable="true" data-field="sysintlstrunsts" width="50"><?= $vew_lang->status; ?></th>
                </thead>
                <tbody></tbody>
              </table>              
            </div>
					</div>
          
				</div>
			</div> <!--/row -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
    $("#<?= $lv_sec; ?> div[name='filterStatus']").on("click",function(){
      $("#<?= $lv_sec; ?> div[name='filterStatus']").css("border","transparent 2px solid");
      let lv_stat = $(this).data("status");
      if( lv_stat=="" ){
      	$("#<?= $lv_sec; ?> #tblint").bootstrapTable("filterBy", {});
      } else {
        $("#<?= $lv_sec; ?> #tblint").bootstrapTable("filterBy", {sysintlstrunsts: lv_stat});
      }
      $(this).css("border","black 2px solid");
    });
		    
    tmssLoadScript("table", function(){
      $("#<?= $lv_sec; ?> #tblint").bootstrapTable({
        columns: [{fields:"sysintcodext"},{field:"sysinttxt"},{field:"sysintlstrunsts"}],
        rowStyle: function (row, index) {
          if (row.sysintlstrunsts === 'E') {
            return { css: {'background-color':'var(--tmss-red);', 'color:':'var(--tmss-red-text);'} };
          } else if (row.sysintlstrunsts === 'W') {
            return { css: {'background-color':'var(--tmss-orange);', 'color':'var(--tmss-orange-text);'} };
          }
          return {}; // Estilo por defecto
        }
      }).on("click-row.bs.table", function (e, row, $element) {
        <?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') || $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03') ){ ?>
        tmssLink("?prg=sysint&act=03", [{post_data:[{name:"sysintcod",value:row.sysintcod}], target:"_new_section"}] );
				<?php } ?>
      });
    });
    
    // REFRESH
		function <?= $lv_sec; ?>_GridRefresh(){
			var lv_spin = "<i class='far fa-gear fa-spin'></i>";
			$("#<?= $lv_sec; ?> #qtyact").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtyS").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtyW").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtyE").html( lv_spin );
			
			// ACTIVOS
			tmssCallProcessNoBackdrop("?prg=sysint&act=dsh",[{name:"typ",value:"active"}],function(data){
				var lv_act = 0;
				for(var i=0; i<data.length; i++){ lv_act += data[i].qty; }
				$("#<?= $lv_sec; ?> #qtyact").html( lv_act );
			});

      // ESTADOS
			tmssCallProcessNoBackdrop("?prg=sysint&act=dsh",[{name:"typ",value:"status"}],function(data){
				var lv_s = 0;
				var lv_e = 0;
				var lv_w = 0;
				for(var i=0; i<data.length; i++){
					if( data[i].sysintlstrunsts=="S" ){ lv_s+=data[i].qty; }
					if( data[i].sysintlstrunsts=="E" ){ lv_e+=data[i].qty; }
					if( data[i].sysintlstrunsts=="W" ){ lv_w+=data[i].qty; }
				}
				$("#<?= $lv_sec; ?> #qtyS").html( lv_s );
				$("#<?= $lv_sec; ?> #qtyE").html( lv_e );
				$("#<?= $lv_sec; ?> #qtyW").html( lv_w );
			});
			
			// LISTA
			tmssCallProcessNoBackdrop("?prg=sysint&act=dsh",[{name:"typ",value:"interface_list"}],function(data){
        var lv_rows = [];
        for( var i=0; i<data.length; i++){
          lv_rows.push({
            sysintcod: data[i].sysintcod,
            sysintcodext: data[i].sysintcodext,
            sysinttxt: data[i].sysinttxt,
            sysintlstrunsts: data[i].sysintlstrunsts,
            sysintlstrunlog: data[i].sysintlstrunlog
          });
        }
        $("#<?= $lv_sec; ?> #tblint").bootstrapTable("load", lv_rows);
			});      
		}
		
    // NUEVO
		$("#<?= $lv_sec; ?> #btnnew").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=sysint&act=01", [{target: "_new_section", target_id: "#<?= $lv_sec; ?>"}]);
		});
		
		$(function(){ <?= $lv_sec; ?>_GridRefresh(); });
	</script>
</section>