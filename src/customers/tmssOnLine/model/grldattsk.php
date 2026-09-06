<?php
final class grldattsk extends tmssAction2 {
  function initialize(){ $this->ID = 'tskcod'; }
  
  // GET EXECUTION LIST. devuelve lista de tareas a ejecutar
  function getExecutionList() {
		$lo_out_data = array();
		if ( $this->call_sp( '20', array(), $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  // UPDATE TASKS STATUS. actualiza el estado de las tareas listadas
  function updateTasksStatus( $lp_dat=array() ) {
		$lo_out_data = array();
		if ( $this->call_sp( '25', $lp_dat, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
  // GET TASKS NEXT EXECUTION. calcula la fecha de la próxima ejecución de todas las tareas exitosas
  function getNextExecution( $lp_dat=array() ) {
	$lo_out_data = array();
	if ( $this->call_sp( '17', $lp_dat, $lo_out_data ) ) {
		$this->data = $lo_out_data;
	} else {
		$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
	}
    return $this->data;
  }
	
  //  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'tskcod'),
																			$this->co_reg->db->sqldat($lp_in,'tskcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'tsktxt'),
																			$this->co_reg->db->sqldat($lp_in,'tskfrqatr',false),
                                     	$this->co_reg->db->sqldat($lp_in,'tskurl'),
                                     	$this->co_reg->db->sqldte($lp_in,'tsklstrundte'),
																			$this->co_reg->db->sqldat($lp_in,'tsklstrunsts'),
																			$this->co_reg->db->sqldat($lp_in,'tsklstrunatr'),
                                     	$this->co_reg->db->sqldat($lp_in,'tsknxtrunatr'),
                                     	$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod001'),
                                      $this->co_reg->db->sqldat($lp_in,'tskprg'),
                                     	$this->co_reg->db->sqldat($lp_in,'tskatr', false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($lp_in,'tsklst'),
                                     	// resultado de ejecución (lo usa la Op 17 para armar el registro de cada tarea)
                                     	$this->co_reg->db->sqldat($lp_in,'tskexeerrtyp'),
                                     	$this->co_reg->db->sqldat($lp_in,'tskexeerrcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'tskexeerrmsg'),
                                     	$this->co_reg->db->sqldat($lp_in,'tskexeres'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																		);
		$this->sysdata['sqltxt'] = 'GRL_DAT_TSK_DEF(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);		
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], '0' );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|20')){return false;}
    
		return ($this->errcod==0?true:false);
	}
} 
?>