<?php
final class hhrtmerngController extends tmssController2 {
  
	function initialize(){$this->MODEL='hhrtmerng';$this->VIEW='hhrtmerng';$this->ID='hhrtmerngcod';$this->preventCopy = array('hhrtmerngcodext');}
  
   function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['hhrtmerngtxt'])?'[~fltrow~]tr.hhrtmerngtxt'.chr(9).''.chr(9).$this->prm['hhrtmerngtxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]tr.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( array('data'=>$lo_data) );
        break;
    }
  }
}
?>