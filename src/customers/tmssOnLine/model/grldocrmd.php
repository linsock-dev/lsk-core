<?php
final class grldocrmd extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'docrmdcod';
  const SRCTYP = 'GRL_RMD';
	
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
	
	// CREATE. inicializa el objeto
	function create() {
		$this->data = array();
		$this->sysdata = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		
		$this->data['docrmdstrtme'] = substr($this->co_reg->db->sqldate($this->data['docrmdstrdte']),0,8).substr(str_ireplace(':','',$this->data['docrmdstrtme']),0,4).'00';
		if ( $this->data['docrmdtyp']=='U' ) {
			$this->data['docrmdfrq'] = '';		
		} else if ( $this->data['docrmdtyp']=='PD' ) {
			if ( (isset($this->data['rmdfrqtypPD001'])?$this->data['rmdfrqtypPD001']:'')=='on' ) {
				$this->data['docrmdfrq']= '<rmdfrqtyp>1</rmdfrqtyp>'.
																	'<rmdech>'.$this->data['docrmdfrqechPD'].'</rmdech>';
			} else if ( (isset($this->data['rmdfrqtypPD002'])?$this->data['rmdfrqtypPD002']:'')=='on' ) {
				$this->data['docrmdfrq']= '<rmdfrqtyp>2</rmdfrqtyp><rmdech>0</rmdech>';
			}
		} else if ( $this->data['docrmdtyp']=='PS' ) {
			$this->data['docrmdfrq']= '<rmdech>'.$this->data['docrmdfrqechPS'].'</rmdech>'.
																'<rmdwekday>'.
																	((isset($this->data['docrmdfrqwekdayPS007'])?$this->data['docrmdfrqwekdayPS007']:'')=='on'?'1':'0').
																	((isset($this->data['docrmdfrqwekdayPS001'])?$this->data['docrmdfrqwekdayPS001']:'')=='on'?'1':'0').
																	((isset($this->data['docrmdfrqwekdayPS002'])?$this->data['docrmdfrqwekdayPS002']:'')=='on'?'1':'0').
																	((isset($this->data['docrmdfrqwekdayPS003'])?$this->data['docrmdfrqwekdayPS003']:'')=='on'?'1':'0').
																	((isset($this->data['docrmdfrqwekdayPS004'])?$this->data['docrmdfrqwekdayPS004']:'')=='on'?'1':'0').
																	((isset($this->data['docrmdfrqwekdayPS005'])?$this->data['docrmdfrqwekdayPS005']:'')=='on'?'1':'0').
																	((isset($this->data['docrmdfrqwekdayPS006'])?$this->data['docrmdfrqwekdayPS006']:'')=='on'?'1':'0').
																'</rmdwekday>';
		} else if ( $this->data['docrmdtyp']=='PM' ) {
			if ( (isset($this->data['docrmdfrqtypPM001'])?$this->data['docrmdfrqtypPM001']:'')=='on' ) {
				$this->data['docrmdfrq']= '<rmdtyp>1</rmdtyp>'.
																	'<rmdday>'.$this->data['docrmdfrqdayPM'].'</rmdday>'.
																	'<rmdech>'.$this->data['docrmdfrqech001PM'].'</rmdech>';
			} else if ( (isset($this->data['docrmdfrqtypPM002'])?$this->data['docrmdfrqtypPM002']:'')=='on' ) {
				$this->data['docrmdfrq']= '<rmdtyp>2</rmdtyp>'.
																	'<rmddaytyp>'.$this->data['docrmdfrqdaytypPM'].'</rmddaytyp>'.
																	'<rmdwekday>'.$this->data['docrmdfrqwekdayPM'].'</rmdwekday>'.
																	'<rmdech>'.$this->data['docrmdfrqech002PM'].'</rmdech>';				
			}
		} else if ( $this->data['docrmdtyp']=='PA' ) {
			if ( (isset($this->data['docrmdfrqtypPA001'])?$this->data['docrmdfrqtypPA001']:'')=='on' ) {
				$this->data['docrmdfrq']= '<rmdtyp>1</rmdtyp>'.
																	'<rmdech>'.$this->data['docrmdfrqechPA'].'</rmdech>'.
																	'<rmdday>'.$this->data['docrmdfrqdayPA'].'</rmdday>'.
																	'<rmdmth>'.$this->data['docrmdfrqmth001PA'].'</rmdmth>';
			} else if ( (isset($this->data['docrmdfrqtypPA002'])?$this->data['docrmdfrqtypPA002']:'')=='on' ) {
				$this->data['docrmdfrq']= '<rmdtyp>2</rmdtyp>'.
																	'<rmdech>'.$this->data['docrmdfrqechPA'].'</rmdech>'.
																	'<rmddaytyp>'.$this->data['docrmdfrqdaytypPA'].'</rmddaytyp>'.
																	'<rmdwekday>'.$this->data['docrmdfrqwekdayPA'].'</rmdwekday>'.
																	'<rmdmth>'.$this->data['docrmdfrqmth002PA'].'</rmdmth>';
			}
		}
		
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
	
  // LOAD. carga el objeto
  function load( $lp_key ) {
		$this->data[self::ID] = $lp_key[self::ID];
		$this->data['docrmdstrdte'] = $lp_key['curdte'];
		$lo_out_data = array();
		return $this->call_sp( '03', $this->data, $this->data );
  }
  
  // DELETE. borra objeto
  function delete( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '04', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET REMINDERS OF PERIOD. obtiene lista de recordatorios actuales (para el día de hoy)
  function getRemindersOfPeriod( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '18', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }	
	
  // CHECK REMINDER. fija marca de realizado en el reminder
  function checkReminder( $lp_dat=array() ) {
    if( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		if ( $this->call_sp( '10', $this->data, $lo_out_data ) ) {
			$this->data['docrmdlogcod'] = array_values($lo_out_data)[0];
			return true;
		} else {
			return false;
		}
  }
	
  // UNCHECK REMINDER. fija marca de realizado en el reminder
  function uncheckReminder( $lp_dat=array() ) {
    if( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		if ( $this->call_sp( '11', $this->data, $lo_out_data ) ) {
			$this->data['docrmdlogcod'] = array_values($lo_out_data)[0];
			return true;
		} else {
			return false;
		}
  }
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'docrmdcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docrmdcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'docrmdtxt'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docrmdtyp'), 
																			$this->co_reg->db->sqldte($lp_in,'docrmdstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'docrmdenddte'), 
																			$this->co_reg->db->sqldat($lp_in,'docrmdstrtme'), 
																			$this->co_reg->db->sqldat($lp_in,'docrmdlngtxt'), 
																			$this->co_reg->db->sqldat($lp_in,'docrmddst'), 
																			(isset($lp_in['docrmdfrq'])?html_entity_decode($lp_in['docrmdfrq']):''), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'docrmdlogcod')
																		);
		$this->sysdata['sqltxt'] = 'GRL_DOC_RMD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		if ( $lp_action=='08' || $lp_action=='18' ) {
			$lp_out = $lo_rs;
		} else {
			if ( $lo_rs && count($lo_rs)>0 ) {
				if ( isset($lo_rs[0]['errcod']) )  {
					if ( $lo_rs[0]['errcod']!=0 ) {
						$this->errtyp = 'E';
						$this->errcod = $lo_rs[0]['errcod'];
						$this->errtxt = $lo_rs[0]['errtxt'];
					} else {
						$lp_out = $lo_rs[0];
						$this->data[self::ID] = array_values($lp_out)[0];
					}
				} else {
					$lp_out = $lo_rs[0];
				}
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -999;
				$this->errtxt = 'Error inesperado al procesar la operacion ['.$this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']).']';
			}
		}		
		return ($this->errcod==0?true:false);
	}
}
?>