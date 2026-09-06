<?php 
	$vew_input->RequiredFields( array('sysdocclscod','docfndstrdte','docfndenddte') );

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');

	$lv_strdte = new DateTime(date('Y-m-d'));
	$lv_strdte->modify('-2 months');
	$lv_enddte = new DateTime(date('Y-m-d'));
?>
<section id="<?= $lv_sec; ?>">

	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<?= gethtml('docrev','hidden', $vew_data['docrev']); ?>
		<?= gethtml('fndobjtyp','hidden', $vew_data['fndobjtyp']); ?>
		<?= gethtml('fndobjcod','hidden', $vew_data['fndobjcod']); ?>
		<?= gethtml('fndcntcod','hidden', $vew_data['fndcntcod']); ?>
		<textarea class="hidden" id="refarr" name="refarr"><?= $vew_data['refarr']; ?></textarea>
		
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
              <label><?= $vew_lang->SOURCE ?></label>
              <?= gethtml('sysdocclscod', $vew_doccls, '', $lv_default); ?>
              <label><?= $vew_lang->ID ?></label>
              <?= gethtml('docfndcod','doccod','',$lv_default); ?>
              <label><?= $vew_lang->NUMBER ?></label>
              <?= gethtml('docfndcodext','doccmt1x20','',$lv_default); ?> 
              <label><?= $vew_lang->FROM ?></label>
              <?= gethtml('docfndstrdte','docdte',$lv_strdte->format('d/m/Y'),$lv_default); ?>
              <label><?= $vew_lang->TO ?></label>
              <?= gethtml('docfndenddte','docdte',$lv_enddte->format('d/m/Y'),$lv_default); ?>
            </div>           
					</div>
				</div> <!-- /col-md-3 -->
              
				<div class="col-md-9" id="divfndres">
           <div class="card">
            <div class="card-header">
              <div class="card-title"><?= $vew_lang->DOCUMENTS ?></div>
            </div>
             <div class="card-body">
              <div class="tmss-vertbl-scroll">      
                <table id="doctbl" class="table d-none"> 
                  <div id="norecords" class="container-fluid d-none">
                    <h3><i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;No se encontraron resultados.</h3>
                  </div> 
                  <thead>
                    <tr>
                      <th><?= $vew_lang->ID ?></th>
                      <th><?= $vew_lang->DATE ?></th>
                      <th><?= $vew_lang->EXTERNALNUMBER ?></th>
                      <th><?= $vew_lang->ATTRIBUTES ?></th>
                    </tr>
                  </thead>
                  <tbody id="doctblbdy"></tbody>
                </table>             
               </div> 
             </div>
           </div>    
				</div> <!-- /col-md-9 -->
			</div> <!-- /row -->
		</div> <!-- /container-fluid -->
	</form>
  <script>
		$("#<?= $lv_sec; ?> #btnfnd").on("click",function(e){ e.preventDefault();
			$("#<?= $lv_sec; ?> #doctbl").hide();
			$("#<?= $lv_sec; ?> #norecords").hide();
			var lv_pstdat = [	{name: "sysdocclscod", value: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
								{name: "docfndcod", value: $("#<?= $lv_sec; ?> #docfndcod").prop("value")},
								{name: "docfndcodext", value: $("#<?= $lv_sec; ?> #docfndcodext").prop("value")},
								{name: "docfndstrdte", value: $("#<?= $lv_sec; ?> #docfndstrdte").prop("value")},
								{name: "docfndenddte", value: $("#<?= $lv_sec; ?> #docfndenddte").prop("value")},
								{name: "docrev",    value: $("#<?= $lv_sec; ?> #docrev").prop("value")},
								{name: "fndobjtyp", value: $("#<?= $lv_sec; ?> #fndobjtyp").prop("value")},
								{name: "fndobjcod", value: $("#<?= $lv_sec; ?> #fndobjcod").prop("value")},
								{name: "fndcntcod", value: $("#<?= $lv_sec; ?> #fndcntcod").prop("value")},
								{name: "refarr", value: $("#<?= $lv_sec; ?> #refarr").text()}
							];
			tmssCallProcess("?prg=grldocflw&act=07", lv_pstdat, function(data) {
				if ( Array.isArray(data) ) {
					if ( data.length==0 ) {
						$("#<?= $lv_sec; ?> #norecords").show();
					} else {
						$("#<?= $lv_sec; ?> #doctbl").show();
						var lv_lstdoc = "";
						var lv_tbl = "";
						var i=0;
						while(i<data.length) {
							if (lv_lstdoc!=data[i]["doccod"]){
								lv_tbl += "<tr style='background-color: #f1f1f1;' onclick='$(this).next().toggleClass("+String.fromCharCode(34)+"hidden"+String.fromCharCode(34)+");'>"
													+"<td>"+data[i]["doccod"]+"</td>"
													+"<td>"+data[i]["docdte"]+"</td>"
													+"<td>"+data[i]["doccodext"]+"</td>"
													+"<td>"+data[i]["docatr"]+"</td>"
													+"</tr>";
								lv_lstdoc = data[i]["doccod"];
							}
							lv_tbl += "<tr class='hidden'>"
												+"<td colspan='4'>"
												+"<table class='table table-condensed'>"
												+"<thead><tr><th><input type='checkbox' id='hdrchk' data-doccod='"+data[i]["doccod"]+"'></th><th>ID</th><th>Codigo</th><th>Descripcion</th><th style='text-align: center;'>Cantidad</th><th style='width:120px; text-align: center;'>Cant.Ref</th><th></th></tr></thead>"
												+"<tbody>";
												while(i<data.length && lv_lstdoc==data[i]["doccod"]) {
													data[i]["docposatr"]["doctyp"] = data[i]["doctyp"];
													data[i]["docposatr"]["doccod"] = data[i]["doccod"];
													data[i]["docposatr"]["docposcod"] = data[i]["docposcod"];
													lv_tbl += "<tr style='min-height: 36px;'>"
																	+"<td style='vertical-align: middle;'>"
																		+"<input type='checkbox' id='rowchk' data-doccod='"+data[i]["doccod"]+"' data-docposcod='"+data[i]["docposcod"]+"'>"
																		+"<textarea class='hidden' id='"+data[i]["doccod"]+"_"+data[i]["docposcod"]+"_data'>"+JSON.stringify(data[i]["docposatr"])+"</textarea>"
																	+"</td>"
																	+"<td style='vertical-align: middle;'>"+data[i]["docposcod"]+"</td>"
																	+"<td style='vertical-align: middle;' alt='"+data[i]["docposcod"]+"'>"+data[i]["docposcodext"]+"</td>"
																	+"<td style='vertical-align: middle;'>"+data[i]["docpostxt"]+"</td>"
																	+"<td style='vertical-align: middle; text-align: right;'>"+data[i]["docposqty"]+"&nbsp;"+data[i]["docposuntcod"]+"&nbsp;</td>"
																	+"<td align='right'><input id='"+data[i]["doccod"]+"_"+data[i]["docposcod"]+"_qty' class='form-control' type='number' min='0.01' max='"+data[i]["docposqty"]+"' step='any' value='"+data[i]["docposqty"]+"'></td>"
																	+"<td>"+data[i]["docposatrtxt"]+"</td>"
																	+"</tr>";
													i++;
												}
							lv_tbl += "</tbody>"
												+"</table>"
												+"</td>"
												+"</tr>";
						}						
						$("#<?= $lv_sec; ?> #doctblbdy").html( lv_tbl );
						$("#<?= $lv_sec; ?> #hdrchk").on("click",function(e){
							var lv_chk = $(this).prop("checked");
							$("#<?= $lv_sec; ?> #rowchk[data-doccod="+$(this).data("doccod")+"]").each(function(e){
								$(this).prop("checked",lv_chk).trigger("change");
							});
						});
						$("#<?= $lv_sec; ?> #rowchk").on("change",function(e){
							if ( $(this).is(":checked") ) {
								$(this).parent().parent().addClass("bg-info");
							} else {
								$(this).parent().parent().removeClass("bg-info");
							}
						});
					}
				}
			});
		});
  </script>
</section>