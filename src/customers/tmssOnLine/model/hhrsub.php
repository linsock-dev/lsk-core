<?php
final class hhrsub extends tmssAction2 {
	const OBJTYP = 'HHR_SUB';	
  function initialize(){ $this->ID = 'hhrsubcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['chrtypasg'] = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		// solo se asignan horas si es un solo cargo
		$lp_dat['hhrsubatr'] = '<hrs>'.(count(explode(chr(9),$lp_dat['hhrchrtypcodlst']))==1?$lp_dat['hhrsubatrhrs']:'').'</hrs>';
    
		return parent::save( $lp_dat, $lp_authCheck );
  }	
	
	// GET CHARGES LIST. devuelve recordset de objetos (suplencias-cargos)
	function getChargesList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
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
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'hhrsubcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrsubcodext'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                      $this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                      $this->co_reg->db->sqldat($lp_in,'dstobjtyp'),
                                      $this->co_reg->db->sqldat($lp_in,'dstobjcod'),
																			$this->co_reg->db->sqldte($lp_in,'hhrsubdtestr'),
                                      $this->co_reg->db->sqldte($lp_in,'hhrsubdteend'),
                                      $this->co_reg->db->sqldat($lp_in,'hhrchrtypcodlst'),
                                      $this->co_reg->db->sqldat($lp_in,'hhrsubcmt',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'hhrsubatr',false)
																		);
		$this->sysdata['sqltxt'] = 'HHR_SUB_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23')){return false;}

		//   C A R G O S
		if( ($lp_action=='03' ||  $lp_action=='13') && $this->errcod==0 ) {
			$lo_chrtypasgmdl = $this->co_reg->load->model('hhrsub');
			$lp_out['chrtypasg'] = $lo_chrtypasgmdl->getChargesList(null, array('hhrsubcod'=>$this->data[$this->ID]) );
		}

		return ($this->errcod==0?true:false);
	}
}
?>