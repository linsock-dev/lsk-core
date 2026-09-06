<?php
final class syssecdrttyp extends tmssAction{
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	private $buscod = '';
	const ID = 'syssecdrttypcod';
	const OBJTYP = 'SYS_DRT';

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
    
  	$this->data['syssecdrttypatr'] = '<usrmsg>'.utf8_decode($lp_dat['syssecdrttypmsg']).'</usrmsg><usrshw>'.(isset($lp_dat['syssecdrttypvis']) ? 1 : 0).'</usrshw>';
   	$this->data['syssecdrttypdef'] = ( isset($lp_dat['syssecdrttyptyp']) ? ( strtoupper($lp_dat['syssecdrttyptyp']) == 'SN' ?  (isset($lp_dat['syssecdrttypdefsn']) ? ($lp_dat['syssecdrttypdefsn'] == 'on' || $lp_dat['syssecdrttypdefsn'] == '1' ? '1' : '0' ) : '0' ) : $lp_dat['syssecdrttypdef'] ) : $lp_dat['syssecdrttypdef']);
    
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
    $lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
  
  // LOAD. carga el objeto
  function load( $lp_key=array() ) { return $this->call_sp( '03', $lp_key, $this->data ); }
	
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
  
  // GET DIRECTIVES. devuelve los datos de las direcrtivas
  function getDirectives( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
    $lo_out_data = array();
		if ( $this->call_sp( '10', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else { $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage(); }
    return $this->data;
  }
  
  //  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, 
																			$this->co_reg->db->sqldat($lp_in,'syssecdrttypcod'), 
																			$this->co_reg->db->sqldat($lp_in,'syssecdrttypcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'syssecdrttyptxt'), 
																			$this->co_reg->db->sqldat($lp_in,'syssecdrttyptyp',false), 
																			$this->co_reg->db->sqlnum($lp_in,'syssecdrttypmin'), 
																			$this->co_reg->db->sqlnum($lp_in,'syssecdrttypmax'), 
																			$this->co_reg->db->sqldat($lp_in,'syssecdrttypdef'), 
                                     	$this->co_reg->db->sqldat($lp_in,'syssecdrttypreq',false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'syssecdrttypatr',false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_SEC_DRT_TYP_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], 0 );

    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' || $lp_action=='10') {
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
		
    // D E P E N D E N C I A S
    if ( $lp_action=='03' && $this->errcod==0 ) {
     	//separa directivas requeridas
      $lv_reqarr = array();
      $lv_reqtagarr = explode( chr(10), $lp_out['syssecdrttypreq'] );
      foreach( $lv_reqtagarr as $lv_key=>$lv_row ){ 
        array_push($lv_reqarr, array('syssecdrttypcod'=>$this->co_reg->document->getTagValue( $lv_row, 'reqcod' ),
                                      'syssecdrttypval'=>$this->co_reg->document->getTagValue( $lv_row, 'reqval' )));
      }

      //crea string con los id de las directivas requeridas
      $lv_reqstr = implode(chr(10), array_column($lv_reqarr, 'syssecdrttypcod'));

      //lista las directivas
      $lo_typmdl = $this->co_reg->load->model('syssecdrttyp');
      $lv_prm =  array( 'vewfldflt' => '[~fltrow~]dt.syssecdrttypcod'.chr(9).'IN'.chr(9).chr(9).$lv_reqstr.chr(9).chr(9).
                                       '[~fltrow~]dt.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
      $lo_drtarr = $lo_typmdl->getList( $lv_prm );

      //añade el valor
      foreach( $lo_drtarr as &$lv_row ){
        foreach( $lv_reqarr as $lv_row2 ){
          if( $lv_row['syssecdrttypcod'] == $lv_row2['syssecdrttypcod'] ){
            $lv_row['syssecdrttypval'] = $lv_row2['syssecdrttypval'];
          }
        }
      }
      unset($lv_row);
      $lp_out["syssecdrttypreq"] = $lo_drtarr;
    }
    
		return ($this->errcod==0?true:false);
	}
}
?>