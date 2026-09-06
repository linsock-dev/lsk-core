<?php
	// CAMPOS REQUERIDOS ********************************************************
	// determino si el usuario definio cambios obligatorios para la clase de documento
  $lo_frmfld = array();
	if( isset($vew_data) && isset($vew_input) ){
    if( is_object($vew_data) && is_object($vew_input) ){
      if( is_object($vew_data->sysdoccls) ){
        
        // asigno valores definidos en clase de documento (seccion -campos-)
        $lv_fldstr = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsfld');
        if($lv_fldstr!=''){ $lo_frmfld = json_decode( $lv_fldstr, true); }        
        
        // si al menos un campo tiene objeto de autorizacion, recupero info de base de datos
        $lv_objaut = false;
        foreach($lo_frmfld as $lv_row){ 
          if(isset($lv_row['fldautobj'])){
          	if(trim($lv_row['fldautobj'])!=''){$lv_objaut=true; break;} 
          }
        }
        if( $lv_objaut ){
          $lo_aut = $vew_load->model('syssecperaut');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$vew_sec->usrcod.chr(9).chr(9).
                                        '[~fltrow~]p.objtypcod'.chr(9).'='.chr(9).chr(9).$vew_data->sysdoccls->objtyp.chr(9).chr(9));
          $lo_autrs = $lo_aut->getList( $lv_prm );
        }
        
      }
    }
	}
	// fin - CAMPOS REQUERIDOS **************************************************


	// TOKEN, CLASES Y ACCION ***************************************************
	// los siguientes valores generalmente permanecen sin cambios
	$lv_sec = $vew_token;
  $lv_always_disabled = array( 'atrval'=>array('css'=>'form-control tmssAlwaysDisabled') );
	$lv_always_enabled = array( 'atrval'=>array('css'=>'form-control tmssAlwaysEnabled') );
  $lv_default = array( 'atrval'=>array('css'=>'form-control') );
	// acción por default
	if ( !isset($vew_actcod) ) { $vew_actcod = '03'; }
	$vew_readonly = ($vew_actcod=='01'||$vew_actcod=='02'?false:true);
	// fin - TOKEN, CLASES Y ACCION *********************************************


	$lv_col222222 = array('cols'=>array(2, 2, 2, 2, 2, 2),'size'=>'md'); 
	$lv_col22323 = array('cols'=>array(2, 2, 3, 2, 3),'size'=>'md'); 
	$lv_col2624 = array('cols'=>array(2, 6, 2, 4),'size'=>'md');
	$lv_col4332 = array('cols'=>array(4, 3, 3, 2),'size'=>'md');
	$lv_col2424 = array('cols'=>array(2, 4, 2, 4),'size'=>'md');
	$lv_col4242 = array('cols'=>array(4, 2, 4, 2),'size'=>'md');
	$lv_col354 = array('cols'=>array(3, 5, 4),'size'=>'md');
	$lv_col552 = array('cols'=>array(5, 5, 2),'size'=>'md');
	$lv_col264 = array('cols'=>array(2, 6, 4),'size'=>'md');
	$lv_col255 = array('cols'=>array(2, 5, 5),'size'=>'md');
	$lv_col273 = array('cols'=>array(2, 7, 3),'size'=>'md');
	$lv_col237 = array('cols'=>array(2, 3, 7),'size'=>'md');
	$lv_col233 = array('cols'=>array(2, 3, 3),'size'=>'md');
	$lv_col291 = array('cols'=>array(2, 9, 1),'size'=>'md');
	$lv_col0111 = array('cols'=>array(1, 11),'size'=>'md');
	$lv_col210 = array('cols'=>array(2, 10),'size'=>'md');
	$lv_col39 = array('cols'=>array(3, 9),'size'=>'md');
	$lv_col48 = array('cols'=>array(4, 8),'size'=>'md');
	$lv_col57 = array('cols'=>array(5, 7),'size'=>'md');
	$lv_col66 = array('cols'=>array(6, 6),'size'=>'md');
	$lv_col75 = array('cols'=>array(7, 5),'size'=>'md');
	$lv_col84 = array('cols'=>array(8, 4),'size'=>'md');
	$lv_col93 = array('cols'=>array(9, 3),'size'=>'md');
	$lv_col102 = array('cols'=>array(10, 2),'size'=>'md');
	$lv_col111 = array('cols'=>array(11, 1),'size'=>'md');
  $lv_col1212 = array('cols'=>array(12, 12),'size'=>'md');
	$lv_col12 = array('cols'=>array(12),'size'=>'md');
	$lv_col244 = array('cols'=>array(2, 4, 4),'size'=>'md');
	$lv_col444 = array('cols'=>array(4, 4, 4),'size'=>'md');
	$lv_col345 = array('cols'=>array(3, 4, 5),'size'=>'md');
	$lv_col2622 = array('cols'=>array(2, 6, 2, 2),'size'=>'md');

	$lv_colsm4242 = array('cols'=>array(4, 2, 4, 2),'size'=>'sm');
	$lv_colsm13143 = array('cols'=>array(1, 3, 1, 4, 3),'size'=>'sm');
	$lv_colsm552 = array('cols'=>array(5, 5, 2),'size'=>'sm');
	$lv_colsm255 = array('cols'=>array(2, 5, 5),'size'=>'sm');
	$lv_colsm237 = array('cols'=>array(2, 3, 7),'size'=>'sm');
	$lv_colsm228 = array('cols'=>array(2, 2, 8),'size'=>'sm');
	$lv_colsm273 = array('cols'=>array(2, 7, 3),'size'=>'sm');
	$lv_colsm354 = array('cols'=>array(3, 5, 4),'size'=>'sm');
	$lv_colsm363 = array('cols'=>array(3, 6, 3),'size'=>'sm');
	$lv_colsm282 = array('cols'=>array(2, 8, 2),'size'=>'sm');
	$lv_colsm291 = array('cols'=>array(2, 9, 1),'size'=>'sm');
	$lv_colsm0111 = array('cols'=>array(1, 11),'size'=>'sm');
	$lv_colsm210 = array('cols'=>array(2, 10),'size'=>'sm'); 
	$lv_colsm39 = array('cols'=>array(3, 9),'size'=>'sm');
	$lv_colsm48 = array('cols'=>array(4, 8),'size'=>'sm');
	$lv_colsm57 = array('cols'=>array(5, 7),'size'=>'sm');
	$lv_colsm66 = array('cols'=>array(6, 6),'size'=>'sm');
	$lv_colsm75 = array('cols'=>array(7, 5),'size'=>'sm');
	$lv_colsm84 = array('cols'=>array(8, 4),'size'=>'sm');
	$lv_colsm93 = array('cols'=>array(9, 3),'size'=>'sm');
	$lv_colsm102 = array('cols'=>array(10, 2),'size'=>'sm');
	$lv_colsm111 = array('cols'=>array(11, 1),'size'=>'sm');
	$lv_colsm2433 = array('cols'=>array(2, 4, 3, 3),'size'=>'sm');
	$lv_colsm2442 = array('cols'=>array(2, 4, 4, 2),'size'=>'sm');
	$lv_colsm2424 = array('cols'=>array(2, 4, 2, 4),'size'=>'sm');
	$lv_colsm2415 = array('cols'=>array(2, 4, 1, 5),'size'=>'sm');
	$lv_colsm1443 = array('cols'=>array(1, 4, 4, 3),'size'=>'sm');
	$lv_colsm13242 = array('cols'=>array(1, 3, 2, 4, 2),'size'=>'sm');
	$lv_colsm525 = array('cols'=>array(5, 2, 5),'size'=>'sm');
	$lv_colsm12 = array('cols'=>array(12),'size'=>'sm');
	$lv_colsm244 = array('cols'=>array(2, 4, 4),'size'=>'sm');
	$lv_colsm444 = array('cols'=>array(4, 4, 4),'size'=>'sm');
	$lv_colsm433 = array('cols'=>array(4, 3, 3), 'size'=>'sm');
	$lv_colsm4332 = array('cols'=>array(4, 3, 3, 2), 'size'=>'sm');
	$lv_colsm435 = array('cols'=>array(4, 3, 5), 'size'=>'sm');
	$lv_colsm345 = array('cols'=>array(3, 4, 5),'size'=>'sm');
	$lv_colsm246 = array('cols'=>array(2, 4, 6),'size'=>'sm');
	
	// Col XS
	$lv_colxs9393 = array('cols'=>array(9, 3, 9, 3), 'size'=>'xs');
	$lv_colxs1244 = array('cols'=>array(12, 4, 4), 'size'=>'xs');
	$lv_colxs1266 = array('cols'=>array(12, 6, 6), 'size'=>'xs');
	$lv_colxs1284 = array('cols'=>array(12, 8, 4), 'size'=>'xs');
	$lv_colxs48 = array('cols'=>array(4, 8),'size'=>'xs');
	$lv_colxs210 = array('cols'=>array(2, 10),'size'=>'xs');
	$lv_colxs39 = array('cols'=>array(3, 9),'size'=>'xs');
	$lv_colxs2424 = array('cols'=>array(2, 4, 2, 4),'size'=>'xs');
	$lv_colxs1255 = array('cols'=>array(12, 5, 5), 'size'=>'xs');
	$lv_colxs12552 = array('cols'=>array(12, 5, 5, 2), 'size'=>'xs');
	$lv_colxs1257 = array('cols'=>array(12, 5, 7), 'size'=>'xs');
	$lv_colxs345 = array('cols'=>array(3, 4, 5),'size'=>'xs');
	$lv_colxs66 = array('cols'=>array(6, 6),'size'=>'xs');
	$lv_colxs552 = array('cols'=>array(5, 5, 2),'size'=>'xs');
	$lv_colxs246 = array('cols'=>array(2, 4, 6),'size'=>'xs');


	// vew_boot( array("cols"=>"2,7,3", "title"=>, "input"=> ) );
	function vew_boot( $lp_prop=array(), $lp_data=array() ) {
		$lv_ret = '';

    $lv_hidden=false;
    $lv_fld=0;
    $lv_fldhde=0;
    foreach($lp_data as $lv_key=>$lv_val){
      if(substr($lv_key,0,5)=='input'){ $lv_fld++; }
      if(substr($lv_key,0,5)=='input' && stripos($lv_val,'tmss-input-hidden')!=false ){ $lv_fldhde++; }
    }
    if($lv_fld==$lv_fldhde){ $lv_hidden=true;}
    
		// C O L S
		if ( (isset($lp_prop['cols']) || is_array($lp_prop)) && !isset($lp_prop['style']) ) {

      // dado que puede ser una variable o un array con variables, incluyo 
      $lp_prop = ( isset($lp_prop['cols']) ? array($lp_prop) : $lp_prop );

      $lv_inx = 0;
			$lv_ret = '<div class="form-group tmss-form-group '.($lv_hidden?'hidden':'').'">';
			foreach( $lp_data as $lv_key=>$lv_val ) {
        
        // armo el string de estilos para la columna
        $lv_colstr = '';
        
        foreach($lp_prop as $lv_cols) {
          // si hay varias columnas determino el tamaño, sino uso siempre el mismo [inx=0]
          // default (si no esta definido, sm )
        	$lv_colstr .= ' col-'.($lv_cols['size']??'sm').'-'.( count($lv_cols['cols'])>$lv_inx ? $lv_cols['cols'][$lv_inx] : $lv_cols['cols'][0] );
      	}
      
        if(substr($lv_key,0,5)=='label') {
          $lv_ret .= '<label class="'.$lv_colstr.' control-label text-nowrap">'.$lv_val.'</label>';
        } else if(substr($lv_key,0,5)=='input') {
          $lv_ret .= '<div class="'.$lv_colstr.'">'.$lv_val.'</div>';
        }
				$lv_inx++;
			}
			$lv_ret .= '</div>';

		// S T Y L E
		} else if (isset($lp_prop['style'])) {

			$lv_readonly= ($lp_prop['readonly']??false);
			$lv_input   = ($lp_data['input']??'');
			$lv_custom  = ($lp_data['custom']??'');
			$lv_id 			= ($lp_data['id']??'');
			switch ($lp_prop['style']) {
				case 'nothing':
					$lv_ret = $lv_input;
					break;
				case 'custom':
					$lv_ret = ($lv_readonly==true ? $lv_input : 
                     '<div class="input-group">'.
											$lv_input .
											$lv_custom .
										'</div>'
                    );
					break;
				case 'color':
					$lv_ret = '<div class="input-group">'.
											$lv_input .
											'<span class="input-group-addon"><i></i></span>'.
										'</div>';
					break;
				case 'search':
					$lv_ret = ($lv_readonly==true ? $lv_input :
									'<div class="input-group">'.
										$lv_input . 
										'<span class="input-group-btn"><a href="#" class="btn btn-default tmssInputBtn" tabindex="-1">&nbsp;<i class="far fa-magnifying-glass"></i></a></span>'.
									'</div>'
								);
					break;
				case 'phone':
					$lv_ret = ($lv_readonly==false ? $lv_input :
									'<div class="input-group">'.
										$lv_input .
										'<span class="input-group-btn">'.
											'<a href="#" onclick="window.location.href='.chr(39).'callto:'.chr(39).'+$('.chr(39).$lv_id.chr(39).').prop('.chr(39).'value'.chr(39).');" class="btn btn-default" type="button"  tabindex="-1">&nbsp;<i class="far fa-phone"></i></a>'.
										'</span>'.
									'</div>'
								);
					break;
				case 'webpage':
					$lv_ret = ($lv_readonly==false ? $lv_input :
									'<div class="input-group">'.
										$lv_input .
										'<span class="input-group-btn">'.
											'<a href="#" onclick="window.open( $('.chr(39).$lv_id.chr(39).').prop('.chr(39).'value'.chr(39).'), '.chr(39).'_blank'.chr(39).' );" class="btn btn-default" type="button" tabindex="-1">&nbsp;<i class="far fa-globe"></i></a>'.
										'</span>'.
									'</div>'
								);
					break;

				case 'email':
					$lv_ret = ($lv_readonly==false ? $lv_input :
									'<div class="input-group">'.
										$lv_input .
										'<span class="input-group-btn">'.
											'<a href="#" onclick="window.location.href='.chr(39).'mailto:'.chr(39).'+$('.chr(39).$lv_id.chr(39).').prop('.chr(39).'value'.chr(39).');" class="btn btn-default" type="button" tabindex="-1">&nbsp;<i class="far fa-envelope"></i></a>'.
										'</span>'.
									'</div>'
								);
					break;

				case 'map':
					$lv_ret = ($lv_readonly==false ? $lv_input :
									'<div class="input-group">'.
										$lv_input .
										'<span class="input-group-btn">'.
											'<a href="#" onclick="window.open( '.chr(39).'http://www.google.com/maps/search/?api=1&query='.$lp_prop['adrmapgeo'].chr(39).', '.chr(39).'_blank'.chr(39).' );" class="btn btn-default" type="button" tabindex="-1">&nbsp;<i class="far fa-map-location"></i></a>'.
										'</span>'.
									'</div>'
								);
					break;

			} // fin SWITCH
		} else {  // Usar más de una configuración de columnas (desktop y mobile)
      $lv_tot = count($lp_prop);
      $lv_cols = array();
      $lv_sizes = array();
      foreach($lp_prop as $lv_key=>$lv_row){
        $lv_cols[$lv_key] = $lv_row['cols'];
        $lv_sizes[$lv_key] = ($lv_row['size']??'sm');
      }
			$lv_inx = 0;
			$lv_ret = '<div class="form-group  tmss-form-group">';
			foreach( $lp_data as $lv_key2=>$lv_val ) {
        $lv_class = '';
        for ($i = 0; $i <= $lv_tot-1; $i++) {
          $lv_class .= 'col-'.$lv_sizes[$i].'-'.$lv_cols[$i][$lv_inx].' ';
        }
        if(substr($lv_key2,0,5)=='label') {
          $lv_ret .= '<label class="'.$lv_class.' control-label text-nowrap">'.$lv_val.'</label>';
        } else if(substr($lv_key2,0,5)=='input') {
          $lv_ret .= '<div class="'.$lv_class.'">'.$lv_val.'</div>';
        }
				$lv_inx++;
			}
			$lv_ret .= '</div>';
      
    } 
    
		return $lv_ret;
	} // fin VEW_BOOT
	
	
	
	// --------------------------------------------------------------------------
	// G E T    H T M L
	// devuelve string con codificacion html de un campo en base a su definicion
	// parametros de entrada:
	// 		id: nombre del campo
	// 		domain: definicion del campo
	//		defval: valor por defecto
	//		prm: array de parametros adicionales
	// --------------------------------------------------------------------------
	$GLOBALS['vew_input'] = '';
	if( isset($vew_input) ) {	$GLOBALS['vew_input'] = (is_object($vew_input) ? $vew_input : '' ); }
	$GLOBALS['vew_db'] = '';
	if( isset($vew_db) ) {	$GLOBALS['vew_db'] = (is_object($vew_db) ? $vew_db : '' ); }
	$GLOBALS['vew_sec'] = '';
	if( isset($vew_sec) ) {	$GLOBALS['vew_sec'] = (is_object($vew_sec) ? $vew_sec : '' ); }
  $GLOBALS['frm_fields'] = array();
	if( isset($lo_frmfld) ) {	$GLOBALS['frm_fields'] = $lo_frmfld; }
  $GLOBALS['frm_auth'] = array();
	if( isset($lo_autrs) ) {	$GLOBALS['frm_auth'] = $lo_autrs; }
  $GLOBALS['vew_readonly'] = $vew_readonly;
  $GLOBALS['vew_actcod'] = $vew_actcod;
  function gethtml( $lp_id, $lp_domain, $lp_defval, $lp_prm=array() ) {
  	
		$lo_input = $GLOBALS['vew_input'];
		$lo_db = $GLOBALS['vew_db'];
		$lo_sec = $GLOBALS['vew_sec'];
    $lo_frmfld = $GLOBALS['frm_fields'];
    $lo_autrs = $GLOBALS['frm_auth'];
    $vew_readonly = $GLOBALS['vew_readonly'];
    $vew_actcod = $GLOBALS['vew_actcod'];
		    
		if( is_array($lp_domain) ) {
			$lo_fld = array('sysfldinptyp'=>'SELECT','sysfldbtnjs'=>$lp_domain);
		} else {
			$lo_fld = $lo_input->GetField($lp_domain);
			if ( count($lo_fld)==0 ) {
				return '<span class="label label-warning" title="no definition found">['.$lp_domain.']</span>';
			}
		}
        
    // se determinan valores segun cofiguracion de clase de doccumento
    $lv_disabled = false;
    $lv_required = false;
    $lv_hidden = ($lp_domain=='hidden'?true:false);
    foreach($lo_frmfld as $lv_row){
      if( $lp_id==trim($lv_row['fldcod']) ){
        if($vew_actcod=='01' && trim( (gettype($lp_defval)=='object'?$lp_defval->format('d-m-Y H:i:s'):$lp_defval) )=='' && isset($lv_row['flddefval']) ){
					$lv_str = strtoupper($lv_row['flddefval']);
          if($lv_str=='@@HOY'){	/* FALTA: utilizar el analizador de formulas */
						$lp_defval = date('d/m/Y');
					} else if($lv_str=='@@USERNAME'){
            $lp_defval = $lo_sec->usrcod;
          } else {
						$lp_defval = $lv_row['flddefval'];
					}
				}
        if( trim($lv_row['flddis']??'')!='' ){ $lv_disabled = true; }
        if( trim($lv_row['fldreq']??'')!='' ){ $lv_required = true; }
        if( trim($lv_row['fldhde']??'')!='' ){ $lv_hidden = true; }
        if( trim($lv_row['fldautobj']??'')!='' && !$lv_disabled ){
          $lv_found = false;
          foreach($lo_autrs as $lv_rowaut){
            if(trim($lv_rowaut['autcod'])==trim($lv_row['fldautobj'])){ $lv_found=true; break;} 
          }
          if(!$lv_found){ $lv_disabled = true; }
        }
      }
    }
		if(is_array($lo_input->getReqFields())){
			if(in_array(strtolower($lp_id), $lo_input->getReqFields()) || $lv_required ) { $lv_required = true; }
		}
    
		// i.e.: class, placeholder, etc
		if( !isset($lp_prm['atrval']) ) { $lp_prm['atrval']=array(); }
    if( !isset($lp_prm['atrval']['css']) ){ $lp_prm['atrval']['css']=''; }
    if( $lv_disabled && stripos($lp_prm['atrval']['css'],'tmssAlwaysDisabled tmssDisabledByDocument')===false ) { $lp_prm['atrval']['css'].=' tmssAlwaysDisabled tmssDisabledByDocument'; }
    if( $lv_required && stripos($lp_prm['atrval']['css'],'tmssInputRequired')===false ) { $lp_prm['atrval']['css'].=' tmssInputRequired'; }
    if( $lv_hidden && stripos($lp_prm['atrval']['css'],'hidden')===false ) { $lp_prm['atrval']['css'].=' hidden tmss-input-hidden'; }
		$lv_atr = ' class="'.$lp_prm['atrval']['css'].'"';

		// ATRIBUTOS. se determinan atributos de campo
		$lv_min = ($lp_prm['atrval']['min']??'0');
		$lv_max = ($lp_prm['atrval']['max']??'');
    $lv_outsze = ($lv_max==''?intval($lo_fld['sysfldoutsze']??'0'):0);
		if( $lv_max=='' && intval($lo_fld['sysfldmaxlng']??'')>0 ) {
      $lv_maxlng = intval($lo_fld['sysfldmaxlng']);
			$lv_max = str_repeat('9', ($lv_maxlng<$lv_outsze ? 1 : $lv_maxlng-$lv_outsze) );
      $lv_max .= ($lv_maxlng<$lv_outsze ? '' : '.'.str_repeat('9',$lv_outsze));
		}
		$lv_step = ($lp_prm['atrval']['step'] ?? (($lo_fld['sysfldoutsze']??'')==''?'any':(intval($lo_fld['sysfldoutsze'])==0?'1':'0.'.str_repeat('0',intval($lo_fld['sysfldoutsze'])-1).'1')) );
		$lv_maxlength = ($lp_prm['atrval']['maxlength']??$lo_fld['sysfldmaxlng']??'');
		$lv_placeholder = ($lp_prm['atrval']['placeholder']??'');
		$lv_format = ($lp_prm['atrval']['format']??'dd/mm/yyyy');
		$lv_start_date = ($lp_prm['atrval']['start-date']??'');
		$lv_end_date = ($lp_prm['atrval']['end-date']??'');
		$lv_style = ($lp_prm['atrval']['style']??'');
		$lv_css = ($lp_prm['atrval']['css']??'');
		$lv_rows = ($lp_prm['atrval']['rows']??intval( ($lo_fld['sysfldmaxlng']??0) / (($lo_fld['sysfldoutsze']??0)==0?1:$lo_fld['sysfldoutsze'])) );
		$lv_multiple = (($lp_prm['atrval']['multiple']??'')!=''?'multiple':'');
		
		$lv_data_atr = '';
		if( is_array($lp_prm['atrval']['data']??array()) ){
			foreach( $lp_prm['atrval']['data']??array() as $lv_key=>$lv_val ){
				$lv_data_atr .= ' data-'.$lv_key.'="'.$lv_val.'"';
			}
		}
		
		// ARMADO. se realiza el armado de cada campo
		switch( strtoupper($lo_fld['sysfldinptyp']??'') ) {
			case 'HIDDEN':
				$lv_sbuffer = '<input type="hidden" id="'.$lp_id.'" name="'.$lp_id.'" value="'.$lp_defval.'" '.$lv_data_atr.'>';
				break;
			
			case 'LABEL':
				$lv_sbuffer = '<span id="'.$lp_id.'" name="'.$lp_id.'" class="'.$lv_css.'" style="'.$lv_style.'" '.$lv_data_atr.'>'.$lp_defval.'</span>';
				break;
			
			case 'CHECKBOX':
				//$lv_sbuffer = '<input type="checkbox" data-toggle="toggle" id="'.$lp_id.'" name="'.$lp_id.'"'.($lp_defval!=''?' checked ':'').'>';	
       	$lv_onchange = ' onchange="if(this.readOnly){ this.checked=!this.checked; } (this.checked ? this.value=1 : this.value=0);" ';
				$lv_sbuffer = '<label class="toggle-switchy" data-size="xs" data-style="rounded" data-text="false">'
          							.'<input type="checkbox" id="'.$lp_id.'" name="'.$lp_id.'" '.($lp_defval=='1' || $lp_defval==='on'?' value="1" checked ':' value="0" ').' '.$lv_atr.$lv_onchange.' '.$lv_data_atr.'>'
          							.'<span class="toggle"><span class="switch"></span></span>'
          						.'</label>';
				break;
			
			case 'TEXT': case 'PASSWORD': case 'PHONE': case 'EMAIL': case 'WEBPAGE': case 'AUTOCOMPLETE': case 'FILE':
				$lv_sbuffer = '<input type="'.($lo_fld['sysfldinptyp']=='FILE'?'FILE': ($lo_fld['sysfldinptyp']=='PHONE'?'TEXT': ($lo_fld['sysfldinptyp']=='AUTOCOMPLETE'?'TEXT': ($lo_fld['sysfldinptyp']=='WEBPAGE'?'URL': $lo_fld['sysfldinptyp'])))).'"'
											.' id="'.$lp_id.'"'
											.' name="'.$lp_id.'"'
											.' value="'.( gettype($lp_defval)=='object' ? $lp_defval->format('d-m-Y H:i:s') : str_ireplace('"','&quot;',($lp_defval==null?'':$lp_defval)) ).'"'
											.' maxlength="'.$lv_maxlength.'"'
											.' placeholder="'.$lv_placeholder.'"'
											.($lo_fld['sysfldinptyp']=='AUTOCOMPLETE'?'autocomplete="off" ':'')
											.' class="'.$lv_css.'" '.$lv_data_atr.'>';
				break;
			
			case 'NUMBER':
				$lv_maxlength = strlen($lv_max);
				$lv_sbuffer = '<input type="NUMBER" id="'.$lp_id.'" name="'.$lp_id.'"'
												.' value="'.($lp_defval==''?'':number_format($lp_defval,intval($lo_fld['sysfldoutsze']),($lo_fld['sysfldoutsze']>0?'.':''),'')).'"'
												.' maxlength="'.$lv_maxlength.'"'
												.' min="'.$lv_min.'"'
												.' max="'.$lv_max.'"'
												.' step="'.$lv_step.'" '
												.' placeholder="'.$lv_placeholder.'" '
												.' class="'.$lv_css.'" '.$lv_data_atr.'>';
				break;
			
			case 'DATE':
				//['data-date-start-date']
				//['data-date-end-date']
				$lv_sbuffer = '<div class="input-group date" '.
												($lv_start_date!=''?'data-date-start-date="'.$lv_start_date.'"':'').
												($lv_end_date!=''?'data-date-end-date="'.$lv_end_date.'"':'').
												' data-date-format="'.$lv_format.'" data-date-autoclose="true" data-date-today-highlight="true" data-date-today-btn="true" data-date-show-on-focus="false" data-date-language="es" data-date-enable-on-readonly="false" data-date-clear-btn="true" data-provide="datepicker" data-date-week-start="0">';
				$lv_sbuffer .= '<input type="TEXT" autocomplete="off" id="'.$lp_id.'" name="'.$lp_id.'"'
											.' value="'.( gettype($lp_defval)=="object"?$lp_defval->format("d/m/Y"):$lp_defval).'"'
											.' maxlength="'.strlen($lv_format).'"'
											.' onblur="$(this).prop('.chr(39).'value'.chr(39).',formatdate(this));"'
											.' placeholder="'.$lv_placeholder.'" '
											.' class="'.$lv_css.'" '.$lv_data_atr.'>';
				$lv_sbuffer .= '<span class="input-group-addon"><i class="far fa-calendar"></i></span>';
				$lv_sbuffer .= '</div>';
				break;
			
			case 'TIME':
				$lv_sbuffer='<div class="input-group date">'
											.'<input type="TEXT" id="'.$lp_id.'" name="'.$lp_id.'"'
												.' value="'.( gettype($lp_defval)=="object"?$lp_defval->format("H:i"):$lp_defval).'"'
												.' maxlength="'.$lv_maxlength.'"'
												.' onblur="$(this).prop('.chr(39).'value'.chr(39).',formattime(this));"'
												.' class="'.$lv_css.'" '.$lv_data_atr.'>'
											.'<span class="input-group-addon"><i class="far fa-clock"></i></span>'
										.'</div>';
				break;
				
			case 'TEXTAREA':
				$lv_sbuffer='<textarea id="'.$lp_id.'" name="'.$lp_id.'" '
											.' rows="'.$lv_rows.'" '
											.' class="'.$lv_css.'" '.$lv_data_atr.'>'
												.($lp_defval)
										.'</textarea>';
				break;
			
			case 'SELECT':
				$lv_srcarr = array();
				if(is_array($lo_fld['sysfldbtnjs'])){
					$lv_srcarr = $lo_fld['sysfldbtnjs'];
				} else {					
					// current: {'code':'value'},{'code':'value'}
					$lv_srcarrdb = explode(',',strtolower(trim($lo_fld['sysfldbtnjs'])));
					foreach( $lv_srcarrdb as $lv_row ) {
						$lv_fldcod = explode("'",explode(":",$lv_row)[0])[1];
						$lv_fldtxt = strtoupper(explode("'",explode(":",$lv_row)[1])[1]);
						$lv_srcarr[$lv_fldcod] = $lv_fldtxt;
					}
				}
				$lv_defval = strtolower($lp_defval===null?'':$lp_defval);
				if(stripos($lv_defval,"|")!=false){
					$lv_defval_arr = explode("|",$lv_defval);
				} else {
					$lv_defval_arr = array($lv_defval);
				}
				$lv_sbuffer = '<select id="'.$lp_id.'" name="'.$lp_id.'" class="'.$lv_css.'" '.$lv_multiple.' '.$lv_data_atr.'>';
				foreach( $lv_srcarr as $lv_key=>$lv_val ) {
					//$lv_sbuffer .= '<option value="'.$lv_key.'"'.(strtolower($lv_key)==strtolower($lv_defval)?' SELECTED':'').'>'.utf8_encode( ($lv_val==null?'':$lv_val) ).'</option>';
					$lv_sbuffer .= '<option value="'.$lv_key.'"'.( in_array(strtolower($lv_key), $lv_defval_arr)?' SELECTED':'').'>'.($lv_val==null?'':$lv_val).'</option>';
				}
				$lv_sbuffer .= '</select>';
				//$lv_sbuffer .= '<script>$("#'.$lp_id.'").select2();</script>';
				break;
			
			case 'SELECT_CUS': case 'SELECT_SYS':
				// current: {'lngcod':'lngtxt':'SYS_LNG_DEF ('08','<application>usrcod</application>')'}
				$lv_srcarr = explode(':',strtolower(trim($lo_fld['sysfldbtnjs'])));
				$lv_fldcod = substr(trim($lv_srcarr[0]),2,strlen(trim($lv_srcarr[0]))-3);
				$lv_fldtxt = substr(trim($lv_srcarr[1]),1,strlen(trim($lv_srcarr[1]))-2);
				$lv_srcsql = substr(trim($lv_srcarr[2]),1,strlen(trim($lv_srcarr[2]))-3);
				$lv_srcsqlfld = explode(',',explode(')',explode('(',$lv_srcsql)[1])[0]);
				$lv_prm = array();
				$lv_sqlprm = '';
				foreach( $lv_srcsqlfld as $lv_row ) {
					$lv_row = trim($lv_row);
					if ( $lv_row=='null' ) {
						$lv_sqlprm .= ($lv_sqlprm==''?'':',').'null';
					} else {
						$lv_sqlprm .= ($lv_sqlprm==''?'':',').'?';
						$lv_row = str_ireplace( '<application>buscod</application>', $lo_sec->buscod, $lv_row );
						$lv_row = str_ireplace( '<application>usrcod</application>', $lo_sec->usrcod, $lv_row );
						$lv_prm[] = ( substr($lv_row,0,1)==chr(39) ? explode(chr(39),$lv_row)[1] : $lv_row );
					}
				}
				$lv_ssql = explode('(',$lv_srcsql)[0] . '(' . $lv_sqlprm . ')';
				// future:  <fldcod>lngcod</fldcod><fldtxt>lngtxt</fldtxt><fldsrc>SYS_LNG_DEF ('08','<application>usrcod</application>')</fldsrc>
				// to do
				$lo_rs = $lo_db->sqlstoredprocedure( $lv_ssql, $lv_prm, ($lo_fld['sysfldinptyp']=='SELECT_SYS'?0:1) );
				$lv_sbuffer = '<select id="'.$lp_id.'" name="'.$lp_id.'" class="'.$lv_css.'" '.$lv_data_atr.'>'
											.'<option value=""></option>';
					foreach( $lo_rs as $lv_row ) {
						$lv_fldsrc = strtolower($lv_row[$lv_fldcod]==null?'':$lv_row[$lv_fldcod]);

						$lv_defval = strtolower($lp_defval==null?'':$lp_defval);
						if(stripos($lv_defval,"|")!=false){
							$lv_defval_arr = explode("|",$lv_defval);
						} else {
							$lv_defval_arr = array($lv_defval);
						}

						//$lv_sbuffer .= '<option value="'.$lv_row[$lv_fldcod].'"'.($lv_fldsrc==$lv_defval?' SELECTED':'').'>'.strtoupper($lv_row[$lv_fldtxt]).'</option>';
						$lv_sbuffer .= '<option value="'.$lv_row[$lv_fldcod].'"'.(in_array($lv_fldsrc,$lv_defval_arr,true)?' SELECTED':'').'>'.strtoupper($lv_row[$lv_fldtxt]).'</option>';
					}
				$lv_sbuffer .= '</select>';
				//$lv_sbuffer .= '<script>$("#'.$lp_id.'").select2();</script>';
				break;
			
			case 'COLOR':
				$lv_sbuffer='<input type="text" id="'.$lp_id.'" name="'.$lp_id.'" value="'.$lp_defval.'" class="'.$lv_css.'" '.$lv_data_atr.'><script>tmssLoadScript("minicolors",function(){$("#'.$lp_id.'").minicolors({theme: "bootstrap", letterCase:"uppercase", change:function(hex) {if(!hex) return; $("#'.$lp_id.' h3 small").html(hex);} }); });</script>';
				break;
			
			default:
				$lv_sbuffer = '<span class="label label-danger" title="invalid field type: '.($lo_fld['sysfldinptyp']??'').'">['.$lp_domain.']</span>';
				break;
		}		
		return $lv_sbuffer;
	}
?>