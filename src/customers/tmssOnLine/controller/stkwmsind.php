<?php
final class stkwmsindController extends tmssController2 {
	function initialize(){
    $this->CONTROLLER = 'stkwmsind';
    $this->MODEL = 'stkwmsind';							
    $this->VIEW  = 'stkwmsind';							
    $this->ID = 'wmsindcod';								
  }
     
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['wmsindtxt'])?'[~fltrow~]wmsindtxt'.chr(9).''.chr(9).$this->prm['wmsindtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
    }
  }
}  
?>