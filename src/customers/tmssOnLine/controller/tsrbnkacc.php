<?php
final class tsrbnkaccController extends tmssController2 {
  function initialize(){ $this->MODEL='tsrbnkacc'; $this->VIEW='tsrbnkacc'; $this->ID='bnkacccod'; $this->mdl = $this->co_reg->load->model($this->MODEL);}
  function additionalFunctions( $lp_act ){
    switch( $lp_act ){
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['bnkacctxt']) 	 ?'[~fltrow~]a.bnkacctxt'.chr(9).''.chr(9).$this->prm['bnkacctxt'].chr(9).chr(9).chr(9):'').
																			 (isset($this->prm['bnkaccclscod'])?'[~fltrow~]a.bnkaccclscod'.chr(9).'='.chr(9).chr(9).$this->prm['bnkaccclscod'].chr(9).chr(9):'').
																			'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_data = $this->mdl->getList($lv_prm); 
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>