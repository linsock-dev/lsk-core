<?php
final class stkwmsareController extends tmssController2 {
  function initialize(){
    $this->CONTROLLER = 'stkwmsare';
    $this->MODEL = 'stkwmsare';							
    $this->VIEW  = 'stkwmsare';							
    $this->ID = 'wmsarecod';								
  }
     
  function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['wmsaretxt'])?'[~fltrow~]wmsaretxt'.chr(9).''.chr(9).$this->prm['wmsaretxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
    }
  }
}  
?>