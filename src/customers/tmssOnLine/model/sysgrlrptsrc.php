<?php
final class sysgrlrptsrc extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'rptsrccod';
	
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
    $this->data['col'] = array();
		$this->sysdata = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
	
  // LOAD. carga el objeto
  function load( $lp_dat=array() ) {
		if(count($lp_dat)==0) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lo_out_data = array();

		if ( $this->call_sp( '03', $this->data, $lo_out_data ) ) {
			$this->data = $lo_out_data;
			$this->data['rptsrcsys'] = $lp_dat['rptsrcsys'];
			return true;
		} else {
			return false;
		}
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
		$lo_rs_cus = array();
		$lo_rs_sys = array();
		
		// se obtienen reportes de usuario
    $lp_prm['rptsrcsys'] = 1;
    if ( !$this->call_sp( '08', $lp_prm, $lo_rs_cus ) ) {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
      // se verifican permisos para llamadas a SP del sistema
    } 
    // se obtienen reportes de sistema
    $lp_prm['rptsrcsys'] = 0;
    if ( !$this->call_sp( '08', $lp_prm, $lo_rs_sys ) ) {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }
    // se combinan ambos resultados en un solo array
		$this->data = array_merge( $lo_rs_cus, $lo_rs_sys );

    // ordenamiento de reportes de sistema/usuario
		if(isset($lp_vewopt['vewfldord']) && $lp_vewopt['vewfldord'] != ""){
			$lp_vewopt_arr = explode(' ',$lp_vewopt['vewfldord']);
			array_multisort (array_column($this->data, $lp_vewopt_arr[0]), $lp_vewopt_arr[1] == 'desc'? SORT_DESC : SORT_ASC, $this->data);
		}
    return $this->data;
  }
  
  // GET REPORT SYSTEM. Obtiene los origenes de Reporte de Sistema (0)
  function getReportSystem( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null	 ) {
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		
		$lo_rs_sys = array();
    $lp_prm['rptsrcsys'] = 0;
    if ( !$this->call_sp( '08', $lp_prm, $lo_rs_sys ) ) {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }
    return $this->data=$lo_rs_sys;
  }
  
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {		
		$this->errtyp = 'S'; 
		$this->errcod = 0;
		$this->errtxt = ''; 
		// los indices de conexion son distintos que los parámetros de pantalla (pantalla [1-sistema / 0-usuario] vs conexion[0-sistema / 1-usuario])
 		$lv_rptsrcsys = $lp_in['rptsrcsys'] ?? $lp_in['rptsrcsys'] ?? '1';

		$this->sysdata['sqlprm']=array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																		$this->co_reg->db->sqldat($lp_in,'rptsrccod'), 
																		$this->co_reg->db->sqldat($lp_in,'rptsrctxt'), 
																		$this->co_reg->db->sqldat($lp_in,'rptsrcsrc',false), 
																		$this->co_reg->db->sqldat($lp_in,'docsts'),
																		$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																		$this->co_reg->db->sqldat($lp_in,'rptsrctyp')
																	);
    $this->sysdata['sqltxt'] = 'SYS_GRL_RPT_SRC_DEF (?,?,?,?,?,?,?,?,?)'; 
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] , $lv_rptsrcsys );

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

		//		C O L
		if ( $lp_action=='03' && $this->errcod==0 ) {
			$lo_colmdl = $this->co_reg->load->model('sysgrlrptsrccol');
			$lv_in = array('rptsrcsys'=>$lv_rptsrcsys);
			$lv_prm = array('vewfldflt'=>'[~fltrow~]rc.rptsrccod'.chr(9).'='.chr(9).chr(9).$lp_in['rptsrccod'].chr(9).chr(9),
											'rptsrcsys'=>$lv_rptsrcsys);
			$lp_out['col'] = $lo_colmdl->getList($lv_prm,$lv_in);
		}
    
		return ($this->errcod==0?true:false);
	}	
}
?>