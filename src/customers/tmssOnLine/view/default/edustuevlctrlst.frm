<?php
	// url del formulario 
  $lv_lnk = '?prg=edustuevl';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->evaluation;
	
	// módulo y programa 
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'EVL';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	$vew_tbl['new']  = array('per'=>false);	
	$vew_tbl['modL'] = array('per'=>false);	
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['calL'] = array('id'=>'btncalL', 'pos'=>'L', 'ttl'=>'', 'tooltip'=>$vew_lang->calendar, 'per'=>true, 'icn'=>'far fa-calendar', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn', 'acc'=>'');
	$vew_tbl['calR'] = array('id'=>'btncalR', 'pos'=>'R', 'ttl'=>'', 'tooltip'=>$vew_lang->calendar, 'per'=>true, 'icn'=>'far fa-calendar', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-mob-btn', 'acc'=>'');
	$vew_tbl['fltR'] = array('id'=>'btnflt',  'pos'=>'R', 'ttl'=>'', 'tooltip'=>$vew_lang->filter,   'per'=>true, 'icn'=>'far fa-filter',   'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled', 'acc'=>'' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<div class="container-fluid">
		<table class="table table-condensed table-bordered table-striped table-hover" id="tblevl">
			<thead>
				<tr>
					<th><?= $vew_lang->career;?></th>
					<th><?= $vew_lang->course;?></th>
					<th><?= $vew_lang->subject;?></th>
					<th><?= $vew_lang->teacher;?></th>
					<th><?= $vew_lang->student;?></th>
					<th><?= $vew_lang->date;?></th>
					<th><?= $vew_lang->time;?></th>
					<th><?= $vew_lang->status;?></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<script>
		var gv_<?= $lv_sec; ?>_flt = [
									{'fldttl': '<?= $vew_lang->ID; ?>', 'fldcod': 'e.evlcod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->place; ?>', 'fldcod': 'el.stdloctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->curriculum; ?>', 'fldcod': 'ec.educurtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->career; ?>', 'fldcod': 'ea.educartxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->course; ?>', 'fldcod': 'eo.educoutxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->subject; ?>', 'fldcod': 'es.edusubtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->teacher; ?>', 'fldcod': 'et.tchtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->student; ?>', 'fldcod': 'eu.stutxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->date; ?>', 'fldcod': 'pd.eduplndte', 'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
									{'fldttl': '<?= $vew_lang->time; ?>', 'fldcod': 'pd.eduplninbdte', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
									{'fldttl': '<?= $vew_lang->status; ?>', 'fldcod': 'docstscnv', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}
									];
		
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
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
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}
			tmssCallProcess("?prg=edustuevl&act=ctrlst", {vewmaxrec: lv_fltint["maxrec"], vewfldflt: lv_fltint["fltstr"]}, function(data){
				if (Array.isArray(data)) {
					var lv_buffer="";
					var lv_color ="";
					for (var i=0;i<data.length;i++) {
						lv_style = "background-color: "+(data[i].rowclr!=null?data[i].rowclr:"#178acc")+" !important; color: #ffffff;";
						lv_buffer += "<tr>" +
						"<td>"+data[i].educartxt+"</td>"+
						"<td>"+data[i].educoutxt+"</td>"+
						"<td>"+data[i].edusubtxt+"</td>"+
						"<td>"+data[i].tchtxt+"</td>"+
						<?php if($vew_sec->hasPermission('EDU','STU','03')) { ?>
							"<td><a href='#' name='lnkstuinf' data-stucod='"+data[i].stucod+"'>"+data[i].stutxt+"</a></td>"+
						<?php } else { ?>
							"<td>"+data[i].stutxt+"</td>"+
						<?php } ?>
						"<td>"+data[i].eduplndtecnv+"</td>"+
						"<td>"+data[i].eduplninbdtecnv+"</td>"+
						"<td><a href='#' name='lnkstuevl' data-evlcod='"+data[i].evlcod+"' data-eduplncod='"+data[i].eduplncod+"' data-eduplndtecod='"+data[i].eduplndtecod+"' data-stucod='"+data[i].stucod+"' data-eduevlfrm='"+data[i].eduevlfrm+"' class='btn btn-default btn-sm btn-block' style='"+lv_style+"'>"+data[i].docstscnv+"</a></td>"+
						"</tr>";
					}
					$("#<?= $lv_sec; ?> #tblevl tbody").html(lv_buffer);
					$("#<?= $lv_sec; ?> #tblevl tbody tr td a[name=lnkstuevl]").on("click",function(e){ e.preventDefault();
						if( $(this).data("eduevlfrm")!="" ) {
							tmssLink($(this).data("eduevlfrm"), [{target: "_new_section", post_data: 
								[
									{name:"evlcod", value:$(this).data("evlcod")},
									{name:"eduplncod", value:$(this).data("eduplncod")},
									{name:"eduplndtecod", value:$(this).data("eduplndtecod")},
									{name:"stucod", value:$(this).data("stucod")}
								]
								}] );
						}
						e.stopPropagation();
					});
					<?php if($vew_sec->hasPermission('EDU','STU','03')) { ?>
					$("#<?= $lv_sec; ?> #tblevl tbody tr td a[name=lnkstuinf]").on("click",function(e){ e.preventDefault();
						tmssLink("?prg=edustu&act=03&prm_stucod="+$(this).data("stucod"), [{target: "_new_section"}]);
						/*
						tmssCallProcess("?prg=edustu&act=23&prm_popup=sysdochdr_popup&prm_stucod="+$(this).data("stucod"), [], function(data){
							if ( data!="" ) {
								BootstrapDialog.show({
									size: BootstrapDialog.SIZE_WIDE,
									title: "<?= $vew_lang->student; ?>",
									message: $(data)
								});
							}
						});
						*/
					});
					<?php } ?>
				}
			});
		}
		$("#<?= $lv_sec; ?> #btncalL, #<?= $lv_sec; ?> #btncalR").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=edustuevl&act=ctr&prm_vew=cal", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>"}]);
		});	
		<?= $lv_sec; ?>_GridRefresh();
  </script>
	<?php include('grldocfrmscr.frm') ?>
</section>