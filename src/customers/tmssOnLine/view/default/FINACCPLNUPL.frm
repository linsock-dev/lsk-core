<?php
	// url del formulario 
  $lv_lnk = '?prg=finaccpln';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = isset($vew_data->finaccplncod) ? $vew_data->finaccplncod : '';

	// titulo 
	$lv_title = $vew_lang->upload;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'PLN';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">  
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">    
    <?= gethtml('finaccplncod','hidden', $lv_dockey); ?>
		<?= gethtml('btnsve','hidden',false); ?>

		<div class="container-fluid">	
			<div class="card" id="selection">
				<div class="card-header">
					<div class="card-title"><?= $vew_lang->upload;?>
						<a href="#" id="btndemo" onclick="" class="card-icon pull-right" title="Descargar modelo de plan de cuentas"><i class="far fa-download"></i></a>
					</div>
				</div>
				<div class="card-body tmss-card-body-edit">
          <!--DROPZONE-->  
          <div id="myDropzone" class="dropzone">
            <input type="file" id="uplfle" class="hidden" charset="utf-8">
          </div>
				</div>
			</div>
			<div class="card hidden" id="preview">
				<div class="card-header"><div class="card-title">
					<a class="card-icon pull-left" id="btnbck"><i class="far fa-arrow-circle-left"></i></a><?= $vew_lang->preview; ?>
					<span class="card-icon">
						<a class="text-success" id="cntscs"><i class="far fa-check-circle"></i></a> / <a class="text-warning" id="cntwrn"><i class="far fa-exclamation-circle"></i></a> / <a class="text-danger" id="cnterr"><i class="far fa-exclamation-triangle"></i></a>
					</span>
					</div>
				</div>
				<div class="card-body">
					<div class="tmss-vertbl-scroll">
						<table id="mattbl" class="table table-condensed">
							<thead>
								<tr valign="top">
									<th width="80"> Nivel </th>
									<th> Nombre </th>
									<th width="80"> Es Cuenta </th>
									<th width="80"> ID Cuenta </th>
									<th width="80"> Moneda </th>
									<th width="150"> Clasificaci&oacute;n </th>
                  <th width="30"></th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
					<div id="datqty"></div>	   
				</div>
			</div>				
    </div> <!-- /container-fluid -->
  </form>
  <script>
		var gv_<?= $lv_sec; ?>_acclst = [];
		
    tmssLoadScript("sheetjs",function(){
      
      //DESCARGAR MODELO 
      $("#<?= $lv_sec; ?> #btndemo").click(<?= $lv_sec; ?>_exportToExcel);
    	function <?= $lv_sec; ?>_exportToExcel() {
				// Datos para la tabla
        let lo_dat = [
          { CODIGO: "01", NOMBRE: "ACTIVO", "ES CUENTA": "NO", "ID CUENTA": "", MONEDA: "", CLASIFICACION: "" },
          { CODIGO: "01.01", NOMBRE: "DISPONIBILIDADES", "ES CUENTA": "NO", "ID CUENTA": "", MONEDA: "", CLASIFICACION: "" },
          { CODIGO: "01.01.01", NOMBRE: "CAJA", "ES CUENTA": "SI", "ID CUENTA": "", MONEDA: "ARS", CLASIFICACION: "ACTIVO" },
          { CODIGO: "02", NOMBRE: "PASIVO", "ES CUENTA": "NO", "ID CUENTA": "", MONEDA: "", CLASIFICACION: "" }
        ];

        let lo_wb = XLSX.utils.book_new();
        let lo_ws = XLSX.utils.json_to_sheet(lo_dat);
        XLSX.utils.book_append_sheet(lo_wb, lo_ws, 'Plan de Cuentas');

        let lv_xlsbin = XLSX.write(lo_wb, { bookType: 'biff8', type: 'binary', mimeType: 'application/vnd.ms-excel' });

        let lo_blb = new Blob([<?= $lv_sec; ?>_stringToarraybuffer(lv_xlsbin)], { type: 'application/vnd.ms-excel' });
        <?= $lv_sec; ?>_saveAs(lo_blb, 'modelo_plan_de_cuentas.xls');
      }
			
      function <?= $lv_sec; ?>_stringToarraybuffer(lv_str) {
        let lo_buf = new ArrayBuffer(lv_str.length);
        let lo_vew = new Uint8Array(lo_buf);
        for (let lv_i = 0; lv_i != lv_str.length; ++lv_i) lo_vew[lv_i] = lv_str.charCodeAt(lv_i) & 0xFF;
        return lo_buf;
      }
			
      function <?= $lv_sec; ?>_saveAs(lo_blb, lv_flenam) {
        let lo_lnk = document.createElement('a');
        lo_lnk.href = window.URL.createObjectURL(lo_blb);
        lo_lnk.download = lv_flenam;
        lo_lnk.click();
      }
      
		  function loadPreview(lp_fle){	
				let lo_reader = new FileReader();
				lo_reader.readAsArrayBuffer( lp_fle );
				lo_reader.onload = function (evt) {
          let lo_dat_xls = lo_reader.result;
					let lo_wb = XLSX.read(lo_dat_xls, {type: 'array', codepage: 65001});
					let lo_ws = lo_wb.Sheets[lo_wb.SheetNames[0]];
					let lo_arr = XLSX.utils.sheet_to_json(lo_ws, {header:1});

          let lo_arrpar = [];
          let lo_arracc = [];
          for(let lv_i=1; lv_i<lo_arr.length; lv_i++){
              let lv_finaccplnlvl    = lo_arr[lv_i][0] ? lo_arr[lv_i][0].toString().trim() : "";
              let lv_raw    = lo_arr[lv_i][1] ? lo_arr[lv_i][1].toString().trim() : "";
              let lv_finaccplntxt; try { lv_finaccplntxt = decodeURIComponent(escape(lv_raw)); } catch(e) { lv_finaccplntxt = lv_raw; }
              let lv_acc  = lo_arr[lv_i][2] && lo_arr[lv_i][2].toString().toUpperCase() == "SI";
              let lv_finacccod = lo_arr[lv_i][3] || 0;
              let lv_curcod = lo_arr[lv_i][4] ? lo_arr[lv_i][4].toString().trim().toUpperCase() : "";
              let lv_clstxt = lo_arr[lv_i][5] ? lo_arr[lv_i][5].toString().trim().toUpperCase() : "";
              
              let lv_finaccclscod = "";
              let lv_finaccclstxt = "";
              if (lv_clstxt === "A" || lv_clstxt === "ACTIVO") { lv_finaccclscod = "A"; lv_finaccclstxt = "ACTIVO"; }
              else if (lv_clstxt === "P" || lv_clstxt === "PASIVO") { lv_finaccclscod = "P"; lv_finaccclstxt = "PASIVO"; }
              else if (lv_clstxt === "R+" || lv_clstxt === "RESULTADO POSITIVO") { lv_finaccclscod = "R+"; lv_finaccclstxt = "RESULTADO POSITIVO"; }
              else if (lv_clstxt === "R-" || lv_clstxt === "RESULTADO NEGATIVO") { lv_finaccclscod = "R-"; lv_finaccclstxt = "RESULTADO NEGATIVO"; }
              else if (lv_clstxt === "PN" || lv_clstxt === "PATRIMONIO NETO") { lv_finaccclscod = "PN"; lv_finaccclstxt = "PATRIMONIO NETO"; }
              else { lv_finaccclscod = lv_clstxt; lv_finaccclstxt = lv_clstxt; }

              if(lv_finaccplnlvl == "" || lv_finaccplntxt == "") continue;
              
              let lo_itm = {
                finaccplnlvl: lv_finaccplnlvl,
                finaccplnlvltxt: lv_finaccplntxt,
                type: lv_acc ? "account" : "folder",
                finacccod: lv_finacccod,
                curcod: lv_curcod,
                finaccclscod: lv_finaccclscod,
                finaccclstxt: lv_finaccclstxt,
                errtyp: 'S',
                errtxt: ''
              };

              lo_arrpar.push(lo_itm);
              if (lv_acc) {
                lo_arracc.push(lo_itm);
              }
          }

					let lo_pstdat = [
					  {name:"finaccplncod", value: $("#<?= $lv_sec; ?> #finaccplncod").val()},
					  {name:"finaccplnacc", value: JSON.stringify(lo_arracc).replace(/[\u0080-\uffff]/g, function(c){ return "\\u" + ("0000"+c.charCodeAt(0).toString(16)).slice(-4); })}
					];

          tmssCallProcess("?prg=finaccpln&act=finaccplnuplchk", lo_pstdat, function(lo_dat_res){
            lo_dat_res = Array.isArray(lo_dat_res) ? lo_dat_res : [];
            
            let lo_map = {};
            for(let lv_i=0; lv_i<lo_dat_res.length; lv_i++) {
                lo_map[lo_dat_res[lv_i].finaccplnlvl] = lo_dat_res[lv_i];
            }
            
            for(let lv_i=0; lv_i<lo_arrpar.length; lv_i++) {
                let lo_val = lo_map[lo_arrpar[lv_i].finaccplnlvl];
                if(lo_val) {
                    lo_arrpar[lv_i].errtyp = lo_val.errtyp;
                    lo_arrpar[lv_i].errtxt = lo_val.errtxt;
                    // si el usuario no cargó el ID pero el SP lo resolvió por nombre, mostrarlo
                    if((!lo_arrpar[lv_i].finacccod || lo_arrpar[lv_i].finacccod == 0) && lo_val.finacccod && lo_val.finacccod != 0)
                        lo_arrpar[lv_i].finacccod = lo_val.finacccod;
                }
            }

            gv_<?= $lv_sec; ?>_acclst = lo_arrpar;
            let lv_buf="";
            let lv_cntacc = 0;
            let lv_cnterr = 0;
            let lv_cntwrn = 0;
            
            if(lo_arrpar.length > 0) {
              for(let lv_i=0; lv_i<lo_arrpar.length; lv_i++){
                let lv_finaccplnlvl    = lo_arrpar[lv_i].finaccplnlvl;
                let lv_finaccplntxt    = lo_arrpar[lv_i].finaccplnlvltxt;
                let lv_acc  = lo_arrpar[lv_i].type == "account";
                let lv_finacccod = lo_arrpar[lv_i].finacccod;
                let lv_curcod = lo_arrpar[lv_i].curcod;
                let lv_clstxt = lo_arrpar[lv_i].finaccclstxt;
                let lv_errtyp = lo_arrpar[lv_i].errtyp;
                let lv_errtxt = lo_arrpar[lv_i].errtxt;
                
                lv_cntacc++;
                if(lv_errtyp === 'E') lv_cnterr++;
                if(lv_errtyp === 'W') lv_cntwrn++;
                
                let lv_clsrow = lv_errtyp === 'E' ? 'bg-danger' : (lv_errtyp === 'W' ? 'bg-warning' : 'bg-success');
                let lv_ico = lv_errtxt
                  ? (lv_errtyp === 'W'
                      ? "<i class='far fa-exclamation-circle text-warning' title='"+lv_errtxt+"'></i>"
                      : "<i class='far fa-exclamation-triangle text-danger' title='"+lv_errtxt+"'></i>")
                  : "";
                
                lv_buf +="<tr valign='top' class='"+lv_clsrow+"'>";
                lv_buf += 	"<td>"+lv_finaccplnlvl+"</td>";
                lv_buf += 	"<td>"+lv_finaccplntxt+"</td>";
                lv_buf += 	"<td>"+(lv_acc ? "SI" : "NO")+"</td>";
                lv_buf += 	"<td>"+(lv_finacccod || "")+"</td>";
                lv_buf += 	"<td>"+(lv_curcod || "")+"</td>";
                lv_buf += 	"<td>"+(lv_clstxt || "")+"</td>";
                lv_buf +=  "<td class='text-center'>"+lv_ico+"</td>";
                lv_buf += "</tr>";
              }
            } else {
              lv_buf = "<tr><td colspan='7' class='text-center text-muted'>No se encontraron cuentas válidas en el archivo</td></tr>";
            }
            
            $("#<?= $lv_sec; ?> #mattbl tbody").html(lv_buf);
            
            $("#<?= $lv_sec; ?> #datqty").html("<span class='pagination-info'>Cuentas/Rubros encontrados <span class='badge'>"+lv_cntacc+"</span></span>");
             $("#<?= $lv_sec; ?> #cntscs i").text(" "+ (lv_cntacc - lv_cnterr - lv_cntwrn));
             $("#<?= $lv_sec; ?> #cntwrn i").text(" "+ lv_cntwrn);
             $("#<?= $lv_sec; ?> #cnterr i").text(" "+ lv_cnterr);
            
            if(lv_cnterr > 0) {
              toastr.warning("Se encontraron errores en algunas cuentas.");
            }else if(lv_cntwrn > 0) {
              toastr.info("Algunas cuentas fueron identificadas por nombre porque el ID del archivo no coincidía.");
            }

            $('#<?= $lv_sec; ?> #selection').animate({left: '-100%'}, 500, function() {
              $(this).addClass('hidden').css('left', '0');
              $('#<?= $lv_sec; ?> #preview').removeClass('hidden').css('left', '100%').animate({left: '0'}, 500);
              $('#<?= $lv_sec; ?>').parent().parent().parent().parent().find("#btnnxt").removeClass('hidden');
            });
          });
				};
			} 
      
      //BOTONES PREVIEW
      $("#<?= $lv_sec; ?> #cntscs").click(()=>{
        let lv_othvew = $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger:not(.hidden), #<?= $lv_sec; ?> #mattbl tbody tr.bg-warning:not(.hidden)").length > 0;
        if(lv_othvew){
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").removeClass("hidden");
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").addClass("hidden");
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-warning").addClass("hidden");
        }else{
          $("#<?= $lv_sec; ?> #mattbl tbody tr").removeClass("hidden");
        }
      });
      
      $("#<?= $lv_sec; ?> #cntwrn").click(()=>{
        let lv_othvew = $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success:not(.hidden), #<?= $lv_sec; ?> #mattbl tbody tr.bg-danger:not(.hidden)").length > 0;
        if(lv_othvew){
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-warning").removeClass("hidden");
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").addClass("hidden");
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").addClass("hidden");
        }else{
          $("#<?= $lv_sec; ?> #mattbl tbody tr").removeClass("hidden");
        }
      });
      
      $("#<?= $lv_sec; ?> #cnterr").click(()=>{
        let lv_othvew = $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success:not(.hidden), #<?= $lv_sec; ?> #mattbl tbody tr.bg-warning:not(.hidden)").length > 0;
        if(lv_othvew){
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").removeClass("hidden");
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").addClass("hidden");
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-warning").addClass("hidden");
        }else{
          $("#<?= $lv_sec; ?> #mattbl tbody tr").removeClass("hidden");
        }
      });
      $("#<?= $lv_sec; ?> #btnbck").click(()=>{
         Dropzone.forElement("#myDropzone").removeAllFiles();
        $('#<?= $lv_sec; ?> #preview').animate({left: '100%'}, 500, function() {
          $(this).addClass('hidden').css('left', '0');
          $('#<?= $lv_sec; ?> #selection').css('left', '-100%').removeClass('hidden').animate({left: '0%'}, 500);
          $('#<?= $lv_sec; ?>').parent().parent().parent().parent().find("#btnnxt").addClass('hidden');
        });
      });
      
     tmssLoadScript("dropzone",function(){
      //DROPZONE	
      if (!window.File || !window.FileReader || !window.FileList || !window.Blob) {
        swal.fire({title:"Error",html:"El navegador no soporta la lectura de archivos.",icon:"error"});
      } else {
        $(function(){		
          $("#myDropzone").dropzone({ 
            url:"/",
            paramName: "uplfle", 
            maxFilesize: 5, 
            acceptedFiles:"text/csv,.csv,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",    
            dictDefaultMessage: "</br></br></br></br></br></br>"+
                                "<h3><b>Arrastra y suelta o haz clic aqu&iacute; para agregar archivos<b/></h3>", 
            maxFiles: 1, 
            init: function() {
              this.on("success", function(file, response) {
                  loadPreview(file);
              });
            }
          });
        });
      }
  	});     
   });
  </script>
  <script>
    //boton save
    $("#<?= $lv_sec; ?> #btnsve").click(function(e){e.preventDefault();
      let lo_arr = gv_<?= $lv_sec; ?>_acclst;
      if(!lo_arr || lo_arr.length == 0) return;

      for(let lv_i=0; lv_i<lo_arr.length; lv_i++){
          if(lo_arr[lv_i].errtyp === 'E') {
              toastr.warning("Existen cuentas con errores. Por favor corrigelos antes de guardar.");
              return;
          }
      }

      let lv_secpar = $("#<?= $lv_sec; ?>").closest(".modal").attr("data-parent-sec");       
      
      // Buscamos el jstree
      let lo_ref = $(".tmss-acc-tree").jstree(true);
      if(!lo_ref) { toastr.warning("El árbol no está listo"); return; }

      let lo_nodrot = lo_ref.get_node("#").children[0];
      if(!lo_nodrot) { toastr.warning("No se encontró el nodo raíz del árbol"); return; }

      let lo_arrchi = [...lo_ref.get_node(lo_nodrot).children];
      for(let lv_i=0; lv_i<lo_arrchi.length; lv_i++) {
          lo_ref.delete_node(lo_arrchi[lv_i]);
      }

      let lo_mapnod = {};
      lo_mapnod[""] = lo_nodrot;

      
      for(let lv_i=0; lv_i<lo_arr.length; lv_i++){
          let lv_finaccplnlvl    = lo_arr[lv_i].finaccplnlvl || "";
          let lv_finaccplntxt    = lo_arr[lv_i].finaccplnlvltxt || "";
          let lv_acc  = lo_arr[lv_i].type === "account";
          let lv_finacccod = lo_arr[lv_i].finacccod || 0;
          let lv_curcod = lo_arr[lv_i].curcod || "";
          let lv_finaccclscod = lo_arr[lv_i].finaccclscod || "";

          if(lv_finaccplnlvl == "" || lv_finaccplntxt == "") continue;

          let lo_arrprt = lv_finaccplnlvl.split(".");
          lo_arrprt.pop();
          let lv_lvlpar = lo_arrprt.join(".");
          let lo_nodpar = lo_mapnod[lv_lvlpar] || lo_nodrot;

          let lv_idnod = lo_ref.create_node(lo_nodpar, {
              "text": lv_finaccplntxt,
              "type": lv_acc ? "account" : "folder",
              "data": {
                  "finacccod": lv_finacccod,
                  "finaccplnlvl": lv_finaccplnlvl,
                  "curcod": lv_curcod,
                  "finaccclscod": lv_finaccclscod
              }
          });

          if(lv_idnod) {
              lo_mapnod[lv_finaccplnlvl] = lv_idnod;
          }
      }
      
      lo_ref.open_all(lo_nodrot);
      toastr.success("Plan de cuentas cargado correctamente desde el archivo");
      // Muestra el botón de descarga en la vista principal si hay datos
      $(".tmss-acc-tree").closest(".card").find("#btndwn").removeClass("hidden");
      BootstrapDialog.closeAll();
    });
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>

