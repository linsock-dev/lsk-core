<?php
final class hhrlqd extends tmssAction2 {
  function initialize(){ $this->ID='hhrlqdcod';}
	const SRCTYP = 'HHR_LQD';
  
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck = true) {
    if(count($lp_dat)==0) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['hhrlqdatr001'] ='<srcobjtxt>'.utf8_encode($lp_dat['srcobjtxt']??'').'</srcobjtxt>'
																.'<srcobjcod>'.($lp_dat['srcobjcod']??'').'</srcobjcod>'
																.'<chrtyptxt>'.utf8_encode($lp_dat['hhrchrtyptxt']??'').'</chrtyptxt>'
																.'<prcschtxt>'.utf8_encode($lp_dat['prcschtxt']??'').'</prcschtxt>'
																.'<chratr>'.($lp_dat['hhrchrasgatr']??'').'</chratr>'
																.'<chrstrdte>'.(isset($lp_dat['hhrchrasgdtestr']) ? (is_object($lp_dat['hhrchrasgdtestr'])?$lp_dat['hhrchrasgdtestr']->format('d/m/Y'):$lp_dat['hhrchrasgdtestr']) : '').'</chrstrdte>'
																.'<chrenddte>'.(isset($lp_dat['hhrchrasgdteend']) ? (is_object($lp_dat['hhrchrasgdteend'])?$lp_dat['hhrchrasgdteend']->format('d/m/Y'):$lp_dat['hhrchrasgdteend']) : '').'</chrenddte>'
																.'<empstrdte>'.(isset($lp_dat['hhrempinbdte']) ? (is_object($lp_dat['hhrempinbdte'])?$lp_dat['hhrempinbdte']->format('d/m/Y'):$lp_dat['hhrempinbdte']) : '').'</empstrdte>'
																.'<empenddte>'.(isset($lp_dat['hhrempoutdte']) ? (is_object($lp_dat['hhrempoutdte'])?$lp_dat['hhrempoutdte']->format('d/m/Y'):$lp_dat['hhrempoutdte']) : '').'</empenddte>'
																.'<medcovtxt>'.utf8_encode($lp_dat['hhrmedcovtxt']??'').'</medcovtxt>'
																.'<medcovcodext>'.($lp_dat['hhrmedcovcodext']??'').'</medcovcodext>'
																.'<lqdstrdte>'.($lp_dat['hhrlqdstrdte']??'').'</lqdstrdte>'
																.'<lqdenddte>'.($lp_dat['hhrlqdenddte']??'').'</lqdenddte>';		
		
    return parent::save($lp_dat,$lp_authCheck);
  }

  // GET SOURCES. devuelve la lista de origenes para liquidación
  function getSources( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '33', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // UPDATETOTAL. actualiza el total de cabecera del documento basado en los documentos asignados
  function updateTotal( $lp_dat=array() ) {
    if(count($lp_dat)==0) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '05', $this->data, $this->data );
  }
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    if(count($lp_dat)==0) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data );
  }
	
	// GET OPEN SERVICES. obtiene la lista de gastos no liquidados
  function getOpenServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '53', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }	
	
  // GET OPEN EXPENSES. obtiene la lista de gastos no liquidados
  function getOpenExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '54', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// GET SERVICES. obtiene la lista de servicios liquidados
  function getServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '43', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET EXPENSES. obtiene la lista de gastos liquidados
  function getExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '44', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // UPDATE TREATMENT. actualiza el estado de tratamiento (cabecera)
  function updateTreatment( $lp_dat=array() ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( '32', $this->data, $this->data );
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
															$this->co_reg->db->sqldat($lp_in,'hhrlqdcod'),
															$this->co_reg->db->sqldat($lp_in,'hhrlqdtxt'),
															$this->co_reg->db->sqldte($lp_in,'hhrlqddte'),
															$this->co_reg->db->sqldte($lp_in,'hhrlqdstrdte'),
															$this->co_reg->db->sqldte($lp_in,'hhrlqdenddte'),
															$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
															$this->co_reg->db->sqldat($lp_in,'srcobjcod001'),
															$this->co_reg->db->sqldat($lp_in,'srcobjcod002'),
															$this->co_reg->db->sqldat($lp_in,'hhrchrasgcod'),
															$this->co_reg->db->sqldat($lp_in,'prcschcod'),
															$this->co_reg->db->sqldat($lp_in,'hhrlqdatr001',false),
															$this->co_reg->db->sqldat($lp_in,'docsts'),
															$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
															$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
															$this->co_reg->db->sqldat($lp_in,'txtprc',false),
															$this->co_reg->db->sqldat($lp_in,'hhrlqdgrpcod')
														);
		$this->sysdata['sqltxt'] = 'HHR_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		$this->chkError($lp_action, $lo_rs, $lp_out, '08|18|53|54|43|44|33');
		//		P R E C I O S
		if ( ($lp_action=='03'|| $lp_action=='13') && $this->errcod==0 ) {
			$lo_slsinvprc = $this->co_reg->load->model('grldatprc');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).self::SRCTYP.chr(9).chr(9).
																		'[~fltrow~]p.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lp_in['hhrlqdcod'].chr(9).chr(9),
											'vewfldord' =>'p.srcobjcod002, p.prcschcndrow ' );
			$lp_out['txtprc'] = $lo_slsinvprc->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>