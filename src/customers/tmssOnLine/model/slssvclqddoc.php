<?php
final class slssvclqddoc extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'slssvclqddoccod';
	
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
		
		/*
		$lp_dat['slssvclqddocatr001']='<refobjgrpcod>'.(isset($lp_dat['refobjgrpcod'])?$lp_dat['refobjgrpcod']:'').'</refobjgrpcod>'.
																	'<refobjgrptxt>'.(isset($lp_dat['refobjgrptxt'])?utf8_decode($lp_dat['refobjgrptxt']):'').'</refobjgrptxt>'.
																	'<refobjsubgrpcod>'.(isset($lp_dat['refobjsubgrpcod'])?$lp_dat['refobjsubgrpcod']:'').'</refobjsubgrpcod>'.
																	'<refobjtyptxt>'.(isset($lp_dat['refobjtyptxt'])?$lp_dat['refobjtyptxt']:'').'</refobjtyptxt>'.
																	'<stkmovdocdtecnv>'.(isset($lp_dat['stkmovdocdtecnv'])?utf8_decode($lp_dat['stkmovdocdtecnv']):'').'</stkmovdocdtecnv>'.
																	'<refobjsubgrptxt>'.(isset($lp_dat['refobjsubgrptxt'])?utf8_decode($lp_dat['refobjsubgrptxt']):'').'</refobjsubgrptxt>'.
                                  '<strdte>'.(isset($lp_dat['slssvclqddocstrdte'])?$lp_dat['slssvclqddocstrdte']:'').'</strdte>'.
                                  '<enddte>'.(isset($lp_dat['slssvclqddocenddte'])?$lp_dat['slssvclqddocenddte']:'').'</enddte>'.
                                  '<mtv>'.(isset($lp_dat['slssvclqddocmtv'])?utf8_decode($lp_dat['slssvclqddocmtv']):'').'</mtv>';
		*/
		
    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '11' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
	
  // SAVE SINGLE. graba el objeto (individual)
  function saveSingle( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['slssvclqddocatr001']='<refobjgrpcod>'.($lp_dat['refobjgrpcod']??'').'</refobjgrpcod>'.
																	'<refobjgrptxt>'.utf8_decode($lp_dat['refobjgrptxt']??'').'</refobjgrptxt>'.
																	'<refobjsubgrpcod>'.($lp_dat['refobjsubgrpcod']??'').'</refobjsubgrpcod>'.
																	'<refobjtyptxt>'.($lp_dat['refobjtyptxt']??'').'</refobjtyptxt>'.
																	'<stkmovdocdtecnv>'.utf8_decode($lp_dat['stkmovdocdtecnv']??'').'</stkmovdocdtecnv>'.
																	'<refobjsubgrptxt>'.utf8_decode($lp_dat['refobjsubgrptxt']??'').'</refobjsubgrptxt>'.
                                  '<strdte>'.($lp_dat['slssvclqddocstrdte']??'').'</strdte>'.
                                  '<enddte>'.($lp_dat['slssvclqddocenddte']??'').'</enddte>'.
                                  '<mtv>'.utf8_decode($lp_dat['slssvclqddocmtv']??'').'</mtv>';
    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }  
  
  // LOAD. carga el objeto
  function load( $lp_key=array() ) {
		return $this->call_sp( '03', $lp_key, $this->data );
  }
	
  // DELETE. borra objeto
  function delete( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '04', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// GET OPEN SERVICES. obtiene la lista de gastos no liquidados
  function getOpenServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '13', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }	

  // GET OPEN EXPENSES. obtiene la lista de gastos no liquidados
	/* FUNCIONALIDAD DISCONTINUADA
  function getOpenExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '14', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	*/
	
	// GET SERVICES. obtiene la lista de servicios liquidados
  function getServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '23', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET EXPENSES. obtiene la lista de gastos liquidados
	/* FUNCIONALIDAD DISCONTINUADA
  function getExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '24', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	*/
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'slssvclqddoccod'), 
																			$this->co_reg->db->sqldat($lp_in,'slssvclqdcod'), 
																			$this->co_reg->db->sqldat($lp_in,'refobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'refobjcod001'), 
																			$this->co_reg->db->sqldat($lp_in,'refobjcod002'), 
																			$this->co_reg->db->sqldat($lp_in,'slssvclqddoccodext'), 
																			$this->co_reg->db->sqldat($lp_in,'slssvclqddoctxt'), 
																			$this->co_reg->db->sqldte($lp_in,'slssvclqddocdte'),
																			$this->co_reg->db->sqlnum($lp_in,'slssvclqddocqty'),
                                     	$this->co_reg->db->sqldat($lp_in,'slssvclqddocday'),
																			$this->co_reg->db->sqlnum($lp_in,'slssvclqddocprc'),
																			$this->co_reg->db->sqlnum($lp_in,'slssvclqddoctot'),
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
																			$this->co_reg->db->sqldat($lp_in,'slssvclqddocatr001',false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'cuscod'),
																			$this->co_reg->db->sqldte($lp_in,'slssvclqdstrdte'),
																			$this->co_reg->db->sqldte($lp_in,'slssvclqdenddte'),
																			$this->co_reg->db->sqldat($lp_in,'slssvclqddockey')
																		);
		$this->sysdata['sqltxt'] = 'SLS_SVC_LQD_DOC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='13' || $lp_action=='23') {
      if($this->errtyp!='E'){
				$lp_out = $lo_rs;
      }else{
        $lp_out=array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt);
      }
			
		// devuelve ID (registro individual)
		} else {
      if ( $lo_rs && count($lo_rs)>0 ) {
        if( $this->errtyp!='E' ){
					$lp_out = $lo_rs[0];
					$this->data[self::ID] = ($lp_out[self::ID]??array_values($lp_out)[0]);
        }
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -9999;
				$this->errtxt = $this->co_reg->language->message('UnexpectedError', $this->sysdata['sqlstm'] );
			}
		}
		return ($this->errcod==0?true:false);
	}
}
?>