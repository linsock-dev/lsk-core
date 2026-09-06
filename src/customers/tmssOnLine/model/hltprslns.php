<?php
final class hltprslns extends tmssAction2 {
  function initialize(){ $this->ID = 'hltlnscod'; }
  
  // GET LIST. devuelve recordset de objetos
  function getListQuota( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null){ $lo_vew = $this->co_reg->load->model('grlvew'); }
    $lp_vewopt['vewmaxrec'] = 100;
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '29', $lp_prm, $lo_out_data ) ) {
      // formatea a 0.000,00
			foreach($lo_out_data as &$lv_row){
        $lv_row['buyexpdoctot'] = number_format($lv_row['buyexpdoctot'], 2, ',','.');
      }
      unset($lv_row);
      $this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }

  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
  
  //  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hltlnscod'), 
                                     	$this->co_reg->db->sqldat($lp_in,'hltlnscodext'), 
																			$this->co_reg->db->sqldat($lp_in,'hltlnstxt'),
                                     	$this->co_reg->db->sqldte($lp_in,'hltlnsdte'),  
                                      $this->co_reg->db->sqldat($lp_in,'prscod'), 
                                      $this->co_reg->db->sqldat($lp_in,'hltlnsqta',false,'1'),
                                     	$this->co_reg->db->sqldat($lp_in,'hltlnsqtaint',false,'0'),
                                      $this->co_reg->db->sqldat($lp_in,'hltlnsqtaintunt',false,'1'),
                                      $this->co_reg->db->sqldte($lp_in,'hltlnsqtafrtdte'), 
                                    	$this->co_reg->db->sqlnum($lp_in,'hltlnstot'), 
                                      $this->co_reg->db->sqldat($lp_in,'buyexptypcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'curcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'HLT_PRS_LNS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|29')){return false;}

		//		C U O T A S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_lnsmdl = $this->co_reg->load->model('hltprslns');
			$lp_out['hltprslnsqta'] = $lo_lnsmdl->getListQuota( array(), array($this->ID=>$lp_out[$this->ID]) );
		}

		return ($this->errcod==0?true:false);
	}
}
?>