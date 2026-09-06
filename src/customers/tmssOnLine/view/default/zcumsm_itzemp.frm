<?php 
	// url del formulario 
  $lv_lnk = '?prg=zcumsm';

	// campos requeridos
	$vew_input->RequiredFields( array() );

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
 	$vew_tbl['sveL'] = array('ttl'=>$vew_lang->process, 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'itzemp00'.chr(39).'});' );

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
    <input type="file" id="uplfle" class="hidden">
		<?= gethtml( 'hhremp' , 'hidden', '' ); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-12">
							<div class="card tmss-hot-ttl">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->employees; ?>
										<a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnupl" title="<?= $vew_lang->upload; ?>"><i class="fas fa-upload"></i></a>
                    <a href="#" id="btndemo" class="card-icon pull-right" title="Descargar modelo de interfaz empleados"><i class="far fa-download"></i></a>
									</div>
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
    const <?= $lv_sec; ?>_emp = <?= json_encode($vew_data->emp) ?>;
    const <?= $lv_sec; ?>_chrtyp = <?= json_encode($vew_data->chrtyp) ?>;
    const <?= $lv_sec; ?>_asgcls = <?= json_encode($vew_data->asgcls) ?>;
    const <?= $lv_sec; ?>_chr = <?= json_encode($vew_data->chr) ?>;
    
    function <?= $lv_sec; ?>_findEmp(lp_hhrempcodext){ 
      const lv_defemp = {hhrempcod: 0, docsts: 'I'};
      const lv_emp = <?= $lv_sec; ?>_emp.find(elem => { return elem["hhrempcodext"] == lp_hhrempcodext; });
      
      return lv_emp && lp_hhrempcodext ? lv_emp : lv_defemp;
    }
    
    function <?= $lv_sec; ?>_findChrTyp(lp_hhrchrtyptxt){ 
      const lv_defchrtyp = {hhrchrtypcod: 0};
      const lv_chrtyp = <?= $lv_sec; ?>_chrtyp.find(elem => { return elem["hhrchrtyptxt"] == lp_hhrchrtyptxt; });
      
      return lv_chrtyp && lp_hhrchrtyptxt ? lv_chrtyp : lv_defchrtyp;
    }
    
    function <?= $lv_sec; ?>_findAsgCls(lp_chrclstxt){ 
      const lv_defasgcls = {sysdocclscod: 0};
      const lv_asgcls = <?= $lv_sec; ?>_asgcls.find(elem => { return elem["sysdocclstxt"] == lp_chrclstxt; });
      
      return lv_asgcls && lp_chrclstxt ? lv_asgcls : lv_defasgcls;
    }
    
    function <?= $lv_sec; ?>_findChr(lp_hhrempcod, lp_hhrchrtypcod, lp_chrclscod, lp_hhrchrasgdtestr){ 
      const lv_defchrcod = 0;
      const lv_chr = <?= $lv_sec; ?>_chr.find(elem => { return elem["hhrempcod"] == lp_hhrempcod && elem["hhrchrtypcod"] == lp_hhrchrtypcod && elem["chrclscod"] == lp_chrclscod && elem["hhrchrasgdtestr"] == lp_hhrchrasgdtestr; });
      
      return lv_chr ? lv_chr["hhrchrasgcod"] : lv_defchrcod;
    }
  </script>
  <script>
    // ARCHIVO. boton cargar archivo
    $("#<?= $lv_sec; ?> #btnupl").on("click",function(e){e.preventDefault();
      $("#<?= $lv_sec; ?> #uplfle").trigger("click");
    });	
    
    function <?= $lv_sec; ?>_fixDte(lp_dte, lp_fletyp){
      const lv_isvaliddte = !lp_dte || !Number.isInteger(lp_dte);
      var lv_fixeddte = lp_dte;

      if(lv_isvaliddte){
        if(lp_fletyp == "text/csv" && lp_dte){ 
          lv_fixeddte = moment(lp_dte, "DD/MM/YYYY hh:mm").format("DD/MM/YYYY");
        }else{
          lv_fixeddte = "";
        }
      }

      return lv_fixeddte;
    }
    
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
          
					for(var i=1; i < lo_arr.length; i++){ 
            var lv_brndte = lo_arr[i][6];
            lv_brndte = <?= $lv_sec; ?>_fixDte(lv_brndte, lv_fletyp);
            
            var lv_inbdte = lo_arr[i][7];
            lv_inbdte = <?= $lv_sec; ?>_fixDte(lv_inbdte, lv_fletyp);
            
						$("#<?= $lv_sec; ?> .progress").data("progress", Number( 10 + (i * 50 / lo_arr.length) ).toFixed(0) );
						
            const lv_hhrempcodext = lo_arr[i][0];
            const lv_hhrchrtyptxt = lo_arr[i][10] ? lo_arr[i][10] : "";
            const lv_chrclstxt = lo_arr[i][9];
            const lv_emp = <?= $lv_sec; ?>_findEmp(lv_hhrempcodext);
            const lv_chrtyp = <?= $lv_sec; ?>_findChrTyp(lv_hhrchrtyptxt.toUpperCase());
            const lv_asgcls = <?= $lv_sec; ?>_findAsgCls(lv_chrclstxt.toUpperCase());
              
            lv_emp.hhrempcodext = lv_hhrempcodext;
            lv_emp.persex = lo_arr[i][1];
            lv_emp.civstscod = lo_arr[i][2];
            lv_emp.idttypcod = lo_arr[i][3];
            lv_emp.taxcod001 = lo_arr[i][4];
            lv_emp.taxcod002 = lo_arr[i][5];
            lv_emp.perbrndte = lv_brndte;
            lv_emp.hhrempinbdte = lv_inbdte;
            lv_emp.chrclscod = lv_asgcls.sysdocclscod;
            lv_emp.chrclscodext = lo_arr[i][8];	
            lv_emp.chrclstxt = lv_chrclstxt; 
            lv_emp.hhrchrtypcod = lv_chrtyp.hhrchrtypcod;
            lv_emp.hhrchrtyptxt = lv_hhrchrtyptxt;
            lv_emp.adrstr = lo_arr[i][11];
            lv_emp.adrstrnum = lo_arr[i][12];
            lv_emp.adrcty = lo_arr[i][13];
            lv_emp.adrpstcod = lo_arr[i][14];
            lv_emp.adrphn001 = lo_arr[i][15];
            lv_emp.adrmblphn = lo_arr[i][16];
            lv_emp.chrcod = <?= $lv_sec; ?>_findChr(lv_emp.hhrempcod, lv_chrtyp.hhrchrtypcod, lv_asgcls.sysdocclscod, lv_inbdte);
            
            lv_hotarr.push(lv_emp);
          }
          
          $("#<?= $lv_sec; ?> .progress").data("progress","75");
					
          <?= $lv_sec; ?>_hotdoc.loadData( lv_hotarr );
          $("#<?= $lv_sec; ?> .progress").data("progress","90");

          <?= $lv_sec; ?>_hotdoc.render();						
          $("#<?= $lv_sec; ?> .progress").data("progress","100");
        }
      });
      
      $("#<?= $lv_sec; ?> #btndemo").click( <?= $lv_sec; ?>_exportToExcel );
		
      function <?= $lv_sec; ?>_saveFileAs(blob, fileName) {
        var link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = fileName;
        link.click();
      }

      function <?= $lv_sec; ?>_stringToarraybuffer(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
      }
      
      function <?= $lv_sec; ?>_exportToExcel() {
        // Datos para la tabla
        const data = [
          [ "Legajo", "Sexo", "Est. Civil", "T. Doc.", "Nro Doc.", "CUIL", "F. Nac." , "F. Antig.", "Tipo planta", "Descripcion", "Escalafon"
            , "Calle", "Nro", "Localidad", "Cod. Postal", "Telefono", "Celular"],
          [ "60800", "m", "C", "96", "17691825", "27-17691825-5", new Date("1966-3-29"), new Date("1985-4-1"), 1, "Permanente", "02.17.01.05  Jefe Departamento"
          	, "ITALIA", "5241", "SANMI", "1663", "4455-2894", "1121558408"],
          [ "56670", "f", "E", "96", "17167625", "27-17167625-5", new Date("1980-5-28"), new Date("1995-3-1"), 2, "Permanente", "05.17.01.05  administrativo 17"
          	, "ITALIA", "5241", "SANMI", "1663", "4455-2894", "1121558408"]
        ];
        
        const workbook = XLSX.utils.book_new();

        const sheet = XLSX.utils.aoa_to_sheet(data);

        XLSX.utils.book_append_sheet(workbook, sheet, 'Hoja1');

        const excelBinary = XLSX.write(workbook, { bookType: 'xlsx', type: 'binary', mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

        // Convierte el archivo binario a Blob
        const blob = new Blob([<?= $lv_sec; ?>_stringToarraybuffer(excelBinary)], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
        const lv_flenme = "modelo_de_interfaz_empleados.xlsx";
        <?= $lv_sec; ?>_saveFileAs(blob, lv_flenme);
      }
    });
	</script>
  <script>
    const <?= $lv_sec; ?>_notRegisteredColor = "#f2483f";
    
    var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if( <?= $lv_sec; ?>_hotdoc != undefined ) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);

        const lv_hhrempcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "hhrempcod");
        td.style.backgroundColor = lv_hhrempcod ? "" :<?= $lv_sec; ?>_notRegisteredColor;
      }
    };
    
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hhremphot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
      <?= ($vew_readonly? '':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'0') ?>,
			colHeaders: [ "Legajo", "Sexo", "Est. Civil", "T. Doc.", "Nro Doc.", "CUIL", "F. Nac.", "F. Antig."
      						,"Tipo planta", "<?= $vew_lang->description; ?>", "Escalafon", "Calle", "Nro", "Localidad", "Cod. Postal", "<?= $vew_lang->phone; ?>", "Celular"],
			columns: [
        {type: "text", data: "hhrempcodext", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly ?'readOnly: true, ':''); ?> allowEmpty: false},
				{type: "text", data: "persex", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "civstscod", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "idttypcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "taxcod001", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "taxcod002", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "perbrndte", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
				{type: "date", data: "hhrempinbdte", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?'readOnly: true, ':''); ?>,
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: true,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
        {type: "text", data: "chrclscodext", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "chrclstxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "hhrchrtyptxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "adrstr", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "adrstrnum", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "adrcty", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "adrpstcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "adrphn001", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> },
        {type: "text", data: "adrmblphn", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> }
			],
      beforeChange: function(changes, source){  
        if(changes && changes[0][2]!=changes[0][3]){
          if(changes[0][1] == "hhrempcodext"){
            const lv_emp = <?= $lv_sec; ?>_findEmp(changes[0][3]);
            changes.push([changes[0][0], "hhrempcod", "", lv_emp.hhrempcod]);
            
          }else if(changes[0][1] == "hhrchrtyptxt"){
            const lv_chrtyp = <?= $lv_sec; ?>_findChrTyp(changes[0][3]);
            changes.push([changes[0][0], "hhrchrtypcod", "", lv_chrtyp.hhrchrtypcod]);
            
          }else if(changes[0][1] == "chrclstxt"){
            const lv_chrtyp = <?= $lv_sec; ?>_findAsgCls(changes[0][3]);
            changes.push([changes[0][0], "chrclscod", "", lv_chrtyp.sysdocclscod]);
          
          }
        }
     	},
      afterChange: function(changes, source){ 
        if(changes && <?= $lv_sec; ?>_hotdoc && (changes[0][1] == "hhrempcodext" || changes[0][1] == "hhrchrtyptxt" || changes[0][1] == "chrclstxt" || changes[0][1] == "hhrempinbdte")){
          let lv_hhrempcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "hhrempcod");
          let lv_hhrchrtypcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "hhrchrtypcod");
          let lv_chrclscod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "chrclscod"); 
          let lv_inbdte = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0], "hhrempinbdte"); 
          const lv_chrcod = <?= $lv_sec; ?>_findChr(lv_hhrempcod, lv_hhrchrtypcod, lv_chrclscod, lv_inbdte);
          
          <?= $lv_sec; ?>_hotdoc.runHooks("beforeChange", [[changes[0][0], "chrcod", "", lv_chrcod]]);
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
				if (gv_<?= $lv_sec; ?>_last_action=="itzemp00") { 
          toastr.success( "Documento procesado.", "<?= $lv_title; ?>" );
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        }
      }
    }
    
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="itzemp00" ) {

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        
        for(let i=0; i<lo_dat.length; i++){
        	if(lo_dat[i]["hhrempcod"] == 0){
          	toastr.warning("Hay empleados cuyo legajo no se ha reconocido.");
            return false;
          }
        }
        
				var lv_arr = lo_dat;
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #hhremp").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #hhremp").prop("value", JSON.stringify( lv_arr ) );
				}
      }
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>