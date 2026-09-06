<?php		
	/* url del formulario */
  $lv_lnk = '?prg=spttrfver&prm_spttrfvercod='.$vew_data->spttrfvercod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->spttrfvercod;

	/* titulo */
	$lv_title = $vew_lang->version;
	
	/* módulo y programa */
	$lv_mdlcod = 'SPT';
  $lv_prgcod = 'TRF';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
      <div class="row">
        <div class="col-md-5">
          <div class="card">
          	<div class="card-header">
              <div class="card-title"><?= $vew_lang->Version;?> <strong><span><small> #<?= $vew_data->spttrfvercod; ?></small></span></strong>
               <input type="hidden" id="spttrfvercod" name="spttrfvercod" value="<?= $vew_data->spttrfvercod; ?>">
               <!--Dropdown-->
                <a href="#" class="btn-group dropdown card-icon dropdown-toggle pl-15 pr-15" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></a>		
                <ul class="card-dropdown-menu dropdown-menu dropdown-menu-right" aria-labelledby="dLabel">
                	<!--Actualizar-->
                  <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmss-Opt"><i class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
                  <!-- Nuevo -->
                  <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '01'});"  class="tmss-Opt tmssHiddeOnEdit" ><i class="far fa-file"></i><?= $vew_lang->new; ?></a></li><?php } ?>
                  <!-- Copiar-->
                  <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'001')) { ?><li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '001'});" class="tmss-Opt tmssHiddeOnEdit" ><i class="far fa-copy"></i><?= $vew_lang->copy; ?></a></li><?php } ?>
                 	<!--Borrar-->
                  <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly){ ?>
                  <li class="divider"></li>
                  <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});" class="tmss-Opt tmssHiddeOnEdit" ><i class="fas fa-trash-alt"></i><?= $vew_lang->delete; ?></a></li>
                	<?php } ?>
                 	<!-- Info -->
                 	<li class="divider"></li>
                 	<li><a href="#" class="tmss-Opt" id="btnshowinfo"><i class="fas fa-info"></i><?= $vew_lang->additionalInfo; ?></a></li>
                </ul>
                <!--Modificar-->
                <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="card-icon tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><i class="fas fa-pencil-alt"></i></a><?php } ?>
								<!--Grabar-->
                <a href="#" id="" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="card-icon btn tmssHiddeOnRead btn-success" title="Grabar"><i class="fas fa-save"></i></a>
                <!--Cancelar-->
								<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="card-icon btn tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><i class="fas fa-times"></i></a>	
                	
              </div><!-- cierre card-title-->
            </div><!-- cierre card-header -->
            <div class="card-body tmss-card-body-edit">
            	<input type="hidden" id="spttrfcod" name="spttrfcod" value="<?= $vew_data->spttrfcod; ?>">
              <?= vew_boot($lv_colsm39, array('label'=>$vew_lang->start, 'input'=>gethtml('spttrfverstrdte', 'docdte', $vew_data->spttrfverstrdte, $lv_default) )); ?>
              <?= vew_boot($lv_colsm39, array('label'=>$vew_lang->end, 'input'=>gethtml('spttrfverenddte', 'docdte', $vew_data->spttrfverenddte, $lv_always_disabled) )); ?>
              <?= vew_boot($lv_colsm39, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 					'docsts', 		$vew_data->docsts, 					$lv_default) )); ?>
            </div><!-- cierre card-body -->
          </div><!-- cierre card -->
        </div><!-- cierre md5 -->
        <div class="col-md-7">
          <div class="card">
            <div class="card-header">
              <div class="card-title">Lista de versiones</div>
            </div><!-- cierre card-header -->
            
            <div class="card-body">
              <div class="tmss-vertbl-scroll">
                <table id="vertbl" class="table table-hover">
                  <thead>
                    <tr valign="top" name="lnkstu">
                      <th> <?= $vew_lang->id ?> </th>
                      <th> <?= $vew_lang->from ?> </th>
                      <th> <?= $vew_lang->to ?> </th>
                      <th> <?= $vew_lang->status ?> </th>
                    </tr>
                  </thead>
                  <tbody></tbody>
                </table>
              </div>
              <div id="datqty"></div>	   
            </div>
            
          </div><!-- cierre card2 -->
        </div><!-- cierre md7 -->
      </div><!-- cierre del row -->
    </div> <!-- container-fluid -->
  </form>

	<script>

		//LISTADO DE VERSIONES
		var lv_pstdat = [ {name:"spttrfcod",value:$("#<?= $lv_sec; ?> #spttrfcod").prop("value")}	];

		tmssCallProcess("?prg=spttrfver&act=29", lv_pstdat, function(data){
				var lv_buffer="";
				lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+data.length+"</span></span>";
				$("#<?= $lv_sec; ?> #datqty").html(lv_buffer);
				lv_buffer="";
				for (var stu in data) {
					lv_buffer +="<tr valign='top' name='lnkstu' class='"+(data[stu].spttrfvercod == "<?= $vew_data->spttrfvercod;?>"?"bg-info":"")+"' data-spttrfvercod='"+data[stu].spttrfvercod+"'>";
					lv_buffer += 	"<td>"+(data[stu].spttrfvercod==null?'-':data[stu].spttrfvercod)+"</td>";
					lv_buffer += 	"<td>"+(data[stu].spttrfverstrdtecnv==null?'-':data[stu].spttrfverstrdtecnv)+"</td>";
					lv_buffer += 	"<td>"+(data[stu].spttrfverenddtecnv==null?'-':data[stu].spttrfverenddtecnv)+"</td>";
					lv_buffer += 	"<td>"+data[stu].docsts+"</td>";
					lv_buffer += "</tr>";
				}	
				$("#<?= $lv_sec; ?> #vertbl tbody ").html(lv_buffer);

				//Evento click, con esto recibo obtengo el id de la version en la cual hago click
				$("#<?= $lv_sec; ?> #vertbl tbody tr").click(function(){
					var lv_vercod = $(this).data("spttrfvercod");
					$("#<?= $lv_sec; ?> #spttrfvercod").val(lv_vercod);

					var lv_pstdat = [ {name:"spttrfvercod",value:$("#<?= $lv_sec; ?> #spttrfvercod").prop("value")}	];
					tmssCallProcess("?prg=spttrfver&act=13", lv_pstdat, function(data){
						$("#<?= $lv_sec; ?>").html( data );
					});	
				});
		});
	</script>
	<!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>