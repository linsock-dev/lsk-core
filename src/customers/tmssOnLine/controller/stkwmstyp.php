<?php
final class stkwmstypController extends tmssController2 {
	function initialize(){
    $this->CONTROLLER = 'stkwmstyp';
    $this->MODEL = 'stkwmstyp';							
    $this->VIEW  = 'stkwmstyp';							
    $this->ID = 'wmstypcod';								
  }
     
	function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
        $this->mdl = $this->co_reg->load->model($this->MODEL);
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['wmstyptxt'])?'[~fltrow~]wmstyptxt'.chr(9).''.chr(9).$this->co_reg->db->sqldata($this->prm['wmstyptxt']).chr(9).chr(9).chr(9):'').
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
        
    }
  }
}  
?>