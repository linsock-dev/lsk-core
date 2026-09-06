<?php
	// url del formulario 
  $lv_lnk = '?prg=slsprc';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->slsprclstvercod;

	// titulo 
	$lv_title = $vew_lang->upload;
	
	// módulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'PRC';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">  
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">    
    <?= gethtml('slsprclstcod','hidden', $vew_data->slsprclstcod); ?>
    <?= gethtml('slsprclstvercod','hidden', $vew_data->slsprclstvercod); ?>
    <?= gethtml('slsprclst','hidden',''); ?>
    <?= gethtml('slsprcrsh','hidden','false'); ?>
    <?= gethtml('slsprclstancvar','hidden', $vew_data->slsprclstancvar??''); ?>     
    <?= gethtml('sysdocclscod','hidden', $vew_data->sysdocclscod); ?>
		<?= gethtml('btnsve','hidden',false); ?>

		<div class="container-fluid">	
			<div class="card" id="selection">
				<div class="card-header">
					<div class="card-title"><?= $vew_lang->upload;?>
						<a href="#" id="btndemo" onclick="" class="card-icon pull-right" title="descargar modelo de precios"><i class="far fa-download"></i></a>
					</div>
				</div>
				<div class="card-body tmss-card-body-edit">
          <!--DROPEZONE-->  
          <div id="myDropzone" class="dropzone">
            <input type="file" id="uplfle" class="hidden" charset="utf-8">
          </div>
				</div>
			</div>
			<div class="card hidden" id="preview">
				<div class="card-header"><div class="card-title">
					<a class="card-icon pull-left" id="btnbck"><i class="far fa-arrow-circle-left"></i></a><?= $vew_lang->preview; ?>
					<span class="card-icon">
						<a class="text-success" id="cntscs"><i class="far fa-check-circle"></i></a> / <a class="text-danger" id="cnterr"><i class="far fa-exclamation-triangle"></i></a>
					</span>
					</div>
				</div>
				<div class="card-body">
          <?= gethtml('slsprdec','hidden',''); ?>
					<div class="tmss-vertbl-scroll">
						<table id="mattbl" class="table table-condensed">
							<thead>
								<tr valign="top">
									<th width="20"> <?= $vew_lang->code; ?></th>
									<th> <?= $vew_lang->description; ?></th>
									 <th width="120"><div class="dropdown">
                    <a class="dropdown-toggle" role="button" id="prcdec" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Precio<span class="caret"></span></a>
                     <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="prcdec">
                      <li class="dropdown-header">formato de decimales</li>
                    	<li class="dropdown-item text-center" href="#" value="2"><a href="#">0,00 (coma)</a></li>
                      <li class="dropdown-item text-center active" href="#" value="1"><a href="#">0.00 (punto)</a></li>
                    </ul>
                  </div>
										</th>
									<th width="20"><?= $vew_lang->quantity; ?></th>
									<th width="30"> UM </th>
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
		var gv_<?= $lv_sec; ?>_matlst = [];
		
    tmssLoadScript("sheetjs",function(){
      
      //DESCARGAR MODELO 
      $("#<?= $lv_sec; ?> #btndemo").click(<?= $lv_sec; ?>_exportToExcel);
    	function <?= $lv_sec; ?>_exportToExcel() {
				// Datos para la tabla
        var data = [
          { CODIGO_EXTERNO: "COD001", PRECIO: 30425,  CANTIDAD: 1, UNIDAD: "UN" },
          { CODIGO_EXTERNO: "CODEXT", PRECIO: 23208.10,   CANTIDAD: 1, UNIDAD: "UN" },
          { CODIGO_EXTERNO: "22222", PRECIO: 11000.99, CANTIDAD: 1, UNIDAD: "UN" },
          { CODIGO_EXTERNO: "01160702100288", PRECIO: 4300.00,  CANTIDAD: 1, UNIDAD: "UN" }
        ];

        // Crea un objeto de trabajo de Excel
        var workbook = XLSX.utils.book_new();

        // Crea una hoja de trabajo y la asigna al libro
        var sheet = XLSX.utils.json_to_sheet(data);
        XLSX.utils.book_append_sheet(workbook, sheet, 'Hoja1');

        var excelBinary = XLSX.write(workbook, { bookType: 'xlsx', type: 'binary', mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });

        // Convierte el archivo binario a Blob
        var blob = new Blob([<?= $lv_sec; ?>_stringToarraybuffer(excelBinary)], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
        <?= $lv_sec; ?>_saveAs(blob, 'modelo_de_precios.xlsx');
      }
			
      // Función para convertir string a ArrayBuffer
      function <?= $lv_sec; ?>_stringToarraybuffer(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
      }
			
      // Función para guardar el archivo
      function <?= $lv_sec; ?>_saveAs(blob, fileName) {
        var link = document.createElement('a');
        link.href = window.URL.createObjectURL(blob);
        link.download = fileName;
        link.click();
      }
      let gv_matlst = [];
			// PROCESO. se procesa el archivo cargado
		  function loadPreview(lp_fle){	
				lo_reader = new FileReader();
				lo_reader.readAsArrayBuffer( lp_fle );
				lo_reader.onload = function (evt) {
          lo_dat = lo_reader.result;
					lo_wb = XLSX.read(lo_dat, {type: 'array'});
					lo_ws = lo_wb.Sheets[lo_wb.SheetNames[0]];
					lo_arr = XLSX.utils.sheet_to_json(lo_ws, {header:1});
					lv_hotarr = [];

					// prepara lista de materiales cargados desde archivo
					gv_matlst = [];
					for(var i=1; i<lo_arr.length; i++){
            if(lo_arr[i][0]!=undefined && lo_arr[i][0]!="" ) {
							gv_matlst.push({matcodext: lo_arr[i][0],
															matprcbse: lo_arr[i][1],
                              matprc:lo_arr[i][1],
															matqty: lo_arr[i][2],
															matuntcod: lo_arr[i][3],
															errtyp:"",
															errcod:"",
															errtxt:""});
						}
					}
					// validacion de materiales
					var lv_pstdat=[ {name:"slsprclstcod",value:$("#<?= $lv_sec; ?> #slsprclstcod").val()},
													{name:"matlst",value:JSON.stringify(gv_matlst)}];
					tmssCallProcess("?prg=slsprclst&act=slsprcuplchk",lv_pstdat,function(data){ 
						gv_<?= $lv_sec; ?>_matlst = data;
            var lv_buffer="";
            lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+data.length+"</span></span>";
            $("#<?= $lv_sec; ?> #datqty").html(lv_buffer);
            lv_buffer="";
						for(var i=0; i<gv_matlst.length; i++){
              //recupero datos
              gv_matlst[i].srcobjtyp = data[i].srcobjtyp;
            	gv_matlst[i].matcod = data[i].matcod;
              gv_matlst[i].mattxt = data[i].mattxt??data[i].errtxt;//posible cambio para mostrar la descripcion
              gv_matlst[i].matprcbse=data[i].matprcbse;
              gv_matlst[i].errtyp=data[i].errtyp;
              lv_fnd=data[i].errtyp=="S";
              lv_matuntcoderr=data[i].errtyp!="S" && data[i].errcod==-2;
              //asigno formato de precio por default
              lv_prc=String(gv_matlst[i].matprcbse);
              lv_prc = lv_prc.replace(".","").replace(",",".");	// simbolo decimal ','
              lv_prc=parseFloat(lv_prc).toFixed(2);
              gv_matlst[i].matprc=lv_prc;
              //agrego tr
              lv_buffer +="<tr valign='top' class='"+(lv_fnd?"bg-success":"bg-danger")+"'>";
              lv_buffer += 	"<td>"+gv_matlst[i].matcodext+"</td>";
              lv_buffer += 	"<td>"+ gv_matlst[i].mattxt+"</td>";
              lv_buffer += 	"<td class='text-right'>"+Number(gv_matlst[i].matprc).toLocaleString()+"</td>";
              lv_buffer += 	"<td class='text-right'>"+gv_matlst[i].matqty+"</td>";
              lv_buffer += 	"<td>"+gv_matlst[i].matuntcod+(lv_matuntcoderr?"&nbsp<a class='text-danger'  title='"+data[i].errtxt+"'><i class='far fa-exclamation-triangle'></i></a>":"")+"</td>";
              lv_buffer += "</tr>";
						}
            $("#<?= $lv_sec; ?> #mattbl tbody").html(lv_buffer);
            $("#<?= $lv_sec; ?> #cntscs i").text(" "+ $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").length);
            $("#<?= $lv_sec; ?> #cnterr i").text(" "+ $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").length);
            $("#<?= $lv_sec; ?> #mattbl tbody tr .bg-danger").length;
						$("#<?= $lv_sec; ?> #slsprclst").val( JSON.stringify( gv_matlst ) );
					});
				};
			} 
      
      //BOTONES PREVIEW
      $("#<?= $lv_sec; ?> #cntscs").click(()=>{
        if(!$("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").hasClass("hidden")){
        $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").removeClass("hidden");
        $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").addClass("hidden");
        }else{
        	$("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").removeClass("hidden");
        	$("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").removeClass("hidden");
        }
      });
      $("#<?= $lv_sec; ?> #cnterr").click(()=>{
        if(!$("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").hasClass("hidden")){
        $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").addClass("hidden");
        $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").removeClass("hidden");
        }else{
          $("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").removeClass("hidden");
        	$("#<?= $lv_sec; ?> #mattbl tbody tr.bg-success").removeClass("hidden");
        }
      });
      $("#<?= $lv_sec; ?> #btnbck").click(()=>{
         Dropzone.forElement("#myDropzone").removeAllFiles();
        $('#<?= $lv_sec; ?> #preview').animate({left: '100%'}, 500, function() {
          $(this).addClass('hidden').css('left', '0');
          $('#<?= $lv_sec; ?> #selection').css('left', '-100%').removeClass('hidden').animate({left: '0%'}, 500);
        });
      });
      
      $("#<?= $lv_sec; ?> .dropdown-item").click(function(){
        //valida que si cambie el formato y no se selecione el mismo
        $("#<?= $lv_sec; ?> .dropdown-item").removeClass("active");
        $(this).addClass("active");
        if($("#<?= $lv_sec; ?> #slsprcdec").val()!=$(this).val()){
        	$("#<?= $lv_sec; ?> #slsprcdec").val($(this).val());
					$("#<?= $lv_sec; ?> table tbody tr").each(function(i, row) {
            lv_prc=gv_matlst[i].matprcbse;
            if( $("#<?= $lv_sec; ?> #slsprcdec").val()==1 ){
              lv_prc = lv_prc.replace(",","");	// simbolo decimal '.'
            } else if ( $("#<?= $lv_sec; ?> #slsprcdec").val()==2 ) {
              lv_prc = lv_prc.replace(".","").replace(",",".");	// simbolo decimal ','
            }
            lv_prc=parseFloat(lv_prc).toFixed(2);
            gv_matlst[i].matprc=lv_prc;
            $(row).find('td:eq(2)').text(Number(lv_prc).toLocaleString());
					});
          $("#<?= $lv_sec; ?> #slsprclst").val( JSON.stringify( gv_matlst ) );
        }
      });
      
     tmssLoadScript("dropzone",function(){
      //DROPZONE	
      if (!window.File || !window.FileReader || !window.FileList || !window.Blob) {
        swal.fire({title:"Error",html:"El navegador no soporta la lectura de archivos.",icon:"error"}).then((result)=>{
          document.location.href("/invoices");	
        });
      } else {
        $(function(){		
          $("#myDropzone").dropzone({ // camelized version of the `id`
            url:"/",
            paramName: "uplfle", // The name that will be used to transfer the file
            maxFilesize: 5, // MB
            acceptedFiles:"application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",    
            dictDefaultMessage: "</br></br></br></br></br></br>"+
                                "<h3><b>Arrastra y suelta o haz clic aqu&iacute; para agregar archivos<b/></h3>", // Cambiar el mensaje por defecto
            maxFiles: 1, // Solo se permite un archivo
            init: function() {
              this.on("success", function(file, response) {
                  loadPreview(file);
                  $('#<?= $lv_sec; ?> #selection').animate({left: '-100%'}, 500, function() {
                  $(this).addClass('hidden').css('left', '0');
                  $('#<?= $lv_sec; ?> #preview').removeClass('hidden').css('left', '100%').animate({left: '0'}, 500);
                  $('#<?= $lv_sec; ?>').parent().parent().parent().parent().find("#btnnxt").removeClass('hidden');
                });
              });
            }
          });
        });
      }
  	});     
   });
  </script>
  <script>
    function <?= $lv_sec; ?>_save (lp_replace){
      //recupero los datos de la tabla
      lv_arrmat=JSON.parse($("#<?= $lv_sec; ?> #slsprclst").val());
      //filtro por registros exitosos
			lv_arrmat = lv_arrmat.filter(lv_row => lv_row.errtyp == "S");
      //hago un mapeo para poder grabarlo correctamente
      lv_arr = lv_arrmat.map(({ matcod,matprc,matqty,matuntcod,srcobjtyp }) => (
        														{slsprcsrctyp:srcobjtyp,
        														slsprcsrccod: matcod,
        														slsprc: matprc,
        														slsprcqty: matqty,
        														slsprcuntcod: matuntcod
      															}
      ));
      var lv_pstdat=[{name:"upl",value:true},
                    {name:"slsprclst",value:JSON.stringify(lv_arr)},
                    {name:"slsprclstcod",value:$("#<?= $lv_sec; ?> #slsprclstcod").val()},
                    {name:"slsprclstvercod",value:$("#<?= $lv_sec; ?> #slsprclstvercod").val()},
                    {name:"slsprcrpl",value:lp_replace}, 
                    ];
      tmssCallProcess("?prg=slsprclst&act=00",lv_pstdat,function(data){ 
          if(data.errtyp="S"){
            toastr.success(data.errtxt,"Precios");
            $("#<?= $lv_sec; ?> #slsprcrsh").val('true');
          }
    			BootstrapDialog.closeAll();
      });
    } 
    // Función para validar errores y si desea grabar los que estan bien
    function <?= $lv_sec; ?>_validarErrores() {
      return  new Promise((resolve, reject) => {
          if($("#<?= $lv_sec; ?> #mattbl tbody tr.bg-danger").length>0){
          BootstrapDialog.show({
            title: "Grabado",
            message:"Se encontraron algunos errores, desea grabar de igual modo solo los registros correctos?",
            type: BootstrapDialog.TYPE_WARNING,
            buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default'", action: function(dialog){ resolve(false);dialog.close();} },
										{label: "<?= $vew_lang->continue ?>", cssClass: "btn-warning",	action: function(dialog){resolve(true);dialog.close();}}]
          });
        }
        else{resolve(true);}
      });
    }
    //boton save
    $("#<?= $lv_sec; ?> #btnsve").click(function(e){e.preventDefault();
      <?= $lv_sec; ?>_validarErrores().then((resultado) => {
      	if (resultado) {
          BootstrapDialog.show({
            title: "Seleccione el metodo de Grabado",
            message:"<div class='list-group' id='lstsve'>"
            +"<a href='#' class='list-group-item' value=1><h4 class='list-group-item-heading'>Reemplazar</h4><p class='list-group-item-text'>se reemplazan los precio cargados en la version actual por los de la lista cargada</p></a>"
           	+"<a href='#' class='list-group-item' value=2><h4 class='list-group-item-heading'>Agregar</h4><p class='list-group-item-text'>se agregan los precio cargados a la version actual y en caso de ya estar cargados se reemplaza por el nuevo</p></a>"
            +"<div>",
            type: BootstrapDialog.TYPE_PRIMARY,
            buttons:[{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default'", action: function(dialog){dialog.close();} },
										{label: "<?= $vew_lang->save ?>", cssClass: "btn-success",	action: function(dialog){
                      lv_val=dialog.$modalBody.find("#lstsve a.active").attr("value");
                      if(lv_val==1)<?= $lv_sec; ?>_save (true);
                      else if(lv_val==2) <?= $lv_sec; ?>_save (false);                                                                                         
                      dialog.close();}}],
            onshown:function(dialog){
            	dialog.$modalBody.find(".list-group-item").click(function(){
              //valida que si cambie el formato y no se selecione el mismo
              dialog.$modalBody.find(".list-group-item").removeClass("active");
              $(this).addClass("active");
              });
          }
          });      	
        }
      });
    });
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>