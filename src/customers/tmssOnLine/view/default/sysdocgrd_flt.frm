<script>
	var lv_<?= $lv_sec; ?>_grdfltqty = 0;
	var lv_<?= $lv_sec; ?>_grdfltcod = 0;
	var lv_<?= $lv_sec; ?>_grdfltdat = [
				<?php
					$lv_buffer = '';
					foreach ( $vew_defcol as $lv_row ) {
						if ( $lv_row['vewfldflt']==1 ) {
							$lv_buffer .= ($lv_buffer==''?'':',').'{fldttl: "'.$vew_lang->get( $lv_row['vewfldttl'] ).'", fldcod: "'.$lv_row['vewfld'].'", fldtyp: "'.$lv_row['sysfldinptyp'].'", flttyp: "", fldvalstr: "", fldvalend: ""}';
						}
					}
					$lv_buffer .= ($lv_buffer==''?'':',').'{fldttl: "", fldcod: "vewmaxrec", fldtyp: "", flttyp: "", fldvalstr: "'.$vew_defhdr['vewdefmaxrec'].'", fldvalend: ""}';
					echo $lv_buffer;					
				?>
			];
	
	$(function(){
		<?php if($lv_vewfldfltdef!='' || (isset($vew_prm['vewfldflt']) && $vew_prm['vewfldflt']!='')) { ?>
			lv_<?= $lv_sec; ?>_grdfltdat = tmssFilterParseToExternal( lv_<?= $lv_sec; ?>_grdfltdat, $("#<?= $lv_sec; ?> #vewfldflt").text() );
			lv_<?= $lv_sec; ?>_grdfltcod = <?= isset($vew_prm['vewfltcod']) ? $vew_prm['vewfltcod'] : '0'; ?>;
			for(var i=0; i<lv_<?= $lv_sec; ?>_grdfltdat.length; i++) {
				if( lv_<?= $lv_sec; ?>_grdfltdat[i]["flttyp"]!="" ) { lv_<?= $lv_sec; ?>_grdfltqty++; }
			}
			$("#<?= $lv_sec; ?> #fltcnt").text( (lv_<?= $lv_sec; ?>_grdfltqty==0?"":lv_<?= $lv_sec; ?>_grdfltqty) );
		<?php } ?>
	});
	
	$("#<?= $lv_sec; ?>_fltbtn").on("click",function(e){ e.preventDefault(); e.stopPropagation();
		tmssFilterShowDialog( lv_<?= $lv_sec; ?>_grdfltdat, <?= $lv_sec; ?>_grdfltset, "<?= $vew_defhdr['vewcod']; ?>", lv_<?= $lv_sec; ?>_grdfltcod, "<?= $lv_sec; ?>" );	
	});
	
	function <?= $lv_sec; ?>_grdfltset( lp_data ) {
		lv_<?= $lv_sec; ?>_grdfltdat = lp_data;
		var lv_dat = tmssFilterParseToInternal( lp_data );
		$("#<?= $lv_sec; ?> #fltcnt").text( (lv_dat["fltqty"]==0?"":lv_dat["fltqty"]) );
		$("#<?= $lv_sec; ?> #vewmaxrec").prop("value", lv_dat["maxrec"]);
		$("#<?= $lv_sec; ?> #vewfldflt").text( lv_dat["fltstr"] );
		if ( typeof window["<?= $lv_sec; ?>_sysdocgrd_refresh"]=="undefined" ) {
			$("#<?= $lv_sec; ?> #sysdocgrd_table").bootstrapTable("refresh");
		} else {
			eval("<?= $lv_sec; ?>_sysdocgrd_refresh();");
		}		
	}
	
	
</script>