<form id="exportdata" method="POST" action="?prg=<?= $vew_controller.$lv_urlkey; ?>&prm_rfh=1&prm_dwn=1">
	<input type="hidden" id="vewfldord_exp" name="vewfldord" value="">
	<input type="hidden" id="vewmaxrec_exp" name="vewmaxrec" value="">
	<textarea class="hidden" id="vewfldflt_exp" name="vewfldflt"></textarea>
	<input type="hidden" id="vewdwntyp_exp" name="vewdwntyp" value="">
</form>
<script>
	$("#<?= $lv_sec; ?>_expbtn").on("click",function(e){
    var lv_expfrm = [
			{expcod: "txt", expttl: "Texto", 		expicn: "far fa-file-text fa-2x"},
			{expcod: "xls", expttl: "MSExcel",	expicn: "far fa-file-excel fa-2x"},
			{expcod: "doc", expttl: "MSWord",		expicn: "far fa-file-word fa-2x"},
			{expcod: "pdf",	expttl: "PDF",			expicn: "far fa-file-pdf fa-2x"},
			{expcod: "clp",	expttl: "Portapapeles",			expicn: "far fa-clipboard fa-2x"}
		];
		var lv_expcmt = "<strong>Nota: </strong>La exportaci&oacute;n de archivos NO considera el l&iacute;mite de registros indicado en el filtro.";
		tmssShowExportDialog( lv_expfrm, lv_expcmt, <?= $lv_sec; ?>_grdexpset );
		e.stopPropagation();
		e.preventDefault();
	});
	function <?= $lv_sec; ?>_grdexpset( lp_data ) {
		if( lp_data=="clp" ) {
			// descargo head
			var lv_hdr = "";
			$("#<?= $lv_sec; ?> #sysdocgrd_table thead tr th").each(function(){
				lv_hdr += (lv_hdr==""?"":String.fromCharCode(9)) + $(this).text();
			});
			lv_hdr += String.fromCharCode(13) + String.fromCharCode(10);
			// descargo body
			var lv_bdy = "";
			$("#<?= $lv_sec; ?> #sysdocgrd_table tbody tr").each(function(){
				var lv_str = "";
				$(this).find("td").each(function(){
					lv_str += (lv_str==""?"":String.fromCharCode(9)) + $(this).text();
				});
				lv_bdy += (lv_bdy==""?"":String.fromCharCode(13) + String.fromCharCode(10)) + lv_str				
			});
			// salida a clipboard
			tmssCopyToClipboard( lv_hdr + lv_bdy );
		} else {
			$("#<?= $lv_sec; ?> #vewfldord_exp").prop("value", $("#<?= $lv_sec; ?> #vewfldord").val() );
			$("#<?= $lv_sec; ?> #vewmaxrec_exp").prop("value", "99999");
			$("#<?= $lv_sec; ?> #vewfldflt_exp").text( encodeURIComponent( $("#<?= $lv_sec; ?> #vewfldflt").text() + $("#<?= $lv_sec; ?> #vewfldfltpre").text() ) );
			$("#<?= $lv_sec; ?> #vewdwntyp_exp").prop("value", lp_data );
			$("#<?= $lv_sec; ?> #exportdata").submit();
		}
	}
</script>