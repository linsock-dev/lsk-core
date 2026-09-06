<?php
final class grlrpt extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'rptcod';
	
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
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }

		// determino donde se debe grabar el reporte (base central / base de cliente)
		$lp_dat['syscnx'] = $lp_dat['rptsys']; 
		
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
		$this->sysdata['view_options'] = preg_replace('/(<veword>)\s*rptsys\s+(asc|desc)\s*(<\/veword>)/i','$1$2', $lo_vew->parseViewOptions($lp_vewopt));
    
		$lo_rs_cus = array();
		$lo_rs_sys = array();		
		// se obtienen reportes de usuario
		$lp_prm['syscnx'] = 1;
		if ( !$this->call_sp( '08', $lp_prm, $lo_rs_cus ) ) {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
			// se verifican permisos para llamadas a SP del sistema
		} 

		// se obtienen reportes de sistema
		$lp_prm['syscnx'] = 0;
		if ( !$this->call_sp( '08', $lp_prm, $lo_rs_sys ) ) {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		// se combinan ambos resultados en un solo array
		$this->data = array_merge( $lo_rs_cus, $lo_rs_sys );

		// ordenamiento de reportes de sistema/usuario
		if( ($lp_vewopt['vewfldord']??'')!='' && count($this->data)>0 ){
			$lp_vewopt_arr = explode(' ',$lp_vewopt['vewfldord']);
			array_multisort(array_column($this->data, $lp_vewopt_arr[0]), trim(strtolower($lp_vewopt_arr[1]))=='desc'? SORT_DESC : SORT_ASC, $this->data);
		}
		
    return $this->data;
  }
  
  // GET REPORT LIST. devuelve recordset de objetos
  function getReportList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null){ $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '18', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  //  GET REPORT DATA. devuelve los datos de la ejecución de un reporte (dado un SP)
	function getReportData( $lp_sqlprm, $lp_sqltxt ) {
		$this->sysdata['sqlprm'] = $lp_sqlprm;
		$this->sysdata['sqltxt'] = $lp_sqltxt;
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		return $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	}
  
  // SAVE SECURITY. establece la seguridad de un reporte
  function saveSecurity( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		
		// toda la seguridad SIEMPRE se graba en la base del cliente
		$lp_dat['syscnx']=1;
		$lp_dat['docsts']='A';
		
    $this->data = $lp_dat;
		return $this->call_sp( '21', $this->data, $this->data );
  }
  
  // GET SECURITY. recupera la seguridad de un reporte
  function getSecurity( $lp_key=array() ) {
    if ( count($lp_key)==0 ) { $lp_key = $this->co_reg->request->post; }
    
    // la recuperación de la seguridad se realiza en la base del cliente
    $lp_key['syscnx'] = 1;
    $lo_out_data = array();

    if ( $this->call_sp( '22', $lp_key, $lo_out_data ) ) {
      $this->data = $lo_out_data;
    }
    return $this->data;
	}
  
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
    $lv_syscnx = $lp_in['syscnx'] ?? $lp_in['rptsys'] ?? '1';
    
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'rptcod'), 
																			$this->co_reg->db->sqldat($lp_in,'rpttxt'), 
																			$this->co_reg->db->sqldat($lp_in,'rpthietxt'), 
																			$this->co_reg->db->sqldat($lp_in,'rptsrccod'), 
																			$this->co_reg->db->sqldat($lp_in,'rptsrcsys'), 
																			$this->co_reg->db->sqldat($lp_in,'rptatr',false),
																			$this->co_reg->db->sqldat($lp_in,'rptperusr'), 
																			$this->co_reg->db->sqldat($lp_in,'rptperrls'), 
																			$this->co_reg->db->sqldat($lp_in,'autcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'rptshwrpm'),
                                     	$this->co_reg->db->sqldat($lp_in,'rptsys')
																		);
		$this->sysdata['sqltxt'] = 'GRL_RPT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);

		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] , $lv_syscnx );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='18' || $lp_action=='22') { 
      if($this->errtyp!='E'){
				$lp_out = $lo_rs;
      }else{
        $lp_out=array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt);
      }	
		} 
    else {
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
    //	M E N S A J E S
    if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
      // obtengo los posibles mensajes para la clase de documento
      $lo_msglstmdl = $this->co_reg->load->model('grldatmsg');
      $lv_prm = array('vewfldflt' =>'[~fltrow~]m.srcobjtyp'.chr(9).'='.chr(9).chr(9).'GRL_RPT'.chr(9).chr(9).
                     								'[~fltrow~]m.srcobjcod'.chr(9).'='.chr(9).chr(9).$lp_in['rptcod'].chr(9).chr(9).
                     								(isset($lo_rs[0]['rptsrcsys'])?'[~fltrow~]m.srcobjcod002'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['rptsrcsys'].chr(9).chr(9):''));
      $lp_out['rptmsgcls'] = array_merge(
        $lo_msglstmdl->getList($lv_prm, array('srcobjtyp'=>'GRL_RPT')),
        $lo_msglstmdl->getMessageList($lv_prm,array('srcobjtyp'=>'GRL_RPT'))
    	);
			
		}
		return ($this->errcod==0?true:false);
	}
}
?>