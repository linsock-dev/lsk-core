<?php
final class hhrevlskiController extends tmssController2 {

  function initialize(){$this->MODEL='hhrevlski';$this->VIEW='hhrevlski';$this->ID='hhrevlskicod';$this->preventCopy = array('hhrevlskicodext');}
  
   function additionalFunctions($lp_act){
      switch ( $lp_act ) {
			
			// LIST by TEXT
      case '#18':
				$lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => (isset($this->prm['hhrevlskitxt'])?'[~fltrow~]s.hhrevlskitxt'.chr(9).''.chr(9).$this->prm['hhrevlskitxt'].chr(9).chr(9).chr(9):'').
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);		
				$lo_data = $this->mdl->getList($lv_prm, null, null, false);
				return $this->co_reg->document->getJson( $lo_data );
        break;
    }
  }
}
?>