<?php
final class crmcnt extends tmssAction2 {
  function initialize(){ $this->ID = 'crmcntcod'; }
  
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		
		// cargo modelo anterior
		$lo_mdlprv = $this->co_reg->load->model('crmcnt');
		if( ($lp_dat['crmcntcod']??'')!='' ){
			$lo_mdlprv->load( array('crmcntcod'=>$lp_dat['crmcntcod']), false );
		}
		$lp_dat['crmcntcmt'] = $lp_dat['crmcntcmt'] ?? '';
    
    $lo_mdlprv->crmcntcmtdte = $this->data['crmcntcmtdte'] ?? '';
		$lo_mdlprv->crmcntcmt = $this->data['crmcntcmt'] ?? '';
		$lo_mdlprv->crmcntatr = $lo_mdlprv->crmcntatr ?? '';
    
		$lv_duedte = ($lp_dat['crmcntduedte']??'');
		$lv_duedte = (is_a($lv_duedte,'DateTime')?date_format($lv_duedte,'d/m/Y'):$lv_duedte);
    $lp_dat['crmcntatr']='<esttme>'.($lp_dat['crmcntesttme'] ?? $this->co_reg->document->getTagValue($lo_mdlprv->crmcntatr , 'esttme') ?? '').'</esttme>'.
      									 '<prg>'.($lp_dat['crmcntprg'] ?? $this->co_reg->document->getTagValue($lo_mdlprv->crmcntatr , 'prg') ?? '').'</prg>'.
      									 '<tmeduedte>'.($lp_dat['crmcntatrtmeduedte'] ?? $this->co_reg->document->getTagValue($lo_mdlprv->crmcntatr , 'tmeduedte') ?? '').'</tmeduedte>'.
      									 '<duedte>'.$lv_duedte.'</duedte>';  	
		// grabo cambios
    $lv_ret = parent::save($lp_dat,$lp_authCheck);

    // si falla, termina aca
    if( !$lv_ret ){ return false; }
    
		// cargo modelo actual
    $this->load( array('crmcntcod'=>$this->crmcntcod), false );
    
		//cargo el comentario para grabar el cambio
    if( ($lp_dat['crmcntcmt']??'')!='' ){
    	$this->crmcntcmt=$lp_dat['crmcntcmt'];
      $this->crmcntcmtdte=$lp_dat['crmcntcmtdte'];
      $this->crmcntmtvcod=$lp_dat['crmcntmtvcod'];
    }
    
		// preparo log de cambios
    $lv_act = ( isset($lp_dat[$this->ID]) && !empty($lp_dat[$this->ID]) ? ($lp_authCheck?'02':'12') : ($lp_authCheck?'01':'11'));
		$lv_chgtxt = '';
    if ( $lv_act=='02' || $lv_act=='12' ) {		
    	$lv_chgtxt .= '<atr><nme>Tipo</nme><old>'.($lo_mdlprv->crmcnttyptxt).'</old><new>'.utf8_decode($this->crmcnttyptxt).'</new></atr>';
			$lv_chgtxt .= '<atr><nme>Motivo</nme><old>'.( $lo_mdlprv->crmcntmtvtxt).'</old><new>'.utf8_decode($this->crmcntmtvtxt).'</new></atr>';
			$lv_chgtxt .= '<atr><nme>Prioridad</nme><old>'.($lo_mdlprv->crmcntprttxt).'</old><new>'.utf8_decode($this->crmcntprttxt).'</new></atr>';
			$lv_chgtxt .= '<atr><nme>Estado</nme><old>'.($lo_mdlprv->crmcntststxt).'</old><new>'.utf8_decode($this->crmcntststxt).'</new></atr>';
			$lv_chgtxt .= '<atr><nme>Titulo</nme><old>'.($lo_mdlprv->crmcnttxt).'</old><new>'.utf8_decode($this->crmcnttxt).'</new></atr>';
			$lv_chgtxt .= '<atr><nme>Comentarios</nme><old></old><new>'.($this->crmcntcmt).'</new></atr>';			
			$lv_chgtxt .= '<atr><nme>Usuario</nme><old>'.($lo_mdlprv->usrcod).'</old><new>'.utf8_decode($this->usrcod).'</new></atr>';
      $lv_chgtxt .= '<atr><nme>Solicitante</nme><old>'.($lo_mdlprv->crmcntsrctxt).'</old><new>'.utf8_decode($this->crmcntsrctxt).'</new></atr>';
      $lv_chgtxt .= '<atr><nme>Contacto</nme><old>'.($lo_mdlprv->crmcntsrccnttxt).'</old><new>'.utf8_decode($this->crmcntsrccnttxt).'</new></atr>';
    }

    // Grabado log de cambios
		if( $lv_chgtxt!='' ){
      $lo_chgdoc = $this->co_reg->load->model('sysdocchg');
      $lv_prm = array('chgdocsrctyp'=>'CRM_CNT', 'chgdocsrccod'=>$this->crmcntcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
      $lo_chgdoc->save( $lv_prm );
		}
    
		return $lv_ret;
  }
	
	
  // GET LIST KANBAN. devuelve recordset de objetos (solo para KANBAN)
  function getListKanban( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '28', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }	
  
	function qualify( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    
    if( ($lp_dat['crmcntcod']??'')=='' ){ return false; }
    $lo_mdlprv = $this->co_reg->load->model('crmcnt');
    $lo_mdlprv->load( array('crmcntcod'=>$lp_dat['crmcntcod']), false );

    $lp_dat['crmcntatr'] = str_ireplace( '<USRCMT>'.$this->co_reg->document->getTagValue($lo_mdlprv->crmcntatr,'USRCMT').'</USRCMT>', '', $lo_mdlprv->crmcntatr) . '<USRCMT>'. $lo_mdlprv->co_reg->request->post['crmcntatrusrqlycmt'] .'</USRCMT>';
    $lp_dat['crmcntatr'] = str_ireplace( '<USRQLF>'.$this->co_reg->document->getTagValue($lo_mdlprv->crmcntatr,'USRQLF').'</USRQLF>', '', $lp_dat['crmcntatr']) . '<USRQLF>'. $lo_mdlprv->co_reg->request->post['crmcntatrusrqly']    .'</USRQLF>';

    return $this->call_sp('30', $lp_dat, $this->data);
  }
  // SORTBYUSER. ordena los tickets en kanban por usuarios
  function sortKanban( $lp_dat=array(), $lp_authCheck=true ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '16', $this->data, $this->data );
  }
	 
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $lp_in['crmcntatr'] = htmlspecialchars_decode( strtolower(isset($lp_in['crmcntatr'])?$lp_in['crmcntatr']:''), ENT_QUOTES );
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                      $this->co_reg->db->sqldat($lp_in,'crmcntcod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcnttxt'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntrqs', false),
                                      $this->co_reg->db->sqldat($lp_in,'crmcnttypcod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntmtvcod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntprtcod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstscod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntsrctyp'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntsrccod'),
                                      $this->co_reg->db->sqldte($lp_in,'crmcntdte'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntcmt'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntrequsr'),
                                      $this->co_reg->db->sqldat($lp_in,'hhrseccod'),
                                      $this->co_reg->db->sqldat($lp_in,'usrcod'),
                                      $this->co_reg->db->sqldat($lp_in,'hhrempcod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntrefdoc'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntatr'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntsrccntcod'),
                                      $this->co_reg->db->sqldte($lp_in,'crmcntduedte'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntkanusrord'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntkanstsord'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntwaycod')
																		);
		$this->sysdata['sqltxt'] = 'CRM_CNT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    $this->chkError($lp_action, $lo_rs, $lp_out, '08|18|28');
    
		// LOG DE CAMBIOS
		if ( $lp_action=='03' || $lp_action=='13') {
			$lo_chgmdl = $this->co_reg->load->model('sysdocchg');
			$this->data['syschgdoc'] = $lo_chgmdl->getDetail( array('chgdocsrctyp'=>'CRM_CNT','chgdocsrccod'=>$lp_in[$this->ID]) );
		}
		return ($this->errcod==0?true:false);
	}
	
	
	// CHECK NOTIFICATION. verifica los destinatarios de notificacion en base a los cambios/comentarios de un contacto crm
  // recibe: oldmdl - modelo previo
  //         newmdl - modelo actual
  // comentarios:
  //         tipos de usuarios:  usrntf ; usrreq ; usrasg ; usrmen
  // 				 tipos de motivo:    newres ; chgsts ; newcnt ; newmen
  function checkNotification($lp_oldmdl, $lp_newmdl){
		$lv_ntfarr = array( 'usrntf'=>array(), 'mtvntf'=>array() );
		// instancio modelo de usuarios
		$lo_usrmdl = $this->co_reg->load->model('syssecusr');
    		
    // cargo modelo de direcciones
    $lv_cntsrceml = '';
    $lo_adrmdl = $this->co_reg->load->model('grldatadr');
    // Tomo el mail del solicitante
    if($lp_newmdl->crmcntsrccntcod != ''){
      $lo_adrmdl->load(array('adrsrctyp' => 'GRL_CCT', 'adrsrccod' => $lp_newmdl->crmcntsrccntcod ));
      $lv_cntsrceml = $lo_adrmdl->adreml; 
    }    
    
		//cargo motivo de contacto
		$lo_cntmtvmdl = $this->co_reg->load->model('crmcntmtv');
		$lo_cntmtvmdl->load( array('crmcntmtvcod'=>$lp_newmdl->crmcntmtvcod) , false );
		$lo_cntmtvstslst = $lo_cntmtvmdl->crmcntmtvsts;		

		// busco el estado de origen y destino para obtener las notificaciones
		// o si no hay estado final, busco el estado inicial coincidente
		foreach($lo_cntmtvstslst as $lv_row){			
			if( ( intval($lp_newmdl->crmcntstscod)==intval($lv_row['crmcntstscodend']) && intval($lp_oldmdl->crmcntstscod)==intval($lv_row['crmcntstscodstr']) )
					|| 
					( intval($lp_newmdl->crmcntstscod)==intval($lv_row['crmcntstscodstr']) && intval($lv_row['crmcntstscodend'])==0 ) ) {
				
				if( $lv_row['crmcntmtvstsatr'] != '' ){
					// atributos de usuarios notificar
					$lv_usrres = $this->co_reg->document->getTagValue( $lv_row['crmcntmtvstsatr'] , 'usrres' );
					
					// array de usuarios a notificar. Se verifica si dentro de los usuarios se asigno un solicitante o un responsable
					$lv_usrres_arr = explode(';', $lv_usrres);
					// si encuentro solicitante o responsable lo reemplazo con datos del crm
					//verifico si dentro de mis usuarios a notificar se asigno un solicitante sino se agrega al array de usuarios a notificar
					foreach($lv_usrres_arr as $lv_row2){
						if( strtoupper($lv_row2) == '<SOLICITANTE>' ){
							if($lv_cntsrceml != '' || $lv_cntsrceml != null){
								$lv_ntfarr['usrntf'][] = array('adreml'=>$lv_cntsrceml,'ntftyp'=>'usrreq');  
							} 
						}else if(strtoupper($lv_row2) == '<RESPONSABLE>'){
							// recupero email del usuario asignado, si no hay usuario asignado por default no se agregara ningun mail
							$lo_usrmdl->load( array('usrcod'=> $lp_newmdl->usrcod) );
							if ($lo_usrmdl->adr != ''){
								$lv_ntfarr['usrntf'][] = array('adreml'=>$lo_usrmdl->adr->adreml,'ntftyp'=>'usrasg');   
							}
						}else{
							//cargo usuarios asignados para notificar
							if ($lv_row2 != ''){
								$lo_usrmdl->load( array('usrcod' => $lv_row2) );
								if ($lo_usrmdl->adr != ''){
									$lv_ntfarr['usrntf'][] = array('adreml'=>$lo_usrmdl->adr->adreml,'ntftyp'=>'usrntf');
								}
							}
						}   
					}    
				}
			}
		}
    
		// comentario y etiquetado
   	if(strpos($lp_newmdl->crmcntcmt, '@') !== false){

      $lv_elements = array();
      $lo_usrlst = array();
			// Extraigo todas las menciones con regex directamente del texto
			preg_match_all( '/@[a-zA-Z0-9_]+/', $lp_newmdl->crmcntcmt, $lo_usrlst );
      
      // lista de usuarios del sistema
      $lo_usr_rs = $lo_usrmdl->getList();
      foreach($lo_usrlst[0] as $lv_usrlstrow){
        foreach($lo_usr_rs as $lv_usrrow){
          //if(strtoupper($lv_usrlstrow) == $lv_usrrow['usrcod']){
          if(strtoupper($lv_usrlstrow) == '@'.$lv_usrrow['usrcod']){
            $lo_usrmdl->load( array('usrcod' => $lv_usrrow['usrcod']) );
            $lv_ntfarr['usrntf'][] = array('adreml'=>$lo_usrmdl->adr->adreml,'ntftyp'=>'usrmen');
          }
        }
      }
    }

		// agrego atributos adicionales segun el motivo de notificacion
    
		// - reasignacion de responsable
    ($lp_oldmdl->usrcod != $lp_newmdl->usrcod && $lp_newmdl->usrcod != '') ? $lv_ntfarr['mtvntf']['newres'] = true : '';	 
    
		// - nuevo contacto o cambio de estado
    if($lp_oldmdl->crmcntstscod != $lp_newmdl->crmcntstscod){
    	( $lp_oldmdl->crmcntstscod == '' ) ? $lv_ntfarr['mtvntf']['newcnt'] = true : $lv_ntfarr['mtvntf']['chgsts'] = true ; 
    }
    
    // - cambio de estado a cerrado
    if($lp_newmdl->crmcntstscls == 1){
    	$lv_ntfarr['mtvntf']['stscls'] = true ; 
    }
    
    // - nueva mencion de usuario en comentario
    foreach($lv_ntfarr['usrntf'] as $lv_row){
      ( $lv_row['ntftyp'] == 'usrmen' ) ? $lv_ntfarr['mtvntf']['newmen'] = true : '';
    }
    
    // devuelvo array 
    return $lv_ntfarr;
  }
  
}
?> 