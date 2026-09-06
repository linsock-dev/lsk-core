<?php 
	$vew_input->RequiredFields( array('') );

	// libreria de estilos bootstrap
	include_once('_library.frm');

	// filtros -> fecha, id, ubicacion, nombre material.
	$lv_strdte = new DateTime(date('Y-m-d'));
	$lv_strdte->modify('-2 months');
	$lv_enddte = new DateTime(date('Y-m-d'));
?>
<section id="<?= $lv_sec; ?>">
  <meta charset="UTF-8">
	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
    
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-3" id="divfndsec">
					<div class="card">
            <div class="card-header">   
              <div class="card-title">
              	<?= $vew_lang->REFERENCE;?>
                <!--Buscar-->
   							<a href="#" id="btnfnd" class="card-icon tmssHiddeOnEdit" title="<?= $vew_lang->find; ?>"><i class="fas fa-search"></i></a> 
              </div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <label><?= $vew_lang->location ?></label>
               <?php echo vew_boot($lv_colxs1257, array('input2'=>gethtml('srcobjtyp', array(''=>'', 'SLS_CUS'=>'CLIENTE','HLT_PAT'=>'PACIENTE','STK_STL'=>'ALMACEN'),'', $lv_default)));?>
              <label><?= $vew_lang->ID ?></label>
              <?= gethtml('docfndcod','doccod','',$lv_default); ?>
              <label><?= $vew_lang->name ?></label>
              <?= gethtml('docfndcodext','doccmt1x20','',$lv_default); ?>
              <label><?= $vew_lang->SERIALNUMBER ?></label>
              <?= gethtml('docfndmatsercodext','doccmt1x20','',$lv_default); ?> 
              <label><?= $vew_lang->FROM ?></label>
              <?= gethtml('docfndstrdte','docdte',$lv_strdte->format('d/m/Y'),$lv_default); ?>
              <label><?= $vew_lang->TO ?></label>
              <?= gethtml('docfndenddte','docdte',$lv_enddte->format('d/m/Y'),$lv_default); ?>
            </div>           
					</div>
				</div> <!-- /col-md-3 -->
              
				<div class="col-md-9" id="divfndres">
           <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->DOCUMENTS ?></div></div>
             <div class="card-body">
              <div class="tmss-vertbl-scroll">      
								<div id="norecords" class="container-fluid d-none">
									<h3><i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;No se encontraron resultados.</h3>
								</div> 
                <table id="doctbl" class="table table-condensed table-hover d-none"> 
                  <thead>
                    <tr>
                      <th><input type="checkbox" id="hdrchk"></th>
                      <th>Materiales Solicitados</th>
                    </tr>
                  </thead>
                  <tbody></tbody>
                </table>             
               </div> 
             </div>
           </div>     
				</div> <!-- /col-md-9 -->
			</div> <!-- /row -->
		</div> <!-- /container-fluid -->
	</form>
  <script>
		// CHECKBOX. se fija evento para checkbox de cabecera
		$("#<?= $lv_sec; ?> #hdrchk").on("change",function(){
			$("#<?= $lv_sec; ?> input[name=rowchk]").prop( "checked", $(this).is(":checked") ); 
      $("#<?= $lv_sec; ?> input[name=rowchk]").parents("tr").toggleClass("bg-info", $(this).is(":checked"));
		});
		
		// BUSCAR. realiza busqueda de materiales
		$("#<?= $lv_sec; ?> #btnfnd").on("click",function(e){ e.preventDefault();
			$("#<?= $lv_sec; ?> #doctbl").hide();
			$("#<?= $lv_sec; ?> #norecords").hide();
			var lv_pstdat = [	
								{name: "srcobjtyp", value: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value")},
        				{name: "docfndcod", value: $("#<?= $lv_sec; ?> #docfndcod").prop("value")},
								{name: "docfndcodext", value: $("#<?= $lv_sec; ?> #docfndcodext").prop("value")},
        				{name: "docfndmatsercodext", value: $("#<?= $lv_sec; ?> #docfndmatsercodext").prop("value")},
								{name: "docfndstrdte", value: $("#<?= $lv_sec; ?> #docfndstrdte").prop("value")},
								{name: "docfndenddte", value: $("#<?= $lv_sec; ?> #docfndenddte").prop("value")},
								{name: "stkmanordcod", value: "EE"},
        				{name: "refarr", value: '<?= html_entity_decode( $vew_data->refarr); ?>'}
							]; //(FILTROS)
			tmssCallProcess("?prg=stkmanreq&act=17", lv_pstdat, function(data) {
				// valido existencia de registros
        if( Array.isArray(data) ) {
					if ( data.length==0 ) { $("#<?= $lv_sec; ?> #norecords").show(); return; }
				} else {
					return;
				}
				
				// armo tabla de salida
				$("#<?= $lv_sec; ?> #doctbl").show();
				var lv_tbl = "";
				var i=0;
				while(i<data.length) {
					lv_tbl += "<tr>"
											+"<td>"
												+"<input type='checkbox' name='rowchk' data-matcod='"+data[i]["matcod"]+"'>"
												+"<textarea class='hidden' data-matcod='"+data[i]["matcod"]+"' data-reqcod='"+data[i]["stkmanreqcod"]+"'>"+JSON.stringify(data[i])+"</textarea>"
												+"<td><strong>"+(data[i]["stkmanreqdte"] ?? '')+" - "+(data[i]["srcobjtxt"] ?? '')+"</strong><br>"
          							+"#"					 +(data[i]["matcod"] ?? '')+" - "+(data[i]["mattxt"] ?? '')+(data[i]["matsercodext"] ? " - "+data[i]["matsercodext"] : '')+"<br>"
          							+(data[i]["stkmanreqmatatr"] ? "Descripci\u00F3n: "+data[i]["stkmanreqmatatr"] : '')+"</td>"
											+"</td>"
										+"</tr>";
						i++;
				}
				$("#<?= $lv_sec; ?> #doctbl tbody").html( lv_tbl );
					
				// EVENTO. fija eventos de checkbox
        $("#<?= $lv_sec; ?> #doctbl tbody tr").on("click", function(e) {
          // Verifica si el clic fue dentro de un checkbox para evitar doble activación
          let lv_chkbox = $(this).find("input[name='rowchk']");
          if (!$(e.target).is("input[type=checkbox]")){ 
          	lv_chkbox.prop("checked", !lv_chkbox.prop("checked"));
          }
      		
          lv_chkbox.parents("tr").toggleClass("bg-info", lv_chkbox.prop("checked"));         
          
          $("#<?= $lv_sec; ?> #hdrchk").prop("checked", $("#<?= $lv_sec; ?> #doctbl input[name='rowchk']:checked").length == $("#<?= $lv_sec; ?> #doctbl input[name='rowchk']").length);
        });
			});
		});
  </script>
</section>