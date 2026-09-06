<?php
final class hhrlic extends tmssAction2 {
	const SRCTYP = 'HHR_LIC';
  function initialize(){ $this->ID = 'hhrliccod'; }
	
	// CREATE. inicializa el objeto
	function create() {
		parent::create();
		$this->data['chrtypasg'] = array();
	}

  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		
		// solo se asignan horas si es un solo cargo
		if (isset($lp_dat['hhrlicatrhrs'])){
			$lp_dat['hhrlicatr'] = '<hrs>'.(count(explode(chr(9),$lp_dat['hhrchrtypcodlst']))==1?$lp_dat['hhrlicatrhrs']:'').'</hrs>';
		}
    
		return parent::save($lp_dat,$lp_authCheck);
  }
  
	// GET CHARGES LIST
	// devuelve recordset de objetos (licencia-cargos)
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
																			$this->co_reg->db->sqldat($lp_in,'hhrliccod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrliccodext'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrchrtypcodlst'),
																			$this->co_reg->db->sqldat($lp_in,'hhrlictypcod'),
																			$this->co_reg->db->sqldte($lp_in,'hhrlicdtestr'),
                                      $this->co_reg->db->sqldte($lp_in,'hhrlicdteend'),
                                      $this->co_reg->db->sqldat($lp_in,'hhrlicatr',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false)
																		);
		$this->sysdata['sqltxt'] = 'HHR_LIC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		$this->chkError($lp_action, $lo_rs, $lp_out, '08|18|23');

		//   C A R G O S
		if( ($lp_action=='03' || $lp_action == '13') && $this->errcod==0 ) {
			$lo_chrtypasgmdl = $this->co_reg->load->model('hhrlic');
			$lp_out['chrtypasg'] = $lo_chrtypasgmdl->getChargesList(null, array('hhrliccod'=>$this->data[$this->ID]) );
		}

		return ($this->errcod==0?true:false);
	}
}
?>