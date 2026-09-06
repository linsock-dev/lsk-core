<?php
	// BOTONES x DEFAULT ---------------------------------------------------
	// lista de botones que se aplicaran a todas las vistas por default
	//	posicion (pos),	permiso (per), texto (ttl), icono (icn), clase (css), id (id), accion (acc), tooltip (tooltip)
	$vew_tbl_int = array();
	$vew_tbl_int['clsL'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left tmss-mob-btn', 'acc'=>(!$vew_readonly && $lv_dockey!=''? $lv_sec.'_fnc({action: '.chr(39).'98'.chr(39).'});':'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));'));
	$vew_tbl_int['new'] = array('pos'=>'L','per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01'), 'ttl'=>$vew_lang->new, 'id'=>'','icn'=>'fas fa-file', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'01'.chr(39).'});' );
	$vew_tbl_int['modL'] = array('pos'=>'L','per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'ttl'=>$vew_lang->modify, 'id'=>'btnmodL','icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'02'.chr(39).'});' );
	$vew_tbl_int['modR'] = array('pos'=>'R','per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'ttl'=>$vew_lang->modify, 'id'=>'btnmodR','icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'02'.chr(39).'});' );
	$vew_tbl_int['cpy'] = array('pos'=>'D','per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01'), 'ttl'=>$vew_lang->copy, 'id'=>'','icn'=>'fas fa-copy', 'css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnEdit', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'001'.chr(39).'});' );
	$vew_tbl_int['delsep'] = array('pos'=>'D','per'=>($lv_dockey??'')!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04'), 'ttl'=>'', 'id'=>'','icn'=>'', 'css'=>'divider', 'acc'=>'' );
	$vew_tbl_int['del'] = array('pos'=>'D','per'=>($lv_dockey??'')!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04'), 'ttl'=>$vew_lang->delete, 'id'=>'','icn'=>'fas fa-trash-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'04'.chr(39).'});' );
	$vew_tbl_int['canc'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->cancel, 'id'=>'','icn'=>'fas fa-times', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'98'.chr(39).'});' );
	$vew_tbl_int['sveL'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->save, 'id'=>'','icn'=>'fas fa-save', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'00'.chr(39).'});' );
  $vew_tbl_int['sveR'] = array('pos'=>'R','per'=>true, 'ttl'=>$vew_lang->save, 'id'=>'','icn'=>'fas fa-save', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success tmss-mob-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'00'.chr(39).'});' );
	$vew_tbl_int['accL'] = array('pos'=>'L', 'per'=>false, 'ttl'=>$vew_lang->accounting, 'id'=>'btnacc','icn'=>'fas fa-gavel', 'css'=>'btn btn-success navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'09'.chr(39).'});');
	$vew_tbl_int['accR'] = array('pos'=>'R', 'per'=>false, 'ttl'=>$vew_lang->accounting, 'id'=>'btnacc','icn'=>'fas fa-gavel', 'css'=>'btn btn-success navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'09'.chr(39).'});');
	$vew_tbl_int['clsR'] = array('pos'=>'', 'per'=>true, 'ttl'=>$vew_lang->close, 'id'=>'btncls', 'icn'=>'far fa-times', 'css'=>'btn tmss-navbar-btn navbar-btn tmss-desk-btn', 'acc'=>(!$vew_readonly && $lv_dockey!=''? $lv_sec.'_fnc({action: '.chr(39).'98'.chr(39).'});':'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));'));
	$vew_tbl_int['frmR'] = array('pos'=>'', 'per'=>true, 'readonly'=>!$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl_int['rfrsh'] = array('pos'=>'','per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'','icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'99'.chr(39).'});' );


	// Flags x VISTA -----------------------------------------------------------
	// Oculta ciertos elementos de la barra si es necesario
	$vew_dropdown = (isset($vew_dropdown) && $vew_dropdown !== '') ? $vew_dropdown : true ;

	// BOTONES x VISTA ----------------------------------------------------------
	// botones especificos de cada vista o anulación de botones por default
	if( isset($vew_tbl) ){
		foreach($vew_tbl as $lv_key=>$lv_row){
			// boton existe y se modifica
			if(isset($vew_tbl_int[ $lv_key ])){
				foreach($lv_row as $lv_key2=>$lv_val2){
					$vew_tbl_int[$lv_key][$lv_key2] = $lv_val2;
				}
			// boton no existe y se agrega
			} else {
				$vew_tbl_int[$lv_key] = $lv_row;
			}
		}
	}
?>
<nav class="navbar-default tmss-navbar tmss-navbar-fixed hidden-print">
  <div class="container-fluid d-flex">
    <?php if( ($vew_tbl_brand??'')!='' ){ echo '<a href="#" class="navbar-brand">'.$vew_tbl_brand.'</a>'; } ?>
    <ul class="nav navbar-nav tmss-navbar-left">
			<!-- Acciones (cerrar mob, nuevo, copiar<oculto>, modificar, cancelar<oculto>, grabar) -->
			<?php
				foreach($vew_tbl_int as $lv_row) {
					if($lv_row['per'] && $lv_row['pos']=='L'){
						if( ($lv_row['htm']??'')!='' ){
							echo $lv_row['htm'];
						} else {
							echo '<a href="#" id="'.($lv_row['id']??'').'" onclick="'.($lv_row['acc']??'').'"  class="'.($lv_row['css']??'').'" title="'.(($lv_row['tooltip']??'')!=''?$lv_row['tooltip']:($lv_row['ttl']??'')).'"><i class="'.($lv_row['icn']??'').'"></i><span class="hidden-xs"> '.($lv_row['ttl']??'').'</span></a>';
						}
					}
				}
			?>
    </ul>
		<!-- Titulo -->
    <div class="tmss-navbar-title"> <?= $lv_title; ?> <span class="tmss-navbar-subtitle"> <?= ($lv_dockey != '')?'# '.$lv_dockey:''; ?> </span></div>
    <ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
			<!-- Botones adicionales -->
			<!-- cuando se necesite agregar un loop para agregar botones definidos especificamente para la vista -->
			<!-- Mobile: modificar, grabar ->
			<!-- agregar botones para mobile con clase para que se visualicen en mobile -->
			<!-- los botones que estan a la izquierda (nuevo, modificar, cancelar, grabar) deberían ocultarse en mobile -->
			<?php
				foreach($vew_tbl_int as $lv_row) {
					if($lv_row['per'] && $lv_row['pos']=='R' ){
						if( ($lv_row['htm']??'')!='' ){
							echo $lv_row['htm'];
						} else {
							echo '<a href="#" id="'.($lv_row['id']??'').'" onclick="'.($lv_row['acc']??'').'"  class="'.($lv_row['css']??'').'" title="'.(($lv_row['tooltip']??'')!=''?$lv_row['tooltip']:($lv_row['ttl']??'')).'"><i class="'.($lv_row['icn']??'').'"></i><span class="hidden-xs"> '.($lv_row['ttl']??'').'</span></a>';
						}
					}
				}
			?>
			<!-- Textos -->
			<?php include('grldattxtbtn.frm'); ?>
			<!-- Formularios -->
			<?php if($vew_tbl_int['frmR']['per']){
  			include('grldatfrmbtn.frm'); 
			}	?>
			<!-- Adjuntos -->
			<?php include('grldatuplbtn.frm'); ?>
      <!-- Workflow -->
      <?php include('grldatwrkbtn.frm'); ?>
      <!-- Dropdown -->
      <?php if($vew_dropdown) { ?>
        <div class="btn-group dropdown">
          <a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></a>
          <form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" aria-labelledby="dLabel">
            <!-- Actualizar -->
            <?php if(isset($vew_tbl_int['rfrsh'])){ ?>
							<li><a href="#" id="<?= ($vew_tbl_int['rfrsh']['id']??'') ?>" onclick="<?= $vew_tbl_int['rfrsh']['acc'] ?>" class="<?= $vew_tbl_int['rfrsh']['css'] ?>"><i class="<?= $vew_tbl_int['rfrsh']['icn'] ?>"></i><?= $vew_tbl_int['rfrsh']['ttl'] ?></a></li>
            <?php unset($vew_tbl_int['rfrsh']);}else{ ?>
            	<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmss-Opt"><i class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
            <?php } ?>
            <!-- Documento siguiente -->
            <?php include('grldocflwposnxtbtn.frm'); ?>
            <!-- Mensajes -->
            <?php include('grldatmsgbtn.frm'); ?>
            <!-- Opciones por Default -->
            <?php
              foreach($vew_tbl_int as $lv_row) {
                if($lv_row['per'] && $lv_row['pos']=='D'){
                  if($lv_row['css']=='divider'){
                    echo '<li class="divider"></li>';
                  } else {
                    echo '<li><a href="#" id="'.$lv_row['id'].'" onclick="'.$lv_row['acc'].'"  class="'.$lv_row['css'].'" title="'.$lv_row['ttl'].'"><i class="'.$lv_row['icn'].'"></i><span> '.$lv_row['ttl'].'</span></a></li>';
                  }
                }
              }
            ?>
            <li class="divider"></li>
            <!-- Estados -->
            <?php include('grldocflwstsbtn.frm'); ?>
            <!-- Info -->
            <li><a href="#" class="tmss-Opt" id="btnshowinfo"><i class="far fa-info"></i><?= $vew_lang->additionalInfo; ?></a></li>
						<!-- Configuracion -->
						<?php 
							if( is_object($vew_data->sysdoccls??null) ){
								$lv_tmp_docclscod = $vew_data->sysdoccls->sysdocclscod;
								if($lv_tmp_docclscod!='' && $vew_sec->hasPermission('SYS','DCL','03')){
									echo '<li><a href="#" class="tmss-Opt" id="btncfg" onclick="tmssLink('.chr(39).'?prg=sysdoccls&act=03&prm_sysdocclscod='.$lv_tmp_docclscod.chr(39).', [{target:'.chr(39).'_new_section'.chr(39).'}] );"><i class="far fa-gear"></i>'.$vew_lang->settings.'</a></li>';
								}
							}
						?>
            <!-- Ayuda -->
            <?php include('sysappprghlpbtn.frm'); ?>
          </form>
        </div>
      <?php } ?>
			<?php
				if($vew_tbl_int['clsR']['per']) {
					echo '<a href="#" onclick="'.$vew_tbl_int['clsR']['acc'].'" id="'.$vew_tbl_int['clsR']['id'].'" class="'.$vew_tbl_int['clsR']['css'].'" title="'.$vew_tbl_int['clsR']['ttl'].'"><i class="fas fa-times"></i></a>';
				}
			?>
    </ul>
  </div>
	<script>
		if( $("#pageTabContent > .tab-pane.active > .tab-frame.active section").length==1 ){
			$("#<?= $lv_sec; ?> #btncls").addClass("hidden");
		}
	</script>
</nav>
