<?php	
	// url del formulario
  $lv_lnk = '?prg=finaccpln&prm_finaccplncod='.$vew_data->finaccplncod;

	// campos requeridos 
	$vew_input->RequiredFields( array('finaccplntxt','curcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->finaccplncod;

	// titulo 
	$lv_title = $vew_lang->ChartOfAccounts;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'PLN';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	function makeAccsTree($lo_arr, $lv_prvlvl){
		$lv_ret = "";
		// If there are no more nodes to process, close all pending li and ul
		if(!is_array($lo_arr) || count($lo_arr)==0){
			for($lv_i=0; $lv_i<$lv_prvlvl; $lv_i++){
				$lv_ret .= '</li></ul>'; 
			}
			return $lv_ret;
		}

		// Get current node and level
		$lo_nod = $lo_arr[0];
		$lv_lvl 	= count(explode(".",$lo_nod['finaccplnlvl']==""?'00':'00.'.$lo_nod['finaccplnlvl']));

		// Create li node
		$lv_finacccod = isset($lo_nod['finacccod']) ? $lo_nod['finacccod'] : '';
		$lv_nodtyp = (isset($lo_nod['type']) && $lo_nod['type']=='account') ? 'account' : 'folder';
		if (!isset($lo_nod['type'])) {
			$lv_nodtyp = ($lv_finacccod != '') ? 'account' : 'folder';
		}
		$lv_finaccplnacccod = isset($lo_nod['finaccplnacccod']) ? $lo_nod['finaccplnacccod'] : '';
		$lv_curcod = isset($lo_nod['curcod']) ? $lo_nod['curcod'] : '';
		$lv_finaccclscod = isset($lo_nod['finaccclscod']) ? $lo_nod['finaccclscod'] : '';

		$lv_licon  = ' data-jstree='.chr(39).'{"type":"'.$lv_nodtyp.'"}'.chr(39)
              .' data-finacccod="'.$lv_finacccod.'"'
              .' data-finaccplnlvl="'.$lo_nod['finaccplnlvl'].'"'
              .' data-curcod="'.$lv_curcod.'"'
              .' data-finaccclscod="'.$lv_finaccclscod.'"'
              .' data-finaccplnacccod="'.$lv_finaccplnacccod.'"';

		// If current level is greather than previous one, start new ul and li
		if( $lv_lvl > $lv_prvlvl ){
			$lv_ret .= '<ul><li '.$lv_licon.'>'.htmlentities($lo_nod['finaccplnlvltxt']);
			array_shift($lo_arr);
		}

		// If current level is the same as previous one, close previous li and start a new one
		if( $lv_lvl == $lv_prvlvl ){
			$lv_ret .= '</li><li '.$lv_licon.'>'.htmlentities($lo_nod['finaccplnlvltxt']);
			array_shift($lo_arr);
		}

		// If current level is shorter than previous one, close all pending li and ul until reach current level
		if( $lv_lvl < $lv_prvlvl ){
			for($lv_i=0; $lv_i<($lv_prvlvl-$lv_lvl); $lv_i++){
				$lv_ret .= '</li></ul>'; 
			}
		}

		// Process next node
		$lv_ret .= makeAccsTree($lo_arr,$lv_lvl);

		return $lv_ret;
	}	

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->finaccplncod; ?><?= gethtml('finaccplncod','hidden',$vew_data->finaccplncod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('finaccplncodext', 'doccmt1x20', $vew_data->finaccplncodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('finaccplntxt', 'doccmt1x50', $vew_data->finaccplntxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->currency, 	
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                        array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled) )) ));  
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
              
						</div>
						<div class="col-md-6">
              
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->accounts; ?>
										<?php if(!$vew_readonly) { ?><a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnupl" title="<?= $vew_lang->upload; ?>"><i class="fas fa-upload"></i></a><?php } ?>                    
                    <a class="card-icon text-center tmssAlwaysEnabled <?= (is_array($vew_data->acc ?? null) && count($vew_data->acc) > 0 ? '' : 'hidden') ?>" id="btndwn" title="Descargar"><i class="fas fa-download"></i></a>
                    <a href="#" class="card-icon text-center tmssAlwaysEnabled hidden" id="btnvew" title="Ver cuenta"><span class="far fa-eye"></span></a>
                    <a href="#" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead hidden" id="btndel"  title="Borrar"><span class="far fa-trash"></span></a>            
                    <a href="#" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead hidden" id="btnedt"  title="Modificar"><span class="far fa-pencil-alt"></span></a>
                    <a href="#" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnaddfld" title="Agregar Rubro/Subrubro"><span class="far fa-folder-plus"></span></a>
                  	<a href="#" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead hidden" id="btnaddacc"  title="Agregar cuenta"><span class="far fa-plus"></span></a>
                  </div>
								</div>
                <textarea class="d-none" id="finaccplnacc" name="finaccplnacc"></textarea>
                <div id="finacctrediv" class="tmss-acc-tree">
                  <ul>
                    <li data-jstree='{"opened":true,"selected":true,"type":"root"}'><?= $vew_lang->ChartOfAccounts; ?>
                      <?= makeAccsTree($vew_data->acc,0); ?>
                    </li>
                  </ul>
                </div>
              </div>
              
            </div><!-- /col -->
					</div><!-- /row -->
				</div><!-- /_tab001 -->
			</div><!-- /tab-content -->
    </div><!-- /container-fluid -->
  </form>
	<script>
		tmssLoadScript("jstree",function(){
			$("#<?= $lv_sec; ?> #finacctrediv").jstree({
				"core": { "expand_selected_onload" : false, 
									"themes": {	"responsive": true }, 
									"animation" : 0, 
									"themes" : { "stripes" : true },
									"check_callback" : function (operation) { return true; }
				},
				"types": {
					"#": {"max_children" : 1, "max_depth" : 50, "valid_children" : ["root"] },
					"root": { "max_children" : 5, "icon": "fas fa-sitemap", "valid_children": ["folder"] },
					"folder": { "max_children" : 10000, "valid_children": ["folder","account"] },
					"account": { "max_children" : 0, "icon": "fas fa-file", "valid_children": [] }
				},
				"plugins": [ "types", "unique" <?= $vew_readonly?'':',"dnd"';?> ]
			});
		});
		
		$("#<?= $lv_sec; ?> #finacctrediv").on('copy_node.jstree', function (e, data) { 
			data.node.data = JSON.parse(JSON.stringify(data.original.data)); 
		});

		// Add new account
		$("#<?= $lv_sec; ?> #btnaddacc").on("click",function(e){ e.preventDefault();  
			let lo_sel = $("#<?= $lv_sec; ?> #finacctrediv").jstree("get_selected",true)
			if(lo_sel[0].type == "folder"){                                                      
				tmssPopup("Buscar cuentas","?prg=finacc&act=08&prm_vewcod=VEW_FIN_ACC_PLN_ACC&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[finacccod:a.finacccod]", function(dialog){
					//... cuando se cierra el dialogo
					let lo_dlg = dialog.getModalBody();
					// verificar si selecciono cuentas
					if( $(lo_dlg).find("#checkboxSelect").val()!=0 ){												
						// asignar cuentas seleccionadas
						let lv_finacccod;
						let lv_txt;
						$(lo_dlg).find("input[type=checkbox]:checked").each(function(){
							let lv_i = 0;  
							$(this).parent().parent().parent().children().each(function(){
								if(lv_i===1){
									lv_finacccod = $(this).text();
								}else if(lv_i===3){
									lv_txt = $(this).text();
								}
								lv_i+=1
							});
							let lo_ref = $("#<?= $lv_sec; ?> #finacctrediv").jstree(true);
							let lo_sel_nod = lo_ref.get_selected();
							if(!lo_sel_nod.length) { return false; }
							lo_sel_nod = lo_sel_nod[0];
							lo_sel_nod = lo_ref.create_node(lo_sel_nod, {"type":"account", "text":lv_txt, "data":{"finacccod":lv_finacccod}});
							if(lo_sel_nod) { lo_ref.edit(lo_sel_nod); }
						});
					};
				});
		}
		});
		
		// Add new folder
		$("#<?= $lv_sec; ?> #btnaddfld").on("click",function(e){ e.preventDefault();
			if (this.hasAttribute("disabled")){return;}
			let lo_ref = $("#<?= $lv_sec; ?> #finacctrediv").jstree(true);
			let lo_sel = lo_ref.get_selected();
			if(!lo_sel.length) { return false; }
			lo_sel = lo_sel[0];
			lo_sel = lo_ref.create_node(lo_sel, {"type":"folder", "text":"Nuevo Rubro/Subrubro"});
			if(lo_sel) { lo_ref.edit(lo_sel); }
		});

		// Edit node text
		$("#<?= $lv_sec; ?> #btnedt").on("click",function(e){ e.preventDefault();
			if (this.hasAttribute("disabled")){return;}
			let lo_ref = $("#<?= $lv_sec; ?> #finacctrediv").jstree(true);
			let lo_sel = $("#<?= $lv_sec; ?> #finacctrediv").jstree("get_selected",true)
			// Edit only folders
			if(lo_sel[0].type == "folder"){
				lo_ref.edit(lo_sel[0]);
			}
		});

		// Delete node
		$("#<?= $lv_sec; ?> #btndel").on("click",function(e){ e.preventDefault();
			if (this.hasAttribute("disabled")){return;}
			let lo_ref = $("#<?= $lv_sec; ?> #finacctrediv").jstree(true);
			let lo_sel = $("#<?= $lv_sec; ?> #finacctrediv").jstree("get_selected",true)
			for(let lv_i=0; lv_i<lo_sel.length; lv_i++){
				// Do not delete root
				if(lo_sel[lv_i].type == "root"){ return false; }
			}
			// Delete node and his childs
			lo_ref.delete_node(lo_sel);
		});

		// View account
		$("#<?= $lv_sec; ?> #btnvew").on("click",function(e){ e.preventDefault();
			if (this.hasAttribute("disabled")){return;}
			let lo_sel = $("#<?= $lv_sec; ?> #finacctrediv").jstree("get_selected",true);
			if(lo_sel.length > 0 && lo_sel[0].type == "account"){
				let lo_noddat = lo_sel[0].data || {};
				let lo_liatr  = lo_sel[0].li_attr || {};
				let lv_finacccod = lo_noddat.finacccod || lo_liatr['data-finacccod'] || null;
				if (lv_finacccod) {
					tmssLink('?prg=finacc&act=03&prm_finacccod=' + lv_finacccod ,[{target: "_new_section"}]);
				} else {
					toastr.warning("No se puede abrir la cuenta porque no tiene un código asignado.");
				}
			}
		});
    
		$("#<?= $lv_sec; ?> #finacctrediv").on("click",function(e){ e.preventDefault();
			let lo_sel = $("#<?= $lv_sec; ?> #finacctrediv").jstree("get_selected",true);
			$("#<?= $lv_sec; ?> #btnedt").removeClass('hidden');
			$("#<?= $lv_sec; ?> #btndel").removeClass('hidden');
			$("#<?= $lv_sec; ?> #btnaddacc").removeClass('hidden');
			$("#<?= $lv_sec; ?> #btnaddfld").removeClass('hidden');
			$("#<?= $lv_sec; ?> #btnvew").removeClass('hidden');
			// Edit only folders
			if(lo_sel[0].type == "root"){
				$("#<?= $lv_sec; ?> #btnaddacc").addClass('hidden');
				$("#<?= $lv_sec; ?> #btndel").addClass('hidden');
				$("#<?= $lv_sec; ?> #btnedt").addClass('hidden');
				$("#<?= $lv_sec; ?> #btnvew").addClass('hidden');
			}
			else if(lo_sel[0].type == "folder"){
				$("#<?= $lv_sec; ?> #btnedt").removeClass('hidden');
				$("#<?= $lv_sec; ?> #btndel").removeClass('hidden');
				$("#<?= $lv_sec; ?> #btnvew").addClass('hidden');
			}else{
				$("#<?= $lv_sec; ?> #btnaddfld").addClass('hidden');
				$("#<?= $lv_sec; ?> #btnaddacc").addClass('hidden');
				$("#<?= $lv_sec; ?> #btnedt").addClass('hidden');
			}
		});
	</script>	
	<script>		
		// function to make an array from tree
    function <?= $lv_sec; ?>_getaccfromtree( lo_nod, lv_finaccplnlvl, lo_arr ) {
    if(lo_nod.type != "root"){
        // jsTree guarda los datos extras en node.data o node.li_attr (según cómo fue creado)
        let lo_noddat   = lo_nod.data || {};
        let lo_liatr     = lo_nod.li_attr || {};
        
        let lv_finaccplnacccod = lo_noddat.finaccplnacccod || lo_liatr['data-finaccplnacccod'] || "";
        let lv_finaccplntxt = lo_nod.text;
        let lv_finacccod       = lo_noddat.finacccod       || lo_liatr['data-finacccod']       || null;
        let lv_curcod          = lo_noddat.curcod          || lo_liatr['data-curcod']          || "";
        let lv_finaccclscod    = lo_noddat.finaccclscod    || lo_liatr['data-finaccclscod']    || "";
        
        let lo_ret = {
            "finaccplnacccod": lv_finaccplnacccod,
            "finaccplnlvltxt": lv_finaccplntxt,
            "finacccod":       lv_finacccod,
            "finaccplnlvl":    lv_finaccplnlvl,
            "curcod":          lv_curcod,
            "finaccclscod":    lv_finaccclscod,
            "type":            lo_nod.type
        };
        lo_arr.push(lo_ret);
    }
    let lo_chi = lo_nod.children || [];
    for(let lv_i = 0; lv_i < lo_chi.length; lv_i++){
        <?= $lv_sec; ?>_getaccfromtree(
            lo_chi[lv_i],
            lv_finaccplnlvl + (lv_finaccplnlvl == "" ? "" : ".") + (lv_i+1).toString().padStart(2, "0"),
            lo_arr
        );
    }
}
  </script>
  <script>
    // curcod
    lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"curcod":"curcod"}, "typeahead":false};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
  </script>
	<script>
		tmssLoadScript("sheetjs",function(){
			// ARCHIVO. boton cargar archivo
			$("#<?= $lv_sec; ?> #btnupl").on("click",function(e){e.preventDefault();
				let lo_pstdat =[{name:"finaccplncod",value:$("#<?= $lv_sec; ?> #finaccplncod").val()}];
    		tmssCallProcess("?prg=finaccpln&act=finaccplnupl", lo_pstdat, function(data){
          BootstrapDialog.show({
  					title: "<?= $vew_lang->upload; ?>",
  					message: $(data),
  					closable: true,
  					draggable: true,
  					type: BootstrapDialog.TYPE_PRIMARY,
  					size: BootstrapDialog.SIZE_WIDE,
  					buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialog){ dialog.close();} },
  										{label: "<?= $vew_lang->continue ?>", cssClass: "btn-success hidden",id:"btnnxt",	action: function(dialog){dialog.$modalBody.find("#btnsve").trigger("click");}}
                     ]
  				});
      	});
			});
			
        // DESCARGAR
        $("#<?= $lv_sec; ?> #btndwn").on("click", function(e){ e.preventDefault();
            try {
                let lo_ref = $("#<?= $lv_sec; ?> #finacctrediv").jstree(true);
                if(!lo_ref) { toastr.warning("El árbol de cuentas no está listo"); return; }

                let lo_tre = lo_ref.get_json('#', {flat:false, no_state:true, no_id:false, no_children:false});
                let lo_arr = [];
                if (lo_tre && lo_tre.length > 0) {
                    <?= $lv_sec; ?>_getaccfromtree(lo_tre[0], '', lo_arr);
                }


                // Cabecera
                let lo_row = [["CODIGO", "NOMBRE", "ES CUENTA", "ID CUENTA", "MONEDA", "CLASIFICACION"]];

                if(lo_arr.length == 0) {
                    toastr.warning("No hay cuentas para descargar");
                    return;
                } else {
                    for(let lv_i=0; lv_i<lo_arr.length; lv_i++){
                        let lv_finaccplnlvl    = lo_arr[lv_i]["finaccplnlvl"];
                        let lv_finaccplntxt    = lo_arr[lv_i]["finaccplnlvltxt"].trim();
                        let lv_acc  = lo_arr[lv_i]["type"] == "account" ? "SI" : "NO";
                        let lv_finacccod = lo_arr[lv_i]["finacccod"]!=null && lo_arr[lv_i]["finacccod"]!=0 ? lo_arr[lv_i]["finacccod"] : "";
                        let lv_curcod = lo_arr[lv_i]["curcod"] ? lo_arr[lv_i]["curcod"] : "";
                        let lv_finaccclscod = lo_arr[lv_i]["finaccclscod"] ? lo_arr[lv_i]["finaccclscod"].toUpperCase() : "";

                        let lv_clstxt = "";
                        if (lv_finaccclscod === "A") lv_clstxt = "ACTIVO";
                        else if (lv_finaccclscod === "P") lv_clstxt = "PASIVO";
                        else if (lv_finaccclscod === "R+") lv_clstxt = "RESULTADO POSITIVO";
                        else if (lv_finaccclscod === "R-") lv_clstxt = "RESULTADO NEGATIVO";
                        else if (lv_finaccclscod === "PN") lv_clstxt = "PATRIMONIO NETO";
                        else lv_clstxt = lv_finaccclscod;

                        lo_row.push([ lv_finaccplnlvl, lv_finaccplntxt, lv_acc, lv_finacccod, lv_curcod, lv_clstxt ]);
                    }
                }


                let lo_ws = XLSX.utils.aoa_to_sheet(lo_row);

                lo_ws["!cols"] = [
                    { wch: 25 }, // CODIGO
                    { wch: 55 }, // NOMBRE
                    { wch: 12 }, // ES CUENTA
                    { wch: 12 }, // ID CUENTA
                    { wch: 12 }, // MONEDA
                    { wch: 20 }  // CLASIFICACION
                ];


                let lo_wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(lo_wb, lo_ws, "Plan de Cuentas");
                
                let lv_xlsbin = XLSX.write(lo_wb, { bookType: 'biff8', type: 'binary', mimeType: 'application/vnd.ms-excel' });
                
                let lo_buf = new ArrayBuffer(lv_xlsbin.length);
                let lo_vew = new Uint8Array(lo_buf);
                for (let lv_i = 0; lv_i != lv_xlsbin.length; ++lv_i) lo_vew[lv_i] = lv_xlsbin.charCodeAt(lv_i) & 0xFF;

                let lo_blb = new Blob([lo_buf], { type: 'application/vnd.ms-excel' });
                
                let lo_lnk = document.createElement('a');
                lo_lnk.href = window.URL.createObjectURL(lo_blb);
                lo_lnk.download = "Plan_de_Cuentas.xls";
                lo_lnk.click();

            } catch(lo_err) {
                toastr.warning("Error al descargar: " + lo_err.message);
            }
        });
      
			// El proceso de carga desde archivo ahora se hace en finaccplnupl.php
			
		});
	</script>  
	<script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// Get tree info
			let lo_ref = $("#<?= $lv_sec; ?> #finacctrediv").jstree(true);
			let lo_tre = lo_ref.get_json();
			let lo_arr = new Array();
			<?= $lv_sec; ?>_getaccfromtree( lo_tre[0], '', lo_arr );
      $("#<?= $lv_sec; ?> #finaccplnacc").prop("value", JSON.stringify(lo_arr) );
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>