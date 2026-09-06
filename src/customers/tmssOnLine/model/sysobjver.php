<?php
final class sysobjver extends tmssAction {
  protected $co_reg; 
  private $data = array();
	private $sysdata = array();
	const ID = 'sysobjcod';
	const OBJTYP = 'SYS_OBJ_VER';

  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }

  // LOAD VERSION. carga los datos de una version
  function loadVersion( $lp_key=array() ) {
		return $this->call_sp( '13', $lp_key, $this->data );
  }
  
  // GET VERSIONS. devuelve la lista de versiones del objeto
  function getVersions( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    if ( !$this->call_sp( '18', $lp_dat, $lo_out_data ) ) {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $lo_out_data;
	}
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod,
                                     $this->co_reg->db->sqldat($lp_in,'sysobjcod'),
                                     $this->co_reg->db->sqldat($lp_in,'sysobjcodext'),
                                     $this->co_reg->db->sqldat($lp_in,'sysobjtxt'),
                                     $this->co_reg->db->sqldat($lp_in,'sysobjclscod'),
                                     $this->co_reg->db->sqldat($lp_in,'sysobjver'),
                                     $this->co_reg->db->sqldat($lp_in,'sysobjlck'),
                                     $this->co_reg->db->sqldat($lp_in,'docsts'),
																		 $this->co_reg->db->sqldat($this->sysdata,'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_OBJ_DEF (?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] , 0);
		
    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='18') {
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
}?>