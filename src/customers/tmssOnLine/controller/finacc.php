<?php 
final class finaccController extends tmssController2{
	function initialize(){ $this->CONTROLLER='finacc'; $this->MODEL='finacc'; $this->VIEW='finacc'; $this->ID='finacccod'; $this->OBJTYP = 'FIN_ACC';  $this->enable_sysdoccls = false; $this->preventCopy = array('finacccodext');}
  
  function additionalFunctions($lp_act){
  	switch ( $lp_act ) {
			// GETLIST by TEXT. Lista por texto
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['finacctxt']) 	 ?'[~fltrow~]a.finacctxt'.chr(9).''.chr(9).($this->prm['finacctxt']).chr(9).chr(9).chr(9):'').
																			 (isset($this->prm['finaccclscod'])?'[~fltrow~]a.finaccclscod'.chr(9).'='.chr(9).chr(9).$this->prm['finaccclscod'].chr(9).chr(9):'').
																			'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('data'=>$lo_data) );
        break;
    }
  }
}
?>