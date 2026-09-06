<?php
	// url del formulario 
  $lv_lnk = '?prg=stkmovdoc&act=28';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->calendar;
	
	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// librería de estilos bootstrap 
	include_once('_library.frm');
			
	$vew_actcod = '02';
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<style type="text/css">
		#READhidden { height:17px; width:1px; position:absolute; margin-top:5px; z-index: 100; color: rgb(0, 0, 0); height: 25px; border: 2px solid rgb(90, 90, 90) !important; }
		#READcursor {position:absolute; visibility:hidden; margin:0px; padding:0px;}
		#READhidden:focus {border:1px solid gray; border-width:0px 0px 0px 1px; outline:none; animation-name: cursor; animation-duration: 0.5s; animation-iteration-count: infinite; }
		@keyframes cursor { from {opacity:0;} to {opacity:1;} }
	</style>
	<div class="container-fluid">
		<input type="hidden" id="last_read" name="last_read" value="">
		
		<div style="padding-bottom:5px;">
			<select id="READhidden"></select>
			<div class="input-group">
				<input type="text" placeholder="Lectura..." readonly="readonly" id="READ" class="col-xs-12 col-md-11 form-control" style="border: 0px; border: 1px solid #74b5b2 !important; border-radius: 3px !important;">
				<input type="text" placeholder="Lectura..." id="READkeyboard" class="hidden col-xs-12 col-md-11 form-control" style="border: 0px; border: 1px solid #74b5b2 !important; border-radius: 3px !important;">
				<span class="input-group-addon" id="tmssKey" style="cursor: pointer;"><span class="fas fa-keyboard"></span></span>
			</div>
			<div id="READcursor" class=""></div>
		</div>
		
		<table class="table table-condensed">
			<thead><tr><th>Material</th><th>Cantidad</th><th>Lote</th><th>Serie</th><th></th></tr></thead>
			<tbody>
				<?php
					foreach($vew_matlst as $lv_row){
						echo '<tr data-matcod="'.$lv_row['matcod'].'" data-matqty="'.$lv_row['matqty'].'" data-matqtypck="'.(isset($lv_row['matqtypck'])?$lv_row['matqtypck']:'').'" data-matuntcod="'.$lv_row['matuntcod'].'" data-matidtuntcod="'.(isset($lv_row['matqtyuntcod'])?$lv_row['matqtyuntcod']:'').'" data-matbchcod="'.((isset($lv_row['matbchcod'])?$lv_row['matbchcod']:0)!=0?$lv_row['matbchcod']:'').'" data-matbchcodext="'.(isset($lv_row['matbchcodext'])?$lv_row['matbchcodext']:'').'" data-matbchduedtecnv="'.(isset($lv_row['matbchduedte'])?$lv_row['matbchduedte']:'').'" data-matsercod="'.((isset($lv_row['matsercod'])?$lv_row['matsercod']:0)!=0?$lv_row['matsercod']:'').'" data-matsercodext="'.(isset($lv_row['matsercodext'])?$lv_row['matsercodext']:'').'">'.
										'<td><strong>'.$lv_row['mattxt'].'</strong><br><small>'.$lv_row['matcod'].'</small></td>'.
										'<td class="text-right" style="font-weight: bold;"><span style="color: '.((isset($lv_row['matqtypck'])?$lv_row['matqtypck']:0)<$lv_row['matqty']?'red':'green').';">'.(isset($lv_row['matqtypck'])?$lv_row['matqtypck']:0).' '.$lv_row['matuntcod'].'</span><br><small>'.$lv_row['matqty'].' '.$lv_row['matuntcod'].'</small></td>'.
										'<td>'.(isset($lv_row['matbchcodext'])?$lv_row['matbchcodext']:'').'<br><small>'.(isset($lv_row['matbchduedte'])?$lv_row['matbchduedte']:'').'</small></td>'.
										'<td>'.(isset($lv_row['matsercodext'])?$lv_row['matsercodext']:'').'</td>'.
										'<td><a href="#" class="btn btn-danger"><i class="fas fa-trash"></i></a></td></tr>';
					}
				?>
			</tbody>
		</table>
	</div>
	<script>
		var lv_<?= $lv_sec; ?>_reads = 0;
		
		$("#<?= $lv_sec; ?> #READ").bind("focus", function(e) {
			$(this).css("background-color","#FFFFFF");
			$("#<?= $lv_sec; ?> #READcursor").css("font", $("#<?= $lv_sec; ?> #READ").css("font"));
			$("#<?= $lv_sec; ?> #READhidden").removeClass("hidden").focus();
			<?= $lv_sec; ?>_clearRead();
			<?= $lv_sec; ?>_refreshCursor();
		});
		
		$("#READhidden").bind("focusout",function(e) {
			$("#<?= $lv_sec; ?> #READ").css("background-color","#F1F1F1");
			$("#<?= $lv_sec; ?> #READhidden").addClass("hidden");
		});
		
		$("#<?= $lv_sec; ?> #READhidden").bind("keydown",function(e) {
			var lv_newtext = "";
			if(e.key=="Enter"){
				<?= $lv_sec; ?>_leerMaterial( $("#<?= $lv_sec; ?> #READ").prop("value") );
				e.preventDefault();
				e.stopPropagation();
				return false;
			} else if(e.key=="Backspace" ) {
				if ( $("#<?= $lv_sec; ?> #READ").prop("value").length>0 ) {
					lv_newtext = $("#<?= $lv_sec; ?> #READ").val().substr(0, $("#<?= $lv_sec; ?> #READ").prop("value").length-1);
				} else { 
					lv_newtext = "";
				}
			} else {
				var lv_key = <?= $lv_sec; ?>_findREADKey(e.key);
				if( lv_key == "" ) {
					console.log(e.key);
					e.preventDefault();
					e.stopPropagation();
					return false;
				} else {
					lv_newtext = $("#<?= $lv_sec; ?> #READ").prop("value") + lv_key;
				}
			}
			$("#<?= $lv_sec; ?> #READ").prop("value",lv_newtext);
			$("#<?= $lv_sec; ?> #READcursor").text(lv_newtext);
			<?= $lv_sec; ?>_refreshCursor();
		});
		
		$("#<?= $lv_sec; ?> #READkeyboard").on("focusout",function(e){
			$(this).addClass("hidden");
			$("#<?= $lv_sec; ?> #READ").prop("value",$(this).prop("value")).removeClass("hidden");
			$("#<?= $lv_sec; ?> #READcursor").text($(this).prop("value")).removeClass("hidden");
			$("#<?= $lv_sec; ?> #READhidden").removeClass("hidden");
			<?= $lv_sec; ?>_refreshCursor();
		});
		
		$("#<?= $lv_sec; ?> #READkeyboard").on("keydown",function(e) {
			if(e.key=="Enter"){
				var eh = jQuery.Event("keydown");
				eh.which=13;
				eh.keyCode=13;
				eh.key="Enter";
				$("#<?= $lv_sec; ?> #READkeyboard").trigger("focusout");
				$("#<?= $lv_sec; ?> #READhidden").focus().trigger(eh);
				e.preventDefault();
				e.stopPropagation();
			}
		});
		
		$("#<?= $lv_sec; ?> #tmssKey").on("click",function(e){
			$("#<?= $lv_sec; ?> #READ").addClass("hidden");
			$("#<?= $lv_sec; ?> #READcursor").addClass("hidden");
			$("#<?= $lv_sec; ?> #READhidden").addClass("hidden");
			$("#<?= $lv_sec; ?> #READkeyboard").removeClass("hidden").focus();
		});
		
		function <?= $lv_sec; ?>_clearRead() {
			$("#<?= $lv_sec; ?> #READcursor").text("");
			$("#<?= $lv_sec; ?> #READkeyboard").prop("value","");
			$("#<?= $lv_sec; ?> #READ").prop("value","");
		}
		
		function <?= $lv_sec; ?>_refreshCursor() {
			var offset = 14;
			var textWidth = $("#<?= $lv_sec; ?> #READcursor").width();
			$("#<?= $lv_sec; ?> #READhidden").css("marginLeft",Math.min(offset+textWidth,$("#<?= $lv_sec; ?> #READ").width()));
		}
		
		function <?= $lv_sec; ?>_findREADKey( lp_key ) {
			var lv_READkeylist = [{key:"0", value:"0"},{key:"1", value:"1"},{key:"2", value:"2"},{key:"3", value:"3"},{key:"4", value:"4"},{key:"5", value:"5"},{key:"6", value:"6"},{key:"7", value:"7"},{key:"8", value:"8"},{key:"9", value:"9"},
														{key:"a", value:"a"},{key:"b", value:"b"},{key:"c", value:"c"},{key:"d", value:"d"},{key:"e", value:"e"},{key:"f", value:"f"},{key:"g", value:"g"},{key:"h", value:"h"},{key:"i", value:"i"},{key:"j", value:"j"},{key:"k", value:"k"},{key:"l", value:"l"},{key:"m", value:"m"},{key:"n", value:"n"},{key:"ñ", value:"ñ"},{key:"o", value:"o"},{key:"p", value:"p"},{key:"q", value:"q"},{key:"r", value:"r"},{key:"s", value:"s"},{key:"t", value:"t"},{key:"u", value:"u"},{key:"v", value:"v"},{key:"w", value:"w"},{key:"x", value:"x"},{key:"y", value:"y"},{key:"z", value:"z"},
														{key:"A", value:"A"},{key:"B", value:"B"},{key:"C", value:"C"},{key:"D", value:"D"},{key:"E", value:"E"},{key:"F", value:"F"},{key:"G", value:"G"},{key:"H", value:"H"},{key:"I", value:"I"},{key:"J", value:"J"},{key:"K", value:"K"},{key:"L", value:"L"},{key:"M", value:"M"},{key:"N", value:"N"},{key:"Ñ", value:"Ñ"},{key:"O", value:"O"},{key:"P", value:"P"},{key:"Q", value:"Q"},{key:"R", value:"R"},{key:"S", value:"S"},{key:"T", value:"T"},{key:"U", value:"U"},{key:"V", value:"V"},{key:"W", value:"W"},{key:"X", value:"X"},{key:"Y", value:"Y"},{key:"Z", value:"Z"},
														{key:"numpad 0", value:"0"},{key:"numpad 1", value:"1"},{key:"numpad 2", value:"2"},{key:"numpad 3", value:"3"},{key:"numpad 4", value:"4"},{key:"numpad 5", value:"5"},{key:"numpad 6", value:"6"},{key:"numpad 7", value:"7"},{key:"numpad 8", value:"8"},{key:"numpad 9", value:"9"},
														{key:"multiply", value:"*"},{key:"add", value:"+"},{key:"subtract", value:"-"},{key:"decimal point", value:"."},{key:"divide", value:"/"},{key:"semi-colon", value:";"},{key:"equal sign", value:"="},{key:"comma", value:","},{key:"single quote", value:"'"},
														{key:"|", value:"|"},{key:"!", value:"!"},{key:"#", value:"#"},{key:"%", value:"%"},{key:"&", value:"&"},{key:"/", value:"/"},{key:"(", value:"("},{key:")", value:")"},{key:"=", value:"="},
														{key:"-", value:"-"},{key:"°", value:"°"},{key:"¡", value:"¡"},{key:"$", value:"$"},{key:"?", value:"?"},{key:"¿", value:"¿"},{key:":", value:":"},{key:";", value:";"},{key:"*", value:"*"},{key:"_", value:"_"},{key:"]", value:"]"},{key:"[", value:"["},{key:"{", value:"{"},{key:"}", value:"}"},{key:"~", value:"~"},{key:",", value:","},{key:".", value:"."},{key:"\/", value:"\/"}
														];
			for(var i=0; i<lv_READkeylist.length; i++) {
				if (lv_READkeylist[i].key == lp_key) {
					return lv_READkeylist[i].value;
				}
			}
			return "";
		}
		
		function <?= $lv_sec; ?>_leerMaterial( lp_barcod ){
			tmssCallProcess("?prg=stkmatidt&act=barcodread",[{name:"barcod",value:lp_barcod}],function(data){
				
				if(data.length==0){
					toastr.warning("Material no encontrado.");
					$("#<?= $lv_sec; ?> #READ").focus();
					return false;
				}
				
				var lv_rowid = "";
				var lv_rowkeyini = "#<?= $lv_sec; ?> table tbody tr[data-matcod='"+data.matcod+"'][data-matuntcod='"+data.matidtuntcod.trim()+"'][data-matidtuntcod=''][data-matbchcod='"+data.matbchcod+"'][data-matsercod='"+data.matsercod+"']";
				var lv_rowkeyidt = "#<?= $lv_sec; ?> table tbody tr[data-matcod='"+data.matcod+"'][data-matuntcod='"+data.matuntcod.trim()+"'][data-matidtuntcod='"+data.matidtuntcod.trim()+"'][data-matbchcod='"+data.matbchcod+"'][data-matsercod='"+data.matsercod+"']";
				if( data.matsercod!='' && $(lv_rowkeyidt).length>0 ) {
					toastr.warning("N&uacute;mero de serie ya le&iacute;do.");
					$("#<?= $lv_sec; ?> #READ").focus();
					return false;
				}
				if( $(lv_rowkeyidt).length>0 ) {
					lv_rowid = lv_rowkeyidt;
				} else {
					lv_rowid = lv_rowkeyini;
				}
				
				var lv_matqtypck = ( $(lv_rowid).length>0 ? Number($(lv_rowid).data("matqtypck"))+1 : 1 );
				var lv_matqty = ( $(lv_rowid).length>0 ? Number($(lv_rowid).data("matqty")) : 0 );
				var lv_row = "<tr data-matcod='"+data.matcod+"' data-matidtuntcod='"+data.matidtuntcod.trim()+"' data-matuntcod='"+data.matuntcod.trim()+"' data-matbchcod='"+data.matbchcod+"' data-matbchcodext='"+data.matbchcodext+"' data-matbchduedtecnv='"+data.matbchduedtecnv+"' data-matsercod='"+data.matsercod+"' data-matsercodext='"+data.matsercodext+"' data-matqty="+lv_matqty+" data-matqtypck="+lv_matqtypck+">"
											+ "<td><strong>"+data.mattxt+"</strong><br><small>"+data.matcod+"<strong>"+(data.matuntcod!=data.matidtuntcod?" ("+data.matidtuntcod+" = "+data.matbseqty+" "+data.matuntcod+")":"")+"</strong></small></td>"
											+ "<td class='text-right' style='font-weight: bold;'><span style='color: "+(lv_matqtypck<lv_matqty?"red":"green")+";'>"+lv_matqtypck+" "+data.matidtuntcod+"</span><br><small>"+lv_matqty+" "+data.matuntcod+"</small></td>"
											+ "<td>"+data.matbchcodext+"<br><small>"+data.matbchduedtecnv+"</small></td>"
											+ "<td>"+data.matsercodext+"</td>"
											+ "<td><a href='#' class='btn btn-danger' onclick='removeRow();'><i class='fas fa-trash'></i></a></td>"
											+ "</tr>";
				
				if( $("#<?= $lv_sec; ?> table tbody tr").length==0 ){
					$(lv_row).appendTo("#<?= $lv_sec; ?> table tbody");
				
				// buscar fila en tabla (igual codigo, UM/UM picking, lote, serie)
				} else if( $(lv_rowid).length>0 ) {
					$(lv_rowid).remove();
					if( $("#<?= $lv_sec; ?> table tbody tr").length==0 ){
						$(lv_row).appendTo("#<?= $lv_sec; ?> table tbody");
					} else { 
						$(lv_row).insertBefore("#<?= $lv_sec; ?> table tbody tr:first");
					}
				} else {
					$(lv_row).insertBefore("#<?= $lv_sec; ?> table tbody tr:first");
				}
				
				gEvent=setInterval(
					function(){
						toWhite( $(lv_rowid) ); 
					}, 10);
				
				$("#<?= $lv_sec; ?> #last_read").prop("value",lv_rowid);
				$("#<?= $lv_sec; ?> #READ").focus();
				$("#<?= $lv_sec; ?> #last_read").trigger("change");
			});
		}
		
		function toWhite( lp_row ){
			var lv_step = 10;
			if($(lp_row).length>0) {
				var lv_bgr = $(lp_row).css("background-color");
				var lv_bga = [parseInt(lv_bgr.split(",")[0].replace(/\D/g,"")),
											parseInt(lv_bgr.split(",")[1].replace(/\D/g,"")),
											parseInt(lv_bgr.split(",")[2].replace(/\D/g,"")) ];
				lv_bga[0] = (lv_bga[0]<=255?(lv_bga[0]+lv_step<=255?lv_bga[0]+lv_step:255):255);
				lv_bga[1] = (lv_bga[1]<=255?(lv_bga[1]+lv_step<=255?lv_bga[1]+lv_step:255):255);
				lv_bga[2] = (lv_bga[2]<=255?(lv_bga[2]+lv_step<=255?lv_bga[2]+lv_step:255):255);
				$(lp_row).css("background-color","rgb("+lv_bga.join()+")");
				if(lv_bga[0]==255 && lv_bga[1]==255 && lv_bga[2]==255){
					clearInterval(gEvent);
				}
			} else {
				clearInterval(gEvent);
			}
		}
		
		$(function(){
			$("#<?= $lv_sec; ?> #READ").focus();
		});
	</script>
</section>