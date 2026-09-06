<?php
	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	$vew_input->RequiredFields( array('sysdocclscod','docfndstrdte','docfndenddte') );

	// ----------------------------------------------------------
	// los siguientes valores generalmente permanecen sin cambios	
	// -- id de secci?n
	$lv_sec = $vew_token;

	// ----------------------------------------------------------	
	$lv_strdte = new DateTime(date('Y-m-d'));
	$lv_strdte->modify('-2 months');
	$lv_enddte = new DateTime(date('Y-m-d'));
?>
<section id="<?= $lv_sec; ?>">

	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
		<textarea class="hidden" id="refarr" name="refarr"><?= $vew_data->refarr; ?></textarea>
		
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-4" id="divfndsec">
					<div class="container-fluid" id="divfndsecfld">
						<div class="form-group tmss-form-group">
							<label class="control-label col-xs-2">Clase</label>
							<div class="col-xs-10">
							<select id="sysdocclscod" name="sysdocclscod" class="form-control">
								<option></option>
								<?php 
									foreach($vew_doccls as $lv_row) {
										echo '<option data-objtyp="'.$lv_row['objtyp'].'" value="'.$lv_row['sysdocclscod'].'">'.$lv_row['sysdocclstxt'].'</option>';
									}
								?>
							</select>
							</div>
						</div>
						<div class="form-group tmss-form-group">
							<label class="control-label col-xs-2">Ruta</label>
							<div class="col-xs-10">
							<input type="text" class="form-control tmssAlwaysDisabled" id="traroutxt" name="traroutxt" value="<?= $vew_data->trarou->traroutxt; ?>" readonly="readonly">
							<input type="hidden" id="traroucod" name="traroucod" value="<?= $vew_data->trarou->traroucod; ?>">
							</div>
						</div>
						<div class="form-group tmss-form-group">
							<label class="control-label col-xs-2">ID</label>
							<div class="col-xs-10"><?= gethtml('docfndcod','doccod','',$lv_default); ?></div>
						</div>
						<div class="form-group tmss-form-group">
							<label class="control-label col-xs-2">Nro</label>
							<div class="col-xs-10"><?= gethtml('docfndcodext','doccmt1x20','',$lv_default); ?></div>
						</div>
						<div class="form-group tmss-form-group">
							<label class="control-label col-xs-2">Desde</label>
							<div class="col-xs-10"><?= gethtml('docfndstrdte','docdte',$lv_strdte->format('d/m/Y'),$lv_default); ?></div>
						</div>
						<div class="form-group tmss-form-group">
							<label class="control-label col-xs-2">Hasta</label>
							<div class="col-xs-10"><?= gethtml('docfndenddte','docdte',$lv_enddte->format('d/m/Y'),$lv_default); ?></div>
						</div>
						<div class="form-group tmss-form-group">
							<div class="text-right">
								<button class="btn btn-primary" id="btnfnd"><span class="far fa-search"></span> Buscar</button>
							</div>
						</div>
					</div>
				</div> <!-- /col-md-4 -->
				<div class="col-md-8" id="divfndres">
					<div id="norecords" style="display: none;" class="container-fluid">
						<h3><i class="far fa-exclamation-triangle"></i>&nbsp;&nbsp;No se encontraron resultados.</h3>
					</div>
					<button class="btn btn-primary" id="btntblfndbtn"><span class="far fa-angle-double-left"></span></button><br>
					<table id="doctbl" class="table table-condensed table-bordered hidden">
						<thead>
							<tr>
								<th><input type="checkbox" name="hdrchk"></th>
								<th>ID</th>
								<th>Fecha</th>
								<th>Num.Ext</th>
								<th>Atributos</th>
							</tr>
						</thead>
						<tbody id="doctblbdy"></tbody>
					</table>
				</div> <!-- /col-md-8 -->
			</div> <!-- /row -->
		</div> <!-- /container-fluid -->
	</form>
  <script>
		$("#<?= $lv_sec; ?> #btntblfndbtn").on("click",function(e){
			if ( $(this).find("span:first").hasClass("fa-angle-double-left") ) {
				$(this).find("span:first").addClass("fa-angle-double-right").removeClass("fa-angle-double-left");
				$("#<?= $lv_sec; ?> #divfndsec").hide();
				$("#<?= $lv_sec; ?> #divfndres").addClass("col-md-12").removeClass("col-md-8");
			} else {
				$(this).find("span:first").addClass("fa-angle-double-left").removeClass("fa-angle-double-right");
				$("#<?= $lv_sec; ?> #divfndsec").show("slow");
				$("#<?= $lv_sec; ?> #divfndres").addClass("col-md-8").removeClass("col-md-12");
			}
			e.preventDefault();
			e.stopPropagation();
		});
	
		$("#<?= $lv_sec; ?> #btnfnd").on("click",function(e){
			$("#<?= $lv_sec; ?> #doctbl").addClass("hidden");
			$("#<?= $lv_sec; ?> #norecords").hide();
			var lv_datpst = [	{name: "sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
												{name: "traroucod", value: $("#<?= $lv_sec; ?> #traroucod").prop("value")},
												{name: "docfndcod", value: $("#<?= $lv_sec; ?> #docfndcod").prop("value")},
												{name: "docfndcodext", value: $("#<?= $lv_sec; ?> #docfndcodext").prop("value")},
												{name: "docfndstrdte", value: $("#<?= $lv_sec; ?> #docfndstrdte").prop("value")},
												{name: "docfndenddte", value: $("#<?= $lv_sec; ?> #docfndenddte").prop("value")},
												{name: "refarr", value: $("#<?= $lv_sec; ?> #refarr").text()}
											];
			tmssCallProcess("?prg=logtra&act=27", lv_datpst, function(data) {
				if ( Array.isArray(data) ) {
					if ( data.length==0 ) {
						$("#<?= $lv_sec; ?> #norecords").show();
					} else {
						$("#<?= $lv_sec; ?> #doctbl").removeClass("hidden");
						var lv_dsttxt = "";
						var lv_dstobjtxt = "";
						var lv_dstcnttxt = "";
            var lv_dstcod = "";
            var lv_dstobjtyp = "";
						var lv_tbl = "";
            var lv_ctedte= "";
            var lv_stkmovobjtyp = "";
            var lv_adrmapgeo = "";
						for(var i=0; i<data.length; i++) {
             	lv_stkmovobjtyp = $("#<?= $lv_sec; ?> #sysdocclscod option:selected").data("objtyp") ;
							lv_dstobjtxt = (lv_stkmovobjtyp=="STK_SOU" ?
														data[i]["dstobjtxt"] : data[i]["srcobjtxt"]
													);
							lv_dstcnttxt = (lv_stkmovobjtyp=="STK_SOU" ?
														data[i]["dstcnttxt"] : data[i]["srccnttxt"]
													);
              lv_dstcod =  lv_stkmovobjtyp=="STK_SOU"?(!lv_dstcnttxt ? data[i]["dstobjcod"] : data[i]["dstcntcod"]):(!lv_dstcnttxt ? data[i]["srcobjcod"] : data[i]["srccntcod"]);
							
              lv_dstobjtyp = lv_stkmovobjtyp=="STK_SOU"? data[i]["dstobjtyp"]:data[i]["srcobjtyp"];

              lv_adrmapgeo = (lv_stkmovobjtyp=='STK_SOU'?(data[i]["dstcnttxt"]?data[i]['dstcntmapgeo']:data[i]['dstobjmapgeo'])
                             :(lv_stkmovobjtyp=='STK_SIN'?(data[i]["srccnttxt"]?data[i]['srccntmapgeo']:data[i]['srcobjmapgeo'])
                          	 :''));  
							lv_dsttxt = "<strong>"+( (lv_dstcnttxt=="" || lv_dstcnttxt==null) ?lv_dstobjtxt:lv_dstcnttxt)+"</strong> <br> <small>"+lv_dstobjtxt+"</small>";
              lv_tbl += "<tr>"
												+"<td><input type='checkbox' name='dlvchk' data-adrmapgeo='"+lv_adrmapgeo+"' data-dstcod='"+lv_dstcod+"' data-dstobjtxt='"+lv_dstobjtxt+"' data-dstcnttxt='"+lv_dstcnttxt+"'  data-stkmovobjtyp='"+lv_stkmovobjtyp +"' data-stkmovdoccod='"+data[i]["doccod"]+"' data-docsts='"+data[i]["docsts"]+"' data-ctedte='"+data[i]["ctedte"]+"' data-accdte='" + (data[i]["accdte"] || "") + "' data-stkmovdoccodext='"+data[i]["doccodext"]+"' data-dstobjtyp='"+lv_dstobjtyp+"' ></td>"
												+"<td>"+data[i]["doccod"]+"</td>"
												+"<td>"+data[i]["docdte"]+"</td>"
												+"<td>"+data[i]["doccodext"]+"</td>"
												+"<td>"+lv_dsttxt+"</td>"
												+"</tr>";
						}
						$("#<?= $lv_sec; ?> #doctblbdy").html( lv_tbl );
						$("#<?= $lv_sec; ?> input[name='hdrchk']").on("click",function(e){
							var lv_chk = $(this).prop("checked");
							$("#<?= $lv_sec; ?> input[name='dlvchk']").each(function(e){
								$(this).prop("checked",lv_chk).trigger("change");
							});
						});
						$("#<?= $lv_sec; ?> input[name='dlvchk']").on("change",function(e){
							if ( $(this).is(":checked") ) {
								$(this).parent().parent().addClass("bg-info");
							} else {
								$(this).parent().parent().removeClass("bg-info");
							}
						});
						$("#<?= $lv_sec; ?> #divfndres").removeClass("col-md-8").addClass("col-md-12");
						$("#<?= $lv_sec; ?> #btntblfndbtn").find("span:first").addClass("fa-angle-double-right").removeClass("fa-angle-double-left");
						$("#<?= $lv_sec; ?> #divfndsec").hide();
					}
				}
			});
			e.preventDefault();
			e.stopPropagation();
		});
  </script>
</section>