<?php
final class grldattxt extends tmssAction2 { 
	const OBJTYP = 'GRL_TXT';
  function initialize(){ $this->ID = 'txtcod'; }
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck = true ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
		$lp_dat['lngcod'] = ($lp_dat['lngcod']??''!=''?$lp_dat['lngcod']:$this->co_reg->sec->lngcod);
   	return parent::save($lp_dat, $lp_authCheck);
  }
	
  // GETLIST - override
	function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null, $lp_authCheck=true ) {
		if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);

		$lo_txt_cus = array();
		$lo_txt_sys = array();
		
		// se obtienen reportes de usuario
    $lp_prm['txtsys'] = 1;
    if ( !$this->call_sp( ($lp_authCheck?'08':'18'), $lp_prm, $lo_txt_cus ) ) {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
      // se verifican permisos para llamadas a SP del sistema
    } 
    // se obtienen reportes de sistema
    if( $this->co_reg->sec->hasPermission('SYS','TXT','05') ){
      $lp_prm['txtsys'] = 0;
      if ( !$this->call_sp( ($lp_authCheck?'08':'18'), $lp_prm, $lo_txt_sys ) ) {
        $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
      }
    }
    // se combinan ambos resultados en un solo array
		$this->data = array_merge( $lo_txt_cus, $lo_txt_sys );

    // ordenamiento de reportes de sistema/usuario
		if(isset($lp_vewopt['vewfldord']) && $lp_vewopt['vewfldord'] != ""){
			$lp_vewopt_arr = explode(' ',$lp_vewopt['vewfldord']);
			array_multisort (array_column($this->data, $lp_vewopt_arr[0]), $lp_vewopt_arr[1] == 'desc'? SORT_DESC : SORT_ASC, $this->data);
		}
    
		return $this->data;    
  }
  
  
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$lv_sys = ( ($lp_in['txtsys']??1)==0 || ($lp_in['txtsys']??1)==1 ? ($lp_in['txtsys']??1) : 1 );
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'txtcod'), 
																			$this->co_reg->db->sqldat($lp_in,'txtcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'txtdes'),
																			$this->co_reg->db->sqldat($lp_in,'txttxt', false), 
																			$this->co_reg->db->sqldat($lp_in,'lngcod'),
																			$this->co_reg->db->sqldat($lp_in,'txtsrctyp'),
																			$this->co_reg->db->sqldat($lp_in,'txtsrccod'),
																			$this->co_reg->db->sqldat($lp_in,'txttypcod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
    																	$this->co_reg->db->sqldat($this->sysdata,'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'GRL_DAT_TXT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], $lv_sys );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23')){return false;}
		
    return ($this->errcod==0?true:false);
	}
}
?>