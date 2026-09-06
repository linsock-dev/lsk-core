<?php
final class hhrass extends tmssAction2 {
  function initialize(){ $this->ID = 'hhrasscod'; }
		
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['chrtypasg'] = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		
    // revisa si tiene que convertir el flag de asistencia
    if( isset($lp_dat['hhrassflg']) ){
      // convierte el flag de asistencia a 0 o 1
      if($lp_dat['hhrassflg'] == 'on' || $lp_dat['hhrassflg'] == 'off'){ $lp_dat['hhrassflg'] = ( $lp_dat['hhrassflg']=='on' ? 1 : 0 ); }
    }else{
      $lp_dat['hhrassflg'] = 0;
    }
    
		// atributos
		$lp_dat['hhrassatr'] ='<refobjtyp>'.($lp_dat['refobjtyp']??'').'</refobjtyp>'.
													'<refobjcod>'.($lp_dat['refobjcod']??'').'</refobjcod>'.
													'<refobjdat>'.($lp_dat['refobjdat']??'').'</refobjdat>';
													
		return parent::save( $lp_dat, $lp_authCheck );
  }
	
	// GET CHARGES LIST. devuelve recordset de objetos (asistencias-cargos)
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
																			$this->co_reg->db->sqldat($lp_in,'hhrasscod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrasscodext'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                      $this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                      $this->co_reg->db->sqldat($lp_in,'hhrassflg'),
																			$this->co_reg->db->sqldat($lp_in,'hhrchrasgcodlst'),
																			$this->co_reg->db->sqldte($lp_in,'hhrassdte'),
																			$this->co_reg->db->sqldat($lp_in,'hhrasscmt',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'hhrassatr',false)
																		);
		$this->sysdata['sqltxt'] = 'HHR_ASS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23')){return false;}
		
		//   C A R G O S
		if( ($lp_action=='03' || $lp_action=='13')  && $this->errcod==0 ) {
			$lo_chrtypasgmdl = $this->co_reg->load->model('hhrass');
			$lp_out['chrtypasg'] = $lo_chrtypasgmdl->getChargesList(null, array('hhrasscod'=>$this->data[$this->ID]) );
		}

		return ($this->errcod==0?true:false);
	}
}
?>