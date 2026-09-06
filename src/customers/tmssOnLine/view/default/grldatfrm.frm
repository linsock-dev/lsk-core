<?php
  // campos requeridos 
  $vew_input->RequiredFields( array() );

  // clave del documento 
  $lv_dockey = $vew_data->frmdatcod;

  // titulo 
  $lv_title = $vew_lang->form;

  // módulo y programa 
  $lv_mdlcod = 'GRL';
  $lv_prgcod = 'FRM';

  // librería de estilos bootstrap 
  include_once('_library.frm');
	
  $vew_readonly = $vew_data->readonly;

	// preparo la tabla de atributos
	$lv_atr = array();
	foreach( $vew_data->sysdocfrm->sysdocfrmfldatr as $lv_rowatr ){
		$lv_atr[ $lv_rowatr['sysdocfrmfldatrcod'] ] = array('prop'=>$lv_rowatr['sysdocfrmfldatrtag'].'_'.$lv_rowatr['sysdocfrmfldatrtgt']);
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('frmdatcod', 'hidden', $vew_data->frmdatcod??''); ?>
		<?= gethtml('srcobjtyp', 'hidden', $vew_data->srcobjtyp??''); ?>
		<?= gethtml('srcobjcod001', 'hidden', $vew_data->srcobjcod001??''); ?>
		<?= gethtml('srcobjcod002', 'hidden', $vew_data->srcobjcod002??''); ?>
		<?= gethtml('sysdocfrmcod', 'hidden', $vew_data->sysdocfrm->sysdocfrmcod??''); ?>
		<?= gethtml('sysdocfrmtxt', 'hidden', $vew_data->sysdocfrm->sysdocfrmtxt??''); ?>
		<?php
			// CAMPOS. recorro campos del formulario
			foreach( $vew_data->sysdocfrm->sysdocfrmfld as $lv_rowsys ){
				$lv_prmdef = $lv_default;
				
				// ATRIBUTOS. para el campo del formulario obtengo los valores de cada atributo
				$lv_tmpatr = json_decode($lv_rowsys['sysdocfrmfldatr'],true);
				foreach( $lv_tmpatr as $lv_rowatr ){
					// si tiene id de atributo
					if( ($lv_rowatr['sysdocfrmfldatrcod']??'')!='' ){
						// si ese id de atributo existe
						if( $lv_atr[$lv_rowatr['sysdocfrmfldatrcod']]!='' ){
							// en el atributo del campo fijo el valor del atributo
							$lv_prop = $lv_atr[$lv_rowatr['sysdocfrmfldatrcod']]['prop'];
							if(!isset($lv_prmdef['atrval'][$lv_prop])){ $lv_prmdef['atrval'][$lv_prop]=''; }
							$lv_prmdef['atrval'][ $lv_prop ] .= ($lv_rowatr['sysdocfrmfldatrval']??'');
						}
					}
				}

				// GRABADO. busco si hay un dato grabado para el campo
				$lv_val = ($lv_prmdef['atrval']['defval_value']??'');
				$lv_frmdatfldcod = '';
        if(is_array($vew_data->grldatfrmfld) && $vew_data->grldatfrmfld != '' ){
        	foreach( $vew_data->grldatfrmfld as $lv_rowdat ){
            if( $lv_rowsys['sysdocfrmfldcod']==$lv_rowdat['frmdocfldcod'] ) {
              $lv_val = $lv_rowdat['frmdatval'];
              $lv_frmdatfldcod = $lv_rowdat['frmdatfldcod'];
              break;
            }
					}
        }
			

				// CAMPO. determino y escribo el tipo de campo
				$lv_id = ($lv_prmdef['atrval']['fldcod_name']??'');	
				$lv_lblshw = ($lv_prmdef['atrval']['lblshw_class']??'');
				$lv_lbltxt = utf8_decode($lv_prmdef['atrval']['lbltxt_text']??'');
        
				$lv_prm = ($vew_readonly?$lv_always_disabled:$lv_default);
				$lv_prm['atrval']['min'] = ($lv_prmdef['atrval']['minval_min']??'');
				$lv_prm['atrval']['max'] = ($lv_prmdef['atrval']['maxval_max']??'');
				$lv_prm['atrval']['step'] = ($lv_prmdef['atrval']['stpval_step']??'');
				$lv_prm['atrval']['placeholder'] = ($lv_prmdef['atrval']['plchld_placeholder']??'');
				$lv_prm['atrval']['maxlength'] = ($lv_prmdef['atrval']['maxlng_maxlength']??'');
				$lv_prm['atrval']['format'] = ($lv_prmdef['atrval']['fldfmt_format']??'');
				$lv_prm['atrval']['css'] .= ' '.($lv_prmdef['atrval']['fldcss_class']??'');
				$lv_prm['atrval']['css'] .= ' '.(($lv_prmdef['atrval']['reqfld_required']??'')!=''?'tmssInputRequired':'');
				$lv_prm['atrval']['style'] = ($lv_prmdef['atrval']['fldsty_style']??'');
				$lv_prm['atrval']['rows'] = ($lv_prmdef['atrval']['fldrow_rows']??'');
				$lv_prm['atrval']['data'] = array('sysfldinptyp'=>strtolower($lv_rowsys['sysfldinptyp']),
																					'frmdocfldcod'=>$lv_rowsys['sysdocfrmfldcod'],
																					'frmdatfldcod'=>$lv_frmdatfldcod,
																					'frmfld'=>'GRL_DAT_FRM_FLD');
				$lv_prm['atrval']['multiple'] = ($lv_prmdef['atrval']['mtpsel_multiple']??'');
       
     
      	$lv_cmbopt = '';
				if( ($lv_prmdef['atrval']['flddef_data-typdef']??'')!='' ){ $lv_prm['atrval']['data']['typdef']=($lv_prmdef['atrval']['flddef_data-typdef']??''); }
				if( ($lv_prmdef['atrval']['fldflt_data-typflt']??'')!='' ){ $lv_prm['atrval']['data']['typflt']=(str_replace('"', "'", ($lv_prmdef['atrval']['fldflt_data-typflt'])) ??''); }
				if( ($lv_prmdef['atrval']['fldasg_data-typasg']??'')!='' ){ $lv_prm['atrval']['data']['typasg']=(str_replace('"', "'", ($lv_prmdef['atrval']['fldasg_data-typasg'])) ??''); }
				if( ($lv_prmdef['atrval']['fldpop_data-typpop']??'')!='' ){ $lv_prm['atrval']['data']['typpop']=($lv_prmdef['atrval']['fldpop_data-typpop']??''); }
				if(	($lv_prmdef['atrval']['fldval_options']??'')!=''){
					$lv_cmbopt=array();
					foreach(explode(chr(10), $lv_prmdef['atrval']['fldval_options']) as $lv_row){
						if( count(explode('|',$lv_row))==2 ){
							$lv_cmbopt[explode('|',$lv_row)[0]]=explode('|',$lv_row)[1];
						}
					}
        }
        
				// determino columnas
				$lv_col = ( $lv_lblshw=='' && $lv_rowsys['sysfldinptyp']!='HR' ? $lv_col39 : $lv_col12 );
				
				// determino etiqueta (label)
				$lv_fld = array();
				if( $lv_lblshw=='' && $lv_rowsys['sysfldinptyp']!='HR' ){ $lv_fld['label']=$lv_lbltxt; $lv_fld['input']=''; }
				
				// determino campo

				switch( $lv_rowsys['sysfldinptyp'] ){
					case 'HR':				$lv_fld['input'] = '<hr id="'.$lv_id.'" name="'.$lv_id.'" class="'.str_ireplace('form-control','',$lv_prm['atrval']['css']).'" style="'.$lv_prm['atrval']['style'].'">'; break;
					case 'BUTTON':		$lv_fld['input'] = '<a href="#" id="'.
                                                $lv_id.'" name="'.$lv_id.'" class="btn btn-default inputObject '.
            																		$lv_prm['atrval']['css'].'" style="'.$lv_prm['atrval']['style'].
            																		'" data-btnact="'.($lv_prmdef['atrval']['fldact_data-btnact']??'').
            																		'"data-sysfldinptyp="'.($lv_prm['atrval']['data']['sysfldinptyp']??'').
                                                '">'.
                                                utf8_decode($lv_prmdef['atrval']['fldtxt_text']??'').
            																		'</a>';	break;
					case 'LABEL':			/* no hay campo */ break;
					case 'TEXT':			$lv_fld['input'] = gethtml($lv_id,'doccmt1x250',$lv_val,$lv_prm);	break;
					case 'NUMBER':		$lv_fld['input'] = gethtml($lv_id,'docnum0603',$lv_val,$lv_prm); break;
					case 'DATE': 			$lv_fld['input'] = gethtml($lv_id,'docdte',$lv_val,$lv_prm); break;
					case 'TYPEAHEAD': $lv_fld['input'] = vew_boot(array('style'=>'search'),array('input'=>gethtml($lv_id,'typeahead',$lv_val,$lv_prm))); break;
					case 'FILE': 			$lv_fld['input'] = gethtml($lv_id,'flefle',$lv_val,$lv_prm); break;
					case 'CHECKBOX': 	$lv_fld['input'] = gethtml($lv_id,'checkbox',$lv_val,$lv_prm); break;
					case 'TEXTAREA': 	$lv_fld['input'] = gethtml($lv_id,'doccmt5x50',$lv_val,$lv_prm); break;
					case 'LIST': 			$lv_fld['input'] = gethtml($lv_id,$lv_cmbopt,$lv_val,$lv_prm); break;
          case 'COMBO': 	$lv_fld['input'] = gethtml($lv_id,$lv_cmbopt,$lv_val,$lv_prm); break;
					default: $lv_def = 'doccmt1x50'; break;
				}
				echo vew_boot( $lv_col, $lv_fld );
			                                 
				// ARCHIVOS. armo tabla de archivos adjuntos
				if( $lv_rowsys['sysfldinptyp']=='FILE' ){
          $lv_buffer = '';
          if(isset($vew_data->getdatupl) && $vew_data->getdatupl != ''){
              foreach( $vew_data->getdatupl as $lv_rowfle ){
                if($lv_rowfle['flesrcfld']==$lv_rowsys['sysdocfrmfldcod']){
                  $lv_buffer.='<tr><td><a href="#" name="file-download" data-flecod="'.$lv_rowfle['flecod'].'">'.$lv_rowfle['flenme'].'</a></td><td class="text-right">'.intval($lv_rowfle['flesze']/1024).' KB</td><td><a href="#" class="card-icon" name="file-delete"><i class="far fa-trash"></i></a></td></tr>';
                }
              }
          }
          echo '<table class="table table-condensed '.($lv_buffer==''?'hidden':'').'">'
          . '<thead><tr><th width="75%">'.$vew_lang->file.'</th>'
          . '<th class="hidden-xs hidden-sm">'.$vew_lang->size.'</th>'
          . (!$vew_readonly?'<th class="hidden-xs hidden-sm"></th>':'')
          . '</tr></thead><tbody>'.$lv_buffer.'</tbody></table>';
				}
			}
		?>
		<a href="#" class="hidden" id="btnsve"></a>
  </form>
	<script>
		// TYPEAHEADs. preparo campos de tipo typeahead
		$("#<?= $lv_sec; ?> input[data-sysfldinptyp=typeahead]").each(function(){  
			var lv_def = $(this).data("typdef") != undefined ? $(this).data("typdef").trim() : ""; 
			var lv_fldasg = JSON.parse(($(this).data("typasg") != undefined ? $(this).data("typasg").trim() : "") != "" ? $(this).data("typasg").replace(/'/g, '"') : "{}");
			var lv_fldflt = JSON.parse(($(this).data("typflt") != undefined ? $(this).data("typflt").trim() : "") != "" ? $(this).data("typflt").replace(/'/g, '"') : "{}");
			var lv_popup = $(this).data("typpop");
			var lo_get = {"fldsec" : "<?= $lv_sec; ?>", 
								"fldflt": lv_fldflt, 
								"fldasg": lv_fldasg,
              	"typeahead": lv_popup.trim().toUpperCase() == "SP" ? false : true,
								"popup": lv_popup.trim().toUpperCase() == "NO" ? false : true
                   }; 
			if(lv_def != '' ){
        tmssTypeahead($(this), lv_def, lo_get); 
      }
			
		});
		
		
    // BUTTON. prepara eventos para botones
    $("#<?= $lv_sec; ?> a[data-sysfldinptyp=button]").on("click", function(e){ e.preventDefault();
      
      var lv_act = $(this).data("btnact");
      if(lv_act != undefined && lv_act!=""){
				var lo_dat = <?= $lv_sec; ?>_getFormData();
        tmssCallProcessFile(lv_act, lo_dat, function(data){});
      }
    });
	</script>
	<script>		
    // ARCHIVOS. AGREGAR. agrega archivos al listado
    $("#<?= $lv_sec; ?> *[data-sysfldinptyp=FILE]").on("change", function(e){
      var lv_fle_arr = $(this).prop("files"); 
      
      // validación de cant. max de archivos
      if($(this).prop("multiple") != false){
        var lv_maxfle = $(this).data("maxfle");
        if((lv_fle_arr.length + $(this).next().find("tbody tr").length) > lv_maxfle){
          toastr.warning("Se permiten un m&aacute;ximo de "+lv_maxfle+" archivos.");
          $(this).val("");
          return false;
        }
      }
      
      // validación max file size
      if($(this).data("maxflesze") != undefined){
        var lv_maxfle = $(this).data("maxflesze");
        for(let i=0; i<lv_fle_arr.length; i++){
          if(lv_fle_arr[i].size / 1024 / 1024 > lv_maxfle){
            toastr.warning("Se permiten archivos de un m&aacute;ximo de "+lv_maxfle.toFixed(1)+" mb.");
            $(this).val("");
            return false;
          }
      	}
      }
    });

		// ARCHIVOS. DESCARGAR. descarga de archivo
    $("#<?= $lv_sec; ?> a[name=file-download]").on("click", function(e){ e.preventDefault();
			var lv_pstdat=[ {name:"flesrctyp",value:"GRL_FRM"},
											{name:"flesrccod",value:"<?= $vew_data->frmdatcod; ?>"},
											{name:"flecod",value:$(this).data("flecod")}
										];
			tmssCallProcessBlob( "?prg=grldatupl&act=downloadFile",lv_pstdat,function(e){
				if(data.type=="application/json" || data.type=="text/html"){
					data.text().then(function(result) {
						var lv_err = JSON.parse(result);
						toastr.warning("No se puede descargar el archivo.<br>"+lv_err.errcod+": "+lv_err.errtxt);
					});
          return false;
				}
				var url = window.URL.createObjectURL(data);
				window.open(url, "_blank");
				return true;
			});
		});
		
		// ARCHIVOS. BORRAR. borra un archivo del formulario
    $("#<?= $lv_sec; ?> a[name=file-delete]").on("click", function(e){ e.preventDefault();
			var lv_row = $(this).parent().parent();
			if( $(this).data("flecod")!="" ){
				$(lv_row).remove();
			} else {
				var lv_pstdat=[ {name:"flesrctyp",value:"GRL_FRM"},
												{name:"flesrccod",value:"<?= $vew_data->frmdatcod; ?>"},
												{name:"flecod",value:$(this).data("flecod")}
											];
				tmssCallProcess( "?prg=grldatupl&act=deleteFile",lv_pstdat,function(e){
					$(lv_row).remove();
					toastr.success("Archivo eliminado.");
				});
			}
		});
	</script>
  <script>
		// GET FORM DATA. serializa los datos del formulario
		function <?= $lv_sec; ?>_getFormData(){
      var lv_frm_arr = [];
      var lv_fle_arr = [];			

			// obtiene los valores de los input
      $("#<?= $lv_sec; ?> *[data-frmfld=GRL_DAT_FRM_FLD]").each(function(){ 
				var lv_val;
				switch( $(this).get(0).tagName ){
					case "LIST": case "SELECT": 
						if( Array.isArray($(this).val()) ){
							lv_val = $(this).val().join("|"); 
						} else {
							lv_val = $(this).val();
						}
						break;
					case "CHECKBOX": lv_val = ($(this).val()==1?"true":"false"); break;
					default: lv_val = $(this).val();
				}

				lv_frm_arr.push({"frmdatfldcod":$(this).data("frmdatfldcod"),
												"frmdatfldcodext":$(this).prop("name"),
												"frmdatval":lv_val,
												"frmdocfldcod": $(this).data("frmdocfldcod")}); 
				if($(this).data("code") == "FILE"){
				 lo_values[lo_values.length-1]["fle"] = "X";
				}
      });

			// obtener valores de los file
			var lv_fldfle;
			$(this).find("*[data-sysfldinptyp=FILE]").each(function(){ 
				lv_fldfle = $(this).prop("files");
				var lv_docfrmcod = $("#<?= $lv_sec; ?> #sysdocfrmcod").val();
				var lv_frmdatcod = $("#<?= $lv_sec; ?> #frmdatcod").val();
				var lv_datfldcod = $(this).data("frmdatfldcod");
				var lv_docfldcod = $(this).attr("id");
				for(let i=0; i < lv_fldfle.length; i++){
					lv_fle_arr["fle_" + lv_docfrmcod + "_" + lv_docfldcod + "_" + lv_frmdatcod + "_" + lv_datfldcod + "_" + i] = lv_fldfle[i];
				}
			});
			
           
			// preparo datos para grabado
			var lo_dat = new FormData();

      lo_dat.append("frmdatcod", "<?= $vew_data->frmdatcod; ?>");
      lo_dat.append("srcobjtyp", "<?= $vew_data->srcobjtyp; ?>");
      lo_dat.append("srcobjcod001", "<?= $vew_data->srcobjcod001; ?>");
      lo_dat.append("srcobjcod002", "<?= $vew_data->srcobjcod002; ?>");
      lo_dat.append("sysdocfrmcod","<?=$vew_data->sysdocfrm->sysdocfrmcod?>");
     	lo_dat.append("docsts","A");
			lo_dat.append("frmdat", JSON.stringify(lv_frm_arr));
    	for(var key in lv_fle_arr){ lo_dat.append(key, lv_fle_arr[key]); }
			
			return lo_dat;
		}
		
		
		// GRABAR. proceso grabado de formulario
    $("#<?= $lv_sec; ?> #btnsve").on("click", function(e){ e.preventDefault();
      // revisa campos validos y requeridos
			if( !tmssFormValidation( $("#<?= $lv_sec; ?>_frm") ) ){ return false; }
			if( !tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") ) ){ return false; }		
			
			// recupera datos del formulario
			var lo_dat = <?= $lv_sec; ?>_getFormData();

			if( lo_dat==false ){ return false; }
      tmssCallProcessFile("?prg=grldatfrm&act=00", lo_dat, function(data){
        if($("#<?= $lv_sec; ?> #btnsve").data("btn_callback") != undefined){
        	$("#<?= $lv_sec; ?>").parents(".modal-body").next().find($("#<?= $lv_sec; ?> #btnsve").data("btn_callback")).trigger("click");
        }
        $("#<?= $lv_sec; ?> #btnsve").data("frmdatcod",data["frmdatcod"]);
      });
    });
  </script>
  <script>
    tmssFormEdit("<?= $lv_sec; ?>","true");
  </script>
</section>