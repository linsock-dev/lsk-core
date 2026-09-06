<?php
final class tsrcshController extends tmssController2 {
  function initialize(){ $this->MODEL='tsrcsh'; $this->VIEW='tsrcsh'; $this->ID='cshcod'; $this->mdl = $this->co_reg->load->model($this->MODEL);}
  function additionalFunctions( $lp_act ){
    switch( $lp_act ){
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['cshtxt'])?'[~fltrow~]cshtxt'.chr(9).''.chr(9).$this->prm['cshtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}  
?>