<?php
final class logtrazonController extends tmssController2 {
  function initialize(){ $this->MODEL='logtrazon'; $this->VIEW='logtrazon'; $this->ID='trazoncod'; $this->mdl = $this->co_reg->load->model($this->MODEL); }
  function additionalFunctions($lp_act){
    switch( $lp_act ){
			// LIST by TEXT
      case '#18': 
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['trazontxt'])?'[~fltrow~]z.trazontxt'.chr(9).''.chr(9).$this->prm['trazontxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]z.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rs = $this->mdl->getList($lv_prm,null,null,false);
				return $this->co_reg->document->getJson( $lo_rs );
        break;
    }
  }
}
?>