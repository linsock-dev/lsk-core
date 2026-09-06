<?php
final class grldoccnt extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'grldoccntcod';
	const OBJTYP = 'DOC_CNT';
	
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
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->sysdata = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }

		$lp_dat['adrnme001'] = ($lp_dat['grldoccntobjtxt']??'');
		$lp_dat['grldoccntatr'] = '<mstcntcod>'.($lp_dat['mstcntcod']??'').'</mstcntcod>';

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
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {		
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'grldoccntcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscodcnt'),
                                     	$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                     	$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'grldoccntobjtyp'),
																			$this->co_reg->db->sqldat($lp_in,'grldoccntobjcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'grldoccntobjtxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in,'grldoccntatr')
																		);
		$this->sysdata['sqltxt'] = 'GRL_DOC_CNT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' ) {
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
		
		//		A D R
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03') && $this->errcod==0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = 'GRL_DOC_CNT';
			$lp_in['adrsrccod'] = $this->data[self::ID];
			if ($lp_action=='03') {
				$lo_adrmdl->load( $lp_in );
				$lp_out['adr'] = $lo_adrmdl;
			} else if ( $lo_adrmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_adrmdl->errcod;
				$this->errtxt = $lo_adrmdl->errtxt;
			} else {
				$lp_out['adr']=$lo_adrmdl;
			}
		}

		//		T A X
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03') && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = 'GRL_DOC_CNT';
			$lp_in['taxsrccod'] = $this->data[self::ID];
			if ($lp_action=='03') {
				$lo_taxmdl->load( $lp_in );
				$lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			} else {
				$lp_out['tax']=$lo_taxmdl;
			}
		}
    
		return ($this->errcod==0?true:false);
	}
}
?>