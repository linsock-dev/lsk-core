<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecdrtgrpasg';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->securitydirectives;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'USR';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('srcobjtyp','hidden',$vew_data->srcobjtyp); ?>
    <?= gethtml('srcobjcod001','hidden',$vew_data->srcobjcod001); ?>

		<div class="containter-fluid">
			<div class="row">
				<div class="col-md-12">
          <textarea id="grpasg" name="grpasg" class="hidden"></textarea>
					<div id="grpasghot"></div>
				</div>
			</div>
		</div>
		
	</form>
	<script>
		/*
		 *
		 *	A S I G N A C I Ó N
		 *
		 */  
		var <?= $lv_sec; ?>_hotasg_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
      td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hotasgchg = [];
		var <?= $lv_sec; ?>_hotasgdel = [];		
		var <?= $lv_sec; ?>_hotasgcnt = $("#<?= $lv_sec; ?> #grpasghot")[0];
		var <?= $lv_sec; ?>_hotasgset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->directiveGroup ?>" ],
			columns: [
				{type: "autocomplete", data: "syssecdrtgrptxt", renderer: <?= $lv_sec; ?>_hotasg_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
					source: function (query, process) { 
						if(!<?= $lv_sec; ?>_hot_paste){
              $.ajax({
                url: "?prg=syssecdrtgrp&act=18", dataType: "json", data: {	prm_syssecdrtgrptxt: query },
                complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="//script"){ eval(jqXHR.responseText); exit();}},
                success: function (response) { 
                  // guardo todos los datos adicionales en una variable temporal
                  var lv_dat = [];
                  var lv_srcLength = <?= $lv_sec; ?>_hotasg.getSourceData().length;
                  <?= $lv_sec; ?>_hotasgchg = [];
                  var lv_invalid = false;
                  for (var i=0; i < response.data.length; i++) {
                    lv_invalid = false;
                    for (var j=0; j < lv_srcLength; j++){
                      if( <?= $lv_sec; ?>_hotasg.getDataAtRowProp( j, "syssecdrtgrpcod" ) == response.data[i]["syssecdrtgrpcod"] ){ lv_invalid = true;break; }
                    }
                    
                    if( lv_invalid ){ continue; }
                    
                    <?= $lv_sec; ?>_hotasgchg.push( {syssecdrtgrptxt: response.data[i]["syssecdrtgrptxt"],
                                                     syssecdrtgrpcod: response.data[i]["syssecdrtgrpcod"]} 
                                                  );
                    lv_dat.push( response.data[i]["syssecdrtgrptxt"] );
                  }
                  process( lv_dat );
                }
              });
            } else {
            	process( [query] );
              <?= $lv_sec; ?>_hot_paste = false;
            }
          },
					strict: true
				}
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="syssecdrtgrptxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotasgchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotasgchg[i].syssecdrtgrptxt == lv_value) {
							changes.push([ changes[0][0], "syssecdrtgrpcod", "", String(<?= $lv_sec; ?>_hotasgchg[i].syssecdrtgrpcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotasg.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["syssecdrtgrpasgcod"]!="" && lv_dat[i]["syssecdrtgrpasgcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotasgdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotasg;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotasg = new Handsontable(<?= $lv_sec; ?>_hotasgcnt, <?= $lv_sec; ?>_hotasgset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->grpasg as $lv_row) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
            					'syssecdrtgrpasgcod:\''.$lv_row['syssecdrtgrpasgcod'].'\','.
            					'syssecdrtgrpcod:\''.$lv_row['syssecdrtgrpcod'].'\','.
            					'syssecdrtgrptxt:\''.$lv_row['syssecdrtgrptxt'].'\''.
            			'}'; 
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotasg.loadData( lv_dat );
			<?= $lv_sec; ?>_hotasg.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });

    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
					
				// obtengo datos de hot asignación
				var lo_dat = <?= $lv_sec; ?>_hotasg.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["syssecdrtgrpcod"]!="" && lo_dat[i]["syssecdrtgrpcod"]!=undefined ){
						lv_arr.push({	"syssecdrtgrpasgcod":lo_dat[i]["syssecdrtgrpasgcod"],
													"syssecdrtgrpcod":lo_dat[i]["syssecdrtgrpcod"],
													"syssecdrtgrptxt":lo_dat[i]["syssecdrtgrptxt"]
												});
					}
				}
			
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotasgdel.length; i++) {
					lv_arr.push({	"syssecdrtgrpasgcod":<?= $lv_sec; ?>_hotasgdel[i]["syssecdrtgrpasgcod"],
												"deleted":"X"
											});
				}
			
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #grpasg").text("");
				} else {
					$("#<?= $lv_sec; ?> #grpasg").text( JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>