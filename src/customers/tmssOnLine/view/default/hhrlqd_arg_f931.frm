<?php		
	// url del formulario
  $lv_lnk = '?prg=hhrlqd&act=arg_f931';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	$lv_dockey = '';

	// titulo
	$lv_title = 'F-931';
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'A93';
	
	$vew_actcod='02';

	// librería de estilos bootstrap
	include_once('_library.frm');

	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['accL'] = array ('id'=>'btndwn', 'pos'=>'L', 'ttl'=>$vew_lang->download, 'per'=>true, 'icn'=>'far fa-download', 'css'=>'btn navbar-btn tmss-navbar-btn btn-success', 'acc'=>'');
	// ocultar botón de dropdown
	$vew_dropdown	= false;
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <div class="tab-content tmss-tab-content">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header"><div class="card-title">F-931</div></div>
            <div class="card-body tmss-card-body-edit">
              <?= vew_boot($lv_col210, array('label'=>$vew_lang->period,'input'=>gethtml('term','typeahead', '', $lv_default) )); ?>
            </div>
          </div>			
        </div>
      </div>
    </div>
  </div>  
  <script>
    $("#<?= $lv_sec; ?> #term").datepicker({
			format: "mm/yyyy",
			startView: "months", 
			minViewMode: "months"
    }).on("change",function(e){
      //cierra el datepicker cuando se selecciona un mes
      $('.datepicker').hide();
    });
    
    $("#<?= $lv_sec; ?> #btndwn").click(()=>{
      // validar período
      let lv_term = $("#<?= $lv_sec; ?> #term").val();
      tmssCallProcess("?prg=hhrlqd&act=arg_f931",[{name:"download",value:"X"}, {name:"term",value:lv_term}],function(data){
        let lv_download = document.createElement('a');
        lv_download.href = window.URL.createObjectURL(new Blob([data.body]));
        lv_download.download=data.filename;
        lv_download.click();
      });
    })
  </script>  
  <?php include('grldocfrmscr.frm'); ?>
</section>