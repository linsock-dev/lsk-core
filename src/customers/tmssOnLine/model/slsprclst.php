<?php
final class slsprclst extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'slsprclstprccod';
  const SRCTYP = 'SLS_PRL';
	
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
    $lv_act = '01';
		$lo_out_data = array();
		if ( $this->call_sp( $lv_act, $this->data, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
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
  // DELETELIST. borra la lista de objetos
  function deleteList( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '14', $this->data, $this->data );
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
  

	 // GET LIST COST. actualiza lista con base costos
  function getListCost( $lp_dat=array(), $lp_vewopt=array(), $lo_vew=null  ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$this->data = $lp_dat;
		$lo_out_data = array();
		if ( $this->call_sp( '16', $this->data, $lo_out_data ) ) {
      return $lo_out_data;
    } else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }
  }
	
  // GET LIST PRICE. actualiza lista con base precios
  function getListPrice( $lp_dat=array(), $lp_vewopt=array(), $lo_vew=null  ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$this->data = $lp_dat;
		$lo_out_data = array();
		if ( $this->call_sp( '17', $this->data, $lo_out_data ) ) {
      return $lo_out_data;
    } else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }
  }
	
	//  CALL SP
	//  llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstcod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstvercod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstprccod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprcsrctyp'),
																			$this->co_reg->db->sqldat($lp_in,'slsprcsrccod'),
																			$this->co_reg->db->sqlnum($lp_in,'slsprcqty'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprcuntcod'),
																			$this->co_reg->db->sqlnum($lp_in,'slsprcminval'), 
																			$this->co_reg->db->sqlnum($lp_in,'slsprcmaxval'), 
																			$this->co_reg->db->sqlnum($lp_in,'slsprcminrng'), 
																			$this->co_reg->db->sqlnum($lp_in,'slsprcmaxrng'), 
																			$this->co_reg->db->sqlnum($lp_in,'slsprc'), 
																			$this->co_reg->db->sqlnum($lp_in,'slsprcref'),
																			$this->co_reg->db->sqlnum($lp_in,'slsprcvar'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'slsprclst', false)
																			//@lp_errcod			as int			= null OUTPUT,	/* id error */
																			//@lp_errtxt			as nvarchar(400)= null OUTPUT,	/* txt error */
																		);
		$this->sysdata['sqltxt'] = 'SLS_PRC_LST_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, null, null)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
  // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0)); 	
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='16' || $lp_action=='17') {
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