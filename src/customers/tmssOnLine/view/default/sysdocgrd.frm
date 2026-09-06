<?php	
	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');

	// determino el controlador a utilizar
	$vew_controller = ($vew_controller!=''?$vew_controller:($vew_view!=''?$vew_view:$vew_model));

	/* filtro de vista pre establecido */
	$lv_vewfldflt='';
	/*if ( isset($vew_prm['vewfldflt']) ) {
		$lv_vewfldflt = $vew_prm['vewfldflt'];
		unset($vew_prm['vewfldflt']);
	}*/
	$lv_vewfldfltdef='';
	if ( isset($vew_prm['vewfldfltdef']) ) {
		$lv_vewfldfltdef = $vew_prm['vewfldfltdef'];
		unset($vew_prm['vewfldfltdef']);
	}

	/* cadena para querystring */
	$lv_urlkey = '';
	foreach ( $vew_prm as $lv_row=>$lv_val ) {
		$lv_urlkey .= '&prm_'.$lv_row.'='.$lv_val;
	}

	$lv_actcod = (isset($vew_prm['actcod'])?$vew_prm['actcod']:'');	
?>
<section id="<?= $lv_sec; ?>">

	<?php if ($vew_defcfg['toolbar']==true) { ?>
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
      <ul class="nav navbar-nav tmss-navbar-left">
				<?php
					if ( !isset($vew_prm['popup']) && isset($vew_defopr) ) {
						foreach( $vew_defopr as $lv_row ) {
							if ( $lv_row['oprshwgrd']=='1' ) {
								$lv_row['oprpic'] = strtolower($lv_row['oprpic']);
								$lv_param = '';
								foreach($vew_prm as $lv_key=>$lv_val) { $lv_param .= '&prm_'.$lv_key.'='.$lv_val; }
								echo '<a href="#" onclick="tmssLink('.chr(39).'?prg='.($vew_view!=''?$vew_view:$vew_model).'&act=01'.$lv_param.chr(39).', [{target: '.chr(39).'_new_section'.chr(39).'}] );" class="btn btn-default navbar-btn">'.(substr($lv_row['oprpic'],0,6)=='class:'?'<span class="'.substr($lv_row['oprpic'],6,strlen($lv_row['oprpic'])-6).'"></span>':'<img src="view/default/library/images/'.$lv_row['oprpic'].'">').' '.$vew_lang->get($lv_row['oprtxt']).'</a></li>';
							}
						}
					}
					if($vew_defhdr['vewselmod']=='N'){
						echo '<a href="#" onclick="'.$lv_sec.'_checkboxSelect();" class="btn btn-default navbar-btn"><i class="far fa-check"></i> '.$vew_lang->get('select').'</a></li>';
					}
				?>
      </ul>
      <ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if ( $vew_defhdr['vewalwflt']==1 && $vew_defcfg['toolbar.filter']==true ) { ?>
					<!-- filtro -->
					<a href="#" id="<?= $lv_sec; ?>_fltbtn" class="btn navbar-btn tmss-navbar-btn"><i class="fas fa-filter"></i><span id="fltcnt" class="badge"></span></a>
				<?php } ?>
				
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<?php if ( $vew_defcfg['toolbar.refresh']==true ) { ?>
							<!-- Actualizar -->
							<li><a href="#" onclick="<?= $lv_sec; ?>_GridRefresh();" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<?php } ?>
						<?php if ($vew_defcfg['toolbar.options.print']==true) 		{ ?>
							<!-- Imprimir -->
							<li><a href="#" onclick="window.print();" class="tmssLink"><i style="width:20px" class="fas fa-print"></i> <?= $vew_lang->print; ?></a></li>
						<?php } ?>
						<?php if ($vew_defcfg['toolbar.options.export']==true) 		{ ?>
							<!-- Exportar -->
							<li><a href="#" id="<?= $lv_sec; ?>_expbtn" class="tmssLink"><i style="width:20px" class="fas fa-download"></i> <?= $vew_lang->export; ?></a></li>
						<?php } ?>
						<?php if ($vew_defcfg['toolbar.options.send']==true) 			{ ?>
							<!-- Enviar -->
							<li class="disabled"><a href="#" data-toggle="modal" data-target="#<?= $lv_sec; ?>_snd" class="tmssLink"><i style="width:20px" class="fas fa-paper-plane"></i> <?= $vew_lang->send; ?></a></li>
						<?php } ?>
						<?php if ($vew_defcfg['toolbar.options.favorites']==true) { ?>
							<!-- Favoritos -->
							<li class="disabled"><a href="#" class="tmssLink"><i style="width:20px" class="far fa-star"></i> <?= $vew_lang->favorites; ?></a></li>
						<?php } ?>
						<?php if ($vew_defcfg['toolbar.options.technical']==true) { ?>
							<!-- Info Tecnica -->
							<li class="divider"></li><li><a href="#" id="btntchinf" class="tmssLink"><i style="width:20px" class="fas fa-code"></i> <?= $vew_lang->additionalinfo; ?></a></li>
						<?php } ?>
          </form>
        </div>
				<?php if ( !isset($vew_prm['popup']) && $vew_defcfg['toolbar.close']==true ) { ?>
					<!--Cerrar-->
					<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><i class="fas fa-times"></i></a>
				<?php } ?>
      </ul>
    </div>
  </nav>
  <?php } ?>
	<!-- data-striped="<?= (isset(explode(' ',$vew_defhdr['vewatr']??'')['tstriped'])?'false':'true'); ?>"  -->	
	<script>
	function <?= $lv_sec; ?>_rowStyle(row, index) {
		var lv_class = "";
		if( row["rowstyle"]!=undefined ) {
			var lv_row = row["rowstyle"].trim().toLowerCase();
			if(lv_row.substr(0,6)=="class:") {
				return {classes: lv_row.substr(7)};
			} else if(lv_row.substr(0,4)=="css:") {
				var lv_obj = {};
				var lv_strarr = lv_row.substr(5).split(";");
				for (var i = 0; i < lv_strarr.length; i++) {
					var split = lv_strarr[i].split(":");
					if(split.length==2){lv_obj[split[0].trim()] = split[1].trim();}
				}
				return {css: lv_obj};
			} else {
				return {classes: lv_class};
			}
		} else {
			return {classes: lv_class};
		}
	}
	</script>	
  <div class="container-fluid">
		<?= gethtml('checkboxSelect','hidden','0'); ?>
    <?= gethtml('vewfldord','hidden',($vew_prm['vewfldord']??''!=''?$vew_prm['vewfldord']:'')); ?>
    <?= gethtml('vewmaxrec','hidden',($vew_prm['vewmaxrec']??''!=''?$vew_prm['vewmaxrec']:$vew_defhdr['vewdefmaxrec'])); ?>
    <textarea style="display: none;" id="vewfldflt" name="vewfldflt"><?= ($vew_prm['vewfldflt']??''!=''?$vew_prm['vewfldflt']:$lv_vewfldfltdef); ?></textarea>
    <textarea style="display: none;" id="vewfldfltpre"><?= $lv_vewfldflt; ?></textarea>
    <table id="sysdocgrd_table" 
            data-toggle="table" 
            data-show-header="<?= (isset(explode(' ',$vew_defhdr['vewatr']??'')['theader'])?'false':'true'); ?>" 
            data-show-footer="<?= (isset(explode(' ',$vew_defhdr['vewatr']??'')['tfooter'])?'true':'false'); ?>" 
            data-height="430" data-cache="false" data-toolbar="#mytoolbar"
            data-show-refresh="false" data-show-columns="false" data-show-export="false" data-show-toggle="false" data-show-pagination-switch="false"
						data-search="false" data-pagination="false" data-side-pagination="server" data-classes="table table-hover table-no-bordered table-condensed"
						data-sort-class="active" data-row-style="<?= $lv_sec; ?>_rowStyle"
          >
      <thead>
      <tr>
				<?php 
					if ($vew_defhdr['vewselmod']=='N') { echo '<th data-field="vewfldchk" data-fltfield="vewfldchk" data-sortable="false" data-checkbox="true"></th>'; }
					foreach ( $vew_defcol as $lv_row ) {
						//$lv_row = $lv_tmp;
						if ( $lv_row['vewfldwth']!=0 ) {
							echo '<th data-field="'.$lv_row['vewfld'].'" data-fltfield="'.str_replace('.','_',$lv_row['vewfld']).'" data-sortable="'.($vew_defhdr['vewalwsrt']==1?'true':'false').'" data-sort-class="tmss-table-active" data-halign="left" data-align="'.$lv_row['vewfldalg'].'">'.$vew_lang->get( $lv_row['vewfldttl'] ).'</th>';
						}
					}
				?>
      </tr>
      </thead>
<!--  <tfooter>
        <?php 
          //foreach ( $vew_defcol as $lv_row ) {
            //$lv_row = $lv_tmp;
            //echo '<tf data-field=''.$lv_row['vewfld'].'' data-sortable=''.($vew_defhdr['vewalwsrt']==1?'true':'false').'' data-halign='left' data-align=''.$lv_row['vewfldalg'].''>'.$vew_lang->get( $lv_row['vewfldttl'] ).'</tf>';
          //}
        ?> 
      </tfooter> -->
    </table>
    <div class="fixed-table-pagination">
      <div class="pull-left pagination-detail" style="margin-top: 0px !important;">
        <span class="pagination-info"></span>
      </div>
    </div>    
  </div> <!-- container-fluid -->

  <!-- E X P O R T -->
	<?php include('sysdocgrd_exp.frm'); ?>
	
  <!-- S E N D -->
  <?php include('sysdocgrd_snd.frm'); ?>

  <!-- F I L T E R -->
	<?php include('sysdocgrd_flt.frm'); ?>
	
  <!-- T E C H N I C A L -->
	<?php include('sysdocgrd_tch.frm'); ?>

  <script>		
		// field assignment
		function sysdocgrd_assign( lp_data ) {
			<?php
				if ( isset($vew_prm['fldasg']) ) {
					$lv_asg = explode(',', $vew_prm['fldasg']);
					?>
					if($("#<?= $vew_prm['fldsec']; ?>").length==0){
						$.each(BootstrapDialog.dialogs, function(id, dialog){
							if(dialog.getModalBody().find("#<?= $vew_prm['fldsec']; ?>").length>0){
								<?php
								foreach( $lv_asg as $lv_row ) {
									$lv_asgfld = explode(':', substr($lv_row,1,strlen($lv_row)-2) );
									$lv_dstfld = $lv_asgfld[0];
									$lv_srcfld = $lv_asgfld[1];
									echo 'dialog.getModalBody().find("#'.$lv_dstfld.':first").prop("value", (lp_data.hasOwnProperty("'.$lv_srcfld.'")?lp_data["'.$lv_srcfld.'"]:sysdocgrd_findfield(lp_data,"'.$lv_srcfld.'"))).trigger("change"); ';
								}
								?>
							}
						});
					} else {
						<?php
							foreach( $lv_asg as $lv_row ) {
								$lv_asgfld = explode(':', substr($lv_row,1,strlen($lv_row)-2) );
								$lv_dstfld = $lv_asgfld[0];
								$lv_srcfld = $lv_asgfld[1];
								echo '$("#'.$vew_prm['fldsec'].' #'.$lv_dstfld.':first").prop("value", (lp_data.hasOwnProperty("'.$lv_srcfld.'")?lp_data["'.$lv_srcfld.'"]:sysdocgrd_findfield(lp_data,"'.$lv_srcfld.'"))).trigger("change"); ';
							}
						?>
					}
					<?php
					/*
					foreach( $lv_asg as $lv_row ) {
						$lv_asgfld = explode(':', substr($lv_row,1,strlen($lv_row)-2) );
						$lv_dstfld = $lv_asgfld[0];
						$lv_srcfld = $lv_asgfld[1];
						echo 'if(lv_popup){lv_fld=lv_dialog.getModalBody().find("#'.$lv_dstfld.':first"); } else { lv_fld = $("#'.$lv_sec.' #'.$lv_dstfld.':first"); }';
						echo '$(lv_fld).prop("value", ($(lp_data).prop("'.$lv_srcfld.'")?$(lp_data).prop("'.$lv_srcfld.'"):sysdocgrd_findfield(lp_data,"'.$lv_srcfld[1].'"))).trigger("change"); ';
					}
					*/
				}
			?>
			
			
			<?php
				/*
				if ( isset($vew_prm['fldasg']) ) {
					$lv_asg = explode(',', $vew_prm['fldasg']);
					foreach( $lv_asg as $lv_row ) {
						$lv_asgfld = explode(':', substr($lv_row,1,strlen($lv_row)-2) );
						echo '$("#'.$vew_prm['fldsec'].'").find("#'.$lv_asgfld[0].':first").prop("value",'.
									'($(lp_data).prop("'.$lv_asgfld[1].'")?'.
										'$(lp_data).prop("'.$lv_asgfld[1].'")'.
										':'.
										' sysdocgrd_findfield( lp_data, "'.$lv_asgfld[1].'" ) '.
									')).trigger("change"); ';
					}
				} 
				*/
			?>
		}
		
		// find field
		function sysdocgrd_findfield( lp_data, lp_fldkey ) {
			var lv_dat="";
			var lv_arr;
			$.each(lp_data, function(lp_key, lp_val){
				lv_arr = lp_key.split(".");
				if(lv_arr.length==1){
					if(lv_arr[0]==lp_fldkey){
						lv_dat = lp_val;
					}
				}else if(lv_arr.length==2){
					if(lv_arr[1]==lp_fldkey){
						lv_dat = lp_val;
					}					
				}
			});
			return lv_dat;
		}
		    
    // G E N E R A L
		// grid refresh
		function <?= $lv_sec; ?>_GridRefresh() {
			$("#<?= $lv_sec; ?> #sysdocgrd_table").bootstrapTable("refresh");
		}
    
		function <?= $lv_sec; ?>_checkboxSelect(){
			var lv_qty = $("#<?= $lv_sec; ?>").find("input[type=checkbox]:checked").length;
			
			// valido que se hayan seleccionado elementos
			if( lv_qty==0 ){
				toastr.warning("Debe seleccionar al menos un elemento de la lista.");
				return false;
			}
			
			// establezco flag de seleccion
			$("#<?= $lv_sec; ?> #checkboxSelect").val( lv_qty );
			
			// cierro dialogo actual
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				if(dialog.getModalBody().find("#<?= $lv_sec; ?>").length>0){
					dialog.close();
				}
			});
		}
		
		tmssLoadScript("table", function(){
		
			// bootstrap table setup & data load
      //TODO: generalizar la clave del localStorage por si se cambia 
      lv_svrnme = window.location.hostname;
      // Hacer ucfirst (poner la primera letra en mayúscula)
      lv_svrnme = lv_svrnme
        .split('.')
        .map(part => part.charAt(0).toUpperCase() + part.slice(1))
        .join('.');
      lv_usrcodnme=lv_svrnme + ".Usrcod";
      lvusrtknnme=lv_svrnme+".Usrtkn";
      const lv_headers = {"gorse-token": localStorage.getItem("gorse-token"),
           								"Tmss-From-Menu": "X"};
      $("#<?= $lv_sec; ?> #sysdocgrd_table").bootstrapTable({
				//url: "index.php?prg=<?= $vew_model . $lv_urlkey; ?>&prm_rfh=1",
				url: "?prg=<?= $vew_controller . ($lv_actcod!=''?'&act='.$lv_actcod:'') . $lv_urlkey; ?>&prm_rfh=1",
        ajaxOptions: { headers:  lv_headers },
				method: "post",
				contentType: "application/x-www-form-urlencoded", 
				queryParams: function (p) {
						return { 
              //usrtkn: localStorage.getItem("<?= $vew_sec->buscod; ?>_usrtkn"),
							vewfldord: $("#<?= $lv_sec; ?> #vewfldord").val(), 
							vewmaxrec: $("#<?= $lv_sec; ?> #vewmaxrec").val(),
							vewfldflt: $("#<?= $lv_sec; ?> #vewfldflt").text() + $("#<?= $lv_sec; ?> #vewfldfltpre").text()
						};
				}
			}).on("load-success.bs.table", function (e, data) {
				if( data["total"] > $("#<?= $lv_sec; ?> #vewmaxrec").val() ) {
					$("#<?= $lv_sec; ?> .pagination-detail .pagination-info").html( "Se encontraron m&aacute;s de <span class='badge'>"+$("#<?= $lv_sec; ?> #vewmaxrec").val()+"</span> registros. Utilice el filtro para reducir el listado." );
				} else {
					$("#<?= $lv_sec; ?> .pagination-detail .pagination-info").html( "Registros encontrados <span class='badge'>"+(data["total"]==""?"0":data["total"])+"</span>" );
				}
				if( typeof(data["sqlstm"])!="undefined" ) { $("#<?= $lv_sec; ?> #tchsrccod").text( data["sqlstm"] ); }
			}).on("load-error.bs.table", function (e, status) {
				if (status!=200) { /*se agregará a futuro un mensaje de error apropiado para este caso*/ }
			}).on("click-row.bs.table", function (e, row, $element) {
				<?php
				if( $vew_defhdr['vewselmod']!='N' ) {
					if ( isset($vew_prm['popup']) ) {
						// asigno campos
						echo 'sysdocgrd_assign( row );';
						
						// cierro modal
						echo '$.each(BootstrapDialog.dialogs, function(id, dialog){ if($(dialog.$modalBody).find("#'.$lv_sec.'").length!=0){dialog.close();} });';
						//echo '$("#'.$vew_prm['popup'].'").modal("hide");';
						
					} else if ( $vew_defhdr['vewselmod']=='1' ) {
						$lv_actcod = (isset($vew_prm['vewactcod'])?$vew_prm['vewactcod']:'03');	
						if ( $vew_sec->hasPermission(strtoupper($vew_prm['mdlcod']), strtoupper($vew_prm['prgcod']), $lv_actcod) ) {
							$lv_key = '';
							foreach ( $vew_defcol as $lv_row ) {
								if ( $lv_row['vewflddatpas']==1 ) {
									$lv_fldnme = '&prm_'.(strpos($lv_row['vewfld'],'.')?explode('.',$lv_row['vewfld'])[1]:$lv_row['vewfld']);
									$lv_key .= ($lv_key==''?'':'+'.chr(34)).'&prm_'.$lv_fldnme.'='.chr(34).'+encodeURI(row['.chr(34).$lv_row['vewfld'].chr(34).'])';
								}
							}
							$lv_key .= ($lv_key==''?'':'+'.chr(34)) . $lv_urlkey;
							echo 'tmssLink("?prg='.$vew_controller.'&act='.$lv_actcod.$lv_key.'", [{target: "_new_section"}] );';
						}
					}
				} else {
					echo 'var lv_chk = $($element).find("input[type=checkbox]");';
					echo '$(lv_chk).prop("checked",!$(lv_chk).is(":checked"));';
				}
				?>
			}).on("sort.bs.table", function (e, name, order) {
				$("#<?= $lv_sec; ?> #vewfldord").prop("value",name+(order==""?"":" "+order));
				$("#<?= $lv_sec; ?> #sysdocgrd_table").bootstrapTable("refresh");
			});
				
		});
  </script>
</section>