<?php
	// url del formulario 
  $lv_lnk = "?prg=sptcrd&prm_ptncod=".$vew_data->ptncod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->ptncod; 

	// titulo 
	$lv_title = $vew_lang->cards;
	
	// módulo y programa 
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'CRD';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
  <nav class="navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
    <div class="navbar-brand"><strong><?=$vew_lang->cards;?></strong></div>
      <ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
        <!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Info-->
						<?php include('grlvewinfbtn.frm'); ?>
						<!--Borrar-->
						<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04')){ ?>
							<li class="divider"></li>
							<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"  class="tmssLink" title="<?= $vew_lang->delete; ?>"><span style="width:20px" class="fas fa-trash-alt"></span><?= $vew_lang->delete; ?></a></li>
						<?php } ?>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
      </ul>
    </div>
  </nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    
    <div class="container-fluid">  
      <table id="ptntbl" class="table table-hover" style="width:100%">
        <thead>
					<tr valign="top" name="lnkstu">
						<th id="ptncheck"><input type='checkbox' name='' id=''></th>
							<th><?= $vew_lang->name;?></th>
							<th><?= $vew_lang->partner;?></th>
							<th><?= $vew_lang->category;?></th>
							<th><?= $vew_lang->taxcode;?></th>
							<th><?= $vew_lang->number;?></th>
							<th><?= $vew_lang->barcode;?></th>
							<th><?= $vew_lang->image;?></th>
							<th><?= $vew_lang->status;?></th>
							<th><?= $vew_lang->comments;?></th>
					</tr>
        </thead>

        <tbody>
        </tbody>
      </table>
      <div id="datqty"></div>		
    </div> <!-- container-fluid -->
  </form>

  <script>

		var gv_<?= $lv_sec; ?>_flt = [
									{'fldttl': '<?= $vew_lang->name; ?>'       , 'fldcod': 'p.ptntxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
									{'fldttl': '<?= $vew_lang->partner; ?>'    , 'fldcod': 'p.ptncodext', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
									{'fldttl': '<?= $vew_lang->category; ?>'   , 'fldcod': 'pc.ptncattxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->taxcode; ?>'    , 'fldcod': 'dt.TaxDocTyp', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->number; ?>'     , 'fldcod': 'dt.TaxDocNum', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->comments; ?>'	 , 'fldcod': 'p.ptncmt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
                  {'fldcod': 'vewmaxrec','fldvalstr': '2000'}
									];

		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){
			e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_GridRefresh);
		});

		function <?= $lv_sec; ?>_GridRefresh(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="2000";}
			tmssCallProcess("?prg=sptptn&act=29", {vewmaxrec: lv_fltint["maxrec"], vewfldflt: lv_fltint["fltstr"]}, function(data){
				//if (Array.isArray(data)) {
					var lv_buffer="";
					lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+data.length+"</span></span>";
					$("#<?= $lv_sec; ?> #datqty").html(lv_buffer);
					lv_buffer="";
					for (var stu in data) {
					  lv_buffer +="<tr valign='top' name='lnkstu'>";
						lv_buffer += 	"<td>"+(data[stu].ptncmt==null?'<input type="checkbox" name="" id="">':'')+"</td>";
						lv_buffer += 	"<td>"+(data[stu].ptntxt==null?'-':data[stu].ptntxt)+"</td>";
						lv_buffer += 	"<td>"+(data[stu].ptncodext==null?'-':data[stu].ptncodext)+"</td>";
						lv_buffer += 	"<td>"+(data[stu].ptncattxt==null?'-':data[stu].ptncattxt)+"</td>";
						lv_buffer += 	"<td>"+(data[stu].taxdoctyp==null?'-':data[stu].idttyptxt)+"</td>";
						lv_buffer += 	"<td>"+(data[stu].taxdocnum==null?'-':data[stu].taxdocnum)+"</td>";
						lv_buffer += 	"<td>"+(data[stu].ptnbarcode==null?'-':data[stu].ptnbarcode)+"</td>";
						lv_buffer += 	"<td>"+(data[stu].flecod==null?'-':'<i class="fas fa-portrait"></i>')+"</td>";
						lv_buffer += 	"<td>"+data[stu].docsts+"</td>";
						lv_buffer += 	"<td>"+(data[stu].ptncmt==null?'-':data[stu].crdststxt)+"</td>";
						lv_buffer += "</tr>";
			    }	
					$("#<?= $lv_sec; ?> #ptntbl tbody").html(lv_buffer);

				//} else if ( data.substring(0,10)=="/*script*/" ) { eval( data ); }
			});
		}

		$(function(){ <?= $lv_sec; ?>_GridRefresh(gv_<?= $lv_sec; ?>_flt); });

		$("#<?= $lv_sec; ?> #ptncheck input:checkbox").on("change",function(e){
			$("#<?= $lv_sec; ?> input:checkbox").prop("checked", $(this).is(":checked"));
		});
  </script>
</section>