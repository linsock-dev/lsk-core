<?php
final class stkwmslocController extends tmssController2 {
	function initialize(){
    $this->CONTROLLER = 'stkwmsloc';
    $this->MODEL = 'stkwmsloc';							
   	$this->VIEW  = 'stkwmsloc';							
    $this->ID = 'wmsloccod';								
  }
  
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['wmsloctxt'])?'[~fltrow~]wmsloctxt'.chr(9).''.chr(9).$this->prm['wmsloctxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
    }
  }
}  
?>