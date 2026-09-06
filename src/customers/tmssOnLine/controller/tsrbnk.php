<?php
final class tsrbnkController extends tmssController2 {
  function initialize(){ $this->MODEL='tsrbnk'; $this->VIEW='tsrbnk'; $this->ID='bnkcod'; $this->mdl = $this->co_reg->load->model($this->MODEL); }
	function additionalFunctions( $lp_act ){
  	switch( $lp_act ){
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['bnktxt'])?'[~fltrow~]bnktxt'.chr(9).''.chr(9).$this->prm['bnktxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>