<?php
final class systra extends tmssAction2 {
	const OBJTYP = 'SYS_TRA';
  function initialize(){ $this->ID = 'systracod'; }
	
	// CREATE. inicializa el objeto
  function create( $lp_data=array() ) {
    parent::create();
		$this->data['traobj'] = array();
  }
  
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null, $lp_authCheck=true ) {
    
    // GRUPO DE DESARROLLO. recupero grupos de desarrollo de usuario
    $lo_devgrpmdl = $this->co_reg->load->model('sysdevgrp');
    $lv_devgrp_arr = $lo_devgrpmdl->getOwnGroups();
    
    $lv_devgrp = '';
    // no se usa este filtro para el caso de los devs de tms
    $lv_doflt = count(array_filter($lv_devgrp_arr, function($lp_val){ return $lp_val['sysdevgrpcodext'] == 'TMS';})) == 0;
    if($lv_doflt){
      if(!count($lv_devgrp_arr)){
      	$lv_devgrp = '0';  
      }else{
        foreach($lv_devgrp_arr as $lv_row){
          $lv_devgrp .= ($lv_devgrp == '' ? '' : chr(10)).$lv_row['sysdevgrpcod'];
        }
      }
    }
  	
    if($lv_doflt){ $lp_vewopt['vewfldflt'].='[~fltrow~]t.sysdevgrpcod'.chr(9).'IN'.chr(9).chr(9).$lv_devgrp.chr(9).chr(9); }
    
    // ejecuto consulta/listado
    return parent::getList($lp_vewopt,$lp_prm,$lo_vew,$lp_authCheck);
  }
  
  
	// RELEASE. libera la orden y sus objetos
  function release( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( ($lp_authCheck?'05':'15'), $this->data, $this->data );
  }
  
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod,
                                     $this->co_reg->db->sqldat($lp_in,'systracod'),
                                     $this->co_reg->db->sqldat($lp_in,'systracodext'),
                                     $this->co_reg->db->sqldat($lp_in,'systratxt'),
                                     $this->co_reg->db->sqldat($lp_in,'srcbuscod'),
                                     $this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                     $this->co_reg->db->sqldat($lp_in,'srcobjcod001'),
                                     $this->co_reg->db->sqldat($lp_in,'srcobjcod002'),
                                     $this->co_reg->db->sqldat($lp_in,'docsts'),
																		 $this->co_reg->db->sqldat($this->sysdata,'view_options', false),
                                     $this->co_reg->db->sqldat($lp_in,'sysdevgrpcod')
																		);
		$this->sysdata['sqltxt'] = 'SYS_TRA_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] , 0);

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
    //obtiene los codigos de los objetos asignados a la orden de transporte
    if( $lp_action=='03' or $lp_action=='13'){
      $lo_traobjmdl = $this->co_reg->load->model('systraobj');
      $lv_prm = array('vewfldflt' => '[~fltrow~]t.systracod'.chr(9).'='.chr(9).chr(9).$lp_in['systracod'].chr(9).chr(9),
                     	'vewfldord' => 'oc.sysobjclstxt, o.sysobjtxt');
      $this->traobj = $lo_traobjmdl->getList( $lv_prm );
    }
		
		return ($this->errcod==0?true:false);
	}
}
?>