<?php 
final class sysdevgrp extends tmssAction2 {
	const OBJTYP = 'SYS_DVG';
  function initialize(){ $this->ID = 'sysdevgrpcod'; }
	  
  function getOwnGroups(){
    // GRUPO DE DESARROLLO. recupero grupos de desarrollo de usuario
    $lo_devgrpmdl = $this->co_reg->load->model('sysdevgrp');
    $lv_prm = array('vewfldflt' => '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                   	'vewfldord' => 'sysdevgrpcod');
    $lo_grp_arr = $lo_devgrpmdl->getList($lv_prm);
    
    $lv_devgrp_arr = array();
    foreach($lo_grp_arr as $lv_row){ 
      $lv_sysdevgrpusr_arr = json_decode($lv_row['sysdevgrpusr'], true);
      foreach($lv_sysdevgrpusr_arr as $lv_usr){
        if(strtoupper($lv_usr) == strtoupper($this->co_reg->sec->usrcod)){
          $lv_devgrp_arr[] = array('sysdevgrpcod'=>$lv_row['sysdevgrpcod']
                                  , 'sysdevgrpcodext'=>$lv_row['sysdevgrpcodext']
                                  , 'sysdevgrptxt'=>$lv_row['sysdevgrptxt']);
          break;
        }
      }
    }
    
    return $lv_devgrp_arr;
  }
  
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, 
                                      $this->co_reg->db->sqldat($lp_in,'sysdevgrpcod'),
																			$this->co_reg->db->sqldat($lp_in,'sysdevgrpcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdevgrptxt'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in, 'sysdevgrpusr', false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_DEV_GRP_DEF (?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);    
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], 0);
    
		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
    return ($this->errcod==0?true:false);
	}
}
?>